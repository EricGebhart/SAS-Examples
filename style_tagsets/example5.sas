
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
        pure_style = yes;

        define event style_class;
            trigger show_style;
        end;

        define event table;
            trigger show_style;
        end;
    
        define event show_style;
            put "Event: " event_name nl;
            putvars style _name_ " : " _value_ nl;
            put "=============================" nl;
        end;

    end;

run;


ods tagsets.show_style file="example5.txt" style=mystyle;

proc print data=sashelp.class;
run;

ods tagsets.show_style close;

