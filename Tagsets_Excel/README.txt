Contents:
========

This ZIP archive contains the following files:


excltags.tpl - The ExcelXP tagset


ExcelXP-setup.sas - Sets the ODS path and imports the latest version of the ExcelXP tagset.  Run this first.


ExcelXP-sample01.sas - Illustrates the following with PROC PRINT: (1) wrapped headers using the SPLIT option, (2) autofilters, (3) frozen column headers, (4) subtotals as a result of the SUM statement, (5) formulas applied to computed fields, (6) formats


ExcelXP-sample02.sas - Illustrates the following with PROC PRINT: (1) wrapped headers using the SPLIT option, (2) autofilters, (3) frozen column headers, (4) frozen row headers, (5) subtotals as a result of the SUM statement, (6) formulas applied to computed fields, (7) formats


ExcelXP-sample03.sas - Illustrates the following with PROC FREQ: (1) autofilters, (2) frozen column headers, (3) frozen row headers


ExcelXP-sample04.sas - Illustrates the following with PROC FREQ: (1) CROSSLIST option, (2) autofilters, (3) frozen column headers, (4) frozen row headers


ExcelXP-sample05.sas - Illustrates the following with PROC REPORT: (1) autofilters, (2) frozen column headers, (3) frozen row headers, (4) default column widths, (5) changing options between PROCs, (6) embedding titles and footnotes in the worksheet instead of the header and footer


ExcelXP-sample06.sas - Illustrates the following with PROC TABULATE: (1) autofilters, (2) frozen column headers, (3) frozen row headers, (4) default column widths


ExcelXP-sample07.sas - Illustrates the following with PROC PRINT and PROC REPORT: (1) wrapped headers using the SPLIT option, (2) adjusting column widths with WIDTH_FUDGE, (3) default column widths, (4) changing options between PROCs, (5) horizontal justification


ExcelXP-sample08.sas - Illustrates the following with PROC PRINT: (1) wrapped headers using the SPLIT option, (2) horizontal justification, (3) embedding titles and footnotes in the worksheet instead of the header and footer, (4) using special text in headers and footers


ExcelXP-sample09sas - Illustrates the following with PROC TABULATE and PROC PRINT: (1) wrapped headers using the SPLIT option, (2) frozen row headers, (3) subtotals as a result of the SUM statement, (4) formulas applied to computed fields, (5) formats, (6) default column widths, (7) multiple tables in a single worksheet, (8) controlling the worksheet name, (9) autofilters on a specific table 


ExcelXP-sample10sas - Illustrates the following with PROC PRINT: (1) multiple tables in a single worksheet, (2) subtotals as a result of the SUM statement


README.txt - This file.


ExcelXP-sample01.xml - Output from program ExcelXP-sample01.sas


ExcelXP-sample02.xml - Output from program ExcelXP-sample02.sas


ExcelXP-sample03.xml - Output from program ExcelXP-sample03.sas


ExcelXP-sample04.xml - Output from program ExcelXP-sample04.sas


ExcelXP-sample05.xml - Output from program ExcelXP-sample05.sas


ExcelXP-sample06.xml - Output from program ExcelXP-sample06.sas


ExcelXP-sample07.xml - Output from program ExcelXP-sample07.sas


ExcelXP-sample08.xml - Output from program ExcelXP-sample08.sas


ExcelXP-sample09.xml - Output from program ExcelXP-sample09.sas


ExcelXP-sample10.xml - Output from program ExcelXP-sample10.sas


Installation:
============

Extract the Zip archive into a directory of your choosing and make note of the location.


Usage:
=====

Edit the program ExcelXP-setup.sas to provide the following:

1.  The directory where the Zip file was extracted, in order to include the latest version of the ExcelXP tagset.  The default directory in the %INCLUDE statement is set to "C:\temp\".
2.  The path where the ExcelXP tagset and ODS styles will be saved.  By default, this is set to work.  In a production system, you should specify a permanent location so all SAS programs can make use of the same version of the tagset. 

Submit the program ExcelXP-setup.sas before running any of the sample code.

To print the inline documentation for the tagset to the SAS Log, submit this SAS code:

ods tagsets.ExcelXP path='c:\temp\' file='empty.xml' options(doc='help');
ods tagsets.ExcelXP close;

All sample code writes the XML file to the directory 'c:\temp'.  If you desire, you can change this location by modifying the ODS statement in each sample program file.