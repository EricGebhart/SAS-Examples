/* Case 4 */
/* This is not user driven. Doing some testing found this       */
/* None of the TOC style information is in the Style definition */
/* When minimal is used.                                        */

ods tagsets.excelxp file="t25.xls" options(contents="yes"
) style=minimal;

proc print data=sashelp.class(obs=1);
run;

ods _all_ close;


