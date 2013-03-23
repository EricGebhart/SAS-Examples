proc template;
 define tagset tagsets.example14;   
 
     define event data;
     trigger basic;
     end;

     define event header;
     trigger basic;
     end;

     define event basic;
     start:
         put "<" event_name;
         trigger halogen;
         put ">" nl;
         ndent;
     finish:
         xdent;
         put "</" event_name ">" nl;
     end;  

     define event halogen;
         putq " value= " value ;
         putq " label= " label ;
         putq " name= "  name ;
         putq " htmlclass= " htmlclass ;
         putq " section= " section ;
         putq " anchor= " anchor ;
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


ods tagsets.example14 file="example14.xml";

proc print data=sashelp.class;
    run;
    
     
ods _all_ close;

