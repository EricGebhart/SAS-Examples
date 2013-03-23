
Ods escapechar="^";

Ods html file="example2.html";

title "Example ^{Style [color=red] of ^{line} a unicode Alpha ^{unicode ALPHA} with some lines ^{newline} ^{line} }" ;


title2 "Example ^{style [color=green] of ^{line} an image ^{inline_image Droplet.jpg} ^{newline} ^{line} }" ;


proc print data=sashelp.class;
run;


ods _all_ close;
