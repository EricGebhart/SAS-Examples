
proc template;
    list tagsets;
run;


ods tagsets.style_display file="exampleA.html";
proc print data=sashelp.class;
run;
ods tagsets.style_display close;

