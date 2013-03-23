ods tagsets.excelxp file='tagattr.xls'; ods listing close;

data _null_;
 declare odsout ByCell();

 ByCell.table_start();
   bycell.row_START();
     ByCell.format_cell(text: '500', overrides: 'background=grey99 font_weight=bold tagattr="format:#,##0"');
     ByCell.format_cell();
     ByCell.format_cell(text: '1000',overrides: 'tagattr="format:@"');
     ByCell.format_cell();
     ByCell.format_cell(text: '1500',overrides: 'tagattr="format:#,##0"');

   ByCell.row_end();
 ByCell.table_end();

run;

ods _all_ close;
ods listing;
