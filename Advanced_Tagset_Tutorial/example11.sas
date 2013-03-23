
proc template;
    define tagset tagsets.example11;
    
        default_event = "decide";

        indent = 2;

        define event initialize;
            trigger set_options;
            trigger documentation;
        end;

        define event options_set;
            /* DEBUG */
            /*
            putlog "Options_Set";
        
            iterate $options;
            do /while _name_;
                putlog _name_ ":" _value_;
                next $options;
            done;
            */
            trigger set_options;
            trigger documentation;
        end;
        
        define event set_options;

            /* DEBUG */
            /*
            iterate $options;
            do /while _name_;
                putlog _name_ ":" _value_;
                next $options;
            done;
            */

            /* set up some defaults */
            set $structure_events "doc proc proc_branch branch leaf output";
            set $table_events "table table_head table_body table_foot";
            set $title_events "system_title system_footer proc_title byline";

            /* DEBUG */
            /* putlog "OPTION" $options['BASIC_VERBOSITY'];*/
            do /if $options['BASIC_VERBOSITY'];
                /* DEBUG */
                /* putlog "OPTION" $options['BASIC_VERBOSITY'];*/
                set $basic_event_verbosity $options['BASIC_VERBOSITY'];
            else;
                set $basic_event_verbosity "some"; /* None Some or All */
            done;
            
            do /if $options['EXTRA_VERBOSITY'];
                set $extra_event_verbosity $options['EXTRA_VERBOSITY'];
            else;
                set $extra_event_verbosity "some"; /* None Some or All */
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
                eval $label_re prxparse($value_match);
            else;
                unset $label_match;
            done;
        end;

        define event documentation;
            trigger help /if cmp($options['DOC'], 'help');
            trigger settings /if cmp($options['DOC'], 'settings');
        end;
        
        define event settings;
            putlog "  Basic_Events: " $basic_events;
            putlog "  Extra_Events: " $extra_events;
            putlog "  Basic_Verbosity: " $basic_event_verbosity;
            putlog "  Extra_Verbosity: " $extra_event_verbosity;
            putlog "  Value_Match: "  $value_match;
            putlog "  Label_Match: "  $label_match;
        end;
    
        define event help;
            putlog "=============================================================================="; 
            putlog "This is help for the example11 tagset."; 
            putlog " "; 
            putlog "Purpose: This tagset is for helping with the exploration of Tagset events and";
            putlog "         their values"; 
            putlog " ";
            putlog 'Example Usage:';
            putlog " ";
            putlog '        ods tagsets.example11 file="test.xml"';
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
            putlog "                           extra events.";
            putlog " ";
            putlog "             Possible Values: None, Some, Few, or All.";
            putlog "             Default value:   Some"; 
            putlog "             Current value: " $basic_event_verbosity;
            putlog " ";
            putlog "        Extra_Verbosity: ";
            putlog "             Description:  Determines which attributes will be shown for the";
            putlog "                           extra events.";
            putlog " ";
            putlog "             Possible Values: None, Some, Few, or All.";
            putlog "             Default value:   Some"; 
            putlog "             Current value: " $extra_event_verbosity;
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
            putlog "=============================================================================="; 
        end;
    
        define event decide;
            start:
                unset $match;
            
                set $match 'basic' /if cmp($basic_events, 'all');
                set $match 'basic' /if contains($basic_events, event_name);

                set $match 'basic_plus' /if cmp($extra_events, 'all');
                set $match 'basic_plus' /if contains($extra_events, event_name);

                /* DEBUG */
                /*
                do/if cmp(event_name, "table");
                    putlog "Table Event" ":" $match;
                    putlog "extra_events" ":" $extra_events;
                done;
                */

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

        define event attribute_matching;
            do /if $match;
                    
                /* DEBUG */
                /*putvars mem _name_ ": " _value_ nl;*/

                do /if any($value_match, $label_match);
                    unset $regex_match;

                    do /if $value_match;
                        eval $foo prxmatch($value_re, value);
                        /* DEBUG */
                        /*putlog "MATCH:" $foo  " Value:" value;*/
                        do /if prxmatch($value_re, value);
                            set $regex_match "True";
                        done;
                    done;

                    do /if $label_match;
                        do /if prxmatch($label_re, value);
                            set $regex_match "True";
                        done;
                    done;

                    /* DEBUG */
                    /*putvars mem _name_ ": " _value_ nl;*/

                    set $match "False" /if ^$regex_match;

                done;
            else;
                set $match "False" /if ^$regex_match;
            done;
        end;

        define event basic;
            start:
                put "<" event_name; 
                trigger put_all_vars /if cmp($basic_event_verbosity, "all");
                trigger put_some_vars /if cmp($basic_event_verbosity, "some");
                trigger put_few_vars /if cmp($basic_event_verbosity, "few");
                put ">" nl;
                break / if empty;
                ndent;
            finish:
                break / if empty;
                xdent;
                put "</" event_name ">" nl; 
        end;

        define event basic_plus;
            start:
                put "[" upcase(event_name); 
                trigger put_all_vars /if cmp($extra_event_verbosity, "all");
                trigger put_some_vars /if cmp($extra_event_verbosity, "some");
                trigger put_few_vars /if cmp($extra_event_verbosity, "few");
                put "/" / if empty;
                put "]" nl;
                break / if empty;
                ndent;
            finish:
                break / if empty;
                xdent;
                put "[/" upcase(event_name) "]" nl; 
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
           putq " url="  url;
       end;
     
       define event put_few_vars;
           putq " value=" value;
           putq " label=" label;
           putq " name="  name;
       end;

    end;
run;

options obs=2;

ods tagsets.example11 file="example11.xml";

proc print data=sashelp.class;
run;

ods _all_ close;

    
ods tagsets.example11 file="example11_b.xml" options(basic_events="data" Extra_events="table" );

ods tagsets.example11 options(doc="settings");

proc print data=sashelp.class;
run;

ods _all_ close;

ods tagsets.example11 file="example11_c.xml" 
     options(basic_events="data" Extra_events="table" basic_verbosity="few");

proc print data=sashelp.class;
run;

ods _all_ close;
ods tagsets.example11 file="example11_c.xml" 
     options(basic_events="data" Extra_events="table" basic_verbosity="few" value_match="/Alfred/" doc="settings");

proc print data=sashelp.class;
run;

ods _all_ close;
    
 
