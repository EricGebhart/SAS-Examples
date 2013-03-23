ods html4 file='sample.html' contents='samplec.html' frame='samplef.html';

proc print data=sashelp.class;
run;

ods _all_ close;
