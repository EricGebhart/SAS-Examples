proc sort data=sashelp.class out=class; by age; run; quit;
ods listing close;
ods tagsets.excelxp  file='class.xls'
  options(embedded_titles='yes' embedded_footnotes='yes');
  title height=3 'Test Title';
  footnote height=2 'Test Footnote';
  proc print data=class; by age; run; quit;
ods tagsets.excelxp close;
