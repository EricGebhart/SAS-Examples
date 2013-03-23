*  Define search path of new tagsets and styles;

ods path work.templates(update)
         sashelp.tmplmst(read);

*  Get the latest version of the ExcelXP tagset;

%include 'c:\temp\excltags.tpl';