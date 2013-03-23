 /*----------------------------------------------------------
  *
  *                 SAS  TEST  LIBRARY
  *
  *  NAME    :  ODMCTL8
  *  TITLE   :  Tests CONTROL TEMPLATES and exclude statement
  *          :    using a partial path
  *  INPUT   :
  *  OUTPUT  :
  *  SPECIAL :
  *  REQUIREMENTS :
  *---------------------------------------------------------*/
title1 'ODMCTL8: control templates w/exclude statement & partial path';


  /*-- Define control template         --*/
  /*-- Exclude using partial path name --*/
  /*-------------------------------------*/
proc template;

   define control controls.exclude_partialpath;

     define event initialize;
             putlog "Exclude summary.quantiles";

             /*-- ods trace --*/
             trace output;

             /*-- ods exclude using partial path name --*/
             exclude summary.quantiles;

             show;
     end;

   end;

run;

  /*-- Close listing output --*/
  /*--------------------------*/
ods listing close;


  /*-- Create output files --*/
  /*-------------------------*/
%filename (ab, mctl8ab, htm);

ods html file=ab control=exclude_partialpath;


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


title2 'Using control templates with exclude statements';
title4 'HTML file excludes summary.quantiles';
proc capability data=mqc2 lp ;
 by cls;
 var x;
 histogram x/ normal midpoints=0 to 240 by 40
              name='HISTOGRAM' des='CAP2337P-2';
run;

ods html close;



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
   *    CHANGES:  27aug04.ncl.  Created.
   *-----------------------------------------------------*/
