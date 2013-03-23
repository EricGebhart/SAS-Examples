
proc template;
    define tagset tagsets.example15;
        parent=tagsets.config_debug;
        
        default_event = "decide";
        indent = 2;


        define event initialize;
            trigger set_defaults;
            trigger set_valid_options;
            trigger set_options;
        end;

        define event set_defaults;
            set $structure_events "proc proc_branch branch leaf output";
            set $table_events "table table_head table_body table_foot row header data";
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

        /*-----------------------------------------------------------eric-*/
        /*-- Each new option should be added in three places before     --*/
        /*-- using it in the underlying code.                           --*/
        /*-- 1. Add the option to the $valid_options array              --*/
        /*-- 2. Add the option to the set_options event to set the      --*/
        /*--        appropriate variable, if necessary.                 --*/
        /*-- 3. Add the option to the quick reference event's help text.--*/
        /*--------------------------------------------------------11Mar07-*/

        define event set_valid_options;
            set $valid_options['SHORT_EVENTS'] 'List of events to display short descriptions.';
            set $valid_options['LONG_EVENTS'] 'List of events to display long descriptions.';
            set $valid_options['DOC'] 'Documentation for this tagset';
            trigger config_debug_valid_options;
        end;


        define event options_setup;
            /*--------------------------------------------------------------*/
            /* options should exist, but avoid bad resolution if it doesn't */
            /* This only happens in SAS 9.1.2 and earlier                   */
            /* 9.1 and 9.1.2 have a known bug.  If an array/dictionary is   */
            /* Accessed in a set, and the array is not defined, the value   */
            /* resolves to the subscript.  Not good, but avoidable.         */
            /* Normally just putting '/if $options' on the set will fix it  */
            /* but this logic becomes needlessly complex.  This is cleaner  */
            /*--------------------------------------------------------------*/
            set $options['test'] "test" /if ^$options;

            trigger set_config_debug_options;

            unset $short_events;
            do /if $options['SHORT_EVENTS'];
                do /if ^cmp($options['SHORT_EVENTS'], 'none');
                    set $event_list $options['SHORT_EVENTS'];
                    trigger set_short_events;
                else /if ^cmp($options['SHORT_EVENTS'], 'default');
                    set $event_list $table_events;
                    trigger set_short_events;
                done;
            else;
                set $event_list $table_events;
                trigger set_short_events;
            done;

            unset $long_events;
            do /if $options['LONG_EVENTS'];
                do /if ^cmp($options['LONG_EVENTS'], 'none');
                    set $event_list $options['LONG_EVENTS'];
                    trigger set_long_events;
                else /if ^cmp($options['LONG_EVENTS'], 'default');
                    set $event_list $structure_events;
                    trigger set_long_events;
                done;
            else;
                set $event_list $structure_events;
                trigger set_long_events;
            done;

            do /if $debug_level = 1;
                putlog "Short Events";
                putlog "=====================";
                iterate $short_events;
                do /while _name_;
                    putlog _name_;
                    next $short_events;
                done;
                putlog "=====================";
                putlog "Long Events";
                putlog "=====================";
                iterate $long_events;
                do /while _name_;
                    putlog _name_;
                    next $long_events;
                done;
                putlog "=====================";
            done;
                    

        end;

        define event set_short_events;
            eval $count 1;
            do /if index($event_list, ' ');
                set $event scan($event_list, 1, ' ');
                do /while !cmp($event, ' ');
                    set $event lowcase($event);
                    set $short_events[$event] 'True';
                    
                    eval $count $count + 1;
                    set $event scan($event_list, $count, ' ');
                done;

            else /if $event;
                eval $short_events[$event_list] 'True';
            done;
        end;
    
        define event set_long_events;
            eval $count 1;
            do /if index($event_list, ' ');
                set $event scan($event_list, 1, ' ');
                do /while !cmp($event, ' ');
                    set $event lowcase($event);
                    set $long_events[$event] 'True';
                    
                    eval $count $count + 1;
                    set $event scan($event_list, $count, ' ');
                done;

            else /if $event;
                eval $long_events[$event_list] 'True';
            done;
        end;

        define event documentation;
            break /if ^$options;
            trigger quick_reference /if cmp($options['DOC'], 'quick');
            trigger help /if cmp($options['DOC'], 'help');
            trigger settings /if cmp($options['DOC'], 'settings');
            trigger list_options /if cmp($options['DOC'], 'options');
        end;

        define event list_options;
            iterate $valid_options;
            putlog "==============================================================================";
            putlog " ";
            putlog "Name     : Current value  :  Description";
            do /while _name_;
                putlog _name_ " : " $options[_name_]  " : " _value_;
                next $valid_options;
            done;
            putlog " ";
        end;

        define event help;
            putlog "==============================================================================";
            putlog "The " tagset  " Help Text.";
            putlog " ";
            putlog "This Tagset/Destination creates psuedo XML output that shows the events ";
            putlog "As they occur in ODS.  The events it prints are defined in two lists,  ";
            putlog "Short_events and Long_events.  Short events prints fewer attributes, while";
            putlog "events listed in long events print more attributes.  Each list can be";
            putlog "changed through options.";
            putlog " ";
            putlog "See Also:";
            putlog "http://support.sas.com/rnd/base/topics/odsmarkup/";
            putlog " ";
            trigger list_options;
            trigger quick_reference;
        end;


        define event quick_reference;
            putlog "==============================================================================";
            putlog " ";
            putlog "These are the options supported by this tagset.";
            putlog " ";
            putlog "Sample usage:";
            putlog " ";
            putlog "ods " tagset " file='test.xml' data='test.ini' options(doc='Help'); ";
            putlog " ";
            putlog "ods " tagset " options(doc='Quick'); ";
            putlog " ";
            putlog "ods " tagset " options(Short_Events='row data header' ";
            putlog "                       Long_Events='proc branch output image'); ";
            putlog "                       Debug_level='1'); ";
            putlog " ";
            putlog "Doc:  No default value.";
            putlog "     Help:     Displays introductory text and options.";
            putlog "     Quick:    Displays available options.";
            putlog "     Settings: Displays config/debug settings.";
            putlog "     options:  Displays list of options, their current value, and";
            putlog "               a short description";
            putlog " ";
            putlog "Short Events:   Default Value '" $table_events "'";
            putlog "     Events which should be displayed with a small number of attributes.";
            putlog "     This is a space delimited list of event names to print";
            putlog "     as they occur.  If 'none' is given no short descriptions will";
            putlog "     be printed.  A value of 'default' will return the list to it's default.";
            putlog " ";
            putlog "Long Events:   Default Value '" $structure_events "'";
            putlog "     Events which should be displayed with a larger number of attributes.";
            putlog "     This is a space delimited list of event names to print";
            putlog "     as they occur.  If 'none' is given no long descriptions will";
            putlog "     be printed.  A value of 'default' will return the list to it's default.";
            putlog " ";

            trigger config_debug_help;

            putlog "Valid Debug Levels: ";
            putlog "     1 :  Prints all event names with Match or No Match.";
            putlog " ";
            putlog "==============================================================================";
        end;

        define event decide;
            start:
                do /if $debug_level = 1;
                    do /if $short_events[$event_name];
                        putlog "Match:" event_name ; 
                    else /if $long_events[$event_name];
                        putlog "Match:" event_name ; 
                    else;
                        putlog "No Match:" event_name ; 
                    done;
                done;
                    
                set $event_name lowcase(event_name);
                trigger basic /breakif $short_events[$event_name];
                trigger basic_plus /breakif $long_events[$event_name];
            finish:
                set $event_name lowcase(event_name);
                trigger basic /breakif $short_events[$event_name];
                trigger basic_plus /breakif $long_events[$event_name];
        end;

        define event basic_plus;
            start:
                put "[" upcase(event_name); 
                trigger put_all_vars;
                put "/" / if empty;
                put "]" nl;
                break / if empty;
                ndent;
            finish:
                break / if empty;
                xdent;
                put "[" upcase(event_name) "/]" nl; 
        end;

    
        define event put_all_vars;
           putvars event " " _name_ '="' _value_ '"';
           putvars style " " _name_ '="' _value_ '"';
           putvars mem   " " _name_ '="' _value_ '"';
        end;
       
       define event put_some_vars;
           putq " value=" value;
           putq " label=" label;
           putq " name="  name;
           putq " htmlclass=" htmlclass;
           putq " anchor=" anchor;
       end;
     
       define event basic;
           start:
               put "<" event_name; 
               trigger put_some_vars;
               put ">" nl;
               ndent;
           finish:
               xdent;
               put "</" event_name ">" nl; 
       end;

    end;

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
                eval $debug_level inputn($debug_level, 'BEST');
                putlog "DEBUG" ": " $debug_level;
            else;
                eval $debug_level 0;
            done;

            do /if $options['CONFIGURATION_NAME'];
                set $configuration_name $options['CONFIGURATION_NAME'];
            else;
                set $configuration_name "default";
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

        define event config_debug_valid_options;
            set $valid_options['DEBUG_LEVEL'] 'Numeric value to turn on various debug messages';
            set $valid_options['CONFIGURATION_FILE'] 'An ini file to read option settings from.' ;
            set $valid_options['CONFIGURATION_NAME'] 'A section name in an ini file that holds option settings';
        end;

        define event help;
            putlog "==============================================================================";
            putlog "This is help for the " $tagset_name "tagset.";
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
            putlog "==============================================================================";
        end;

        define event config_debug_help;
            putlog " ";
            putlog "Configuration_Name: ";
            putlog "     Description:  Name of the configuration to read or write";
            putlog "                   in the .ini file.";
            putlog " ";
            putlog "     Possible Values: Any reasonable string.";
            putlog "     Default value:   default";
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
            putlog "     Default value:   ";
            putlog "     Current value: " $configuration_file;
            putlog " ";
            putlog "Debug_Level: ";
            putlog "     Description:  Determine what level of debugging information should";
            putlog "                   be printed to the log.  Higher numbers cause more";
            putlog "                   information to be printed.";
            putlog " ";
            putlog "     Possible Values: Any positive or negative number";
            putlog "     Default value:   ";
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
    
    
 
