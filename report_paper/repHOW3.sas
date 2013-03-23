%let repout = c:\workshop\ws187\htmout\;
%let gifs   = c:\workshop\ws187\code\;
*---------------------------------------------------------------------------------;
ods listing close;
ods html body   = "&repout.rephow3det.htm"
         anchor = "pt1";

title1 'Blood Pressure Med Study - Detail (enhanced-1)';
title2 'Add Images and Data Above Headers';
*---------------------------------------------------------------------------------;
proc report data=work.bptrial nowd split='\'
             style=[preimage="&gifs.medical.gif"];
   column patient drug sex visitdate 
          ("Blood Pressure" systolic slash diastolic)
          fever nausea rash;

   define patient   / order noprint;
   define drug      / order;
   define sex       / order;
   define visitdate / analysis format=date7.;
   define systolic  / analysis 'Systolic';
   define slash     / computed '/';
   define diastolic / analysis 'Diastolic' left;
   define fever     / analysis center;
   define nausea    / analysis center;
   define rash      / analysis center;

   compute before patient;
      if  fever.sum  = . 
      and nausea.sum = . 
      and rash.sum   = . then reaction = 'No ';
                         else reaction = 'Yes';

      lastsys  = .;
      lastdias = .;
   endcomp;

   compute before _page_ / center ;
      line 'Patient Number: '        patient  $5.;
      line 'Reaction to medicine?: ' reaction $3.;
   endcomp;

   compute slash / length=1;
      slash = '/';
   endcomp;

   compute systolic;
      if lastsys ne . then do;
         if systolic.sum gt lastsys 
         then call define(_col_,'style',
                          'style=[foreground=red preimage="&gifs.trendupsm.gif"]');
         else if systolic.sum lt lastsys 
         then call define(_col_,'style',
                          'style=[foreground=green preimage="&gifs.trenddownsm.gif"]');
      end;
      lastsys = systolic.sum;
   endcomp;

   compute diastolic;
      if lastdias ne . then do;
         if diastolic.sum gt lastdias then
         call define(_col_,'style',
                     'style=[foreground=red postimage="&gifs.trendupsm.gif"]');
         else if diastolic.sum lt lastdias then
         call define(_col_,'style',
                     'style=[foreground=green postimage="&gifs.trenddownsm.gif"]');
      end;
      lastdias = diastolic.sum;
   endcomp;

   break after patient / page;
run;
*---------------------------------------------------------------------------------;
ods html close;
ods listing;
