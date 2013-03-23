
proc template;
    define tagset tagsets.template;
    
        default_event = basic;
        
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
            trigger set_options;
            trigger documentation;
        end;

        define event options_set;
            trigger set_options;
            trigger documentation;
        end;
        
        define event set_options;
            trigger set_config_debug_options;
        end;

        define event set_config_debug_options;

            do /if $options['DEBUG_LEVEL'];
                set $debug_level $options['DEBUG_LEVEL'];
                eval $debug_level inputn($debug_level, '1.');
                putlog "DEBUG" ": " $debug_level;
            else;
                eval $debug_level 0;
            done;

            do /if $options['CONFIGURATION_NAME'];
                set $configuration_name $options['CONFIGURATION_NAME'];
            done;

            do /if $options['CONFIGURATION_FILE'];
                set $configuration_file $options['CONFIGURATION_FILE'];
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
    
        define event help;
            putlog "=============================================================================="; 
            putlog "This is help for the " $tagset_namep "tagset."; 
            putlog " "; 
            putlog "Purpose: This tagset is ...";
            putlog " ";
            putlog 'Example Usage:';
            putlog " ";
            putlog '        ods tagsets.' $tagset_name ' file="test.xml" ';
            putlog '            options(help="doc");';
            putlog " ";
            putlog "Options:";
            putlog " ";
            putlog "        Doc: ";
            putlog "             Description:  Prints this help text if the value is set to 'help'.";
            putlog "                           Prints the current option settings if set to 'settings.'";
            putlog " ";
            putlog "             Possible Values: help, settings";
            putlog "             Default value: " $table_events " " $structure_events;
            putlog "             Current value: " $basic_events;
            putlog " ";
            trigger config_debug_help;
        end;
        
        define event config_debug_help;
            putlog "    Configuration_Name: ";
            putlog "         Description:  Name of the configuration to read or write";
            putlog "                       in the .ini file.";
            putlog " ";
            putlog "         Possible Values: Any reasonable string.";
            putlog "         Default value:   default"; 
            putlog "         Current value: " $configuration_name;
            putlog " ";
            putlog "    Configuration_File: ";
            putlog "         Description:  Name of the configuration file to read.";
            putlog "                       This is a .ini formatted file as written";
            putlog "                       to the data file if one is given";
            putlog "                       If given, the options for the configuration";
            putlog "                       will be loaded on top of any options given on the";
            putlog "                       ods statement.  A file may contain more than one";
            putlog "                       configuration section.  Only the first section that";
            putlog "                       matches the configuration name will be loaded.";
            putlog " ";
            putlog "         Possible Values: A valid file name.";
            putlog "         Default value:   "; 
            putlog "         Current value: " $configuration_file;
            putlog " ";
            putlog "    Debug_Level: ";
            putlog "         Description:  Determine what level of debugging information should";
            putlog "                       be printed to the log.  Higher numbers cause more";
            putlog "                       information to be printed.";
            putlog " ";
            putlog "         Possible Values: 0,1,2,3,4,5";
            putlog "         Default value:   "; 
            putlog "         Current value: " $debug_level;
            putlog " ";
            putlog "=============================================================================="; 
        end;
    
            
        define event write_ini;
            file=data;
 
            /* It is a bug that this needs to be done */
            break /if ^cmp(dest_file, 'data');

            /*---------------------------------------------------------------eric-*/
            /*-- Only write a configuration once.  If the name changes          --*/
            /*-- it's ok to write it again. It doesn't cover all possiblities   --*/
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
            
            put nl nl;
            
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
                    putlog "Match Section Name";
                    set $reading_section "True";
                else;
                    putlog "No Match Section Name";
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

    
 
