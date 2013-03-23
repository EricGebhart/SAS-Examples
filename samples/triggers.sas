proc template; 
  define tagset tagsets.triggers; 
         define event doc; 
      start: 
        put "start of doc" nl; 
        trigger mytest; 
        trigger jabberwocky; 
      finish: 
        trigger mytest; 
        put "finish of doc" nl; 
        trigger mytest start; 
        trigger jabberwocky; 
        trigger mytest finish; 
    end; 
         define event mytest; 
      start: 
        put "start of mytest" nl; 
      finish:  
        put "finish of mytest" nl; 
    end; 
         define event jabberwocky; 
      put "This is Jabberwocky" nl; 
    end; 
       end; 
run; 

ods tagsets.triggers file="triggers.txt"; 
ods tagsets.triggers close;

