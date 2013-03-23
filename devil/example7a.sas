
data prof;
 input grade rpass year count percent;
cards;
1 2 2002 23 9.9
1 2 2003 43 8.2
1 2 2001 24 2.1
2 3 2002 32 8.9
2 3 2001 32 7.9
2 3 2003 32 6.9
3 4 2002 32 8.9
3 4 2001 32 7.9
3 4 2003 32 6.9
4 2 2002 23 9.9
4 2 2003 43 8.2
4 2 2001 24 2.1
;

ods tagsets.ExcelXP file='example7a.xls' style=journal_borders options(zoom="200");

proc report data = prof nowd;
	column grade grade=grade2 rpass year,(count percent);
        define grade / group order=data descending 'Grade';
	define grade2 / noprint;
        define rpass / group ' ' order=internal ;
        define year / across order=data descending ' ' ;
        define count / '#';
        define percent / '%';
	title 'Districtwide Reading';
	title2 'Table 1: Proficiency';

/*
	compute grade2;
		if mod(grade2, 2) = 0 then do;
			call define (_row_, "style", "style = [background = CXDFE1D5]");
		end;
	endcomp;	
*/

run;

ods tagsets.ExcelXP close;
