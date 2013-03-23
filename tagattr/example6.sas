ods listing close;

data test;
  d1 = '1st data row of stuff'; output;
  d1 = '2nd data row of stuff'; output;
run;
 
ods tagsets.excelxp file="example6.xls" style=journal ;
 
title ;
 
proc report data=test nowd;
  columns d1;
  define d1 / '' style={tagattr="mergeAcross:yes"};
run;

proc report data=test nowd;
  columns d1;
  define d1 / '';
run;
 
 
ods tagsets.excelxp close;
ods listing;
