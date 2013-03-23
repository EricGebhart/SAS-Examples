
%macro styles(just=center);

%local I NSTYLE STYLE;

proc sort data=sashelp.class out=class; by sex; run; quit;

proc format;
  value $gender 'F' = 'Female, with some additional text to make the BY
value longer than the data table'
                'M' = 'Male, with some additional text to make the BY
value longer than the data table';
run; quit;

proc sql errorstop feedback noprint;
  select count(style) into: NSTYLE
  from sashelp.vstyle;
quit;

%put NSTYLE=&NSTYLE;

ods listing close;

options &JUST;

title1 'This is some really long text that is much larger than the data
table, for title 1';
title3 'This is some really long text that is much larger than the data
table, for title 3';

footnote1 'This is some really long text that is much larger than the
data table, for footnote 1';
footnote3 'This is some really long text that is much larger than the
data table, for footnote 3';

%do I = 1 %to &NSTYLE;

  data _null_;
  set sashelp.vstyle(firstobs=&I obs=&I);
  call symput('STYLE',strip(substr(style,8)));
  run;

  ods tagsets.excelxp(&I) 
file="&STYLE-&JUST..xls" style=&STYLE
    options(embedded_titles='yes' embedded_footnotes='yes');

%end;

  proc print data=class; by sex; format sex $gender.; run; quit;
  ods _ALL_ close;

%mend styles;

%STYLES(just=nocenter);

