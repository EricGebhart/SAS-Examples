

ods tagsets.excelxp file="test.xls";

title "Hello";

title1 "Title One";

title2;

title3 "Title Three";

title4 "Title Four";


proc print data=sashelp.class;
run;

ods _all_ close;
