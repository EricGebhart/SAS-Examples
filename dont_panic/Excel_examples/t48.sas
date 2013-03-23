  /****************************************************************
  *
  *            DEFECTS SYSTEM TEST LIBRARY
  *
  *
  *  DEFECTID: S0311899
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

ods tagsets.excelxp file="test.xls";

proc report data=sashelp.class(obs=5) nowd;
define name / style={just=left};
run;

ods tagsets.excelxp close;
