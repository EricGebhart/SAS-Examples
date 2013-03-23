proc sort data=sashelp.class out=foo;
    by age;
run;


ods html file="t142.html" contents="t142c.html" options(scroll_tables='yes' toc_type='menu');

proc print data=foo;
run;

proc print data=foo;
    by age;
run;

ods html file="t142.2.html" options(body_toc='yes' scroll_tables='yes');

proc print data=foo;
run;

proc print data=foo;
    by age;
run;

ods html close;


