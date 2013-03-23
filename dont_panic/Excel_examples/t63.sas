ods tagsets.excelxp file='t63.xls'
options(absolute_column_width='4'
        debug_level="-2");

title2 'setting absolute_column_width to 4';
proc print data=sashelp.class;
run;

ods tagsets.excelxp close;

