
proc template;
    define tagset tagsets.example12;
        
    define event initialize;
        iterate $options;
        do /while _name_;
            putlog _name_ ": " _value_;
            next $options;
            done;
        end;
    end;
run;

ods tagsets.example12 file="example12.empty" options(doc="help" events="table row data");

    
