
ods rtf file="rtf.rtf";

ods tagsets.rtf file="mrtf.rtf";

proc reg data=sashelp.class;
   model Weight = Height Age;
run;quit;

ods _all_ close;


