
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


    define tagset tagsets.supermap;
        parent = tagsets.config_debug;    

        default_event = "decide";

        indent = 2;

        define event set_options;

            /* set up some defaults */
            set $structure_events "doc proc proc_branch branch leaf output";
            set $table_events "table table_head table_body table_foot";
            set $title_events "system_title system_footer proc_title byline";

            set $variable_list "value label name htmlclass anchor url"; /* some */
            set $variable_ex_list "value label name htmlclass anchor url"; /* some */
            set $configuration_name "default";
            set $variable_family_list "event style";

            trigger set_config_debug_options;
            
            do /if $options['BASIC_VERBOSITY'];
                set $basic_event_verbosity $options['BASIC_VERBOSITY'];
            else;
                set $basic_event_verbosity "some"; /* None Some or All */
            done;

            set $variable_list "value label name"  /if cmp($basic_event_verbosity, 'few');
            
            do /if $options['EXTRA_VERBOSITY'];
                set $extra_event_verbosity $options['EXTRA_VERBOSITY'];
            else;
                set $extra_event_verbosity "some"; /* None Some or All */
            done;
        
            set $variable_ex_list "value label name"  /if cmp($extra_event_verbosity, 'few');
            
            do /if $options['VARIABLES'];
                set $variable_list $options['VARIABLES'];
                set $extra_event_verbosity "Some"; /* None Some or All */
            done;

            do /if $options['EXTRA_VARIABLES'];
                set $variable_list $options['EXTRA_VARIABLES'];
                set $extra_event_verbosity "Some"; /* None Some or All */
            done;

            do /if $options['BASIC_EVENTS'];
                set $basic_events $options['BASIC_EVENTS'];
            else;
                set $basic_events $table_events $structure_events;
            done;
                
            do /if $options['EXTRA_EVENTS'];
                set $extra_events $options['EXTRA_EVENTS'];
            else;
                set $extra_events $title_events;
            done;
                
            do /if $options['VALUE_MATCH'];
                set $value_match $options['VALUE_MATCH'];
                eval $value_re prxparse($value_match);
            else;
                unset $value_match;
            done;
                
            do /if $options['LABEL_MATCH'];
                set $label_match $options['LABEL_MATCH'];
                eval $label_re prxparse($label_match);
            else;
                unset $label_match;
            done;

            do /if $options['MATCH_ANY'];
                set $match_any $options['MATCH_ANY'];
                eval $match_any_re prxparse($match_any);
            else;
                unset $match_any;
            done;

            do /if $options['MATCH_ANY_VARIABLE'];
                set $match_any_var $options['MATCH_ANY_VARIABLE'];
                eval $match_any_var_re prxparse($match_any_var);
            else;
                unset $match_any;
            done;
            
            do /if $options['MARKUP_TAGS'];
                set $markup_tags $options['MARKUP_TAGS'];
            else;
                set $markup_tags "|<|>|</|>|[|]|[/|]|/|";
            done;

            do /if $options['VARIABLE_FAMILIES'];
                set $variable_family_list $options['VARIABLE_FAMILIES'];
            else;
                set $variable_family_list "event style";
            done;

            trigger set_markup_tags;

            trigger write_ini;
            
        end;

        define event set_markup_tags;
            set $delim substr($markup_tags, 1,1);
            set $basic_start_beg scan($markup_tags, 1, $delim);
            set $basic_start_end scan($markup_tags, 2, $delim);
            set $basic_finish_beg scan($markup_tags, 3, $delim);
            set $basic_finish_end scan($markup_tags, 4, $delim);
            set $extended_start_beg scan($markup_tags, 5, $delim);
            set $extended_start_end scan($markup_tags, 6, $delim);
            set $extended_finish_beg scan($markup_tags, 7, $delim);
            set $extended_finish_end scan($markup_tags, 8, $delim);
            set $empty_tag scan($markup_tags, 9, $delim);
            do /if $debug_level >= 1;
                putlog "Basic Start Tag:     " $basic_start_beg "TAG" $basic_start_end;
                putlog "Basic Finish Tag:    " $basic_finish_beg "TAG" $basic_finish_end;
                putlog "Basic Empty Tag:     " $basic_start_beg "TAG" $empty_tag $basic_start_end;

                putlog "Extended Start Tag:  " $extended_start_beg "TAG" $extended_start_end;
                putlog "Extended Finish Tag: " $extended_finish_beg "TAG" $extended_finish_end;
                putlog "Extended Empty Tag:  " $extended_start_beg "TAG" $empty_tag $extended_start_end;
            done;
        end;                              
        
        define event settings;
            putlog "  Basic_Events: " $basic_events;
            putlog "  Extra_Events: " $extra_events;
            putlog "  Basic_Verbosity: " $basic_event_verbosity;
            putlog "  Extra_Verbosity: " $extra_event_verbosity;
            putlog "  Value_Match: "  $value_match;
            putlog "  Label_Match: "  $label_match;
            putlog "  Configuration_Name: "  $configuration_name;
            putlog "  Configuration_File: "  $configuration_file;
            putlog "  Debug Level: "  $debug_level;
            putlog "  Markup_Tags: "  $markup_tags;
        end;
    
        define event help;
            putlog "=============================================================================="; 
            putlog "This is help for the supermap tagset."; 
            putlog " "; 
            putlog "Purpose: This tagset is for helping with the exploration of Tagset events and";
            putlog "         their values"; 
            putlog " ";
            putlog 'Example Usage:';
            putlog " ";
            putlog '        ods tagsets.supermap file="test.xml" data="test.ini"';
            putlog '            options(extra_events="system_title system_footer help="doc");';
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
            putlog "        Basic_events: ";
            putlog "             Description:  Determines which events will be shown in a basic";
            putlog "                           way with standard XML tag format and a limited";
            putlog "                           number of attributes.";
            putlog "                           Names must be in lower case for them to match.";
            putlog " ";
            putlog "             Possible Values: Any list of event names or All";
            putlog "             Default value: " $table_events " " $structure_events;
            putlog "             Current value: " $basic_events;
            putlog " ";
            putlog "        Extra_events: ";
            putlog "             Description:  Determines which events will be shown in addition";
            putlog "                           to the basic events.  These events are formatted with";
            putlog "                           Names must be in lower case for them to match.";
            putlog "                           []'s and the names are in uppercase. By default the";
            putlog "                           attributes shown will be the same as the basic";
            putlog "                           events.  This can be changed with the verbosity";
            putlog "                           options.";
            putlog " ";
            putlog "             Possible Values: Any list of event names or All";
            putlog "             Default value: " $title_events;
            putlog "             Current value: " $extra_events;
            putlog " ";
            putlog "        Basic_Verbosity: ";
            putlog "             Description:  Determines which attributes will be shown for the";
            putlog "                           basic events.  This is for convenience beyond the";
            putlog "                           Variables option";
            putlog " ";
            putlog "             Possible Values: None, Some, Few, or All.";
            putlog "             Default value:   Some"; 
            putlog "             Current value: " $basic_event_verbosity;
            putlog " ";
            putlog "        Variables: ";
            putlog "             Description:  Determines which attributes will be shown for the";
            putlog "                           basic events.";
            putlog " ";
            putlog "             Possible Values: A space delimited list of variable names.";
            putlog "             Default value: "; 
            putlog "             Current value: " $variable_list;
            putlog " ";
            putlog "        Extra_Verbosity: ";
            putlog "             Description:  Determines which attributes will be shown for the";
            putlog "                           extra events.  This is for convience beyond the";
            putlog "                           Extra Variables option.";
            putlog " ";
            putlog "             Possible Values: None, Some, Few, or All.";
            putlog "             Default value:   Some"; 
            putlog "             Current value: " $extra_event_verbosity;
            putlog " ";
            putlog "        Extra_Variables: ";
            putlog "             Description:  Determines which attributes will be shown for the";
            putlog "                           extra events.";
            putlog " ";
            putlog "             Possible Values: A space delimited list of variable names.";
            putlog "             Default value: "; 
            putlog "             Current value: " $variable_list;
            putlog " ";
            putlog "        Variable_families: ";
            putlog "             Description:  Determines which attribute families will be shown.";
            putlog " ";
            putlog "             Possible Values: A space delimited list of family names.";
            putlog "                              The family names are; event style mem dynamic";
            putlog "             Default value: event style"; 
            putlog "             Current value: " $variable_family_list;
            putlog " ";
            putlog "        Value_Match: ";
            putlog "             Description:  Uses the contents of the value event variable to";
            putlog "                           determine which events to display.";
            putlog " ";
            putlog "             Possible Values: A Perl regular expression.";
            putlog "             Default value:   "; 
            putlog "             Current value: " $value_match;
            putlog " ";
            putlog "        Label_Match: ";
            putlog "             Description:  Uses the contents of the label event variable to";
            putlog "                           determine which events to display.";
            putlog " ";
            putlog "             Possible Values: A Perl regular expression.";
            putlog "             Default value:   "; 
            putlog "             Current value: " $label_match;
            putlog " ";
            putlog "        Match_Any: ";
            putlog "             Description:  Checks every variable for a match to";
            putlog "                           determine which events to display.";
            putlog " ";
            putlog "             Possible Values: A Perl regular expression.";
            putlog "             Default value:   "; 
            putlog "             Current value: " $match_any;
            putlog " ";
            putlog "        Match_Any_variable: ";
            putlog "             Description:  Checks every variable for a match to";
            putlog "                           determine which variables to display.";
            putlog "                           Any variable that has a value match for";
            putlog "                           the regular expression will be printed in";
            putlog "                           addition to the variables already specified.";
            putlog " ";
            putlog "             Possible Values: A Perl regular expression.";
            putlog "             Default value:   "; 
            putlog "             Current value: " $match_any_var;
            putlog " ";

            trigger config_debug_help;
            
            putlog "        Markup_tags: ";
            putlog "             Description:  Set the markup tags for the basic and extended";
            putlog "                           events.  The list must start with the character";
            putlog "                           chosen as the delimiter.  The order of the strings";
            putlog "                           is this.  Basic Start; beginning and ending. Basic";
            putlog "                           finish; beginning and ending. Extended Start; beginning";
            putlog "                           and ending. Extended Finish; beginning and ending. The";
            putlog "                           last string is for XML empty tags, the default is '/'";
            putlog " ";
            putlog "                           Setting the debug_level to 1 or higher will cause a ";
            putlog "                           sample of the resulting Tags to be printed to the log.";
            putlog " ";
            putlog "             Possible Values: A set of 9 strings with common delimiter";
            putlog "             Default value:   |<|>|</|>|[|]|[/|]|/|";
            putlog "             Current value: " $markup_tags;
            putlog " ";
            putlog "=============================================================================="; 
        end;
    
        define event decide;
            start:
                unset $match;
            
                set $match 'basic' /if cmp($basic_events, 'all');
                set $match 'basic' /if contains($basic_events, event_name);

                set $match 'basic_plus' /if cmp($extra_events, 'all');
                set $match 'basic_plus' /if contains($extra_events, event_name);

                trigger attribute_matching;
                
                /* push the match onto the stack */
                set $event_stack[] $match;
                
                trigger basic /breakif cmp($match, 'basic');
                trigger basic_plus /breakif cmp($match, 'basic_plus');
                    
            finish:
 
                /* pop the match off the stack */
                set $match $event_stack[-1];
                unset $event_stack[-1];

                trigger basic /breakif cmp($match, 'basic');
                trigger basic_plus /breakif cmp($match, 'basic_plus');
        end;


        define event debug_putall;
             putlog _name_ ": " _value_ ;
        end;
                    

        define event attribute_matching;
            do /if $match;
                /* DEBUG */
                do /if $debug_level >= 4;
                    putlog "BEFORE ATTRIBUTE MATCHING:  MEM Variables";
                    dovars mem debug_putall;
                done;
                    

                do /if any($value_match, $label_match);
                    unset $regex_match;

                    do /if $value_match;

                        /* DEBUG */
                        do /if $debug_level >= 3;
                            putlog "MATCHING on VALUE: ";
                            eval $foo prxmatch($value_re, value); 
                            putlog "MATCH:" $foo  " Value:" value; 
                        done;
                            
                        do /if prxmatch($value_re, value);
                            set $regex_match "True";
                        done;
                    done;

                    do /if $label_match;
                        /* DEBUG */
                        do /if $debug_level >= 3;
                            putlog "MATCHING on VALUE: ";
                            eval $foo prxmatch($label_re, label); 
                            putlog "MATCH:" $foo  " Value:" label; 
                        done;

                        do /if prxmatch($label_re, label);
                            set $regex_match "True";
                        done;
                    done;

                    /* DEBUG */
                    do /if $debug_level >= 4;
                        putlog "AFTER ATTRIBUTE MATCHING:  MEM Variables";
                        dovars mem debug_putall;
                    done;

                    set $match "False" /if ^$regex_match;

                done;
            else /if ($match_any);

                dovars event match_any;
                dovars style match_any;
                dovars dynamic match_any;
            
                set $match "False" /if ^$regex_match;

            else;
                set $match "False" /if ^$regex_match;
            done;
        end;

        define event match_any;
            eval $foo prxmatch($match_any_re, _value_); 
            set $regex_match "True" /if ($foo);
        end;

        define event basic;
            start:
                put $basic_start_beg event_name; 
                do /if cmp($basic_event_verbosity, "all");
                    trigger put_all_vars;
                else;
                    set $filter_variable_list $variable_list;
                    trigger put_some_vars;
                done;
                    
                put $empty_tag / if empty;
                put $basic_start_end nl;
                break / if empty;
                ndent;
            finish:
                break / if empty;
                xdent;
                put $basic_finish_beg event_name $basic_finish_end nl; 
        end;

        define event basic_plus;
            start:
                put $extended_start_beg upcase(event_name); 
                
                do /if cmp($extra_event_verbosity, "all");
                    trigger put_all_vars;
                else;
                    set $filter_variable_list $variable_ex_list;
                    trigger put_some_ex_vars;
                done;
                
                put $empty_tag / if empty;
                put $extended_start_end nl;
                break / if empty;
                ndent;
            finish:
                break / if empty;
                xdent;
                put $extended_finish_beg upcase(event_name) $extended_finish_end nl; 
        end;

    
        define event put_all_vars;
            do /if contains($variable_family_list, 'event'); 
                putvars event " " _name_ '="' _value_ '"';
            done;
            do /if contains($variable_family_list, 'style'); 
                putvars style " " _name_ '="' _value_ '"';
            done;
            do /if contains($variable_family_list, 'mem'); 
                putvars mem   " " _name_ '="' _value_ '"';
            done;
            do /if contains($variable_family_list, 'dyn'); 
                putvars dynamic   " " _name_ '="' _value_ '"';
            done;
        end;


        define event put_some_vars;
            do /if contains($variable_family_list, 'event'); 
                do /if $debug_level >= 3;
                    putlog "Event Family !!!!" 
                    putlog "Filter Variable List: " $filter_variable_list;
                done;
                dovars event filter_vars;
            done;
            do /if contains($variable_family_list, 'style'); 
                do /if $debug_level >= 2;
                    putlog "Style Family !!!!" 
                    putlog "Filter Variable List: " $filter_variable_list;
                done;
                dovars style filter_vars;
            done;
            do /if contains($variable_family_list, 'mem'); 
                do /if $debug_level >= 3;
                    putlog "Mem Family !!!!" 
                    putlog "Filter Variable List: " $filter_variable_list;
                done;
                dovars mem   filter_vars;
            done;
            do /if contains($variable_family_list, 'dyn'); 
                do /if $debug_level >= 3;
                    putlog "Dynamic Family !!!!" 
                    putlog "Filter Variable List: " $filter_variable_list;
                done;
                dovars dynamic   filter_vars;
            done;
        end;
            

        define event filter_vars;
            set $name lowcase(_name_); 
            put " " $name '="' _value_ '"'/breakif contains($filter_variable_list, $name); 
            break /if ^$match_any_var;
            do /if $foo prxmatch($match_any_var_re, _value_); 
                put " " $name '="' _value_ '"';
            done;
        end;
        
    end;
run;

options obs=2;

ods tagsets.supermap file="map.xml" data="map.ini";

proc print data=sashelp.class;
run;

ods _all_ close;

    
ods tagsets.supermap file="map_b.xml" data="map_b.ini" 
                     options(basic_events="data" 
                             Extra_events="table" );

ods tagsets.supermap options(doc="settings");

proc print data=sashelp.class;
run;

ods _all_ close;

ods tagsets.supermap file="map_c.xml" data="map_c.ini"
     options(basic_events="data" 
             Extra_events="table" 
             basic_verbosity="few");

proc print data=sashelp.class;
run;

ods _all_ close;

ods tagsets.supermap file="map_d.xml" data="map_d.ini" 
     options(basic_events="data" 
             Extra_events="table" 
             basic_verbosity="few" 
             value_match="/Alfred/" 
             doc="settings");

proc print data=sashelp.class;
run;

ods _all_ close;

ods tagsets.supermap file="map_e.xml" options(configuration_file='map_d.ini' debug_level='2');

proc print data=sashelp.class;
run;


ods _all_ close;
    
 
