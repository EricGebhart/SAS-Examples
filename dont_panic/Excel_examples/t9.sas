ods listing close;
ods tagsets.excelxp file='t9.xls'
 options(embedded_titles='yes' embedded_footnotes='yes');

title 'mytitle';
footnote 'myfootnote';
  proc print data=sashelp.class(obs=5) noobs;
  run; quit;
ods _all_  close;
