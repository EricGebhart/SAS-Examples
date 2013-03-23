
proc template;
    define tagset tagsets.example5;
        parent=tagsets.html4;
        default_mimetype = "text/html";
        stylesheet_mimetype = "text/css";

        package=example5;

        body = "test.html";
        stylesheet = "test.css";
        
        define event foo;
            putlog "Hello";
        end;
    end;
run;

proc template;
    
    define package packages.example5;

         /* publish info */               /* where to publish to.  archive, webdav, queue, email, etc. */
         /* publish properties, key value pairs. */

         publish = Archive properties ( path="./");  

         Description = "This is my description";
         Abstract = "This is my abstract";

         clear = yes;
         
         NameValue = 'foobar="./"';

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

ods tagsets.test file="example5.spk";

 proc gplot data=sashelp.class;
     plot height*weight;
     by name;
 run;
 quit;    

ods html close;

    



