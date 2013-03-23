
/*
length question $50
       dept $10
       diff valid 2
       pct1 pct2 pct3  3;

input @1  question 
      @52  dept
      @63 diff
      @66 valid
      @69 pct1
      @73 pct2
      @77 pct3;

label   question = 'Question'
        dept = 'Department'
        diff = 'Diff % Fav'
        validN = 'Valid N'
        pct1 = 'Unfavorable'
        pct2 = 'Neutral'
        pct3 = 'Favorable';

/*2345671901234567890123456789012345678901234567890123456789012345678901234567890*/
*/

*INPUT question $ 1-50 dept $ 52-61 diff 63-64 valid 66-67 pct1 69-71 pct2 72-75 pct3 76-79;
data test;
label   question = 'Question'
        dept = 'Department'
        diff = 'Diff % Fav'
        validN = 'Valid N'
        pct1 = 'Unfavorable'
        pct2 = 'Neutral'
        pct3 = 'Favorable';
format pct1 pct2 pct3 percent.;
INPUT @1 question $50. @52 dept $10. @63 diff 2. @66 valid 2. @69 (pct1 pct2 pct3) (percent.) ; 


cards;
The computer I have is adequate for my needs       Design     10 30 50%   10%   40% 
The computer I have is adequate for my needs       Marketing  10 30 10%   40%   50% 
The computer I have is adequate for my needs       Devel      10 30 50%   10%   40% 
The computer I have is adequate for my needs       Pubs       10 30 10%   40%   50% 
The Software on my computer is always up to date   Design     10 30 10%   40%   50% 
The Software on my computer is always up to date   Marketing  10 30 50%   10%   40% 
The Software on my computer is always up to date   Devel      10 30 90%   01%   08% 
The Software on my computer is always up to date   Pubs       10 30 10%   40%   50% 
I feel adequately protected from computer viruses  Design     10 30 50%   10%   40% 
I feel adequately protected from computer viruses  Marketing  10 30 10%   40%   50% 
I feel adequately protected from computer viruses  Devel      10 30 50%   10%   40% 
I feel adequately protected from computer viruses  Pubs       10 30 90%   01%   08% 
The OS and tools are the best available for my job Design     10 30 50%   10%   40% 
The OS and tools are the best available for my job Marketing  10 30 10%   40%   50% 
The OS and tools are the best available for my job Devel      10 30 50%   30%   20% 
The OS and tools are the best available for my job Pubs       10 30 80%   15%   05% 
;

run;


ods html file='test.html';

proc print data=test;
run;

ods html close;

