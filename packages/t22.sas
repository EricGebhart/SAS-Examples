ods package(pkg) open;


  /*-- Create html and rtf output.  Send it --*/
  /*-- to a package called pkg.             --*/
  /*------------------------------------------*/
%filename(a, spk002b, htm);
%filename(r, spk002r, rtf);
ods html package(pkg) file=a;
ods rtf package(pkg) file=r;

  /*-- Create output  --*/
  /*--------------------*/
proc sort data=sashelp.class out=class;
by age;
run;

title2 'Proc report:  BY age';
proc report data=class nowd;
column sex height weight;
by age;
define sex /group;
run;

title2 'Proc means: BY age';
proc means data=class n min max;
by age;
run;


  /*-- close ODAs   --*/
  /*------------------*/
ods html close;
ods rtf close;

  /*-- Publish the package.  This creates a file      --*/
  /*-- called spk002.spk.   Spk002.spk should contain --*/
  /*-- the metadata, html and rtf files.              --*/
  /*-- Have to specify archive_name and archive_path. --*/
  /*----------------------------------------------------*/
ods package(pkg) publish archive
  properties(archive_name='spk002.spk' archive_path=".");


  /*-- Close the package.   --*/
  /*--------------------------*/
ods package(pkg) close;


  /*-- dump contents of metadata --*/
  /*-------------------------------*/

data _null_;
   length desc $500   nameValue $256  fname $256 channel $64 mimeType
$64
          etype $20 filename $256;
   pid=0;rc=0;   total=0; plist=0;

   call retrieve_package(plist, "FROM_ARCHIVE", "spk002", total, rc);
   if (rc ne 0) then do;
       put "Retrieve_package failed.";
       msg = sysmsg();
       put msg;
       ABORT;
   end;

   numEntries = 0;
   dateTime = 0;

   call package_first(plist, pid, numEntries, desc, dateTime, nameValue,
channel, rc);
   if (rc ne 0) then do;
       put "Package_first failed";
       msg = sysmsg();
       put msg;
       ABORT;
   end;


   count = 0;
   do while (count < numEntries);
      put "       ";
      ehandle = 0;
      call entry_next(pid, ehandle, etype, mimeType, desc, nameValue,
rc,
"FILENAME",fname);
      if (rc ne 0) then do;
          put "Entry_next failed.";
          msg = sysmsg();
          put msg;
          ABORT;
      end;

      put etype=;
      put mimeType=;
      put desc=;
      put nameValue=;
           put fname=;


     filename = "filename:" || fname;
      put "Retrieving "  filename;
      call retrieve_file(ehandle, filename,rc);
      if (rc ne 0) then do;
          put "Retrieve_file failed";
          msg = sysmsg();
          put msg;
          ABORT;
      end;



      count = count + 1;



   end; /* end do while numEntries */

run;quit;
