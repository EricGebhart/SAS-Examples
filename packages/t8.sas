
ods listing close;

goptions dev=actximg xpixels=480 ypixels=320;

ods package;

ods html package file="t8.html";

 proc gplot data=sashelp.class;
     plot height*weight;
     by name;
 run;
 quit;    

ods html close;
    
ods package publish archive properties(archive_name="t8.spk" archive_path="./");

    
ods package close clear;
    



