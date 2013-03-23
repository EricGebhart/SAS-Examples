%let repout = c:\workshop\ws187\htmout\;
*---------------------------------------------------------------------------------;
ods listing close;
ods html body = "&repout.rephow1.htm";

title 'Blood Pressure Med Study - Vanilla';
*---------------------------------------------------------------------------------;
proc report data=work.bptrial nowd split='\';

   column patient drug sex visitdate 
          systolic diastolic fever nausea rash;

   define patient   / order;
   define drug      / order;
   define sex       / order;
   define visitdate / analysis format=date7.;
   define systolic  / analysis;
   define diastolic / analysis;
   define fever     / analysis;
   define nausea    / analysis;
   define rash      / analysis;
run;
*---------------------------------------------------------------------------------;
ods html close;
ods listing;
