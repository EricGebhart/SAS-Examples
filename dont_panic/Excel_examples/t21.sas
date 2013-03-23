ods tagsets.excelxp file="t21.xls"
options(
 auto_subtotals='yes'
 embedded_titles='no' 
 Orientation='landscape'
 sheet_interval='none' 
 sheet_name='Summary'
 absolute_column_width='14,15,10.5,10.5' 
 frozen_headers='3' 
 frozen_rowheaders='2'
 Convert_Percentages='No'
 AutoFilter_Table='none'
 AutoFilter='1-4'
 scale='70'
 zoom='75'
 dpi='600'
); 


proc print data=sashelp.class;
run;

proc print data=sashelp.class;
run;

ods _all_ close;
