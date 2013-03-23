
/*---------------------------------------------------------------eric-*/
/*-- Recursion limit is 200.  If the limit is hit it will unwind    --*/
/*-- automatically.                                                 --*/
/*------------------------------------------------------------12Feb03-*/

proc template;
  define tagset tagsets.test;
    
    define event doc;
      set $count 1;
      trigger loop;
      put "Count: " $count nl;
    end;

    define event loop;
      put "Count: " $count nl;
      putlog "Count: " $count nl;
      eval $count $count+1;
      trigger loop /if $count<100;
      eval $count $count-1;
      put "Unwind:" $count nl;
      putlog "Unwind:" $count nl;
    end;
  end;
  
run;

ods tagsets.test file="recurse.txt";

ods _all_ close;

