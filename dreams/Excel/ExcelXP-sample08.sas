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

*;
*  By default, titles are placed in the header lines, and footnotes are placed in the footer lines.
*  As a result, "&" has a special meaning.  For example, "&D" will insert the current date.  If you
*  wish to use an "&" in a title or footnote, use two together.
*
*  12/24/2004: Justification is currently not working.
*;

title1 'Texas A&&M Students';
footnote1 'This document was printed on &D';

ods listing close;
ods &_ODSDEST path='c:\temp' file='ExcelXP-sample08.xml' style=&_ODSSTYLE;
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

  ods &_ODSDEST options(embedded_titles='yes');

  *;
  *  Force titles to be "embedded" within the worksheet.  As a result, "&" has no
  *  special meaning now, so just use one in the title.
  *;

  title1 'Texas A&M Students';
  footnote;

  proc print data=sashelp.class noobs label split='*';
    var name / style={just=r};
    var age sex / style={just=c};
    var height weight / style={just=l};

    label name   = 'Student*Name'
          age    = '*Age'
          sex    = '*Gender'
          height = 'Height*(inches)'
          weight = 'Weight*(pounds)';
  run; quit;
ods &_ODSDEST close;