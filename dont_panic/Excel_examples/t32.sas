ods tagsets.excelxp file="file.xls" ;

data test;

 x="really long value here too long - must wrap please";

 y=99;

 output;

run;

proc report nowd data=test;

define x / display ; *style(column)={cellwidth=2in};

run;

ods _all_ close;
