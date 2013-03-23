
/* this creates the archive c:\temp\testPackage.spk"      */
/* after running this one, it appears to create the files */
/* contents.html, frame.html, page.html                   */
/* body.html body1.html, body2.html, body3.html           */

ods package open;

ods html package  body='body.html' frame='frame.html'
             page='page.html' contents='contents.html' newfile=proc;


data b;x=1;run;
proc print;run;
proc datasets;quit;
proc contents;run;quit;

proc sort data=sashelp.class out=foo;
    by age;
run;
proc print ;
    by age;
run;


ods html close;
ods package publish archive properties(archive_name="testPackage" archive_path="c:\temp");

ods package close clear;





data _null_;
   length desc $256  nameValue $256  channel $64 mimeType $64 etype $20 filename $256;
   pid=0;rc=0;   total=0; plist=0;

   call retrieve_package(plist, "FROM_ARCHIVE", "c:\temp\testPackage", total, rc);
   if (rc ne 0) then do;
       put "Retrieve_package failed.";
       msg = sysmsg();
       put msg;
       ABORT;
   end;

   numEntries = 0;
   dateTime = 0;

   call package_first(plist, pid, numEntries, desc, dateTime, nameValue, channel, rc);
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
      call entry_next(pid, ehandle, etype, mimeType, desc, nameValue, rc);
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

               /*

      filename outfile "c:\temp\outfile.bin");
      call retrieve_file(ehandle, filename,rc);
      if (rc ne 0) then do;
          put "Retrieve_file failed";
          msg = sysmsg();
          put msg;
          ABORT;
      end;
*/

      count = count + 1;



   end; /* end do while numEntries */

run;quit;
