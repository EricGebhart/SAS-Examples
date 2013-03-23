options papersize=legal;

ods tagsets.excelxp file="t33.xls" style=Normal;

proc sort data=sashelp.class;
    by age;
    
proc print ;
    by age;
    
run;

ods tagsets.excelxp close;
