proc format;
 value fgcolor  1-300="yellow"
              301-500="orange"
           501-high="white";

ods tagsets.excelxp file="s0303839.xls"
options(doc='help' frozen_headers='yes' sheet_name="myname");

/* commenting out style(column) makes it run */
proc print data=sashelp.air style(column)={background=white};
var date;
var air / style(column)={foreground=fgcolor.};
run;

ods tagsets.excelxp close;
