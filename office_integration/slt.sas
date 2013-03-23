%inc "ods/pgm/en/htmltags.tpl";


ods csv file="csv.csv";

ods csvall file="csvall.csv";

ods csvbyline file="csvbyline.csv";

ods csv file="csvsemi.csv" options(Delimiter=';');

proc reg data=sashelp.class;
   model Weight = Height Age;
run;quit;

ods _all_ close;


