ods tagsets.excelxp alias="bygroup" file='mexl2ab.xls';
ods html file="t93.html";


data cake;
input LastName $ 1-12 PresentScore 14-15 TasteScore 17-18
Flavor $ 21-30 Layers 32;
datalines;
Orlando      93 80  Vanilla    1
Goldston     68 75  Vanilla    1
Roe          79 73  Vanilla    2
Larsen       77 84  Chocolate  .
Strickland   82 79  Chocolate  1
Nguyen       77 84  Vanilla    .
Hildenbrand  81 83  Chocolate  1
Byron        72 87  Vanilla    2
Sanders      56 79  Chocolate  1
Jaeger       66 74             1
Davis        69 75  Chocolate  2
Conrad       85 94  Vanilla    1
Walters      67 72  Chocolate  2
Matthew      81 92  Chocolate  2
Anderson     87 85  Chocolate  1
Merritt      73 84  Chocolate  1
;

proc format ;
value layerfmt 1='single layer'
               2-3='multi-layer'
               .='unknown';
value $flvrfmt (notsorted)
'Vanilla'='Vanilla'
'Orange','Lemon'='Citrus'
'Mint','Almond'='Other Flavor';
run;

proc sort data=cake;
by flavor;
run;

title2 '001:  Proc report with by groups';
proc report data=cake nowd headline headskip missing;
by flavor;
column flavor layers presentscore tastescore;
define flavor / order format=$flvrfmt.;
define layers / order format=layerfmt.;
define presentscore / mean 'Average Presentation Score';
define tastescore / mean 'Average Taste Score';
break after flavor / ol ul summarize skip;
run;

 ods  _all_ close;
