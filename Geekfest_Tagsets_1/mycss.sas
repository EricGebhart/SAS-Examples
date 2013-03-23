proc template; 

define tagset tagsets.mycss; 
  parent=tagsets.phtml; 

  define event system_title; 
    put "<h2"; 
    trigger align; 
    put ">"; 
    put VALUE;  
    put "" CR; 
  end; 

  define event system_footer; 
    put "<h2"; 
    trigger align; 
    put ">"; 
    put VALUE; 
    put "" CR; 
  end; 

  define event table; 
    start: 
      put "<div"; 
      trigger align; 
      put ">" CR; 
      put "<table";   
      putq " border=" BORDERWIDTH;  
      put ' border="1"' / if !exists(BORDERWIDTH);  
      putq ' cellspacing= "0"'; 
      putq ' cellpadding="5"' ; 
      putq " rules=" RULES; 
      putq " frame=" FRAME;  
      put ' class="main_table"'; 
      put ">" CR; 
    finish: 
      put "</table>" CR; 
      put "</div>" CR; 
      put "" CR; 
  end; 

  define event header; 
    start: 
      put "<th"; 
      trigger rowcol; 
      trigger headalign; 
      put ' class="thcell"'; 
      put ">"; 
      put VALUE;    
    finish: 
      put "</th>" CR; 
  end; 

  define event data; 
    start: 

    /* this is so we will get a header when we   
       are supposed to. Even if the proc   
       is not telling us it is a header. */ 

      trigger header /if cmp(section,"head");  
      break /if cmp(section, "head");  
      trigger header /if cmp(htmlclass, "rowheader");     
      break /if cmp (htmlclass,"rowheader"); 
      put "<td"; 
      trigger rowcol; 
      trigger align; 
      put ' class="tdcell"'; 
      put ">";  
      put '<pre>' /if exists(asis); 
      put VALUE; 
    finish:  
      trigger header /if cmp(section,"head");  
      break /if cmp(section, "head");  
      trigger header /if cmp(htmlclass,"rowheader"); 
      break /if cmp(htmlclass, "rowheader"); 
      put '</pre>' /if exists(asis); 
      put "</td>" CR;
  end; 
end; 
run; 

ods tagsets.mycss file="mycss.html"  
    stylesheet=(url="http://myserver/standard.css"); 

proc print data=sashelp.class;
run;

ods _all_ close;
