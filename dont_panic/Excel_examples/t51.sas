data test;
pef=100;
input reg_ex $;
cards;
aaa
bbb
ccc
ddd
;
run;
ods listing close;
ods tagsets.excelxp file='test.xls';
  proc tabulate data=test;
    class reg_ex;
    var pef;
    table reg_ex, pef=' '*mean=' '*f=8.2;
run; quit;
ods _all_ close;
