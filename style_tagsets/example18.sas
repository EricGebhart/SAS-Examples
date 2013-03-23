options debug=tagset_where;


proc template;
    define style styles.slider;
        parent=styles.torn;

        style table from table /
            rules=cols
            cellpadding=0
            cellspacing=0
        ;

        style slider from data /
            background = colors('headerbg')
        ;

        style bar from data /
	    backgroundimage = 'gridline58.gif'
            borderleftwidth = 1px
            borderleftstyle = solid
            borderleftcolor =  cxe5e5e5
            borderrightwidth = 1px
            borderrightstyle = solid
            borderrightcolor = cxe5e5e5
            cellpadding = 0
            borderbottomstyle = none
            preimage = 'bar.png';
        
        ;
        Style header from header /
            just = left
            vjust = top
        ;

        style last from bar  /
	    borderbottomwidth = 1px
	    borderbottomstyle = solid 
	    borderbottomcolor = cxe5e5e5
        ;

        style first from bar /
	    bordertopwidth = 1px
	    bordertopstyle = solid
	    bordertopcolor = cxe5e5e5
        ;
    end;
run;



ods tagsets.slider file='example18.html' style=slider options(doc='help' aural_headers='yes');

proc print data=sashelp.class;
    var name;
    var sex;
    var age;     
    var height / style(data) = slider[just=center tagattr="slider-80"];
    var weight / style(data) = slider[just=center tagattr="slider-150"];
run;

Proc print data=sashelp.class;
    var name;
    var sex;
    var age;     
    var height / style(data) = bar[just=left tagattr="slider-80"];
    var weight / style(data) = bar[just=left tagattr="slider-150"];
run;

Proc REPORT DATA=sashelp.class LS=138 PS=55  SPLIT="/" HEADLINE HEADSKIP CENTER nowd;

DEFINE  name / DISPLAY "Name" style=header;
DEFINE  sex / DISPLAY center "Sex";
DEFINE  age / DISPLAY   center "Age" ;
DEFINE  height / DISPLAY  center "Height" style(column)=slider[tagattr="slider-80"];
DEFINE  weight / DISPLAY  center "Weight" style(column)=slider[tagattr="slider-150"];
run;

PROC REPORT DATA=sashelp.class LS=138 PS=55  SPLIT="/" HEADLINE HEADSKIP CENTER nowd;

DEFINE  name / DISPLAY "Name" style=header;
DEFINE  sex / DISPLAY center "Sex";
DEFINE  age / DISPLAY   center "Age" ;
DEFINE  height / DISPLAY  left "Height" style(column)=bar[tagattr="slider-80"];
DEFINE  weight / DISPLAY  left "Weight" style(column)=bar[tagattr="slider-150"];
run;


  data Growth;
    length date $ 5;
    input week date weight height;
    cards;
1  8-28   1.125 .
2  9-3    1.777 .
3  9-11   -3.7  . 
4  9-18   6.5  7
5  9-26   -9.7  .
6  10-05  14   .
7  10-12  18   .
8  10-19  -20.9 .
9  10-26  24.9 .
10 11-02  29   13 
11 11-02  33.2 .
12 11-16  37   .
13 11-22  -40.6 .
14 11-30  45.3 19 
15 12-07  -51.9 20
16 12-14  54.5 .
17 12-21  58.3 .
18 12-27  -64.5 .
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

proc print;
    var week;
    var date;
    var weight / style(data) = bar[just=left tagattr="slider-102 64.5"];
    var height / style(data) = bar[just=left tagattr="slider-150"];
run;

ods tagsets.slider close;
