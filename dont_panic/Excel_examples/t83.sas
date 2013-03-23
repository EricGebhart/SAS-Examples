data class;
    length var1 $4;
	set sashelp.class;
	var1=put(_n_,z4.);
	var2=_n_;
run;

** name is char and var1 is char;
** BUT, name has = and var1 does NOT have =;

ods csv file="t83.csv" options(quote_by_type = 'yes' prepend_equals="yes" );

proc print data=class;
var name age height var1 var2;
format age eurox12.2;
run;

proc report data=class nowd;
	column name age height var1 var2;
	define age /  format=eurox12.2;
run;

ods csv close;
