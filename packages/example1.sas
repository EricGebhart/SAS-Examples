
ods listing close;

goptions dev=gif xpixels=480 ypixels=320;

ods package open;

ods html package;

 proc gplot data=sashelp.class;
     plot height*weight;
     by name;
 run;
 quit;    

ods html close;
    
ods package publish archive properties(archive_name="example1.zip" archive_path="./");

ods package close;
    



