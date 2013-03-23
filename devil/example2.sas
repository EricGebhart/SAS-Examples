proc sort data=sashelp.class out=example;
     by age sex;

ods tagsets.Excelxp file="example2.xls" style=journal2
    options(sheet_interval = 'bygroup'
            sheet_label = ' '
            index='yes'
            contents='yes');

proc print data=example;
     by age sex;
run;

ods _all_ close;
