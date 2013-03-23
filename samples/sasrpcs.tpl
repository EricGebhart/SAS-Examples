define tagset.sasrpcs;
    default=rpc;

    define event rpc;
        put '<' event_name '>';
        indent;

        put '<event>';
        indent;
        putvars event '<' _name_ '>' _value_ '</' _name_ '>';
        xdent;
        put '</event>';

        put '<style>';
        indent;
        putvars style '<' _name_ '>' _value_ '</' _name_ '>';
        xdent;
        put '</style>';

        put '<dynamic>';
        indent;
        putvars dynamic '<' _name_ '>' _value_ '</' _name_ '>';
        xdent;
        put '</dynamic>';

        put '<user>';
        indent;
        putvars user '<' _name_ '>' _value_ '</' _name_ '>';
        xdent;
        put '</user>';

        put '<stream>';
        indent;
        putvars stream '<' _name_ '>' _value_ '</' _name_ '>';
        xdent;
        put '</stream>';

        xdent;
        put '</' event_name '>';
    end;
end;

