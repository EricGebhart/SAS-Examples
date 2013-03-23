
ods tagsets.excelxp file="t19.xls" style=minimal;

proc print data=sashelp.class;
run;

ods _all_ close;
