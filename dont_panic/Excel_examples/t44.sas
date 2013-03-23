data test;
input a b c d;
informat d percent5.;
format d percent5.;
cards;
1 2 3 5.6%
1 2 1 2.2%
4 4 4 4.1%
4 3 2 1.0%
;

  /*-- Specifying convert_percentages= yes --*/
  /*-----------------------------------------*/
ods tagsets.excelxp file='a.xls' options(convert_percentages='yes'); 
 
title2 'Specifying convert_percentages= yes';                           
proc print data=test;
run;

ods tagsets.excelxp close;



  /*-- Specifying convert_percentages= no  --*/
  /*-----------------------------------------*/
ods tagsets.excelxp file='b.xls' options(convert_percentages='no'); 
 
title2 'Specifying convert_percentages= no';                           
proc print data=test;
run;

ods tagsets.excelxp close;
