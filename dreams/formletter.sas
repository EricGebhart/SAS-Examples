%inc "formletter.tpl";

*options debug="tagset_where";


ods tagsets.formletter file="letter1.txt" newfile=table;

ods tagsets.formletter options(doc='help');

option obs=3;

proc sort data=sashelp.class;
    by name;
run;


proc print ;
    var name age height weight;
    by name;
run;

ods tagsets.letter close;

