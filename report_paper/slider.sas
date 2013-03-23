proc template;
    define style styles.slider;
        parent=styles.default;

        style table from output /
            rules=cols
            cellpadding=0
            cellspacing=0
        ;
/*
        replace data from data /
            backgroundimage = 'gridline58.png'
        ;
*/
        style slider from data /
            background = colors('headerbg')
        ;
        style bar from data /
	    backgroundimage = 'gridline58.gif'
            borderleftwidth = 1px
            borderleftstyle = solid
            borderleftcolor =  cxe5e5e5
            borderrightwidth = 1px
            borderrightstyle = solid
            borderrightcolor = cxe5e5e5
            cellpadding = 0
            borderbottomstyle = none
            preimage = 'bar.png';
        
        ;
        style header from header /
            just = left
            vjust = top
        ;

        style last from bar  /
	    borderbottomwidth = 1px
	    borderbottomstyle = solid 
	    borderbottomcolor = cxe5e5e5
        ;

        style first from bar /
	    bordertopwidth = 1px
	    bordertopstyle = solid
	    bordertopcolor = cxe5e5e5
        ;
    end;


  

    define tagset tagsets.slider;
        parent=tagsets.html4;

    define event initialize;
        trigger set_just_lookup;
        trigger set_options;
    end;
    
    define event options_set;
        trigger set_options;
    end;

    define event set_options;
        trigger nls_numbers;
        trigger options_setup;
        trigger documentation;
    end;

    define event documentation;
        break /if ^$options;
        trigger quick_reference /if cmp($options['DOC'], 'quick');
        trigger help /if cmp($options['DOC'], 'help');
        trigger settings /if cmp($options['DOC'], 'settings');
    end;

    define event help;
        putlog "==============================================================================";
        putlog "The HTML Slide Bar Tagset Help Text.";
        putlog " ";
        putlog "This Tagset/Destination creates HTML that has slidebars in the indicated table";
        putlog "Columns.  The slidebar is turned on by setting tagattr as a style over ride.";
        putlog " ";
        putlog "The following Proc Print turns the sliders on for the height and weight columns.";
        putlog "The value given is used to calculate a percentage from the values that are in the";
        putlog "data cells.  If the values are percentages then no value is needed.";
        putlog " ";
        putlog "proc print data=sashelp.class;";
        putlog "    var name;";
        putlog "    var sex;";
        putlog "    var age;     ";
        putlog '    var height / style(data) = slider[just=center tagattr="slider-80"];';
        putlog '    var weight / style(data) = slider[just=center tagattr="slider-150"];';
        putlog " ";
        putlog "In the case that the values may have negative values a second value must ";
        putlog "be given.  The second value is the 0 offset.  If the largest negative value ";
        putlog "is -275 then the offset would be 275.  That value would be specified as this. ";
        putlog " ";
        putlog '    var weight / style(data) = slider[just=center tagattr="slider-150 275"];';
        putlog " ";
        putlog "This particular example specifies a range of -275 - 150 for that column's values.";
        putlog " ";
        trigger quick_reference;
    end;


    define event quick_reference;
        putlog "==============================================================================";
        putlog " ";
        putlog "These are the options supported by this tagset.";
        putlog " ";
        putlog "Sample usage:";
        putlog " ";
        putlog "ods tagsets.slidebar file='test.html' options(doc='Help'); ";
        putlog " ";
        putlog "ods tagsets.slidebar options(doc='Quick'); ";
        putlog " ";
        putlog "ods tagsets.slidebar options(currency_symbol='€' Thousands_separator='.'); ";
        putlog " ";
        putlog "Doc:  No default value.";
        putlog "     Help: Displays introductory text and options.";
        putlog "     Quick: Displays available options.";
        putlog " ";
        putlog "Aural_headers:   Default Value 'no'";
        putlog "     When turned on the heders of a table are invisible but readable by";
        putlog "     HTML readers.   The text of the header is used by default. ";
        putlog " ";
        putlog "Aural_text:   Default Value 'none'";
        putlog "     valid values are the values of none, flyover or summary.";
        putlog "     when given, the text of the given field will be used in place of";
        putlog "     the value of the header.";
        putlog " ";
        putlog "Currency_symbol:   Default Value '$'";
        putlog "     Used for detection of currency formats and for ";
        putlog "     removing those symbols so excel will like them.";
        putlog "     Will be deprecated in a future release when it is";
        putlog "     no longer needed.        ";
        putlog " ";
        putlog "Thousands_separator:   Default Value ','";
        putlog "     The character used for indicating thousands in numeric values.";
        putlog "     Used for removing those symbols from numerics so excel will like them.";
        putlog "     Will be deprecated in a future release when it is no longer needed.";
        putlog " ";
        putlog "==============================================================================";
        putlog " ";
    end;
    

    define event nls_numbers;

        unset $currency;
        unset $decimal_separator;
        unset $thousands_separator;

        /*-------------------------------------------------------eric-*/
        /*-- The currency symbol for the US is $,  set it           --*/
        /*-- accordingly.  It is used for detection of currency     --*/
        /*-- formats and for removing those symbols so excel will   --*/
        /*-- like them.                                             --*/
        /*----------------------------------------------------14Jun04-*/
        set $currency $options['CURRENCY_SYMBOL'] /if $options;
        set $currency "$" /if ^$currency;
        set $currency_compress $currency ",";

        set $thousands_separator $options['THOUSANDS_SEPARATOR'] /if $options;
        set $thousands_separator ',' /if ^$thousands_separator;

        set $Currency_compression $currency $thousands_separator;

    end;

    define event options_setup;
        /*--------------------------------------------------------------*/
        /* options should exist, but avoid bad resolution if it doesn't */
        /* This only happens in SAS 9.1.2 and earlier                   */
        /* 9.1 and 9.1.2 have a known bug.  If an array/dictionary is   */
        /* Accessed in a set, and the array is not defined, the value   */
        /* resolves to the subscript.  Not good, but avoidable.         */
        /* Normally just putting '/if $options' on the set will fix it  */
        /* but this logic becomes needlessly complex.  This is cleaner  */
        /*--------------------------------------------------------------*/
        set $options['test'] "test" /if ^$options;

        trigger set_config_debug_options;

        do /if $options['AURAL_HEADERS'];
            do /if cmp($options['AURAL_HEADERS'], "yes");
                set $aural_headers 'True';
            else;
                unset $aural_headers;
            done;
        done;

        do /if $options['AURAL_TEXT'];
            do /if cmp($options['AURAL_TEXT'], "none");
                unset $aural_text;
            else /if cmp($options['AURAL_TEXT'], "flyover");
                set $aural_text 'flyover';
            else /if cmp($options['AURAL_TEXT'], "summary");
                set $aural_text 'summary';
            else;
                unset $aural_text;
            done;
        done;
    end;
    

        define event style_inline;
            /*put ' ' tagattr;*/
            break / if !any(font_face, font_size, font_weight, font_style,
                            foreground, background, backgroundimage,
                            leftmargin, rightmargin, topmargin, bottommargin,
                            bullet, outputheight, outputwidth, htmlstyle, indent, text_decoration,
                            borderwidth,
                            bordertopwidth, borderbottomwidth, borderrightwidth, borderleftwidth,
                            bordercolor,
                            bordertopcolor, borderbottomcolor, borderrightcolor, borderleftcolor,
                            borderstyle,
                            bordertopstyle, borderbottomstyle, borderrightstyle, borderleftstyle);
            put ' style="';
            put " font-family: " FONT_FACE;
            put  ";" / exists(FONT_FACE);
            put " font-size: " FONT_SIZE;
            put  ";" / exists(FONT_SIZE);
            put " font-weight: " FONT_WEIGHT;
            put  ";" / exists(FONT_WEIGHT);
            put " font-style: " FONT_STYLE;
            put  ";" / exists(FONT_STYLE);
            put " color: " FOREGROUND;
            put  ";" / exists(FOREGROUND);
            put " text-decoration: " text_decoration;
            put ";" / exists(text_decoration);
            put " background-color: " BACKGROUND;
            put  ";" / exists(BACKGROUND);
            put "  background-image: url('" BACKGROUNDIMAGE "')" /if exists(backgroundimage);
            put  ";" / exists(BACKGROUNDIMAGE);
            put " margin-left: " LEFTMARGIN;
            put  ";" / exists(LEFTMARGIN);
            put " margin-right: " RIGHTMARGIN;
            put  ";" / exists(RIGHTMARGIN);
            put " margin-top: " TOPMARGIN;
            put  ";" / exists(TOPMARGIN);
            put " margin-bottom: " BOTTOMMARGIN;
            put  ";" / exists(BOTTOMMARGIN);
            put " text-indent: " indent;
            put  ";" / exists(indent);

            trigger Border_inline ;

            put " list_style_type: " BULLET;
            put  ";" / exists(BULLET);
            put " height: " OUTPUTHEIGHT;
            put  ";" / exists(OUTPUTHEIGHT);
            put " width: " OUTPUTWIDTH;
            put  ";" / exists(OUTPUTWIDTH);

            put  " " htmlstyle;
            put  ";" / exists(htmlstyle);
            put '"';
        end;

        define event calculate_width;
            unset $offset_pos;
            unset $max_len;
        
            set $width value /breakif index(value, '%') > 0;

            eval $dash_pos index(Tagattr, '-');
            do /if $dash_pos;
                eval $dash_pos $dash_pos+1;
                eval $max_and_offset substr(Tagattr, $dash_pos);
                eval $offset_pos index($max_and_offset, ' ');
            done;

            eval $value compress(value, $currency_compression);
            eval $value inputn($value, 'BEST20.');

            /*---------------------------------------------------------------eric-*/
            /*-- If there is a negative range all the numbers need to be        --*/
            /*-- shifted above 0.                                               --*/
            /*------------------------------------------------------------13Feb06-*/
            do /if $offset_pos > 0;
                eval $offset_pos $offset_pos+1;
                eval $max_len length($max_and_offset) - $offset_pos;

                eval $max inputn(substr($max_and_offset, 1, $max_len), 'BEST20.');
                eval $offset inputn(substr($max_and_offset, $offset_pos), 'BEST20.');
                eval $value $value + $offset;
                eval $max $max + $offset;
            else;
                eval $max inputn(substr(Tagattr, $dash_pos), 'BEST20.');
            done;
                
            eval $width ($value / $max) * 100;
            set $width '0' /if missing($width);
            /* set the img width to up to 300 pixels. */
            eval $img_width $width;
            set $width $width '%';
            unset $dash_pos;
        end;

        define event put_value;
            do /if $slider_column;
                trigger calculate_width;
                trigger data_cell_value;
            else;
                do /if $header;
                    trigger cell_value;
                else;
                    trigger data_cell_value;
                done;
            done;
        end;

        define event data_cell_value;
                put "<td";
                do /if $slider_column && ^$bar_column;
                    putq ' width=' $width;
                done;
                    
                putq " title=" flyover;
                do /if !cmp(htmlclass,'batch');
                    trigger classalign;
                    trigger style_inline;
                done;
                trigger rowcol;
                put " nowrap" /if no_wrap;
                put ">";

                do /if $slider_column;
                    do /if $bar_column;
                        put "<img ";
                        putq ' src=' preimage;
                        put  ' alt=""';
                        putq ' width=' $img_width;
                        put ' height="16"';
                        put '/>';
                    done;
                done;

                trigger cell_value;
                set $wrote_cell "True";
        end;

        define event hyperlink;
          start:
            put '<a href="' URL;
            /*put "#" ANCHOR;*/
            put '"';
            do /if cmp(dest_file, 'contents');
              putq " target=" HREFTARGET / if frame_name;
            else;
              putq " target=" HREFTARGET;
            done;
            put ">";
            trigger aural_text_value;
          finish:
            put "</a>" CR;
        end;

        define event aural_text_value;
            do /if cmp($aural_text, 'flyover');
                put flyover;
            else /if cmp($aural_text, 'summary');
                put summary;
            else;
                put value;
            done;
        end;

        define event aural_value;
          start:
            do / if exists(URL);
                set $close_hyperlink "true";
                trigger hyperlink;
            else;
                trigger aural_text_value;
          finish:
            trigger hyperlink / if exists($close_hyperlink);
            unset $close_hyperlink;
        end;

        define event cell_value;
          start:
            trigger preformatted /if asis;
            do / if exists(URL);
                set $close_hyperlink "true";
                trigger hyperlink;
            else;
                put value;
            done;
            
          finish:
            trigger hyperlink / if exists($close_hyperlink);
            unset $close_hyperlink;
            trigger preformatted /if asis;
        end;
            
        define event data;
            start:
                /* this would work but sometimes htmlclass is empty... */
                unset $slider_column;
                unset $bar_column;
                unset $cell_has_value;
                unset $wrote_cell;
                set $header "True";

                trigger header /breakif cmp(htmlclass, "RowHeader");
                trigger header /breakif cmp(htmlclass, "Header");
                unset $header;

                do /if index(tagattr, 'slider') > 0;
                    trigger calculate_width;
                    set $slider_column "True";
                    do /if preimage;
                        set $bar_column "True";
                        trigger data_cell_value;
                        break;
                    else;
                        put '<td width="150" class="data">' nl;
                        put '<table width="100%" class="data" cellpadding=0; cellspacing=0;>' nl;
                    done;    

                done;    
                    trigger data_cell_value;    
                 
            finish:
                trigger header /breakif cmp(htmlclass, "RowHeader");
                trigger header /breakif cmp(htmlclass, "Header");
   
                trigger data_cell_value /if ^$wrote_cell;
                put "</td>" nl /if $wrote_cell;
                do /if $slider_column;
                    do /if ^$bar_column;
                        put '<td>&nbsp;</td>' CR;
                        put "</table></td>" CR;
                        unset $width;
                    done;
                done;

        end;

        define event auralstyle;
            putl '.auraltext';
            putl '    {';
            putl '       position: absolute;';
            putl '       font-size: 0;';
            putl '       left: -1000px;';
            putl '    }';
        end;
    
        define event stylesheet_link;
            break /if !exists(url);
            set $urlList url;
            trigger urlLoop ;
            unset $urlList;
            put '<style type="text/css">' CR '<!--' CR;
            trigger alignstyle;
            trigger auralstyle;
            put '-->' CR '</style>' CR ;
        end;

        define event embedded_stylesheet;
           start:
              put "<style type=""text/css"">" nl "<!--" nl;
           finish:
              trigger alignstyle;
            trigger auralstyle;
              put "-->" nl "</style>" nl;
        end;

         define event header;
            start:
                put "<th";
                putq " title=" flyover;
                trigger classalign;
                trigger style_inline;
                trigger rowcol;
                put ">";
                do /if cmp(section, 'head');
                    do /if $aural_headers;
                        put '<span class="auraltext">' ;
                        trigger aural_value;
                    else;
                        trigger cell_value;
                    done;
                done;
            finish:
                do /if cmp(section, 'head');
                    do /if $aural_headers;
                        trigger aural_value;
                    else;
                        trigger cell_value;
                    done;
                done;
                put '</span>' /if $aural_headers;
                put "</th>" CR;
         end;
    end;
run;

