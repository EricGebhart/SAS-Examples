
proc template;

    /*******************************************************************/
    /*******************************************************************/
    /*******************************************************************/
    /* SASReport.  Shows all events relevant to SAS Report XML         */
    /* Support:    Eric Gebhart (saseag)                               */
    /*******************************************************************/
    /*******************************************************************/
    /*******************************************************************/
     %macro tagsets_sasreport;

      %if  %substr(&sysver,1,1) = 8 %then %do;
         /* not in version 8 */
         %end;

      %else %do;

    define tagset tagsets.SASReport;
        parent = tagsets.graph;
        notes "This is the SAS Report XML event map definition";
        /*log_note = 'This tagset is used for data interchange';*/

        map = '<>&';
        mapsub = '/&lt;/&gt;/&amp;/';
        nobreakspace = ' ';
        split = '<Br/>';

    /*---------------------------------------------------------sasdck-*/
    /*-- Indent must be zero.  Otherwise preformatted text messes up.--*/
    /*--------------------------------------------------------28Apr03-*/

        indent=0;
        stacked_columns = yes;
        hierarchical_data = yes;
        output_type = 'xml';
        copyright='&copy;';
        trademark='&trade;';
        registered_tm='&reg;';
        image_formats = 'gif,jpeg,png';
        no_byte_order_mark = yes;

        /*default_event="basic";*/

        /*-------------------------------------------------------eric-*/
        /*-- Handy function for debugging.                          --*/
        /*----------------------------------------------------29Jan03-*/
        define event putvars;
            put "event vars" nl;
            putvars event "name: " _name_ " = " _value_ nl;
            put "memory vars" nl;
            putvars mem "name: " _name_ " = " _value_ nl;
            put "style vars" nl;
            putvars style "name: " _name_ " = " _value_ nl;
        end;

        define event basic;
          start:
             put "EVENT: " event_name nl;
          finish:
             put "EVENT/: " event_name nl;
        end;


        /* get rid of event defined by graph */
        define event javascript;
        end;

        define event breakline;
            open view;
            put "<Br/>";
            close;
        end;

        /* Same as put_value for now. Ignore url variable. */
        define event hyperlink;
            trigger put_value;
        end;

        /* Put value in Data */
        define event put_value;
            put value;
        end;

        /* Put value in Data */
        define event put_value_cr;
            put value nl;
        end;

        /* Put value in View */
        define event put_label;
            open view;
            put value;
            close;
        end;

        define event inline_style;
           trigger stylename;
           trigger page_break_before;
           trigger text_align;
           trigger style_inline;
        end;

        /* I'm betting this comes back to life at somepoint. */
        define event stylename;
          putq ' style:style=' htmlclass ;
        end;

        define event page_break_before;
           unset $breakpage;
        end;

        define event text_align;
            put  ' style:textAlign=';
            put  '"center"' / if cmp(just, 'c');
            put  '"left"' / if cmp(just, 'l');
            put  '"right"' / if cmp(just, 'r');
            put  '"right"' / if cmp(just, 'd');
        end;

        /*-------------------------------------------------------eric-*/
        /*-- Loop through the style variables creating attributes   --*/
        /*-- that look like this.                                   --*/
        /*--                                                        --*/
        /*-- style:attribute="value"                                --*/
        /*----------------------------------------------------30Apr03-*/
        define event style_inline;
            putq " style:fontFamily=" font_face;
            putq " style:fontSize=" font_size;
            putq " style:fontWeight=" font_weight;
            putq " style:fontStyle=" font_style;

            putq " style:color=" foreground;
            putq " style:backgroundColor=" background;
            putq " style:backgroundImage=" backgroundimage;

            putq " style:marginLeft=" leftmargin;
            putq " style:marginRight=" rightmargin;
            putq " style:marginTop=" topmargin;
            putq " style:marginBottom=" bottommargin;

            putq " style:listStyleType=" bullet;

            putq " style:height=" outputheight;
            putq " style:width=" outputwidth;

            putq " style:textIndent=" indent;
            putq " style:textDecoration=" text_decoration;

            putq " style:borderWidth=" borderwidth;
            putq " style:borderTopWidth=" bordertopwidth;
            putq " style:borderBottomWidth=" borderbottomwidth;
            putq " style:borderRightWidth=" borderrightwidth;
            putq " style:borderLeftWidth=" borderleftwidth;

            putq " style:borderColor=" bordercolor;
            putq " style:borderTopColor=" bordertopcolor;
            putq " style:borderBottomColor=" borderbottomcolor;
            putq " style:borderRightColor=" borderrightcolor;
            putq " style:borderLeftColor=" borderleftcolor;

            putq " style:borderStyle=" borderstyle;
            putq " style:borderTopStyle=" bordertopstyle;
            putq " style:borderBottomStyle=" borderbottomstyle;
            putq " style:borderRightStyle=" borderrightstyle;
            putq " style:borderLeftStyle=" borderleftstyle;
        end;

        /* Eliminate the Graph definitions that collide */
        /* with the SASReport events to prevent duplication (cdh). */
        define event GraphSASReport;
        end;
        define event GraphData;
        end;
        define event GraphSection;
        end;
        define event GraphBody;
        end;

        /* For now, we have to duplicate the <Graph> event to get the */
        /* scheme name assigned correctly.  When tables start using */
        /* styles, this event should be removed and the scheme name */
        /* hard-coded on the <View> element (cdh).                  */
        define event graph;
          start:
            ndent;
            put "<Graph";
            putq " name=" @graphid;
            putq " style:height=" @Height / if !cmp(@Height,"0px");
            trigger graph_styleheight / if cmp(@Height,"0px");
            putq " style:width=" @Width / if !cmp(@Width,"0px");
            trigger graph_stylewidth / if cmp(@Width,"0px");
            put ' style:scheme="GraphStyleScheme"';
            put ' style:style="GraphScheme';
            put anchor '" ';
            putq " showChartTips=" @ChartTips;
            putq " view2D=" @View2D;
            putq " g3dTilt=" @G3DTilt;
            putq " g3dRotate=" @G3DRotate;
            putq " chartBorder=" @ChartBorder;
            putq " drillDownEnabled=" @DrillDownEnabled;
            putq " drillDownMode=" @DrillDownMode;
            putq " rotationX=" @RotateX;
            putq " rotationY=" @RotateY;
            putq " rotationZ=" @RotateZ;
            put ">" CR;
          finish:
            put "</Graph>" CR;
            xdent;
        end;

        define event GraphView;
          start:
             open view;
          finish:
             close;
        end;

        define event StyleScheme;
          start:
            open scheme;
            break / if exists($GraphScheme);
            ndent;
            set $GraphScheme "TRUE";
            put '<style:Scheme name="GraphStyleScheme">' CR;
          finish:
            close;
        end;

        define event fmt;
          start:
            open format;
            break / if exists($GraphFormats);
            set $GraphFormats "TRUE";
            put "<Formats>" CR;
          finish:
            close;
        end;

        define event SchemeOut;
           open scheme;
           put "</style:Scheme>" CR;
           xdent;
           flush;
           close;
           put $$scheme;
           unset $$scheme;
           unset $GraphScheme;
        end;

        define event FormatOut;
           open format;
           put "</Formats>" CR;
           flush;
           close;
           put $$format;
           unset $$format;
           unset $GraphFormats;
        end;

      define event doc;
         start:
            put '<?xml version="1.0"';
            putq " encoding=" encoding;
            put "?>" CR CR;
            put '<SASReport version="1.0" applicationName="ODS" applicationVersion="9.1"' nl;
            put ' xmlns:style="http://www.sas.com/sasreportmodel/styles"' nl;
            put ' xmlns:ods="http://www.sas.com/sasreportmodel/ods"' nl;
            putq ' dateCreated="'; /* 2003-05-05T15:48:09-4:00" */
            put javadate 'T' javatime '"';
            putq ' dateModified="';
            put javadate 'T' javatime '"';
            put ">" nl;
            ndent;
         finish:
            xdent;
            put $$view;
            unset $$view;
            put '<Formats>' nl;
            put $$mappings;
            unset $$mappings;
            put '</Formats>' nl;
            put '</SASReport>' nl;
     end;

     define event stylesheet_link;
         put "<style:CSSScheme";
         putq " name=" style;
         putq " file=" url;
         put "/>" nl;
     end;

     define event break_margin;
         unset $margin_unit;
         eval $match prxmatch($margin_re, $margin);
         set $margin_size prxposn($margin_re, 1, $margin) ;
         /* regex gives back strings... We don't want 0 margins              */
         /* might as well break too, (bif) since we don't want anything else */
         unset $margin_size /breakif inputn($margin_size, "2.3") = 0;
         set $margin_unit prxposn($margin_re, 2, $margin) ;
         set $margin_unit lowcase($margin_unit) /if $margin_unit;
         set $margin_unit "in" /if !$margin_unit;
     end;

     define event Margins;
         eval $margin_re prxparse('(([0-9]*[\.]?[0-9]*)(IN|CM)?)') ;

         set $margin getoption('leftmargin');
         trigger break_margin;
         put ' marginLeft="' $margin_size $margin_unit '"' /if $margin_size;

         set $margin getoption('rightmargin');
         trigger break_margin;
         put ' marginRight="' $margin_size $margin_unit '"' /if $margin_size;

         set $margin getoption('topmargin');
         trigger break_margin;
         put ' marginTop="' $margin_size $margin_unit '"' /if $margin_size;

         set $margin getoption('bottommargin');
         trigger break_margin;
         put ' marginBottom="' $margin_size $margin_unit '"' /if $margin_size;
         unset $margin;
         unset $margin_size;
         unset $margin_unit;
     end;

     define event paperHeightWidth;

         /* tranwrd just makes the regex easier. Get rid of optional quotes */
         set $papersize tranwrd($papersize, '"', " ");
         set $papersize tranwrd($papersize, "'", " ");

         /* could be centimeters, could be quoted, or not...
            default is supposedly inches but could be installation
            dependent.
            (8in 11in);
            ('8in', '11in');
            ("8in", "11in");
            ("8", "11");
         */
         eval $re prxparse('( *([0-9]+) *(IN|CM)* *[,]+ *([0-9]+) *(IN|CM)*.*)') ;
         eval $match prxmatch($re, $papersize);

         set $pwidth prxposn($re, 1, $papersize) ;
         set $pwidth_unit prxposn($re, 2, $papersize) ;
         set $pwidth_unit lowcase($pwidth_unit) /if $pwidth_unit;
         set $pwidth_unit "in" /if !$pwidth_unit;

         set $pheight prxposn($re, 3, $papersize) ;
         set $pheight_unit prxposn($re, 4, $papersize) ;
         set $pheight_unit lowcase($pheight_unit) /if $pheight_unit;
         set $pheight_unit "in" /if !$pheight_unit;

         /* Only if they are non-zero */
         put ' height="' $pheight $pheight_unit '"' /if $pheight;
         put ' width="' $pwidth $pwidth_unit '"' /if $pwidth;

         unset $papersize;
         unset $re;
         unset $pwidth;
         unset $pwidth_unit;
         unset $pheight;
         unset $pheight_unit;

     end;

      define event doc_body;
          start:
              put '<Data refreshPolicy="embedded">' nl;
              open view;
              put '<View' ;
              putq ' style:scheme=' style;
              putq ' style:style=' htmlclass;
              put '>' nl;

              put "<PageSetup";
              set $pageno getoption('PAGENO');
              put ' startingNumber="' $pageno '"' / if cmp(getoption('NUMBER'),'NUMBER');
              set $orientation getoption('ORIENTATION');
              put ' orientation="' $orientation '"';

              /*-- handle (width height) --*/

              set $papersize getoption('PAPERSIZE');

              do /if contains($papersize, "(" );
                  trigger paperHeightWidth;
              else;
                  put ' size="' $papersize '"';
              done;


              /*-- handle margins --*/

              trigger Margins;

              put ">" nl;
              put "<PageHeader>" nl;
              put "<Text>" nl;
              put '<GriddedConstraint halign="center" fill="horizontal" />' nl;
              put '<Date style:textAlign="right"';
              put ' showDate="false" showTime="false"' / if cmp(getoption('DATE'),'NODATE');
              put '>';
              put javadate 'T' javatime;
              put '</Date>' nl;
              put "</Text>" nl;
              put '<Text><PageNumber style:textAlign="right" /></Text>' nl;
              put "</PageHeader>" nl;

              put "</PageSetup>" nl;


              /* put in an outermost section for Nikolaj */
              trigger section;

              unset $pageno;
              unset $orientation;
              unset $papersize;

              close;
          finish:
              put '</Data>' nl;
              open view;
              trigger section;
              put "</View>" nl;
              flush;
              close;
              trigger FormatOut / if exists($GraphFormats);
              trigger SchemeOut / if exists($GraphScheme);
     end;

      define event cube_label;
         open view;
         put "<Label";
         putq " position=" position;
         put ">";
         put "<Span";
         trigger inline_style;
         put ">";
         put value;
         put "</Span>";
         put "</Label>" nl;
         close;
     end;

        define event splitline;
            put "<Br/>";
        end;

        define event breakline;
            put "<Br/>";
        end;

      define event view_cube;
         start:
            open view;
            put "<Table";
            putq " style:style=" htmlclass;
            putq " data=" name;
            put  ' cellSpacing="' CELLSPACING "px" '"' /if cellspacing ;
            put ">" nl;
            trigger griddedconstraint;
            close;
         finish:
            open view;
            put "</Table>" nl;
            close;
      end;

      define event cube;
         start:
            trigger view_cube;
            put '<IQData type="MDEmbedded"';
            putq ' name=' name;
            put '>' nl;
            ndent;
            put '<EmbeddedData>' nl;
         finish:
            put '</EmbeddedData>' nl;
            xdent;
            put '</IQData>' nl;
            trigger view_cube;
      end;

      define event dimensions;
         start:
            ndent;
            put '<Dimensions>' nl;
         finish:
            xdent;
            put '</Dimensions>' nl;
         end;

      define event dimension;
         start:
            ndent;
            put '<Dimension';
            putq " name=" name;
            putq " label=" label;
            put '>' nl;
         finish:
            xdent;
            put '</Dimension>' nl;
         end;

      define event hierarchy;
         start:
            ndent;
            put '<Hierarchy';
            putq " name=" name;
            putq " label=" label;
            put '>' nl;
         finish:
            xdent;
            put '</Hierarchy>' nl;
         end;

      define event axes;
        start:
          ndent;
          put "<Axes>" CR;
        finish:
          put "</Axes>" CR;
          xdent;
      end;

      define event axis;
         start:
            ndent;
            put '<Axis';
            putq " name=" name;
            putq " type=" type;
            put '>' nl;
         finish:
            xdent;
            put '</Axis>' nl;
         end;

      define event members;
         start:
            ndent;
            put '<Members>' nl;
         finish:
            xdent;
            put '</Members>' nl;
         end;

      define event member;
         ndent;
         put '<Member';
         putq " name=" name;
         putq " dimension=" dimension;
         putq " parentMember=" parentmember;
         putq " label=" label;
         putq " level=" level;
         trigger style_inline;
      /* Disable until consumers ready for raw values + formats      */
      /* putq " encoding=" dataencoding;                             */
      /* putq " SASFormat=" sasformat;                               */
         put '/>' nl;
         xdent;
      end;

      define event tuples;
         start:
            ndent;
            put '<Tuples>' nl;
         finish:
            xdent;
            put '</Tuples>' nl;
         end;


      define event tuple;
         start:
            ndent;
            put '<Tuple>' nl;
         finish:
            xdent;
            put '</Tuple>' nl;
         end;

      define event level;
         ndent;
         put '<Level';
         putq " depth=" depth;
         putq " label=" label;
         putq " name=" name;
      /* putq " SASFormat=" sasformat;                               */
      /* putq " encoding=" dataencoding;                             */
         put '/>' nl;
         xdent;
         end;

      define event cube_values;
         start:
            put '<ValuesList';
            putq ' valuesCount=' valuescount;
            putq ' columnAxis=' columnaxis;
            putq ' rowAxis=' rowaxis;
            put '>' nl;
            ndent;
         finish:
            xdent;
            put '</ValuesList>' nl;
      end;

      define event row;
         start:
            /*-------------------------------------------------------eric-*/
            /*-- Remove this if we want to start outputing table footers.--*/
            /*----------------------------------------------------28Jan03-*/
            break / if cmp(section,"foot");
            trigger table_body / if cmp(htmlclass,"batch");
            put '<Values>' nl;
            set $RowData "1" / if cmp(htmlclass,"Body");
            ndent;
         finish:
            /*-------------------------------------------------------eric-*/
            /*-- Remove this if we want to start outputing table footers.--*/
            /*----------------------------------------------------28Jan03-*/
            break / if cmp(section,"foot");
            xdent;
            put '</Values>' nl;
            unset $RowData;
            trigger table_body / if cmp(htmlclass,"batch");
      end;

      define event header;
         start:
            trigger data;
         finish:
            trigger data;
      end;

      /* PROC PRINT: use blank as missing value in Header-class values */
      define event missing_data;
         putq ' missing=' missing / if !cmp(htmlclass,"Header");
         put  ' missing=" "'      / if  cmp(htmlclass,"Header");
      end;

      define event cell_is_empty;
         put ' ';
      end;

      /*---------------------------------------------------------eric-*/
      /*-- Put a blank line after output objects.                   --*/
      /*------------------------------------------------------17Mar04-*/
      define event output;
         finish:
             open view;
             put '<Text>' nl;
             put '<GriddedConstraint fill="horizontal"/>' nl;
             put '<Br/>' nl;
             put '</Text>' nl;
             close;
      end;

      define event table_label;
         start:
            open view;
            put '<Label';
            put  ' isVisible="false"' / if !exists(value);
            put  ' isStacked="true"'  / if is_stacked;
            put  ' isStacked="false"' / if !is_stacked;
            putq ' position="bottom"';
            trigger stylename;
            trigger text_align;
            put  '>';
            put value;
            close;
         finish:
            open view;
            put "</Label>" nl;
            close;
      end;

      define event data;
         start:
            /*-------------------------------------------------------eric-*/
            /*-- Remove this if we want to start outputing table footers.--*/
            /*----------------------------------------------------28Jan03-*/
            trigger table_label / if cmp(section,"foot");
            break / if cmp(section,"foot");
            put '<Value';
         /* putq " SASFormat=" sasformat;                            */
         /* putq " encoding=" dataencoding;                          */
            trigger missing_data / if exists(missing);
            trigger text_align / if cmp($RowData,"1");
            trigger style_inline ;
            put ' /' / if exists(empty);
            put '>';
            put nl / if exists(empty);
            break / if exists(empty);
         /* Disable until BI consumers ready    */
         /* put rawvalue / if exists(rawvalue); */
         /* put value / if !exists(rawvalue);   */
            put value;
         finish:
            /*-------------------------------------------------------eric-*/
            /*-- Remove this if we want to start outputing table footers.--*/
            /*----------------------------------------------------28Jan03-*/
            trigger table_label / if cmp(section,"foot");
            break / if cmp(section,"foot");
            break / if exists(empty);
            put '</Value>' nl;
      end;

      define event table_body;
         start:
            put '<ValuesList>' nl;
         finish:
            put '</ValuesList>' nl;
      end;

      /*---------------------------------------------------------eric-*/
      /*-- For tables and images.                                   --*/
      /*------------------------------------------------------26Aug03-*/
      define event griddedconstraint;
         put '<GriddedConstraint';
         put ' halign=';
         put '"center"' / if cmp(just, 'c');
         put '"left"' / if cmp(just, 'l');
         put '"right"' / if cmp(just, 'r');
         put ' fill="horizontal"';   /* added per dabail 3/10/04 - eric */
         put ' />' nl;
      end;

      /*---------------------------------------------------------eric-*/
      /*-- Same thing, but with fill horizontal for text.           --*/
      /*------------------------------------------------------26Aug03-*/
      define event fit_to_container;
         put '<GriddedConstraint';
         put ' halign=';
         put '"center"' / if cmp(just, 'c');
         put '"left"' / if cmp(just, 'l');
         put '"right"' / if cmp(just, 'r');
         put ' fill="horizontal"';
         put ' />' nl;
      end;

      define event view_table;
         start:
           open view;
           put "<Table";
           putq ' data=' anchor;
           trigger stylename;
           trigger page_break_before;
           trigger style_inline;
           put  ' cellSpacing="' CELLSPACING "px" '"' /if cellspacing ;
           put '>' nl;
           trigger griddedconstraint;
           ndent;
           close;
         finish:
           open view;
           xdent;
           put "</Table>" nl;
           close;
      end;

      define event table;
         start:
           put '<IQData type="2DEmbedded"' ;
           putq ' name=' anchor '>' nl;
           ndent;
           put "<EmbeddedData>" nl;
           ndent;
           trigger view_table;
         finish:
           trigger view_table;
           xdent;
           put "</EmbeddedData>" nl;
           xdent;
           put "</IQData>" nl;
      end;

      define event table_headers;
         start:
            put '<Variables>' nl;
            trigger view_columns;
         finish:
            trigger view_columns;
            put '</Variables>' nl;
      end;

      define event header_spec;
         start:
           open view;
           put '<Columns order="specified">' nl;
           ndent;
           trigger label;
           close;
         finish:
           open view;
           xdent;
           put '</Columns>' nl;
           close;
      end;

      /* Non-spanning column label. Report generates empty Labels to  */
      /* suppress the default use of the column name as a label.      */
      define event col_header_label;
         start:
            open view;
             put '<Label';
            trigger event_attr;
            trigger inline_style;
            put ' isVisible="false"' / if exists(empty);
            put ' isStacked="true"'  / if is_stacked;
            put ' isStacked="false"' / if !is_stacked;
            put ' position="top"';
            put '/>' nl              / if exists(empty);
            close                    / if exists(empty);
            break                    / if exists(empty);
            put '>';
            put value;
            close;
         finish:
            open view;
            break / if exists(empty);
            put '</Label>' nl;
            close;
     end;

     define event event_attr;
         /*putq " eventName=" event_name;*/
     end;

      define event label;
        /* It is critically important that the <Label>text</Label> */
        /* sequence not have any extra white space between the     */
        /* tags and the text!                                      */
        put  '<Label';
        trigger event_attr;
        put  ' isVisible="false"' / if !exists(value);
        put  ' isStacked="true"'  / if is_stacked;
        put  ' isStacked="false"' / if !is_stacked;
        putq ' position=' position;
        trigger stylename;
        trigger text_align;
        put '>';
        put value;
        put '</Label>' nl;
      end;

      define event col_header_spec;
         start:
            trigger header_spec;
         finish:
            trigger header_spec;
      end;

      define event sub_header_colspec;
        start:
          trigger view_column;
          put  '<Variable';
          put  ' encoding="Text"';
      /*  Wait until rawvalue+format support enabled */
      /*  putq ' SASFormat=' sasformat;   */
      /*  putq ' encoding=' dataencoding; */
          put  ' type=';
        /*-------------------------------------------------------eric-*/
        /*-- change these 1st three back to numeric when BIP is     --*/
        /*-- ready to use them as numerics...                       --*/
        /*----------------------------------------------------5Feb 03-*/
          put  '"String"' / if cmp(type, "double");
          put  '"String"' / if cmp(type, "int");
          put  '"String"' / if cmp(type, "bool");
          put  '"String"'  / if cmp(type, "char");
          put  '"String"'  / if cmp(type, "string");
          put  '"String"'  / if cmp(type, "unknown");
          putq ' name=' name / if cmp(proc_name,"Print");
          trigger alt_colid  / if !cmp(proc_name, "Print");
          put  ' />' nl;
        finish:
          trigger view_column;
      end;

      define event alt_colid;
          put  ' name="var'  ;
          put  col_id        ;
          put  '"'           ;
      end;

      define event span_group;
      end;
      define event span_header_colspec;
      end;

      define event colspecs;
        start:
          break /if  !cmp(data_viewer, 'Batch');
          put '<Variables>' nl;
          trigger header_spec;
        finish:
          break /if  !cmp(data_viewer, 'Batch');
          put '</Variables>' nl;
          trigger header_spec;
      end;

      define event colgroup;
      end;

      define event colspec_entry;
        start:
          break /if  !cmp(data_viewer, 'Batch');
          trigger sub_header_colspec;
        finish:
          break /if  !cmp(data_viewer, 'Batch');
          trigger sub_header_colspec;
      end;
      define event sub_colspec_header;
      end;

      define event view_columns;
         start:
           open view;
           put '<Columns order="specified"> ' nl;
           ndent;
           close;
         finish:
           open view;
           xdent;
           put '</Columns> ' nl;
           close;
      end;

      define event view_column;
        start:
          open view;
          put '<Column';
          trigger stylename;
      /*  Disable until consumers ready for raw data + formats  */
      /*  putq ' SASFormat=' sasformat / if cmp(genformat,"1"); */
      /*  putq ' SASFormat=' sasformat;                         */
            /*  putq " encoding=" dataencoding;                       */
          do /if  cmp(proc_name,"Print");
            putq ' variable=' name;
          else;
            trigger altvarid;
          done;
          put '>' nl ;
          ndent ;
          put '<Cell ' ;
          trigger text_align;
          putq " style:style=" htmlclass;
          put '/>' nl;
          close;
        finish:
          open view;
          xdent;
          put '</Column>' nl;
          close;
      end;


      define event altvarid;
          put ' variable="var' ;
          put col_id             / if !cmp(proc_name,"Print");
          put '"'    ;
      end;

      define event table_head;
         start:
            block data;
            block row;
            block header;
         finish:
            unblock data;
            unblock row;
            unblock header;
      end;

      define event datetime;
         break;  /* no dates.  It's in the header now */
         put '<!-- no content -->' nl / if !exists($do_date);
         break /if !exists($do_date);
         unset $do_date;
         put '<Date style:textAlign="right"';
         put ' showDate="false" showTime="false"' / if cmp(getoption('DATE'),'NODATE');
         put '>';
         put javadate 'T' javatime;
         put '</Date>' nl;
      end;

      define event textheader;
         start:
            open view;
            put '<Text';
            put '>' nl;
            ndent;
            trigger fit_to_container;
            trigger datetime;
            put '<Span';
            trigger inline_style;
            put '>';
         finish:
            put '</Span>' nl;
            xdent;
            put '</Text>' nl;
            close;
      end;

      /* Stand-alone <Text> not associated with */
      /* a title. Used by PROC FREQ crosstabs.  */
      define event body_text;
         start:
            open view;
            put '<Text';
            trigger inline_style;
            put '>' nl;
            trigger fit_to_container;
            ndent;
            put '<Span>';
            /* Do not add a newline after '>'. There can be  */
            /* no white space between the tags and the text. */
            put value;
         finish:
            put '</Span>' nl;
            xdent;
            put '</Text>' nl;
            close;
      end;

        define event system_title_group;
            start:
            /* Removed Dates according to David Bailey          */
            /* if other output doesn't have neither should this */
            /* I agree.  Eric                                   */
            /*set $do_date "true";*/
            open view;
            put '<Header';
            put '>' nl;
            ndent;
            put '<GriddedLayout />' nl;
            close;
          finish:
            open view;
            unset $do_date;
            /* blank line after system titles */
            /* Removed per Dabail 3/10/04 - eric */
            /* put '<Text><!-- no content --></Text>' nl; */
            xdent;
            put '</Header>' nl;
            close;
        end;

        /*-------------------------------------------------------eric-*/
        /*-- I'm not sure about the removal of this event.  We      --*/
        /*-- needed to have something that said there were no       --*/
        /*-- titles for some reason.  When we see why this might    --*/
        /*-- come back.                                             --*/
        /*----------------------------------------------------18Mar04-*/
        define event no_system_titles;
            /* Removed Dates according to David Bailey          */
            /* if other output doesn't have neither should this */
            /* I agree.  Eric                                   */
           /*set $do_date "true";*/
           /*
           open view;
           put '<Header>' nl;
           put '<Text>' nl;
           trigger fit_to_container;
           trigger datetime;
           put '</Text>' nl;
           put '<Text></Text>' nl;
           put '</Header>' nl;
           */
        end;

