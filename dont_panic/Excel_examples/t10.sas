
ods tagsets.excelxp file="t10.xls" options(autofilter="yes");



proc report data=sashelp.class nowd;

run;



ods tagsets.excelxp options(autofilter='1-2');



proc report data=sashelp.class nowd;

run;



ods tagsets.excelxp close;

