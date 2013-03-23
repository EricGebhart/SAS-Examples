
proc template;

    define tagset tagsets.example1;
     
       define event header;
           put "Header: " value nl;
       end;

       define event data;
           put "Data: " value nl;
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

ods tagsets.example1 file="example1.txt";       
proc print data=sashelp.class;
   run;
ods _all_ close; 
