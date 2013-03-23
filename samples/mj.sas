somebody really digging tagsets, but having trouble.
I don't know why Proc Report would make their variable disappear.

sandy


From: mjessup@yahoo.com (M.Jessup)
Subject: Disappearing variable using custom ODS tagset and proc report
Newsgroups: comp.soft-sys.sas
Date: 11 Aug 2004 06:08:48 -0700
Organization: http://groups.google.com
Lines: 116
Message-ID: <3a31f236.0408110508.331727c5@posting.google.com>
NNTP-Posting-Host: 155.94.62.221
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Trace: posting.google.com 1092229784 25218 127.0.0.1 (11 Aug 2004 13:09:44 GMT)
X-Complaints-To: groups-abuse@google.com
NNTP-Posting-Date: Wed, 11 Aug 2004 13:09:44 +0000 (UTC)
Path: newshost!lamb.sas.com!attws1!ip.att.net!news101.his.com!news.lightlink.com!priapus.visi.com!orange.octanews.net!news.octanews.net!indigo.octanews.net!green.octanews.net!news-out.octanews.net!news.glorb.com!postnews2.google.com!not-for-mail
Xref: newshost comp.soft-sys.sas:63739

I have created a custom tagset which will print a dataset and place
the system titles and footers within a cell of the actual data table.
To accomplish this I save the COLCOUNT to a variable ($COLCOUNT) in
the colspecs event and then refer to it later to create a cell to span
the entire table.

This technique worked exactly as I expected it to when using the
tagset with ODS and a proc print for a simple dummy dataset. However
when used with proc report and the same dataset, the $COLCOUNT
variable "disappears" during the entire table_header event, and then
magically "reappears" during subsequent events (Including during a
later use of the variable to write the system footers).

Any help in correcting this problem, or an explanation of why this
behavior occurs would be greatly appreciated. Please find the code for
the custom tagset below (which includes some debugging puts which
illustrate the "disappearing variable"):

/*
BEGIN CUSTOM TAGSET CODE
*/
proc template;
define tagset tagsets.myTagSet /store=sasuser.templat;
	parent=tagsets.chtml;

	default_event='def_ev';

	define event def_ev;
		put EVENT_NAME NL;
	end;

	define event doc;
		start:
put "$COLCOUNT1: " $COLCOUNT NL;
put "COLCOUNT1: " COLCOUNT NL;
			set $titles "";
			set $footers "";
			put "<html>" NL;
			put "<body>" NL;
		finish:
put "$COLCOUNT2: " $COLCOUNT NL;
put "COLCOUNT1: " COLCOUNT NL;
			put "<tr><td colspan=""" $COLCOUNT """ align=""left"">" NL;
			put "<p style=""border-top-style: solid;border-top-width: 1px"">"
NL;
			put $footers "</p></td></tr>" NL;
			put "</table>";
			put "</body>" NL;
			put "</html>" NL;
			unset $titles;
			unset $footers;
			unset $COLCOUNT;
	end;

	define event table;
		start: 
put "$COLCOUNT3: " $COLCOUNT NL;
put "COLCOUNT1: " COLCOUNT NL;
			put "<table border=""0"">" NL;

	end;

	define event system_title;
put "$COLCOUNT4: " $COLCOUNT NL;
put "COLCOUNT1: " COLCOUNT NL;
		set $titles $titles VALUE "<br />";
	end;
	define event system_footer;
put "$COLCOUNT5: " $COLCOUNT NL;
put "COLCOUNT1: " COLCOUNT NL;
		set $footers $footers VALUE "<br />";
	end;

	define event table_body;
put "$COLCOUNT6: " $COLCOUNT NL;
put "COLCOUNT1: " COLCOUNT NL;
	end;

	define event colspecs;
		put "COLCOUNT: " COLCOUNT NL;
		eval $COLCOUNT COLCOUNT;
		set $cols COLCOUNT;
		put "$COLCOUNT: " $COLCOUNT NL;
	end;

	define event table_head;
		start:
put "$COLCOUNT7: ";
put $COLCOUNT NL;
put "COLCOUNT1: " COLCOUNT NL;
			put "<thead>" NL;
			put "<tr><td colspan=""";
			put $COLCOUNT;
			put """ align=""center"">";
			put "<p style=""border-bottom-style: solid;border-bottom-width: ";
			put "1px;font-size: 12px; font-family: Times New Roman;font-weight:
bold;"">" NL;
			put $titles "</p></td></tr>" NL;
		finish:
put "COLCOUNT1: " COLCOUNT NL;
put "$COLCOUNT8: " $COLCOUNT NL;
			put "<tr><td colspan=""";
			put $COLCOUNT;
			put """ align=""center"">" NL;
			put "<hr width=""100%""></td></tr>" NL;
			put "</thead>" NL;
	end;

	define event table_foot;
	end;
end;
run;

/*
END CUSTOM TAGSET CODE
*/
