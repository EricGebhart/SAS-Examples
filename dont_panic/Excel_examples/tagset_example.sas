proc template;                                                               
   define style Styles.newstyle2;                                             
      style header "EntóÕe de colonne" /                                               
         font = ("Arial",3,Italic)                                           
         background = white                                                  
         foreground = black;                                                 
      style Systemtitle "Titre" /                                                           
         font = ("Arial",3,Italic)                                           
         background = red                                                    
         foreground = black;                                                 
      style Data "DonnñÆs dans cellules" /                                           
         font = ("Arial",4)                                                  
         background = red                                                    
         foreground = black
		 Borderwidth=7
		 Bordercolor=cxb5a642 ;
end;                                                                      
run;     


title "Hello"; 
footnote;

  *;
  *  Illustrate the use of split characters and column justification.
  *  Use WIDTH_FUDGE= to get slightly wider columns.
  *;

  ods listing close;

  ods tagsets.excelxp file='report.xls' style=Styles.Newstyle2 options(embedded_titles='yes' default_column_width="7.5, 7.5, 5, 7.5, 7.5" width_fudge='0.75');

  proc report data=sashelp.class nowindows split='*';
     column  name sex age height weight;
     define  name   / display   'Student*Name'    left    style={just=l cellwidth=8 cm};
     define  sex    / display   '*Gender'          right   style={just=r cellwidth=1 cm};
     define  age    / display   '*Age'            center  style={just=c cellwidth=1 cm};
     define  height / display   'Height*(inches)'   center  style={just=c cellwidth=2 cm};
     define  weight / display   'Weight*(pounds)'  center  style={just=c cellwidth=2 cm};
  run; quit;

  ods tagsets.excelxp close;
  ods listing;



