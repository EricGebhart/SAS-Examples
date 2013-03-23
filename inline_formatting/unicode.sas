/*

Unicode Characters
 
You can now use the 'unicode' inline formatting function to select 
any available unicode character in the current unicode font. Simply 
supply it with the HEX value of the character that you want.

Note: Fonts will not have every character, so you'll have to see what 
      characters your font has using the MS Windows Character Map 
      accessory or a similar application.

*/

proc fontreg mode=all;
   fontpath 'c:\winnt\fonts';
run;

/* Change unicode font to something with more characters in it */
/* Copy this to 'unicode.sasxreg' */
/*
[ODS\DESTINATIONS\PRINTER]
"Unicode Font"="Arial Unicode MS"
*/
proc registry import = 'unicode.sasxreg'; run;

ods escapechar='^';

/* Create a table of unicode characters */
data work.unicode;
input @1 name $25. @27 value $4.; 
datalines;
Snowman                   2603
Black Knight              265E
White Rook                2656
Snowflake                 2744
Two Fifths                2156
Greater Than or Equal To  2267
;

/* Create table that will show the name, unicode value, and actual symbol */
proc template;
define table unitable;
    define column name;
        header = 'Name';
    end;
    define column value;
        style={textalign=center};
        header = 'Value';
    end;
    define column symbol;
        style={textalign=center};
        header = 'Symbol';
        compute as '^{unicode ' || value || '}';
    end;
end;
run;

/* Make the fonts big */
proc template;
define style styles.bigprinter; parent=styles.printer;
    class systemtitle, data, header /
        fontsize = 40pt
    ;
end;
run;

/* Generate report */
ods pdf file="unicode.pdf" style=styles.bigprinter;

data _null_;
    set work.unicode;
    file print ods=(template='unitable');
    put _ods_;
run;

ods pdf close;

ods listing; title; footnote;
