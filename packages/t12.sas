
ods listing close;


ods package desc="This is a description";

ods html package file="t12_1.html" newfile=output;

*options obs=5;

proc sort data=sashelp.class out=foo;
    by age;
run;


proc report ;
    by age;
run;
    

ods html close;


ods package add file="t12.sas";

    
ods package publish archive properties(archive_name="t12.spk" archive_path="./");

    
ods package close clear;
    



