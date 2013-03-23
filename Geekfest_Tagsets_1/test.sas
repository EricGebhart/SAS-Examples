
ods csv file="test.csv";

proc print data=sashelp.class;
run;

ods csv close;
