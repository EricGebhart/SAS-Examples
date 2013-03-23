  
<sasl:code>
data one;
  input r1 r2 d $ @@;
cards;
100 200 a 100 201 b 100 202 c
101 210 d 101 211 e
;
run;

proc sort data=one out=one_sorted;
  by r1 r2;
run;

data two;
  set one_sorted end=last;
  by r1 r2;
  file "~/two.xml";
  length row1 row2 data $12;
  row1 = trim(left(put(r1,best12.)));
  row2 = trim(left(put(r2,best12.)));
  data = trim(left(htmlencode(d)));

  if _n_ = 1  then put @1 "<example>";
  if first.r1 then put @3 "<outer_tag row=""" row1 +(-1) """>";
  if first.r2 then put @5 "<inner_tag row=""" row2 +(-1) """ " @;
                   put "data=" """" data +(-1) """" @;
  if last.r2  then put "/>";
  if last.r1  then put @3 "</outer_tag>";
  if last     then put @1 "</example>";
run;
</sasl:code>

Chang Y. Chung
