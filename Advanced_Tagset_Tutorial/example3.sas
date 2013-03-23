
proc template;

    define tagset tagsets.example3;
     
       define event basic;
           put event_name ": " value nl;
           putvars event "   "  _name_ ": " _value_ nl;
           putvars style "   "  _name_ ": " _value_ nl;
           put "-------------------" nl;
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

ods tagsets.example3 file="example3.txt";       
proc print data=sashelp.class;
   run;
ods _all_ close; 
