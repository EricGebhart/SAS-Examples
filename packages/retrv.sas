

%let datanum = 1;
%macro getPack(pid);

 %put Entering getPack with pid of &pid;

 %let first=1;
 %do %while (&rc = 0);
   %put   ;
   %let rhandle = 0;
   %let rtype = aaaaaaaaaaaaaaaaaa;
   %let desc=aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa;
   %let nv=aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa;
   %let rc=0;
   %let mimeType=aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa;

   %if (&first = 1)  %then %do;
     %syscall entry_first(pid, rhandle, rtype, mimeType, desc, nv, rc);
     %if &rc >= 0 %then %do;
       %put entry_first successful.;
       %put Entry handle  is &rhandle;
       %put Entry  type is * &rtype *;
       %put Entry desc is * &desc *;
       %put Entry nameValue is * &nv *;
       %put Entry mimeType is * &mimeType *;
       %let rc=0;
     %end;
     %else  %do;
       %let msg = %sysfunc(sysmsg());
       %put &msg;
     %end;
     %let first=0;
   %end;
   %else %do;
     %syscall entry_next(pid, rhandle, rtype, mimeType, desc, nv, rc);
     %if &rc >= 0 %then %do;
       %put entry_next successful.;
       %put Entry rhandle is &rhandle;
       %put Entry  type is * &rtype *;
       %put Entry desc is * &desc *;
       %put Entry nameValue is * &nv *;
       %put Entry mimeType is * &mimeType *;
       %let rc=0;
     %end;
     %else  %do;
       %put  Index next failed.;
       %let msg = %sysfunc(sysmsg());
       %put &msg;
     %end;
   %end;


 %end;
%let rc=0;
%mend;







%macro steph;
%let plist=0;
%let total=0;
%let rc=0;
%let plist=0;
%let from=FROM_ARCHIVE;
%let info= t2.spk;
%let prop=Prop1, prop2;
%let v1=value1;
%let v2=value2;
%syscall retrieve_package(plist, from,info, total, rc);
%if &rc ne 0 %then %do; %put RC from retrieve is   &rc;

       %let msg = %sysfunc(sysmsg());
       %put &msg;
     %end;
%else %put Retrieve package successful with total of &total.;

%let count = 1;
%let firstp = 1;
%do %while (&count <= &total);
%put     ;
%put   ;
%put   ;
 %let pid = 0;
 %let num=0;
 %let dt=0;
 %let desc=aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa;
 %let nv=aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa;
 %let rc=0;
%let exp=0;
%let chList=aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa;
 %if (&firstp = 1) %then %do;
   %let prop=EXPIRATION_DATETIME;
   %syscall package_first(plist, pid,num, desc,dt, nv,chList, rc, prop, exp);
   %if &rc ne 0 %then %put Rc from package_first is  &rc;
   %else %put Package_first ok.;
   %let firstp =0;
 %end;
 %else %do;
   %let prop = ABSTRACT; %let abstract=aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa;
   %syscall package_next(plist, pid,num, desc,dt, nv,chList, rc);
     %if &rc eq 0 %then %do;
       %put Package next  successful.;

     %end;
     %else  %do;
       %put Package next failed.;
       %let msg = %sysfunc(sysmsg());
       %put &msg;
     %end;

 %end;

 %if (&rc = 0) %then %do;
   %put Package Desc: &desc;
   %put Package pieces total: &num;

   %put  Package datetime is  %sysfunc(putn(&dt, datetime20.));
  %put  Expiration datetime is  %sysfunc(putn(&exp, datetime20.));
   %put Package nv: &nv;
   %getPack(&pid);
 %end;

%let count = %eval(&count+1);



%end;

%syscall package_term(plist, rc);
%if &rc ne 0 %then %do;
  %put Term failed.;
  %let msg = %sysfunc(sysmsg());
  %put &msg;
%end;
%else %put Package_term successful.;


%mend;
%steph;




                                  proc datasets;quit;
