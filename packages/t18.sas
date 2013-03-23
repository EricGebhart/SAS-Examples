
ods listing close;


ods package open;

ods html package file="t2_1.html" newfile=output;

*options obs=5;

proc sort data=sashelp.class out=foo;
    by age;
run;


proc print ;
    by age;
run;
    

ods html close;
    
ods package publish Email addresses("eric.gebhart@sas.com")
properties(archive_name="testPackage" archive_path="./");
    
ods package close clear;
    



