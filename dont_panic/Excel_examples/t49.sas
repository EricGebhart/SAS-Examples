  /****************************************************************
  *
  *            DEFECTS SYSTEM TEST LIBRARY
  *
  *
  *  DEFECTID: S0303839
  *
  *  TEST STREAM PATHNAME:
  *
  *  RESULTS -- INCORRECT:
  *
  *
  *  RESULTS -- CORRECT:
  *
  ****************************************************************/

OPTIONS NODATE NOSTIMER LS=78 PS=60;


proc format;
 value fgcolor  1-300="yellow"
              301-500="orange"
	     501-high="white";

ods tagsets.excelxp file="test.xls"  
options(frozen_headers='yes' sheet_name="myname");

/* commenting out style(column) makes it run */
proc print data=sashelp.air style(column)={background=white};
var date;
var air / style(column)={foreground=fgcolor.};
run;

ods tagsets.excelxp close;
