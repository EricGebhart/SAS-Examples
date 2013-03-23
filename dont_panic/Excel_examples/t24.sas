data one;
  x='first'||'252D'x||'second';
  y="first%-second";
  put y hex.;
 run;
 ods html file="t24.html";
 proc report data=one;
 run;
 ods html close;
