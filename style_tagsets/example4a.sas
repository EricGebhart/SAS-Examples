
proc template;
    define style styles.mystyle;    
         style table /
              borderwidth = 1
              bordercolor = red
              color = blue
         ;
    end;

    define tagset tagsets.show_style;
        embedded_stylesheet=yes;

        define event style_class;
            put "Event: " event_name nl;
            putvars style _name_ " : " _value_ nl;
            put "=============================" nl;
        end;

        define event table;
            put "Event: " event_name nl;
            putvars style _name_ " : " _value_ nl;
            put "=============================" nl;
        end;

    end;

run;


ods tagsets.show_style file="example4a.txt" style=mystyle;

proc print data=sashelp.class;
run;

ods tagsets.show_style close;

