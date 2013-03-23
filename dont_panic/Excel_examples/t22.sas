
ods tagsets.excelxp  file='t22.xls'
options(
embedded_titles='no' 
sheet_interval='none'
sheet_name='Summary'
frozen_headers='3' 
frozen_rowheaders='2'

); 


proc print data=sashelp.class;
run;


ods tagsets.excelxp
options(
sheet_interval='none'
sheet_name='Product-Units'
frozen_headers='2' 
frozen_rowheaders='1'
); 


proc print data=sashelp.class;
run;

ods _all_  close;
