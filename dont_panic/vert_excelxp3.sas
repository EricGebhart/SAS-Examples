/*---------------------------------------------------------------eric-*/
/*-- Column widths will be too wide because the tagset thinks the   --*/
/*-- headers are horizontal...                                      --*/
/*------------------------------------------------------------10Jan06-*/

proc template;
    define style styles.mystyle;
        parent=styles.default;

        style vertical_header from header /
            tagattr = 'rotate:45'
        ;
     end;
run;

ods tagsets.excelxp 
            style=mystyle
            file="test.xls" 
            options(absolute_column_width="4,8,4,3,4,5" 
                    row_heights="30" 
                   );

proc print data=sashelp.class;
    var name / style(header) = vertical_header;
    var age sex;
    var weight height / style(header) = vertical_header;
run;

ods _all_ close;

