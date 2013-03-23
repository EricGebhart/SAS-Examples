

ods tagsets.excelxp file="test.xls" options(sheet_interval="bygroup" suppress_bylines='yes');

proc sort data=sashelp.class out=foo;
   by age sex; 
run;


proc report data=foo;
    by age sex;
    run;

ods tagsets.excelxp close;    
