
/*---------------------------------------------------------------eric-*/
/*-- Set this break point:                                          --*/
/*-- d sasxml:\xmldoc.c 1819 {dz event_name}                        --*/
/*--                                                                --*/
/*-- You will see the events go by.  There aren't very many left so --*/
/*-- it won't take long to get where you want to be.                --*/
/*------------------------------------------------------------11Jun02-*/

/*---------------------------------------------------------------eric-*/
/*-- There are 3 procs here.  shewhart, cusum, and macctrl.  All    --*/
/*-- have the same problem of not terminating their bygroups if     --*/
/*-- they don't get a quit.                                         --*/
/*------------------------------------------------------------11Jun02-*/

OPTIONS NODATE NOSTIMER LS=78 PS=60;

ods listing close;

proc template;
    define tagset tagsets.leaf;
       parent = tagsets.short_map;
       image_formats = "gif,jpeg";

       define event leaf;
       end;   
       define event output_object;
       end;   
       define event image;
       end;   
       define event pagebreak;
       end;   
       define event system_footer_group;
       end;   
       define event system_footer;
       end;   
       define event system_footer_setup_group;
       end;   
       define event system_footer_setup;
       end;   
       define event put_value;
       end;   
       define event page_anchor;
       end;   
       define event anchor;
       end;   
       define event span_group;
       end;   
       define event span_header_colspec;
       end;   
       define event header_spec;
       end;   
       define event title_container_row;
       end;   
       define event title_container;
       end;   
       define event title_container_specs;
       end;   
       define event title_container_spec;
       end;   
       define event title_setup_container;
       end;   
       define event title_setup_container_row;
       end;   
       define event title_setup_container_spec;
       end;   
       define event title_setup_container_specs;
       end;   
       define event row_group;
       end;   
       define event row_header_spec;
       end;   
       define event sub_rowheader_colspec;
       end;   
       define event proc_title_group;
       end;   
       define event proc_title;
       end;   
       define event table;
       end;   
       define event output;
       end;   
       define event data;
       end;   
       define event row;
       end;   
       define event table_body;
       end;   
       define event table_head;
       end;   
       define event page_setup;
       end;   
       define event system_title;
       end;   
       define event system_title_group;
       end;   
       define event system_title_setup;
       end;   
       define event system_title_setup_group;
       end;   
       define event cell_is_empty;
       end;   
       define event rowspec;
       end;   
       define event colgroup;
       end;   
       define event colspecs;
       end;   
       define event colspec_entry;
       end;   
       define event colspecsep;
       end;   
       define event cellspec;
       end;   
       define event cellspecsep;
       end;   
       define event doc_head;
       end;
       define event doc_meta;
       end;
       define event auth_oper;
       end;
       define event doc_title;
       end;
       define event stylesheet_link;
       end;
       define event code_link;
       end;
       define event javascript;
       end;
       define event startup_function;
       end;
       define event shutdown_function;
       end;
       define event table_headers;
       end;
       define event col_header_spec;
       end;
       define event sub_header_colspec;
       end;
       define event sub_colspec_header;
       end;
       define event header;
       end;
       define event cellspecspan;
       end;
       define event colspanfillsep;
       end;
       define event colspanfill;
       end;
       define event rowspancolspanfill;
       end;
       define event rowspanfill;
       end;
   end;
