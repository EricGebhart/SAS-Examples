ods tagsets.slider file='example6.html' style=slider options(doc='help' aural_headers='no');
 
options obs=5;
 
 
Proc Report data=sashelp.class nowd ;
   columns  sex name age height weight weight=weight2 weight_pct;
 
   define sex        / group     'Gender' width=6;
   define name       / display   'Name'   width=10; 
   define age        / display   'Age'    width=4;
   define height     / analysis mean  'Height' format=8.1;
   define weight     / analysis noprint        format=8.1;
   define weight2    / analysis mean  'Weight' format=8.1;
   define weight_pct /  '% of Weight' format=Percent6. left style(column)=bar[tagattr="slider"];
  
   compute weight_pct;
       weight_pct = weight.sum / weight_sum;
   endcomp;
 
   compute before sex;
       weight_sum = weight.sum;
   endcomp;
  
   break after sex / summarize style=header;
  
run;
 
ods tagsets.slider close;
 
