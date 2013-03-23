proc template; 
    define style styles.myjournal; 
        parent = styles.Journal; 
 
        style angle_header from header / 
              tagattr = 'rotate:45' 
        ; 
    end; 
run; 

ods tagsets.ExcelXP file="Example15.xls" style=myjournal; 

    proc sort data=sashelp.class out=foo; 
        by sex; 

    proc tabulate data=foo 
          order=data missing format=8.0 noseps   
          formchar=',          '; 
        by sex; 

        class age sex name; 

        classlev name /s=angle_header; 

        var height weight; 
        title; 
        table age,  name=' '*(height=' '*median=' '*F=5.3); 

    run; 


ods tagsets.ExcelXP close; 
