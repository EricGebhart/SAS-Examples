*options debug="tagset_where";

/*----------------------------------------------------------------*/
/*-- Reading a file in using datastep functions.  This example  --*/
/*-- comes straight out of the online documentation             --*/
/*-- for fread().                                               --*/
/*----------------------------------------------------------------*/
proc template;
    define tagset tagsets.website;
        parent=tagsets.html4;
        embedded_stylesheet=no;

        mvar infiles;


        define event set_default_files;
           set $infiles 'default_head.html default_foot.html';
        end;

        /*-------------------------------------------------------------eric-*/
        /*-- The files should be given as a list with spaces between them.--*/
        /*----------------------------------------------------------8Nov 03-*/
        define event initialize;
            trigger set_just_lookup;
        
           do /if cmp(tagset_alias, 'default');
                trigger set_default_files;
            else;
                set $infiles tagset_alias;
                set $infiles infiles /if !$infiles;
            done;
            putlog "Infiles are" " :" $infiles;

            set $filename scan($infiles, 1, ' ');

            /*---------------------------------------------------------eric-*/
            /*-- Set a flag so the ending document tags can be suppressed.--*/
            /*------------------------------------------------------8Nov 03-*/
            do /if $infiles);
                set $read_files 'true';
                set $filrf "headfile";
                set $read_head "true";
            done;
        end;

        define event proc;
            start:
                do /if no_top;
                    do /if $read_head;
                        trigger readfile;
                        unset $read_head;
                    done;
                done;
        end;


        define event head_search;
            trigger integrated_link /if contains($file_record, '</head>');
        end;

        define event integrated_link;
            put '<style type="text/css">' CR '<!--' CR;
            trigger alignstyle;
            put '-->' CR '</style>' CR ;
        
            set $urlList stylesheet_url;
            set $urlList stylesheet_name /if !$urlList;
            trigger urlLoop ;
            unset $urlList;
        end;

        define event readfile;
            
            /*--------------------------------------------------------*/
            /*-- Set up the file and open it.                       --*/
            /*--------------------------------------------------------*/
            putlog "Reading in file: " $filename;

            eval $fid 0;
            
            eval $rc filename($filrf, $filename);
            
            eval $fid fopen($filrf);
            do /if missing($fid);
                putlog "Error: Could not open file, " $filename;
                break;
            done;
            

            /*--------------------------------------------------------*/
            /*-- datastep functions  will bind directly to the      --*/
            /*-- variable space as it exists.                       --*/
            /*--                                                    --*/
            /*-- Tagset variables are not like datastep             --*/
            /*-- variables but we can create a big one full         --*/
            /*-- of spaces and let the functions write to it.       --*/
            /*--                                                    --*/
            /*-- This creates a variable that is 200 spaces so      --*/
            /*-- that the function can write directly to the        --*/
            /*-- memory location held by the variable.              --*/
            /*-- in VI, 200i<space>                                 --*/
            /*--------------------------------------------------------*/
            set $file_record  "                                                                                                                                                                                                        ";

            /*--------------------------------------------------------*/
            /*-- Loop over the records in the file                  --*/
            /*--------------------------------------------------------*/
            do /if $fid > 0 ;

                do /while fread($fid) = 0;

                    set $rc fget($fid,$file_record ,200);

                    trigger head_search;
                    
                    /* trimn to get rid of the spaces at the end. */
                    put trimn($file_record ) nl;

                done;
            done;

           /*----------------------------------------------------------*/
           /*-- close up the file.  set works fine for this.         --*/
           /*----------------------------------------------------------*/

            set $rc close($fid);
            set $rc filename($filrf);

        end;

        define event doc;
            start:
                set $doctype '<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">';
                set $framedoctype '<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN">';
                put $doctype CR;
                put "<html>" CR;

            finish:
                do /if $read_files;
                    set $filename scan($infiles, 2, ' ');
                    set $filrf "footfile";
                    trigger readfile;
                    break;
                done;

                put "</html>" CR;
        end;

        define event doc_body;
            put '<body onload="startup()"';
            put ' onunload="shutdown()"';
            put  ' bgproperties="fixed"' / WATERMARK;
            putq " background=" BACKGROUNDIMAGE;
               trigger style_inline;
            put ">" CR;
            trigger pre_post;
            put          CR;
            trigger ie_check;

          finish:
            trigger pre_post;

            break /if $read_files;
            put "</body>" CR;
        end;

end;

run;


ods tagsets.short_map stylesheet="stylesheet.map" 
                          file="website.map"(notop) 
                         alias='default';
ods tagsets.website stylesheet="website.css" 
                          file="website.html"(notop) 
                         alias='default';

proc print data=sashelp.class; run;
    
ods tagsets.website close;
ods _all_ close;
