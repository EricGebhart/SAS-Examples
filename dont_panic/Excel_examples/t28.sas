ods listing close;
ods tagsets.ExcelXP file='aedata.xml' data='xlxpinit.txt';

  ods tagsets.ExcelXP options(sheet_name='Data - Trial 1'
     width_fudge='0.7'
     frozen_headers='2' autofilter='all'
     orientation='landscape' row_repeat='1-2');

  proc print data=sashelp.class;
  run; quit;

ods tagsets.excelxp close;

