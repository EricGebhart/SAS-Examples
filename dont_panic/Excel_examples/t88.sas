  /****************************************************************
  *
  *            DEFECTS SYSTEM TEST LIBRARY
  *
  *
  *  DEFECTID: S0387216
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

 /* first problem */
 /*---------------*/
proc template; 
   define style styles.SUGI31; 
     parent = styles.Journal; 
       style vertical_header from header / 
             tagattr = 'rotate:45' 
         ; 
   end; 
 run; 
 
 ods tagsets.ExcelXP file="temp.xls" options( 
               sheet_interval="none" 
               absolute_column_width='5' 
               debug_level='-2' 
               ) style=sugi31; 
 
                  proc sort data=sashelp.class out=foo; 
                  by sex; 
 
           proc tabulate data=foo 
           order=data missing format=8.0 noseps formchar=',          '; 
              by sex; 
              class age sex name; 
              classlev name /s=vertical_header; 
              var height weight; 
              title; 
              table age,  name=' '*(height=' '*median=' '); 
 
           run; 
 
                 proc tabulate data=foo 
               order=data missing format=8.0 noseps   
               formchar=',          '; 
              by sex; 
              class age sex name; 
              classlev name /s=vertical_header; 
              var height weight; 
              title; 
              table age,  name=' '*(height=' '*median=' '*F=5.3); 
 
           run; 
 
 
       ods tagsets.ExcelXP close; 



  /* second problem  */
  /*-----------------*/
data test; 
input region $ x; 
cards; 
UTWT 11713.5 
UTWT 11782.88 
SYR 3967.86 
SYR 7379.93 
U&S 15681.36 
U&S 19162.81 
; 
run; 
 
ods listing close; 
*ods tagsets.msoffice2k file='test.xls'; 
ods tagsets.excelxp file='test.xls' ; 
 
PROC REPORT data=test nowd ; 
column  region x; 
define x / format=dollar12.2; 
compute region; 
If region='SYR' then call 
define(_row_,'style','style=[background=YELLOW]'); 
endcomp; 
RUN; 
 
ODS tagsets.excelxp close; 
ods tagsets.msoffice2k close; 
ods listing; 
