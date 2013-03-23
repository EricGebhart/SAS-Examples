
ods html file="example1.html";

Proc Report data=sashelp.class nowd;
   columns name sex age height weight;

   define name   / display   'Name'   width=10;  
   define sex    / display   'Gender' width=6;
   define age    / display   'Age'    width=4;
   define height / analysis  'Height' format=8.1; 
   define weight / analysis  'Weight' format=8.1; 
run;

ods html close;
