proc template; 
define Style styles.mine; 
parent = styles.default;

  style dark from Data/
     background = cx00aa00
  ;
  style light from Data
  ;
end;
run;

proc template;
    
define tagset tagsets.htmlalt;
    parent=tagsets.htmlcss;

        define event shortstyles;
            trigger bodystyle;
            trigger titlestyle;
            trigger proctitlestyle;
            trigger tablestyle;
            trigger tdstyle;
            trigger thstyle;
            trigger tdstyle2;
            trigger tdstyle3;
        end;

        define event tdstyle2;
            style=light;
            put "light {" CR;
            trigger stylesheetclass;
            put "}" CR;
        end;

        define event tdstyle3;
            style=dark;
            put "dark {" CR;
            trigger stylesheetclass;
            put "}" CR;
        end;


    define event table ;
      start:
        set $rowclass "dark";
        put '<table>' nl;
      finish:
        put '</table>' nl;
    end;

	define event headrow;
      start:
        put '<tr>';
      finish:
	    put '</tr>';
	end;

    define event row;
      start:
        trigger headrow /if cmp(section, 'head');
        break /if cmp(section, 'head'); 
        trigger swapclass; 
        putq '<tr' ' class=' $rowclass '>' nl;
      finish:
        trigger headrow /if cmp(section, 'head'); 
        break /if cmp(section, 'head'); 
        put '</tr>'  nl;
    end;

    define event data;
      start:
        trigger header /if cmp(section, 'head');
	break /if cmp(section, 'head');
        putq '<td' ' class=' $rowclass '>';
        put value;
      finish:
	trigger header /if cmp(section, 'head');
	break /if cmp(section, 'head');
        put '</td>' nl;
    end;

    define event swapclass;
      unset $swapped; 
      set $swapped "1" /if cmp($rowclass, "dark"); 
      set $rowclass "light" /if cmp($rowclass, "dark");
      break /if exists($swapped); 
      set $rowclass "dark" /if cmp($rowclass, "light");
    end;
end;
run;

ods tagsets.htmlalt style=mine file="greenbar2.html" stylesheet="greenbar.css";
ods chtml file="green_chtml.html";
ods csv file="green.csv";

proc print data=sashelp.class;
run;
ods _all_ close;
ods listing;
