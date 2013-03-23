ods html file="example5.html" style=Journal 
         options(body_toc='yes' toc_type='menu'
                 scroll_tables='yes' scroll_control_images='yes');

proc print data=sashelp.class;
run;

proc standard print data=sashelp.class;
run;

proc report data=sashelp.class nowd;
run;

ods html close;
