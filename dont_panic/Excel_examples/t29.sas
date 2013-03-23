Ods  listing close;

data tstnull;
input grp var name $ num1 num2 num3 pct1 pct2 pct3 pval;
cards;
1     102     PCT      127.00    141.00    268.00      .       .       .
.
1     103     PCT       42.80     43.40     43.10      .       .       .
0.663
1     104     PCT       44.00     44.00     44.00      .       .       .
.
1     105     PCT       11.08     10.03     10.53      .       .       .
.
1     106     PCT       20.00     20.00     20.00    64.0    66.0
66.0     .
3     505     PCT       16.00     14.00     30.00    12.6     9.9
11.2    0.241
3     506     PCT       92.00    114.00    206.00    72.4    80.9
76.9     .
3     507     PCT       19.00     13.00     32.00    15.0     9.2
11.9     .
;;;


PROC FORMAT;
  VALUE VF 101 = 'Age(Years)'
           102 = 'n'
           103 = 'Mean'
           104 = 'Median'
           105 = 'SD'
           106 = '(Min,Max)'
           503 = 'Male'
           504 = 'Female'
           501 = 'Age < 12'
           502 = 'Age >= 12'
           505 = 'Age < 30'
           506 = 'Age 30-55'
           507 = 'Age > 55'
           508 = 'White'
           509 = 'African-Amer'
           510 = 'Asian'
           511 = 'Hispanic'
           512 = 'Other'
           513 = '3-6 Months'
           514 = '7-12 Months'
           515 = '1-5 Years'
           516 = '>5 Years'
          1501 = 'Systolic BP'
          1502 = 'n'
          1503 = 'Mean'
          1504 = 'Median'
          1505 = 'SD'
          1506 = '(Min,Max)'
          2001 = 'Diastolic BP'
          2002 = 'n'
          2003 = 'Mean'
          2004 = 'Median'
          2005 = 'SD'
          2006 = '(Min,Max)'
          2502 = 'n'
          2503 = 'Mean'
          2504 = 'Median'
          2505 = 'SD'
          2506 = '(Min,Max)'
          3002 = 'n'
          3003 = 'Mean'
          3004 = 'Median'
          3005 = 'SD'
          3006 = '(Min,Max)'
          3502 = 'n'
          3503 = 'Mean'
          3504 = 'Median'
          3505 = 'SD'
          3506 = '(Min,Max)'
          4002 = 'n'
          4003 = 'Mean'
          4004 = 'Median'
          4005 = 'SD'
          4006 = '(Min,Max)'
          4502 = 'n'
          4503 = 'Mean'
          4504 = 'Median'
          4505 = 'SD'
          4506 = '(Min,Max)'
           ;

   VALUE GF 1 = 'Age (Years)'
            2 = 'Age 12, n (%)'
            3 = 'Age Group'
            5 = 'Race, n (%)'
           50 = 'Symptom Length'
           15 = 'Systolic BP'
           20 = 'Diastolic BP'
           25 = 'Pulse'
           30 = 'PSA'
           35 = 'Age at Diagnosis'
           40 = 'Yrs from Diagnosis'
           45 = 'Prostate Sec.'
           ;
run;

*ODS HTML3  FILE = "E:\SasApps\MISC\DEMONULL.HTM"
  HEADTEXT = '<STYLE> TD.I1 {TEXT-INDENT:20px}
    TD.I1 {TEXT-INDENT:26px} </STYLE>'
  STYLE = STYLES.OMPTBL
  ;

ods tagsets.short_map file="map.xml";
ods tagsets.event_map file="map2.xml";

*ods html file='just.html';
*ods pdf  file='just.pdf';
*ods rtf  file='just.rtf';
DATA _NULL_;
  SET tstnull END = EOF;
  IF (_N_ = 1) THEN DO;
    dcl odsout tbl();
