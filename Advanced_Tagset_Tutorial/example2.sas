
proc template;

    define tagset tagsets.example2;
     
       define event basic;
           put event_name ": " value nl;
       end;

       define event header;
           trigger basic;
       end;

       define event data;
           trigger basic;
       end;
       
       define event row;
           start:
               put "===================" nl;
           finish:
               put "===================" nl;
       end;
    end;
run;

options obs=2;

ods tagsets.example2 file="example1.txt";       
proc print data=sashelp.class;
   run;
ods _all_ close; 
