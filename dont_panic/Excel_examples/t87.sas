Options debug="tagset_where";

ods tagsets.excelxp file='a.xml';
proc print data=sashelp.class;
var age / style={tagattr='data:number format:standard'};
run;
ods _all_ close;
