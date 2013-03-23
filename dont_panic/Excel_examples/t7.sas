ods listing close;
ods tagsets.excelxp file='t7.xls'
options(embedded_titles='yes' 
         embedded_footnotes='yes'
         center_horizontal='yes' 
         center_vertical='yes'         
         row_repeat = '4-5' 
         column_repeat='1-2'
         /*row_repeat = '5' */
         /*debug_level = '3'*/
         Print_Header = '&amp;LLeft Header Text&amp;CCenter Header Text&amp;RRight Header Text'
         Print_Footer = '&amp;LLeft Footer Text&amp;CCenter Footer Text&amp;RRight Footer Text'
         frozen_rowheaders = '3'
         frozen_headers = '6'  
         left_to_right = 'yes' 
         pages_fitwidth = '3' 
         pages_fitheight = '4' 
         doc='help'
        );

  title1 'My first title';
  title3 'My third title';
  footnote1 'My first footnote';
  footnote3 'My third footnote';
  proc print data=sashelp.class(obs=5); run; quit;
ods _all_ close;
