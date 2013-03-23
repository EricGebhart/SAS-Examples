
proc template;

    define tagset tagsets.example4;

        define event put_all_vars;
           put "*******************" nl;
           putvars event "   "  _name_ ": " _value_ nl;
           putvars style "   "  _name_ ": " _value_ nl;
           putvars mem "   "  _name_ ": " _value_ nl;
           put "*******************" nl;
       end;
       
       define event put_some_vars;
           put "value: " value nl;
           put "label: " label nl;
           put "name: "  name nl;
           put "htmlclass: " htmlclass nl;
           put "section: " section nl;
           put "section: " section nl;
           put "anchor: " anchor nl;
       end;
     
       define event basic;
           put event_name ": " nl;
           trigger put_some_vars;
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

ods tagsets.example4 file="example4.txt";       
proc print data=sashelp.class;
   run;
ods _all_ close; 
