
proc template;
    define tagset tagsets.test;
        parent=tagsets.html4;
        default_mimetype = "text/html";
        stylesheet_mimetype = "text/css";
    end;
run;

proc template;
    
    define package packages.example3;

        archive_path = "./";
    
        archive_name = "example3.zip";
    
         /* Paths.  Where to put stuff inside the package */

         default_path = "./";

         path './'
                files = body contents frame code data
         ;  

        
         path 'style/'
                files = stylesheet
         ;  

         path 'images/'
                mimetypes = "image/bmp image/gif image/jpg image/png"
         ;

         path 'drawing/'
                mimetypes = "image/svg+xml"
         ;

         path 'rtf/'
                mimetypes = "text/rtf text/richtext"
         ;  


    end;
    
run;

proc template;
    list packages;
    source packages.example3;
run;


ods listing close;

goptions dev=gif xpixels=480 ypixels=320;

ods package open template=example3 namevalue = 'stuff="junk"';

*ods tagsets.test package file="t2.html" stylesheet="t2.css";
ods html package;

 proc gplot data=sashelp.class;
     plot height*weight;
     by name;
 run;
 quit;    

ods html close;

*ods package add file="test.sas" path="sas" mimetype="text/plain";
    
ods package publish archive;

ods package close;
    



