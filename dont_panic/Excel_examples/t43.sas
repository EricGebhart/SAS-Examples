ods listing close;
ods tagsets.excelxp file='test.xls';
   title; footnote;
   proc print data=sashelp.class; run; quit;
 ods _all_ close;
