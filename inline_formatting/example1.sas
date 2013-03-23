
ods Escapechar="^";


title "Examples of Functions";

Title2 'This is ^{style [color=red] Red}';

title3 'Example of ^{nbspace 3} Non-Breaking Spaces Function';

title4 'Example of ^{newline 2} Newline Function';

title5 'Example of ^{raw rtf \cf12 } RAW function';

title6 'Example of ^{unicode 03B1} UNICODE function';

title7 "Example ^{style [foreground=red] of ^{super ^{unicode ALPHA} ^{style [foreground=green] Nested}} Formatting} and Scoping";
title8 "Example of ^{super ^{style [foreground=red] red ^{style [foreground=green] green } and ^{style [foreground=blue] blue}}} formatting";

ods html file="example1.html";

ods rtf file="example1.rtf";


proc print data=sashelp.class;
run;

ods _all_ close;
