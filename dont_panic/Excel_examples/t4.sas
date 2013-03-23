options topmargin=1in
         bottommargin=1in
         leftmargin=.5in
         rightmargin=.5in;


proc template;
    define style styles.XLStatistical ;
        parent = styles.Statistical;

        style Body from Body /
            topmargin=.5in
            leftmargin=.25in;

        style Header from Header /
            borderwidth=2;

        style CHeader from Header /
            just=c;

        style RowHeader from RowHeader /
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

data a;
   input car1-car3;
   cards;
. . .
. . .
. . .
. . .
. . .
. . .
;

ods tagsets.excelXP file="t4.xls" style=XLStatistical ;

title2 'data are missing';
proc report nowd style(header)=CHeader;
run;

proc print;
run;


ods tagsets.excelxp
    options(embedded_titles='yes' 
             sheet_interval='none' 
             pagebreaks='yes'
             /*debug_level='3'*/
             scale='75'
             );

title "This is title1";
title2 "This is title 2";
title3 "This is title 3";

proc sort data=sashelp.class out=work.foo;
    by age sex;
run;

proc print;
    by age sex;
run;


ods tagsets.excelxp 
    options(skip_space='2,1');

title "This is a different title1";
title2 "This is different title 2";
title3 "This is title 3";

proc print;
    by age;
run;

ods tagsets.excelxp options(sheet_interval='none');

proc report nowd style(header)=CHeader;
run;

ods tagsets.excelxp 
    options(skip_space='1,0' sheet_interval='bygroup');

ods tagsets.short_map file="map.xml";

proc sort data=sashelp.class out=work.foo;
    by age  sex;
run;

Title "SEX is #BYVAL(SEX)";
Title2;
Title3;

proc report nowd style(header)=CHeader;
    by age sex;
run;


Ods _all_ close;

