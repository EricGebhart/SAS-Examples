proc template;
    define style styles.mymeadow;
    parent=styles.meadow;

    /* borderwidth doesn't work because the parent defines left and top of 0 */
    style double_data from data/
        borderstyle=double
        bordertopwidth=1
        borderbottomwidth=1
        borderleftwidth=1
        borderrightwidth=1
        bordertopcolor=cx003399
        borderbottomcolor=cx003399
        borderleftcolor=cx003399
        borderrightcolor=cx003399
    ;
        
    end;
run;
    
    

ods tagsets.excelxp file='example10.xls' style=mymeadow ; 
ods html file='example10.html' style=mymeadow; 

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

ods _all_ close; 

