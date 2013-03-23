ods tagsets.excelxp file="t91.xls" options(embedded_titles='yes');


Title1 "Department of Assistive and Rehabilitative Services";
Title2 bcolor=yellow color=blue bold italic height=14pt justify=center "Expenditures by Strategy and Division";
Title3 bcolor=green color=yellow bold italic height=14pt justify=right "something on the right";
Title4 bcolor=blue color=yellow bold italic height=14pt justify=left "something on the left";

proc print data=sashelp.class;
run;

ods _all_ close;
