proc template;
  define style styles.SUGI31;
    parent = styles.Journal;
      style vertical_header from header /
            tagattr = 'rotate:45'
	
        ;
      style byline from byline /
            fontsize = 15pt
        ;

  end;

run;

ods html file="temp.html";

ods tagsets.ExcelXP file="temp.xls" options(
              sheet_interval="none"
              row_heights="110"
              skip_space="5") style=sugi31;

		  proc sort data=sashelp.class;
		  by sex;

          proc tabulate data=sashelp.class
          order=data missing format=8.0 noseps formchar=',          ';
             by sex;
             class age sex name;
             classlev name /s=vertical_header;
             var height weight;
             title;
             table age,  name=' '*(height=' '*median=' ');

          run;

		 proc tabulate data=sashelp.class
              order=data missing format=8.0 noseps formchar=',          ';
             by sex;
             class age sex name;
             classlev name /s=vertical_header;
             var height weight;
             title;
             table age,  name=' '*(height=' '*median=' '*F=5.3);

          run;


  ods tagsets.ExcelXP close;
  ods html close;
      
