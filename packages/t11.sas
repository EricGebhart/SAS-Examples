
ods listing close;

ods graphics on;

goptions dev=actximg xpixels=480 ypixels=320;

ods package;

ods html package file="t11.html";

proc sgplot data=sashelp.class;
scatter x=weight y=height;
run;

ods html close;
    
ods package publish archive properties(archive_name="t11.spk" archive_path="./");

    
ods package close clear;
    



