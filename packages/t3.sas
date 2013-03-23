
ods listing close;


ods package(foo) open;

ods html package(foo) file="t2_1.html" newfile=output;

*options obs=5;

proc sort data=sashelp.class out=foo;
    by age;
run;


proc print ;
    by age;
run;
    

ods html close;
    
ods package(foo) publish archive properties(archive_name="t3.spk" archive_path="./");

    
ods package(foo) close;
    