run;

  ods tagsets.leaf body="test11.xml";
  ods rtf file="test11.rtf";
  ods pdf file="test11.pdf";
  ods document name=test11;
  ods html file="test11.html";

  goptions target=gif device=html ext=grf hsize=8 in
           vsize=6 in;



  symbol1 v=dot;

  data D134567z;
     input S134567z T134567z X134567z X234567z X334567z X434567z @;
     I134567z ='G'||put(S134567z,z2.);
     B134567z = ceil(S134567z/5);
     C134567z = mod(S134567z,5);
     length C234567z $6;
     select(B134567z);
        when(1) do;
           C234567z='cyan'; L134567z=1; _phase_='Phase1'; end;
        when(2) do;
           C234567z='yellow'; L134567z=2; _phase_='Phase2'; end;
        when(3) do;
           C234567z='gray'; L134567z=33; _phase_='Phase3'; end;
        otherwise;
        end;
     do i=1 to 5;
        input Y134567z @;
        do B234567z= 'G134567z','G234567z','G334567z' ;
           output;
           end;
        end;
     drop i;
     input;
     cards;
  1    0.72125   9.5 34.2 138.2 312.3 .70 .72 .61 .75 .73
  2    0.72376  11.5 49.4 287.0 358.0 .83 .68 .83 .71 .73
  3    0.72626  10.2 39.6 187.9 449.1 .86 .78 .71 .70 .90
  4    0.72877  11.7 31.1 140.5 256.5 .80 .78 .68 .70 .74
  5    0.73128   7.2 25.5 128.0  64.1 .64 .66 .79 .81 .68
  6    0.73379  15.5 30.9 142.9 335.5 .68 .64 .71 .69 .81
  7    0.73629   8.0 34.8 292.1 358.9 .80 .63 .69 .62 .75
  8    0.73880   3.1 20.8 169.1 231.6 .65 .81 .68 .84 .66
  9    0.74131   5.6 21.0 180.4 185.1 .64 .70 .66 .65 .93
  10   0.74381  10.7 29.4 472.6 319.1 .77 .83 .88 .70 .64
  11   0.74632  10.6 17.0  61.3 318.3 .72 .67 .77 .74 .72
  12   0.74883   7.8 27.3 190.5 181.1 .73 .66 .72 .73 .71
  13   0.75134  11.9 33.0 105.9 485.3 .79 .70 .63 .70 .88
  14   0.75384   4.3 39.6 106.2 224.8 .85 .80 .78 .85 .62
  15   0.75635   9.7 35.4 205.3 321.3 .67 .78 .81 .84 .96
  run;


  proc sort; by B234567z; run;

  /*-------------------*/
  /* Annotate data set */
  /*-------------------*/
  data D234567z;
     size=1; hsys='4'; xsys='1'; ysys='1'; color='blue';
     x=10; y=80; function='label'; texta='Global Annotate';
     position='6';
     do B234567z= 'G134567z','G234567z','G334567z' ;
        text = trim(texta) || ' ' || B234567z;
        output; y=y-10;
        end;
     drop texta;
  run;

  data D334567z;
     size=1; hsys='4'; xsys='1'; ysys='1'; color='red';
     x=10; y=40; function='label'; texta='Chart Annotate';
     position='6';
     do B234567z= 'G134567z','G234567z','G334567z' ;
        text = trim(texta) || ' ' || B234567z;
        output;
        end;
     drop texta;
  run;

  proc cusum data=D134567z;
       by B234567z;
       xchart Y134567z * S134567z / name='cush2ga'
          mu0=.71 alpha=.05 delta=1;
  run;

  goptions target=gif device=html ext=grf hsize=8 in
           vsize=6 in;

  options ls=80;
  symbol1 v=dot;

  data D134567z;
     input S134567z T134567z X134567z X234567z X334567z X434567z @;
     I134567z ='G'||put(S134567z,z2.);
     B134567z = ceil(S134567z/5);
     C134567z = mod(S134567z,5);
     length C234567z $6;
     select(B134567z);
        when(1) do; C234567z='cyan'; L134567z=1; _phase_='Phase1'; end;
        when(2) do; C234567z='yellow'; L134567z=2; _phase_='Phase2'; end;
        when(3) do; C234567z='gray'; L134567z=33; _phase_='Phase3'; end;
        otherwise;
        end;
     do i=1 to 5;
        input Y134567z @;
        S234567z = 5*(S134567z-1)+i;
        do B234567z= 'G134567z','G234567z','G334567z' ;
           output;
           end;
        end;
     drop i;
     input;
     cards;
  1    0.72125   9.5 34.2 138.2 312.3 .70 .72 .61 .75 .73
  2    0.72376  11.5 49.4 287.0 358.0 .83 .68 .83 .71 .73
  3    0.72626  10.2 39.6 187.9 449.1 .86 .78 .71 .70 .90
  4    0.72877  11.7 31.1 140.5 256.5 .80 .78 .68 .70 .74
  5    0.73128   7.2 25.5 128.0  64.1 .64 .66 .79 .81 .68
  6    0.73379  15.5 30.9 142.9 335.5 .68 .64 .71 .69 .81
  7    0.73629   8.0 34.8 292.1 358.9 .80 .63 .69 .62 .75
  8    0.73880   3.1 20.8 169.1 231.6 .65 .81 .68 .84 .66
  9    0.74131   5.6 21.0 180.4 185.1 .64 .70 .66 .65 .93
  10   0.74381  10.7 29.4 472.6 319.1 .77 .83 .88 .70 .64
  11   0.74632  10.6 17.0  61.3 318.3 .72 .67 .77 .74 .72
  12   0.74883   7.8 27.3 190.5 181.1 .73 .66 .72 .73 .71
  13   0.75134  11.9 33.0 105.9 485.3 .79 .70 .63 .70 .88
  14   0.75384   4.3 39.6 106.2 224.8 .85 .80 .78 .85 .62
  15   0.75635   9.7 35.4 205.3 321.3 .67 .78 .81 .84 .96
  run;


  proc sort; by B234567z; run;

  /*----------------------*/
  /* required syntax only */
  /*----------------------*/
  proc shewhart data=D134567z;
       xchart Y134567z * S134567z / name='sheh2ga';
       footnote 'test 1';
       by B234567z;
  run;


  goptions reset=global target=gif device=html ext=grf hsize=8 in
           vsize=6 in;

  options ls=80;
  symbol1 v=dot;

  data D134567z;
     input S134567z T134567z X134567z X234567z X334567z X434567z @;
     I134567z ='G'||put(S134567z,z2.);
     B134567z = ceil(S134567z/5);
     C134567z = mod(S134567z,5);
     length C234567z $6;
     select(B134567z);
        when(1) do;
           C234567z='cyan'; L134567z=1; _phase_='Phase1'; end;
        when(2) do;
           C234567z='yellow'; L134567z=2; _phase_='Phase2'; end;
        when(3) do;
           C234567z='gray'; L134567z=33; _phase_='Phase3'; end;
        otherwise;
        end;
     do i=1 to 5;
        input Y134567z @;
        do B234567z= 'G134567z','G234567z','G334567z' ;
           output;
           Y134567z = Y134567z + .1 + .01*rannor(12345);
           end;
        end;
     drop i;
     input;
     cards;
  1    0.72125   9.5 34.2 138.2 312.3 .70 .72 .61 .75 .73
  2    0.72376  11.5 49.4 287.0 358.0 .83 .68 .83 .71 .73
  3    0.72626  10.2 39.6 187.9 449.1 .86 .78 .71 .70 .90
  4    0.72877  11.7 31.1 140.5 256.5 .80 .78 .68 .70 .74
  5    0.73128   7.2 25.5 128.0  64.1 .64 .66 .79 .81 .68
  6    0.73379  15.5 30.9 142.9 335.5 .68 .64 .71 .69 .81
  7    0.73629   8.0 34.8 292.1 358.9 .80 .63 .69 .62 .75
  8    0.73880   3.1 20.8 169.1 231.6 .65 .81 .68 .84 .66
  9    0.74131   5.6 21.0 180.4 185.1 .64 .70 .66 .65 .93
  10   0.74381  10.7 29.4 472.6 319.1 .77 .83 .88 .70 .64
  11   0.74632  10.6 17.0  61.3 318.3 .72 .67 .77 .74 .72
  12   0.74883   7.8 27.3 190.5 181.1 .73 .66 .72 .73 .71
  13   0.75134  11.9 33.0 105.9 485.3 .79 .70 .63 .70 .88
  14   0.75384   4.3 39.6 106.2 224.8 .85 .80 .78 .85 .62
  15   0.75635   9.7 35.4 205.3 321.3 .67 .78 .81 .84 .96
  run;


  proc sort; by B234567z; run;

  /*-------------------*/
  /* Annotate data set */
  /*-------------------*/
  data D234567z;
     size=1; hsys='4'; xsys='1'; ysys='1'; color='blue';
     x=10; y=80; function='label'; texta='Global Annotate';
     position='6';
     do B234567z= 'G134567z','G234567z','G334567z' ;
        text = trim(texta) || ' ' || B234567z;
        output; y=y-10;
        end;
     drop texta;
  run;

  data D334567z;
     size=1; hsys='4'; xsys='1'; ysys='1'; color='red';
     x=10; y=40; function='label'; texta='Chart Annotate';
     position='6';
     do B234567z= 'G134567z','G234567z','G334567z' ;
        text = trim(texta) || ' ' || B234567z;
        output;
        end;
     drop texta;
  run;

  proc macontrol data=D134567z;
       by B234567z;
       machart Y134567z * S134567z /
          span=3 name='mach2ga';
  run;


ods _all_ close;

