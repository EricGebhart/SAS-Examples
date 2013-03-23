
title;
footnote;

%let MYHEADER=This is my header;
%let MYFOOTER=This is my footer;

ods tagsets.excelxp file='t8.xls' 
        options(embedded_titles='yes'
                 embedded_footnotes='yes' 
                 print_header="&MYHEADER" 
                 print_footer="&MYFOOTER");

  proc print data=sashelp.class; run; quit;

ods _all_ close;
