/*
Ultimately I want a dataset like:                                                                         
100 200 a                                                                                                 
100 201 b                                                                                                 
100 202 c                                                                                                 
101 210 d                                                                                                 
101 211 e                                                                                                 
                                                                                                          
To look like:                                                                                             
<example>                                                                                                 
  <outer_tag row="100">                                                                                   
    <inner_tag row="200" data="a"/>                                                                       
    <inner_tag row="201" data="b"/>                                                                       
    <inner_tag row="202" data="c"/>                                                                       
  </outer_data>                                                                                           
  <outer_tag row="101">                                                                                   
    <inner_tag row="210" data="d"/>                                                                       
    <inner_tag row="211" data="e"/>                                                                       
  </outer_tag>                                                                                            
</example>                                    
*/

proc template;

    define tagset tagsets.print_example;
        indent = 2;
    
        define event doc;
            start:
                put '<example>' nl;
                ndent;
            finish:
                xdent;
                put '</example>' nl;
        end;

        define event byline;
            put '<outer_tag ' value '>' nl;
            ndent;
        end;

        define event table;
            finish:
                xdent;
                put '</outer_tag>' nl;
        end;

        define event row;
            start:
                break /if !cmp(section, "body");
                put "<inner_tag";
            finish:
                break /if !cmp(section, "body");
                put "/>" nl;
        end;

        define event data;
            putq " row=" value /if cmp(colstart, "1");
            putq " data=" value /if !cmp(colstart, "1");
        end;

    end;

run;


proc template;

    define tagset tagsets.tabulate_example;
        indent = 2;
    
        define event doc;
            start:
                put '<example>' nl;
                ndent;

                /*-----------------------------------------------eric-*/
                /*-- This is only because we have no way to prevent the first close--*/
                /*-- when we get the first data value.              --*/
                /*--                                                --*/
                /*--------------------------------------------29Oct03-*/
                trigger outer_tag;

                /*-----------------------------------------------eric-*/
                /*-- this is ugly too, but we can't suppress the '/>' on the--*/
                /*-- header row for the class vars.                 --*/
                /*--                                                --*/
                /*--------------------------------------------29Oct03-*/
                put '<inner_tag' ;
            finish:
                trigger outer_tag finish;
                xdent;
                put '</example>' nl;
        end;

        define event outer_tag;
            start:
                put '<outer_tag'; 
                putq ' row=' value;
                put '>' nl;
                ndent;
            finish:
                xdent;
                put '</outer_tag>' nl;
        end;

 
        define event inner_tag;
            put '<inner_tag' ;
            putq " row=" value; 
        end;

        /* close the inner_tag */
        define event row;
            finish:
                break /if !cmp(section, "body");
                put "/>" nl;
        end;

        define event data_attr;
            putq " data=" value /if !cmp(colstart, "1");
        end;
        
        define event header;
            /* throw away the head section of the table */
            break /if !cmp(section, "body");

            /* throw away the class headers */
            break /if cmp(value, "row");
            break /if cmp(value, "y");
            break /if cmp(value, "z");
        
            trigger outer_tag finish /if cmp(colstart, "1");
            trigger outer_tag /if cmp(colstart, "1");
            trigger inner_tag /if cmp(colstart, "2");
            trigger data_attr /if cmp(colstart, "3");
        end;

    end;

run;

proc template;

    define tagset tagsets.tabulate_example2;
        indent = 2;
    
        define event doc;
            start:
                put '<example>' nl;
                ndent;

            finish:
                trigger outer_tag finish;
                xdent;
                put '</example>' nl;
        end;

        define event outer_tag;
            start:
            
                put '<outer_tag'; 
                putq ' row=' value;
                put '>' nl;
                ndent;
            finish:
                break /if cmp(value, 'row');
                xdent;
                put '</outer_tag>' nl;
        end;

 
        define event inner_tag;
            put '<inner_tag' ;
            putq " row=" value; 
        end;

        /* close the inner_tag */
        define event row;
            finish:
                break /if !cmp(section, "body");
                put "/>" nl;
        end;

        define event data_attr;
            putq " data=" value /if !cmp(colstart, "1");
        end;
        
        define event header;
            /* throw away the head section of the table */
            break /if !cmp(section, "body");

            trigger outer_tag finish /if cmp(colstart, "1");
            trigger outer_tag /if cmp(colstart, "1");
            trigger inner_tag /if cmp(colstart, "2");
            trigger data_attr /if cmp(colstart, "3");
        end;

    end;

run;

data a;
    format x 3.;
    format y 3.;
    format z $1.;
    label x=row;
    input x y z ;
    cards;
100 200 a                                                                                                 
100 201 b                                                                                                 
100 202 c                                                                                                 
101 210 d                                                                                                 
101 211 e                                                                                                 
;
run;

proc sort  data=a;
  by x y;
run;

ods tagsets.print_example file="print.xml";

proc print data=a noobs;
  by x;
run;
ods tagsets.print_example close;


ods tagsets.tabulate_example2 file="tabulate2.xml";
ods tagsets.tabulate_example file="tabulate.xml";
proc tabulate data=a;
     class x y z;
     table x*y*z, n;
run;
ods tagsets.tabulate_example close;
ods tagsets.tabulate_example2 close;
    
    
