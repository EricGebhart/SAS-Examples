options obs=5;


ods html file="example2.html";

Proc Report data=sashelp.class nowd;
   columns name sex age height weight ratio;

   define name   / display   'Name'   width=10;  
   define sex    / display   'Gender' width=6;
   define age    / display   'Age'    width=4;
   define height / analysis mean 'Height' format=8.1; 
   define weight / analysis mean 'Weight' format=8.1; 
   define ratio  / computed   format=6.2;
   
   compute ratio;
     ratio = height.mean / weight.mean;
   endcompute;
   rbreak after / summarize;
   
run;

ods html close;
