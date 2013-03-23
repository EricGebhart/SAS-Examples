proc template;
    
define style styles.mystyle;
    parent = styles.default;

    style myheader from header /
        foreground=black
        font_size=3
        just=c
    ;
    style whiteheader from header /
          foreground=black
          background=white
   ;
    style silverheader from whiteheader /
          background=silver
   ;
    
   style summary /
         foreground=BLACK
         text_decoration=underline
         textindent= 5
   ;
   end;

run;


ODS TAGSETS.EXCELXP style=mystyle FILE="test.xls"
OPTIONS(EMBEDDED_TITLES='YES'
SHEET_NAME='WEEKLY' FROZEN_HEADERS='3');
RUN;

/*
PROC REPORT NOWD DATA=W_W 
STYLE(HEADER)=myheader
STYLE(COLUMN)=whiteheader
STYLE(SUMMARY)=silverheader;
TITLE "NH WEEKLY METRO";
COLUMN MARKET NAME REPORTING COUNTY NITHHWK1-NITHHWK4;
DEFINE MARKET / GROUP RIGHT;
DEFINE NAME / GROUP;
DEFINE REPORTING / GROUP;
DEFINE COUNTY / ORDER CENTER;
DEFINE NITHHWK1 / SUM '1 NIT';
DEFINE NITHHWK2 / SUM '2 NIT';
DEFINE NITHHWK3 / SUM '3 NIT';
DEFINE NITHHWK4 / SUM '4 NIT';
BREAK AFTER MARKET/ SUMMARIZE SUPPRESS SKIP
STYLE(SUMMARY)=summary;
RUN; 
*/

PROC REPORT NOWD DATA=sashelp.class 
STYLE(HEADER)=myheader
STYLE(COLUMN)=whiteheader
STYLE(SUMMARY)=silverheader;
TITLE "NH WEEKLY METRO";
COLUMN NAME sex age weight;
DEFINE sex / GROUP RIGHT;
DEFINE NAME / GROUP;
BREAK AFTER sex/ SUMMARIZE SUPPRESS SKIP
STYLE(SUMMARY)=summary;
RUN; 


ods _all_ close;