*    tbl.open_dir(name: "table1", label: "test");
    tbl.format_text(text: "test");
    tbl.table_start(name: "test",  label: "test",
      overrides: "cellspacing = 10");

    tbl.row_start(type: "header");
    tbl.format_cell(
      text: "Table 8-5.  Summary of Demographic and Baseline
Characteristics",
      column_span: 9);
    tbl.row_end();
    tbl.row_start(type: "header");
    tbl.format_cell(
      text: "(Intent-to-Treat Population In Protocol A)",
      column_span: 9);
    tbl.row_end();
    tbl.row_start(type: "header");
    tbl.format_cell(
      text: "Demographic",
      column_span: 1, overrides:  "just = L");
    tbl.format_cell(text: " ",

      column_span: 1);
    tbl.format_cell(
      text: "Ditropan",
      column_span: 2);
    tbl.format_cell(
      text: "Placebo",
      column_span: 2);
    tbl.format_cell(
      text: "Total",
      column_span: 2);
    tbl.format_cell(
      text: " ",
      column_span: 1);
    tbl.row_end();
    tbl.row_start(type: "header");
    tbl.format_cell(
      text: "Characteristic",
      column_span: 1, overrides:  "just = L");
    tbl.format_cell(
      text: " ",
      column_span: 1);
    tbl.format_cell(
      text: "(n=127)",
      column_span: 2);
    tbl.format_cell(
      text: "(n=141)",
      column_span: 2);
    tbl.format_cell(
      text: "(n=268)",
      column_span: 2);
    tbl.format_cell(
      text: "p-value",
      column_span: 1);
    tbl.row_end();
   end;
   tbl.row_start(type: "data");
   if (var in(102, 505)) then do;
    tbl.format_cell(
      text: put(grp, gf.),
      column_span: 1, overrides:  "just = L");
     end;
   if (var not in(102, 505)) then do;
    tbl.format_cell(
      text: " ",
      column_span: 1, overrides:  "just = L");
     end;
   tbl.format_cell(text: put(var, vf.), column_span: 1,
     overrides:  "just = L");
   if (var = 102) then do;
     tbl.format_cell(text: put(num1, 6.0), column_span: 2, overrides:
"just=d");
     tbl.format_cell(text: put(num2, 6.0), column_span: 2, overrides:
"just=d");
     tbl.format_cell(text: put(num3, 6.0), column_span: 2, overrides:
"just=d");
     tbl.format_cell(text: " ", column_span: 1);
    end;
   if (var = 103) then do;
     tbl.format_cell(text: put(num1, 6.1), column_span: 2, overrides:
"just=d");
     tbl.format_cell(text: put(num2, 6.1), column_span: 2, overrides:
"just=d");
     tbl.format_cell(text: put(num3, 6.1), column_span: 2, overrides:
"just=d");
     tbl.format_cell(text: put(pval, 8.3), column_span: 1, overrides:
"just=d");
    end;
   if (var = 104) then do;
     tbl.format_cell(text: put(num1, 6.1), column_span: 2, overrides:
"just=D");
     tbl.format_cell(text: put(num2, 6.1), column_span: 2, overrides:
"just=D");
     tbl.format_cell(text: put(num3, 6.1), column_span: 2, overrides:
"just=D");
     tbl.format_cell(text: " ", column_span: 1);
    end;
   if (var = 105) then do;
     tbl.format_cell(text: put(num1, 6.2), column_span: 2, overrides:
"just=D");
     tbl.format_cell(text: put(num2, 6.2), column_span: 2, overrides:
"just=D");
     tbl.format_cell(text: put(num3, 6.2), column_span: 2, overrides:
"just=D");
     tbl.format_cell(text: " ", column_span: 1);
    end;
   if (var = 106) then do;
     tbl.format_cell(text: "(" || put(num1, 6.0) || ","
       || put(pct1, 6.0) || ")", column_span: 2);
     tbl.format_cell(text: "(" || put(num2, 6.0) || ","
       || put(pct2, 6.0) || ")", column_span: 2);
     tbl.format_cell(text: "(" || put(num3, 6.0) || ","
       || put(pct3, 6.0) || ")", column_span: 2);
     tbl.format_cell(text: " ", column_span: 1);
    end;
   if (var = 505) then do;
     tbl.format_cell(text: put(num1, 6.0), column_span: 1,
       overrides: 'just = R');
     tbl.format_cell(text: "(" || put(pct1, 6.1) || ")",
       column_span: 1, overrides: 'just = R');
     tbl.format_cell(text: put(num2, 6.0), column_span: 1,
       overrides: 'just = R');
     tbl.format_cell(text: "(" || put(pct2, 6.1) || ")",
       column_span: 1, overrides: 'just = R');
     tbl.format_cell(text: put(num3, 6.0), column_span: 1,
       overrides: 'just = R');
     tbl.format_cell(text: "(" || put(pct3, 6.1) || ")",
       column_span: 1, overrides: 'just = R');
     tbl.format_cell(text: put(pval, 8.3), column_span: 1);
    end;
   if (var in(506,507)) then do;
     tbl.format_cell(text: put(num1, 6.0), column_span: 1,
       overrides: 'just = R');
     tbl.format_cell(text: "(" || put(pct1, 6.1) || ")",
       column_span: 1, overrides: 'just = R');
     tbl.format_cell(text: put(num2, 6.0), column_span: 1,
       overrides: 'just = L');
     tbl.format_cell(text: "(" || put(pct2, 6.1) || ")",
       column_span: 1, overrides: 'just = R');
     tbl.format_cell(text: put(num3, 6.0), column_span: 1,
       overrides: 'just = R');
     tbl.format_cell(text: "(" || put(pct3, 6.1) || ")",
       column_span: 1, overrides: 'just = R');
     tbl.format_cell(text: " ", column_span: 1);
    end;
   tbl.row_end();

   if (eof) then do;
     tbl.table_end();
     put 'last';
    end;
RUN;

ODS _all_ CLOSE;
