ods escapechar='^';
ods printer pdf file="inline.pdf";

title 'black ^{style [color=red] red text ^{style [fontsize=18pt] big} more ^{style [color=blue] blue  ^{unicode alpha}} text} end';

proc print data=sashelp.class(obs=1); run;

ods _all_ close;
