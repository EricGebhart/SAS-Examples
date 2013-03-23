
proc template;
    define tagset tagsets.sdhtml;
    parent=tagsets.html4;
    
    define event superDuper;

        put '<span style="border-width:1; border-style:solid; border-color: black;"> ' nl;

        eval $count 1;
        do /if index(value, ' ');
            set $word scan(value, 1, ' ');
            do /while !cmp($word, ' ');

                do /if mod($count, 2); 
                    put '<sup>' $word '</sup>';
                else;
                    put '<sub>' $word '</sub>';
                done;

                eval $count $count + 1;
                set $word scan(value, $count, ' ');
            done;

        else /if $event;
            put '<sup>' value '</sup>';
        done;

        put nl "</span>" nl;
                 

    end;
end;

run;


ods escapechar="^";


title 'This is ^{superduper SUPER DUPER text}
        This is ^{sub SUB text}';

title2 'This is ^{super SUPER text}
        ^{sub This is SUB text}
        ^{super More SUPER text}
        ^{sub More SUB text}';


ods tagsets.sdhtml file="example17.html";

proc print data=sashelp.class;
run;

ods _all_ close;
