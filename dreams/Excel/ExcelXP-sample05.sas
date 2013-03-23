 /****************************************************************/
 /*          S A S   S A M P L E   L I B R A R Y                 */
 /*                                                              */
 /*    NAME: ODSREP4                                             */
 /*   TITLE: Demonstrates Embedded Links with PROC REPORT        */
 /* PRODUCT: BASE                                                */
 /*  SYSTEM: ALL                                                 */
 /*    KEYS: ODS HTML FILE= ANCHOR=                              */
 /*   PROCS: REPORT                                              */
 /*    DATA:                                                     */
 /* SUPPORT:                             UPDATE:                 */
 /*     REF:                                                     */
 /*    MISC:                                                     */
 /*                                                              */
 /****************************************************************/

title1 '*** odsrep4: Demonstrates Report Embedded Links ***';
title3 'This is title 3';

footnote1 'This is footnote 1.';
footnote3 'This is footnote 3.';

options ps=100 ls=150;

*  Create some test data;

data work.trial;
input patient $4. +1 
      sex  $1. +1 
      drug $1. +1 
      dosage $3. +1 
      Visitdate mmddyy8. +1 
      systolic 
      diastolic 
      fever 
      nausea 
      rash 
      visit;
cards;
1813 F A 400 01/08/91 109 73 1 . . 1
1813 F A 400 01/15/91 109 73 . . . 2
1813 F A 400 01/22/91 107 73 . 1 . 3
1813 F A 400 01/29/91 109 73 . . . 4
1813 F A 400 02/05/91 100 74 1 1 . 5
1813 F A 400 02/12/91 114 73 1 1 . 6
1826 F B 200 01/09/91 125 89 . 1 . 1
1826 F B 200 01/16/91 124 89 . . . 2
1826 F B 200 01/23/91 123 86 . . . 3
1826 F B 200 01/30/91 122 86 . 1 . 4
1826 F B 200 02/06/91 120 90 1 1 . 5
1826 F B 200 02/13/91 119 89 . 1 . 6
1839 M B 400 01/10/91 149 108 . 1 . 1
1839 M B 400 01/17/91 147 108 1 1 . 2
1839 M B 400 01/24/91 144 110 1 1 . 3
1839 M B 400 01/31/91 141 108 1 . . 4
1839 M B 400 02/07/91 138 109 1 1 . 5
1839 M B 400 02/14/91 135 105 1 . . 6
1852 F B 400 01/11/91 148 71 . . . 1
1852 F B 400 01/18/91 146 73 . . . 2
1852 F B 400 01/25/91 143 71 . 1 . 3
1852 F B 400 02/01/91 140 74 1 1 1 4
1852 F B 400 02/08/91 137 73 . 1 1 5
1852 F B 400 02/15/91 134 72 1 . . 6
1865 F B 400 01/07/91 111 61 . 1 . 1
1865 F B 400 01/14/91 109 63 1 1 1 2
1865 F B 400 01/21/91 120 61 1 1 1 3
1865 F B 400 01/28/91 117 62 1 1 1 4
1865 F B 400 02/04/91 110 63 . 1 1 5
1865 F B 400 02/11/91 114 60 1 1 . 6
1878 F A 200 01/08/91 118 86 1 1 . 1
1878 F A 200 01/15/91 118 82 1 1 . 2
1878 F A 200 01/22/91 107 86 1 . . 3
1878 F A 200 01/29/91 115 87 1 1 . 4
1878 F A 200 02/05/91 110 86 . . 1 5
1878 F A 200 02/12/91 109 87 1 1 1 6
1891 M B 400 01/09/91 103 101 . 1 . 1
1891 M B 400 01/16/91 103 101 1 1 . 2
1891 M B 400 01/23/91 100 101 1 1 . 3
1891 M B 400 01/30/91 105 98 . 1 . 4
1891 M B 400 02/06/91 108 101 1 1 . 5
1891 M B 400 02/13/91 101 101 1 . . 6
1904 M A 400 01/10/91 124 102 1 . . 1
1904 M A 400 01/17/91 123 104 1 1 . 2
1904 M A 400 01/24/91 122 103 1 . . 3
1904 M A 400 01/31/91 121 102 1 1 1 4
1904 M A 400 02/07/91 120 106 . . . 5
1904 M A 400 02/14/91 118 104 . 1 . 6
1917 M B 200 01/11/91 102 85 . 1 . 1
1917 M B 200 01/18/91 100 85 1 1 . 2
1917 M B 200 01/25/91 100 85 1 1 . 3
1917 M B 200 02/01/91 115 85 . 1 1 4
1917 M B 200 02/08/91 113 84 1 1 . 5
1917 M B 200 02/15/91 100 85 . 1 1 6
1930 M A 200 01/07/91 106 64 1 1 . 1
1930 M A 200 01/14/91 100 66 1 . . 2
1930 M A 200 01/21/91 102 67 . . . 3
1930 M A 200 01/28/91 100 64 1 1 1 4
1930 M A 200 02/04/91 100 60 . . . 5
1930 M A 200 02/11/91 100 62 1 . 1 6
1943 F B 200 01/08/91 137 62 . 1 . 1
1943 F B 200 01/15/91 136 60 1 . 1 2
1943 F B 200 01/22/91 135 62 . 1 . 3
1943 F B 200 01/29/91 133 62 1 . 1 4
1943 F B 200 02/05/91 132 60 1 . . 5
1943 F B 200 02/12/91 131 62 1 1 . 6
1956 M B 400 01/09/91 149 92 1 1 . 1
1956 M B 400 01/16/91 147 93 1 1 . 2
1956 M B 400 01/23/91 144 92 . . 1 3
1956 M B 400 01/30/91 141 90 1 1 . 4
1956 M B 400 02/06/91 138 91 1 . . 5
1956 M B 400 02/13/91 135 94 1 1 . 6
1969 F B 400 01/10/91 116 68 1 1 . 1
1969 F B 400 01/17/91 117 69 . 1 1 2
1969 F B 400 01/24/91 103 68 1 . . 3
1969 F B 400 01/31/91 119 69 1 . . 4
1969 F B 400 02/07/91 100 71 . . 1 5
1969 F B 400 02/14/91 120 66 . 1 1 6
1982 M B 400 01/11/91 136 80 . 1 . 1
1982 M B 400 01/18/91 134 83 1 1 . 2
1982 M B 400 01/25/91 131 79 1 1 . 3
1982 M B 400 02/01/91 128 80 . . . 4
1982 M B 400 02/08/91 126 80 1 1 . 5
1982 M B 400 02/15/91 123 79 . . 1 6
1995 M A 400 01/07/91 121 93 1 . . 1
1995 M A 400 01/14/91 120 93 . 1 1 2
1995 M A 400 01/21/91 119 93 1 1 . 3
1995 M A 400 01/28/91 118 93 1 1 . 4
1995 M A 400 02/04/91 117 93 . 1 . 5
1995 M A 400 02/11/91 115 96 . 1 . 6
;
run;

