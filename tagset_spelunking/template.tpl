
proc template;
define tagset tagsets.template;
    parent=tagsets.config_debug;

    define event initialize;
        trigger set_options_defaults;
        trigger set_valid_options;
        trigger set_options;
    end;

    /*--------------------------------------------------------------eric-*/
    /*-- This one happens when options(...) are given on the ods markup--*/
    /*-- statement.                                                    --*/
    /*-----------------------------------------------------------14Jun04-*/
    define event options_set;
        trigger set_options;
    end;

    define event set_options;
        trigger check_valid_options;
        trigger options_setup;
        trigger documentation;
    end;

    define event check_valid_options;
        iterate $options;
        do /while _name_;
            do /if ^$valid_options[_name_];
                putlog "Unrecognized option: " _name_;
            done;
            next $options;
        done;
    end;
    
    /*-----------------------------------------------------------eric-*/
    /*-- Each new option should be added in three places before     --*/
    /*-- using it in the underlying code.                           --*/
    /*-- 1. Add the option to the $valid_options array              --*/
    /*-- 2. Add the option to the set_options event to set the      --*/
    /*--        appropriate variable, if necessary.                 --*/
    /*-- 3. Add the option to the quick reference event's help text.--*/
    /*--------------------------------------------------------11Mar07-*/
    
    define event set_valid_options;
        set $valid_options['DOC'] 'Documentation for this tagset.';
        set $valid_options['STRING_OPTION'] 'This is string option to do something';
        set $valid_options['NUMERIC_OPTION'] 'This is a Numeric option to do something';
        set $valid_options['YES_NO_OPTION'] 'This is a yes/no option to turn something on';
        trigger config_debug_set_valid_options;
    end;

    define event set_options_defaults;
        set $option_defaults['DOC'] 'none';
        set $option_defaults['STRING_OPTION'] 'none';
        set $option_defaults['NUMERIC_OPTION'] '100';
        set $option_defaults['YES_NO_OPTION'] 'no';
        trigger config_debug_set_options_defaults;
        trigger set_valid_option_values;
    end;
    
    define event set_valid_option_values;
        trigger set_yes_no_option_values;
    end;
    
    define event set_yes_no_option_values;
        eval $yes_no['yes'] 1;
        eval $yes_no['on'] 1;
        eval $yes_no['no'] 0;
        eval $yes_no['off'] 0;
    end;
    
    define event check_yes_no;
        unset $answer;
        break /if ^$option;
        set $no_answer "true";
        iterate $yes_no;
        do /while _name_;
            do /if cmp($option, _name_);
                eval $answer _value_;
                unset $no_answer;
            done;
            next $yes_no;
        done;      
        do /if $no_answer;
            putlog "%3z Yes/No options only take, yes, no, on, or off as valid values";
        done;      
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

        trigger config_debug_options_setup;
        
        unset $option;
        set $option $options['STRING_OPTION'];
        set $option $option_defaults['STRING_OPTION'] /if ^$option;
        
        do /if cmp($options, 'none');
            unset $string_option;
        else;
            set $string_option $options;
        done;


        unset $option;
        set $option $options['NUMERIC_OPTION'];
        set $option $option_defaults['NUMERIC_OPTION'] /if ^$option;

        do /if $option;
            eval $numeric_option inputn($option, 'BEST');
            do /if missing($option);
                set $numeric_option $option_defaults['NUMERIC_OPTION'];
                eval $numeric_option inputn($numeric_option, 'BEST');
            done;
        done;


        unset $option;
        set $option $options['YES_NO_OPTION'];
        set $option $option_defaults['YES_NO_OPTION'] /if ^$option;
        
        unset $yes_no_option;
        trigger check_yes_no;
        eval $yes_no_option $answer;
    end;
    
    
    
    define event documentation;
        break /if ^$options;
        trigger quick_reference /if cmp($options['DOC'], 'quick');
        trigger help /if cmp($options['DOC'], 'help');
        trigger settings /if cmp($options['DOC'], 'settings');
        trigger list_options /if cmp($options['DOC'], 'options');
    end;

    define event list_options;
        iterate $valid_options;
        putlog "==============================================================================";
        putlog "Name     : Current value  :  Description";
        putlog " ";
        do /while _name_;
            set $option $options[_name_];
            set $option $option_defaults[_name_] /if ^$option;
            putlog _name_ " : " $option  " : " _value_;
            next $valid_options;
        done;
        putlog " ";
    end;

    define event help;
        putlog "==============================================================================";
        putlog "The " tagset  " Help Text.";
        putlog " ";
        putlog "This Tagset/Destination creates .... ";
        putlog " ";
        putlog "See Also:";
        putlog "http://support.sas.com/rnd/base/topics/odsmarkup/";
        putlog " ";
        trigger list_options;
        trigger quick_reference;
    end;
    
    
    define event quick_reference;
        putlog "==============================================================================";
        putlog " ";
        putlog "These are the options supported by this tagset.";
        putlog " ";
        putlog "Sample usage:";
        putlog " ";
        putlog "ods " tagset " file='test.xml' data='test.ini' options(doc='Help'); ";
        putlog " ";
        putlog "ods " tagset " options(doc='Quick'); ";
        putlog " ";
        putlog "ods " tagset " options(String_Option='something here' ";
        putlog "                       Numeric_Option='2.5'); ";
        putlog "                       Yes_No_Option='yes'); ";
        putlog " ";
        putlog "Doc:    Default value: " $option_defaults['DOC'];
        putlog "     Help:     Displays introductory text and options.";
        putlog "     Quick:    Displays available options.";
        putlog "     Settings: Displays config/debug settings.";
        putlog "     options:  Displays list of options, their current value, and";
        putlog "               a short description";
        putlog " ";
        putlog "String Option:   Default Value: " $option_defaults['STRING_OPTION'] ;
        putlog "     Sets some string to use for something.";
        putlog " ";
        putlog "Numeric_Option:   Default Value: " $option_defaults['NUMERIC_OPTION'];
        putlog "     Sets some number to do something.";
        putlog " ";
        putlog "Yes_No_Option:   Default Value: " $option_defaults['YES_NO_OPTION'];
        putlog "     If set to 'yes', turns something on or off.";
        putlog " ";
        
        trigger config_debug_help;

        putlog "==============================================================================";
    end;

end;
run;


