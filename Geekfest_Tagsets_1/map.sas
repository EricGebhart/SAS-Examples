

ods tagsets.namedhtml file='named.html'  stylesheet="named.css";

proc print data=sashelp.class;
run;

ods _all_ close;    

