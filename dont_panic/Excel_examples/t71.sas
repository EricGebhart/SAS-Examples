data test;
input a b c;
cards;
1 2 3
3 . 2
0 0 3
;
run;

ods tagsets.excelXP file="junk.xls" style=minimal;

proc print data=test;
run;

ods tagsets.excelXP close;
