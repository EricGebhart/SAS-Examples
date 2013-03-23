 /****************************************************************/
 /*          S A S   S A M P L E   L I B R A R Y                 */
 /*                                                              */
 /*    NAME: ODSTAB9                                             */
 /*   TITLE: Demonstrates Highlighting Cells with PROC TABULATE  */
 /* PRODUCT: BASE                                                */
 /*  SYSTEM: ALL                                                 */
 /*    KEYS: ODS HTML BODY=                                      */
 /*   PROCS: TABULATE                                            */
 /*    DATA:                                                     */
 /* SUPPORT:                             UPDATE:                 */
 /*     REF:                                                     */
 /*    MISC:                                                     */
 /*                                                              */
 /****************************************************************/
 

  data failure;
     length process $20;
     input  process $ 3-11 day $ 15-21 cause $ 25-38 count 42-43;
     color = 'gray';

     if process = 'Process A' then process = 'Texas         ';
       else                          process = 'North Carolina';


    cards;
  Process A   March 1   Contamination    15
  Process A   March 1   Corrosion         2
  Process A   March 1   Doping            1
  Process A   March 1   Metallization     2
  Process A   March 1   Miscellaneous     0
  Process A   March 1   Oxide             8
  Process A   March 1   Silicon           1
  Process A   March 2   Contamination    16
  Process A   March 2   Corrosion         1
  Process A   March 2   Doping            1
  Process A   March 2   Metallization     3
  Process A   March 2   Miscellaneous     1
  Process A   March 2   Oxide             9
  Process A   March 2   Silicon           2
  Process A   March 3   Contamination    20
  Process A   March 3   Corrosion         1
  Process A   March 3   Doping            1
  Process A   March 3   Metallization     0
  Process A   March 3   Miscellaneous     3
  Process A   March 3   Oxide             7
  Process A   March 3   Silicon           2
  Process A   March 4   Contamination    12
  Process A   March 4   Corrosion         1
  Process A   March 4   Doping            1
  Process A   March 4   Metallization     0
  Process A   March 4   Miscellaneous     0
  Process A   March 4   Oxide            10
  Process A   March 4   Silicon           1
  Process A   March 5   Contamination    23
  Process A   March 5   Corrosion         1
  Process A   March 5   Doping            1
  Process A   March 5   Metallization     0
  Process A   March 5   Miscellaneous     1
  Process A   March 5   Oxide             8
  Process A   March 5   Silicon           2
  Process B   March 1   Contamination     8
  Process B   March 1   Corrosion         2
  Process B   March 1   Doping            1
  Process B   March 1   Metallization     4
  Process B   March 1   Miscellaneous     2
  Process B   March 1   Oxide            13
  Process B   March 1   Silicon           3
  Process B   March 2   Contamination     9
  Process B   March 2   Corrosion         0
  Process B   March 2   Doping            1
  Process B   March 2   Metallization     2
  Process B   March 2   Miscellaneous     1
  Process B   March 2   Oxide             9
  Process B   March 2   Silicon           2
  Process B   March 3   Contamination     4
  Process B   March 3   Corrosion         1
  Process B   March 3   Doping            1
  Process B   March 3   Metallization     0
  Process B   March 3   Miscellaneous     0
  Process B   March 3   Oxide            10
  Process B   March 3   Silicon           1
  Process B   March 4   Contamination     2
  Process B   March 4   Corrosion         2
  Process B   March 4   Doping            1
  Process B   March 4   Metallization     0
  Process B   March 4   Miscellaneous     1
  Process B   March 4   Oxide             7
  Process B   March 4   Silicon           1
  Process B   March 5   Contamination     1
  Process B   March 5   Corrosion         3
  Process B   March 5   Doping            1
  Process B   March 5   Metallization     0
  Process B   March 5   Miscellaneous     0
  Process B   March 5   Oxide             8
  Process B   March 5   Silicon           2
  run;


  data failuredetail;
    set failure;

    drop i count;

    do i = 1 to count;

       j = uniform(123);

       if process = 'Texas' then do;

          if      j < .2  then operator = 'Paul Kent           ';
          else if j < .4  then operator = 'Eric Gebhart        ';
          else if j < .6  then operator = 'Robert Ray          ';
          else if j < .78 then operator = "Dan O'Connor        ";
          else                 operator = 'Brian Schellenberger';

          end;

       else do;

          if      j < .3  then operator = 'Sandy McNeill       ';
          else if j < .4  then operator = 'David Kelley        ';
          else if j < .75 then operator = 'Chris Olinger       ';
          else if j < .9  then operator = 'Lewis Church        ';
          else                 operator = 'Martyn Wheeler      ';

          end;

       opref = 'opref' ;
      
                      

       output;

       end;


       keep process operator opref cause;

    run;


 /* Point ODS in the right direction. */

ods tagsets.colorlatex file="color.tex" stylesheet="sas.sty"(url="sas");
  ods html file="odstab9.htm";
  ods listing close;


  proc format;

    value downb low-9.9     = 'cxd3d3d3'
                10-14.99    = 'pink'
                15-high     = 'cxd02020'
                other       = 'violet';

    value downf 15-high     = 'white'
                 other      = 'black'
                 ;

    /* Replace the src= path with the path of your own image */
    /* and remove the title=                                 */
   
    value $proimg  'Texas'          = 'Texas'

               'North Carolina' = 'North Carolina'
                 ;

    value $cause (notsorted)
                 'Oxide'          = 'Oxide'
                 'Contamination'  = 'Contamination>'
                 'Silicon'        = 'Silicon'
                 other            = 'Other'
                 ;
  run;


  proc tabulate data=failuredetail;


    class process;
    format process $proimg.;

    %let opclass=opref;
    %let opclass=operator;

    class &opclass;

    class cause / preloadFmt order= data;
    format cause $cause.;


    classlev process    / style={foreground=black
                                 background=gray vjust=c just=c};
    classlev &opclass   / style={font_weight=bold
                                 font_style=italic};
    classlev cause      / style={font_weight=bold
                                 font_style=italic};

    keyword  all / style={foreground=black
                          background=gray font_weight=bold};

    table process='Process'
          * (
             all='Overall'  * {style={background=gray
                                      foreground=black
                                      font_weight=bold
                                      font_size=4}}
             &opclass=' '   * {style={background=downb.
                                      foreground=downf.
                                      font_weight=bold}}
            )
      ,
         pctn <&opclass * cause all * cause> =' '
          * cause=' '


      / indent = 0;

  run;


 /* All done, let us take a look. */

  ods html close;
  ods tagsets.colorlatex close;
  

