
proc template;
   define tagset tagsets.foo;
      define event doc;
      start:

         set $foo "this is foo";
      
         put "foo has is" nl /if contains("is", $foo);

         /*--------------------------------------------------------------eric-*/
         /*-- create a stream the 'normal' way.                             --*/
         /*-----------------------------------------------------------12Mar02-*/
         open junk4;
         put "some more stuff for junk4" ;
         close;
         
         put "Open/put Junk4:" $$junk4 nl;
         
         /*---------------------------------------------------------------eric-*/
         /*-- Add to our previously created stream...                        --*/
         /*------------------------------------------------------------12Mar02-*/
         open junk4;
         put " more stuff" ;
         close;

         put "Open/put Junk4:" $$junk4 nl;
         
         /*---------------------------------------------------------------eric-*/
         /*-- set the same stream to something else.  It's like starting over.--*/
         /*------------------------------------------------------------12Mar02-*/
         set $$junk4 "A completely new junk4"; 

         put "set Junk4:" $$junk4 nl;

        /*---------------------------------------------------------------eric-*/
        /*-- This is a syntax error.  you  cant put a stream variable in a  --*/
        /*-- memory variable                                                --*/
        /*------------------------------------------------------------12Mar02-*/
/*         set $bar $$junk;  */
         
         /*------------------------------------------------------eric-*/
         /*-- Set a stream to it's self plus some more.             --*/
         /*---------------------------------------------------12Mar02-*/
         set $$junk4 $$junk4 " !!! even more stuff for junk4"; 

         put "setself Junk4:" $$junk4 nl;

         /*------------------------------------------------------eric-*/
         /*-- Set the stream to itself with  stuff on each side.    --*/
         /*-- Set differs from put in that putting a stream to      --*/
         /*-- itself will set what the stream looked like before    --*/
         /*-- the set command.                                      --*/
         /*---------------------------------------------------12Mar02-*/
         set $$junk4 "*********" $$junk4 "%%%%%%%%%%"; 

         put "setself Junk4:" $$junk4 nl;

         /*------------------------------------------------------eric-*/
         /*-- Append some text a newline and our stream to itself.  --*/
         /*-- Notice that the append of itself includes Everything  --*/
         /*-- up to the stream reference. Including the newline.    --*/
         /*---------------------------------------------------12Mar02-*/
         open junk4;
         put "!!! This gets duped too!!! " nl $$junk4 ;
         close;

         put "open/putself Junk4:" $$junk4 nl ;
         
         putstream Junk4;

         put nl;
         
         put "Junk4:" $$junk4 nl;

         put "Stream variables:" nl;
         putvars stream "<" _name_ ">" _value_ "</" _name_ ">" nl;

      end;    
  end;
run;


ods tagsets.foo file="st.txt";
ods tagsets.foo close;

           
