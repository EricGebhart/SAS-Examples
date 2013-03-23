ods listing close;
* Open up ExcelXP tagset, set options *;
ods tagsets.ExcelXP file="test.xls"
    options(default_column_width='8,20,30'
            row_repeat='header'
            frozen_headers='yes'
            debug_level='5')
    ;

proc report data=SASHELP.EISMSG
               nowd split='*';
  columns MSGID
          MNEMONIC
          TEXT
          ;
  define MSGID         /order 'Message*ID';
  define MNEMONIC      /display 'Mnemonic'  ;
  define TEXT          /display 'Text Of Message' ;

  compute before _page_  ;
      line 'Output Line before page';
      line 'Second Output Line Before Page';
  endcomp;

  title 'Test Report';
  title2 'Testing new Tagset';
  title3 "EXCELXP";

run;

* Close *;
ods tagsets.ExcelXP close;
ods listing;
