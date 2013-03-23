
proc template;
    define tagset tagsets.example8a;
        default_event = "basic";

        indent=2;

        define event initialize;
                set $title_events "system_title system_footer proc_title byline pagebreak"; 
                set $structure_events "doc proc proc_branch branch bygroup leaf output table"; 
                set $event_list $structure_events $title_events; 
        end;

        define event basic;
            start:
                break /if ^contains($event_list, event_name);
                put "<" event_name; 
                trigger halogen;
                put "/" / if empty;
                put ">" nl;
                break / if empty;
                ndent;
            finish:
                break /if ^contains($event_list, event_name);
                break / if empty;
                xdent;
                put "<" event_name "/>" nl; 
        end;

        define event halogen;
            putq " value=" value;
            putq " label=" label;
            putq " name="  name;
            putq " htmlclass=" htmlclass;
            putq " anchor=" anchor;
        end;
    end;
run;

options obs=2;

ods tagsets.example8a file="example8a.xml";

proc print data=sashelp.class;
run;

ods _all_ close;

    
    
 
