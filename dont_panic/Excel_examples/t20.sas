
ods tagsets.excelxp
    options(frozen_headers='Yes' debug_level='-2'
    )
    file="t20.xls"

    style=minimal;


  proc print data=sashelp.class;
  run;

  ods _all_ close;
