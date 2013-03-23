ods tagsets.excelxp file='example5.xls' style=analysis;

/* create a new DateTime column from the date column */
data buy;
    set sashelp.buy;
    datetime=date*86400;
run;

/* Pre-9.2, the format/informat name was IS8601DT . That name is still */
/* allowed in 9.2, although we are                                     */
/* now using the name E8601DT (E=Extended vs. B=Basic).                */


/* set the format for the DateTime coming from SAS */
/* and set the Excel type and format so Excel knows what to do with it */
proc print data=buy; 
        format datetime e8601dt.;
	var datetime / style(data)={tagattr='type:DateTime format:YYYY-MM-DD'};
        var date;
	var amount;
run;

ods tagsets.excelxp close;
