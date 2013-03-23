  /****************************************************************
  *
  *            DEFECTS SYSTEM TEST LIBRARY
  *
  *
  *  DEFECTID: S0396371
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

/* close the listing destination to avoid error message */
ods listing close;

/* Create dummy data */
data test;
  input c1 $ c2 $ c3 $;
datalines;
hello1 . . 
. hello2 .
. . hello3
;

ods html file='bycell_rules.html' options(css_table="yes");

data _null_;
  set test end=done;

  /* Load values into an array for COLUMNS and an 
     array for OVERRIDE ATTRIBUTES */
  array c(3) c1 c2 c3;
  array cellattr(3)$20. _temporary_ ('font_weight=bold', ' ', 'background=red');

  if _N_=1 then do;
    declare odsout ByCell();
    ByCell.table_start();
  end;

  /* start a new row in the table */
  ByCell.row_start();
  /* For each element in the C array, check to see if its non-missing, 
     if so, execute a FORMAT_CELL with an override argument.  Note that 
     if an array reference is used in the override, the override occurs,
     but the text of the override instruction is written out rather than the 
     text of the DATA|TEXT argument.
  */
  do col = 1 to dim(c);
    *if c{col} ne '' then ByCell.format_cell
       (text: c{col}, overrides: cellattr{col});
    /* USING TRIM avoids the defect in S0396275 */
    if c{col} ne '' then ByCell.format_cell
      (text: c{col}, overrides: trim(cellattr{col}));
    else ByCell.format_cell();
  end;
  /* terminate the row*/
  ByCell.row_end();

   /* on the last observation of the data set, terminate the 
      table and delete the object */
 if done then do;
   ByCell.table_end();
   ByCell.delete();
 end;
run;

ods _all_ close;
/* Reopen listing */
ods listing;
