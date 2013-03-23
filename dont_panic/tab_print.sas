
%let _ODSDEST=tagsets.ExcelXP;
%let _ODSSTYLE=Statistical;

data prdsale;
  set sashelp.prdsale;
  Difference = actual-predict;
run;

proc sort data=prdsale; by country region division year; run; quit;

title; footnote;

*;
*  Create a workbook with multiple tables per worksheet, and specify the name for the worksheets.  Autofilters
*  will be applied to the second table in each worksheet.  The SUM statement of PROC PRINT will result in a subtotal
*  row, but note that the SUBTOTAL function is not used for the DIFFERENCE column because a formula was specified on
*  the SUM statment.  In this case, the user-specified formula takes precedence over the auto subtotal.
*;

ods listing close;
ods &_ODSDEST file='tab_print.xls' style=&_ODSSTYLE options(auto_subtotals='yes' default_column_width='7, 10, 10, 7, 7' frozen_rowheaders='yes' sheet_interval='none' sheet_name='Canada' autofilter='all' autofilter_table='2');

*;
*  The output from the following two procs will be in a single worksheet
*  with a user-specified name of 'Canada'.
*;

  proc tabulate data=prdsale;
    where country eq 'CANADA' and year eq 1993;
    var predict actual;
    class region division prodtype;
    table 
      region*(division*prodtype all={label='Division Total'}) all={label='Grand Total'},
      predict={label='Total Predicted Sales'}*f=dollar10.*sum={label=''} 
      actual={label='Total Actual Sales'}*f=dollar10.*sum={label=''};
  run; quit;

  proc print data=prdsale noobs label split='*';
    where country eq 'CANADA' and year eq 1993;
    id country region division;
    var prodtype product quarter month year;
    sum predict / style={tagattr='format:Currency'};
    sum actual / style={tagattr='format:Currency'};
    sum difference / style={tagattr='format:Currency formula:RC[-1]-RC[-2]'};
    label prodtype = 'Product*Type'
          predict  = 'Predicted*Sales'
          actual   = 'Actual*Sales';
  run; quit;

  ods &_ODSDEST options(sheet_interval='none' sheet_name='Germany');

*;
*  The output from the following two procs will be in a single worksheet
*  with a user-specified name of 'Germany'.
*;

  proc tabulate data=prdsale;
    where country eq 'GERMANY' and year eq 1993;
    var predict actual;
    class region division prodtype;
    table 
      region*(division*prodtype all={label='Division Total'}) all={label='Grand Total'},
      predict={label='Total Predicted Sales'}*f=dollar10.*sum={label=''} 
      actual={label='Total Actual Sales'}*f=dollar10.*sum={label=''};
  run; quit;

  proc print data=prdsale noobs label split='*';
    where country eq 'GERMANY' and year eq 1993;
    id country region division;
    var prodtype product quarter month year;
    sum predict / style={tagattr='format:Currency'};
    sum actual / style={tagattr='format:Currency'};
    sum difference / style={tagattr='format:Currency formula:RC[-1]-RC[-2]'};
    label prodtype = 'Product*Type'
          predict  = 'Predicted*Sales'
          actual   = 'Actual*Sales';
  run; quit;

  ods &_ODSDEST options(sheet_interval='none' sheet_name='United States');

*;
*  The output from the following two procs will be in a single worksheet
*  with a user-specified name of 'United States'.
*;

  proc tabulate data=prdsale;
    where country eq 'U.S.A.' and year eq 1993;
    var predict actual;
    class region division prodtype;
    table 
      region*(division*prodtype all={label='Division Total'}) all={label='Grand Total'},
      predict={label='Total Predicted Sales'}*f=dollar10.*sum={label=''} 
      actual={label='Total Actual Sales'}*f=dollar10.*sum={label=''};
  run; quit;

  proc print data=prdsale noobs label split='*';
    where country eq 'U.S.A.' and year eq 1993;
    id country region division;
    var prodtype product quarter month year;
    sum predict / style={tagattr='format:Currency'};
    sum actual / style={tagattr='format:Currency'};
    sum difference / style={tagattr='format:Currency formula:RC[-1]-RC[-2]'};
    label prodtype = 'Product*Type'
          predict  = 'Predicted*Sales'
          actual   = 'Actual*Sales';
  run; quit;
ods &_ODSDEST close;
