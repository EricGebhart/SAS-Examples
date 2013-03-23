

ods imode file="imode.html";

ods chtml file="chtml.html";

ods phtml file="phtml.html";

ods htmlcss file="htmlcss.html";

ods html4 file="html4.html";

ods tagsets.xhtml file="xhtml.html";

proc reg data=sashelp.class;
   model Weight = Height Age;
run;quit;

ods _all_ close;


