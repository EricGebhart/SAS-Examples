
proc template;

    define style styles.mystyle;
        parent=styles.Minimal;
        style table_head/
            backgroundColor=cx00CCCC
            borderTopWidth=5
            borderTopColor=red
            borderBottomWidth=10
            borderBottomColor=red;
        ;
         
    end;


    define tagset tagsets.myhtml;
        parent = tagsets.html4;
    
        define event table_head;
            style=table_head;
        
            start:
                put "<thead";
                trigger classalign;
                trigger style_inline;
                put ">" nl;
            finish:
                put "</thead>";
        end;

    end;

run;


ods tagsets.myhtml file="example12.html" style=mystyle;

proc print data=sashelp.class;
run;

ods tagsets.mystyle close;

