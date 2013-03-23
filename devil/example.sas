ods tagsets.Excelxp(a) file="examplea.xls" style=journal;
ods tagsets.Excelxp(b) file="exampleb.xls" style=meadow;
ods tagsets.Excelxp(c) file="examplec.xls" style=analysis;
ods tagsets.Excelxp(d) file="exampled.xls" style=statistical;
ods tagsets.Excelxp(e) file="examplee.xls" style=minimal;
ods tagsets.Excelxp(f) file="examplef.xls" style=printer;
ods tagsets.Excelxp(g) file="exampleg.xls" style=seaside;
ods tagsets.Excelxp(h) file="exampleh.xls" style=watercolor;
ods tagsets.Excelxp(i) file="examplei.xls" style=sketch;

proc print data=sashelp.class; run;

ods _all_ close;

