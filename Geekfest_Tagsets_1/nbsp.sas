/*
  Lots of people don't notice. Other people hate the space created 
  by the non-breaking space. Using tagsets it is possible to change 
  the anchor to anything you want, or even remove it. This is what 
  you would do. 
*/

proc template; 

  define tagset tagsets.myhtml; 
    parent=tagsets.htmlcss; 

    define event anchor;  
      putq "<a name=" NAME ">" NL / exists(NAME);  
    end; 

  end; 

run; 

ods tagsets.myhtml file="nbsp.html";

proc print data=sashelp.class;
run;

ods _all_ close;

