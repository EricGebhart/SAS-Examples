Proc Template;
define tagset tagsets.test;         

    define event byline;
        put "Byline: " value nl;
        set $mybyline "By var #byvar1 and By Val #byval1";
        put $mybyline nl;
        put "===============" nl;
    end;
          
end; Run;

proc sort data=sashelp.class out=myclass;
    by age sex;
run;


ods tagsets.test file="example19.txt";

proc report;
   by age sex;
run;   
 
ods tagsets.test close;