/*

        define event system_footer_group;
          start:
            open view;
            put "<Footer>" nl;
            putq '<GriddedLayout columns=' colcount '/>' nl;
            open view;
            close;
          finish:
            open view;
            put "</Footer>" nl;
            close;
        end;
*/

        define event proc_title_group;
          start:
            open view;
            trigger bodysection finish;
            trigger innersection finish;
            trigger page_headers;
            close;
          finish:
            open view;
            trigger page_headers;
            trigger bodysection start;
            close;
        end;

/*
        define event system_title_setup_group;
          start:
            open view;
            put '<Header';
            put '>' nl;
            close;
          finish:
            open view;
            put '</Header>' nl;
            close;
        end;
*/

/*
        define event system_footer_setup_group;
          start:
            open view;
            put '<PageFooter';
            trigger inline_style;
            put '>' nl;
            close;
          finish:
            open view;
            put '</PageFooter>' nl;
            close;
        end;
*/

        define event innersection;
            start:
              break /if exists($innersection);
              trigger section;
              set $innersection "true";
            finish:
              break /if !exists($innersection);
              trigger section;
              unset $innersection;
        end;

        define event leaf;
            start:
              open view;
              trigger page_headers finish;
              trigger innersection;
              trigger bodysection start;
              close;
        end;

        define event bodysection;
           start:
                break /if exists($inbody);
                set $inbody "True";
                put "<Body>" nl;
                ndent;
                put '<GriddedLayout columns="1"/>' nl;
           finish:
                break /if !exists($inbody);
                xdent;
                put "</Body>" nl;
                unset $inbody;
        end;

        define event page_headers;
           start:
              trigger innersection;
              break /if exists($in_page_headers);
              put '<Header>' nl;
              put '<GriddedLayout columns="1"/>' nl;
              set $in_page_headers 'true';
           finish:
              break /if !exists($in_page_headers);
              put '</Header>' nl;
              unset $in_page_headers;
        end;

        define event proc;
            start:
                open view;
                trigger section;
                trigger pagebreak_section start;
                close;
            finish:
                open view;
                trigger bodysection finish;
                trigger innersection finish;
                trigger pagebreak_section finish;
                trigger section;
                close;
        end;

        define event pagebreak_section;
            start:
               put '<Section style:pageBreakAfter="always">' nl;
               ndent;
            finish:
               xdent;
               put '</Section>' nl;
        end;


        define event pagebreak;
            open view;
            trigger bodysection finish;
            trigger innersection finish;
            trigger pagebreak_section finish;
            trigger pagebreak_section start;
            close;
        end;

        /*
        define event title_setup_format_section;
             put value;
        end;
        */
        define event title_format_section;
            put '<Span';
            trigger inline_style;
            put '>';
            put value;
            put '</Span>' nl;
        end;

        define event system_title;
        start:
            open view;
            put '<Text';
            put '>' nl;
            trigger fit_to_container;
            ndent;
            put '<Span';
            trigger inline_style;
            put '>';
            put value;
            put '</Span>' nl;
            xdent;
        finish:
            put '</Text>' nl;
            /*
            put '<Text>' nl;
            trigger fit_to_container;
            ndent;
            trigger datetime;
            xdent;
            put '</Text>' nl;
            */
            close;
        end;

        define event system_footer_group;
          start:
            open view;
            trigger bodysection finish;
            trigger innersection finish;
            put '<Footer';
            trigger inline_style;
            put '>' nl;
            /* colcount indicates the number of parts in a title */
            /*putq '<GriddedLayout columns=' colcount '/>' nl;   */
            put '<GriddedLayout columns="1"/>' nl;
            close;
          finish:
            open view;
            put '</Footer>' nl;
            close;
        end;

        define event system_footer;
            open view;
            put '<Text';
            put '>' nl;
            trigger fit_to_container;
            ndent;
            put '<Span';
            trigger inline_style;
            put '>' nl;
            put value nl;
            put '</Span>' nl;
            xdent;
            put '</Text>' nl;
            close;
        end;

        define event byline;
            open view;
            trigger textheader;
            put value;
            trigger textheader finish;
            close;
        end;

        define event proc_title;
            open view;
            trigger textheader;
            put value;
            trigger textheader finish;
            close;
        end;

        define event proc_title_redef;
            open view;
            put '<Text ';
            put '>';
            trigger fit_to_container;
            put '<Span';
            trigger inline_style;
            putq ' topOfPage="True"';
            put '>' nl;
            put value nl;
            put '</Span>' nl;
            put '</Text>' nl;
            close;
        end;

        define event note;
            trigger textheader;
            put 'Note: ' value;
            trigger textheader finish;
        end;
        define event error;
            trigger textheader;
            put 'Error: ' value;
            trigger textheader finish;
        end;
        define event fatal;
            trigger textheader;
            put 'Fatal: ' value;
            trigger textheader finish;
        end;
        define event warning;
            trigger textheader;
            put 'Warning: ' value;
            trigger textheader finish;
        end;

