ods listing close;

ods tagsets.excelXP file='temp.xls';



  ods tagsets.ExcelXP options(sheet_name='Class');



  proc print data=sashelp.class(obs=2); run; quit;



  ods tagsets.ExcelXP options(sheet_name='None');



  proc print data=sashelp.class(obs=2); run; quit;



  ods tagsets.ExcelXP options(sheet_label='vcd');



  proc print data=sashelp.class(obs=2); run; quit;



  ods tagsets.ExcelXP options(sheet_label='None');



  proc print data=sashelp.class(obs=2); run; quit;



ods tagsets.ExcelXP close;
