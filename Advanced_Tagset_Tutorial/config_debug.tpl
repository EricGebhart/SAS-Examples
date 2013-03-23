
proc template;

    define tagset tagsets.config_debug;

        default_event = 'basic';

        indent = 2;

        define event basic;
            start:
                put '<' event_name;

                put ' value=' value;
                put ' name=' name;
                put ' label=' label;

                put '/' / if empty;
                put '>' nl;
                break / if empty;
                ndent;
            finish:
                break / if empty;
                xdent;
                put '</' event_name '>' nl;
        end;

        define event initialize;
            trigger set_options_defaults;
            trigger set_valid_options;
            trigger set_options;
        end;

        /*--------------------------------------------------------------eric-*/
        /*-- This one happens when options(...) are given on the ods markup--*/
        /*-- statement.                                                    --*/
        /*-----------------------------------------------------------14Jun04-*/
        define event options_set;
            trigger set_options;
        end;

        define event set_options;
            trigger check_valid_options;
            trigger options_setup;
            trigger documentation;
        end;

        define event check_valid_options;
            iterate $options;
            do /while _name_;
                do /if ^$valid_options[_name_];
                    putlog "Unrecognized option: " _name_;
                done;
                next $options;
            done;
        end;
        
        
        /*-------------------------------------------------------eric-*/
        /*-- These get over ridden in the child class....           --*/
        /*----------------------------------------------------16Mar07-*/
        define event options_setup;
            trigger config_debug_options_setup;
        end;
        define event set_options_defaults;
            trigger config_debug_set_options_defaults;
        end;
        define event set_valid_options;
            trigger config_debug_set_valid_options;
        end;

        define event config_debug_options_setup;
            /* Debug Level */
            unset $option;
            set $option $options['DEBUG_LEVEL'];
            
            eval $debug_level inputn($option, 'BEST');
            do /if missing($debug_level);
                set $option $defaults['DEBUG_LEVEL'];
                eval $debug_level inputn($option, 'BEST');
            done;
            putlog "DEBUG" ": " $debug_level /if $debug_level ^= 0;
            

            /* Configuration Name */
            unset $configuration_name;
            set $configuration_name $options['CONFIGURATION_NAME'];
            set $configuration_name $defaults['CONFIGURATION_NAME'] /if ^$configuration_name;
            

            /* Configuration File */
            unset $configuration_file;
            set $configuration_file $options['CONFIGURATION_FILE'];
            set $configuration_file $defaults['CONFIGURATION_NAME'] /if ^$configuration_file;
            
            /*---------------------------------------------------eric-*/
            /*-- Possibly blank it out.  one way or the other.      --*/
            /*------------------------------------------------16Mar07-*/
            unset $configuration_file /if cmp($configuration_file, 'none');
            set $configuration_file strip($configuration_file);
            
            do /if $configuration_file;
                trigger read_config_ini;
            else;
                unset $configuration_file;
            done;

            trigger write_ini;

        end;

        define event documentation;
            break /if ^$options;
            trigger help /if cmp($options['DOC'], 'help');
            trigger settings /if cmp($options['DOC'], 'settings');
            trigger quick /if cmp($options['DOC'], 'quick');
        end;

        define event settings;
            putlog "  Configuration_Name: "  $configuration_name;
            putlog "  Configuration_File: "  $configuration_file;
            putlog "  Debug Level: "  $debug_level;
        end;

        define event config_debug_set_valid_options;
            set $valid_options['DEBUG_LEVEL'] 'Numeric value to turn on various debug messages';
            set $valid_options['CONFIGURATION_FILE'] 'An ini file to read option settings from.' ;
            set $valid_options['CONFIGURATION_NAME'] 'A section name in an ini file that holds option settings';
        end;

        define event config_debug_set_options_defaults;
            set $defaults['DEBUG_LEVEL'] '0';
            set $defaults['CONFIGURATION_FILE'] 'none';
            set $defaults['CONFIGURATION_NAME'] 'default';
        end;

        define event config_debug_help;
            putlog " ";
            putlog "Configuration_Name: ";
            putlog "     Description:  Name of the configuration to read or write";
            putlog "                   in the .ini file.";
            putlog " ";
            putlog "     Possible Values: Any reasonable string.";
            putlog "     Default value:  " $defaults['CONFIGURATION_NAME'];
            putlog "     Current value: " $configuration_name;
            putlog " ";
            putlog "Configuration_File: ";
            putlog "     Description:  Name of the configuration file to read.";
            putlog "                   This is a .ini formatted file as written";
            putlog "                   to the data file if one is given";
            putlog "                   If given, the options for the configuration";
            putlog "                   will be loaded on top of any options given on the";
            putlog "                   ods statement.  A file may contain more than one";
            putlog "                   configuration section.  Only the first section that";
            putlog "                   matches the configuration name will be loaded.";
            putlog " ";
            putlog "     Possible Values: A valid file name.";
            putlog "     Default value: " $defaults['CONFIGURATION_FILE'];
            putlog "     Current value: " $configuration_file;
            putlog " ";
            putlog "Debug_Level: ";
            putlog "     Description:  Determine what level of debugging information should";
            putlog "                   be printed to the log. "; 
            putlog " ";
            putlog "     Possible Values: Any positive or negative number";
            putlog "     Default value: " $defaults['DEBUG_LEVEL'];
            putlog "     Current value: " $debug_level;
            putlog " ";
        end;


        define event write_ini;
            file=data;

            /* It is a bug that this needs to be done */
            break /if ^cmp(dest_file, 'data');

            /*---------------------------------------------------------------eric-*/
            /*-- Only write a configuration once.  If the name changes          --*/
            /*-- it's ok to write it again. It doesn't cover all possibilities  --*/
            /*-- but it should be good enough.                                  --*/
            /*------------------------------------------------------------11Feb05-*/
            break /if cmp($ini_written, $configuration_name);
            set $ini_written $configuration_name;

            put '[' $Configuration_name ']' nl;

            put "Tagset_name =" tagset  nl;

            iterate $options;

            do /while _name_;
                put _name_ ' = ' _value_ nl;
                next $options;
            done;
            
            put ' ' nl;
            put ' ' nl;

        end;

        define event read_config_ini;
            set $read_file $configuration_file;
            putlog "READING configuration_file" ":" $configuration_file;
            trigger readfile;

            do /if $debug_level >= 1;
                putlog "OPTIONS LOADED from " ":" $configuration_file " : " $configuration_name;
                iterate $options;
                do /while _name_;
                    putlog _name_ " : " _value_;
                    next $options;
                done;
            done;
        end;

        /*---------------------------------------------------------------eric-*/
        /*-- Look for a section that matches the configuration name.        --*/
        /*-- Once found, read the variable in and load them into            --*/
        /*-- the options array.                                             --*/
        /*--                                                                --*/
        /*-- If another section is encountered quit scanning                --*/
        /*-- for options.                                                   --*/
        /*------------------------------------------------------------11Feb05-*/
        define event process_data;

            break /if $done_reading_section;

            do /if $debug_level >= 2;
                do /if ^$done_reading_section;
                    putlog "LOOKING [" $configuration_name "]" " " $record ;
                done;
            done;


            /*-- If a record starts with a [ then it is the start of a new section.--*/
            /*------------------------------------------------------------11Feb05-*/
            set $record_start substr($record, 1,1);

            do /if cmp('[', $record_start);

                set $config_name_pattern "[" $configuration_name "]";
                do /if cmp($config_name_pattern, $record);
                    putlog "Reading configuration: " $configuration_name;
                    set $reading_section "True";
                else;
                    set $done_reading_section "True" /if $reading_section;
                    unset $reading_section;
                done;

            else /if $reading_section;

                do /if $debug_level >= 2;
                    putlog "LOADING [" $configuration_name "]" " " $record ;
                done;

                set $key scan($record, 1, '=');
                set $key_value scan($record, 2, '=');

                set $key strip($key);
                set $key_value strip($key_value);

                set $options[$key] $key_value;
            done;


        end;

        define event readfile;

            /*---------------------------------------------------eric-*/
            /*-- Set up the file and open it.                       --*/
            /*------------------------------------------------13Jun03-*/

            set $filrf "myfile";
            eval $rc filename($filrf, $read_file);

            do /if $debug_level >= 5;
                putlog "File Name" ":" $rc " : " $read_file;
            done;

            eval $fid fopen($filrf);

            do /if $debug_level >= 5;
                putlog "File ID" ":" $fid;
            done;


            /*---------------------------------------------------eric-*/
            /*-- datastep functions  will bind directly to the      --*/
            /*-- variable space as it exists.                       --*/
            /*--                                                    --*/
            /*-- Tagset variables are not like datastep             --*/
            /*-- variables but we can create a big one full         --*/
            /*-- of spaces and let the functions write to it.       --*/
            /*--                                                    --*/
            /*-- This creates a variable that is 200 spaces so      --*/
            /*-- that the function can write directly to the        --*/
            /*-- memory location held by the variable.              --*/
            /*-- in VI, 200i<space>                                 --*/
            /*------------------------------------------------27Jun03-*/
            set $file_record  "

                                                               ";

            /*---------------------------------------------------eric-*/
            /*-- Loop over the records in the file                  --*/
            /*------------------------------------------------13Jun03-*/
            do /if $fid > 0 ;

                do /while fread($fid) = 0;

                    set $rc fget($fid,$file_record ,200);

                    do /if $debug_level >= 5;
                        putlog 'Fget' ':' $rc 'Record' ':' $file_record;
                    done;

                    set $record trim($file_record);

                    trigger process_data;

                    /* trimn to get rid of the spaces at the end. */
                    /*put trimn($file_record ) nl;*/

                done;
            done;

           /*-----------------------------------------------------eric-*/
           /*-- close up the file.  set works fine for this.         --*/
           /*--------------------------------------------------13Jun03-*/

            set $rc close($fid);
            set $rc filename($filrf);

        end;

    end;
run;

options obs=2;

ods tagsets.example15 file="example15.xml" options(doc='help' debug_level='1');

proc print data=sashelp.class;
run;

ods _all_ close;

ods tagsets.example15 file="example15.xml" options(doc='options' test='junk');
ods _all_ close;
    
    
 