/*
        define event bygroup;
           start:
           trigger section;
           finish:
           trigger section;
        end;
*/
/*
        define event proc_branch;
          start:
             trigger branch;
          finish:
             trigger branch;
        end;

        define event branch;
           start:
              trigger section;
           finish:
              trigger section;
        end;

        define event leaf;
           start:
               open view;
               trigger section;
               set $inleaf 'true';
               put "<Body>" nl;
               put '<GriddedLayout columns="1"/>' nl;
               close;
           finish:
               open view;
               put "</Body>" nl;
               unset $inleaf;
               trigger section;
               close;
        end;
*/
        define event section;
           start:
               put "<Section";

               /*-----------------------------------------------------eric-*/
               /*-- put the html link in.  But only on the first section.--*/
               /*--------------------------------------------------9Jul 03-*/
               do /if !$ods_link;
                   putq " ods:html=" tagset_alias;
                   set $ods_link "TRUE";
               done;

               /* when triggered from leaf event the name     */
               /* variable is preferred over the value        */
               /* variable as the value of the name attribute */
               putq " name=" name;
               putq " name=" value / if !exists(name);
               put ">" nl;
               ndent;
           finish:
               xdent;
               put "</Section>" nl;
        end;

        /* Generate <Image /> tag for graph procs. */
        define event image;
            start:
               open view;
               put '<Image';
               trigger text_align;
               put ' alternateText="' alt '"';
               put ' file="' url '"';
               put ' usemap="#' @CLIENTMAP;
               put ' usemap="#' NAME / if !exists(@CLIENTMAP);
               put '"' / if any(@CLIENTMAP , NAME);
               put ' >' nl;
               trigger griddedconstraint;
               close;
            finish:
               open view;
               put '</Image>' nl;
               close;
        end;

        define event verbatim_container;
           start:
             open view;
             put '<Text';
