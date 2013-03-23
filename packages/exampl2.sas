proc document name=archive(write);
import archive="example1.zip" to mypackage;
run;
quit;

proc document name=archive;run;
 list;run;


import archive="example1.zip" to myPackage;



list/levels=all;run;



dir myPackage;
list 'sashtml.htm'n/details; run;
