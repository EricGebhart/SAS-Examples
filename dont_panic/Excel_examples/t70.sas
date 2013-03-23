ods listing close;
	 
	ods tagsets.ExcelXP
	      file='t70.xls'
	      options(contents='yes' index='yes');
	 
	proc sort data=sashelp.class out=class;  by age; run; quit;
	 
	proc print data=class; by age; run; quit;
	 
	ods tagsets.ExcelXP close;
