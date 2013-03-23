
proc template;
    define style styles.mystatistical;
      parent=styles.statistical;

      style data_formatted from data/
          tagattr='format:$#,##0_);[Red]\($#,##0\)'
      ;

      style data_difference from data/
          tagattr='format:$#,##0_);[Red]\($#,##0\) formula:RC[-1]-RC[-2]'
      ;
    end;
run;

            
  /*-----------------*/
  /*-- Create data --*/
  /*-----------------*/
data prdsale;
  set sashelp.prdsale;
  Difference = actual-predict;
run;

proc sort data=prdsale;
  by country region division year;
run;

ods tagsets.excelxp file="example16.xls" style=mystatistical
                    options(autofilter='1-3' 
                            frozen_headers='2'
                            frozen_rowheaders='4' 
                            auto_subtotals='yes');


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
  proc print data=prdsale noobs label split='*';
    id country region division;
    var prodtype product quarter month year;
    var predict actual / style={tagattr='format:$#,##0_);[Red]\($#,##0\)'};
    var difference /     style={tagattr='format:$#,##0_);[Red]\($#,##0\) formula:RC[-1]-RC[-2]'};
    sum predict actual difference / style={tagattr='format:$#,##0_);[Red]\($#,##0\)'};;
    label prodtype = 'Product*Type'
          predict  = 'Predicted*Sales*For Area'
          actual   = 'Actual*Sales*Amount';
  run;

  proc print data=prdsale noobs label split='*';
    id country region division;
    /*var prodtype product quarter month year;*/
    var prodtype;
    var predict actual / style(data)=data_formatted;
    var difference /     style(data)=data_difference;
    sum predict actual difference / style(data)=data_formatted;;
    label prodtype = 'Product*Type'
          predict  = 'Predicted*Sales*For Area'
          actual   = 'Actual*Sales*Amount';
  run;

ods tagsets.excelxp close;

