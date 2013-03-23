
proc template;
    define style styles.mystyle;    
         style table /
              borderwidth = 1
              bordercolor = red
              color = blue
         ;
    end;
run;


ods html file="example2.html" stylesheet="example2.css" style=mystyle;
proc print data=sashelp.class;
run;
ods html close;

