proc sort data=sashelp.class out=example;
     by age sex;
run;


     ods tagsets.Excelxp file="example4.xls" contents="example4_contents.xls"
                newfile=proc;

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
run;

proc print data=example;
     by age sex;
run;

ods _all_ close;
