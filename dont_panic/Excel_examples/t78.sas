proc sort data=sashelp.class out=class; by age; run; quit;
ods listing close;
ods html file="class.html";
ods tagsets.excelxp file='class.xls'
  options(embedded_titles='yes' embedded_footnotes='yes');
  title 'Test Title';
  footnote 'Test Footnote';
  proc print data=class; by age; run; quit;
ods tagsets.excelxp close;
