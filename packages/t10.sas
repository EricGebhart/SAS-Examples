
ods listing close;

ods graphics on;

goptions dev=javaimg xpixels=480 ypixels=320;

ods package;

ods html package file="t10.html";

proc sgplot data=sashelp.class;
scatter x=weight y=height;
run;

ods html close;
    
ods package publish archive properties(archive_name="t10.spk" archive_path="./");

    
ods package close clear;
    



