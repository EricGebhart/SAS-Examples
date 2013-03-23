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
*  Illustrate the use of split characters and column justification.  Use WIDTH_FUDGE to
*  get slightly wider columns (default value is "0.75").
*
*  12/24/2004: Justification is currently not working.
*;

ods listing close;
ods &_ODSDEST path='c:\temp' file='ExcelXP-sample07.xml' style=&_ODSSTYLE options(width_fudge='0.8');
  proc print data=sashelp.class noobs label split='*';
    var name          / style={just=r};
    var age sex       / style={just=c};
    var height weight / style={just=l};

    label name   = 'Student*Name'
          age    = '*Age'
          sex    = '*Gender'
          height = 'Height*(inches)'
          weight = 'Weight*(pounds)';
  run; quit;

  *;
  *  PROC REPORT is not setting column widths.  So we must force them with
  *  default_column_width.  Reset WIDTH_FUDGE to the default value of "0.75".
  *;

  ods &_ODSDEST options(default_column_width="7.5, 7.5, 5, 7.5, 7.5" width_fudge='0.75');

  proc report data=sashelp.class nowindows split='*';
    column  name sex age height weight;
    define  name   / display   'Student*Name'     left    style={just=l};
    define  sex    / display   '*Gender'          right   style={just=r};
    define  age    / display   '*Age'             center  style={just=c};
    define  height / display   'Height*(inches)'  center  style={just=c};
    define  weight / display   'Weight*(pounds)'  center  style={just=c};
  run; quit;
ods &_ODSDEST close;