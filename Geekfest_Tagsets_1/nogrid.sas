
proc template;

    define style styles.nogrid;
    parent=styles.minimal;
 
    /* ----- */
    replace Output /
       BorderWidth = 0
       CellSpacing = 1
       CellPadding = 7
       Frame = void
       Rules = none
    ;
    
end;

    define style styles.nogrid2;
    parent=styles.default;
 
    /* ----- */
    replace Output /
       BorderWidth = 0
       CellSpacing = 0
       CellPadding = 7
       Frame = void
       Rules = none
    ;
    
end;

run;

ods html style=nogrid file="test.html";
ods html(id=1) style=nogrid2 file="test2.html";

proc print data=sashelp.class;
run;

ods _all_ close;    
