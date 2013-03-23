
proc template;
    define tagset tagsets.test;
        parent=tagsets.html4;
        default_mimetype = "text/html";
        stylesheet_mimetype = "text/css";
    end;
run;

proc template;
    
    define package packages.example4;

         /* publish info */               /* where to publish to.  archive, webdav, queue, email, etc. */
         /* publish properties, key value pairs. */

         publish = Archive properties ( archive_path="./" archive_name="foo");  

         Description = "This is my description";
         Abstract = "This is my abstract";

         clear = yes;
         
         NameValue = 'path="./"';


         /* Paths.  Where to put stuff inside the package */

         default_path = "./";

         path './'
                files = body contents frame code data
         ;  

         path 'style/'
                mimetypes = "text/css";
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


ods listing close;

goptions dev=gif xpixels=480 ypixels=320;

ods package open template=example4;

ods html package;

*ods tagsets.test package file="t2.html" stylesheet="t2.css";

 proc gplot data=sashelp.class;
     plot height*weight;
     by name;
 run;
 quit;    

*ods tagset.test close;

ods html close;


*ods package publish Archive properties(archive_name="example4.zip");
ods package publish Archive;


ods package close;
    



