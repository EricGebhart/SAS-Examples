ods escapechar="^";


title 'This is ^{super SUPER text}
        This is ^{sub SUB text}';

title2 'This is ^{super SUPER text}
        ^{sub This is SUB text}
        ^{super More SUPER text}
        ^{sub More SUB text}';


ods html file="example16.html";

proc print data=sashelp.class;
run;

ods _all_ close;
