proc template;
    
    define tagset tagsets.namedstyle;
    parent = tagsets.namedhtml;
    

 define event do_value;
             trigger foo /if exists(htmlclass);
 
            put VALUE CR;
        end;
        define event foo;
            put '<span class="name_label">Style:&nbsp;</span>' /if exists(htmlclass);
            put '<span class="name_value">' htmlclass '</span>' /if exists(htmlclass);
            put "<br>" /if exists(htmlclass);

        end;
    end;

run;

ods tagsets.namedstyle file="namedstyle.html" stylesheet="namedstyle.css";
proc template;
    
    define tagset tagsets.foo;
    parent=tagsets.namedhtml;
    

        define event do_value;
            trigger foo /if exists(htmlclass);
            put VALUE CR;
        end;
            
        define event foo;
            put '<span class="name_label">Style:&nbsp;</span>';
            put '<span class="name_value">' htmlclass '</span>';
            put "<br>";
        end;

    end;
run;


ods tagsets.foo file="nstyle.html" stylesheet="nstyle.css";
    

proc print data=sashelp.class;
run;

ods _all_ close;
