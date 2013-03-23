data exprev;
   input Region $ State $ Month monyy5.
         Expenses Revenues;
   format month monyy5.;
   datalines;
Southern GA JAN95 2000  8000
Southern GA FEB95 1200  6000
Southern FL FEB95 8500 11000
Northern NY FEB95 3000  4000
Northern NY MAR95 6000  5000
Southern FL MAR95 9800 13500
Northern MA MAR95 1500  1000
;

options nodate pageno=1 linesize=70
pagesize=60 nobyline;
proc sort data=exprev;
   by region;
run;

proc format;
 value revfmt
     low-5000   = 'light red'
     5000-10000 = 'yellow'
     other      = 'green';
 value revfly
      low-5000   = 'Your revenues are dangerously low'
      5000-10000 = 'Your revenues are all right'
      other      = 'GREAT JOB! Keep up the good work';
 value expfmt
      low-5000   = 'green'
      5000-8000  = 'yellow'
      other      = 'red';
 value expfly
      low-5000   = 'Great job controlling those
      expenses'
      5000-8000  = 'You had better start controlling expenses'
      other      = 'I''m bringing in the comptroller';
run;

ods markup tagset=&sysparm file="xml\print3-&sysparm..xml";
proc print data=exprev noobs
   n='Number of observations for the state: '
     'Number of observations for the data set: ';
   var revenues / style(COLUMN) = {background=revfmt. flyover=revfly.};
   var expenses / style(COLUMN) = {background=expfmt. flyover=expfly.};
   sum expenses revenues;
   by region;
   id region;
run;

