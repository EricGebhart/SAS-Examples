
proc template;
    define tagset tagsets.excel;
    parent = tagsets.excelxp;
    
    define event option;
        set $name upcase(name);
        /*putvars event _name_ " : " _value_ nl;*/
        putlog "OPTION:" $name " : " name  ":" value;
        set $options[$name] value;
        trigger options_setup;
        trigger documentation;
    end;
end;
run;


ods tagsets.excel file="test.xls";

ods tagsets.excel event=option(name="doc" text="help");

    
ods tagsets.excel event=option(name="orientation" text="landscape");

proc print data=sashelp.class;
run;

ods tagsets.excel close;


    
