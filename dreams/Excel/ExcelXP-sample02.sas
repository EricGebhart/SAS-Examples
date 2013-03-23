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

*  Create some test data;

data prdsale;
  set sashelp.prdsale;
  Difference = actual-predict;
run;

proc sort data=prdsale; by country region division year; run; quit;

*;
*  Use Excel formulas to represent computed cells, and use an Excel format to force Excel to show negative 
*  currency values in red and with the format ($nnn).  In the formula below, the RC value corresponds
*  to the cell relative to the current cell.  For example, RC[-2] means "2 cells to the left of the current cell".
*  Any valid Excel formula can be used, and the formula used here matches the computation performed in the DATA step
*  that created the column.
*;

title; footnote;

ods listing close;
ods &_ODSDEST path='c:\temp' file='ExcelXP-sample02.xml' style=&_ODSSTYLE options(autofilter='all' frozen_headers='yes' frozen_rowheaders='yes' auto_subtotals='yes');
  proc print data=prdsale noobs label;
    id country region division;
    var prodtype product quarter month year;
    var predict actual / style={tagattr='format:$#,##0_);[Red]\($#,##0\)'};
    var difference / style={tagattr='format:$#,##0_);[Red]\($#,##0\) formula:RC[-1]-RC[-2]'};
    sum predict actual difference / style={tagattr='format:$#,##0_);[Red]\($#,##0\)'};;
  run; quit;

  proc print data=prdsale noobs label split='*';
    id country region division;
    var prodtype product quarter month year;
    var predict actual / style={tagattr='format:$#,##0_);[Red]\($#,##0\)'};
    var difference / style={tagattr='format:$#,##0_);[Red]\($#,##0\) formula:RC[-1]-RC[-2]'};
    sum predict actual difference / style={tagattr='format:$#,##0_);[Red]\($#,##0\)'};;
    label prodtype = 'Product*Type'
          predict  = 'Predicted*Sales'
          actual   = 'Actual*Sales';
  run; quit;
ods &_ODSDEST close;