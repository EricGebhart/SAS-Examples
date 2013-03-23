/*Print Margins can be controlled like this.  */

options topmargin=1in
         bottommargin=1in
         leftmargin=.5in
         rightmargin=.5in;


/* borderwidth of 1 should turn borders off.  2 turns them on. */
/* every other app takes 0 as off.  But not Excel                         */

/* Parskip controls the space between things...                         */

proc template;
    define style styles.XLPrinter ;
        parent = styles.Printer;

        style Body from Body /
            topmargin=.5in
            leftmargin=.25in;

        style Table from Table /
            background=white
            borderwidth=0;

        style Header from Header /
            borderwidth=0;

        style CHeader from Header /
            just=c;

        style Top_Header from Header /
            vjust=t;

        style Top_Data from Data /
            vjust=t;

        style Hyperlink from Data /
            foreground=blue;

        style ContentItem from ContentItem /
            foreground=blue;

       style SystemFooter from SystemFooter /
            just=l;

        style RowHeader from RowHeader /
            borderwidth=1;

        style Data from Data /
            borderwidth=1;

        style DataMissing from Data /
            borderwidth=1;

        style parskip /
            cellheight=16;

    end;
    

run; quit;

footnote "This is a footnote";
footnote "This is a title";


footnote link="#Contents!A1" "Return to Contents";

ods html file="test.html";

ods tagsets.excelxp file="t12.xls" style=XLPrinter 
       options(embedded_titles='yes'
                embedded_footnotes='yes'
                contents='no'
                index='yes'
                );

proc report nowd style(header)=Top_Header  data=sashelp.class;
run;



proc print data=sashelp.class;
run;

ods _all_ close;
