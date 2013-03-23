  /****************************************************************
  *
  *            DEFECTS SYSTEM TEST LIBRARY
  *
  *
  *  DEFECTID: S0362589
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

title1 'ODSTEXT1:  using multiple text= options for multiple ODAs';

ods html file='text.htm';

ods html text='This is the first text line. '
         text='This is the second text line.'
         text='this is the third line'
         text='fourth line';

title2 'Proc print:  Using multiple text= strings';
proc print data=sashelp.class;
run;

ods _all_ close;
