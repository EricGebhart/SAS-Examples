ods tagsets.excelxp file='mexl10ab.xml'
options(absolute_column_width='4');

title2 'setting absolute_column_width to 4';
proc print data=sashelp.class;
run;

ods tagsets.excelxp close;
