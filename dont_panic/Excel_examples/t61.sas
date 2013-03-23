proc template;
   define style styles.SUGI31;
     parent = styles.Journal;
       style vertical_header from header /
             tagattr = 'rotate:45'
         ;
   end;
 run;

 ods tagsets.ExcelXP file="temp.xls" options(
               sheet_interval="none"
               absolute_column_width='5'
               debug_level='-2'
               row_heights='140') style=sugi31;

 		  proc sort data=sashelp.class out=foo;
 		  by sex;

           proc tabulate data=foo
           order=data missing format=8.0 noseps formchar=',          ';
              by sex;
              class age sex name;
              classlev name /s=vertical_header;
              var height weight;
              title;
              table age,  name=' '*(height=' '*median=' ');

           run;

 		 proc tabulate data=foo
               order=data missing format=8.0 noseps  
               formchar=',          ';
              by sex;
              class age sex name;
              classlev name /s=vertical_header;
              var height weight;
              title;
              table age,  name=' '*(height=' '*median=' '*F=5.3);

           run;


       ods tagsets.ExcelXP close;
