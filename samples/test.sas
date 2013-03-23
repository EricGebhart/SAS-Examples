/* Create a view descriptor on a 32-bit host ( i.e. Booker ) FTP the guy over to
a 64-bit machine ( STONES ) and try to print )

proc access dbms=sybase;
create x.tmp.access;
table = DEPT;
user = 'dbitest';
sybpw = 'dbitest';
server = HP_1150;

create x.vtmp.view;
select all;
run;

/* on 64-bit machine */
proc print data=x.vtmp; run;
