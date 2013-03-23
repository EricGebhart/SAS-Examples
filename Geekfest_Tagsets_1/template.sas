%*--------------------------------------------------------------------*
 | MACRO:                                                             |
 |   TEMPLATE                                                         |
 |                                                                    |
 | INPUT:                                                             |
 |   TEMPLATE - Name(s) of the PROC TEMPLATE the user wants run.      |
 |   DEBUG - Indicate if in debug mode.                               |
 |                                                                    |
 | DESCRIPTION:                                                       |
 |   This macro will run predefined PROC TEMPLATE statements.         |
 |                                                                    |
 | INTENDED USE:                                                      |
 |   This macro is to be used by SAS v8+.                             |
 |                                                                    |
 | NOTE:                                                              |
 |                                                                    |
 |                                                                    |
 *--------------------------------------------------------------------*
 |                          MAINTANCE LOG                             |
 *--------------------------------------------------------------------*
 | ISSUE #  LANID     DATE        DESCRIPTION                         |
 *--------------------------------------------------------------------*
 | SB00000  SEBENNET  06/12/2001  Created                             |
 | SB77562  SEBENNET  05/30/2002  Added CSVTBA                        |
 *--------------------------------------------------------------------*;

%MACRO TEMPLATE
       (TEMPLET
       ,DEBUG=NO
       )
       /
    /* STORE */
       DES='Predefined PROC TEMPLATEs'
       ;

  %IF "&SYSVER" LT "8.00" %THEN %DO;
   %PUT ERROR: TEMPLATE;
   %PUT ERROR: You are calling TEMPLATE from SAS version that is pre ;
   %PUT ERROR: v8.0, TEMPLATE is not supported in SAS v&SYSVER;
   %GOTO EXIT;
  %END;

  %*----------------------*
   | Get SAS options used |
   *----------------------*;
  %LOCAL NOTES;
  %LET NOTES = %SYSFUNC(GETOPTION(NOTES));
  %IF &DEBUG = NO %THEN %DO;
   OPTIONS NONOTES;
  %END;

  %IF &TEMPLET ^= %STR() %THEN %DO;
   %LET WORD = 1;
   %LET TEMPLATE_NAME = %SCAN(&TEMPLET,&WORD,%STR( ));
   %DO %WHILE(&TEMPLATE_NAME ^= %STR());
    %IF &TEMPLATE_NAME = XLS %THEN %DO;
     PROC TEMPLATE;
       DEFINE STYLE STYLES.XLS;
         PARENT=STYLES.DEFAULT;
         REPLACE COLOR_LIST /
              "WHITE"  = CXFFFFFF
              "BLACK"  = CX000000
              "RED"    = CX440044
         ;
         REPLACE COLORS /
               "DOCBG"          = COLOR_LIST("WHITE")
               "DOCFG"          = COLOR_LIST("BLACK")
               "CONTENTBG"      = COLOR_LIST("WHITE")
               "CONTENTFG"      = COLOR_LIST("BLACK")
               "LINK1"          = COLOR_LIST("BLACK")
               "LINK2"          = COLOR_LIST("BLACK")
               "CONTITLEFG"     = COLOR_LIST("BLACK")
               "CONFOLDERFG"    = COLOR_LIST("BLACK")
               "CONENTRYFG"     = COLOR_LIST("BLACK")
               "SYSTITLEBG"     = COLOR_LIST("WHITE")
               "SYSTITLEFG"     = COLOR_LIST("BLACK")
               "TITLEBG"        = COLOR_LIST("WHITE")
               "TITLEFG"        = COLOR_LIST("BLACK")
               "CAPTIONBG"      = COLOR_LIST("WHITE")
               "CAPTIONFG"      = COLOR_LIST("BLACK")
               "PROCTITLEBG"    = COLOR_LIST("WHITE")
               "PROCTITLEFG"    = COLOR_LIST("BLACK")
               "BYLINEBG"       = COLOR_LIST("WHITE")
               "BYLINEFG"       = COLOR_LIST("BLACK")
               "NOTEBG"         = COLOR_LIST("WHITE")
               "NOTEFG"         = COLOR_LIST("BLACK")
               "TABLEBG"        = COLOR_LIST("WHITE")
               "TABLEBORDER"    = COLOR_LIST("BLACK")
               "BATCHFG"        = COLOR_LIST("BLACK")
               "BATCHBG"        = COLOR_LIST("WHITE")
               "DATABG"         = COLOR_LIST("WHITE")
               "DATAFG"         = COLOR_LIST("BLACK")
               "DATABGSTRONG"   = COLOR_LIST("WHITE")
               "DATAFGSTRONG"   = COLOR_LIST("BLACK")
               "DATABGEMPH"     = COLOR_LIST("WHITE")
               "DATAFGEMPH"     = COLOR_LIST("BLACK")
               "HEADERBG"       = COLOR_LIST("WHITE")
               "HEADERFG"       = COLOR_LIST("BLACK")
               "HEADERBGSTRONG" = COLOR_LIST("WHITE")
               "HEADERFGSTRONG" = COLOR_LIST("BLACK")
               "HEADERBGEMPH"   = COLOR_LIST("WHITE")
               "HEADERFGEMPH"   = COLOR_LIST("BLACK")
         ;

         REPLACE FONTS /
           'TITLEFONT2' = ("ARIAL, HELVETICA, HELV",3)
           'TITLEFONT'  = ("ARIAL, HELVETICA, HELV",3)
           'STRONGFONT' = ("ARIAL, HELVETICA, HELV",3)
           'EMPHASISFONT' = ("ARIAL, HELVETICA, HELV",3)
           'FIXEDEMPHASISFONT' = ("ARIAL, HELVETICA, HELV",3)
           'FIXEDSTRONGFONT' = ("ARIAL, HELVETICA, HELV",3)
           'FIXEDHEADINGFONT' = ("ARIAL, HELVETICA, HELV",3)
           'BATCHFIXEDPOINT' = ("ARIAL, HELVETICA, HELV",3)
           'FIXEDFONT' = ("ARIAL, HELVETICA, HELV",3)
           'HEADINGEMPHASISFONT' = ("ARIAL, HELVETICA, HELV",3)
           'HEADINGFONT' = ("ARIAL, HELVETICA, HELV",3)
           'DOCFONT' = ("ARIAL, HELVETICA, HELV",3);

         STYLE DATA FROM DATA /
           PRETEXT='<NOBR>'
           POSTTEXT='</NOBR>';

       END;

       DEFINE TAGSET TAGSETS.XLS;
         NOTES "THIS IS HTML FOR USE IN XLS FILE";
         %LET  MAP =<>%NRSTR(&)%STR(%')%STR(%");   /*')*/
         MAP="&MAP";
         MAPSUB = '/&LT;/&GT;/&AMP;/&#39;/&QUOT;/';
         NOBREAKSPACE = '&NBSP;';
         SPLIT='<BR>';
         STACKED_COLUMNS=YES;
         OUTPUT_TYPE='HTML';

        DEFINE EVENT DOC;
            START:
                PUT "<HTML>";
                PUT "<!-- GENERATED BY BFQUERY V2.0 -->" ;
            FINISH:
                PUT "</HTML>" CR;
        END;

        DEFINE EVENT DOC_HEAD;
            START:
                PUT "<HEAD>";
            FINISH:
                PUT "</HEAD>" CR;
        END;

        DEFINE EVENT CONTENTS_HEAD;
            START:
                TRIGGER DOC_HEAD;
            FINISH:
                TRIGGER DOC_HEAD;
        END;

        DEFINE EVENT DOC_TITLE;
            PUT "<TITLE>";
            PUT "BFQUERY v2.0" / if !exists(VALUE);
            PUT VALUE;
            PUT "</TITLE>";
        END;

        DEFINE EVENT DOC_META;
            PUT "<META";
            PUT ' HTTP-EQUIV="CONTENT-TYPE" CONTENT="' /
                IF ANY(HTMLCONTENTTYPE, ENCODING);
            PUT HTMLCONTENTTYPE;
            PUT "; " / IF EXISTS(HTMLCONTENTTYPE, ENCODING);
            PUT " CHARSET=" ENCODING;
            PUT VALUE;
            PUT '">';
        END;

        DEFINE EVENT DOC_BODY;
            START:
                PUT '<BODY BGCOLOR="#FFFFFF">' ;
                PUT '<FONT  FACE="ARIAL, HELVETICA, HELV" SIZE="3"';
                PUT ' COLOR="#000000">' ;
            FINISH:
                PUT "</FONT>" ;
                PUT "</BODY>" ;
        END;

        DEFINE EVENT BREAKLINE;
            PUT "<BR>";
        END;

        DEFINE EVENT TABLE;
            START:
                PUT "<TABLE";
                PUT ' BORDER=1';
                PUT " CELLSPACING=1";
                PUT " CELLPADDING=1";
                PUT ">" CR;
            FINISH:
                PUT "</TABLE>" ;
                PUT "<BR>" ;
        END;

        DEFINE EVENT COLGROUP;
        END;

        DEFINE EVENT COLSPEC_ENTRY;
        END;

        DEFINE EVENT ROW;
            PUT '<TR>';
        FINISH:
            PUT "</TR>" CR;
        END;

        DEFINE EVENT ROWCOL;
            PUTQ " ROWSPAN=" ROWSPAN;
            PUTQ " COLSPAN=" COLSPAN;
        END;

        DEFINE EVENT ATTR_OUT;
            PUT ' ' CR;
            PUT '************' CR;
            PUTQ " EVENT_NAME="   EVENT_NAME;
            PUTQ " TRIGGER_NAME=" TRIGGER_NAME;
            PUTQ " SECTION="      SECTION;
            PUTQ " STATE="        STATE;
            PUTQ " EMPTY="        EMPTY;
            PUTQ " CLASS="        HTMLCLASS;
            PUTQ " ID="           HTMLID;
            PUTQ " TEXT="         TEXT;
            PUTQ " VALUE="        VALUE;
            PUTQ " ROWSPAN="      ROWSPAN;
            PUTQ " COLSPAN="      COLSPAN;
            PUTQ " ROW="          ROW;
            PUTQ " COLCOUNT="     COLCOUNT;
            PUTQ " COL="          COLSTART;
            PUTQ " COL_ID="       COL_ID;
            PUTQ " REF_ID="       REF_ID;
            PUTQ " NAME="         NAME;
            PUTQ " LABEL="        LABEL;
            PUTQ " CLABEL="       CLABEL;
            PUTQ " TYPE="         TYPE;
            PUTQ " RAWVALUE="     RAWVALUE;
            PUTQ " MISSING="      MISSING;
            PUTQ " PATH="         PATH;
            PUTQ " FLYOVER="      FLYOVER;
            PUTQ " INDEX="        ANCHOR;
            PUTQ ' JUST='         JUST;
            PUTQ ' VJUST='        VJUST;
            PUTQ " FONT-FACE="    FONT_FACE;
            PUTQ " FONT-SIZE="    FONT_SIZE;
            PUTQ " FONT-WEIGHT="  FONT_WEIGHT;
            PUTQ " FONT-STYLE="   FONT_STYLE;
            PUTQ " FOREGROUND="   FOREGROUND;
            PUTQ " BACKGROUND="   BACKGROUND;
            PUTQ " BACKGROUNDIMAGE=" BACKGROUNDIMAGE;
            PUTQ " LEFTMARGIN="    LEFTMARGIN;
            PUTQ " RIGHTMARGIN="   RIGHTMARGIN;
            PUTQ " TOPMARGIN="     TOPMARGIN;
            PUTQ " BOTTOMMARGIN="  BOTTOMMARGIN;
            PUTQ " BORDERCOLORDARK=" BORDERCOLORDARK;
            PUTQ " BORDERCOLORLIGHT=" BORDERCOLORLIGHT;
            PUTQ " BULLET="       BULLET;
            PUTQ " OUTPUTHEIGHT=" OUTPUTHEIGHT;
            PUTQ " OUTPUTWIDTH="  OUTPUTWIDTH;
            PUTQ " TAGATTR="      TAGATTR;
            PUTQ " HTMLSTYLE="    HTMLSTYLE;
            PUTQ " WIDTH="        WIDTH;
            PUTQ " SCALE="        SCALE;
            PUTQ " PRECISION="    PRECISION;
            PUTQ " URL="          URL;
            PUTQ " HREFTARGET="   HREFTARGET;
            PUT '************' CR;
        END;

        DEFINE EVENT DATA;
            START:
                PUT '<TD STYLE="vnd.ms-excel.numberformat:@" ';
                TRIGGER ROWCOL;
                PUT ">";
                PUT VALUE;
            FINISH:
                PUT "</TD>" ;
        END;

        DEFINE EVENT CELL_IS_EMPTY;
            PUT '&NBSP;';
        END;

       END;
     RUN;
    %END;
    %ELSE %IF &TEMPLATE_NAME = HTML %THEN %DO;
     PROC TEMPLATE;
       DEFINE STYLE STYLES.HTML;
         PARENT=STYLES.SASWEB;

         STYLE DATA FROM DATA /
           PRETEXT='<NOBR>'
           POSTTEXT='</NOBR>';
       END;
     RUN;
    %END;
    %ELSE %IF &TEMPLATE_NAME = CSVTBA %THEN %DO;
     %PUT NOTE: Defining CSVTBA tagset.;
     PROC TEMPLATE;
        DEFINE TAGSET TAGSETS.CSVTBA;
           NOTES "THIS IS THE CSV WITH TITLES AND BYLINES DEFINITION";
           PARENT = TAGSETS.CSV;
           DEFINE EVENT PROC_TITLE;
              PUT VALUE NL;
           END;
           DEFINE EVENT SYSTEM_TITLE;
              PUT VALUE NL;
           end;
           DEFINE EVENT SYSTEM_FOOTER;
              PUT VALUE NL;
           END;
           DEFINE EVENT BYLINE;
              PUT VALUE NL;
           END;
           DEFINE EVENT NOTE;
              PUT VALUE NL;
           END;
           DEFINE EVENT FATAL;
              PUT VALUE NL;
           END;
           DEFINE EVENT ERROR;
              PUT VALUE NL;
           END;
           DEFINE EVENT WARNING;
              PUT VALUE NL;
           END;
        END;
     RUN;
    %END;
    %LET WORD = %EVAL(&WORD+1);
    %LET TEMPLATE_NAME = %SCAN(&TEMPLET,&WORD,%STR( ));
   %END;
  %END;

  %EXIT:;
  OPTIONS &NOTES;

%MEND TEMPLATE;
