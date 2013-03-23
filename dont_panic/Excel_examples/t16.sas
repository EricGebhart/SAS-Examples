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

        style Header from Header /
            borderwidth=1;

        style CHeader from Header /
            just=c;

        style Top_Header from Header /
            vjust=t;

        style Top_Data from Data /
            vjust=t;

       style SystemFooter from SystemFooter /
            just=l;

        style RowHeader from RowHeader /
            borderwidth=1;

        style Data from Data /
            borderwidth=1;

        style DataMissing from Data /
            borderwidth=0;

        style parskip /
            cellheight=16;

    end;
    

run; quit;

footnote "This is a footnote";

ods tagsets.excelxp file="t16.xls" contents="t16c.xls" style=XLPrinter 
                    options(embedded_titles='yes' contents='yes' index='yes' Contents_file='All');

proc report nowd style(header)=CHeader  data=sashelp.class;
run;


proc print split='*' data=sashelp.class;
    label age='This is age'
           sex='This is Sex';
run;


proc print split='*' data=sashelp.class;
    label age='This*is age'
           sex='This*is*Sex';
run;

ods tagsets.excelxp options(absolute_column_width='6');

proc print split='*' data=sashelp.class;
    label age='This is age'
           sex='This is Sex';
run;


/*
proc print data=exprev split='*' n obs='Observation*Number*===========';
   var month state expenses;
   label month='Month**====='          
         state='State**====='  
         expenses='Expenses**========';
                format expenses comma10.;    
  title 'Monthly Expenses for Offices in Each State';
run;
*/
ods _all_ close;
