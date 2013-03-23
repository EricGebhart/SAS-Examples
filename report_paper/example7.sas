options obs=5;


ods html file="example5.html";

Proc Report data=sashelp.class nowd ;
   columns  sex name age height weight weight=weight2 weight_pct;

   define sex        / group     'Gender' width=6;
   define name       / display   'Name'   width=10;  
   define age        / display   'Age'    width=4;
   define height     / analysis mean  'Height' format=8.1; 
   define weight     / analysis noprint        format=8.1; 
   define weight2    / analysis mean  'Weight' format=8.1; 
   define weight_pct /  '% of Weight' format=8.2; 
   
   compute weight_pct;
       weight_pct = weight.sum / weight_sum;
   endcompute;

   compute before sex;
       weight_sum = weight.sum;
   endcompute;
   
   break after sex / summarize style=header;
   
run;

ods html close;
