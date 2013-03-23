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

        define event calculate_width;
            set $width value /breakif index(value, '%') > 0;

            eval $dash_pos index(Tagattr, '-');
            do /if $dash_pos;
                eval $dash_pos $dash_pos+1;
            done;
            eval $value inputn(value, '12.');
            eval $max inputn(substr(Tagattr, $dash_pos), '12.');
            eval $width ($value / $max) * 100;
            set $width $width '%';
            unset $dash_pos;
        end;

        define event data;
            start:
                /* this would work but sometimes htmlclass is empty... */
                trigger header /breakif cmp(htmlclass, "RowHeader");
                trigger header /breakif cmp(htmlclass, "Header");

                do /if index(tagattr, 'slider') > 0;
                    put '<td width="150" class="data">' nl;
                    put '<table width="100%" class="data" cellpadding=0; cellspacing=0;>' nl;
                    trigger calculate_width;
                done;
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

            finish:
                trigger header /breakif cmp(htmlclass, "RowHeader");
                trigger header /breakif cmp(htmlclass, "Header");
   
                trigger cell_value;
                put "</td>" CR;
                do /if $width;
                    put '<td>&nbsp;</td>' CR;
                    put "</table></td>" CR;
                    unset $width;
                done;

        end;
    end;
run;

options obs=3;
ods tagsets.slider file='test.html' style=slider;

proc print data=sashelp.class;
    var name;
    var sex;
    var age;     
    var height / style(data) = slider[just=center tagattr="slider-80"];
    var weight / style(data) = slider[just=center tagattr="slider-150"];
run;

ods tagsets.slider close;
