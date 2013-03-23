
proc template;

    define tagset tagsets.example5;

        indent = 2;
    
        define event put_all_vars;
           putvars event " " _name_ '="' _value_ '"';
           putvars style " " _name_ '="' _value_ '"';
           putvars mem   " " _name_ '="' _value_ '"';
       end;
       
       define event put_some_vars;
           putq " value=" value;
           putq " label=" label;
           putq " name="  name;
           putq " htmlclass=" htmlclass;
           putq " anchor=" anchor;
       end;
     
       define event basic;
           start:
               put "<" event_name; 
               trigger put_some_vars;
               put ">" nl;
               ndent;
           finish:
               xdent;
               put "</" event_name ">" nl; 
       end;

       define event header;
           start:
               trigger basic;
           finish:
               trigger basic;
       end;

       define event data;
           start:
               trigger basic;
           finish:
               trigger basic;
       end;
       
       define event row;
           start:
               trigger basic;
           finish:
               trigger basic;
       end;
    end;
run;

options obs=2;

ods tagsets.example5 file="example5.xml";       
proc print data=sashelp.class;
   run;
ods _all_ close; 
