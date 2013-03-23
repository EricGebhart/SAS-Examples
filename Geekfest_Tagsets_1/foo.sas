
ods html style=analysis file="foo.html" stylesheet="foo.css";

ods tagsets.event_map file="foo.xml";
ods tagsets.text_map file="foo.txt";


proc print data=sashelp.class;
run;

ods _all_ close;
