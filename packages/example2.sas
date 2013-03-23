
proc document name=archive;
import archive="example1.zip" to myPackage;

list/levels=all;run;

dir myPackage;
list 'sashtml.htm'n/details; run;
