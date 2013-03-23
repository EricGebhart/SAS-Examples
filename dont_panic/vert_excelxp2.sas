proc template;
    
    define tagset tagsets.vert_excelxp;
    parent = tagsets.excelxp;
    
    define event xl_style_elements;
        delstream style_elements;
        open style_elements;


        set $headerString lowcase(htmlclass);
        do /if index ($headerString, 'header');
            put '<Alignment';
            set $align_tag "True";
            put ' ss:WrapText="1"';
            unset $headerString;
        done;

/*---------------------------------------------------------------eric-*/
/*-- Make vertical column headers vertical...                       --*/
/*------------------------------------------------------------10Jan06-*/
        put ' ss:Vertical="Top" ss:Rotate="90" ' /if cmp(htmlclass, 'vertical_header');

        do /if $vjust;
            put '<Alignment' /if ^$align_tag;
            set $align_tag "True";
            put ' ss:Vertical=';
            put '"Center"' /if cmp($vjust, 'm');
            put '"Top"' /if cmp($vjust, 't');
            put '"Bottom"' /if cmp($vjust, 'b');
        done;
        unset $vjust;


        do /if $just;
            put '<Alignment' /if ^$align_tag;
            set $align_tag "True";
            put ' ss:Horizontal=';
            put '"Center"' /if cmp($just, 'c');
            put '"Left"' /if cmp($just, 'l');
            put '"Right"' /if cmp($just, 'r');
            put '"Right"' /if cmp($just, 'd');

        else /if contains(htmlclass, "SystemTitle") or
               contains(htmlclass, "SystemFooter") or
               cmp(htmlclass, "Byline");
            do /if ^$just;
                do /if cmp($align, "center");
                    put '<Alignment' /if ^$align_tag;
                    set $align_tag "True";
                    put ' ss:Horizontal="Center"';
                done;
            done;
        done;
        unset $just;

        putl '/>'  /if $align_tag;
        unset $align_tag;
        
        
        trigger write_all_borders;

        trigger font_interior;

        put '<Protection';
        put  ' ss:Protected="1"';
        put  ' />' NL;

        flush;
        close;
    end;

end;

run;

/*---------------------------------------------------------------eric-*/
/*-- Column widths will be too wide because the tagset thinks the   --*/
/*-- headers are horizontal...                                      --*/
/*------------------------------------------------------------10Jan06-*/

proc template;
    define style styles.mystyle;
        parent=styles.default;

        style vertical_header from header /
        ;
     end;
run;

ods tagsets.vert_excelxp 
            style=mystyle
            file="test.xls" 
            options(absolute_column_width="4,8,4,3,4,5" 
                    row_heights="30" 
                   );

proc print data=sashelp.class;
    var name / style(header) = vertical_header;
    var age sex;
    var weight height / style(header) = vertical_header;
run;

ods _all_ close;

