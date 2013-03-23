ods listing close;


data test;
length camp_code  comm_code $5
       product $3
       outbound_channel $11
       outbound_team
       inbound_channel  inbound_team $1
       offer_group $3
       offer_subgroup  time_period $6
       offers obj_value  roi_profit  roi_cost  roi_value 8;
input @1  camp_code
      @9  comm_code
      @17 product
      @23 outbound_channel $char11.
      @37 offer_group
      @43 offer_subgroup
      @52 time_period
      @61 offers
      @69 obj_value;
roi_profit = obj_value;
roi_cost   = roi_profit*0.25;
roi_value  = roi_profit/roi_cost;
label camp_code        = 'Campaign*Code'
      comm_code        = 'Comm*Code'
      product          = '*Product'
      outbound_channel = 'Outbound*Channel'
      outbound_team    = 'Outbound*Team'
      inbound_channel  = 'Inbound*Channel'
      inbound_team     = 'Inbound*Team'
      offer_group      = 'Offer*Group'
      offer_subgroup   = 'Offer*Subgroup'
      time_period      = 'Time*Period'
      offers           = '*Offers'
      obj_value        = 'Obj*Value'
      roi_profit       = 'ROI*Profit'
      roi_cost         = 'ROI*Cost'
      roi_value        = 'ROI*Value';
format offers comma8. obj_value roi_profit roi_cost
       dollar9.2 roi_value percent.;
cards;
CAMP1   ADB_1   ADB   Direct Mail   ADB   Jan_04   Jan_04   22420   891.634432
CAMP1   ADB_2   ADB   Direct Mail   ADB   Feb_04   Feb_04   22420   891.634432
CAMP1   ADB_3   ADB   Direct Mail   ADB   Mar_04   Mar_04   22420   891.634432
CAMP1   GBL_1   GBL   Direct Mail   GBL   Jan_04   Jan_04   22420   891.634432
CAMP1   GBL_2   GBL   Direct Mail   GBL   Feb_04   Feb_04   22420   891.634432
CAMP1   GBL_3   GBL   Direct Mail   GBL   Mar_04   Mar_04   22420   891.634432
CAMP1   T70_1   T70   Direct Mail   T70   Jan_04   Jan_04   24785   304.082208
CAMP1   T70_2   T70   Direct Mail   T70   Feb_04   Feb_04   22420   891.634432
CAMP1   T70_3   T70   Direct Mail   T70   Mar_04   Mar_04   24785   304.082208
;
run;


  /*-- Modify the Statistical style to fix --*/
  /*-- missing border lines.               --*/
  /*-----------------------------------------*/
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
run;
quit;


ods tagsets.excelxp file="example3.xls" style=xlstatistical
    options(autofilter='all' frozen_headers='yes' auto_subtotals='yes');


  /*-- Use Excel formulas to represent computed cells, and use an --*/
  /*-- Excel format (0%) to force Excel to report the percentage  --*/
  /*-- as 400% instead of 400.00%.  In the formulas below, the RC --*/
  /*-- value corresponds to the cell relative to the current cell.--*/
  /*-- For example, RC[-2] means "2 cells to the left of the      --*/
  /*-- current cell".  Any valid Excel formula can be used, and   --*/
  /*-- the formulas used here match the computations performed in --*/
  /*-- the DATA step that created the columns.                    --*/
  /*----------------------------------------------------------------*/

title2 'Proc print of data using style statement with tagattr';
proc print data=test noobs label split='*';
  var camp_code comm_code product outbound_channel outbound_team
      inbound_channel inbound_team offer_group offer_subgroup
      time_period offers obj_value roi_profit;
  var roi_cost / style={tagattr='formula:RC[-1]*0.25'};
  var roi_value / style={tagattr='format:0% formula:RC[-2]/RC[-1]'};
  sum offers / style={tagattr='format:#,###'};
  sum obj_value  roi_profit roi_cost;
run;


ods tagsets.excelxp close;


