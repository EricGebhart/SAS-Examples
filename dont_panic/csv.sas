
ods csv file="csv.csv";

ods csvall file="csvall.csv";

ods tagsets.csvbyline file="csvbyline.csv";

ods csv(2) file="csvsemi.csv" options(Delimiter=';');

proc reg data=sashelp.class;
   model Weight = Height Age;
run;quit;

ods _all_ close;


