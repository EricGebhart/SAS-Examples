
proc template;
    define tagset tagsets.example8;
        parent = tagsets.example7;
        default_event = "INVALID";

        define event basic_plus;
            start:
                put "<" upcase(event_name); 
                trigger put_all_vars;
                put "/" / if empty;
                put ">" nl;
                break / if empty;
                ndent;
            finish:
                break / if empty;
                xdent;
                put "<" upcase(event_name) "/>" nl; 
        end;
    
        define event proc;
            start:
                trigger basic_plus;
            finish:
                trigger basic_plus;
        end;
        
    end;
run;

options obs=2;

ods tagsets.example8 file="example8.xml";

proc print data=sashelp.class;
run;

ods _all_ close;

    
    
 
