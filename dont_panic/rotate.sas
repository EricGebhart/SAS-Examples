
proc template;
    define style styles.mystyle;
        parent=styles.Meadow;

        style vertical_header from header /
            tagattr = 'rotate:45'
        ;
     end;
run;

 
/*---------------------------------------------------------------eric-*/
/*-- Column widths will be too wide because the tagset thinks the   --*/
/*-- headers are horizontal...                                      --*/
/*------------------------------------------------------------10Jan06-*/
ods tagsets.excelxp    style=mystyle file="rotate.xls";

proc print data=sashelp.class;
    var name / style (header) = vertical_header;
    var age sex;
    var weight height / style (header)= vertical_header;
run;

ods _all_ close;

