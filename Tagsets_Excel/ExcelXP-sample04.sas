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
ods &_ODSDEST path='c:\temp' file='ExcelXP-sample04.xml' style=&_ODSSTYLE options(autofilter='1-2' frozen_headers='yes' frozen_rowheaders='yes');
  *;
  *  NOTE:  The CROSSLIST option is required to get all the data into a single table.
  *
  *  From Eric G. (10/14/2004):
  *
  *  Vince - You are looking at freq crosstabs.  It is the least conformant of all the procs.  Tim is working on it but 
  *  it will be next year before we can expect anything decent from it.  You can add the crosslist option.  That 
  *  will fix this particular case.  The reason you get two worksheets is because it is two tables.  One is the legend
  *  for the other. 
  *;

  proc freq data=sashelp.class;
    tables height*sex / crosslist;
  run; quit;
ods &_ODSDEST close;