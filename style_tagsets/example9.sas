
proc template;

    define tagset tagsets.show_class;

        embedded_stylesheet=yes;
        default_event = 'show_class';

        define event show_class;
            /* bail out if there isn't a style class here   */
            /* and this is style_class, we don't care about */
            /* the stylesheet events                        */
            break /if ^value | ^htmlclass | cmp(event_name, 'style_class');  
        
            set $events[event_name] htmlclass;
        end;

        define event doc;
            finish:
                putvars $events "Event/Style: " _name_ " / " _value_ nl;
        end;

    end;

run;


ods tagsets.show_class file="example9.txt";

proc print data=sashelp.class;
run;

ods tagsets.show_class close;

