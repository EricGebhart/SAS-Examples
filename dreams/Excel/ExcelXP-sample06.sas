 /****************************************************************/
 /*          S A S   S A M P L E   L I B R A R Y                 */
 /*                                                              */
 /*    NAME: ODSTAB1                                             */
 /*   TITLE: Demonstrates Use of PRELOADFMT with PROC TABULATE   */
 /* PRODUCT: BASE                                                */
 /*  SYSTEM: ALL                                                 */
 /*    KEYS: ODS HTML BODY=                                      */
 /*   PROCS: TABULATE                                            */
 /*    DATA:                                                     */
 /* SUPPORT:                             UPDATE:                 */
 /*     REF:                                                     */
 /*    MISC:                                                     */
 /*                                                              */
 /****************************************************************/

title1 '*** odstab1: Demonstrates use of PreLoadFmt ***';
footnote;

options ps=60 ls=80 nostimer center;

proc format;
   value regfmt(notsorted)
      3='North'
      4='South'
      1='East'
      2='West'
      5='Texas'
      6='California';

   value habfmt(notsorted)
      2='Rural'
      1='Urban'
      3='Burbs';

   value sexfmt(notsorted)
      2='Male'
      1='Female';
run; quit;

*  Create some test data;

data one;
  retain seed1 543 seed2 1234;
  drop j ind;
  label y='Number of years of schooling';
  format region regfmt. sex sexfmt. habitat habfmt.;
  do region = 1 to 4;
     if (region = 1) then
        do habitat = 1 to 3;
           do sex = 1 to 2;
              call ranuni( seed1, ind );
              ind = int( ind * 20 ) + 2;
              do j= 1 to ind;
                 call rannor( seed2, y );
                 y = int( y * 3 + 13 );
                 output;
              end;
           end;
        end;
     else
        do habitat = 1 to 2;
           do sex = 1 to 2;
              call ranuni( seed1, ind );
              ind = int( ind * 20 ) + 2;
              do j= 1 to ind;
                 call rannor( seed2, y );
                 y = int( y * 3 + 13 );
                 output;
              end;
           end;
        end;
  end;
  drop seed1 seed2;
run;

data clsdat;
input region sex habitat;
format region regfmt. sex sexfmt. habitat habfmt.;
cards;
2 1 3
2 1 2
2 1 1
2 2 3
2 2 2
2 2 1
4 1 3
4 1 2
4 1 1
4 2 3
4 2 2
4 2 1
;
run;

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
*  PROC TABULATE is not setting column widths.  So we must force them
*  with default_column_width.  The value "7" is used for all columns.
*;

ods listing close;
ods &_ODSDEST path='c:\temp' file='ExcelXP-sample06.xml' style=&_ODSSTYLE options(autofilter='3-11' frozen_headers='yes' frozen_rowheaders='yes' default_column_width='7');
  title2 'Standard V6 type Tabulate';

  proc tabulate data=one;
    class region sex habitat;
    var y;
    table region*sex, habitat*y*(min max median);
  run; quit;
ods &_ODSDEST close;
