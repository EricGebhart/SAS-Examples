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

ods listing close;
ods &_ODSDEST path='c:\temp' file='ExcelXP-sample03.xml' style=&_ODSSTYLE options(autofilter='1' frozen_headers='yes' frozen_rowheaders='yes');
  proc freq data=sashelp.class;
    tables sex;
  run; quit;
ods &_ODSDEST close;