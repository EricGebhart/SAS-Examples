

ods tagsets.excelxp file="t94.xls";
* options(debug_level='-5');

proc print data=sashelp.class;
    var name;
    var age /style(data) = {tagattr="Type:Number format:0.00"};
    var weight / style(data)={tagattr="type:Number format:#0.00"};
run;

ods tagsets.excelxp close;

