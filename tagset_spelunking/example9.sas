
proc template;
    define tagset tagsets.example9;
        parent = tagsets.example7;
        default_event = "decide";
        

        define event initialize;
            set $structure_events "proc proc_branch branch leaf output";
            set $table_events "table table_head table_body table_foot";

            set $basic_desc_events $table_events;
            set $long_desc_events $structure_events;
        end;

        define event decide;
            start:
                putlog "Event:" event_name "Long:" $long_desc_events;
                trigger basic /breakif contains($basic_desc_events, event_name);
                trigger basic_plus /breakif contains($long_desc_events, event_name);
            finish:
                trigger basic /breakif contains($basic_desc_events, event_name);
                trigger basic_plus /breakif contains($long_desc_events, event_name);
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
    
    end;
run;

options obs=2;

ods tagsets.example9 file="example9.xml";

proc print data=sashelp.class;
run;

ods _all_ close;

    
    
 
