proc template;
  define style styles.mymeadow;
    parent=styles.meadow;

      style hidden from data/
        tagattr="wrap:no"
    ;
end;
run;

ods tagsets.excelxp file="example7.xls" style=mymeadow options(wraptext='no' doc='help');

proc report data=sashelp.class nowd; 
   column Name Sex Age Weight Height; 
   define Weight / display; 

   compute Weight; 
      if (Weight > 100) then do; 
         CALL DEFINE(_ROW_, "STYLE", 
         "STYLE=data[tagattr='wrap:yes']"); 
      end; 
   endcomp; 
run;


ods _all_ close
