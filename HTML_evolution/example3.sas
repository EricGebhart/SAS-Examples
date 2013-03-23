ods html file="example3.html" style=seaside 
         options(body_toc='yes' toc_type='menu');

proc print data=sashelp.class;
run;

proc standard print data=sashelp.class;
run;

proc report data=sashelp.class nowd;
run;

ods html close;
