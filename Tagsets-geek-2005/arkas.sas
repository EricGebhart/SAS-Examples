proc template;
    define tagset tagsets.arkas;
    parent=tagsets.html4;
    
        define event image;

            put '<div';
            trigger alt_align;
            put '>' nl;
            put "<table";
            put ' background="arkas_kleenex.jpg"' /if exists($first_graph);
            put ' background="arkas_80.gif"' /if !exists($first_graph);
            set $first_graph "true";
            put ' summary="Page Layout"';
            put "><tr><td>" CR;
            put "<img";
            putq ' alt=' alt;
            put ' src="';
            put BASENAME / if !exists(NOBASE);
            put URL;
            put '"';
            put ' style="' /if any(outputheight, outputwidth);
            put "height:" OUTPUTHEIGHT ";" /if exists(outputheight);
            put " width:" OUTPUTWIDTH ";" /if exists(outputwidth);
            put '"' /if any(outputheight, outputwidth);
            put ' border="0"';
            put ' usemap="#' @CLIENTMAP;
            put ' usemap="#' NAME / if !exists(@CLIENTMAP);
            put '"' / if any(@CLIENTMAP , NAME);
            putq " id="    HTMLID;
            trigger classalign;
            put $empty_tag_suffix;
            put ">" CR;
            put "</td></tr></table>" CR;
            put "</div>" CR;
        end;

        define event simple_table;
          start:
            put '<table cellpadding="7">' nl;
          finish:
            put "</table>" nl;
        end;
    
        define event simple_cell;
          start:
            put "<td>" nl;
          finish:
            put "</td>" nl;
        end;
    
        define event arkas_intro;
        put '<div style="font-size: large; text-align: left;">';
        put "This is Arkas my 7 month old maremma sheepdog.  He had a rough start in life.  At 7 days old ";
        put "all of his siblings had died and his mother was very sick.  Arkas nearly died in that second ";
        put "week.  But as you can see he is doing fine now.  ";
        put "Maremma sheepdogs are from the Maremma and Abruzzese regions of Italy.  The breed's full name is ";
        put "Pastore Il Maremma-Abruzzese.  The Maremma is related to the few other big white dogs of the world.";
        put "The Maremma is most similar to the Great Pyrenees, and Kuvaz.  Maremma's supposedly top out at 100 lbs."; 
        put "But there is a lot of variation since the breed standard is really about two different dogs, the one "; 
        put "from Maremma, and the one from Abruzzese.  The dogs from Abruzzes can be very big, up to 100 kg.  ";
        put "All of the BWD's have the same job, guarding livestock.  The dogs are bonded to the livestock and live ";
        put "with them full time.  They don't herd so much as lead and guard.  They are very easy going and somewhat ";
        put "lazy in their apparant behavior.";
        put '</div>' nl;
        end;
    
        define event arkas_small;
        put '<div style="font-size: large; text-align: left; text-valign: middle;">';
        put "It's hard to believe how small Arkas was.  Or how fast he grew...";
        put "Here's a picture from his second week.  The picture under the chart is from his 22nd week " nl;
        put "when he only weighed 83 lbs.";
        put '<img align="center" src="arkas_small.jpg">' nl;
        put '</div>' nl;
        end;
        
        define event arkas_weight;
        put '<div style="font-size: large; text-align: left; text-valign: middle;">';
        put "I've kept track of Arkas' weight since his first day.  In the beginning it was critical that we know if ";
        put "he was gaining weight or not.  Later the weekly trip to the vet was just to keep him happy about going to ";
        put "to the vet.  He has grown really fast but he seems to be slowing down a bit.  He is already bigger than his ";
        put "his father, and what the breed standard says.  He won't be full grown until 2 years of age so he has a ways";
        put " to go.";
        put '</div>' nl;
        end;

        define event arkas_height;
        put '<div style="font-size: large; text-align: left; text-valign: middle;">';
        put "I didn't keep a close track on Arkas' height, so the chart on the left has a lot of missing values";
        put "Arkas shouldn't get much taller.  He's already 27 inchess tall at the whithers.  Almost desk height.  He ";
        put "might make it ";
        put "to 29 inches.   At this point he can easily scan the coffee table for kleenex.";
        put "  Standing up on hind legs ";
        put "he can almost see over anything I can.  The picture under the graph is from when he was 4 weeks old.  ";
        put "This is about the time he figured out a kleenex box is an endless supply of tissues. ";
        put "</div>";
        end;

        define event whitespace;
            put "<br><br>" nl;
        end;

        define event div;
           put "<div";
           put ' class="c ' htmlclass '">';
           put text;
           put "</div>" nl;
        end;
         
        define event pagebreak;
        end;

    end;
