proc template;
   define style styles.mystyle;
          parent=styles.default;

   style classlev from header/
        vjust=middle
        just=center
   ;
   end;
run;
   
 

ods _all_ close ;
ods tagsets.excelxp file="demo.rts.alignment.xls" style=mystyle;
ods html            file="demo.rts.alignment.html" style=mystyle; * for comparison;
proc tabulate data= sashelp.class  format= 3. ;
  class    sex name ;
  classlev sex name /STYLE=classlev ; *effective on html ;
  table    sex*name, n ;
run;
ods _all_ close;