/*           trigger text_align;*/
             put ' style:fontFamily="SAS Monospace, Courier New, Courier, monospace" style:fontSize="small">' nl;
             close;
           finish:
             open view;
             put '</Text>' nl;
             close;
        end;

        define event verbatim;
           start:
             open view;
             trigger fit_to_container;
             close;
        end;

        /*-------------------------------------------------------eric-*/
        /*-- This is event is no longer used.  Even when doing the  --*/
        /*-- batch view, normal pagebreaks are used.   The verbatim --*/
        /*-- section will be ended, and a pagebreak inserted.       --*/
        /*--                                                        --*/
        /*-- Maybe there is something I don't understand here.  But --*/
        /*-- I don't think so.                                      --*/
        /*----------------------------------------------------20Dec03-*/
        define event preformatted_pagebreak_text;
           start:
             open view;
             put '<Text';
/*           trigger text_align;*/
             put ' style:pageBreakBefore="always" style:fontFamily="SAS Monospace, Courier New, Courier, monospace" style:fontSize="small">' nl;
             trigger fit_to_container;
             close;
           finish:
             open view;
             put '</Text>' nl;
             close;
        end;

        define event verbatim_text;
           open view;
           put "<Span>";
           put value ;
           put "<Br/>" nl;
           put "</Span>" nl;
           close;
        end;
