proc sort data=sashelp.class out=sorted;
by sex;
run;
ods tagsets.excelxp file="file.xls" options(doc='help'
sheet_label="Gender" sheet_interval="bygroup" );

proc report nowd data=sorted;
by sex;
run;

ods _all_ close;
