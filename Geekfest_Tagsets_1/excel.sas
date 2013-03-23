%*--------------------------------------------------------------------*
 | MACRO:                                                             |
 |   DS2EXCEL                                                         |
 |                                                                    |
 | INPUT:                                                             |
 |   DSN       - DATASET TO CONVERT                                   |
 |   FILEDD    - FILEREF TO HOLD THE EXCEL FILE                       |
 |   EXISTS    - SET TO YES IF DD WAS DEFINED OUTSIDE MACRO           |
 |   FIELDS    - FIELDS REQUIRING CUSTOM FORMATS SEPERATED BY SPACES  |
 |   FORMATS   - CUSTOM EXCEL FORMATS SEPERATED BY SPACES             |
 |   VAR       - ALLOWS USER TO LIMIT AND REORDER FIELDS WRITTEN      |
 |   INCLUDE_TITLE - Flag indicating if title lines should be written |
 |                                                                    |
 | DESCRIPTION:                                                       |
 |   CREATE A EXCEL READABLE TABLE OUT OF AN INPUT DATASET            |
 |                                                                    |
 | INTENDED USE:                                                      |
 |   USE THIS MACRO TO CONVERT A DATASET TO AN EXCEL READABLE FORMAT  |
 |                                                                    |
 | NOTE:                                                              |
 |   THE LIST OF FILEDS AND FORMATS MUST MATCH ONE TO ONE.            |
 |                                                                    |
 *--------------------------------------------------------------------*
 |                          MAINTANCE LOG                             |
 *--------------------------------------------------------------------*
 | ISSUE #  LANID     DATE        DESCRIPTION                         |
 *--------------------------------------------------------------------*
 | SB40932  BCKEANE   06/07/2001  CREATE MACRO                        |
 | SB40932  SEBENNET  06/07/2001  CREATE MACRO(BASED ON BFQUERY USE)  |
 | SB33349  SEBENNET  12/17/2001  Added remove_ltgt_signs as input    |
 | SB35062  BMLITTNE  12/19/2001  Fixed logic error with empty dsn    |
 | SB39960  SEBENNET  01/13/2002  Fixed remove_ltgt_signs             |
 | SB70682  SEBENNET  02/05/2002  Added INCLUDE_TITLE option          |
 *--------------------------------------------------------------------*;

