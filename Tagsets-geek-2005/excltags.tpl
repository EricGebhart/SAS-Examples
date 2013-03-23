
proc template;

define tagset Tagsets.ExcelXP;
    notes "Excel XP (2002) XML format.";
    Parent = tagsets.config_debug;
    output_type = "xml";
    indent = 0;
    split = "&#10;";
    default_event = '';
    /*-----------------------------------------------------------eric-*/
    /*-- This seems to act like a preferred split but only works if --*/
    /*-- Wrapit is set on the style.  But if wrapit is set on the   --*/
    /*-- style everything wraps if it doesn't fit.  Very strange.   --*/
    /*-- It's best to not wrap.                                     --*/
    /*--------------------------------------------------------29Jul03-*/

    /*----------------------------------------------------------Vince-*/
    /*-- Using &#10; for the split for column headings will work    --*/
    /*-- providing WrapText is set to 1 on the Alignment element    --*/
    /*-- for that cell.  Added the logic for this in the            --*/
    /*-- xl_style_elements event and modified the width calculation --*/
    /*-- in the sub_colspec_header and colspec_entry events.        --*/
    /*--------------------------------------------------------20Dec04-*/

    map = '<>&';
    mapsub = '/&lt;/&gt;/&amp;/';
    copyright='&copy;';
    trademark='&trade;';
    registered_tm='&reg;';
    nobreakspace = ' ';
    stacked_columns = no;
    embedded_stylesheet = yes;
    pure_style=no;

    /*    default_event = "default"; */

    /*-----------------------------------------------------------eric-*/
    /*-- If 'yes' system titles and footnotes will be placed as     --*/
    /*-- spanning cells above and below each table. - A part of     --*/
    /*-- the table really.                                          --*/
    /*--------------------------------------------------------22Aug03-*/
    mvar embedded_titles;

    /*-----------------------------------------------------------eric-*/
    /*-- If yes, cause the top of the worksheet to be stationary    --*/
    /*-- while the data scrolls.                                    --*/
    /*--------------------------------------------------------4Aug 04-*/
    mvar frozen_headers;

    /*-----------------------------------------------------------eric-*/
    /*-- If yes, cause the left of the worksheet to be stationary    --*/
    /*-- while the data scrolls.                                    --*/
    /*--------------------------------------------------------4Aug 04-*/
    mvar frozen_rowheaders;

    /*-----------------------------------------------------------eric-*/
    /*-- If all or a range like 1-10, causes autofilter to be       --*/
    /*-- turned on for all or some of the columns in the table      --*/
    /*--------------------------------------------------------4Aug 04-*/
    mvar autofilter;
    mvar width_points;
    mvar width_fudge;
    mvar default_column_width;

    /*-----------------------------------------------------------eric-*/
    /*-- If 'no' do not turn percentages into numbers.              --*/
    /*-- Display them as strings.  The default behavior             --*/
    /*-- is to divide them by 100 before displaying as              --*/
    /*-- Percent format.                                            --*/
    /*--------------------------------------------------------23Aug03-*/
    mvar convert_percentages;

    /*-----------------------------------------------------------eric-*/
    /*-- Set orientation to landscape to get landscape oriented printing.--*/
    /*--------------------------------------------------------14Jun04-*/
    mvar orientation;

    /*-----------------------------------------------------------eric-*/
    /*-- Supposedly there is a 31 worksheet limit.  But we have     --*/
    /*-- not seen that to be the case.                              --*/
    /*--------------------------------------------------------25Jul03-*/
    log_note = "NOTE: This is the Excel XP tagset. Add options(doc='help') to the ods statement for more information.";

    /*-----------------------------------------------------------eric-*/
    /*-- The excel xml specification is here.                       --*/
    /*--                                                            --*/
    /*-- http://msdn.microsoft.com/library/default.asp?url=/library/en-us/dnexcl2k2/html/odc_xlsmlinss.asp--*/
    /*--------------------------------------------------------24Jul03-*/

    notes "http://msdn.microsoft.com/library/default.asp?url=/library/en-us/dnexcl2k2/html/odc_xlsmlinss.asp";

    define event default;
        start:
            put "<" event_name ">" nl;
        finish:
            put "</" event_name ">" nl;
    end;
    /*-----------------------------------------------------------eric-*/
    /*-- excel can currently only handle one table per worksheet so --*/
    /*-- any options other than table or bygroup will not work.     --*/
    /*-- The specification reads like that may change in the future --*/
    /*-- so I'll leave the code in place for now.                   --*/
    /*--------------------------------------------------------21Jul03-*/
    /*
    log_note = 'NOTE: Experimental Excel XP tagset. Use alias=("proc" | "page" | "bygroup" | "table" | "none") to determine how worksheets will be created.  The default is page.';
    */

    /*-------------------------------------------------------------eric-*/
    /*-- The specification for this xml is here.                      --*/
    /*-- http://msdn.microsoft.com/library/default.asp?               --*/
    /*--        url=/library/en-us/dnexcl2k2/html/odc_xlsmlinss.asp   --*/
    /*----------------------------------------------------------4Jul 03-*/

    /*-------------------------------------------------------------eric-*/
    /*-- Use this event to reset the worksheet interval to what was   --*/
    /*-- given on the ods statement or to the default.  If no value   --*/
    /*-- is given then it will reset.  If a value of proc, page,      --*/
    /*-- bygroup, table, or none is given then the interval will be   --*/
    /*-- set to the value given.                                      --*/
    /*-- Use like this:                                               --*/
    /*--                                                              --*/
    /*-- ods tagsets.excelxp event=sheet_interval(text="bygroup");    --*/
    /*--                                                              --*/
    /*-- or to reset the interval                                     --*/
    /*--                                                              --*/
    /*-- ods tagsets.excelxp event=sheet_interval;                    --*/
    /*----------------------------------------------------------4Jul 03-*/
    define event documentation;
        break /if ^$options;
        trigger quick_reference /if cmp($options['DOC'], 'quick');
        trigger help /if cmp($options['DOC'], 'help');
        trigger settings /if cmp($options['DOC'], 'settings');
    end;

    define event help;
        putlog "==============================================================================";
        putlog "The EXCELXP Tagset Help Text.";
        putlog " ";
        putlog "This Tagset/Destination creates Microsoft's spreadsheetML XML.";
        putlog "It is used specifically for importing data into Excel.";
        putlog " ";
        putlog "Each table will be placed in its own worksheet within a workbook.";
        putlog "This destination supports ODS styles, traffic lighting, and custom formats.";
        putlog " ";
        putlog "Numbers, Currency and percentages are correctly detected and displayed.";
        putlog "Custom formats can be given by supplying a style override on the tagattr";
        putlog "style element.";
        putlog " ";
        putlog "By default, titles and footnotes are part of the spreadsheet, but are part";
        putlog "of the header and footer.";
        putlog " ";
        putlog "Also by default, printing will be in 'Portrait'.";
        putlog "The orientation can be changed to landscape.";
        putlog " ";
        putlog "The specification for this xml is here.";
        putlog "http://msdn.microsoft.com/library/default.asp?url=/library/en-us/dnexcl2k2/html/odc_xlsmlinss.asp";
        putlog " ";
        putlog "See Also:";
        putlog "http://support.sas.com/rnd/base/topics/odsmarkup/";
        putlog "http://support.sas.com/rnd/papers/index.html#excelxml";
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
        putlog "ods tagsets.excelxp file='test.xml' data='test.ini' options(doc='Help'); ";
        putlog " ";
        putlog "ods tagsets.excelxp options(doc='Quick'); ";
        putlog " ";
        putlog "ods tagsets.excelxp options(embedded_titles='No' Orientation='Landscape'); ";
        putlog " ";
        putlog "Doc:  No default value.";
        putlog "     Help: Displays introductory text and options.";
        putlog "     Quick: Displays available options.";
        putlog " ";
        putlog "Orientation:   Default Value 'Portrait'";
        putlog "     Tells excel how to format the page when printing.";
        putlog "     The only other value is 'landscape'.";
        putlog "     Also available as a macro variable.";
        putlog " ";
        putlog "Embedded_Titles:   Default Value 'No'";
        putlog "     If 'Yes' titles and footnotes will appear in the worksheet.";
        putlog "     By default, titles and footnotes are a part of the header and footer.";
        putlog "     Also available as a macro variable.";
        putlog " ";
        putlog "Frozen_Headers:   Default Value 'No'";
        putlog "     If 'Yes' The rows down to the bottom of the headers will be frozen when";
        putlog "     the table data scrolls.  This includes any titles created with the";
        putlog "     embedded titles option.";
        putlog "     Also available as a macro variable.";
        putlog " ";
        putlog "Frozen_RowHeaders:   Default Value 'No'";
        putlog "     If 'Yes' The header columns on the left will be frozen when";
        putlog "     the table data scrolls.";
        putlog "     Also available as a macro variable.";
        putlog " ";
        putlog "AutoFilter:   Default Value 'none'";
        putlog "     Values: None, All, range.";
        putlog "     If 'all' An auto filter will be applied to all columns.";
        putlog "     If a range such as '3-5' The auto filter will be applied to the";
        putlog "          in that range of columns.";
        putlog " ";
        putlog "AutoFilter_Table:   Default Value '1'";
        putlog "     Values: Any number";
        putlog "     If sheet interval is anything but table or bygroup, this value";
        putlog "     Determines which table gets the autofilter applied.  If the sheet";
        putlog "     interval is table, or bygroup the only table get's the autofilter";
        putlog "     regardless of this setting.";
        putlog " ";
        putlog "Width_Fudge:   Default Value '0.75'";
        putlog "     Values: None, Number.";
        putlog "     By default this value is used along with Width_Points and column width";
        putlog "     to calculate an approximate width for the table columns.";
        putlog "     width = Data_Font_Points * number_Of_Chars * Width_Fudge.";
        putlog "     If 'none' this feature is turned off.";
        putlog " ";
        putlog "Width_Points:   Default Value 'None'";
        putlog "     Values: None, Number.";
        putlog "     By Default the point size from the data or header style";
        putlog "     elements are used to calculate a pseudo column width.";
        putlog "     The column width is calculated from the given column width or";
        putlog "     the length of the column's header text.  If the header is bigger.";
        putlog "     In the case the header length is used, so is the header's point size.";
        putlog "     This value overrides that point size.";
        putlog "     This value is used along with WidthFudge and column width";
        putlog "     to calculate an approximate width for the table columns.";
        putlog "     width = Width_Points * number_Of_Chars * Width_Fudge.";
        putlog " ";
        putlog "Default_Column_Width:   Default Value 'None'";
        putlog "     Values: None, Number, list of numbers.";
        putlog "     Most procedures provide column widths, but occasionally a column";
        putlog "     will not have a width.  Excel will resize the column to fit any";
        putlog "     numbers but will not auto-size for character string headings.";
        putlog "     In the case that a column does not have a width, this value will be";
        putlog "     used instead.  The value should be the width in characters.";
        putlog "     If the value of this option is a comma separated list.";
        putlog "     Each number will be used for the column in the same position.  If";
        putlog "     the table has more columns, the list will start over again.";
        putlog " ";
        putlog "TagAttr Style Element:   Default Value ''";
        putlog "     Values: <ExcelFormat> or <Format: ExcelFormat> <Formula: ExcelFormula>";
        putlog "     This is not a tagset option but a style attribute that the tagset will";
        putlog "     use to get formula's and column formats. The format and formula's given";
        putlog "     must be a valid to excel.";
        putlog "     A single value without a keyword is interpreted as a format.";
        putlog "     Both a formula and format can be specified together with keywords.";
        putlog "     There should be no spaces except for those between the two values";
        putlog "     The keyword and value must be separated by a ':'";
        putlog "     tagattr='Format:###.## Formula:SUM(R[-4]C:R[-1]C').";
        putlog " ";
        putlog "Sheet_Interval:   Default Value 'Table'";
        putlog "     Values: Table, Page, Bygroup, Proc, None.";
        putlog "     This option controls how many tables will go in a worksheet.";
        putlog "     In reality only one table is allowed per worksheet.  To get more";
        putlog "     than one table, the tables are actually combined into one.";
        putlog " ";
        putlog "     Specifying a sheet interval will cause the current worksheet to close.";      
        putlog " ";
        putlog "Sheet_Name:   Default Value 'None'";
        putlog "     Values: Any string ";
        putlog "     Worksheet names can be up to 31 characters long.  This name will";
        putlog "     be used in combination with a worksheet counter to create a unique name.";
        putlog " ";
        putlog "Sheet_Label:   Default Value 'None'";
        putlog "     Values: Any String";
        putlog "     This option is used in combination with the various worksheet naming.";
        putlog "     heuristics which are based on the sheet interval.";
        putlog "     This string will be used as the first part of the name instead of the";
        putlog "     predefined string it would normally use.";
        putlog " ";
        putlog "     These are the defaults:";
        putlog " ";
        putlog "     'Proc ' total_Proc_count  - label";
        putlog "     'Page ' total_page_count  - label";
        putlog "     'By '   numberOfWorksheets byGroupLabel - label";
        putlog "     'Table ' numberOfWorksheets  - label";
        putlog " ";
        putlog "Auto_SubTotals:   Default Value 'No'";
        putlog "     Values: Yes, No";
        putlog "     If yes, this option causes a subtotal formula to be placed in the";
        putlog "     subtotal cells on the last table row of the Print Procedure's tables.";
        putlog "     WARNING: This does not work with Sum By.  It only works if the ";     
        putlog "     totals only happen once per table.";
        putlog " ";
        putlog "Convert_Percentages:   Default Value 'Yes'";
        putlog "     Remove percent symbol, apply excel percent format, and multiply by 100.";
        putlog "     This causes percentage values to display as numeric percentages in Excel.";
        putlog "     If 'No' percentage values will be untouched and will appear as";
        putlog "     strings in Excel.";
        putlog "     Will be deprecated in a future release when it is no longer needed.";
        putlog " ";
        putlog "Currency_symbol:   Default Value '$'";
        putlog "     Used for detection of currency formats and for ";
        putlog "     removing those symbols so excel will like them.";
        putlog "     Will be deprecated in a future release when it is";
        putlog "     no longer needed.        ";
        putlog " ";
        putlog "Currency_format:   Default Value 'Currency'";
        putlog "     The currency format specified for excel to use.";
        putlog "     Another possible value is 'Euro Currency'.";
        putlog "     Will be deprecated in a future release when it is";
        putlog "     no longer needed.        ";
        putlog " ";
        putlog "Decimal_separator:   Default Value '.'";
        putlog "     The character used for the decimal point.";
        putlog "     Will be deprecated in a future release when it is no longer needed.";
        putlog " ";
        putlog "Thousands_separator:   Default Value ','";
        putlog "     The character used for indicating thousands in numeric values.";
        putlog "     Used for removing those symbols from numerics so excel will like them.";
        putlog "     Will be deprecated in a future release when it is no longer needed.";
        putlog " ";
        putlog "Numeric_Test_Format:   Default Value '12.'";
        putlog "     Used for determining if a value is numeric or not.";
        putlog "     Other useful values might be COMMAX or NLNUM formats.";
        putlog "     Will be deprecated in a future release when it is no longer needed.";
        putlog " ";
        putlog "Minimize_Style:   Default Value 'No'";
        putlog "     If set to 'yes' the stylesheet will be filtered so that only the most.";
        putlog "     necessary definitions are printed.  This can have the reverse effect";
        putlog "     if style attribute over rides are used on the proc statements.";
        putlog "     It is best to define a new style with the appropriate over rides built in.";
        putlog "     The proc can use the new style, but without individual attribute over-rides.";
        putlog "     The result is a much smaller style section. - In that case, this option";
        putlog "     should be set to No.";
        putlog " ";

        trigger config_debug_help;

        putlog "==============================================================================";
    end;

        define event compile_regexp;
            unset $currency_sym;
            unset $decimal_separator;
            unset $thousands_separator;

            /*=========================================================*/
            /* If the currency symbol, decimal separator, or thousands */
            /* separator are Perl regular expression metacharacters,   */
            /* then they must be escaped with a backslash.             */
            /*=========================================================*/

            set $currency_sym "\" $currency;
            set $currency_sym "\$" /if ^$currency_sym;

            set $decimal_separator  "\." /if ^$decimal_separator;

            set $thousands_separator "," /if ^$thousands_separator;

            set $punctuation $currency_sym $thousands_separator "%";

            set $integer_re   "\d+";
            set $sign_re      "[+-]?";
            set $group_re     "\d{1,3}(?:" $thousands_separator "\d{3})*";
            set $whole_re     "(?:" $group_re "|" $integer_re ")";
            set $exponent_re  "[eE]" $sign_re $integer_re;
            set $fraction_re  "(?:" $decimal_separator "\d*)";
            set $real_re      "(?:" $whole_re $fraction_re "|" $fraction_re $integer_re "|" $whole_re ")";
            set $percent_re   $sign_re $real_re "\%";
            set $scinot_re    $sign_re "(?:" $real_re $exponent_re "|" $real_re ")";
            set $cents_re     "(?:" $decimal_separator "\d\d)";
            set $money_re     $sign_re $currency_sym "(?:" $whole_re $cents_re "|" $cents_re "|" $whole_re ")";
            set $number_re    "/^(?:" $real_re "|" $percent_re "|" $scinot_re "|" $money_re ")\Z/";
            eval $number prxparse($number_re);

            /* $test1 = "format:0_);[Red]\(0\) formula:=RC[-1]-50 formula:=RC[-1]-50   */
            /* +format:0_);[Red]\(0\) formula:=ABS(RC[-1]*10)";  */
            /* $test2 = "Formula:'Response Results'!j2"; */
        
            set $tagattr_regexp "/^(format:|formula:)/";
            eval $tagattr_regex prxparse($tagattr_regexp);
            
        end;

    define event sheet_interval;
        unset $tmp_interval;
        do /if value;
            set $tmp_interval value;
        else;
            set $tmp_interval tagset_alias;
        done;
        trigger set_sheet_interval /if $tmp_interval;
    end;

    define event set_sheet_interval;
        trigger worksheet finish /if $tmp_interval;
        set $tmp_interval lowcase($tmp_interval);

        /*-------------------------------------------------------eric-*/
        /*-- Table and bygroup are really synonymous.  The others   --*/
        /*-- do not currently work, because excel doesn't handle    --*/
        /*-- multiple tables per worksheet.  It might later so      --*/
        /*-- I'm leaving the code here.                             --*/
        /*----------------------------------------------------21Jul03-*/
        do /if $tmp_interval in ('table', 'bygroup');
        /*do /if $tmp_interval in ('table', 'page', 'proc', 'bygroup', 'none');*/
            set $sheet_interval $tmp_interval;
        else /if cmp($tmp_interval, "page");
            set $sheet_interval 'page';
        else /if cmp($tmp_interval, "proc");
            set $sheet_interval 'proc';
        else /if cmp($tmp_interval, "none");
            set $sheet_interval 'none';
        else; 
            set $sheet_interval 'table';
        done;
    end;

    /*-----------------------------------------------------------eric-*/
    /*-- Procs that we shouldn't create new worksheets for.         --*/
    /*--------------------------------------------------------19Aug03-*/
    define event proc_list;
        /* Init proc list */
        set $proclist['Gchart'] '1';
        set $proclist['Gplot'] '1';
        set $proclist['Gmap'] '1';
        set $proclist['Gcontour'] '1';
        set $proclist['G3d'] '1';
        set $proclist['Gbarline'] '1';
        set $proclist['Gareabar'] '1';
        set $proclist['Gradar'] '1';
        set $proclist['Gslide'] '1';
        set $proclist['Ganno'] '1';
    end;


    define event nls_numbers;

        unset $currency;
        unset $currency_format;
        unset $decimal_separator;
        unset $thousands_separator;
        unset $test_format;

        /*-------------------------------------------------------eric-*/
        /*-- The currency symbol for the US is $,  set it           --*/
        /*-- accordingly.  It is used for detection of currency     --*/
        /*-- formats and for removing those symbols so excel will   --*/
        /*-- like them.                                             --*/
        /*----------------------------------------------------14Jun04-*/
        set $currency $options['CURRENCY_SYMBOL'] /if $options;
        set $currency "$" /if ^$currency;
        set $currency_compress $currency ",";

        /*-------------------------------------------------------eric-*/
        /*-- Currency or Euro Currency.  The format to use for currency.--*/
        /*----------------------------------------------------14Jun04-*/
        set $currency_format $options['CURRENCY_FORMAT'] /if $options;
        set $currency_format "Currency" /if ^$currency_format;
        /*set $currency_format "Euro Currency" /if ^$currency_format;*/

        set $decimal_separator $options['DECIMAL_SEPARATOR'] /if $options;
        set $decimal_separator '\.' /if ^$decimal_separator;

        set $thousands_separator $options['THOUSANDS_SEPARATOR'] /if $options;
        set $thousands_separator ',' /if ^$thousands_separator;

        /*-------------------------------------------------------eric-*/
        /*-- The format to use for checking values.  If the value   --*/
        /*-- is missing after applying this format then it is not a --*/
        /*-- number.   Default is '12.'  NLNUM12. may be needed in  --*/
        /*-- other locals.                                          --*/
        /*----------------------------------------------------14Jun04-*/
        set $test_format $options['NUMERIC_TEST_FORMAT'] /if $options;
        set $test_format '12.' /if ^$test_format;
    end;

    define event bad_fonts;
        set $bad_fonts[] 'Times';
        set $bad_fonts[] 'Times Roman';
        set $bad_fonts[] 'Trebuchet MS';
    end;

    /*-----------------------------------------------------------eric-*/
    /*-- We need at least these styles.  If the style doesn't       --*/
    /*-- provide them we will create empty style definitions.       --*/
    /*--------------------------------------------------------14Jun04-*/
    define event needed_styles;
        set $missing_styles['Data']         'True';
        set $missing_styles['Header']       'True';
        set $missing_styles['Footer']       'True';
        set $missing_styles['RowHeader']    'True';
        set $missing_styles['Table']        'True';
        set $missing_styles['Batch']        'True';
        set $missing_styles['SystemFooter'] 'True';
        set $missing_styles['SystemTitle']  'True';
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

        /*-------------------------------------------------------eric-*/
        /*-- make the page do landscape setup.                      --*/
        /*----------------------------------------------------14Jun04-*/
        unset $landscape;
        set $landscape "True" /if cmp($options['ORIENTATION'], 'landscape');
        do /if ^$landscape;
            set $landscape "True" /if cmp(orientation, 'landscape');
        done;

        do /if $options['EMBEDDED_TITLES'];
            do /if cmp($options['EMBEDDED_TITLES'], "yes");
                set $embedded_titles "true" ;
            else;
                unset $embedded_titles;
            done;
        else;
            do /if cmp(embedded_titles, "yes");
                set $embedded_titles "true" ;
            else;
                unset $embedded_titles;
            done;
        done;

        do /if $options['FROZEN_HEADERS'];
            do /if cmp($options['FROZEN_HEADERS'], "yes");
                set $frozen_headers "true" ;
            else;
                unset $frozen_headers;
            done;
        else;
            do /if cmp(frozen_headers, "yes");
                set $frozen_headers "true" ;
            else;
                unset $frozen_headers;
            done;
        done;

        do /if $options['FROZEN_ROWHEADERS'];
            do /if cmp($options['FROZEN_ROWHEADERS'], "yes");
                set $frozen_rowheaders "true" ;
            else;
                unset $frozen_rowheaders;
            done;
        else;
            do /if cmp(frozen_rowheaders, "yes");
                set $frozen_rowheaders "true" ;
            else;
                unset $frozen_rowheaders;
            done;
        done;

        do /if $options['CONVERT_PERCENTAGES'];
            do /if cmp($options['CONVERT_PERCENTAGES'], "no");
                unset $convert_percentages;
            else;
                set $convert_percentages "true" ;
            done;
        else;
            do /if cmp(convert_percentages, "no");
                unset $convert_percentages;
            else;
                set $convert_percentages "true" ;
            done;
        done;

        do /if $options['AUTOFILTER'];
            do /if cmp($options['AUTOFILTER'], "none");
                unset $autofilter;
            else;
                set $autofilter $options['AUTOFILTER'] ;
            done;
        else;
            do /if cmp(autofilter, "none");
                unset $autofilter;
            else;
                set $autofilter autofilter ;
            done;
        done;

        eval $widthfudge 0.75;
        
        do /if $options['WIDTH_FUDGE'];
            do /if cmp($options['WIDTH_FUDGE'], "none");
                unset $widthFudge;
            else;
                set $widthFudge $options['WIDTH_FUDGE'];
                eval $widthFudge inputn($widthFudge, 'BEST'); ;
            done;
        else;
            do /if cmp(width_fudge, "none");
                unset $widthFudge;
            else /if width_fudge;
                eval $widthFudge inputn(width_Fudge, 'BEST'); ;
            done;
        done;
        
        unset $widthpoints;

        do /if $options['WIDTH_POINTS'];
            do /if cmp($options['WIDTH_POINTS'], "none");
                unset $widthPoints;
            else;
                set $widthPoints $options['WIDTH_POINTS'];
                eval $widthPoints inputn($widthPoints, 'BEST'); 
            done;
        else;
            do /if cmp(width_points, "none");
                unset $widthPoints;
            else /if width_points;
                eval $widthPoints inputn(width_points, 'BEST'); ;
            done;
        done;

        unset $default_widths;

        do /if $options['DEFAULT_COLUMN_WIDTH'];
            do /if cmp($options['DEFAULT_COLUMN_WIDTH'], "none");
                unset $default_widths;
            else;
                set $defwid $options['DEFAULT_COLUMN_WIDTH'];
                trigger set_default_widths;
            done;
        else;
            do /if cmp(default_column_width, "none");
                unset $default_widths;
            else /if default_column_width;
                set $defwid default_column_width;
                trigger set_default_widths;
            done;
        done;

        do /if $options['SHEET_INTERVAL'];
            set $tmp_interval lowcase($options['SHEET_INTERVAL']);
            trigger set_sheet_interval;
            /* this is so we can detect when it is set.        */
            /* each time it's set we should close the current */
            /* worksheet if one is open                       */
            unset $options['SHEET_INTERVAL'];
        done;
        
        do /if $options['SHEET_NAME'];
            set $sheet_name $options['SHEET_NAME'];
        else;
            unset $sheet_name;
        done;
        
        do /if $options['SHEET_LABEL'];
            set $sheet_label $options['SHEET_LABEL'];
        else;
            unset $sheet_label;
        done;
        
        unset $auto_sub_totals;
        do /if $options['AUTO_SUBTOTALS'];
            set $auto_sub_totals 'True' /if cmp($options['AUTO_SUBTOTALS'], 'yes');
        done;

        /*-------------------------------------------------------eric-*/
        /*-- autofilter table is 1 unless there are multiple tables --*/
        /*-- per worksheet.                                         --*/
        /*----------------------------------------------------23Dec04-*/
        eval $autofilter_table 1;
        do /if $sheet_interval ^in ('table', 'bygroup');
            do /if $options['AUTOFILTER_TABLE'];
                set $tmp $options['AUTOFILTER_TABLE'];
                eval $autofilter_table inputn($tmp, 'BEST');
            done;
        done;

        do /if $options['MINIMIZE_STYLE'];
            set $minimize_style 'True' /if cmp($options['MINIMIZE_STYLE'], 'yes');
        else;
            unset $minimize_style;
        done;
        
        
        trigger set_config_debug_options;
    end;
    
    define event set_default_widths;
        do /if index($defwid, ',');
            set $def_width scan($defwid, 1, ',');
            eval $count 1;
            do /while !cmp($def_width, ' ');
                set $default_widths[] strip($def_width);
                eval $count $count + 1;
                set $def_width scan($defwid, $count, ',');
            done;
        else;
            set $default_widths[] strip($defwid);
        done;
    end;
    /*-----------------------------------------------------------eric-*/
    /*-- This one happens when options(...) are given on the ods markup--*/
    /*-- statement.  It only happens after the first statement though.--*/
    /*--------------------------------------------------------14Jun04-*/
    define event options_set;
        trigger set_options;
    end;

    define event set_options;
        trigger nls_numbers;
        trigger compile_regexp;
        trigger options_setup;
        trigger documentation;
    end;


    define event initialize;

        trigger set_options;

        trigger bad_fonts;

        trigger needed_styles;

        set $align getoption('center');
        set $sheet_names['#$%!^&&&&'] 'junk';

        trigger proc_list;

        set $weight["1px"] '0';
        set $weight["2px"] '1';
        set $weight["3px"] '2';
        set $weight["4px"] '3';
        set $font_size["xx-small"] "8";
        set $font_size["x-small"]  "12";
        set $font_size["medium"]   "14";
        set $font_size["large"]    "16";
        set $font_size["x-large"]  "18";
        set $font_size["xx-large"] "20";

        eval $numberOfWorksheets 0;
        eval $format_override_count 0;

        /*------------------------------------------------------------------eric--*/
        /* if we were given an alias try to set the sheet interval with it.       */
        /* it should be none, proc, bygroup, page, or table.  The default is page */
        /*----------------------------------------------------------------4Jul 03-*/
        set $tmp_interval tagset_alias;
        trigger set_sheet_interval;

    end;

   
    define event doc;
        start:
            eval $numberOfWorksheets 0;

            put '<?xml version="1.0"';
            putq " encoding=" encoding;
            put "?>" CR CR;
            putl '<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"';
            putl '          xmlns:x="urn:schemas-microsoft-com:office:excel"';
            putl '          xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"';
            putl '          xmlns:html="http://www.w3.org/TR/REC-html40">';
            putl '<DocumentProperties xmlns="urn:schemas-microsoft-com:office">';
            do /if operator;
                putl '<Author>' operator '</Author>';
                putl '<LastAuthor>' operator '</LastAuthor>';
            done;
            putl '<Created>' date 'T' time '</Created>';
            putl '<LastSaved>' date 'T' time '</LastSaved>';
            putl '<Company>SAS Institute Inc. http://www.sas.com</Company>';
            putl '<Version>' saslongversion '</Version>';
            putl '</DocumentProperties>';
        finish:
            putl '</Workbook>';
    end;

    define event embedded_stylesheet;
        start:
            unset $currency_styles;
            unset $percentage_styles;
            unset $style_list;
            eval $format_override_count 0;
            open style;
            put "<Styles>" nl;
            trigger alignstyle;
        finish:
            close;
    end;

    define event doc_body;
        start:
            open worksheet;
        finish:
            /* close the worksheet if it's open.  We're shutting down */
            trigger worksheet;

            close;

            /*---------------------------------------------------eric-*/
            /*-- Write the end of the styles section.  We have to   --*/
            /*-- wait until now in case there were style ver-rides --*/
            /*-- written during worksheet creation.                 --*/
            /*------------------------------------------------4Jul 03-*/
            open style;
            putl '</Styles>' nl;
            close;

            /* write out the style definitions and delete the stream */
            put $$style;
            delstream style;

            /* write out the worksheets and delete the stream */
            put $$master_worksheet;
            delstream master_worksheet;
    end;

    define event shortstyles;
        flush;
        open style;
        iterate $missing_styles;
        do /while _name_;
            set $cell_class _name_;
            trigger empty_style;
            next $missing_styles;
        done;
        close;
        unset $cell_class;
    end;

    define event empty_style;
            put '<Style ss:ID="' $cell_class '"/>' NL;
    end;

    define event style_class;
        /*-------------------------------------------------------eric-*/
        /*-- trim down the number of styles we define...            --*/
        /*-- 3Jul 03                                                --*/
        /*-- If you see an error about styleID value not            --*/
        /*-- being right, add the name in question here.            --*/
        /*-- Or set the minimize_style option to no.                --*/
        /*----------------------------------------------------21Dec04-*/
        do /if $minimize_style;
            unset $doit;
            set $doit "true" /if cmp(htmlclass, "SystemTitle");
            set $doit "true" /if cmp(htmlclass, "SystemFooter");
            set $doit "true" /if cmp(htmlclass, "NoteContent");
            set $doit "true" /if cmp(htmlclass, "byline");
            set $doit "true" /if contains(htmlclass, "able");   /* Table  */
            set $doit "true" /if contains(htmlclass, "atch");   /* Batch  */
            set $doit "true" /if contains(htmlclass, "ata");    /* Data   */
            set $doit "true" /if contains(htmlclass, "eader");  /* Header */
            set $doit "true" /if contains(htmlclass, "ooter");  /* Footer */
            break /if ^$doit;
        done;

        unset $missing_styles[htmlclass];

        putq '<Style ss:ID=' HTMLCLASS '>' NL;
        /*trigger tagattr_settings; */ /* seemingly good idea. Not */
        set $format_override $attrs['format'];
        trigger xl_style_elements;
        open style;
        put $$style_elements;
        unset $$style_elements;
        /* trigger cell_format; *//* seemingly good idea. Not */
        putl '</Style>';
    end;

    define event xl_style_elements;
        delstream style_elements;
        open style_elements;

        put '<Alignment';

        set $headerString lowcase(htmlclass);
        set $headerStringIndex index($headerString, 'header');
        put ' ss:WrapText="1"' /if cmp($headerStringIndex, "1");
        unset $headerString;
        unset $headerStringIndex;
        
        do /if cmp(htmlclass, "SystemTitle") or cmp(htmlclass, "SystemFooter");
            do /if cmp($align, "center");
                put ' ss:Horizontal="Center"';
            done;
        done;

        putl '/>';

        putl '<ss:Borders>';


        put  '<ss:Border ss:Position="Left"';
        putq ' ss:Color=' BORDERCOLOR;
        do /if borderwidth;
            /* translate px to number +1 */
            putq ' ss:Weight=' $weight[BORDERWIDTH];
            put  ' ss:LineStyle="Continuous"';
        done;
        putl ' />';


        put  '<ss:Border ss:Position="Top"';
        putq ' ss:Color=' BORDERCOLOR;
        do /if borderwidth;
            /* translate px to number +1 */
            putq ' ss:Weight=' $weight[BORDERWIDTH];
            put  ' ss:LineStyle="Continuous"';
        done;
        putl ' />';


        put  '<ss:Border ss:Position="Right"';
        putq ' ss:Color=' BORDERCOLOR;
        do /if borderwidth;
            /* translate px to number +1 */
            putq ' ss:Weight=' $weight[BORDERWIDTH];
            put  ' ss:LineStyle="Continuous"';
        done;
        putl ' />';


        put  '<ss:Border ss:Position="Bottom"';
        putq ' ss:Color=' BORDERCOLOR;
        do /if borderwidth;
            /* translate px to number +1 */
            putq ' ss:Weight=' $weight[BORDERWIDTH];
            put  ' ss:LineStyle="Continuous"';
        done;
        putl ' />';


        putl '</ss:Borders>';

        trigger font_interior;

        put '<Protection';
        put  ' ss:Protected="1"';
        put  ' />' NL;

        flush;
        close;
    end;

    define event cell_format;
        /*------------------------------------------------------------eric-*/
        /*-- General is the default and it's the best we can do for now. --*/
        /*---------------------------------------------------------4Jul 03-*/
        put '<NumberFormat';
        putq ' ss:Format=' $format_override;
        putq ' ss:Format=' $format /if ^$format_override;
        put  ' />' NL;
    end;


    define event font_interior;

        do /if any(font_face, font_size, font_weight, foreground);
            put '<Font';
            do /if font_face;
                set $fontFace font_face;
                /*---------------------------------------------------eric-*/
                /*-- for some reason excel doesn't like this font       --*/
                /*-- specification. getting rid of sans-serif makes     --*/
                /*-- it happy.                                          --*/
                /*--                                                    --*/
                /*-- Courier New, Courier, sans-serif                   --*/
                /*------------------------------------------------28Jul03-*/
                do /if contains(font_face, "Courier");
                    set $fontFace tranwrd($fontFace, 'sans-serif, ', '');
                    set $fontFace tranwrd($fontFace, ', sans-serif', '');
                    set $fontFace tranwrd($fontFace, 'sans-serif', '');
                done;
                /* Excel does not like "SAS Monospace" */
                set $fontFace tranwrd($fontFace, 'SAS Monospace, ', '');
                set $fontFace tranwrd($fontFace, 'SAS Monospace', '');

                /* get rid of quotes and replace ' ,' with ',' */
                set $fontFace tranwrd($fontFace, "'", '');
                set $fontFace tranwrd($fontFace, " ,", ',');


                /*-----------------------------------------------eric-*/
                /*-- Get rid of fonts that excel and windows don't  --*/
                /*-- like.  See the bad_fonts event...              --*/
                /*--------------------------------------------9Jun 04-*/
                set $fontname scan($fontFace, 1, ',');
                eval $count 1;
                unset $tmp_fontFace;

                do /while !cmp($fontname, ' ');

                    /* look for fonts that will make excel croak */
                    iterate $bad_fonts;
                    do /while _value_;
                        set $fontname strip($fontname);
                        do /if cmp($fontname, _value_);
                            unset $fontname /if cmp($fontname, _value_);
                            stop;
                        done;

                        next $bad_fonts;
                    done;

                    /* put the font list back together */
                    do /if $fontname;
                        set $tmp_fontFace $tmp_fontFace ", " /if $tmp_fontFace;
                        set $tmp_fontFace $tmp_fontFace $fontname;
                        unset $fontname;
                    done;

                    eval $count $count + 1;
                    set $fontname scan($fontFace, $count, ',');
                    set $fontname strip($fontname);
                done;

                set $fontFace $tmp_fontFace;

                /*---------------------------------------------------eric-*/
                /*-- Excel can't handle more than 3 fonts in it's font  --*/
                /*-- list.  This loop cuts off the last one.            --*/
                /*------------------------------------------------29Jul03-*/
                eval $comma index($fontFace, ",");
                eval $comma_index $comma ;
                eval $comma_count 0;
                set $tmp_fontFace $fontFace;
                do /while $comma > 0;
                    eval $comma $comma+1;
                    eval $comma_count $comma_count + 1;
                    do /if $comma_count = 3;
                        eval $comma_index $comma_index -1;
                        set $fontFace substr($fontFace, 1, $comma_index);
                        stop;
                    done;
                    set $tmp_fontFace substr($tmp_fontFace, $comma);
                    eval $comma index($tmp_fontFace, ",");
                    eval $comma_index $comma_index + $comma ;
                done;

                putq ' ss:FontName=' strip($fontFace);
                unset $fontFace;
            done;


            /* find out if the font size is in points */
            eval $pt_pos index(FONT_SIZE, "pt") - 1;
            do /if $pt_pos > 0;
               /* if it is a point size take off the unit */
               set $size substr(font_size, 1, $pt_pos);
               putq  ' ss:Size=' $size;
            else;
               /* translate small, medium, large into numbers. */
               set  $size $font_size[FONT_SIZE];
               putq  ' ss:Size=' $font_size[FONT_SIZE];
            done;
           
            /*---------------------------------------------------eric-*/
            /*-- Save away the point size for the data to be used   --*/
            /*-- when the column widths are calculated.             --*/
            /*------------------------------------------------5Oct 04-*/
            do /if cmp(htmlclass, 'data');
                stop /if $data_point_size;
                set $data_point_size $size;
            done;

            do /if cmp(htmlclass, 'header');
                stop /if $header_point_size;
                set $header_point_size $size;
            done;

            put  ' ss:Italic="1"' / if cmp(FONT_STYLE, 'italic');
            put  ' ss:Bold="1"' / if cmp(FONT_WEIGHT, 'bold');
            putq ' ss:Color=' FOREGROUND /if ^cmp(foreground, 'transparent');
            put  ' />' NL;
        done;

        do /if background;
            put '<Interior';
            do /if ^cmp(background, 'transparent');
                putq ' ss:Color=' BACKGROUND;
                put  ' ss:Pattern="Solid"' / if exist(BACKGROUND);
            done;
            put  ' />' NL;
        done;
    end;


    define event output;
        start:
            trigger worksheet /if cmp($sheet_interval, "table");
            trigger worksheet /if cmp($sheet_interval, "proc");
        finish:
            trigger worksheet /if cmp($sheet_interval, "table");
            /* for proc freq.... */
            trigger worksheet /if cmp($sheet_interval, "bygroup");
    end;


    define event proc;
        start:
            /* in case embedded_titles or convert_percents has changed. */
            trigger options_setup;
            set $align getoption('center');
            set $proc_name name;
            /*-----------------------------------------------------eric-*/
            /*-- We don't really want to start a worksheet here       --*/
            /*-- because the titles haven't come out yet.  So we'll   --*/
            /*-- just be sure to turn off the worksheet when the proc --*/
            /*-- ends.                                                --*/
            /*--------------------------------------------------3Jul 03-*/
        finish:
            trigger worksheet /if cmp($sheet_interval, "proc");
    end;


    /*-----------------------------------------------------------eric-*/
    /*-- Redefine this event if you want to change the way          --*/
    /*-- worksheets get labeled.                                    --*/
    /*--------------------------------------------------------4Jul 03-*/
    define event worksheet_label;

        do /if label;
            set $label label;
        else;
            set $label proc_name;
        done;

        /*---------------------------------------------------eric-*/
        /*-- Try to create a reasonable worksheet label based   --*/
        /*-- on the type of sheet interval we are using.        --*/
        /*------------------------------------------------4Jul 03-*/
        do /if $sheet_name;
            do /if $sheet_names[$sheet_name];
                eval $name_count $sheet_names[$sheet_name] + 0;
                eval $name_count $name_count + 1;
                eval $sheet_names[$sheet_name] $name_count;
            else;
                eval $sheet_names[$sheet_name] 1;
            done;
            set $worksheetName $sheet_name ' ' $name_count;
        else;
            set $worksheetName $sheet_label ' ';
            do /if cmp($sheet_interval, 'none');
                set $worksheetName 'Job ' /if ^$sheet_label;
                set $worksheetName $worksheetName $numberOfWorksheets ' - ' $label;

            else /if cmp($sheet_interval, 'proc');
                set $worksheetName 'Proc ' /if ^$sheet_label;
                set $worksheetName $worksheetName total_Proc_count ' - ' $label;

            else /if cmp($sheet_interval, 'page');
                set $worksheetName 'Page ' /if ^$sheet_label;
                set $worksheetName $worksheetName total_page_count ' - ' $label;

            else /if cmp($sheet_interval, 'bygroup');
                set $worksheetName 'By ' /if ^$sheet_label; 
                set $worksheetName $worksheetName $numberOfWorksheets ' ' $byGroupLabel ' - ' $label;

            else /if cmp($sheet_interval, 'table');
                set $worksheetName 'Table ' /if ^$sheet_label; 
                set $worksheetName $worksheetName $numberOfWorksheets ' - ' $label;
            done;
        done;

        /*-------------------------------------------------------eric-*/
        /*-- If we have a bygroup label then we should use it.      --*/
        /*----------------------------------------------------21Jul03-*/
        /*
        do /if $byGroupLabel;
            set $worksheetName 'By ' $numberOfWorksheets ' ' $byGroupLabel ' - ' $label;
        done;
        */

        unset $byGroupLabel;
        unset $label;

    end;


    /*-----------------------------------------------------------eric-*/
    /*-- make sure the worksheet label doesn't have any invalid     --*/
    /*-- characters and that it is not too long.  The length can    --*/
    /*-- be no longer than 31.                                      --*/
    /*--------------------------------------------------------4Jul 03-*/
    define event clean_worksheet_label;

        /*set $worksheetName compress($worksheetName, "/\?*:'"); */
        set $worksheetName tranwrd($worksheetName, '/', ' ');
        set $worksheetName tranwrd($worksheetName, '\', ' ');
        set $worksheetName tranwrd($worksheetName, '?', ' ');
        set $worksheetName tranwrd($worksheetName, '*', ' ');
        set $worksheetName tranwrd($worksheetName, ':', ' ');
        set $worksheetName tranwrd($worksheetName, "'", ' ');

        eval $worksheetNameLength length($worksheetName);
        do /if $worksheetNameLength > 31;
            set $worksheetName substr($worksheetName, 1, 31);
        done;
    end;


    define event worksheet;
        start:
            
            do /if $proclist[proc_name];
                putlog "Excel XML does not support output from Proc:" proc_name;
                putlog "Output will not be created.";
                break;
            done;

            break /if $worksheet_started;
            
            unset $worksheet_widths;
            unset $worksheet_has_panes;
            unset $worksheet_has_autofilter;
            eval $worksheet_row 0;

            eval $numberOfWorksheets $numberOfWorksheets + 1;

            trigger worksheet_label;
            trigger clean_worksheet_label;

            unset $$worksheet_start;
            open worksheet_start;
            putq '<Worksheet ss:Name=' $worksheetName '>' NL;

            unset $tempWorksheetName;
            unset $worksheetName;
            /*-----------------------------------------------------eric-*/
            /*-- write out the system titles and footers.             --*/
            /*--------------------------------------------------2Jul 03-*/
            put '<x:WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">' NL;
            
            put "<x:PageSetup>" nl;

            put $$page_setup /if !$embedded_titles;;

            do /if $landscape;
                put '<Layout x:Orientation="Landscape" x:StartPageNumber="2"/>' NL;
                put '<PageMargins x:Right="0.5" x:Top="0.75"/>' NL;
            done;

            put "</x:PageSetup>" nl;
            
            close;
            open worksheet;


            set $worksheet_started "True";

        finish:
            break /if $proclist[proc_name];

            break /if ^$worksheet_started;
            unset $worksheet_started;

            open master_worksheet;
            /*-------------------------------------------------------eric-*/
            /*-- This wacky.  We keep each worksheet is a smaller       --*/
            /*-- stream.  We also keep the top of the worksheet in      --*/
            /*-- another stream.  All so we can count the titles and    --*/
            /*-- the header rows and use the count in                   --*/
            /*-- worksheet_head_end to create a non-scrolling region.   --*/
            /*-- When we get to the body section we can put the parts   --*/
            /*-- together.  At the end of the table the entire          --*/
            /*-- worksheet get's written to the master worksheet.       --*/
            /*-- The master worksheet get's put together with the style --*/
            /*-- worksheet at the end of the doc_body to create a       --*/
            /*-- complete file.                                         --*/
            /*----------------------------------------------------4Aug 04-*/
            put $$worksheet_start;
            unset $$worksheet_start;

            trigger worksheet_head_end;
            trigger table_start;
            put $$worksheet;

            putl '</Table>';
            eval $table_count 0;
            unset $$worksheet;
            putl '</Worksheet>';
    end;
    
    define event table_start;
        break /if ^$regular_table;
        unset $regular_table; 
        put  '<Table';
        putq ' ss:StyleID=' $table_class;
        putl '>';
        /*-------------------------------------------------------eric-*/
        /*-- Write out the colspecs for the entire worksheet.       --*/
        /*----------------------------------------------------17Dec04-*/
        iterate $worksheet_widths;
        do /while _value_;
            put '<ss:Column ss:AutoFitWidth="1"';
            eval $numeric_width inputn(_value_, 'BEST');
            putq ' ss:Width=' _value_ /if $numeric_width > 0;
            put '/>' nl;
            next $worksheet_widths;
        done;
    end;


    /*
   <Selected/>
   <FreezePanes/>
   <FrozenNoSplit/>
   <SplitHorizontal>1</SplitHorizontal>
   <TopRowBottomPane>1</TopRowBottomPane>
   <SplitVertical>1</SplitVertical>
   <LeftColumnRightPane>1</LeftColumnRightPane>
   <ActivePane>0</ActivePane>
   <Panes>
    <Pane>
     <Number>3</Number>
    </Pane>
    <Pane>
     <Number>1</Number>
    </Pane>
    <Pane>
     <Number>2</Number>
    </Pane>
    <Pane>
     <Number>0</Number>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
    */

    define event worksheet_head_end;

        do /if any($frozen_headers, $frozen_rowheaders);
            stop /if $worksheet_has_panes;
            put '<Selected/>' nl;
            put '<FreezePanes/>' nl;
            put '<FrozenNoSplit/>' nl;
            set $worksheet_has_panes "true";
            do /if $embedded_titles;
                do /if $titles;
                    eval $row_count $row_count + $titles + 1;
                    eval $worksheet_row $worksheet_row + $titles + 1;
                done;
            done;

            unset $panes;
            eval $pane_count 0;
            do /if $frozen_headers;
                do /if $row_count > 0;
                    put '<SplitHorizontal>' $row_count '</SplitHorizontal>' nl;
                    put '<TopRowBottomPane>' $row_count '</TopRowBottomPane>' nl;
                    eval $pane_count $pane_count + 2;
                    set $panes['3'] '3';
                    set $panes['2'] '2';
                    set $active_pane '2';
                done;
            done;

            do /if $frozen_rowheaders;
                do /if $best_rowheader_count > 0;
                    put '<SplitVertical>' $best_rowheader_count '</SplitVertical>' nl;
                    put '<LeftColumnRightPane>' $best_rowheader_count '</LeftColumnRightPane>' nl;
                    eval $pane_count $pane_count + 2;
                    do /if $panes['3'];
                        set $panes['0'] '0';
                        set $active_pane '0';
                    else;
                        set $panes['3'] '3';
                        set $active_pane '1';
                    done;
                    set $panes['1'] '1';
                done;
            done;
            do /if $panes;
                put '<ActivePane>' $active_pane '</ActivePane>' nl;
                put '<Panes>' nl;
                putvars $panes '<Pane>' nl '<Number>' _name_ '</Number>' nl '</Pane>' nl;
                put '</Panes>' nl;
            done;
            put '<ProtectObjects>False</ProtectObjects>' nl;
            put '<ProtectScenarios>False</ProtectScenarios>' nl;
        done;

        put '</x:WorksheetOptions>' nl;
        
        do /if $autofilter;
            stop /if $worksheet_has_autofilter;
            set $worksheet_has_autofilter "True";
            putq '<AutoFilter';
            put  ' x:Range="';
            eval $last $last_autofilter_col+1;
            do /if cmp($autofilter, 'all');
                /*-----------------------------------------------eric-*/
                /*-- I don't remember why, but colcount is always 1 less than--*/
                /*-- the actual number of columns. - it's decremented in--*/
                /*-- colspecs finish.                               --*/
                /*--------------------------------------------6Oct 04-*/
                put 'R' $autofilter_row 'C1:R' $last_autofilter_row 'C' $last ;

            else /if index($autofilter, '-');
                eval $tmp_col inputn(scan($autofilter, 1, '-'), 'BEST');
                set $tmp_col $last /if $tmp_col > $last;
                put 'R' $autofilter_row 'C' $tmp_col ;
                /*put 'R1C' $tmp_col;*/

                eval $tmp_col inputn(scan($autofilter, 2, '-'), 'BEST');
                set $tmp_col $last /if $tmp_col > $last;
                put ':R' $last_autofilter_row 'C' $tmp_col ;
                /*put ':R2C' $tmp_col;*/

            else;
                eval $tmp_col inputn($autofilter, 'BEST');       
                set $tmp_col $last /if $tmp_col > $last;
                put 'R' $autofilter_row 'C' $tmp_col ;
                put ':R' $last_autofilter_row 'C' $tmp_col ;
                /*put 'R1C' $tmp_col;
                  put ':R2C' $tmp_col; */
            done;
            put  '" xmlns="urn:schemas-microsoft-com:office:excel">';
            putq '</AutoFilter>';
        done;
        unset $autofilter_row;
        unset $last_autofilter_row;
    end;

    define event byline;
        set $byGroupLabel VALUE;
        set $byline value;
        set $byline_style htmlclass;
        trigger worksheet finish /if cmp($sheet_interval, "bygroup");
        trigger worksheet /if cmp($sheet_interval, "bygroup");
    end;

    define event verbatim;
        start:
            /*-----------------------------------------------------eric-*/
            /*-- There are various reasons we may not have a          --*/
            /*-- worksheet currently open.  So just make sure         --*/
            /*-- we have one.                                         --*/
            /*--------------------------------------------------2Jul 03-*/
            eval $colcount 0;
            trigger worksheet;

            put  '<Table';
            putq ' ss:StyleID=' HTMLCLASS;
            putl '>';
            put '<ss:Column ss:AutoFitWidth="1"/>' nl;
        finish:
            trigger embedded_footnotes;
            putl '</Table>';
            unset $batch_one;
            trigger worksheet finish /if cmp($sheet_interval, "table");
            trigger worksheet finish /if cmp($sheet_interval, "bygroup");
    end;

    define event verbatim_text;

        /*-------------------------------------------------------eric-*/
        /*-- toggle the stream if we are in a head section.         --*/
        /*-- for proc report and tabulate.                          --*/
        /*----------------------------------------------------19Aug03-*/
        trigger worksheet_or_head;

        put  '<Row ss:StyleID="Batch"><Cell ss:StyleID="Batch">';
        putq  '<Data ss:Type="String"';
        put '>';

        /*-----------------------------------------------eric-*/
        /*-- put on a dot to preserve leading spaces.       --*/
        /*-- Excel doesn't like leading and trailing space. --*/
        /*--------------------------------------------28Jul03-*/
        set $value "." value;
        set $value strip($value);

        put $value;

        unset $value;

        putl '</Data></Cell></Row>';

        open worksheet;
    end;

    define event table;
        start:
            /*-----------------------------------------------------eric-*/
            /*-- There are various reasons we may not have a          --*/
            /*-- worksheet currently open.  So just make sure         --*/
            /*-- we have one.                                         --*/
            /*--------------------------------------------------2Jul 03-*/
            unset $auto_sub_totals_done;
            eval $colcount 0;
            eval $row_count 0;
            eval $rowheader_count 0;
            eval $best_rowheader_count 0;
            eval $first_data_column 0;
            trigger worksheet;
            do /if ^$table_count;
                eval $table_count 1;
            else;
                eval $table_count $table_count + 1;
            done;

            do /if $worksheet_row > 0;
                /*-----------------------------------------------eric-*/
                /*-- this may look wrong.   But worksheet row get's --*/
                /*-- incremented at the beginning of the row.  It   --*/
                /*-- really is +2 but +1 here and +1 there.  which  --*/
                /*-- turns out to be the same as table_index here.  --*/
                /*--------------------------------------------23Dec04-*/
                eval $worksheet_row $worksheet_row + 1;

                /* Table index is where the next table will start. */
                eval $table_index $worksheet_row ;

            else /if $sheet_interval ^in ('table', 'bygroup');
                do /if $byline;
                    eval $table_index 1;
                    eval $worksheet_row 1;
                done;
            done;

            set $regular_table "True";
            set $table_class HTMLCLASS;
            set $is_a_table_head "true";
        finish:
            do /if $table_count = $autofilter_table;
                do /if ^$last_autofilter_row;
                    eval $last_autofilter_row $worksheet_row;
                    eval $last_autofilter_col $colcount;
                done;
            done;
            trigger embedded_footnotes;
            trigger worksheet finish /if cmp($sheet_interval, "table");
            trigger worksheet finish /if cmp($sheet_interval, "bygroup");
    end;

    define event row;
        start:
            /*-------------------------------------------------------eric-*/
            /*-- toggle the stream if we are in a head section.         --*/
            /*-- for proc report and tabulate.                          --*/
            /*----------------------------------------------------19Aug03-*/
            trigger worksheet_or_head;
            
            do /if exists($table_index, $byline);
                set $span_cell_index $table_index;
                set $span_cell_style $byline_style;
                trigger span_cell start;
                put $byline;
                trigger span_cell finish;
                eval $table_index $table_index + 1;
                eval $worksheet_row $worksheet_row + 1;
                unset $span_cell_index;
                unset $byline;
            done;
            
            put  '<Row';
            putq ' ss:Index=' $table_index;
            putq ' ss:StyleID=' HTMLCLASS;
            putl '>';
            unset $table_index;
            
            eval $worksheet_row $worksheet_row + 1;

            do /if cmp(section, 'head');
                eval $row_count $row_count+1;

            else /if cmp(section, 'body');
                eval $data_row_count $data_row_count+1;
            done;

            do /if cmp(section, 'body');
                do /if $rowheader_count > $best_rowheader_count;
                    eval $best_rowheader_count $rowheader_count;
                done;
                eval $rowheader_count 0;
            done;

            open worksheet;

      finish:
            /*-------------------------------------------------------eric-*/
            /*-- toggle the stream if we are in a head section.         --*/
            /*-- for proc report and tabulate.                          --*/
            /*----------------------------------------------------19Aug03-*/
            trigger worksheet_or_head;

            putl '</Row>';
            set $auto_sub_totals_done "True" /if ($auto_sub_totals_done, "Almost");

            open worksheet;
    end;

    define event colspec_entry;
        start:
            open worksheet;
            /*---------------------------------------------------------eric-*/
            /*-- This should be there.  But excel has a bug, that causes  --*/
            /*-- autofit to not work if width is specified.  Autofit      --*/
            /*-- doesn't work so well anyway... This is the best we can   --*/
            /*-- do.                                                      --*/
            /*------------------------------------------------------3Jul 03-*/
            set $colwidth strip(colwidth);
            /*putlog "Colwidth" ": " colwidth " Points" ":" $widthpoints " fudge" ":" $widthfudge;
            putlog "datapointsize" ": " $data_point_size ;
            putlog "headerpointsize" ": " $header_point_size ;
            */
            /*--------------------------------------------------------Vince-*/                
            /*-- Compute a default value of header_len based on the      --*/ 
            /*-- column name.  This will be used in the event that there --*/
            /*-- is no label on the column and if LABEL is not specified --*/
            /*-- with PROC PRINT.                                        --*/
            /*------------------------------------------------------22Dec04-*/                
                                                                                  
            do /if exists(name);                                                  
              eval $header_len length(name);                                      
            else;                                                                 
              eval $header_len 0;                                                 
            done;          
            
    finish:
        
            do /if $colwidth;
                eval $number_of_chars inputn($colwidth, 'BEST');
                do /if missing($number_of_chars);
                    eval $number_of_chars 0+0; 
                done;
            else;
                eval $number_of_chars 0+0;
            done;
            
            /*-------------------------------------------------------eric-*/
            /*-- If no column width get the corresponding default width --*/
            /*-- if we have any.                                        --*/
            /*----------------------------------------------------13Oct04-*/
            
         
            do /if $number_of_chars = 0;
            
                stop /if ^$default_widths;

                eval $index $default_widths;

                do /if $index > 1;
                    eval $tmp_colcount $colcount+1;
                    eval $index $default_widths;

                    do /if $index > $tmp_colcount;
                        eval $index $tmp_colcount;

                    else /if $tmp_colcount > $index;
                        do /while $tmp_colcount > $index;
                            eval  $tmp_colcount $tmp_colcount - $default_widths;
                        done;
                        eval $index $tmp_colcount;
                    done;
                done;

                set $defwid $default_widths[$index];
                eval $number_of_chars inputn($defwid, 'BEST');
            done;
                    
            do /if $widthPoints;
                eval $points $widthPoints;
            else;
                eval $points max(inputn($header_point_size, '3.'), inputn($data_point_size, '3.'));
            done;

            do /if $number_of_chars < $header_len;
                eval $difference $header_len - $number_of_chars;

                /* putlog "colspec_entry event: number_of_chars=" $number_of_chars " header_len=" $header_len " difference=" $difference; */
                do /if $difference = 1;
                    eval $number_of_chars $header_len + 1;
                else; 
                    eval $number_of_chars $header_len + 0; 
                done;
                unset $difference;
            done;

            /* putlog "colspec_entry event: Final number_of_chars=" $number_of_chars; */

            do /if exists($number_of_chars, $Points, $widthfudge);
                
                eval $width $Points * $number_Of_Chars * $widthfudge;
                
                /*
                putlog "Colwidth" ": " $colwidth " HeaderLen" ": " $header_len;
                putlog "Points" ":" $points " fudge" ":" $widthfudge;
                putlog "datapointsize" ": " $data_point_size ;
                putlog "headerpointsize" ": " $header_point_size ;
                putlog "Width" ": " $width ;
                */
                
                set $table_widths[] $width;

            done;

            eval $colcount $colcount+1;
    end;
        

    define event sub_colspec_header;
        eval $header_len 0;
        do /if value;
          eval $header_len length(value);
          /*------------------------------------------------------Vince-*/
          /*-- Recalculate the header length if it contains a split   --*/
          /*-- character.                                             --*/
          /*----------------------------------------------------20Dec04-*/
          eval $headerStringIndex index(value, '&#10;');
          do /if $headerStringIndex > 0;
            eval $headerStringIndex 1;
            eval $header_len 0;
            set $headerFragment scan(value, $headerStringIndex, '&#10;');
            do /while ^cmp($headerFragment, ' ');
              eval $header_len max($header_len, length($headerFragment));
              eval $headerStringIndex $headerStringIndex+1;
              eval $headerFragment scan(value, $headerStringIndex, '&#10;');
            done;
          done;
          unset $headerStringIndex;
          unset $headerFragment;
        done;
        /* putlog " "; */
        /* putlog "sub_colspec_header event: value=" value " label=" label " header_len=" $header_len; */
    end;

    define event MergeAcross;
        eval $mergeAcross inputn(COLSPAN, "3.")-1;
        putq ' ss:MergeAcross=' $mergeAcross;
        unset $mergeAcross;
    end;

    define event MergeDown;
        eval $mergeDown   inputn(ROWSPAN, "3.")-1;
        putq ' ss:MergeDown=' $mergeDown;
        unset $mergeDown;
    end;

    define event cell_start;
        start:
            /*---------------------------------------------------eric-*/
            /*-- If there are over-rides write the style            --*/
            /*-- attributes to a stream for safe keeping.           --*/
            /*------------------------------------------------19Aug03-*/
            do /if any(font_face, font_size, font_style,
                font_weight, foreground, background,
                borderwidth, bordercolor);

                /*-----------------------------------------------eric-*/
                /*-- This event redirects to it's own stream,       --*/
                /*-- ye be warned...                                --*/
                /*--------------------------------------------19Aug03-*/
                trigger xl_style_elements;
                set $style_over_ride "true";
            else;
                unset $style_over_ride;
            done;


            /*---------------------------------------------------eric-*/
            /*-- Mostly for aesthetics.  stream switching causes    --*/
            /*-- unsightly line breaks.  Save the cell tag away     --*/
            /*-- until we can print it all at once.                 --*/
            /*------------------------------------------------19Aug03-*/
            open cell_start;
            trigger MergeAcross / if COLSPAN;
            trigger MergeDown  / if ROWSPAN;
            putq ' ss:Index=' COLSTART;
            close;

            set $format_override $attrs['format'] /if $attrs;

            /*-------------------------------------------------------eric-*/
            /*-- toggle the stream if we are in a head section.         --*/
            /*-- for proc report and tabulate.                          --*/
            /*----------------------------------------------------19Aug03-*/
            trigger worksheet_or_head;

            set $cell_class htmlclass;


        finish:

            break /if ^$$cell_start;

            /*-------------------------------------------------------eric-*/
            /*-- toggle the stream if we are in a head section.         --*/
            /*-- for proc report and tabulate.                          --*/
            /*----------------------------------------------------19Aug03-*/
            trigger worksheet_or_head;

            put '<Cell';
            putq ' ss:StyleID=' $cell_class;
            unset $formula;
            set $formula $attrs['formula'] /if $attrs;
            do /if $formula;
                putq ' ss:Formula=' $formula;
            else;
                stop /if ^$auto_sub_totals;
                stop /if cmp($auto_sub_totals_done, 'True');
                stop /if ^cmp($proc_name, 'print');
                stop /if cmp(section, 'head');
                stop /if ^colstart;
                stop /if $first_data_column > inputn(colstart, 'BEST');
                stop /if ^cmp(event_name, 'header'); /* & ^cmp(name, 'Obs');*/
                set $tmp_value strip(value);
                stop /if $data_row_count < 2 & $first_data_column = 0;
                do /if $tmp_value;
                    /*
                    put nl "ADDING SUBTOTAL: value is  " "|" $tmp_value "|" nl;
                    put "               : section   " "|" section "|" nl;
                    put "               : event_name" "|" event_name "|" nl;
                    put "               : proc_name " "|" $proc_name "|" nl;
                    put "               : colstart  " "|" colstart "|" nl;
                    put "               : first D C " "|" $first_data_column "|" nl;
                    put "               : Data Row  " "|" $data_row_count "|" nl;
                    */
                    eval $tmp_count $data_row_count -1;
                    put ' ss:Formula=';
                    put '"=SUBTOTAL(9,R[-' $tmp_count ']C:R[-1]C)"';
                    unset $tmp_count;
                    set $auto_sub_totals_done "Almost";
                done;    
                unset $tmp_value;
            done;
            put $$cell_start;
            put  '>';
            unset $$cell_start;

            close;
    end;


    /*-----------------------------------------------------------eric-*/
    /*-- Write out a style definition for style over-rides.         --*/
    /*-- It just keeps counting and writing because it has          --*/
    /*-- no way of knowing if they are the same or not.             --*/
    /*--                                                            --*/
    /*-- We could know that.  But the expense isn't worth it.       --*/
    /*-- If the number of styles becomes oppressive, the better     --*/
    /*-- answer is to create an ods style that defines style        --*/
    /*-- elements that can be defined once and used many times.     --*/
    /*--------------------------------------------------------19Aug03-*/
    define event style_over_ride;
            /*---------------------------------------------------eric-*/
            /*-- Nothing to do if this isn't set.                   --*/
            /*------------------------------------------------19Aug03-*/
            break /if ^$style_over_ride;

            /*---------------------------------------------------eric-*/
            /*-- If we've done an over-ride for this style name     --*/
            /*-- before...                                          --*/
            do /if $style_list[$cell_class];

                /*-----------------------------------------------eric-*/
                /*-- If there aren't any over-rides we are here for --*/
                /*-- a format and that already exists.  So let's    --*/
                /*-- not make another one.                          --*/
                /*--------------------------------------------19Aug03-*/
                do /if $$style_elements;
                    eval $style_list[$cell_class] $style_list[$cell_class] + 1;

                else;

                    /*-------------------------------------------eric-*/
                    /*-- It's for an existing format style.  so     --*/
                    /*-- lets set the name and get out of here.     --*/
                    /*----------------------------------------19Aug03-*/
                    set $cell_class $cell_class $style_list[$cell_class];
                    break;
                done;

            /*---------------------------------------------------eric-*/
            /*-- First time for this style...                       --*/
            /*------------------------------------------------18Aug03-*/
            else;
                eval $style_list[$cell_class] 1;
            done;

            /*---------------------------------------------------eric-*/
            /*-- set the name.  basically it's going to be data1,   --*/
            /*-- data2, etc.  or possibly data_currency1, and if    --*/
            /*-- it's data_currency + over-rides then it could be   --*/
            /*-- data_currency2 etc.                                --*/
            /*------------------------------------------------19Aug03-*/
            set $cell_class $cell_class $style_list[$cell_class];

            /*---------------------------------------------------eric-*/
            /*-- Ok, it's a new style definition.                   --*/
            /*-- Lets write it out.                                 --*/
            /*------------------------------------------------19Aug03-*/
            flush;
            open style;
            put '<Style ss:ID="' $cell_class '"';
            putq ' ss:Parent=' $parent_class '>' NL;

            put $$style_elements;
            unset $$style_elements;

            trigger cell_format;

            putl '</Style>';
            close;

            open worksheet;
    end;

    /*-----------------------------------------------------------eric-*/
    /*-- based on the format, we need to possibly create a          --*/
    /*-- style and keep track of it.  We only have 3 formats.       --*/
    /*-- General, Currency, and percentage.  Two types.             --*/
    /*-- numeric and string.  If's string then it's always          --*/
    /*-- General.                                                   --*/
    /*--------------------------------------------------------18Aug03-*/
    define event resolve_cell_format;
        set $parent_class $cell_class;

        do /if $format_override;
            set $cell_class $cell_class "_manual";
            set $key $parent_class $format_override;
            do /if ^$manual_format_styles[$key] ;
                eval $format_override_count $format_override_count+1;
                set $manual_format_styles[$key] $format_override_count ;
                set $cell_class $cell_class $format_override_count '_';
            else;
                set $cell_class $cell_class $manual_format_styles[$key] '_';
            done;

            set $style_over_ride "true";
        else;
            /*---------------------------------------------------eric-*/
            /*-- It's currency.                                     --*/
            /*------------------------------------------------18Aug03-*/
            do /if cmp($format, $currency_format);
                set $cell_class $cell_class "_currency";
                do /if !$currency_styles[$parent_class];
                    set $currency_styles[$parent_class] $cell_class ;
                done;
                set $style_over_ride "true";

            /*---------------------------------------------------eric-*/
            /*-- It's a percentage format.                          --*/
            /*------------------------------------------------18Aug03-*/
            else /if cmp($format, "Percent");
                set $cell_class $cell_class "_percent";
                do /if ^$percentage_styles[$parent_class];
                    set $percentage_styles[$parent_class] $cell_class ;
                done;
                set $style_over_ride "true";
            done;
        done;

        /*-------------------------------------------------------eric-*/
        /*-- write out the style definition.                        --*/
        /*----------------------------------------------------18Aug03-*/
        trigger style_over_ride;
        unset $parent_class;
    end;


    define event cell_and_value;

        break /if ^any(value, $empty);
        /*-------------------------------------------------------eric-*/
        /*-- The cell tag hasn't finished up yet.                   --*/
        /*----------------------------------------------------18Aug03-*/
        do /if ^$cell_tag;
            /*-------------------------------------------------------eric-*/
            /*-- Figure out if it's a string or number and if it's      --*/
            /*-- general, currency, or percentage.                      --*/
            /*----------------------------------------------------18Aug03-*/
            trigger value_type;

            /*-------------------------------------------------------eric-*/
            /*-- get a style created or used, close up the beginning of --*/
            /*-- the cell tag.                                          --*/
            /*----------------------------------------------------18Aug03-*/
            trigger resolve_cell_format;

            /*-------------------------------------------------------eric-*/
            /*-- toggle the stream if we are in a head section.         --*/
            /*-- for proc report and tabulate.                          --*/
            /*----------------------------------------------------19Aug03-*/
            trigger worksheet_or_head;

            /*---------------------------------------------------eric-*/
            /*-- Finish off the opening Cell tag.                   --*/
            /*------------------------------------------------19Aug03-*/
            trigger cell_start finish;

            open worksheet;
        done;

        /*-------------------------------------------------------eric-*/
        /*-- print the value.                                       --*/
        /*----------------------------------------------------18Aug03-*/
        trigger value_put;
    end;
    
    define event tagattr_settings;
        
        unset $attrs;
        break /if ^tagattr;
        break /if cmp(section, 'head');
        
        /*-------------------------------------------------------eric-*/
        /*-- If there is a : then we need to parse for format       --*/
        /*-- and/or formula.  To add new attributes change the      --*/
        /*-- tagattr_regexp above.                                  --*/
        /*----------------------------------------------------17Dec04-*/

        do /if index(tagattr, ":") > 0;

            eval $index 1;
            /* get the first section to look at */
            set $tmp scan(tagattr, $index, ' ');
            
            do /while !cmp($tmp, ' ');

                /* look for an attribute */
                do /if prxmatch($tagattr_regex, $tmp);

                    /* get the attribute name */
                    set $attr scan($tmp, 1, ':');
                    /* get what is left */
                    set $attrs[$attr] scan($tmp, 2, ":");

                else;
                    /* it didn't start with a name so add it on */
                    set $attrs[$attr] $attrs[$attr] ' ' $tmp;
                done;
                
                eval $index $index + 1;
                /* get the next section */
                set $tmp scan(tagattr, $index, ' ');
            done;
            
        else;
            set $attrs['format'] tagattr;
        done;
        
    end;

    define event data;
        start:
            trigger tagattr_settings;
            unset $format_override;
            do /if cmp(section, 'body');
                do /if ^$first_data_column & cmp(event_name, 'data');
                    /*do /if ^contains(htmlclass, "eader"); */
                    /*putlog "FIRST_DATA_COLUMN: " ":" colstart " Class" ":" htmlclass " Event " ":" event_name;*/
                    eval $first_data_column inputn(colstart, 'BEST') ;
                done;
            done;
            /*---------------------------------------------------eric-*/
            /*-- Save away the beginning of the cell, and the style --*/
            /*-- over-rides.                                        --*/
            /*------------------------------------------------19Aug03-*/
            trigger cell_start start;

            /*---------------------------------------------------eric-*/
            /*-- if we have a value, figure out what format to use, --*/
            /*-- write out the style definition for the over-ride,  --*/
            /*-- if we need to.  write out the value.               --*/
            /*------------------------------------------------19Aug03-*/
            trigger cell_and_value /if value;

            set $in_a_cell "true";

        finish:
            /*---------------------------------------------------eric-*/
            /*-- If it was actually an empty cell and not a         --*/
            /*-- put_value event from proc report we need to        --*/
            /*-- print the Data tag now.                            --*/
            /*------------------------------------------------25Jul03-*/
            do /if !$value_put;
                set $empty "true";
                trigger cell_and_value ;
                unset $empty;
            done;
            unset $value_put;
            unset $in_a_cell;

            /*-------------------------------------------------------eric-*/
            /*-- toggle the stream if we are in a head section.         --*/
            /*-- for proc report and tabulate.                          --*/
            /*----------------------------------------------------19Aug03-*/
            trigger worksheet_or_head;

            put '</Data>';

            putl '</Cell>';


            open worksheet;

    end;

    /*-----------------------------------------------------------eric-*/
    /*-- We only have to do this because procs report, tabulate     --*/
    /*-- and freq don't give the type of the variable.              --*/
    /*-- And even if they did we can only use them as a guidline.   --*/
    /*--                                                            --*/
    /*-- Excel can't handle something like >.001 as a number.  Nor  --*/
    /*-- can it handle percents.  Although once they are loaded it  --*/
    /*-- recognizes them.  inputn works pretty well be we do have   --*/
    /*-- numeric data with spaces in them.  Which are technically   --*/
    /*-- non numeric.                                               --*/
    /*--------------------------------------------------------28Jul03-*/
    define event value_type;
        set $value strip(VALUE);
        set $format "General";
        do /if $value;
            eval $is_numeric prxmatch($number, $value);
            do /if $is_numeric;

                set $type "Number";
                set $value compress($value, $punctuation);

                do /if index(value, "%") > 0;
                    set $format "Percent" /if index(value, "%") > 0;
                    /*putlog "Percent value:" $value;*/
                    eval $tmp inputn($value, $test_format)/100;
                    /*putlog "Percent value:" $tmp;*/
                    set $value $tmp;

                else /if index(value, $currency) > 0;
                    set $format $currency_format /if index(value, $currency) > 0;
                done;

            else;
                set $type 'String';
            done;
        else;
            /* default to string for empty values*/
            set  $type "String" ;
            set  $type "Number" / if cmp(type, 'int');
            set  $type "Number" / if cmp(type, 'double');
            set  $type "String" / if cmp(type, 'string');
        done;

    end;


    define event value_put;

        /*-------------------------------------------------------eric-*/
        /*-- toggle the stream if we are in a head section.         --*/
        /*-- for proc report and tabulate.                          --*/
        /*----------------------------------------------------19Aug03-*/
        trigger worksheet_or_head;

            do /if !$value_put;
                do /if cmp(event_name, 'header');
                    set $tmp_val strip(value);
                    set $type "String" /if ^$tmp_val;
                    unset $tmp_val;
                done;
                putq  '<Data ss:Type=' $type ;
                put '>';
                set $value_put "true";
                unset  $type;
            done;

            put $value;

            unset $value;

            open worksheet;
    end;

    /*-----------------------------------------------------------eric-*/
    /*-- These events are to work around the tables that don't      --*/
    /*-- provide colspecs up front.  procs report, tabulate and     --*/
    /*-- freq with crosstabs.                                       --*/
    /*--------------------------------------------------------28Jul03-*/


    /*-----------------------------------------------------------eric-*/
    /*-- if we are in the head section we want rows and cells to go --*/
    /*-- into the table_headers stream.  What a pain.               --*/
    /*--------------------------------------------------------19Aug03-*/
    define event worksheet_or_head;
        do /if $is_a_table_head;
            open table_headers ;
        else;
            open worksheet;
        done;
    end;

    define event rowspec;
        start:
            break /if $is_a_table_head;
            open table_headers;
    end;

    define event table_head;
        start:
            break /if $colspecs_are_done;
            set $is_a_table_head "true";
            open table_headers;
        finish:
            do /if $colspecs_are_done;
                unset $colspecs_are_done;
                break;
            done;
            unset $is_a_table_head;
            close;

    end;

    /* just in case */
    define event table_body;
        do /if $$table_headers;

            do /if $titles_are_done;
                unset $titles_are_done;
            else;
                trigger embedded_title;
            done;

            put $$table_headers;
            unset $$table_headers;
        done;
        do /if $table_count = $autofilter_table;
            do /if ^$autofilter_row;
                eval $autofilter_row $worksheet_row;
            done;
        done;
        unset $is_a_table_head;
        eval $data_row_count 0;
    end;

    define event colspecs;
        start:
            trigger worksheet_or_head;
        finish:
            eval $colcount $colcount-1;
            set $colspecs_are_done "true";
            trigger embedded_title;
            put $$table_headers;
            unset $$table_headers;
            set $titles_are_done 'true';
            
            /*---------------------------------------------------eric-*/
            /*-- move the table column widths into the worksheet    --*/
            /*-- column widths.  The biggest width for a column     --*/
            /*-- wins.                                              --*/
            /*------------------------------------------------17Dec04-*/
            eval $count 1;
            do /while $table_widths;
                do /if $worksheet_widths[$count];
                    eval $width inputn($worksheet_widths[$count], 'Best');
                    do /if $width < inputn($table_widths[1], 'Best');
                        set $worksheet_widths[$count] $table_widths[1];
                    done;
                else;
                    set $worksheet_widths[] $table_widths[1];
                done;
                unset $table_widths[1];
                eval $count $count + 1;
            done;
    end;

    define event header;
        start:
            do /if cmp(section, 'body');
                eval $rowheader_count $rowheader_count + 1;
            done;
            trigger data;
        finish:
            trigger data;
    end;

    define event embedded_title;
        break /if ^$embedded_titles;
        break /if ^$titles;

        do /if ^$worksheet_row;
            eval $worksheet_row 0;
        done;
        eval $worksheet_row $worksheet_row + $titles + 1;

        eval $count 1;
        do /while $count <= $titles ;
            set $span_cell_style $title_styles[$count];
            trigger span_cell start;
            put $titles[$count];
            trigger span_cell finish;
            eval $count $count+1;
        done;
        /* a blank row for padding. */
        unset $span_cell_style;
        unset $titles;
        trigger span_cell start;
        trigger span_cell finish;
    end;

    define event embedded_footnotes;
        break /if ^$embedded_titles;
        break /if ^$footers;
        /* a blank row for padding. */
        trigger span_cell start;
        trigger span_cell finish;
        
        do /if ^$worksheet_row;
            eval $worksheet_row 0;
        done;
        eval $worksheet_row $worksheet_row + $footers + 1;

        eval $count 1;
        do /while $count <= $footers ;
            set $span_cell_style $footer_styles[$count];
            trigger span_cell start;
            put $footers[$count];
            trigger span_cell finish;
            eval $count $count+1;
        done;
        unset $footers;
    end;

    define event span_cell;
        start:
            putq '<Row';
            putq ' ss:Index=' $span_cell_index;
            put  ' ss:StyleID="Table">';
            put  '<Cell';
            putq ' ss:StyleID=' $span_cell_style;
            putq ' ss:MergeAcross=' $colcount;
            put ">";
            putq '<Data ss:Type="String"';
            put '>';
        finish:
            put '</Data>';
            put '</Cell></Row>' nl;
    end;
    

    define event hyperlink;
        trigger put_value;
    end;

    define event put_value;
        do /if $in_a_cell;
            trigger cell_and_value /if value;
        else;
            put strip(VALUE);
        done;
    end;

    define event put_value_cr;
        do /if $in_a_cell;
            trigger cell_and_value /if value;
        else;
            put strip(VALUE) nl;
        done;
    end;

    /*-------------------------------------------------------------eric-*/
    /*-- This is a bit painful.  We want to have all of our titles    --*/
    /*-- and footnotes but the xml only allows for one header tag     --*/
    /*-- and one footer tag.  So we're putting all the titles in      --*/
    /*-- the one tag with a newline between them.  excel seems to     --*/
    /*-- know what to do with it so I guess this is ok.               --*/
    /*----------------------------------------------------------2Jul 03-*/
    define event page_setup;
        start:
            unset $$page_setup;
            unset $titles;
            unset $footers;
            open page_setup;


        finish:
            close;

            /* reopen the worksheet stream */
            open worksheet;

            /* possibly close an open worksheet */
            trigger worksheet finish /if cmp($sheet_interval, "page");
            /* start a new worksheet */
            trigger worksheet start /if cmp($sheet_interval, "page");
            /* It might be the first time and the interval is none */
            trigger worksheet start /if cmp($sheet_interval, "none");
            /* It might be the first time and the interval is proc */
            trigger worksheet start /if cmp($sheet_interval, "proc");
    end;

    define event system_title_setup_group;
        start:
            unset $titles;
            unset $title_styles;
            put  '<x:Header ';
        finish:
            putl '"/>';
            unset $not_first;
    end;

    define event system_footer_setup_group;
        start:
            unset $footers;
            unset $footer_styles;
            put  '<x:Footer ';
        finish:
            putl '"/>';
            unset $not_first;
    end;

    /*-------------------------------------------------------------eric-*/
    /*-- Print out the titles and footnotes with newlines between them.--*/
    /*----------------------------------------------------------3Jul 03-*/
    define event title_data;

        do /if $not_first;
            put nl;
        else;
            putq " ss:StyleID=" htmlclass;
            putq ' Data="';
        done;

        put value;
        
        /*-------------------------------------------------------eric-*/
        /*-- The flush causes everything to go into the page_setup  --*/
        /*-- stream.  Without it, some of the titles, - every other --*/
        /*-- second title, where the second one has style           --*/
        /*-- over-rides, will go to the output file.                --*/
        /*----------------------------------------------------24Nov04-*/
        flush;

        set $not_first "True";
    end;

    define event system_title_setup;
        trigger title_data;
        set $tmp_value strip(value);
        set $tmp_value ' ' /if ^$tmp_value;
        set $titles[] $tmp_value;
        unset $tmp_value;
        trigger title_footer_over_rides;
        set $title_styles[] $style_name;
    end;

    define event system_footer_setup;
        trigger title_data;
        set $tmp_value strip(value);
        set $tmp_value ' ' /if ^$tmp_value;
        set $footers[] $tmp_value;
        unset $tmp_value;
        trigger title_footer_over_rides;
        set $footer_styles[] $style_name;
    end;

    
    define event title_footer_over_rides;
        set $style_name htmlclass;
        do /if any(font_face, font_size, font_style,
            font_weight, foreground, background,
            borderwidth, bordercolor);
            
            do /if cmp(event_name, "system_title_setup");
                do /if $title_style_count;
                    eval $title_style_count $title_style_count + 1;
                else;
                    eval $title_style_count 1;
                done;
                set $style_name htmlclass "_" $title_style_count;

            else /if cmp(event_name, "system_footer_setup");
                do /if $footer_style_count;
                    eval $footer_style_count $footer_style_count + 1;
                else;
                    eval $footer_style_count 1;
                done;
                set $style_name htmlclass "_" $footer_style_count;
            done;

            /*-----------------------------------------------eric-*/
            /*-- This event redirects to it's own stream,       --*/
            /*-- ye be warned...                                --*/
            /*--------------------------------------------19Aug03-*/
            trigger xl_style_elements;

            open style;
            put '<Style ss:ID="' $style_name '"';
            putq ' ss:Parent=' $htmlclass '>' NL;

            put $$style_elements;
            unset $$style_elements;

            putl '</Style>';
            close;
            
            open page_setup;

        done;
    end;


    /* for debugging */
    define event putvars;
        put NL "----- Event Variables -----" NL;
        putvars EVENT  _NAME_ "=" _VALUE_ NL;
        put "----- Style Variables -----" NL;
        putvars STYLE  _NAME_ "=" _VALUE_ NL;
        put NL;
    end;

end;
run;
