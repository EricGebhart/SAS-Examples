ods listing close;

data two ;
   length text1 $ 12. text2 $ 12. w $ 26. a $ 12. b $ 22 c $ 10 d $ 15 e $ 26;
   do i = 1 to 20;
     if i < 5 then do
        x = 1; y = 5; z = 100; w='a long string of text'; d='hello to you';
        a='variable a';b='really long variable b'; c='i < 5';
        e='long text field';
        end;
     else
     if i <  3 then do
        x = 2; y = 60; z = 200; w='some short text'; d='hello to you';
        a='variable a';b='really long variable b'; c='i < 23';
        e='zyxwvutsrqponmlkjighfedcba';
        end;
     else
     if i < 14 then do
        x = 4; y = 160; z = 1100; w='abcdefghijklmnopqrstuvwxyz';
        d='hello to you';
        a='variable a';b='really long variable b'; c='i < 64';
        e='long text field';
        end;
     else do
        x = 6; y = 200; z = 2000; w='the end'; d='hello to you';
        e='long text field';
        a='variable a';b='really long variable b'; c='i < 100';
        end;
     text1 = 'text 1';
     text2 = 'text 2';
     output;
   end;

proc sort data=two;
by x;
run;

%filename (a, t53, xls);
ods tagsets.excelxp file=a options(pagebreaks='yes' skip_space='2,1,2,2,3'
 sheet_interval='none' embedded_titles='yes' embedded_footnotes='yes');
 
title2 'Proc tabulate: ';    
footnote1 'using pagebreaks and skip_space';
proc tabulate data=two;
by x;
var x y z;
class text1 text2 w;
table w all,
  text1 text2 x*n x*mean x*sum x*pctsum
              y*n y*mean y*sum y*pctsum
              z*n z*mean z*sum z*pctsum all / condense;
run;

ods _all_ close;
