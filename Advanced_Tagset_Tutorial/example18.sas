Proc Template;
define tagset tagsets.test;         

    define event byline;
        put "Byline: " value nl;
        putvars $byvars _name_ ': ' _value_ nl;
        put "===============" nl;
    end;
          
end; Run;

proc sort data=sashelp.class out=myclass;
    by age sex;
run;


ods tagsets.test file="example18.txt";

proc report;
   by age sex;
run;   
 
ods tagsets.test close;
