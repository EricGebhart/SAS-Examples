  /****************************************************************
  *
  *            DEFECTS SYSTEM TEST LIBRARY
  *
  *
  *  DEFECTID: S0401852
  *
  *  TEST STREAM PATHNAME:
  *
  *  RESULTS -- INCORRECT:
  *
  *
  *  RESULTS -- CORRECT:
  *
  ****************************************************************/

OPTIONS NODATE NOSTIMER LS=78 PS=60;


  data product;
    input prodname $ 1-10 prodcost prodlist;
    format prodcost prodlist dollar.;
   cards;
flippers      16    20
jet ski     2150  2675
kayak        190   240
raft           5     7
snorkel       12    15
surfboard    615   750
windsurfer  1090  1325
;
  run;


 %filename(b6, mrs0gb, htm);
  ods markup  tagset=htmlcss
           body=b6(url="mrs0gb.htm")
           recsep=none;

  proc print data=product;
    title2 '007 Print: Product Table, record_separator=none';
    title3 '    NONE is NOT specified as a character string';
    title4 '    Body=mrs0gb.htm';
  run;


   ods _all_ close;
