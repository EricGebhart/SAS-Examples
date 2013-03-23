ods listing close;

ods pdf file='stack_col.pdf';
ods escapechar='~';
  proc report data=newclass nowd;
    column name age newvar height;
    define name /order noprint;
    define age /display noprint;
    define newvar / computed;
    define height /display
       style(column)={vjust=b};
    compute newvar / character length=40;
       newvar = name||"~n"||put(age,3.0);
    endcomp;
  run;
ods pdf close;
