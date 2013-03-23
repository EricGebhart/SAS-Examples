
data one;
  x="00%-25";
run;

ods csv file="t23.xls";
ods html file="t23.html";
ods pdf file="t23.pdf";


proc print data=one noobs;
run;

ods _all_ close;
