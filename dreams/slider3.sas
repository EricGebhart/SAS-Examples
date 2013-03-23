proc template;
    define style styles.slider;
        parent=styles.default;

        style table from output /
            rules=cols
            cellpadding=3
            cellspacing=1
        ;
        style slider from data /
            background=colors('headerbg')
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
            set $width value /breakif index(value, '%') > 0;

            eval $dash_pos index(Tagattr, '-');
            do /if $dash_pos;
                eval $dash_pos $dash_pos+1;
            done;
            eval $value compress(value, $currency_compression);
            eval $value inputn($value, 'BEST20.');
            eval $max inputn(substr(Tagattr, $dash_pos), 'BEST20.');
            eval $width ($value / $max) * 100;
            set $width '0' /if missing($width);
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
                break /if cmp($width, '0%');
                put "<td";
                putq ' width=' $width;
                putq " title=" flyover;
                do /if !cmp(htmlclass,'batch');
                    trigger classalign;
                    trigger style_inline;
                done;
                trigger rowcol;
                put " nowrap" /if no_wrap;
                put ">";
                trigger cell_value;
                set $wrote_cell "True";
        end;
            
        define event data;
            start:
                /* this would work but sometimes htmlclass is empty... */
                unset $slider_column;
                unset $cell_has_value;
                unset $wrote_cell;
                set $header "True";

                trigger header /breakif cmp(htmlclass, "RowHeader");
                trigger header /breakif cmp(htmlclass, "Header");
                unset $header;

                do /if index(tagattr, 'slider') > 0;
                    put '<td width="150" class="data">' nl;
                    put '<table width="100%" class="data" cellpadding=0; cellspacing=0;>' nl;
                    trigger calculate_width;
                    set $slider_column "True";
                done;

                trigger data_cell_value /if value;
                

            finish:
                trigger header /breakif cmp(htmlclass, "RowHeader");
                trigger header /breakif cmp(htmlclass, "Header");
   
                trigger data_cell_value /if ^$wrote_cell;
                put "</td>" CR /if $wrote_cell;
                do /if $width;
                    put '<td>&nbsp;</td>' CR;
                    put "</table></td>" CR;
                    unset $width;
                done;

        end;
    end;
run;

options obs=3;
ods tagsets.slider file='test.html' style=slider options(doc='help');

proc print data=sashelp.class;
    var name;
    var sex;
    var age;     
    var height / style(data) = slider[just=center tagattr="slider-80"];
    var weight / style(data) = slider[just=center tagattr="slider-150"];
run;

PROC REPORT DATA=sashelp.class LS=138 PS=55  SPLIT="/" HEADLINE HEADSKIP CENTER nowd;

DEFINE  name / DISPLAY "Name" style=header;
DEFINE  sex / DISPLAY center "Sex";
DEFINE  age / DISPLAY   center "Age" ;
DEFINE  height / DISPLAY  center "Height" style(column)=slider[tagattr="slider-80"];
DEFINE  weight / DISPLAY  center "Weight" style(column)=slider[tagattr="slider-150"];
run;

ods tagsets.slider close;
