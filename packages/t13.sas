data stan;
  do i = 1 to 100;
    k = normal(12345);
    j = uniform(3579);
    jk = j*k;
    output;
    end;
  label k='Some dang Label'
        jk='Some even dangier Label. Longer too.';
  run;

        /*------------------------------------------------------------*/
        /*-- this is some hokey stuff paul invented.                --*/
        /*------------------------------------------------------------*/

options ls=72;
proc standard print mean=75 out=stanout;
  run;

options ls=120;
proc standard print mean=75 out=stanout;
  run;

options nocenter;
proc sql;
  select i,j,k,jk length=8 format=16.2
    from stanout;


        /*------------------------------------------------------------*/
        /*-- chris will want to add some more stuff here.           --*/
        /*------------------------------------------------------------*/

data a;
   input student section test1-test3;
   stest1=test1;
   stest2=test2;
   stest3=test3;
   cards;
238900545 1 94 91 87
254701167 1 95 96 97
238806445 2 91 86 94
999002527 2 80 76 78
263924860 1 92 40 85
459700886 2 75 76 80
416724915 2 66 69 72
999001230 1 82 84 80
242760674 1 75 76 70
990001252 2 51 66 91
;
run;

proc sort;
   by section;
run;

options center;
proc standard mean=80 std=5 out=new print;
   by section;
   var stest1-stest3;
run; 
