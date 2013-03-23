
proc template;
    define tagset tagsets.example6;
        parent = tagsets.example5;
        default_event = "basic";
    end;
run;

options obs=2;

ods tagsets.example6 file="example6.xml";

proc print data=sashelp.class;
run;

ods _all_ close;

    
    
 
