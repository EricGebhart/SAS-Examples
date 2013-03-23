*;
*  Prepare the sample data.
*;

proc sort data=sashelp.class out=class; by age; run; quit;

*  Modify the Statistical style to fix missing border lines;

proc template;
  define style styles.XLStatistical;
    parent = styles.Statistical;
    style Header from Header /
      borderwidth=2;
    style RowHeader from RowHeader /
      borderwidth=2;
    style Data from Data /
      borderwidth=2;
  end;
run; quit;

%let _ODSDEST=tagsets.ExcelXP;
%let _ODSSTYLE=XLStatistical;

title; footnote;

*;
*  Use the SHEET_INTERVAL option to force all BY groups into a single worksheet.  Subtotals will be
*  added to the HEIGHT and WEIGHT fields as a result of the SUM statement.
*;

ods listing close;
ods &_ODSDEST file='ExcelXP-sample10.xml' style=&_ODSSTYLE options(sheet_interval='none' auto_subtotals='yes');
  proc print data=class;
    by age; 
    id name;
    sum height weight;
  run; quit;
ods &_ODSDEST close;
