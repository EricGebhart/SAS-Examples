proc sort data=sashelp.class out=example;
     by age sex;

ods tagsets.Excelxp file="example1a.xls" style=analysis
    options(sheet_interval = 'bygroup'
            sheet_label = ' '
            embedded_titles = 'yes'
            suppress_bylines = 'yes');

title #byvar2 : #byval2;

proc print data=example;
     by age sex;
     pageby sex;
run;

ods _all_ close;
