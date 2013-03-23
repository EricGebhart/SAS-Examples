

ods pdf file="pdf.pdf";

proc reg data=sashelp.class;
   model Weight = Height Age;
run;quit;

ods _all_ close;


