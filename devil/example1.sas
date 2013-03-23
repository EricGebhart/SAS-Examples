proc sort data=sashelp.class out=example;
     by age sex;

ods tagsets.Excelxp file="example1.xls" style=analysis
    options(sheet_interval = 'bygroup'
            sheet_label = ' ');

proc print data=example;
     by age sex;
run;

ods _all_ close;
