proc template;
  define style styles.mymeadow;
    parent=styles.meadow;

      style hidden from data/
        tagattr="hidden:yes"
    ;
end;
run;

ods tagsets.excelxp file="example5.xls" style=mymeadow;

proc report data=sashelp.class nowd; 
   column Name Sex Age Weight Height; 
   define Weight / display; 

   compute Weight; 
      if (Weight > 100) then do; 
         CALL DEFINE(_ROW_, "STYLE", 
         "STYLE=hidden"); 
      end; 
   endcomp; 
run;


ods _all_ close
