
%inc "repHOWdata.sas";


*%let repout = c:\workshop\ws187\htmout\;
%let repout = ./;
*%let gifs   = c:\workshop\ws187\code\;
%let gifs   = ./;
*---------------------------------------------------------------------------------;
ods listing close;
*---------------------------------------------------------------------------------;
proc format;
   value fevfmt  1 = 'pink'
                 . = 'lightcyan';
   value nausfmt 1 = '#d8859f'
                 . = 'lightcyan';
   value rashfmt 1 = '#bb2222'
                 . = 'lightcyan';
run;
*---------------------------------------------------------------------------------;
ods html body = "&repout.rephow5summ.htm";
*---------------------------------------------------------------------------------;
title1 "Blood Pressure Med Study - Summary (enhanced)";
title2 "Add Colors";
*---------------------------------------------------------------------------------;
proc report data=work.bptrial nowd
             style(report) = [rules=all cellspacing=0 bordercolor=gray]
             style(header) = [background=lightskyblue foreground=black]
             style(column) = [background=lightcyan foreground=black];

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
      else do;
         reaction = 'Yes';
         call define(_col_,'style','style=[foreground=red background=pink font_weight=bold]');
      end;
   endcomp;

   compute before patient;
      ptno + 1;
   endcomp;

   compute patient;
      urlstring = "&repout.rephow5det.htm#pt" || left(put(ptno,3.0));
      call define (_col_, 'URL', urlstring );
   endcomp;
run;
*---------------------------------------------------------------------------------;
ods html close;
*---------------------------------------------------------------------------------;
ods html body   = "&repout.rephow5det.htm"
         anchor = "pt1";
*---------------------------------------------------------------------------------;
title1 "Blood Pressure Med Study - Detail (enhanced-3)";
title2 "Alternate Method for Reaction Colors & Navigation Title";
title3 "<H4><A HREF='&repout.rephow5summ.htm'>All Patient Summary</A></H4>";
*---------------------------------------------------------------------------------;
proc report data=work.bptrial nowd split='\'
             style(report) = [rules=all cellspacing=0 bordercolor=gray]
             style(header) = [background=lightskyblue foreground=black]
             style(column) = [background=lightcyan foreground=black];

   column patient drug sex visitdate 
          ("Blood Pressure" systolic slash diastolic)
          ("Reactions" fever nausea rash)
          systolic=sysmean diastolic=diasmean;

   define patient   / order noprint;
   define drug      / order;
   define sex       / order;
   define visitdate / analysis format=date7.;
   define systolic  / analysis 'Systolic';
   define slash     / computed '/';
   define diastolic / analysis 'Diastolic' left;
   define fever     / analysis sum center style(column)=[background=fevfmt.];
   define nausea    / analysis sum center style(column)=[background=nausfmt.];
   define rash      / analysis sum center style(column)=[background=rashfmt.];
   define sysmean   / mean noprint;
   define diasmean  / mean noprint;

   compute before _page_ / center style=[font_weight=bold foreground=black
                                         background=lightyellow];
      line 'Patient Number: '       patient   $5.;
      line 'Reaction to medicine? ' reaction  $3.;
      line 'Systolic mean: '        sysmean    3.;
      line 'Diastolic mean: '       diasmean   3.;
   endcomp;

   compute before patient;
      if  fever.sum  = . 
      and nausea.sum = . 
      and rash.sum   = . then reaction = 'No ';
                         else reaction = 'Yes';

      lastsys  = .;
      lastdias = .;
   endcomp;

   compute slash / length=1;
      slash = '/';
   endcomp;

   compute systolic;
      if lastsys ne . then do;
         if systolic.sum gt lastsys 
         then call define(_col_,'style',
                          'style=[foreground=red font_weight=bold
                                  preimage="&gifs.trendupsm.gif"]');
         else if systolic.sum lt lastsys
         then call define(_col_,'style',
                         'style=[foreground=green font_weight=bold
                          preimage="&gifs.trenddownsm.gif"]');
      end;
      lastsys = systolic.sum;
   endcomp;

   compute diastolic;
      if lastdias ne . then do;
         if diastolic.sum gt lastdias 
         then call define(_col_,'style',
                          'style=[foreground=red font_weight=bold  
                                  postimage="&gifs.trendupsm.gif"]');
         else if diastolic.sum lt lastdias 
         then call define(_col_,'style',
                          'style=[foreground=green font_weight=bold 
                                  postimage="&gifs.trenddownsm.gif"]');
      end;
      lastdias = diastolic.sum;
   endcomp;

   break after patient / page;
run;
*---------------------------------------------------------------------------------;
ods html close;
ods listing;


