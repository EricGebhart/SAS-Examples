
ods listing close;


ods package(foo);
ods package;

ods html package file="t6_1.html" newfile=output;
ods rtf package(foo) file="t6_1.rtf" newfile=output;
ods pdf package(foo) file="t6_1.pdf" newfile=output;


*options obs=5;

proc sort data=sashelp.class out=foo;
    by age;
run;


proc print ;
    by age;
run;
    

ods _all_ close;
    
ods package(foo) publish archive properties(archive_name="t6.spk" archive_path="./");
ods package publish archive properties(archive_name="t6_html.spk" archive_path="./");

    
ods package(foo) close clear;
ods package close;
    



