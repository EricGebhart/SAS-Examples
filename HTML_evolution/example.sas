ods html3 file="exampleb.html" frame="example.html" contents="examplec.html" pages="examplep.html";

proc print data=sashelp.class;
run;

proc standard print data=sashelp.class;
run;

proc report data=sashelp.class nowd;
run;

ods html2 close;
