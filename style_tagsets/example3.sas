
proc template;
    define style styles.mystyle;    
         style table /
              borderwidth = 1
              bordercolor = red
              color = blue
         ;
    end;
run;


ods tagsets.tpl_style_map file="example3_map.xml" stylesheet="example3_style_map.xml" style=mystyle;

proc print data=sashelp.class;
run;

ods _all_ close;

