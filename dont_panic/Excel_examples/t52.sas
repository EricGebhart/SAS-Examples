/* generate data file */
data temp;
  input age_group zip cost;
  do i = 1 to int(ranuni(4225)*77) + 1;
    output;
  end;
cards;
1 89123 2034
2 89101 1980
1 89124 1900
1 89124 1760
2 89141 5400
;
run;

/* cross tab to listing file */
proc tabulate;
  class age_group zip;
  var cost;
  table age_group,zip,cost*(sum='Total'*[style=[background=yellow]]
*f=dollar17.2);
  keylabel sum = ' ';
run;

/* cross tab to Excel file */
ods listing close;
ods html file="junk.html";
ods tagsets.odsxrpcs file="bmap.xml";
ods tagsets.event_map file="map.xml";
ods tagsets.ExcelXP
                    file  = 'junk.xls'
                    data =  'test.ini'
                    style = statdoc
             options(sheet_name='2456'  
             width_fudge='0.75'
             absolute_column_width='10, 10, 20'
             autofit_height='yes'
             frozen_headers='no'
             autofilter='none'
             embedded_titles='Yes'
             embedded_title_once='Yes'
             row_repeat='none'
             );

proc tabulate
  ;
  class age_group zip;
  var cost;
  table age_group,zip,cost*(sum='Total'*[style=[background=yellow]]
*f=dollar17.2 );
  keylabel sum = ' ';
run;

ods _all_ close;
ods listing;

