
proc template;
    define tagset tagsets.example7;
        parent = tagsets.example5;
        default_event = "Filler";

        define event Filler;
            start:
                put "[" upcase(event_name); 
                trigger put_some_vars;
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

ods tagsets.example7 file="example7.xml";

proc print data=sashelp.class;
run;

ods _all_ close;

    
    
 
