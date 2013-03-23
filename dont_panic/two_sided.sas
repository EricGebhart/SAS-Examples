
/*---------------------------------------------------------------eric-*/
/*-- This tagset repeats the first column of any table as the last  --*/
/*-- column.  It assumes 1 column is to be repeated, but could      --*/
/*-- be easily adapted to repeat any number of columns.             --*/
/*------------------------------------------------------------22Oct03-*/
proc template;
    
    define tagset tagsets.two_sided;
    parent=tagsets.html4;

        mvar column_count;
        mvar header_interval;

        /*---------------------------------------------------------------eric-*/
        /*-- Set the column count from the column_count macro variable.     --*/
        /*-- If not present set it to one.                                  --*/
        /*------------------------------------------------------------22Oct03-*/
        define event initialize;
            trigger set_just_lookup;
            do /if column_count;
                eval $column_count inputn(column_count, "3.");
            else;
                eval $column_count 1;
            done;

            trigger set_interval;

            putlog "This tagset is only capable of saving 6 columns" /if $column_count > 6;
        end;
  
        define event set_interval;
    
            do /if header_interval;
                eval $header_interval inputn(header_interval, "3.");
            else;
                eval $header_interval 0;
            done;

        end;
        


        define event row;
            start:
                /*---------------------------------------------------------------eric-*/
                /*-- print the first row, if we are starting the second row.        --*/
                /*------------------------------------------------------------22Oct03-*/
                do /if $$header_row;
                    put "<head>" nl /if $first_row;
                    put $$header_row;
                    open header_rows;
                    put $$header_row;
                    close;
                    unset $$header_row;
                    unset $first_row;
                done;

                
                do /if cmp(section, "body");
                    eval $data_row_count $data_row_count + 1;
                done;
                
                    
                do /if cmp(section, "head");
                    open header_row /if cmp(section, "head");
                    put "<tr>" CR;
                done;
                

            finish:

                /*---------------------------------------------------------------eric-*/
                /*-- print the columns in reverse order at the end of the row.        --*/
                /*------------------------------------------------------------22Oct03-*/
                trigger reverse_header_streams;
        
                put "</tr>" CR;
                unset $row_started;

                /*-----------------------------------------------eric-*/
                /*-- close the first_row stream, and set second_row --*/
                /*-- so we know to print the first row before the   --*/
                /*-- next row starts.  That comes next, but right   --*/
                /*-- after the internal memory stream wreaks havoc. --*/
                /*--------------------------------------------22Oct03-*/
                
                do /if cmp(section, "head");
                    close; 
                done;
                
        end;

        /*---------------------------------------------------------------eric-*/
        /*-- Print out the columns in reverse order and delete them.        --*/
        /*------------------------------------------------------------22Oct03-*/
        define event reverse_header_streams;


            flush;
        
            /*---------------------------------------------------------------eric-*/
            /*-- For the case where are row has fewer cells than what we want   --*/
            /*-- to repeat.                                                     --*/
            /*------------------------------------------------------------22Oct03-*/
            trigger put_header_streams;

            put $$column_6;
            put $$column_5;
            put $$column_4;
            put $$column_3;
            put $$column_2;
            put $$column_1;
            
            unset $$column_6;
            unset $$column_5;
            unset $$column_4;
            unset $$column_3;
            unset $$column_2;
            unset $$column_1;
        end;

        define event header_streams;
            eval $column inputn(colstart, "3.");
            do /if $column <= $column_count;
                unset $row_headers_printed ;

                do /if $column = 1;
                    open column_1;
                else /if $column = 2;
                    open column_2;
                else /if $column = 3;
                    open column_3;
                else /if $column = 4;
                    open column_4;
                else /if $column = 5;
                    open column_5;
                else /if $column = 6;
                    open column_6;
                done;

            else /if $column = $column_count + 1;


                trigger put_header_streams;

            done;

        end;
        
        define event put_header_streams;
        
                flush;

                break /if $row_headers_printed;

                /* just in case */
                close;

                /*---------------------------------------------------------------eric-*/
                /*-- go back to the header row stream if need be.                    --*/
                /*------------------------------------------------------------22Oct03-*/
                open header_row /if cmp(section, "head");

                /* the rowheaders for this row have been printed */
                set $row_headers_printed "True";

                /*---------------------------------------------------------------eric-*/
                /*-- This chunk prints out the headers at the beginning of the row. --*/
                /*------------------------------------------------------------22Oct03-*/
                put $$column_1;
                put $$column_2;
                put $$column_3;
                put $$column_4;
                put $$column_5;
                put $$column_6;
                flush;
                    
        end;

    /*-----------------------------------------------------------eric-*/
    /*-- Craziness.  I have to save the entire first row of the     --*/
    /*-- table in a stream so I can print it out later.  Otherwise  --*/
    /*-- the internal memory stream manipulations get in the way    --*/
    /*-- and everything comes out in the wrong order.               --*/
    /*--                                                            --*/
    /*-- When proc report and tabulate start giving colspecs then   --*/
    /*-- the internal memory stream stuff can go away. and so       --*/
    /*-- can this mess.                                             --*/
    /*--                                                            --*/
    /*-- Just so this might make a little sense,  When I don't      --*/
    /*-- get colspecs from the proc I send the first row of         --*/
    /*-- the table into a memory stream, when I get to the          --*/
    /*-- end of the row, I print out the colspecs and then          --*/
    /*-- send the memory stream to the output.                      --*/
    /*--                                                            --*/
    /*-- This interferes with tagset streams, which end up          --*/
    /*-- getting printed before the colspecs.  While everything     --*/
    /*-- else goes to the right place.  Saving the entire row       --*/
    /*-- in a tagset stream, and suppressing colspecs is the        --*/
    /*-- work around.                                               --*/
    /*--------------------------------------------------------22Oct03-*/
    
        define event colgroup;
        end;
        define event colspec_entry;
        end;
    
        define event table_head;
          
        /*---------------------------------------------------------------eric-*/
        /*-- set the header interval for this table, in case it             --*/
        /*-- changed in between.                                            --*/
        /*------------------------------------------------------------22Oct03-*/
        trigger set_interval;

            unset $$header_rows;

            open header_row;
            set $first_row "true";

        finish:
            /* just in case there was only one row */
            do /if $$header_row;
        
                put $$header_row;

                open header_rows;
                put $$header_row;
                close;

                unset $$header_row;
            done;
                
            unset $first_row;
            unset $second_row;
            put "</thead>" CR;

            eval $data_row_count 0 ;

 
            /*---------------------------------------------------------------eric-*/
            /*-- disable the repeating headers if the interval is 0.            --*/
            /*------------------------------------------------------------22Oct03-*/
            unset $$header_rows /if !$header_interval;
            
        end;


        define event header;
            start:
              
                do /if cmp(section, "body");
                    do /if !$row_started;
                
                        do /if $data_row_count > $header_interval;
                            do /if cmp(colstart, '1');
                                put $$header_rows;
                                eval $data_row_count 1;
                            done;    
                        done;
                            
                        put "<tr>" CR;
                        set $row_started "True";
                    done;
                        
                done;
                    
                /*---------------------------------------------------------------eric-*/
                /*-- open up a column stream if needed.                             --*/
                /*------------------------------------------------------------22Oct03-*/
                trigger header_streams;
                    
            
                put "<th";
                putq " title=" flyover;
                trigger classalign;
                trigger style_inline;
                trigger rowcol;
                put ">";
                trigger cell_value;
            finish:
                trigger cell_value;
                put "</th>" CR;
       end;

      /* Web Accessibility Feature 1194.22 (G&H) */
      /*-----------------------------------------*/
       define event data;
           start:
               /* this would work but sometimes htmlclass is empty... */
               trigger header /breakif cmp(htmlclass, "RowHeader");
               trigger header /breakif cmp(htmlclass, "Header");
  
               /*---------------------------------------------------------------eric-*/
               /*-- open up a column stream if needed.                             --*/
               /*------------------------------------------------------------22Oct03-*/
               trigger header_streams;
                    
               put "<td";
               putq " title=" flyover;
               do /if !cmp(htmlclass,'batch');
                   trigger classalign;
                   trigger style_inline;
               done;
               trigger rowcol;
               put " nowrap" /if no_wrap;
               put ">";
               trigger cell_value;
          finish:
               trigger header /breakif cmp(htmlclass, "RowHeader");
               trigger header /breakif cmp(htmlclass, "Header");
  
               trigger cell_value;
               put "</td>" CR;
        end;
    
    end;

run;

%let column_count=2;
%let header_interval=5;

options obs=10;

ods tagsets.two_sided file="twosided3.html";

proc print data=sashelp.class;run;

%let header_interval=10;

proc tabulate missing data=sashelp.revhub2;
   class type;
   class hub source;
   var revenue;
   table hub*source, type*(revenue="Average Revenue"*(mean*f=10.0))
      / rts=40;
   keylabel mean=' ';
run;     

ods tagsets.two_sided close;      


/*
ods html file="test2.html";

proc tabulate missing data=sashelp.revhub2;
   class type;
   class hub source;
   var revenue;
   table hub*source, type*(revenue="Average Revenue"*(mean*f=10.0))
      / rts=40;
   keylabel mean=' ';
run;

ods html close;
*/

