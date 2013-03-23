OPTIONS NODATE NOSTIMER LS=78 PS=60;

ods tagsets.excelxp file="temp.xls";
ods tagsets.short_map file="map.xml";
ods html file="temp.html";

proc report data=sashelp.class nowd;
define age / order;

compute after;
line "This is the first line";
line "This is the second line";
endcomp;

run;

ods _all_ close;
