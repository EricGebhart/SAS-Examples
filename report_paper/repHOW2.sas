%let repout = c:\workshop\ws187\htmout\;
*---------------------------------------------------------------------------------;
ods listing close;
ods html body = "&repout.rephow2summ.htm";
*---------------------------------------------------------------------------------;
title 'Blood Pressure Med Study - Summary (basic)';
*---------------------------------------------------------------------------------;
proc report data=work.bptrial nowd split='\';

   column patient drug sex fever nausea rash reaction;

   define patient  / group;
   define drug     / group;
   define sex      / group;
   define fever    / analysis sum noprint;
   define nausea   / analysis sum noprint;
   define rash     / analysis sum noprint;
   define reaction / computed 'Reaction?';

   compute reaction / length=3;
      if  fever.sum  = . 
      and nausea.sum = . 
      and rash.sum   = . then reaction = 'No ';
                         else reaction = 'Yes';
   endcomp;

   compute before patient;
      ptno + 1;
   endcomp;

   compute patient;
      urlstring = "&repout.rephow2det.htm#pt" || left(put(ptno,3.0));
      call define (_col_, 'url', urlstring );
   endcomp;
run;
*---------------------------------------------------------------------------------;
ods html close;
*---------------------------------------------------------------------------------;
ods html body   = "&repout.rephow2det.htm"
         anchor = "pt1";
*---------------------------------------------------------------------------------;
title1 'Blood Pressure Med Study - Detail (basic)';
*---------------------------------------------------------------------------------;
proc report data=work.bptrial nowd split='\';

   column patient drug sex visitdate 
          ("Blood Pressure" systolic slash diastolic) 
          fever nausea rash;

   define patient   / order;
   define drug      / order;
   define sex       / order;
   define visitdate / analysis format=date7.;
   define systolic  / analysis 'Systolic';
   define slash     / computed '/';
   define diastolic / analysis 'Diastolic' left;
   define fever     / analysis center;
   define nausea    / analysis center;
   define rash      / analysis center;

   break after patient / page;

   compute slash / length=1;
      slash = '/';
   endcomp;
run;
*---------------------------------------------------------------------------------;
ods html close;
ods listing;
