data one;
  x=1;
  y=.;
run;

ods tagsets.excelxp file='test.xls' style=minimal;

proc print data=one;
run;

ods tagsets.excelxp close;
