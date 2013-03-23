options topmargin=.1in rightmargin=0.2in bottommargin=0.3in
leftmargin=.4in;

proc options option=topmargin; run; quit;
proc options option=rightmargin; run; quit;
proc options option=bottommargin; run; quit;
proc options option=leftmargin; run; quit;

ods listing close;
ods tagsets.excelxp file='t11.xls';
  proc print data=sashelp.class; run; quit;
ods _all_ close;
