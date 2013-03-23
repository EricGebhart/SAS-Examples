
ods listing close;


ods package;

ods html package file="t4_1.html" newfile=output;
ods rtf package file="t4.rtf";
ods pdf package file="t4.pdf";


*options obs=5;

proc sort data=sashelp.class out=foo;
    by age;
run;


proc print ;
    by age;
run;
    

ods _all_ close;
    
ods package publish archive properties(archive_name="t4.spk" archive_path="./");

    
ods package close;
    



