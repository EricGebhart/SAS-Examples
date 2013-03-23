options nonumber nodate;
ods pdf file="line.pdf" notoc;
ods html file="underline.html";

ods escapechar='^';
title underlin=1 "an underlined title using underlin=.";
title3 "^{style [textdecoration=line_through]a line-through title}";
title5 "^{style [textdecoration=overline]An overlined title}";
title7 "^{style [textdecoration=underline]Switching from underline to} 
        ^{style [textdecoration=line_through]line-through, then} 
        ^{style [textdecoration=overline]overline}.";

proc print data=sashelp.class(obs=1);run;

ods pdf text="^{style [just=r textdecoration=underline color=red]Here is some random underlined text.}";
   
ods _all_ close;
ods listing; 