proc format;
  value sympfmt  0-1   = 'x'
                 other = ' ';
run; quit;

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

ods listing close;

*;
*  As is often the case with TABULATE, the PROC REPORT is not setting column widths.  So we must force
*  them with default_column_width.
*;

ods &_ODSDEST path='c:\temp' file='ExcelXP-sample05.xml' style=&_ODSSTYLE options(autofilter='all' frozen_headers='yes' frozen_rowheaders='yes' default_column_width='7, 7, 7, 7') anchor='patient';

  title2 'Patient Visit Log';

  proc report nowindows data=work.trial;
    columns patient sex drug dosage
            visitdate ('Blood Pressure' systolic diastolic);
    define patient--dosage / order noprint;
    define visitdate / order order=internal format=date8.;
    define systolic / spacing=5 "Systolic";
    define diastolic / "Diastolic";

    compute before _page_;
      line 'Patient: ' patient $4. +2 'Sex: ' sex $1. +2
         'Drug: ' drug $1. +2 'Dosage: ' dosage $3.;
    endcomp;

    break after patient / page;
  run; quit;

  title2 'Patient Side Effects Log';

  *  Force titles to be "embedded" within the worksheet, and change the default column width;

  ods &_ODSDEST options(embedded_titles='yes' default_column_width='5.5');

  proc report nowindows data=work.trial headline;

    columns patient fever nausea rash;

    define patient / group width = 10;
    define fever--rash / sum format=sympfmt1. width=6 center;

    compute after;
      line ' ';
      line 'Side effects occurrences:';
      line 'Fever:  ' fever.sum 5.0;
      line 'Nausea: ' nausea.sum 5.0;
      line 'Rash:   ' rash.sum 5.0;
    endcomp;

    compute before;
      num = 0;
    endcomp;

    compute after patient;
      num = num + 1;
    endcomp;


  *  NOTE:  URL string (hyperlink) does not currently work for XML;

    compute patient ;
      urlstring = "odsrep4A.htm#patient" || left(put(num,3.0));
      call define(_col_, 'URL', urlstring);
      call define(_col_, 'style', 'style={flyover="Click to go to patient visit log"}');
      endcomp;
  run; quit;
ods &_ODSDEST close;