
proc template;
   define tagset tagsets.foo;
      define event doc;
      start:

         /*----------------------------------------------------------------eric-*/
         /*-- create a user variable 'foo'.  author is empty by default so    --*/
         /*-- the 'Author iss:' string shouldn't become a part of $foo either.--*/
         /*-------------------------------------------------------------9Mar 02-*/
         set $foo "This" " is" " foo" " Author is:" author;
         put $foo nl nl;

        /*-------------------------------------------------------eric-*/
        /*-- Write something to the log.  newlines and streams not  --*/
        /*-- allowed.                                               --*/
        /*----------------------------------------------------12Mar02-*/
         putlog "Hello " "foo is: " $foo;
         
         unset $foo;
         unset all;
         unset _all_;
         
        /*---------------------------------------------------------------eric-*/
        /*-- Write some stuff to an Item store stream.                      --*/
        /*------------------------------------------------------------9Mar 02-*/
         open junk;
         put "this goes to junk"    nl;
         close;

        /*---------------------------------------------------------------eric-*/
        /*-- write some stuff to the file.  just like usual.                --*/
        /*------------------------------------------------------------9Mar 02-*/
         put "this goes to the file" nl nl;

         put "this shouldn't print:" $bar;

        /*---------------------------------------------------------------eric-*/
        /*-- write out the stuff we put in the stream earlier.              --*/
        /*------------------------------------------------------------9Mar 02-*/
         put "putstream:" nl;
         putstream junk;
         put "end putstream" nl;

         put "put with stream:" nl;
         put "here it comes" nl $$junk "there it was" nl /if exists($$junk);
         put nl;

        /*---------------------------------------------------------------eric-*/
        /*-- Put some more stuff into our original stream.                  --*/
        /*------------------------------------------------------------9Mar 02-*/
         open junk;
         put "this goes to junk too"    nl;
         close;

        /*-------------------------------------------------------eric-*/
        /*-- Create a new stream.  copy our other stream into it    --*/
        /*-- along with some other stuff.                           --*/
        /*----------------------------------------------------9Mar 02-*/

         open junk2;
         put "this is junk2" nl;
         put "with junk in it" nl;
         putstream junk;
         put "The end of junk2" nl;

        /*---------------------------------------------------------------eric-*/
        /*-- A stream can't write to it's self.  This will do an implicit   --*/
        /*-- close.  Which redirects the output back to the output file.    --*/
        /*------------------------------------------------------------9Mar 02-*/
         putstream junk2;

        /*---------------------------------------------------------------eric-*/
        /*-- Set our user variable 'foo' to it's self plus some other stuff.--*/
        /*------------------------------------------------------------9Mar 02-*/
         set $foo "This is the first foo: " $foo ", Here's some more:" " Operator is:" operator;
         put nl $foo nl nl;

        /*---------------------------------------------------------------eric-*/
        /*-- putvars.  List all the variables in the variable group using   --*/
        /*-- the format given.  like put in a loop.                         --*/
        /*--                                                                --*/
        /*-- Valid groups are:                                              --*/
        /*--                                                                --*/
        /*-- User   :  user variabls like $foo above.                       --*/
        /*-- Event  :  all the builtin variables that aren't in styles.     --*/
        /*-- Style  :  all the style variables as defined in the ODS styles.--*/
        /*-- Dynamic:  Dynamic variables which are created internally       --*/
        /*--           within sas.  Graph and statgraph do this a lot.      --*/
        /*--           currently only the variables created by statgraph    --*/
        /*--           will show up.  This is because statgraph gives their --*/
        /*--           dynamic variables as an associative array.  Graph    --*/
        /*--           currently uses a more complex callback method which  --*/
        /*--           prevents the tagset from knowing any of the dynamic  --*/
        /*--           variable names.                                      --*/
        /*------------------------------------------------------------9Mar 02-*/
         put nl "User variables:" nl;
         putvars user "<" _name_ ">" _value_ "</" _name_ ">" nl;

         put nl "Event variables:" nl;
         putvars event "<" _name_ ">" _value_ "</" _name_ ">" nl;

         put nl "Style variables:" nl;
         putvars style "<" _name_ ">" _value_ "</" _name_ ">" nl;

         put nl "Dynamic variables:" nl;
         putvars dynamic "<" _name_ ">" _value_ "</" _name_ ">" nl;

        /*---------------------------------------------------------------eric-*/
        /*-- if we are currently writing to a stream the output will be     --*/
        /*-- switched to the output file when putvars get's to that stream. --*/
        /*-- Just like the implicit close in the xample above.              --*/
        /*------------------------------------------------------------9Mar 02-*/
         open junk3;
         close;
         
         put nl "Stream variables:" nl;
         putvars stream "<" _name_ ">" _value_ "</" _name_ ">" nl;

         put nl "putstream:" nl;
         putstream junk;

        /*--------------------------------------------------------------eric-*/
        /*-- We can force a flush of the file buffers.  This isn't really  --*/
        /*-- necessary much.  But if you want to do crazy twisted things   --*/
        /*-- like have more than one file write to the same stream it      --*/
        /*-- will be.  It could also be handy if you want to write more    --*/
        /*-- than one file to the same fileref. Franke Poppe's DDE tagset  --*/
        /*-- could benefit from this.                                      --*/
        /*-----------------------------------------------------------9Mar 02-*/
         put nl "We are going to flush this" nl;
         flush;
         
        /*---------------------------------------------------------------eric-*/
        /*-- Delete the stream.  This will happen automatically when the    --*/
        /*-- ODA closes.  But we can force it too.                          --*/
        /*------------------------------------------------------------9Mar 02-*/

         put nl "delstream:" nl;
         unset $$junk;

        /*---------------------------------------------------------------eric-*/
        /*-- junk is gone so we shouldn't get anything but the label here.  --*/
        /*------------------------------------------------------------9Mar 02-*/

         put nl "putstream junk:" nl;
         putstream junk;

         put nl;

        /*-------------------------------------------------------eric-*/
        /*-- You can't set $$variables.  That would not be good.  For--*/
        /*-- consistency the label won't be assigned either.  just as--*/
        /*-- if the $$variable had no value.  $$junk would cause a  --*/
        /*-- syntax error.                                          --*/
        /*----------------------------------------------------10Mar02-*/
         set $bar "this is junk " $junk "junk shouldn't be in here. just this.";
         put $bar nl nl;

         /*------------------------------------------------------eric-*/
         /*-- You can set a stream. It will open the stream and     --*/
         /*-- append the junk to it.  Then close it. It's like a    --*/
         /*-- combination open, put, and close.                     --*/
         /*---------------------------------------------------10Mar02-*/
         
         set $$junk4 "this is weird" " but it should work";

        /*---------------------------------------------------------------eric-*/
        /*-- In order to keep putting stuff in junk4 we have to open it or  --*/
        /*-- keep doing sets.  put is a lot nicer than set...               --*/
        /*------------------------------------------------------------10Mar02-*/
         open junk4;
         
         put nl "some more stuff for junk4" nl;
         
        /*---------------------------------------------------------------eric-*/
        /*-- A set removes anything that was previously in the stream and   --*/
        /*-- starts over with what is given.                                --*/
        /*------------------------------------------------------------12Mar02-*/
         set $$junk4 "reset junk4"; 

         putstream junk4;

         unset $$junk4;
         

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

        /*---------------------------------------------------------------eric-*/
        /*-- check to see if foo has the string "first" in it anywhere      --*/
        /*------------------------------------------------------------12Mar02-*/
         put "first is in foo" nl/if contains($foo, "first");

         set $foo "this is foo";
      
         put "foo has is" nl /if contains($foo, "is");
         put "foo does not have jabberwocky" nl /if !contains($foo, "jabberwocky");


         put "foo exists" nl/if exists($foo);
         put "junk exists" nl/if exists($$junk);
         put "foo or junk exist" nl/if any($foo);
         put "foo says hello" nl/if cmp('hello', $foo);

         /*------------------------------------------------------eric-*/
         /*-- This is a syntax error.  you can't compare a stream.  --*/
         /*---------------------------------------------------12Mar02-*/
         /*put "hello" /if cmp('hello', $$junk4);*/
         
        /*-------------------------------------------------------eric-*/
        /*-- We can delete a stream with unset too.                 --*/
        /*----------------------------------------------------9Mar 02-*/
         unset $$junk2;
         put nl "put deleted junk2:" nl;
         put $$junk2;
         
        /*---------------------------------------------------------------eric-*/
        /*-- So let's see what's left of our streams.  we still have an     --*/
        /*-- empty stream called junk3.                                     --*/
        /*------------------------------------------------------------9Mar 02-*/
         put nl "Stream variables:" nl;
         putvars stream "<" _name_ ">" _value_ "</" _name_ ">" nl;

         /* this is a real delete of an Istore stream */
         delstream junk4;
         

      end;    
  end;
run;


ods tagsets.foo file="strmtest.txt";
ods tagsets.foo close;

           
