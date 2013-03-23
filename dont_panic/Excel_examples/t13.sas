
Proc template;
   define style styles.test;
     parent=styles.minimal;
       style data from data /
          borderwidth=2;
     end;
Run;   

/* sample code */
ods tagsets.excelxp
        options(frozen_headers='Yes' autofilter='All'
     /* sheet_interval='none'
        sheet_name="Oldies-%sysfunc(today(),mmddyy10.)"
        default_column_width='12, 16, 16, 16, 16, 16, 16, 16, 16'
     */
     /* debug_level='3' */
        embedded_titles='No')
        file="t13.xls"
        style=test ;

proc print data=sashelp.class(obs=1);
run;

ods _all_ close;
