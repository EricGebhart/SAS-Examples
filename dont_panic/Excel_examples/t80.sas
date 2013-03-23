
ods csv file="test.csv" options(prepend_equals="yes" table_headers="no");

proc print data=sashelp.class;
run;

ods csv close;

ods csv file="test2.csv" ;

proc print data=sashelp.class;
run;

ods csv close;
