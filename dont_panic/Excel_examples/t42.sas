data test;
input @1 Region $char15.
      @18 CitySize $8.
      @30 SaleType $9.
      @46 Quantity
      @55 Amount 8.;
cards;
North Central    1-Small     Retail          472      11800
North Central    1-Small     Wholesale       472      9440
North Central    2-Medium    Retail          1066     26600
North Central    2-Medium    Wholesale       1066     21320
North Central    3-Large     Wholesale       2272     45440
Northeast        1-Small     Retail          623      15575
Northeast        1-Small     Wholesale       623      12460
Northeast        2-Medium    Retail          1825     45625
Northeast        2-Medium    Wholesale       1825     36500
Northeast        3-Large     Retail          2421     60525
Northeast        3-Large     Wholesale       2421     48420
Southern         1-Small     Retail          1254     31150
Southern         2-Medium    Retail          2149     54725
Southern         2-Medium    Wholesale       2149     42980
Southern         3-Large     Retail          2303     57575
Southern         3-Large     Wholesale       2303     46060
Western          1-Small     Retail          561      14025
Western          1-Small     Wholesale       561      11220
Western          2-Medium    Retail          2360     59000
Western          2-Medium    Wholesale       2360     47200
Western          3-Large     Retail          2655     66375
Western          3-Large     Wholesale       2655     53100
;
run;
ods listing close;
ods html file="test.html";
ods tagsets.ExcelXP file='test.xls'
  options( auto_subtotals='yes' sheet_interval='page'
currency_format='$#,##0_);[Red]\($#,##0\)');
  title;
  footnote;
  proc print data=test noobs label;
    by region citysize;
    id citysize;
    sum quantity / style={tagattr='format:#,###'};
    sum amount;
    pageby region;
  run; quit;
ods _all_ close;
