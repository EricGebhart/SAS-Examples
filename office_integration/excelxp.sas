ods tagsets.excelxp file="Excelxp.xls" 
                    options(
                        sheet_interval="none"
                        embedded_titles='yes' 
                        embedded_footnotes='yes'
                    );

proc reg data=sashelp.class;
   model Weight = Height Age;
run;quit;

ods _all_ close;
