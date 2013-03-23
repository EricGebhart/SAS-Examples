ods tagsets.excelxp

    options(
    frozen_headers='Yes' autofilter='All'
    embedded_titles='No'
    pages_fitWidth='2'
    pages_fitHeight='3'
    )

    file="t34.xls"
    style=minimal;


 ods noproctitle;
 proc print data=sashelp.class
    contents="sashelp.class";

    id Name;
    var Sex;
    var Age Height;
    var Weight / style={tagattr='format:text'};
    sum Age Height Weight;
 run;

ods tagsets.excelxp close; 
