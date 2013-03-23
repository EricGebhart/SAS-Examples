ods html file="example2.html" options(body_toc='yes') style=seaside;

proc print data=sashelp.class;
run;

proc standard print data=sashelp.class;
run;

proc report data=sashelp.class nowd;
run;


ods html close;