/*
        define event contents_body;
           start:
           trigger section;
           finish:
           trigger section;
        end;
*/

        /* Format-related events */
        define event mappings;
        end;

        define event mapping;
           start:
              open mappings;
              put '<Format';
              putq ' name=' name;
              put '>' nl;
              ndent;
              put '<Type>';
              put type;
              put '</Type>' nl;
              close;             /* DO NOT xdent! */
           finish:
              open mappings;
              xdent;
              put '</Format>' nl;
              close;
        end;

        define event map_head;
        end;

        define event map_options;
           open mappings;
           put '<Name-Options';
           putq ' Default=' defwidth;
           putq ' Fuzz=' fuzz;
           putq ' Max=' max;
           putq ' Min=' min;
           put  ' Multilabel="true"' / if exists(multilabel);
           put  ' Notsorted="true"'  / if exists(notsorted);
           putq ' Round="true"'      / if exists(round);
           put ' />' nl;
           close;
        end;

        define event map_body;
        end;

        define event map_relation;
           start:
              open mappings;

              put '<Mapping>' nl;
              ndent;
              put '<Label-Options';
              putq ' Datatype=' datatype;
              putq ' Fill=' fill;
              putq ' Language=' fmtlang;
              putq ' Multiplier=' multiplier;
              put  ' Noedit="true"'  / if exists(noedit);
              putq ' Prefix=' prefix;
              put ' />' nl;
              close;
           finish:
              open mappings;
              xdent;
              put '</Mapping>' nl;
              close;
        end;

        define event map_interval;
           open mappings;
           put '<Range>';
           put start;

           /* For single-value intervals, the closure */
           /* and end variables will not exist.       */

           put '&lt;-'     / if cmp(closure,"openclosed");
           put '&lt;-&lt;' / if cmp(closure,"openopen");
           put '-&lt;'     / if cmp(closure,"closedopen");
           put '-'         / if cmp(closure,"closedclosed");
           put end;
           put '</Range>' nl;
           close;
        end;

        define event map_display_value;
           open mappings;
           put '<Label>';
           put value;
           put '</Label>' nl;
           close;
        end;
        /* end format-related events */

  end;

   %end;  %mend;
  %tagsets_sasreport;


  define tagset tagsets.sasreport_html;
      parent=tagsets.html4;
      stacked_columns = no;

        define event doc_body;
           put '<body onload="startup()"';
           put ' onunload="shutdown()"';
           put  ' bgproperties="fixed"' / WATERMARK;
           putq " class=" HTMLCLASS;
           putq " background=" BACKGROUNDIMAGE;
           trigger style_inline;
           put ">" CR;
           trigger pre_post;
           put          CR;
           trigger ie_check;
           trigger body_div;
         finish:
           trigger body_div;
           trigger pre_post;
           put "</body>" CR;
        end;

        define event body_div;
            put '<!-- Outermost div Begin -->' nl;
            put '<div';
            putq ' class=' HTMLCLASS;
            put ">" CR;
          finish:
            put "</div>" CR;
            put '<!-- Outermost div End -->' nl;
        end;

        define event embedded_stylesheet;
           start:
               put "<style type=""text/css"">" nl "<!--" nl;
               put "/* ODS style classes Begin */" nl;
              trigger alignstyle;
           finish:
               put "/* ODS style classes End */" nl;
              put "-->" nl "</style>" nl;
       end;

       define event stylesheet_link;
           break /if !exists(url);
           put '<style type="text/css">' CR '<!--' CR;

           put "/* ODS style classes Begin */" nl;

           trigger alignstyle;

           put "/* ODS style classes End */" nl;

           put '-->' CR '</style>' CR ;

           put '<!--' CR;
           put "/* ODS style links Begin */" nl;
           put '-->' CR;

           set $urlList url;
           trigger urlLoop ;
           unset $urlList;

           put '<!--' CR;
           put "/* ODS style links End */" nl;
           put '-->' CR;
       end;

       define event image;
           put '<div';
           trigger alt_align;
           put '>' nl;
           put "<!-- Image -->" nl;
           put "<img";
           putq ' alt=' alt;
           put ' src="';
           put BASENAME / if !exists(NOBASE);
           put URL;
           put '"';
           put ' style="' /if any(outputheight, outputwidth);
           put "height:" OUTPUTHEIGHT ";" /if exists(outputheight);
           put " width:" OUTPUTWIDTH ";" /if exists(outputwidth);
           put '"' /if any(outputheight, outputwidth);
           put ' border="0"';
           put ' usemap="#' @CLIENTMAP;
           put ' usemap="#' NAME / if !exists(@CLIENTMAP);
           put '"' / if any(@CLIENTMAP , NAME);
           putq " id="    HTMLID;
           trigger classalign;
           put $empty_tag_suffix;
           put ">" CR;
           put "</div>" CR;

       end;

       define event alignstyle ;
           putl '.l {text-align: left }';
           putl '.c {text-align: center }';
           putl '.r {text-align: right }';
           putl '.d {text-align: "." }';
           putl '.t {vertical-align: top }';
           putl '.m {vertical-align: middle }';
           putl '.b {vertical-align: bottom }';
           putl 'DIV.Body TD, DIV.Body TH {vertical-align: top }';
       end;

       define event linkclass;
       end;

       define event vlinkclass;
       end;

       define event alinkclass;
       end;

       define event proc;
       end;

  end;

run;
