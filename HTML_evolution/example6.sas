ods tagsets.html4 file="example6.html" style=seaside 
         options(body_toc='yes' toc_type='menu'
                 scroll_tables='yes' scroll_control_images='yes' 
                 panelling='yes');

ods tagsets.html4 event=panel(start);

proc print data=sashelp.class;
run;

proc standard print data=sashelp.class;
run;

proc report data=sashelp.class nowd;
run;

ods tagsets.html4 event=panel(finish);


ods html close;
