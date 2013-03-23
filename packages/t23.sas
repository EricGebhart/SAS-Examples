  /****************************************************************
  *
  *            DEFECTS SYSTEM TEST LIBRARY
  *
  *
  *  DEFECTID: S0388515
  *
  *  TEST STREAM PATHNAME:
  *
  *  RESULTS -- INCORRECT:
  *
  *
  *  RESULTS -- CORRECT:
  *
  ****************************************************************/

OPTIONS NODATE NOSTIMER LS=78 PS=60;

/*-- test nested packages --*/

proc template;
        define tagset tagsets.test;
            parent=tagsets.html4;
            default_mimetype = "text/html";
            stylesheet_mimetype = "text/css";
        end;
    run;

    proc template;

        define package packages.test;

             /* publish info */               
             /* where to publish to.  archive, webdav, queue, email, etc. */
             /* publish properties, key value pairs. */

             publish = Archive properties ( archive_path="./" archive_name="test" ); 

             Description = "This is my description";
             Abstract = "This is my abstract";

             /* clean up the temporary files */
             clear = yes;

             NameValue = 'path="./"';

             /* Paths.  Where to put stuff inside the package */

             default_path = "./";

             path './'
                    files = body contents frame code data
                    mimetypes = "text/html"
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

    /* list the packages, and source the one we just created */


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

    /* create the package */
    ods package publish archive properties(archive_name="test.spk" archive_path="./");

    /* close the package and clean up */
    ods package close clear;

ods listing;
proc document name=import(write);
   import archive="test.spk" to ^;
   list/levels=all details;
   replay;
   run;
   quit;

proc template;
  delete tagsets.test;
  delete packages.test;
run;   
