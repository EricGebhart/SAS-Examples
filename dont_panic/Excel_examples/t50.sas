
%let name=bar068;
filename odsout '.';

data a;
input a b c;
cards;
1 23 456
1 23 458
1 22 289
2 22 124
2 26 497
2 27 400
3 44 888
3 22 999
;
run;

 GOPTIONS DEVICE=gif;

 ODS LISTING CLOSE;
 ODS HTML gpath="foo.bar" path=odsout body="&name..htm";

 goptions reset=all;

 title "A simple gif bar chart";
 footnote c=black 'Build: ' c=red "&sysvlong" c=black '   Executed: ' c=red "&sysdate9";

 proc gchart data=a; hbar a / subgroup=b sumvar=c nostats discrete name="&name"; run;

 quit;
 ODS HTML CLOSE;
 ODS LISTING;
