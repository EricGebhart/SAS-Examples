ods listing close;

*  Create some test data;

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

format offers comma8. obj_value roi_profit roi_cost dollar9.2 roi_value percent.;

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

title; footnote;

*;
*  AMO should be able to open this HTML file.  Replace the ODS statements
*  with %STPBEGIN and %STPEND.  If your stored process has registered parameters
*  named _ODSDEST and _ODSSTYLE, remove the %LET statements below.
*;

%let _ODSDEST=tagsets.MSOffice2K;
%let _ODSSTYLE=Statistical;

ods &_ODSDEST path='c:\temp' file='ExcelXP-sample01.htm' style=&_ODSSTYLE;
  proc print data=test noobs label split='*';
    sum offers obj_value roi_profit roi_cost;
  run; quit;
ods &_ODSDEST close;

*;
*  AMO may or may not be able to open this XML file.  You will need to get the latest version of
*  the ExcelXP tagset in order to take advantage of these new features.  Replace the ODS statements
*  with %STPBEGIN and %STPEND.  If your stored process has registered parameters
*  named _ODSDEST and _ODSSTYLE, remove the %LET statements below.
*;

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
*  Use Excel formulas to represent computed cells, and use an Excel format (0%) to force Excel to 
*  report the percentage as 400% instead of 400.00%.  In the formulas below, the RC value corresponds
*  to the cell relative to the current cell.  For example, RC[-2] means "2 cells to the left of the current cell".
*  Any valid Excel formula can be used, and the formulas used here match the computations performed in the DATA step
*  that created the columns.
*;

ods &_ODSDEST path='c:\temp' file='ExcelXP-sample01.xml' style=&_ODSSTYLE options(autofilter='all' frozen_headers='yes' auto_subtotals='yes');
  proc print data=test noobs label split='*';
    var camp_code  comm_code  product  outbound_channel  outbound_team  inbound_channel  
        inbound_team  offer_group  offer_subgroup  time_period offers  obj_value  roi_profit;
    var roi_cost / style={tagattr='formula:RC[-1]*0.25'};
    var roi_value / style={tagattr='format:0% formula:RC[-2]/RC[-1]'};
    sum offers / style={tagattr='format:#,###'};
    sum obj_value  roi_profit roi_cost;
  run; quit;
ods &_ODSDEST close;