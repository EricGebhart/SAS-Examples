ods html file='temp.htm';
goptions reset=all dev=javameta;
proc gchart data=sashelp.class;
vbar age;
run;
quit;
ods html close;
ods listing;
