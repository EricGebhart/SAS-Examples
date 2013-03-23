
proc template;
    define tagset tagsets.test;
        parent=tagsets.html4;
        default_mimetype = "text/html";
        stylesheet_mimetype = "text/css";
    end;
run;

proc template;
    
    define package packages.test;

         /* publish info */               /* where to publish to.  archive, webdav, queue, email, etc. */
         /* publish properties, key value pairs. */

         publish = Archive properties ( path="./" archive_name="foo" foo="bar" );  

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

proc template;
    list packages;
    source packages.test;
run;


ods listing close;

goptions dev=gif xpixels=480 ypixels=320;

ods package open template=test namevalue = 'stuff="junk"';

ods tagsets.test package file="t2.html" stylesheet="t2.css";

 proc gplot data=sashelp.class;
     plot height*weight;
     by name;
 run;
 quit;    

ods tagsets.test close;

ods package add file="test.sas" path="sas" mimetype="text/plain";
    
ods package publish archive properties(archive_name="test.spk" archive_path="./");

ods package close;
    



