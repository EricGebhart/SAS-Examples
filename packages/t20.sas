
ods listing close;

%filename (t, t20, sas);

ods package open;

/* this causes the grammar processor to go into an endless loop. */
*ods package add data=sashelp 0 class;

ods package add file="t20.sas" path="sas" mimetype="text/plain";

ods package add file=t;

ods package add data=sashelp.class;


proc sort data=sashelp.class out = foo;
    by age;
run;


ods package add data = foo;
    
ods package publish archive properties(archive_name="t20.spk" archive_path="./");

    
ods package close clear;
    



