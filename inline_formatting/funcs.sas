options nodate nonumber;
ods escapechar="*" ;
ods listing close ; 
*ods pdf file="funcs.pdf";
ods html file="funcs.html";
ods rtf file="funcs.rtf";
*ods tagsets.rtf file="funcs.rtf " ;  
    
title "test *{style [foreground=red] of  *{super *{unicode ALPHA} 
*{style [foreground=green] text}} formatting } and such" ;  
 
title2 "test of 
*{style [foreground=red] red 
*{style [foreground=green] green} and
*{style [foreground=blue] blue} formatting } and such" ;   

title3 "test of *{super
*{style [foreground=red] red 
*{style [foreground=green] green } and 
*{style [foreground=blue] blue } formatting }} and such" ;

title4 "test of *{super
*{style [foreground=red] red 
*{style [foreground=green] green } 
*{style [fontsize=18pt] 
and 
*{style [foreground=blue] blue }
} formatting }} 
and such ";

proc print data=sashelp.class(obs=1) ; run;

ods _all_ close ; 
