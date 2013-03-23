
proc template;

    define style styles.mydefault;
        style red_header from header /
            foreground=red
            tagattr="Show this!"
        ;
        style green_data from data /
            foreground=green
            tagattr="!!!!!!"
        ;
    end;
    
        

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

ods tagsets.show_style file="example13a.txt" style=mydefault;
ods html file="example13a.html" style=mydefault;

proc print data=sashelp.class noobs;
    var name /style (header) = red_header;
    var age  /style (data) = green_data;
run;

ods _all_ close;

