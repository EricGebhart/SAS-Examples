
proc template;

    define tagset tagsets.show_style;

        embedded_stylesheet=yes;

        define event header;
            trigger show_style;
        end;

        define event data;
            trigger show_style;
        end;
    
        define event show_style;
            put "Event: " event_name nl;
            put "Value: " value nl;
            putvars style _name_ " : " _value_ nl;
            put "=============================" nl;
        end;

    end;

run;

options obs=1;

ods tagsets.show_style file="example13.txt";
ods html file="example13.html";

proc print data=sashelp.class noobs;
    var name /style (header) =[foreground=red];
    var age  /style (data) = [foreground=green];
run;

ods _all_ close;

