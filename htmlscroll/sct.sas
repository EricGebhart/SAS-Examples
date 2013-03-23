
%inc  "htmlscroll.tpl";

run;

ods tagsets.htmlscroll file="scroll.html"
           options(scroll_batch_size='6');

proc print data=sashelp.class;
run;

ods tagsets.htmlscroll close;

