ods tagsets.excelxp file='example8.xls' style=meadow ;
ods html file='example8.html' style=meadow; 

proc report data=sashelp.class nowd; 
   column Name Sex Age Weight Height; 
   define Weight / display; 

   compute Weight; 
      if (Weight > 100) then do; 
         CALL DEFINE(_ROW_, "STYLE", 
         "STYLE=[border_style=double border_width=1]"); 
      end; 
   endcomp; 
run; 

ods _all_ close; 

