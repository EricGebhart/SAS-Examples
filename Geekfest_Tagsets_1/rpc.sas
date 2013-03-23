
/*%inc "xmlrpc.tpl";*/

ods tagsets.odsxrpcs file='rpc.xml';

proc print data=sashelp.class;
run;

ods _all_ close;    

