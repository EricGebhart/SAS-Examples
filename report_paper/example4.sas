options obs=5;


ods html file="example3.html";

Proc Report data=sashelp.class nowd ;
   columns  sex name age height weight ratio;

   define sex    / group     'Gender' width=6;
   define name   / display   'Name'   width=10;  
   define age    / display   'Age'    width=4;
   define height / analysis mean 'Height' format=8.1; 
   define weight / analysis mean 'Weight' format=8.1; 
   define ratio  / computed   format=6.2;
   
   compute ratio;
     ratio = height.mean / weight.mean;
   endcompute;
   break after sex / summarize;
   
run;

ods html close;
