

data VolumeExpense; 
length PurchMC ProvMC Type $8.; 
format Cost comma10.2; 
do purchmc = 'Hay', 'Rch', 'Oak'; 
do provmc = 'Oak', 'Hay', 'Rch'; 
do type = 'Volume', 'Expense'; 
cost = round(ranuni(94612)*100, .01); 
output; 
end; 
end; 
end; 
run; 


ods tagsets.excelxp file="t37.xls"
options(sheet_name='Output from REPORT' 
frozen_headers='3' 
row_repeat='1-3' 
autofilter='2' 
); 

proc report data=VolumeExpense missing nofs nocenter 
completerows completecols; 
column purchmc type provmc, cost cost=totcost; 
define purchmc / group 'Purch MC' width=8 order=data; 
define type / group 'Type' width=8 order=data; 
define provmc / across 'Prov MC' width=8 order=data; 
define Cost / sum 'Cost' 
style={tagattr='format:#,##0.00'}; 
define totcost / sum 'Total Cost' width=10 format=comma10.2 
style={tagattr='format:#,##0.00'}; 
; 
compute provmc; 
if type = 'Expense' then 
call define(_col_, 'style', 'style={background=yellow}'); 
endcomp; 
run; 

ods _all_ close;
