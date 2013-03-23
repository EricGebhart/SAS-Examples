ods html file="example4.html" style=Journal 
         options(body_toc='yes' toc_type='menu'
                 scroll_tables='yes');

proc print data=sashelp.class;
run;

proc standard print data=sashelp.class;
run;

proc report data=sashelp.class nowd;
run;

ods html close;
