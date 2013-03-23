options topmargin=1in
         bottommargin=1in
         leftmargin=.5in
         rightmargin=.5in;

options nocenter;


proc template;
    define style styles.XLStatistical ;
        parent = styles.Statistical;

        Style Body from Body /
            topmargin=.5in
            leftmargin=.25in;

        style Header from Header /
            borderwidth=2;

        style CHeader from Header /
            just=c;

        Style RowHeader from RowHeader /
            borderwidth=2;

        style Data from Data /
            borderwidth=2;

        style parskip /
            cellheight=32;

        style pagebreak /
            cellheight=8pt
            foreground=black
            tagattr="HorzStripe";
    end;
run; quit;   


Ods tagsets.excelxp file="t2.xls" style=XLStatistical 
    options(embedded_titles='yes' 
             sheet_interval='none' 
             row_repeat='header'
             column_repeat='header'
             pagebreaks='yes'
             scale='75'
             row_height_fudge='8'
             );

title "This is title1";
title2 "This is title 2";
title3 "This is title 3";

proc sort data=sashelp.class out=work.foo;
    by age  sex;
run;

proc print;
    by age sex;
run;


ods tagsets.excelxp 
    options(skip_space='2,1' 
             row_height_fudge='4'
             row_heights='18, 20, 30, 30, 10, 18');

title "This is a different title1";
title2 "This is different title 2";
title3 "This is title 3";

proc print;
    by age;
run;

ods tagsets.excelxp options(sheet_interval='none');

proc report nowd style(header)=CHeader;
run;

Ods tagsets.excelxp 
    options(skip_space='1,0' sheet_interval='bygroup');

proc sort data=sashelp.class out=work.foo;
    by age  sex;
run;

Title "AGE is #BYVAL(AGE)";
Title2;
Title3;

PROC TABULATE DATA=foo;
   VAR Height Weight;
   CLASS Sex Age;
   TABLE Age*Mean ALL*Sex*Mean,
         Weight;
   by age;
   
RUN;


/*
proc tabulate data=foo order=data;
    var name age sex;
    table age*sex;
    by age sex;
run;
*/

Title "SEX is #BYVAL(SEX)";

proc report;
    by age sex;
run;

ods tagsets.excelxp 
    options(pagebreaks='no' embed_titles_once='yes');

Title "AGE is #BYVAL(AGE)";

proc report;
    by age sex;
run;


Ods _all_ close;

