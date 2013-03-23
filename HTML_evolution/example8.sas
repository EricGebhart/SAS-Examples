ods tagsets.html4 file="example8.html" style=seaside 
         options(body_toc='yes' toc_type='menu'
                 scroll_tables='yes' scroll_control_images='yes' 
                 );

ods tagsets.html4 event=row_panel(start);

ods tagsets.html4 event=column_panel(start);

proc print data=sashelp.class;
run;

proc standard print data=sashelp.class;
run;

ods tagsets.html4 event=column_panel(finish);

ods tagsets.html4 event=column_panel(start);

ods tagsets.html4 
         options(body_toc='yes' toc_type='menu'
                 scroll_long_table_length='22' );


proc report data=sashelp.class nowd;
run;

ods tagsets.html4 event=column_panel(finish);
ods tagsets.html4 event=row_panel(finish);


ods html close;
