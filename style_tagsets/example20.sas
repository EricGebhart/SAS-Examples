proc template;
  define style styles.mymeadow;
    parent=styles.meadow;

      style double_data from data/
        borderstyle=double
        bordertopwidth=1
        borderbottomwidth=1
        borderleftwidth=1
        borderrightwidth=1
    ;
end;
run;

ods tagsets.excelxp file="example20.xls" style=mymeadow;

proc report data=sashelp.class nowd; 
   column Name Sex Age Weight Height; 
   define Weight / display; 

   compute Weight; 
      if (Weight > 100) then do; 
         CALL DEFINE(_ROW_, "STYLE", 
         "STYLE=double_data"); 
      end; 
   endcomp; 
run;


ods _all_ close
