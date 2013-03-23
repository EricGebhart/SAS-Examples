ods tagsets.excelxp file="Excelxp2.xls" style=Printer
                    options(
                        sheet_interval="bygroup"
                    );

proc sort data=sashelp.class out=work.class;
    by Age Sex;
    
proc print;
   by Age Sex;
run;

ods _all_ close;