run;




  /*-- Close Monospace ODA --*/
  /*-------------------------*/
  ods listing close;


  /*-- create data set Growth --*/
  /*----------------------------*/
  data Growth;
    length date $ 5;
    input week date weight height;
    cards;
1  8-28   1.125 .
2  9-3    1.777 .
3  9-11   3.7  . 
4  9-18   6.5  7
5  9-26   9.7  .
6  10-05  14   .
7  10-12  18   .
8  10-19  20.9 .
9  10-26  24.9 .
10 11-02  29   13 
11 11-02  33.2 .
12 11-16  37   .
13 11-22  40.6 .
14 11-30  45.3 19 
15 12-07  51.9 20
16 12-14  54.5 .
17 12-21  58.3 .
18 12-27  64.5 .
19 01-04  68.5 .
20 01-10  69.8 .
21 01-18  76   .
22 01-25  79.8 .
23 02-01  83.0 .
24 02-08  87.3 .
25 02-15  89.8 25
26 02-22  94.3 26
27 03-01  97.4 26.5
28 03-08  100.4 27
29 03-15  102.5 27
    
  run;


  /*-- Dev = GIF --*/
  /*--------------*/

  goptions extension=grf dev=gif;

  title;
  

  ods tagsets.arkas nogtitle file="arkas.html";

  ods tagsets.arkas event=div(style=systemtitle text="Arkas, my Maremma-Abruzzes Puppy");

  ods tagsets.arkas event=simple_table(start);
  ods tagsets.arkas event=row(start);
  ods tagsets.arkas event=simple_cell(start);
  ods tagsets.arkas event=arkas_intro;
  ods tagsets.arkas event=simple_cell(finish);
  ods tagsets.arkas event=row(finish);
  ods tagsets.arkas event=simple_table(finish);
  
  ods tagsets.arkas event=simple_table(start);
  ods tagsets.arkas event=row(start);
  ods tagsets.arkas event=simple_cell(start);

  ods tagsets.arkas event=div(style=systemtitle text="Arkas' Growth");
  ods tagsets.arkas event=arkas_small;
  ods tagsets.arkas event=arkas_weight;

  ods tagsets.arkas event=simple_cell(finish);
  ods tagsets.arkas event=simple_cell(start);
  ods tagsets.arkas event=whitespace;
  
  goptions reset=global border
         cback=black
         colors=(black blue green red)
         ftitle=swissb ftext=swiss htitle=6
         transparency
         vpos=150 hpos=250
         htext=4;  

  /* /home/eric/pp/s0174799/arkas_80.gif */

  proc gplot data=growth;
    symbol cv=yellow ci=yellow v=circle interpol=join width=2 height=2;

    axis1 
      offset=(3,3)
      color=yellow
      label=('Age in Weeks')
      major=(height=3 width=2)
      minor=(number=6 color=white height=2 width=1)
      width=3;

    axis2 color=yellow
      label=('Weight')
      major=(height=3)
      minor=(number=4 color=white height=1);
    

    axis3 color=yellow
      label=('Height')
      major=(height=3)
      minor=(number=4 color=white height=1);

    plot weight*week / haxis=axis1
                   vaxis=axis2
                    vref=(20 40 60 80 100) ;
    
    run;

  ods tagsets.arkas event=simple_cell(finish);
  ods tagsets.arkas event=row(finish);
  ods tagsets.arkas event=simple_table(finish);

  ods tagsets.arkas event=whitespace;
  ods tagsets.arkas event=simple_table(start);
  ods tagsets.arkas event=row(start);

  ods tagsets.arkas event=simple_cell(start);
  ods tagsets.arkas event=whitespace;
  ods tagsets.arkas event=whitespace;
  
    plot height*week / haxis=axis1
                   vaxis=axis3
                   vref=(10 20) ;
    
    run;
  quit;
  ods tagsets.arkas event=simple_cell(finish);
  ods tagsets.arkas event=simple_cell(start);
  

  ods tagsets.arkas event=whitespace;
  ods tagsets.arkas event=whitespace;
  ods tagsets.arkas event=whitespace;
  ods tagsets.arkas event=whitespace;
  ods tagsets.arkas event=div(style=systemtitle text="Arkas' height");
  ods tagsets.arkas event=arkas_height;
  ods tagsets.arkas event=simple_cell(finish);

  
  ods tagsets.arkas event=row(finish);
  ods tagsets.arkas event=simple_table(finish);

  ods _all_ close;


