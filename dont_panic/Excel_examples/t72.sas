proc sort data=sashelp.class out=class; by sex; run; quit;
ods listing close;
ods tagsets.excelxp file='default.xls' style=default options(embedded_titles="yes" embedded_footnotes="yes");
ods tagsets.excelxp(1) file='minimal.xls' style=minimal options(embedded_titles="yes" embedded_footnotes="yes");
ods tagsets.excelxp(2) file='torn.xls' style=torn options(embedded_titles="yes" embedded_footnotes="yes");
ods tagsets.html4 file='torn.html' style=torn;
ods tagsets.excelxp(3) file='seaside.xls' style=seaside options(embedded_titles="yes" embedded_footnotes="yes");
ods tagsets.excelxp(4) file='printer.xls' style=printer options(embedded_titles="yes" embedded_footnotes="yes");
ods tagsets.excelxp(5) file='meadow.xls' style=meadow options(embedded_titles="yes" embedded_footnotes="yes");
ods tagsets.excelxp(6) file='statistical.xls' style=statistical options(embedded_titles="yes" embedded_footnotes="yes");
ods tagsets.excelxp(7) file='journal.xls' style=journal options(embedded_titles="yes" embedded_footnotes="yes");
ods tagsets.excelxp(8) file='rsvp.xls' style=rsvp options(embedded_titles="yes" embedded_footnotes="yes");
ods tagsets.excelxp(9) file='festival.xls' style=festival options(embedded_titles="yes" embedded_footnotes="yes");
ods tagsets.excelxp(10) file='normal.xls' style=normal options(embedded_titles="yes" embedded_footnotes="yes");
ods tagsets.excelxp(11) file='money.xls' style=money options(embedded_titles="yes" embedded_footnotes="yes");
ods tagsets.excelxp(12) file='sketch.xls' style=sketch options(embedded_titles="yes" embedded_footnotes="yes");
ods tagsets.excelxp(13) file='watercolor.xls' style=watercolor options(embedded_titles="yes" embedded_footnotes="yes");
*ods tagsets.excelxp(14) file='fancyprinter.xls' style=fancyprinter options(embedded_titles="yes" embedded_footnotes="yes");
*ods tagsets.excelxp(15) file='barrettsblue.xls' style=barrettsblue options(embedded_titles="yes" embedded_footnotes="yes");
*ods tagsets.html4 file='barrettsblue.html' style=barrettsblue;
*ods tagsets.excelxp(16) file='brown.xls' style=brown options(embedded_titles="yes" embedded_footnotes="yes");
options nocenter;
title2 "title two";
footnote "footnote";
footnote2 "footnote2";

  proc print data=class noobs; by sex; run; quit;
ods _all_ close;

