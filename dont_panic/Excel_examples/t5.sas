ods listing close;
ods tagsets.excelxp file='t5.xls'
options(autofilter='all' debug_level='2');
  proc print data=sashelp.class;
  run; quit;
ods _all_ close;
