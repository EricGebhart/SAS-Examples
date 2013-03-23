proc template;
 define tagset tagsets.example13;   
 
     define event data;
     trigger xenon;
     end;

     define event header;
     trigger xenon;
     end;


    define event xenon;
      put event_name ": " value nl;
      putvars event "   " _name_ ": " _value_ nl;
      putvars style "   " _name_ ": " _value_ nl;
      put "-------------------" nl;
    end;  
end;
run;

options obs=1;


ods tagsets.example13 file="example13.txt";

proc print data=sashelp.class;
    run;
    
     
ods _all_ close;

