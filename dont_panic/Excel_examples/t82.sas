PROC TEMPLATE;
  DEFINE STYLE STYLES.CntPct;
    PARENT=STYLES.Minimal;
    STYLE header /
      just = CENTER
      font = ("Arial",8pt,Bold Italic);
    STYLE data /
      cellheight = 12
      font = ("Arial",8pt);
    STYLE cnt from data /
      tagattr='format:0';
    STYLE pct from data /
      tagattr='format:0.0';
  END;
RUN;

OPTIONS PAGENO=1  TOPMARGIN="0.5 IN"  BOTTOMMARGIN="0.5 IN"
LEFTMARGIN="0.5 IN"  
  RIGHTMARGIN="0.5 IN"  ORIENTATION=LANDSCAPE;

TITLE1 '&C&B&12DAWN - Lags in ED data reporting, 2006 data';
FOOTNOTE1 '&LPrinted &D&RPage &P of &N';

ODS LISTING CLOSE;
ODS RESULTS OFF;
ODS TAGSETS.ExcelXP STYLE=CntPct FILE='t82.xls'

OPTIONS (
    frozen_headers='1'  autofilter='all'  row_repeat='1'  scale='80'
    Sheet_Name='ED Data Lags'
    orientation='Landscape'  center_horizontal='yes'
    Gridlines='yes'  Print_Header_margin='0.25'
    Print_Footer_margin='0.25'
);

proc print data=sashelp.class;run;

ODS TAGSETS.ExcelXP CLOSE;
ODS RESULTS ON;
ODS LISTING;

