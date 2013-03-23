
ods html file="example1.html" stylesheet="example1.css";
proc print data=sashelp.class;
run;
ods html close;

