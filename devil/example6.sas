
  /*-- Create a difference column --*/
  /*--------------------------------*/
data prdsale;
  set sashelp.prdsale;
  Difference = actual-predict;
run;

proc sort data=prdsale;
  by country region division year;
run;


ods tagsets.excelxp file="examlple6.xls" style=meadow
                    options(autofilter='1-3' frozen_headers='2'
                            frozen_rowheaders='4' auto_subtotals='yes');


  /*------------------------------------------------------*/
  /*-- Use Excel formulas to represent computed cells,  --*/
  /*-- and use an Excel format to force Excel to show   --*/
  /*-- negative currency values in red and with the     --*/
  /*-- format ($nnn).  In the formula below, the RC     --*/
  /*-- value corresponds to the cell relative to the    --*/
  /*-- current cell.  For example, RC[-2] means "2      --*/
  /*-- cells to the left of the current cell".  Any     --*/
  /*-- valid Excel formula can be used, and the formula --*/
  /*-- used here matches the computation performed      --*/
  /*-- in the DATA step that created the column.        --*/
  /*------------------------------------------------------*/

title2 'Print of data using tagattr with formats';
title3 'predict & actual - ';
title4 'difference - ';
title5 'Sums - ';
  proc print data=prdsale noobs label;
    id country region division;
    var prodtype product quarter month year;
    var predict actual / style={tagattr='format:$#,##0_);[Red]\($#,##0\)'};
    var difference /
style={tagattr='format:$#,##0_);[Red]\($#,##0\) formula:RC[-1]-RC[-2]'};
    sum predict actual difference /
style={tagattr='format:$#,##0_);[Red]\($#,##0\)'};;
  run;

title6 'Adding labels to prodtype, predict and actual';
  proc print data=prdsale noobs label split='*';
    id country region division;
    var prodtype product quarter month year;
    var predict actual / style={tagattr='format:$#,##0_);[Red]\($#,##0\)'};
    var difference /
style={tagattr='format:$#,##0_);[Red]\($#,##0\) formula:RC[-1]-RC[-2]'};
    sum predict actual difference /
style={tagattr='format:$#,##0_);[Red]\($#,##0\)'};;
    label prodtype = 'Product*Type'
          predict  = 'Predicted*Sales*For Area'
          actual   = 'Actual*Sales*Amount';
  run;


ods tagsets.excelxp close;
