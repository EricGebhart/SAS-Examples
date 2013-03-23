proc template;

    define style styles.stripes;
        parent=styles.default;
    
        style DataStripe from data /
            background=cxB0B0B0
        ;
        
    end;
    
    define tagset tagsets.stripes;
        parent=tagsets.html4;

        define event initialize;
            set $alt_row_style tagset_alias;
            set $alt_row_style 'DataStrong' /if !$alt_row_style;
        end;

        define event table_head;
            start:
                put '<thead';
                put '>' nl;
                set $row_class 'data';
                eval $row_count 0;
            finish:
                put '</thead>' nl;
        end;

        define event row;
            start:

                put '<tr>' nl;

            finish:
                put '</tr>' nl;
                trigger swapclass /if cmp(section, 'body');

        end;

        define event swapclass;
            eval $row_count $row_count+1;
            eval $dont_switchit mod($row_count,12);
            /*putlog $row_count " : " $dont_switchit;*/
            break /if $dont_switchit;
            do /if cmp($row_class, 'data');
                set $row_class $alt_row_style;
            else;
                set $row_class 'data';
            done;
        end;
            

        define event classalign;
            do /if cmp(htmlclass, 'data');
                set $class $row_class;
            else;
                set $class htmlclass;
            done;

            unset $vjust;
            unset $just;
            set $vjust vjust / when !cmp("t", vjust);
            set $just just / when !cmp("l", just);
            set $just "r" /when cmp("d", $just);
            break / when !any($class, $just, $vjust);
            put ' class="';
            put $just ' ' $vjust;
            put ' ' $class;
            put '"';
        end;
    end;
run;

ods tagsets.stripes file='striped.html' alias='DataStripe' style=stripes;
*options obs=5;
proc print data=sashelp.class; run;
ods _all_ close;
