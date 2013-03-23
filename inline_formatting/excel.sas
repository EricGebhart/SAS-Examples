

ods tagsets.excelxp style=journal file="test.xls"  frame="help.html" options(doc='help');

proc print data = sashelp.class;
run;

ods _all_ close;
