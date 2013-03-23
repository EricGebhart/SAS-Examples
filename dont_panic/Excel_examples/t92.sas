  /****************************************************************
  *
  *            DEFECTS SYSTEM TEST LIBRARY
  *
  *
  *  DEFECTID: S0365005
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

title1 'ODMEXL11: Using EXCELXP with options';

ods tagsets.excelxp file='t91.xls';

data beets;
   do harvest=1 to 2;
      do rep=1 to 6;
         do col=1 to 6;
            input variety y @; output;
            end;
         end;
      end;
cards;
3 19.1 6 18.3 5 19.6 1 18.6 2 18.2 4 18.5
6 18.1 2 19.5 4 17.6 3 18.7 1 18.7 5 19.9
1 18.1 5 20.2 6 18.5 4 20.1 3 18.6 2 19.2
2 19.1 3 18.8 1 18.7 5 20.2 4 18.6 6 18.5
4 17.5 1 18.1 2 18.7 6 18.2 5 20.4 3 18.5
5 17.7 4 17.8 3 17.4 2 17.0 6 17.6 1 17.6
3 16.2 6 17.0 5 18.1 1 16.6 2 17.7 4 16.3
6 16.0 2 15.3 4 16.0 3 17.1 1 16.5 5 17.6
1 16.5 5 18.1 6 16.7 4 16.2 3 16.7 2 17.3
2 17.5 3 16.0 1 16.4 5 18.0 4 16.6 6 16.1
4 15.7 1 16.1 2 16.7 6 16.3 5 17.8 3 16.2
5 18.3 4 16.6 3 16.4 2 17.6 6 17.1 1 16.5
;

ods trace on;
ods select modelanova;

title2 'specifying sheet_interval=page, autofilter_table=3, autofilter=2';
proc anova;
  class col rep variety harvest;
  model y= rep col variety rep*col*variety
    harvest harvest*rep
    harvest*variety;

  test h=rep col variety e=rep*col*variety;
  test h=harvest e=harvest*rep;
run;

ods tagsets.excelxp close;
