  /****************************************************************
  *
  *            DEFECTS SYSTEM TEST LIBRARY
  *
  *
  *  DEFECTID: S0385939
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

ods tagsets.ExcelXP file="t84.xls" 
    options(Print_Header="test"    
            sheet_interval='bygroup'
);

proc sort data=sashelp.class out=new;
by age;
run;

proc print data=new;
BY age;
run;
ods tagsets.ExcelXP close;
