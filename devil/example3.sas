proc sort data=sashelp.class out=example;
     by age sex;

ods tagsets.Excelxp file="example3.xls" style=Journal3
    options(sheet_interval = 'bygroup'
            sheet_label = ' '
            index = 'yes'
            contents = 'yes'
            embedded_titles = 'yes'
            embed_titles_once = 'yes');

title link="#Contents!A1" "Return to Contents";
title2 link="#Worksheets!A1" "Return to Index";

proc print data=example;
     by age sex;
     pageby age;
run;

ods _all_ close;
