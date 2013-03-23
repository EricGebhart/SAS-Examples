
proc template;
    define style styles.mystyle;

        style red_header from header/
           foreground=red
        ;
    
        style green_data from data/
           foreground=green
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

ods tagsets.show_style file="example14.txt" style=mystyle;
ods html file="example14.html" style=mystyle;

proc print data=sashelp.class noobs;
    var name /style (header) =red_header;
    var age  /style (data) = green_data;
run;

ods _all_ close;

