OPTIONS NODATE NOSTIMER LS=78 PS=60;

proc template;
    define tagset tagsets.ssv;
        parent = tagsets.csv;  

        define event initialize;
            trigger My_defaults;    

            trigger set_options;
            trigger documentation;
            trigger compile_regexp;
        end;
        
        define event My_defaults;
            set $OPTIONS['DELIMITER'] ';';
            set $OPTIONS['DECIMAL_SEPARATOR'] ',';
            set $OPTIONS['THOUSANDS_SEPARATOR'] '.';
        end;
    end;

run;


/* test code */
data test;
input v1;
format v1 commax20.2;
cards;
123456
123456.7
123.456
0.12345
12345.6
;
run;

ods listing close;
ods html file="test.html";
ods tagsets.excelxp file='test.xls' options(decimal_separator=',' thousands_separator='.');
ods csv file='test.csv' options(delimiter=";" decimal_separator=',' thousands_separator='.');
ods tagsets.ssv file='test.ssv';

proc print data=test;
run;

ods _all_ close;
