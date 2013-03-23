
proc template;

    define tagset tagsets.show_class;

        embedded_stylesheet=yes;
        default_event = 'show_class';

        define event show_class;
            /* bail out if there isn't a style class here   */
            /* and this is style_class, we don't care about */
            /* the stylesheet events                        */
            break /if ^htmlclass | cmp(event_name, 'style_class');  
        
            put "Event: " event_name nl;
            put "Class: " htmlclass nl;
            put "Value: " value nl;
            
            /* trigger show_style */

            put "=============================" nl;
        end;

        define event show_style;
            put "-----------------------------" nl;
            putvars style _name_ " : " _value_ nl;
        end;

    end;

run;


ods tagsets.show_class file="example7.txt";

proc print data=sashelp.class;
run;

ods tagsets.show_class close;

