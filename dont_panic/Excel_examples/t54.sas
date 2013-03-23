
proc template;
  define tagset tagsets.captions;

      define event caption;
           putvars event _name_ ":" _value_ nl; 
      end;
  end;

run;

ods tagsets.captions file="captions.txt";

%inc "t52.sas";



       
