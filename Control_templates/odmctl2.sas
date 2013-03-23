 /*----------------------------------------------------------
  *
  *                 SAS  TEST  LIBRARY
  *
  *  NAME    :  ODMCTL2
  *  TITLE   :  Tests CONTROL TEMPLATES and select statement
  *          :    using a partial path
  *  INPUT   :
  *  OUTPUT  :
  *  SPECIAL :
  *  REQUIREMENTS :
  *---------------------------------------------------------*/
title1 'ODMCTL2: control templates w/select statement & partial path';


  /*-- Define control template        --*/
  /*-- Select using partial path name --*/
  /*------------------------------------*/
proc template;

   define control controls.select_partialpath;

     define event initialize;
             putlog "Select summary.quantiles";

             /*-- ods trace --*/
             trace output;

             /*-- ods select using partial path name --*/
             /*-- this is like doing an "ods html select ..." statement  --*/
             select summary.quantiles;

             show;
     end;

     define event close;
             putlog "ODA GOODBYE";
             document close;
     end;

     define event proc;
          start:
             putlog "HELLO: " proc_name;

          finish:
             putlog "GOODBYE";
     end;

   end;

run;


  /*-- Close listing output.     --*/
  /*-- The trace output info in  --*/
  /*-- the log should be from    --*/
  /*-- the items selected only.  --*/
  /*-------------------------------*/
ods listing close;


  /*-- Create output files --*/
  /*-------------------------*/
%filename (ab, mctl2ab, htm);

ods chtml file=ab control=select_partialpath;


   /*-- Creating data for proc capability --*/
   /*---------------------------------------*/

data mqc;
   do group=1 to 25;
     do i=1 to 5;
        x=ranuni(12345)*10;
        if group=5 then x=x*5;
        output;
     end;
   end;
run;

data mqc2;
 set mqc; x=x*group;
 if group < 7 then cls='Class 1';
 else if group < 15 then cls='Class 2';
 else cls='Class 3';
run;


title2 'Using control templates with select statements';
title3 'CHTML file has summary.quantiles';
proc capability data=mqc2 lp ;
 by cls;
 var x;
 histogram x/ normal midpoints=0 to 240 by 40
              name='HISTOGRAM' des='CAP2337P-2';
run;

ods chtml close;


  /*------------------------------------------------------
   *
   *               SAS  TEST  LIBRARY  TRAILER
   *
   *    SYSTEMS:  ALL
   *    PRODUCT:  sas
   *       KEYS:
   *        REF:
   *   COMMENTS:
   *    SUPPORT:  SASNCL
   *    CHANGES:  09sep04.ncl.  Created.
   *-----------------------------------------------------*/
