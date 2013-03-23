run;


ods tagsets.excelxp file="t27.xls";


ods tagsets.excelxp options(sheet_name="A" sheet_interval='none' row_repeat='1' debug_level='1');

proc print data=sashelp.class;
run;

	
ods tagsets.excelxp options(sheet_name="B" sheet_interval='none' row_repeat='4');

proc print data=sashelp.class;
run;

ods tagsets.excelxp close;

