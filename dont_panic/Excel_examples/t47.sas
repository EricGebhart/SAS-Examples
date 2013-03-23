ods listing close;
title;
ods pdf file='test.pdf';
ods html file="test.html" ;

data _null_;
declare odsout obj();
obj.layout_gridded(columns:3);
obj.region(column:1,overrides:"frame=void borderwidth=0 background=_undef_ 
rules=none rightmargin=_undef_");
obj.table_start(name: name,
Label:"Model Summary",
overrides:"Just=L
 frame=void
 background=_undef_
 cellpadding=0
 font_size=1
 borderwidth=0
 rules=none
");
obj.row_start();
obj.format_cell(text:"A"  ,column_span:4,overrides:"just=Left  
background=_undef_   rules=none borderwidth=0" );
obj.row_end();
obj.row_start();
obj.format_cell(text:"B"  ,column_span:4,overrides:"just=Left  
background=_undef_ borderwidth=0 rules=none" );
obj.row_end();
obj.row_start();
obj.format_Cell(text:"C"  ,column_span:4,overrides:"just=Left  
background=_undef_  borderwidth=0 rules=none");
obj.row_end();
obj.table_end();
obj.region(column:2);
obj.region(column:3);
obj.table_start(name: name,
Label:"Model Summary",
overrides:"Just=L
 frame=void
 background=_undef_
 cellpadding=0
 font_size=1
 borderwidth=0
 rules=none
");
obj.row_start();
obj.format_cell(text:"D" ,column_span:4,overrides:"just=Left  
background=_undef_   rules=none borderwidth=0" );
obj.row_end();
obj.row_start();
obj.format_cell(text:"E" ,column_span:4,overrides:"just=Left  
background=_undef_ borderwidth=0 rules=none" );
obj.row_end();
obj.row_start();
obj.format_Cell(text:"F" ,column_span:4,overrides:"just=Left  
background=_undef_  borderwidth=0 rules=none");
obj.row_end();
obj.table_end();
obj.layout_end();
run;
ods _all_ close;
ods listing;
