
proc template;
    define tagset tagsets.example10;
        parent = tagsets.example7;
        default_event = "decide";
        

        define event initialize;
            set $extra_event_verbosity "some"; /* None Some or All */

            set $structure_events "doc proc proc_branch branch leaf output";
            set $table_events "table table_head table_body table_foot";

            set $title_events "system_title system_footer proc_title byline";

            set $basic_events $table_events $structure_events;
            set $extra_events $title_events;
        end;

        define event decide;
            start:
                trigger basic /breakif contains($basic_events, event_name);
                trigger basic_plus /breakif contains($extra_events, event_name);
            finish:
                trigger basic /breakif contains($basic_desc_events, event_name);
                trigger basic_plus /breakif contains($extra_events, event_name);
        end;

        define event basic_plus;
            start:
                put "[" upcase(event_name); 
                trigger put_all_vars /if cmp($extra_event_verbosity, "all");
                trigger put_some_vars /if cmp($extra_event_verbosity, "some");
                put "/" / if empty;
                put "]" nl;
                break / if empty;
                ndent;
            finish:
                break / if empty;
                xdent;
                put "[" upcase(event_name) "/]" nl; 
        end;
    
    end;
run;

options obs=2;

ods tagsets.example10 file="example10.xml";

proc print data=sashelp.class;
run;

ods _all_ close;

    
    
 
