data test;
input region $ x;
cards;
UTWT 11713.5
UTWT 11782.88
SYR 3967.86
SYR 7379.93
U&S 15681.36
U&S 19162.81
;
run;

ods listing close;
*ods tagsets.msoffice2k file='test.xls';
ods tagsets.excelxp file='test.xls' ;

PROC REPORT data=test nowd ;
column  region
      x;
define x / format=dollar12.2;
compute region;
If region='SYR' then call
define(_row_,'style','style=[background=YELLOW]');
endcomp;
RUN;

ODS tagsets.excelxp close;
ods tagsets.msoffice2k close;
ods listing;
