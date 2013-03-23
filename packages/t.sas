


ods tagsets.rtf file="t.rtf" ;
ods html file="t.html";

ods text="test of generic" ; 

proc print data=sashelp.class; run;

ods _all_ close; 