%MACRO DS2EXCEL
       (DSN=&SYSLAST
       ,FILEDD=DS2EXCEL
       ,EXISTS=NO
       ,FIELDS=
       ,FORMATS=
       ,VAR=
       ,REMOVE_LTGT_SIGNS=N
       ,INCLUDE_TITLE=N
       )
       /
    /* STORE */
       DES='CONVERT DATASET TO EXCEL'
       ;
  %LOCAL ZEROS;
  %LET ZEROS=00000000000000000000000000000000;

  %*---------------------------*
   | ABEND IF SAS VERSION < 8  |
   *---------------------------*;
  %IF "&SYSVER" LT "8.00" %THEN %DO;
   %PUT ERROR: DS2EXCEL;
   %PUT ERROR: YOU ARE CALLING DS2EXCEL FROM SAS VERSION THAT IS PRE 8;
   %PUT ERROR: DS2EXCEL IS NOT SUPPORTED IN SAS V&SYSVER;
   %GOTO EXIT;
  %END;

  %*----------------------------------------------*
   | DEFINE THE TEMP FILE TO HOLD THE COPIED DATA |
   *----------------------------------------------*;
  %IF &EXISTS = NO %THEN %DO;
   FILENAME &FILEDD TEMP;
  %END;

  %*------------------------------------------*
   | CHECK TO SEE IF THE SOURCE FILE IS EMPTY.|
   | IF THE FILE IS EMPTY WRITE OUT MESSAGE   |
   | AND GOTO THE END OF THE MACRO.           |
   *------------------------------------------*;
  %LET DSID = %SYSFUNC(OPEN(&DSN));
  %IF &DSID %THEN %DO;
   %LET NOBS = %SYSFUNC(ATTRN(&DSID,NOBS));
   %LET RC = %SYSFUNC(CLOSE(&DSID));
   %IF &RC %THEN %DO;
    %PUT ERROR: Unable to close &DSN after check OBS count.;
    %GOTO EXIT;
   %END;
  %END;
  %ELSE %DO;
   %PUT ERROR: Unable to open &DSN to check for OBS count.;
   %PUT ERROR: &DSN may be missing or invalid DSN.;
   %GOTO EXIT;
  %END;
  %IF &NOBS = 0 %THEN %DO;
   %PUT NOTE: %TRIM(&DSN) has no observations to convert to Excel.;
   %GOTO EXIT;
  %END;

  %*--------------------------*
   | PROCESS THE TEMPLATES    |
   *--------------------------*;
  %TEMPLATE(XLS)

  %*------------------------------*
   | CHECK USER INPUT FOR LIBNAME |
   *------------------------------*;
  %LET DSN=&DSN;
  %LET TMP=%INDEX(&DSN,%STR(.));
  %IF &TMP %THEN %DO;
   %LET LIB = "%SUBSTR(&DSN,1,%EVAL(&TMP-1))";
   %LET MEM = %SUBSTR(&DSN,%EVAL(&TMP+1),%EVAL(%LENGTH(&DSN)-&TMP));
  %END;
  %ELSE %DO;
   %LET LIB = 'WORK','USER';
   %LET MEM = &DSN;
  %END;

  %*------------------------------------*
   | PROCESS USER CUSTOM  EXCEL FORMATS |
   *------------------------------------*;
  %LOCAL WORD;
  %LET WORD=1;
  %LOCAL NM;
  %LET NM=%SCAN(&FIELDS,&WORD,%STR( ));
  DATA;
    FORMAT CUSTNAME $CHAR32. CUSTFORMAT $CHAR200.;
    %DO %WHILE(&NM NE %STR());
     CUSTNAME="&NM";
     CUSTFORMAT="%SCAN(%SUPERQ(FORMATS),&WORD,%STR( ))";
     OUTPUT;
     %LET WORD=%EVAL(&WORD+1);
     %LET NM=%SCAN(&FIELDS,&WORD,%STR( ));
    %END;
    STOP;
  RUN;
  %LET CUSTFMTS=&SYSLAST;

  %*-------------------*
   | PROCESS VAR INPUT |
   *-------------------*;
  %IF &VAR ^= %STR() %THEN %DO;
   DATA;
     FORMAT VARNAME $CHAR32.;
     %LET WORD=1;
     %LET NM=%SCAN(&VAR,&WORD,%STR( ));
     %DO %WHILE(&NM NE %STR());
      VARNAME="&NM";
      VARNUM=&WORD;
      OUTPUT;
      %LET WORD=%EVAL(&WORD+1);
      %LET NM=%SCAN(&VAR,&WORD,%STR( ));
     %END;
     STOP;
   RUN;
  %END;

  %*-------------------*
   | SELECT DSN INFO   |
   *-------------------*;
  PROC SQL NOPRINT;

    SELECT
    %IF &VAR ^= %STR() %THEN %DO;
           A.VARNUM
    %END;
    %ELSE %DO;
           VARNUM
    %END;
         , FORMAT
         , TYPE
         , CUSTFORMAT
    INTO   :TEMP
         , :FMT1   - :FMT99999
         , :TYPE1   - :TYPE99999
         , :CUST1   - :CUST99999
    FROM   DICTIONARY.COLUMNS
     LEFT  JOIN &CUSTFMTS
     ON    NAME = CUSTNAME
    %IF &VAR ^= %STR() %THEN %DO;
     INNER JOIN &SYSLAST A
     ON    NAME = VARNAME
    %END;
    WHERE  LIBNAME IN (&LIB)
      AND  MEMNAME = "&MEM"
    ORDER BY 1
    ;
    %LET FMT=&SQLOBS;

  QUIT;

  %*-------------------------------*
   | DEFINE CUSTOM TEMPLETE FOR DSN|
   *-------------------------------*;
  PROC TEMPLATE;
    DEFINE TAGSET TAGSETS.DS2EXCEL;
     PARENT=TAGSETS.XLS;

     %IF &INCLUDE_TITLE = Y %THEN %DO;
      DEFINE EVENT SYSTEM_TITLE;
        PUT "<H1";
        TRIGGER ALIGN;
        PUT ">";
        PUT VALUE;
        PUT "</H1>" CR;
      END;
     %END;

     DEFINE EVENT XLSFMT;
      %DO Y = 1 %TO &FMT;
       %IF %UPCASE(&&TYPE&Y) = CHAR %THEN
        %LET EXCELFORMAT = %STR(@);
       %ELSE %IF %INDEX(%UPCASE(&&FMT&Y),DATETIME) = 1 %THEN
        %LET EXCELFORMAT = %STR(@);
       %ELSE %IF %INDEX(%UPCASE(&&FMT&Y),DATE) = 1 %THEN
        %LET EXCELFORMAT = %STR(@);
       %ELSE %IF %UPCASE(&&FMT&Y) = %STR(YYMMDD10.) %THEN
        %LET EXCELFORMAT = %STR(YYYY-MM-DD);
       %ELSE %IF %UPCASE(&&TYPE&Y) = NUM
       AND %LENGTH(&&FMT&Y) > %INDEX(&&FMT&Y,.)
       %THEN %DO;
        %IF %SUBSTR(&&FMT&Y,%INDEX(&&FMT&Y,.)+1) > 3 %THEN
         %LET EXCELFORMAT
            = 0.%SUBSTR(&ZEROS,1,%SUBSTR(&&FMT&Y,%INDEX(&&FMT&Y,.)+1));
        %ELSE
         %LET EXCELFORMAT =;
       %END;
       %ELSE
        %LET EXCELFORMAT =;
       %IF %SUPERQ(CUST&Y) ^= %STR() %THEN
        %LET EXCELFORMAT = %SUPERQ(CUST&Y);
       %IF &EXCELFORMAT ^= %STR() %THEN %DO;
        PUT 'STYLE="vnd.ms-excel.numberformat:' /
            IF CMP(COLSTART,"&Y");
        PUT "&EXCELFORMAT" /
            IF CMP(COLSTART,"&Y");
        PUT '" ' /
            IF CMP(COLSTART,"&Y");
       %END;
      %END;
     END;

     DEFINE EVENT DATA;
      START:
       PUT '<TD ';
       TRIGGER XLSFMT / IF !CMP(SECTION,'head');
       TRIGGER ROWCOL;
       PUT "><NOBR>";
       PUT VALUE;
      FINISH:
       PUT "</NOBR></TD>" CR;
     END;

    END;
  RUN;

  %*---------------------------------------*
   | USE ODS TO CREATE MARKUP CODE FOR XLS |
   *---------------------------------------*;
  ODS LISTING CLOSE;
  ODS PHTML
      TAGSET=TAGSETS.DS2EXCEL
  %IF &REMOVE_LTGT_SIGNS NE N %THEN %DO;
   %PUT NOTE: GENERATEING TEMP FILE TO HOLD EXCEL REPORT.;
   %LOCAL FILE_REF;
   %IF %SYSFUNC(FILENAME(FILE_REF,,TEMP)) %THEN %DO;
    %PUT ERROR: COULD NOT DEFINE TEMP EXCEL FILE.;
    %PUT %SYSFUNC(SYSMSG());
    %GOTO %EXIT;
   %END;
      FILE=&FILE_REF
  %END;
  %ELSE %DO;
      FILE=&FILEDD
  %END;
      RECORD_SEPARATOR=NONE
      NOGTITLE
      ;

  PROC PRINT DATA=&DSN NOOBS LABEL;
    %IF &VAR ^= %STR() %THEN %DO;
     VAR &VAR;
    %END;
  RUN;

  ODS PHTML CLOSE;
  ODS LISTING;

  %*-----------------------------*
   | CONVERT <> TO 60 AND 62     |
   *-----------------------------*;
  %IF &REMOVE_LTGT_SIGNS NE N %THEN %DO;
   DATA _NULL_;
     INFILE &FILE_REF;
     FILE &FILEDD;
     INPUT;
     LINE_LNGTH = LENGTH(_INFILE_);
     FORMAT LINE_TX $VARYING32767. LINE_LNGTH;
     START = INDEX(_INFILE_,'<NOBR>');
     END = INDEX(_INFILE_,'</NOBR>');
     IF START AND END THEN DO;
      START + 6;
      Y = START;
      END = END - 1;
      LINE_TX = _INFILE_;
      DO X = START TO END;
       IF SUBSTR(_INFILE_,X,1) = '<' THEN DO;
        SUBSTR(LINE_TX,Y) = '&#60;';
        LINE_LNGTH + 4;
        Y + 5;
       END;
       ELSE IF SUBSTR(_INFILE_,X,1) = '>' THEN DO;
        SUBSTR(LINE_TX,Y) = '&#62;';
        Y + 5;
       END;
       ELSE DO;
        SUBSTR(LINE_TX,Y) = SUBSTR(_INFILE_,X,1);
        LINE_LNGTH + 4;
        Y + 1;
       END;
      END;
      SUBSTR(LINE_TX,Y) = SUBSTR(_INFILE_,END + 1);
      PUT LINE_TX;
     END;
     ELSE
      PUT _INFILE_;
   RUN;
  %END;

  %EXIT:

%MEND DS2EXCEL;
