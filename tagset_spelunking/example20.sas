%inc "config_debug.tpl";

proc template;
    define tagset tagsets.example20;
        parent=tagsets.config_debug;
        
        default_event = "decide";
        indent = 2;


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

        /*-----------------------------------------------------------eric-*/
        /*-- Each new option should be added in three places before     --*/
        /*-- using it in the underlying code.                           --*/
        /*-- 1. Add the option to the $valid_options array              --*/
        /*-- 2. Add the option to the set_options event to set the      --*/
        /*--        appropriate variable, if necessary.                 --*/
        /*-- 3. Add the option to the quick reference event's help text.--*/
        /*--------------------------------------------------------11Mar07-*/

        define event set_valid_options;
            set $valid_options['DOC'] 'Documentation for this tagset';
            set $valid_options['SHORT_EVENTS'] 'List of events to display short descriptions.';
            set $valid_options['LONG_EVENTS'] 'List of events to display long descriptions.';
            trigger config_debug_set_valid_options;
        end;

        define event set_options_defaults;
            set $defaults['DOC'] 'none';
            set $defaults['SHORT_EVENTS'] "table table_head table_body table_foot row header data";
            set $defaults['LONG_EVENTS'] "proc proc_branch branch leaf output";
            trigger config_debug_set_options_defaults;
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

            trigger config_debug_options_setup;

            /* Events with Short Descriptions */
            unset $short_events;
            unset $event_list;

            /* set the list to the option if there is one */
            set $event_list $options['SHORT_EVENTS'];

            /* set the list back to nothing so the default will restore. */
            unset $event_list /if cmp($event_list, 'default');

            /* set the list to the default if it's not set already. */
            set $event_list $defaults['SHORT_EVENTS'] /if ^$event_list;

            /* make a list of event names */
            trigger set_short_events /if ^cmp($event_list, 'none');
                    


            /* Events with Long Descriptions */
            unset $long_events;
            unset $event_list;
            set $event_list $options['LONG_EVENTS'];
            unset $event_list /if cmp($event_list, 'default');
            set $event_list $defaults['LONG_EVENTS'] /if ^$event_list;

            /* make a list of event names */
            trigger set_long_events /if ^cmp($event_list, 'none');



/*---------------------------------------------------------------eric-*/
/*-- Print some debug messages so we can see what is going on with  --*/
/*-- our options.                                                   --*/
/*------------------------------------------------------------16Mar07-*/
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
            putlog "Doc:   Default value: " $defaults['DOC'];
            putlog "     Help:     Displays introductory text and options.";
            putlog "     Quick:    Displays available options.";
            putlog "     Settings: Displays config/debug settings.";
            putlog "     options:  Displays list of options, their current value, and";
            putlog "               a short description";
            putlog " ";
            putlog "Short Events:   Default Value '" $defaults['SHORT_EVENTS'] "'";
            putlog "     Events which should be displayed with a small number of attributes.";
            putlog "     This is a space delimited list of event names to print";
            putlog "     as they occur.  If 'none' is given no short descriptions will";
            putlog "     be printed.  A value of 'default' will return the list to it's default.";
            putlog " ";
            putlog "Long Events:   Default Value '" $defaults['LONG_EVENTS'] "'";
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

run;

options obs=2;

ods tagsets.example20 file="example20.xml" options(doc='help' debug_level='1');

proc print data=sashelp.class;
run;

ods _all_ close;

ods tagsets.example20 file="example20.xml" options(doc='options' test='junk');
ods _all_ close;
    
    
 
