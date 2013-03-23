proc template;

    /******************************************************/
    /******************************************************/
    /******************************************************/
    /*  Plain Jane HTML definition                        */
    /******************************************************/
    /******************************************************/
    /******************************************************/
    define tagset tagsets.phtml;
        log_note = "NOTE: This is one of the HTML tagsets (SAS 9.2, v1.59, 11/08/07). Add options(doc='help') to the ods statement for more information."; 

       
       mvar scroll_batch_size;
       mvar scroll_long_table_length;
       mvar scroll_control_images;
       

        notes "This is the plain HTML definition";

        parent= tagsets.cascading_stylesheet;

        %let  map =<>%nrstr(&)%str(%')%str(%");
        map="&map";
        mapsub = '/&lt;/&gt;/&amp;/&#39;/&quot;/';
        /*  old map
        map = '<>&';
        mapsub = '/&lt;/&gt;/&amp;/';
        */
        default_mimetype = "text/html";
        stylesheet_mimetype = "text/css";

        nobreakspace = '&nbsp;';
        split = '<br>';
        stacked_columns = yes;
        output_type = 'html';
        image_formats = 'png,gif,jpg,svg,xml';
        breaktext_ratio = 2.5;
        breaktext_width = 40;
        breaktext_length = 80;
        ext_graph_instance = yes;
        embedded_stylesheet=yes;
        copyright='&copy;';
        trademark='&trade;';
        registered_tm='&reg;';
        beginwellformed = '<';
        endwellformed = '>';
        
        
      /**************************************************************/
        
        
        define event readfile;

            /*---------------------------------------------------eric-*/
            /*-- Set up the file and open it.                       --*/
            /*------------------------------------------------13Jun03-*/

            set $filrf "myfile";
            eval $rc filename($filrf, $read_file);
            
            /*
            do /if $debug_level >= 5;
                putlog "File Name" ":" $rc " : " $read_file;
            done;
            */

            eval $fid fopen($filrf);
            
            /*
            do /if $debug_level >= 5;
                putlog "File ID" ":" $fid;
            done;
            */


            /*---------------------------------------------------eric-*/
            /*-- datastep functions  will bind directly to the      --*/
            /*-- variable space as it exists.                       --*/
            /*--                                                    --*/
            /*-- Tagset variables are not like datastep             --*/
            /*-- variables but we can create a big one full         --*/
            /*-- of spaces and let the functions write to it.       --*/
            /*--                                                    --*/
            /*-- This creates a variable that is 200 spaces so      --*/
            /*-- that the function can write directly to the        --*/
            /*-- memory location held by the variable.              --*/
            /*-- in VI, 200i<space>                                 --*/
            /*------------------------------------------------27Jun03-*/
            set $file_record  "

                                                               ";

            /*---------------------------------------------------eric-*/
            /*-- Loop over the records in the file                  --*/
            /*------------------------------------------------13Jun03-*/
            do /if $fid > 0 ;

                do /while fread($fid) = 0;

                    set $rc fget($fid,$file_record ,200);
                    
                    /*
                    do /if $debug_level >= 5;
                        putlog 'Fget' ':' $rc 'Record' ':' $file_record;
                    done;
                    */

                    set $record trim($file_record);

                    trigger process_data;

                    /* trimn to get rid of the spaces at the end. */
                    /*put trimn($file_record ) nl;*/

                done;
            done;

           /*-----------------------------------------------------eric-*/
           /*-- close up the file.  set works fine for this.         --*/
           /*--------------------------------------------------13Jun03-*/

            set $rc close($fid);
            set $rc filename($filrf);

       end;


       define event process_data;
           put $record;
       end;
       
       
       define event include_file;
           set $read_file value;
           trigger readfile;
       end;

/*---------------------------------------------------------------eric-*/
/*-- This code implements table scrolling.  The default row batch --*/
/*-- size is 8.  %let scroll_batch_size  to any other number to     --*/
/*-- change it.  The batch size can also be set on the url when     --*/
/*-- invoking the page.                                             --*/
/*------------------------------------------------------------27Apr04-*/
       
       define event set_scroll_options_default;
           set $default_scroll_batch_size '8';
           set $default_scroll_long_table_length '(2*batch_size)+1';
           unset $default_scroll_control_images;
           /*set $default_scroll_control_images 'True';*/
       end;

       define event javascript;
           start:
               trigger javascript_tag start;
               trigger scroll_code /if !any(code_name, code_url);
           finish:
               trigger javascript_tag finish;
       end;

       define event ie_check;
           trigger javascript_tag start;
           put 'var _info = navigator.userAgent' CR;
           put 'var _ie = (_info.indexOf("MSIE") > 0' CR;
           put '          && _info.indexOf("Win") > 0' CR;
           put '          && _info.indexOf("Windows 3.1") < 0);' CR;
           set $ieCheckDone "true";
           trigger javascript_tag finish;
       end;

       define event code_link;
           put "<script";
           putq " src=" code_name /if !exists(code_url);
           putq " src=" code_url /if exists(code_url);
           put ' language="javascript" type="text/javascript">';
           put "</script>" CR;
           put "<noscript></noscript>" CR;
       end;
       
       define event image_names;
           set $top_image       'top.png';
           set $page_up_image   'pageup.png';
           set $up_image        'up.png';
           set $down_image      'down.png';
           set $page_down_image 'pagedown.png';
           set $bottom_image    'bottom.png';
       end;
        
       define event scroll_code;

           /* set up the values for any tagset options we may or may not have received */
           trigger set_scroll_options;

           putl "//";
           putl "// Scrollable Tables";
           putl "// =================";
           putl "//";
           putl "// This javascript file can be included in any HTML document that ";
           putl "// contains data tables.  It will convert excessively long tables";
           putl "// into smaller tables that are scrollable.  ";
           putl "//";
           putl "// To use it, simply include the Javascript in your document and ";
           putl "// run `setupLongTables()` in the onload event of the <body> tag.";
           putl "//";
           putl '//    <script language="javascript" src="scrolltable.js"></script>';
           putl "//";
           putl "//  Then add setupLongTables() to the onload= event of your <body> tag.";
           putl "//";
           putl '//    <body onload="setupLongTables()">';
           putl "//";
            putl "//";
            putl "// Two parameters are used to control the detection of an excessively";
            putl "// long table, and the number of rows to be displayed in a converted";
            putl "// table: long_table_length and batch_size.  These can be hard-coded";
            putl "// below or added to the URL as parameters.";
            putl "//";
            putl "// Examples::";
            putl "//     http://www.foo.com/mytables.html?batch_size=3";
            putl '//     http://www.foo.com/mytables.html?batch_size=3&long_table_length=20';
            putl "//";
            putl "// It is also possible to use images to invoke the scrolling instead ";
            putl "// of the default text.  Simply define the variables `top_image`, ";
            putl "// `page_up_image`, `up_image`, `down_image`, `page_down_image`,";
            putl "// and `bottom_image` to contain the path to each image.";
            putl "//";
            putl "// This code should work in any browser that supports DOM (i.e. MSIE 5.5+,";
            putl "// Safari, Mozilla, etc.).";
            putl "//";
            putl "// Known Issues";
            putl "// ------------";
            putl "//";
            putl "// Some browsers have issues with code that messes with already rendered";
            putl "// table structures.  You may see some artifacts of this in table";
            putl "// borders while scrolling a table.";
            putl "//";
            putl "// Bugs/Comments: Kevin.Smith@sas.com";
            putl "//";
            putl "";
            putl "// Number of rows to show in each batch of the table";

            putl "var batch_size =" $scroll_batch_size ";";

            putl "";
            putl "// Minimum length of table before batching should occur";
            putl "var long_table_length =" $scroll_long_table_length ";";
            putl "";
            putl "// Buttons to use for table batch navigation (undefined, by default)";
            putl "var top_image = '';";
            putl "var page_up_image = ''; ";
            putl "var up_image = '';";
            putl "var down_image = '';";
            putl "var page_down_image = '';";
            putl "var bottom_image = '';";
            putl "";
            do /if $scroll_control_images;
                trigger image_names;
                putl "var top_image = '" $top_image "';";
                putl "var page_up_image = '" $page_up_image "';";
                putl "var up_image = '" $up_image "';";
                putl "var down_image = '" $down_image "';";
                putl "var page_down_image = '" $page_down_image "';";
                putl "var bottom_image = '" $bottom_image "';";
            done;
            putl "";
            putl "if ( !top_image )";
            putl "{";
            do /if $scroll_control_text;
            putl "    var top_button = document.createTextNode('[top]');";
            putl "    var page_up_button = document.createTextNode('[page up]');";
            putl "    var up_button = document.createTextNode('[up]');";
            putl "    var down_button = document.createTextNode('[down]');";
            putl "    var page_down_button = document.createTextNode('[page down]');";
            putl "    var bottom_button = document.createTextNode('[bottom]');";
            else;
            putl "    var top_button = document.createTextNode('^^');";
            putl "    var page_up_button = document.createTextNode('^');";
            putl "    var up_button = document.createTextNode('+');";
            putl "    var down_button = document.createTextNode('-');";
            putl "    var page_down_button = document.createTextNode('v');";
            putl "    var bottom_button = document.createTextNode('vv');";
            done;
            putl "} else {";
            putl "    var top_button = document.createElement('img');";
            putl "    top_button.setAttribute('src',top_image);";
            putl "    var page_up_button = document.createElement('img');";
            putl "    page_up_button.setAttribute('src',page_up_image);";
            putl "    var up_button = document.createElement('img');";
            putl "    up_button.setAttribute('src',up_image);";
            putl "    var down_button = document.createElement('img');";
            putl "    down_button.setAttribute('src',down_image);";
            putl "    var page_down_button = document.createElement('img');";
            putl "    page_down_button.setAttribute('src',page_down_image);";
            putl "    var bottom_button = document.createElement('img');";
            putl "    bottom_button.setAttribute('src',bottom_image);";
            putl "}";
            putl "";
            putl "// See if the batch_size and long_table_length have been overridden";
            putl "// in the URL variables";
            putl "var qs = location.search.substring(1);";
            putl 'var nv = qs.split(''&'');';
            putl "var url = new Object();";
            putl "for (var i = 0; i < nv.length; i++)";
            putl "{";
            putl "    var part = nv[i];";
            putl "    eq = part.indexOf('=');";
            putl "    key = part.substring(0,eq).toLowerCase();";
            putl "    value = unescape(part.substring(eq+1));";
            putl "    if (key == 'batch_size')";
            putl "        batch_size = parseInt(value);";
            putl "    else if (key == 'long_table_length')";
            putl "        long_table_length = parseInt(value);";
            putl "}";
            putl "    ";
            putl "function eventObject(event)";
            putl "//";
            putl "// Get the event object for all browsers";
            putl "//";
            putl "{";
            putl "    if (event.target) return event.target;";
            putl "    else if (event.srcElement) return event.srcElement;";
            putl "}";
            putl "";
            putl "function getDataRows(event)";
            putl "//";
            putl "// Get a collection of all of the rows that are in TBODY tags";
            putl "// for the table adjacent to the element that was clicked.";
            putl "//";
            putl "{";
            putl "    elem = eventObject(event);";
            putl "";
            putl "    // Find the table wrapping the navigation and data tables";
            putl "    var table = elem.parentNode;";
            putl '    while (table && table.nodeName != ''TABLE'')';
            putl "        table = table.parentNode;";
            putl "    if (!table) return;";
            putl "    table = table.parentNode;";
            putl '    while (table && table.nodeName != ''TABLE'')';
            putl "        table = table.parentNode;";
            putl "    if (!table) return;";
            putl "";
            putl "    table = table.getElementsByTagName('table')[0];";
            putl "    var tbody = table.getElementsByTagName('tbody');";
            putl "    var rows = Array();";
            putl "    for (var j = 0; j < tbody.length; j++)";
            putl "    {";
            putl "        var tr = tbody[j].getElementsByTagName('tr');";
            putl "        for (var k = 0; k < tr.length; k++) ";
            putl "            rows[rows.length] = tr[k];";
            putl "    }";
            putl "    return rows;";
            putl "}";
            putl "";
            putl "function tablePrevious(event,scroll_rows)";
            putl "//";
            putl "// Jump down 'scroll_rows' in the table";
            putl "//";
            putl "{";
            putl "    if (scroll_rows == -1)";
            putl "        scroll_rows = batch_size;";
            putl "";
            putl "    var rows = getDataRows(event);";
            putl "";
            putl "    // Bail out early if the first row is already displayed";
            putl "    if (isVisible(rows[0]))";
            putl "        return;";
            putl "";
            putl "    var first_displayed_row = 0;";
            putl "    for (var i = 0; i < rows.length; i++)";
            putl "    {";
            putl "        if (isVisible(rows[i]))";
            putl "        {";
            putl "            first_displayed_row = i - scroll_rows;";
            putl "            if (scroll_rows > 1)";
            putl "                first_displayed_row += 1;";
            putl "            for (var j = 0; j < batch_size; j++)";
            putl "                hideRow(rows[i+j]);";
            putl "            break;";
            putl "        }";
            putl "    } ";
            putl "    if (first_displayed_row < 0)";
            putl "        first_displayed_row = 0;";
            putl "    for (var i = 0; i < batch_size; i++)";
            putl "        displayRow(rows[i+first_displayed_row]);";
            putl "";
            putl "    var status = getStatusCell(eventObject(event));";
            putl "    updateRowStatus(status, first_displayed_row+1, ";
            putl "                            first_displayed_row+batch_size,";
            putl "                            rows.length);";
            putl "}";
            putl "";
            putl "function tableTop(event)";
            putl "//";
            putl "// Jump to the top of the table";
            putl "//";
            putl "{";
            putl "    var rows = getDataRows(event);";
            putl "";
            putl "    // Bail out early if the first row is already displayed";
            putl "    if (isVisible(rows[0]))";
            putl "        return;";
            putl "";
            putl "    // Hide all rows";
            putl "    for (var i = 0; i < rows.length; i++)";
            putl "        hideRow(rows[i]);";
            putl "";
            putl "    // Show top rows";
            putl "    for (var i = 0; i < batch_size; i++)";
            putl "        displayRow(rows[i]);";
            putl "";
            putl "    var status = getStatusCell(eventObject(event));";
            putl "    updateRowStatus(status, 1, batch_size, rows.length);";
            putl "}";
            putl "";
            putl "function tableBottom(event)";
            putl "//";
            putl "// Jump to the bottom of the table";
            putl "//";
            putl "{";
            putl "    var rows = getDataRows(event);";
            putl "";
            putl "    // Bail out early if the last row is already displayed";
            putl "    if (isVisible(rows[rows.length-1]))";
            putl "        return;";
            putl "";
            putl "    // Hide all rows";
            putl "    for (var i = 0; i < rows.length; i++)";
            putl "        hideRow(rows[i]);";
            putl "";
            putl "    // Show bottom rows";
            putl "    for (var i = rows.length-1; i >= (rows.length-batch_size); i--)";
            putl "        displayRow(rows[i]);";
            putl "";
            putl "    var status = getStatusCell(eventObject(event));";
            putl "    updateRowStatus(status, rows.length-batch_size+1, rows.length, rows.length);";
            putl "}";
            putl "";
            putl "function tableNext(event,scroll_rows)";
            putl "//";
            putl "// Jump down 'scroll_rows' in the table";
            putl "//";
            putl "{";
            putl "    if (scroll_rows == -1)";
            putl "        scroll_rows = batch_size;";
            putl "";
            putl "    var rows = getDataRows(event);";
            putl "";
            putl "    // Bail out early if the last row is already displayed";
            putl "    if (isVisible(rows[rows.length-1]))";
            putl "        return;";
            putl "";
            putl "    var first_displayed_row = 0;";
            putl "    for (var i = 0; i < rows.length; i++)";
            putl "    {";
            putl "        if (isVisible(rows[i]))";
            putl "        {";
            putl "            first_displayed_row = i + scroll_rows;";
            putl "            if (scroll_rows > 1)";
            putl "                first_displayed_row -= 1;";
            putl "            for (var j = 0; j < batch_size; j++)";
            putl "                hideRow(rows[i+j]);";
            putl "            break;";
            putl "        }";
            putl "    } ";
            putl "    if ((first_displayed_row + batch_size) > (rows.length - 1))";
            putl "        first_displayed_row = rows.length - batch_size;";
            putl "    for (var i = 0; i < batch_size; i++)";
            putl "        displayRow(rows[i+first_displayed_row]);";
            putl "";
            putl "    var status = getStatusCell(eventObject(event));";
            putl "    updateRowStatus(status, first_displayed_row+1, ";
            putl "                            first_displayed_row+batch_size,";
            putl "                            rows.length);";
            putl "}";
            putl "";
            putl "function hideRow(row)";
            putl "//";
            putl "// Hide the given row";
            putl "//";
            putl "{";
            putl "    row.style.display = 'none';";
            putl "}";
            putl "";
            putl "function displayRow(row)";
            putl "//";
            putl "// Unhide the given row";
            putl "//";
            putl "{";
            putl "    row.style.display = '';";
            putl "}";
            putl "";
            putl "function isHidden(obj)";
            putl "//";
            putl "// Is the given object hidden?";
            putl "//";
            putl "{";
            putl "    if (obj.style.display == 'none')";
            putl "        return true;";
            putl "    return false;";
            putl "}";
            putl "";
            putl "function isVisible(obj)";
            putl "//";
            putl "// Is the given object visible?";
            putl "//  ";
            putl "{";
            putl "    return !isHidden(obj);";
            putl "}";
            putl "";
            putl "function getStatusCell(obj)";
            putl "//";
            putl "// Get the cell that contains the row status for the associated table";
            putl "//";
            putl "{";
            putl "    var navtable = obj.parentNode;";
            putl "    while (navtable.nodeName != 'TABLE')";
            putl "        navtable = navtable.parentNode;";
            putl "";
            putl "    var cells = navtable.getElementsByTagName('TD');";
            putl "    for (var i = 0; i < cells.length; i++)";
            putl "    {";
            putl "        if (cells[i].className == 'longtablestatus')";
            putl "            return cells[i];";
            putl "    }";
            putl "    return null;";
            putl "}";
            putl "";
            putl "function updateRowStatus(status, begin, end, total)";
            putl "//";
            putl "// Update the displayed row status";
            putl "// ";
            putl "{";
            putl "    var position = document.createElement('DIV');";
            putl "    position.appendChild(document.createTextNode(begin+'-'+end));";
            putl "    position.appendChild(document.createElement('BR'));";
            putl "    position.appendChild(document.createTextNode('of'));";
            putl "    position.appendChild(document.createElement('BR'));";
            putl "    position.appendChild(document.createTextNode(total));";
            putl "    status.appendChild(position);";
            putl "    status.removeChild(status.firstChild);";
            putl "}";
            putl "";
            putl "function setupLongTables()";
            putl "//";
            putl "// Hide all rows in tables that aren't in the first batch";
            putl "//";
            putl "{";
            putl "    if (long_table_length < 1) return;";
            putl "";
            putl "    var tables = document.getElementsByTagName('table');";
            putl "    for (var i = 0; i < tables.length; i++)";
            putl "    {";
            putl "";
            putl "        // Don't do this if the table contains a table";
            putl "        if (tables[i].getElementsByTagName('table').length > 1)";
            putl "            continue;";
            putl "";
            putl "        // Hide rows";
            putl "        var tbodies = tables[i].getElementsByTagName('tbody');";
            putl "        var rows = Array();";
            putl "        for (var j = 0; j < tbodies.length; j++)";
            putl "        {";
            putl "            var current = tbodies[j].getElementsByTagName('tr');";
            putl "            for (var k = 0; k < current.length; k++) ";
            putl "                rows[rows.length] = current[k];";
            putl "        }";
            putl "";
            putl "        // Only do this on long tables";
            putl "        if (rows.length < long_table_length)";
            putl "            continue;";
            putl "";
            putl "        for (var j = 0; j < rows.length; j++)";
            putl "        {";
            putl "            if (j < batch_size)";
            putl "                displayRow(rows[j]);";
            putl "            else";
            putl "                hideRow(rows[j]);";
            putl "        }";
            putl "";
            putl "        var table = tables[i];";
            putl "        var tparent = table.parentNode;";
            putl "        var navwrapper = document.createElement('DIV');        ";
            putl "        navwrapper.className = 'tablenavwrapper';";
            putl "";
            putl "        // Swap wrapper and data table in the original document";
            putl "        tparent.replaceChild(navwrapper,table);";
            putl "";
            putl "        navwrapper.appendChild(table);";
            putl "        var navtable = tableNavigator();";
            putl "        navwrapper.appendChild(navtable);";
            putl "";
            putl "        var cells = navtable.getElementsByTagName('TD');";
            putl "        for (var c = 0; c < cells.length; c++)";
            putl "        {";
            putl "            if (cells[c].className == 'longtablestatus')";
            putl "            {";
            putl "                updateRowStatus(cells[c], 1, batch_size, rows.length);";
            putl "                break;";
            putl "            }";
            putl "        }";
            putl "    }";
            putl "";
            putl "    // Swap the DIV out for a table.  This had to be done in a ";
            putl "    // separate step because the browsers didn't like it when I";
            putl "    // was swapping in-and-out tables while iterating over them.";
            putl "    var divs = document.getElementsByTagName('DIV');";
            putl "    for (var i = 0; i < divs.length; i++)";
            putl "    {";
            putl "        var current = divs[i];";
            putl "        var cparent = current.parentNode;";
            putl "        if (current.className != 'tablenavwrapper')";
            putl "            continue;";
            putl " ";
            putl "        var table = document.createElement('TABLE');";
            putl "        var tbody = document.createElement('TBODY');";
            putl "        var row = document.createElement('TR');";
            putl "        var datacell = document.createElement('TD');";
            putl "        datacell.appendChild(current.firstChild);";
            putl "        var navcell = document.createElement('TD');";
            putl "        navcell.appendChild(current.lastChild);";
            putl "";
            putl "        for (var j = 0; j < cparent.childNodes.length; j++)";
            putl "            cparent.removeChild(cparent.firstChild);";
            putl "";
            putl "        // Build the final table with data and navigation";
            putl "        table.appendChild(tbody);";
            putl "        tbody.appendChild(row);";
            putl "        row.appendChild(datacell);";
            putl "        row.appendChild(navcell);";
            putl "        cparent.appendChild(table);";
            putl "    }";
            putl "";
            putl "}";
            putl "";
            putl "";
            putl "function tableNavigator()";
            putl "//";
            putl "// Create a table that contains table navigation buttons";
            putl "//";
            putl "{";
            putl "    var table = document.createElement('TABLE');";
            putl "    var tbody = document.createElement('TBODY');";
            putl "";
            putl "    // Append buttons that navigate up";
            putl "    tbody.appendChild(navigatorCell('up','tableTop(event)',top_button.";
            putl "                                    cloneNode(true)));";
            putl "    tbody.appendChild(navigatorCell('up','tablePrevious(event,-1)',";
            putl "                                    page_up_button.cloneNode(true)));";
            putl "    tbody.appendChild(navigatorCell('up','tablePrevious(event,1)',";
            putl "                                    up_button.cloneNode(true)));";
            putl "";
            putl "    // Append displayed row status cell";
            putl "    var tr = document.createElement('TR');";
            putl "    var cell = document.createElement('TD');";
            putl "    cell.className = 'longtablestatus';";
            putl "    cell.style.textAlign = 'center';";
            putl "    cell.style.verticalAlign = 'middle';";
            putl "    cell.style.fontSize = 'small';";
            putl "    cell.style.height = '100px';";
            putl "    cell.appendChild(document.createTextNode(''));";
            putl "    updateRowStatus(cell,'#','#','#');";
            putl "    tr.appendChild(cell);";
            putl "    tbody.appendChild(tr);";
            putl "";
            putl "    // Append buttons that navigate down";
            putl "    tbody.appendChild(navigatorCell('down','tableNext(event,1)',";
            putl "                                    down_button.cloneNode(true)));";
            putl "    tbody.appendChild(navigatorCell('down','tableNext(event,-1)',";
            putl "                                    page_down_button.cloneNode(true)));";
            putl "    tbody.appendChild(navigatorCell('down','tableBottom(event)',";
            putl "                                    bottom_button.cloneNode(true)));";
            putl "";
            putl "    table.appendChild(tbody);";
            putl "    return table;";
            putl "}";
            putl "";
            putl "function navigatorCell(name,onclick,button)";
            putl "//";
            putl "// Utility function to create button for table navigator";
            putl "//";
            putl "{";
            putl "    var link = document.createElement('A');";
            putl "    link.setAttribute('name',name);";
            putl "    if (navigator.appVersion.indexOf('MSIE') > 0)";
            putl "        link.onclick = new Function(onclick);";
            putl "    else";
            putl "        link.setAttribute('onclick','javascript:'+onclick+';return false');";
            putl "    link.style.cursor = 'hand';";
            putl "    link.appendChild(button);";
            putl "    var cell = document.createElement('TD');";
            putl "    cell.appendChild(link);";
            putl "    cell.style.textAlign = 'center';";
            putl "    var row = document.createElement('TR');";
            putl "    row.appendChild(cell);";
            putl "    return row";
            putl "}";
            put 'startup()';
            put  nl;
        end;
        
      /**************************************************************/

       define event graph_java_width;
           style=Graph;
           pure_style;
           put '   document.writeln("WIDTH=' COLWIDTH '");' CR / if !cmp( COLWIDTH , "0" );
           break / if !cmp( COLWIDTH , "0" );
           put '   document.writeln("WIDTH=' OUTPUTWIDTH '");' CR / if exists(OUTPUTWIDTH);
           put '   document.writeln("WIDTH=640");' CR / if !exists(OUTPUTWIDTH);
        end;

        define event graph_java_height;
           style=Graph;
           pure_style;
           put '   document.writeln("HEIGHT=' DEPTH '");' CR / if !cmp( DEPTH , "0" );
           break / if !cmp( DEPTH , "0" );
           put '   document.writeln("HEIGHT=' OUTPUTHEIGHT '");' CR / if exists(OUTPUTHEIGHT);
           put '   document.writeln("HEIGHT=480");' CR / if !exists(OUTPUTHEIGHT);
        end;

        define event graph_java2_attribute;
           put '   document.writeln("';
           put NAME '=\"' VALUE '\"';
           put '");' CR;
        end;

        define event graph_java2_fxd_attributes;
           put '   document.writeln(">");' CR;
           trigger javascript finish;
        end;

        define event graph_attribute;
            put " " NAME;
            putq "=" VALUE CR;
        end;

        define event graph_parameter;
            putq "<PARAM NAME=" NAME;
            putq " VALUE=" VALUE;
            put ">" CR;
        end;

        define event graph_onload;
        end;

        define event graph_fillin_block;
        end;

        define event graph_fxd_parameters;
            putq '<PARAM NAME="BackColor" VALUE=' BACKGROUND;
            put ">" CR / exists(BACKGROUND );
        end;

        define event html3_center;
            start:
               put "<CENTER>" CR;
            finish:
               put "</CENTER>" CR;
        end;

        define event java_unsupported;
            put "Sorry, your browser does not support the applet tag." CR;
            putq 'The graph ' value ' cannot be displayed.' CR;
        end;

        define event activex_unsupported;
            put "Sorry, there was a problem with the Graph control or plug-in in your browser." CR;
            putq 'The graph ' value ' cannot be displayed.' CR;
        end;

        define event graph_description;
            putq value CR;
        end;

        define event activex_graph;
            start:
                put "<OBJECT " CR;
                putq " ID=" ref_id CR;
            finish:
                put "</OBJECT> " CR;
        end;

        define event java2_parameters;
                put  '<PARAM NAME="TYPE" VALUE="application/x-java-applet;version=1.5">' CR;
                put  '<PARAM NAME="ENCODING" VALUE=' / if exists(ENCODING);
                putq  ENCODING / if exists(ENCODING);
                put  '>' CR / if exists(ENCODING);
                put  '<PARAM NAME="SCRIPTABLE" VALUE="true">' CR;
        end;


        /* This event is to allow the xmldoc being driven by graph */
        /* to be able to write out an ODSTAG string to the HTML    */
        /* document. Do not remove this event unless you find out  */
        /* that EG does not need ODSTAG strings any more. --sandy  */

        define event odstag_eg;
            put "<!-- ODSTAG TYPE=" value ;
            put " ID=" anchor ;
            put  " -->" CR;
        end;


        define event java2_graph;
            start:
                pure_style;
                trigger ie_check / if !exists($ieCheckDone);
                trigger javascript start;
                put  '   document.writeln("<OBJECT");' CR;
                trigger graph_java_width;
                trigger graph_java_height;
                put  '   document.writeln("ALIGN=\"baseline\"");' CR;
                put  'if (_ie == true) {' CR;
                put  '   document.writeln("CLASSID=\"clsid:8AD9C840-044E-11D1-B3E9-00805F499D93\"");' CR;
                do / if CODEBASE;
                put  '   document.writeln("CODEBASE=\"' CODEBASE '\"");' CR;
                else;
                put  '   document.writeln("CODEBASE=\"http://java.sun.com/update/1.5.0/jinstall-1_5_0_12-windows-i586.cab#Version=1,5,0,0\"");' CR;
                done;
                put  '}' CR;
                put  'else {' CR;
                put  '   document.writeln("TYPE=\"application/x-java-applet;version=1.5\"");' CR;
                put  '   document.writeln("CODEBASE=\"http://java.sun.com/javase/downloads/index_jdk5.jsp\"");' CR;
                put  '}' CR;

            finish:
                put  '</OBJECT>' CR;
            end;


        define event graph_fxd_attributes;
            pure_style;
            trigger graph_actx_width;
            trigger graph_actx_height;
            putq " CLASS=" HTMLCLASS CR;
            put  ' ALIGN="top">' CR;
            put '<PARAM NAME="ENCODING" VALUE=' / if exists(ENCODING);
            putq ENCODING / if exists(ENCODING);
            put  '>' CR / if exists(ENCODING);
        end;


        define event options_set;
            trigger set_options;
            trigger documentation;
        end;

        define event documentation;
            trigger help /if cmp($options['DOC'], 'help');
            trigger quick_reference /if cmp($options['DOC'], 'quick');
        end;

    define event help;
        putlog "==============================================================================";
        putlog "The " tagset " Tagset Help Text.";
        putlog " ";
        putlog "This Tagset/Destination creates output in HTML format.";
        putlog " ";
        putlog " ";
        trigger quick_reference;
    end;

    define event quick_reference;
        putlog "==============================================================================";
        putlog " ";
        putlog "These are the options supported by this tagset.";
        putlog " ";
        putlog "Sample usage:";
        putlog " ";
        putlog "ods html options(doc='Quick'); ";
        putlog " ";
        putlog "ods html options(header_dots='yes' summary_byvars='yes'); ";
        putlog " ";
        putlog "Doc:  No default value.";
        putlog "     Help: Displays introductory text and options.";
        putlog "     Quick: Displays available options.";
        putlog " ";
        putlog "body_toc:   Default Value 'no'";
        putlog "     Creates a floating table of contents in the main output file.";
        putlog " ";
        putlog "toc_type:   Default Value 'tree'";
        putlog "     menu: display as pulldown menus.";
        putlog "     tree: display as a hierarchical list.";
        putlog "     Determines whether the table of contents will show as pulldown menus or as a tree.";
        putlog " ";
        putlog "header_data_associations:   Default Value 'no'";
        putlog "     Associates data cells and header cells by adding an ID attribute";
        putlog "     to each header cell and listing the IDs of associated headers in";
        putlog "     a HEADERS attribute added to each data cell. (PROC REPORT only)";
        putlog " ";
        putlog "header_dots:   Default Value 'no'";
        putlog "     Puts hidden dots before the text in all table headers";
        putlog " ";
        putlog "scroll_tables:   Default Value 'no'";
        putlog "     Causes tables to scroll vertically.";
        putlog " ";
        putlog "scroll_batch_size:   Default Value '8'";
        putlog "     Number of observations to display in a scrolling table.";
        putlog "     This can also be set through a macro variable of the same name.";
        putlog "     This value can also be provided on the url when loading the output.";
        putlog '     http://www.foo.com/mytables.html?batch_size=3";';
        putlog " ";
        putlog "scroll_control_images:   Default Value 'no'";
        putlog "     Causes the scroll controls to use images rather than ascii characters";
        putlog "     By default these images are named, top.png, pageup.png, up.png, down.png, pagedown.png,";
        putlog "     and bottom.png.  These images and more information about table scrolling can be";     
        putlog "     found here.  http://support.sas.com/rnd/base/ods/odsmarkup/htmlscroll.html";
        putlog " ";
        putlog "scroll_control_text:   Default Value 'no'";
        putlog "     Causes the scroll controls to use textual words, top, pageup, up, down, page down, and bottom";
        putlog "     rather than ^^, ^, +, -, v, vv.";
        putlog " ";
        putlog "scroll_long_table_length:  Default Value (2 * scroll_batch_size)+1"; 
        putlog "     Number of rows a table must have before scrolling is turned on for that table.";
        putlog "     This can also be set through a macro variable of the same name.";
        putlog "     This value can also be provided on the url when loading the output.";
        putlog "     http://www.foo.com/mytables.html?batch_size=3&long_table_length=20';";
        putlog " ";
        putlog "summary_as_caption:   Default Value 'no'";
        putlog "     Causes a table caption to be created from the table summary.";
        putlog " ";
        putlog "summary_byvars:   Default Value 'no'";
        putlog "     Adds a list of by variable names to the table summary";
        putlog " ";
        putlog "summary_byvals:   Default Value 'no'";
        putlog "     Add the values of the by variables along with the names in the table summary";
        putlog "     This works with summary byvars but not without.";
        putlog " ";
        putlog "summary:   Default Value ''";
        putlog "     Text for the table summary";
        putlog " ";
        putlog "summary_prefix:   Default Value ''";
        putlog "     Text to place at the beginning of table summary";
        putlog " ";
        putlog "summary_suffix:   Default Value ''";
        putlog "     Text to place at the end of table summary";
        putlog " ";
        putlog "page_break:   Default Value 'yes'";
        putlog "     If yes, the usual pagebreak style attribute will be used to create";
        putlog "     what becomes the page separator.  Usually that is an HR line.";
        putlog "     If No, then no pagebreak will be output.";
        putlog "     If anything else, the value given will be output as the pagebreak.";
        putlog " ";
        putlog "css_table:   Default Value 'no'";
        putlog "     If yes, the table tags will not have any style attributes but will";
        putlog "     rely entirely on the table style defined in the stylesheet.  This may";
        putlog "     create undesirable table rendering in some browsers.";
        putlog " ";
        putlog "percentage_font_size:   Default Value 'no'";
        putlog "     If yes, titles and footnotes will allow font sizes to be specified as";
        putlog "     a percentage of the font size.";
        putlog " ";
        putlog "==============================================================================";
    end;

       define event set_scroll_options;
           trigger set_scroll_options_default;
           unset $scroll_batch_size;
           unset $scroll_long_table_length;
           unset $scroll_control_images;
           set $scroll_batch_size $options['SCROLL_BATCH_SIZE'] /if $options;
           set $scroll_batch_size scroll_batch_size /if ^$scroll_batch_size;
           set $scroll_batch_size $default_scroll_batch_size /if ^$scroll_batch_size;

           set $scroll_long_table_length $options['SCROLL_LONG_TABLE_LENGTH'] /if $options;
           set $scroll_long_table_length scroll_long_table_length /if $scroll_long_table_length;
           set $scroll_long_table_length $default_scroll_long_table_length /if ^$scroll_long_table_length;
           
           do /if $options['SCROLL_CONTROL_IMAGES'];
               set $scroll_control_images $options['SCROLL_CONTROL_IMAGES'];
           else /if scroll_control_images;
               set $scroll_control_images "true" /if cmp(scroll_control_images, "yes");
           else;
               set $scroll_control_images $default_scroll_control_images;
           done;
       end;

        define event set_options;
            unset $header_dots;
            unset $byvar_caption;
            set $options['junk'] "junk" /if ^$options;

            /*=========================================================*/
            /* If the currency symbol, decimal separator, or thousands */
            /* separator are Perl regular expression metacharacters,   */
            /* then they must be escaped with a backslash.             */
            /*=========================================================*/

            unset $scroll_tables;
            do / if cmp($options['SCROLL_TABLES'], 'yes');
                set $scroll_tables "True";
            done;

            unset $scroll_control_text;
            do / if cmp($options['SCROLL_CONTROL_TEXT'], 'yes');
                set $scroll_control_text "True";
            done;

            unset $contents_body;
            do / if cmp($options['BODY_TOC'], 'yes');
                set $contents_body "True";
            done;


            unset $contents_list;
            set $contents_tree "True";
            do / if cmp($options['TOC_TYPE'], 'menu');
                set $contents_list "True";
                unset $contents_tree;
            done;

            unset $header_data_associations;
            do / if cmp($options['HEADER_DATA_ASSOCIATIONS'], 'yes');
                set $header_data_associations "True";
            done;

            unset $header_dots;
            do / if cmp($options['HEADER_DOTS'], 'yes');
                set $header_dots "True";
            done;

            unset $summary_byvars;
            do / if cmp($options['SUMMARY_BYVARS'], 'yes');
                set $summary_byvars "True";
            done;

            unset $summary_byvals;
            do / if cmp($options['SUMMARY_BYVALS'], 'yes');
                set $summary_byvals "True";
            done;

            unset $summary_as_caption;
            do / if cmp($options['SUMMARY_AS_CAPTION'], 'yes');
                set $summary_as_caption "True";
            done;

            do / if $options['SUMMARY_PREFIX'];
                set $summary_prefix $options['SUMMARY_PREFIX'];
            else;
                unset $summary_prefix;
            done;

            do / if $options['SUMMARY'];
                set $summary $options['SUMMARY'];
            else;
                unset $summary;
            done;

            do / if $options['SUMMARY_SUFFIX'];
                set $summary_suffix $options['SUMMARY_SUFFIX'];
            else;
                unset $summary_suffix;
            done;

            set $pagebreak 'yes';
            do / if $options['PAGEBREAK'];
                set $pagebreak $options['PAGEBREAK'];
            done;

            unset $css_table;
            do / if cmp($options['CSS_TABLE'], 'yes');
                set $css_table "True";
            done;

            unset $percentage_font_size;
            do / if cmp($options['PERCENTAGE_FONT_SIZE'], 'yes');
                set $percentage_font_size "True";
            done;

        end;

      define event unicode ;
         Notes "Unicode function inserts unicode values. ";
         start:
            do /if value;
               set $squote "'" ;
            eval $temp value ;
            set  $temp strip($temp);
            set  $temp upcase($temp);

               /* is it in the internal list ? */
            do /if  $unicodeMap[$temp] ;
               eval $newvalue $unicodeMap[$temp] ;
            else ;
                  /* is it '01B3'x form */
                  do / if (index($temp, $squote ) > 0);
                     set $newvalue scan($temp, 1, $squote );
                  /* is it "01B3"x form */
                  else /if (index($temp, '"') > 0);
                     set $newvalue scan($temp, 1, '"');
                  /* Then it must be 01B3 */
                  else;
               set $newvalue $temp;
                  done;
               done;

            eval $unicode inputn($newvalue, "hex4.") ;
            put '&#' $unicode ';' /if $unicode ;
            done;
      end;

      define event bulleted_list;
         start:
           put '<ul';
           trigger classalign;
           trigger style_inline;
           putq ' start=' startvalue / if startvalue > 0;
           put '>' nl;
         finish:
           put '</ul>' nl;
      end;

      define event bulleted_list_item;
         start:
           put '<li';
           trigger classalign;
           trigger style_inline;
           putq ' value=' startvalue / if startvalue > 0;
           put '>';
         finish:
           put '</li>' nl;
      end;

/****** These events can be replaced by any child *******/
/* LAYOUT */
    has_layout_support = yes;

    define event LAYOUT ;
         start:
             /*   set $layout_trace "TRUE" ;  */
             putlog " LAYOUT start" /if $layout_trace;
             put "<div";
             trigger alt_align;
             put ">" CR;
             put "<table";
             trigger classalign;
             trigger style_inline;
             putq " id="    HTMLID;
             do /if ^$css_table;
                 putq " rules=" LOWCASE(RULES);
                 putq " frame=" LOWCASE(FRAME);
             done;
             putq " border=" BORDERWIDTH / if exist( BORDERWIDTH );
             putq " borderstyle=" BORDERSTYLE /if exist( BORDERSTYLE);
             putq " bordercolor=" BORDERCOLOR / if exist( BORDERCOLOR );
             putq " bordercolordark=" BORDERCOLORDARK /if exist( BORDERCOLORDARK);
             putq " bordercolorlight=" BORDERCOLORLIGHT /if exist( BORDERCOLORLIGHT);
             put ' summary="Layout table"';
             put ">" CR;
         finish:
             put "</table>" CR;
             put "</div>" CR;
             putlog " LAYOUT finish " /if $layout_trace;
     end;

define event LAYOUT_COLSPECS ;
  putlog " LAYOUT_COLSPECS "/if $layout_trace ;
  trigger COLSPECS ;
end ;

define event LAYOUT_COLSPEC_ENTRY ;
  putlog " LAYOUT_COLSPEC_ENTRY "/if $layout_trace ;
  trigger COLSPEC_ENTRY ;
end ;

define event LAYOUT_COLSPECSEP ;
  putlog " LAYOUT_COLSPECSEP "/if $layout_trace ;
  trigger COLSPECSEP ;
end ;

define event LAYOUT_BODY ;
  putlog " LAYOUT_BODY "/if $layout_trace ;
  trigger BODY ;
end ;

define event LAYOUT_ROW;
  start:
    putlog " LAYOUT_ROW  start"/if $layout_trace ;
    trigger ROW start;
  finish:
    putlog " LAYOUT_ROW  finish"/if $layout_trace ;
    trigger ROW finish;
end ;

define event LAYOUT_REGION;
  start:
     set $no_pagebreak "true" ;
     putlog " LAYOUT_REGION start"/if $layout_trace ;
     put "<td";
     putq " id="    HTMLID;
     putq " title=" flyover;
     trigger classalign;
     trigger style_inline;
     trigger rowcol;
     put ">";
     trigger cell_value;
  finish:
     put "</td>" CR;
     unset $no_pagebreak  ;
     putlog " LAYOUT_REGION finish "/if $layout_trace ;
end;

define event FORMAT;
  putlog " LAYOUT FORMAT"/if $layout_trace ;
  trigger FORMAT;
end ;
/**/
    /*************************** end layout *********************/
    define event do_header_dots;
        break /if ^$header_dots;
        break /if ^htmlclass;
        break /if ^cmp(event_name, 'header');
        put '<span ' 'class="'  htmlclass '_dots">...</span>';
        end;

        /*-----------------------------------------------------------eric-*/
        /*-- blank out the style class event so we only get a nice      --*/
        /*-- short stylesheet from the short_styles event.              --*/
        /*--------------------------------------------------------27Jul06-*/
        define event style_class;
        end;

        define event putvars;
            put "event vars" nl;
            putvars event "name: " _name_ " = " _value_ nl;
            put "memory vars" nl;
            putvars mem "name: " _name_ " = " _value_ nl;
            put "style vars" nl;
            putvars style "name: " _name_ " = " _value_ nl;
        end;

        define event initialize;
            trigger set_just_lookup;
            trigger grand_init;
            trigger set_options;
            trigger store_all_borders;
            trigger documentation;
        end;


        define event show_charset;
           set $show_charset "1" / if !exists(suppress_charset);
        end;

        define event put_value;
            put VALUE;
        end;

        define event put_value_cr;
            put VALUE nl;
        end;


        define event dynamic;
            put "Content-Type: text/html" CR CR CR;
        end;

        define event top_file;
            start:
                put HTMLDOCTYPE CR;
                put "<html>" CR;
            finish:
                put "</html>" CR;
        end;

        define event top_title;
            put "<title>";
            put "SAS Output Frame"  / if !exists(value);
            put VALUE;
            put "</title>" CR;
        end;

        define event top_code;
            start:
                set $content_position "first" /if cmp(type, 'f');
                set $content_position "last" /if cmp(type, 'l');
                set $content_orientation "horizontal" /if cmp(colcount, '1');
                set $content_orientation "vertical" /if cmp(colcount, '2');

                put "<frameset";

                /*  not horizontal */
                put ' cols="'  / if cmp(colcount, "2");
                /*  horizontal */
                put ' rows="' / if cmp(colcount, "1");

                trigger content_frameset start/ if cmp(type, "f");

                /* body_frameset if not content_first */
                trigger body_frameset  / if cmp(type,"l");

                put ',';

                /* body_frameset if content_first */
                trigger body_frameset / if cmp(type, "f");

                /* content_frameset if not content_first */
                trigger content_frameset /if cmp(type, "l");

                put '">' CR;

                /* create a frameset to hold the two contents files if they both exist. */
                trigger contents_pages_frameset start/ if cmp(type, "f");

            finish:
                put "<noframes>" nl;
                put "<body>" nl ;
                put "<ul>" nl ;

                unset $link;
                set $link contents_url /if exists(contents_url);
                set $link contents_name /if !exists($link);
                put '<li><a href="' $link '">The Table of Contents</a></li>' nl /if exists($link);

                unset $link;
                set $link pages_url /if exists(pages_url);
                set $link pages_name /if !exists($link);
                put '<li><a href="' $link '">The Table of Pages</a></li>' nl /if exists($link);

                unset $link;
                set $link body_url /if exists(body_url);
                set $link body_name /if !exists($link);
                put '<li><a href="' $link '">The Contents</a></li>' nl /if exists($link);
                put "</ul>" nl ;
                put "</body>" nl ;
                put "</noframes>" nl;
                put "</frameset>" nl;
        end;

        define event contents_pages_frameset;
            start:
                break /if !exists(pages_name, contents_name);
                put "<frameset";

                /* over and under */
                put ' rows="'  / if cmp(colcount, "2");
                /* side by side */
                put ' cols="' / if cmp(colcount, "1");

                put '66%,*">' nl;

            finish:
                break /if !exists(pages_name, contents_name);
                put "</frameset>" nl;
        end;

        define event content_frameset;
            put "23%"  / if !exists(CONTENTSIZE);
            put CONTENTSIZE;
        end;

        define event body_frameset;
            put "*"  / if !exists(BODYSIZE);
            put BODYSIZE;
        end;

        define event pages_frame;
            break /if !exists(pages_name);
            put '<frame marginwidth="4" marginheight="0"';
            put " frameborder=";
            put '"1"' / if cmp(frameborder, "yes");
            put '"0"' / if !cmp(frameborder, "yes");
            putq " src=" URL;
            put ' name="pages" scrolling=';
            putq "auto"  / if !exists(CONTENTSCROLLBAR);
            putq CONTENTSCROLLBAR;
            putq " title=" pages_title;
            put ' title="The Table of Pages"' /if !exists(pages_title);
            put $empty_tag_suffix;
            put ">" CR;
            /* close up the frameset for the contents files if they both exist */
            trigger contents_pages_frameset finish;
        end;

        define event content_frame;
            break /if !exists(contents_name);
            put '<frame marginwidth="4" marginheight="0"';
            put " frameborder=";
            put '"1"' / if cmp(frameborder, "yes");
            put '"0"' / if !cmp(frameborder, "yes");
            putq " src=" URL;
            put ' name="contents" scrolling=';
            putq "auto"  / if !exists(CONTENTSCROLLBAR);
            putq CONTENTSCROLLBAR;
            putq " title=" contents_title;
            put ' title="The Table of Contents"' /if !exists(contents_title);
            put $empty_tag_suffix;
            put ">" CR;
        end;

        define event body_frame;
            put '<frame marginwidth="9" marginheight="0"';
            put " frameborder=";
            put '"1"' / if cmp(frameborder, "yes");
            put '"0"' / if !cmp(frameborder, "yes");
            putq " src=" URL;
            put ' name="body" scrolling=';
            putq "auto"  / if !exists(BODYSCROLLBAR);
            putq BODYSCROLLBAR;
            putq " title=" body_title;
            put ' title="The SAS Output"' /if !exists(body_title);
            put $empty_tag_suffix;
            put ">" CR;
            /* create a frameset to hold the two contents files if they both exist. */
            trigger contents_pages_frameset start/ if cmp($content_position, "last");
        end;

        define event doc;
            start:
                put HTMLDOCTYPE CR;
                put "<html>" CR;
            finish:
                put "</html>" CR;
        end;

        define event doc_head;
            start:
                put "<head>" CR;
                put VALUE CR ;
            finish:
                put "</head>" CR;
        end;

       define event code_body;
           trigger scroll_code;
           trigger contents_code;
       end;

        define event contents_bullet_style;
           put "<style type=""text/css"">" CR;
           put "<!--" CR;
           put "/* Outline Style Sheet */" CR CR;
           put "UL { cursor: pointer;" CR;
           put "    list-style-type: decimal;}" CR CR;
           put "DL { cursor: pointer;" CR;
           put "    list-style-type: none;}" CR CR;
           put "// so Netscape wont indent so far" CR;
           put "DL {marginLeft: -12pt}" CR CR;
           put "SPAN {cursor: pointer}" CR;
           put "-->" CR;
           put "</style>" CR CR;
       end;
       
    /*******************************************************************************************/
       define event contents_list2;
            start:
                put cr '<script type="text/javascript">' cr;
                put 'var __CONTENTS_IDS = 0;' cr;
                put cr;
                put 'function generateID()' cr;
                put '// Generate a unique ID ' cr;
                put '{' cr;
                put '    return "contents-id-" + __CONTENTS_IDS++;' cr;
                put '}' cr;
                put cr;
                put 'function makeSelectList(data, id)' cr;
                put '//' cr;
                put '// Create select lists from nested data structure' cr;
                put '//' cr;
                put '// Arguments:' cr;
                put '// data -- object that contains two keys: label and items.  Label is the ' cr;
                put '//     string to display and items is the list of subitems.  Each item' cr;
                put '//     in the subitem list has the same structure as `data`.' cr;
                put '// id -- the ID to use for this node' cr;
                put '//' cr;
                put '// Returns: the newly created select list' cr;
                put '//' cr;
                put '{' cr;
                put '    if ( !data.items )' cr;
                put '        return;' cr;
                put cr;
                put '    var select = document.createElement("select");' cr;
                put '    if ( id ) select.setAttribute("id", id);' cr;
                put '    select.onchange = displaySelectList;' cr;
                put '    select.style.marginBottom = "0.5em";' cr;
                put '    select.style.display = "block";' cr;
                put '    select.style.width = "100%";' cr;
                put cr;
                put '    var blank = document.createElement("option");' cr;
                put '    blank.setAttribute("selected", "seleted");' cr;
                put '    select.appendChild(blank);' cr;
                put cr;
                put '    for ( var i = 0; i < data.items.length; i++ )' cr;
                put '    {' cr;
                put '        if ( !data.items[i] ) continue;' cr;
                put '        var opt = document.createElement("option");' cr;
                put '        var id = generateID();' cr;
                put '        if ( data.items[i].url )' cr;
                put '            opt.setAttribute("value", id + "@@@@@" + data.items[i].url);' cr;
                put '        else' cr;
                put '            opt.setAttribute("value", id);' cr;
                put '        opt.appendChild(document.createTextNode(data.items[i].label));' cr;
                put '        select.appendChild(opt)' cr;
                put '        makeSelectList(data.items[i], id);' cr;
                put '    }' cr;
                put cr;
                put '    document.getElementById("controls").appendChild(select);' cr;
                put cr;
                put '    return select;' cr;
                put '}' cr;
                put cr;
                put 'function displaySelectList()' cr;
                put '//' cr;
                put '// Display the next child select list' cr;
                put '//' cr;
                put '{' cr;
                put '    // Remove select lists that belong to another option' cr;
                put '    var controls = document.getElementById("controls");' cr;
                put '    while ( this.nextSibling )' cr;
                put '    {' cr;
                put '        this.nextSibling.selectedIndex = 0;' cr;
                put '        controls.appendChild(this.nextSibling);' cr;
                put '    }' cr;
                put cr;
                put '    // Get the ID and URL from the form value' cr;
                put '    var parts = this.options[this.selectedIndex].getAttribute("value").split("@@@@@");' cr;
                put '    var id = null;' cr;
                put '    var url = null;' cr;
                put cr;
                put '    if ( parts.length >= 1 )' cr;
                put '        id = parts[0];' cr;
                put '    if ( parts.length >= 2 )' cr;
                put '        url = parts[1];' cr;
                put cr;
                put '    // Load the specified URL in the appropriate frame' cr;
                put '    if ( url )' cr;
                put '    {' cr;
                put '        try {' cr;
                put '            parent.frames[parent.frames.length-1].location.href = url;' cr;
                put '        } catch ( err ) {' cr;
                put '            window.location.href = url;' cr;
                put '        }' cr;
                put '    }' cr;
                put cr;
                put '    // Display the new child select list' cr;
                put '    var elem = document.getElementById(id);' cr;
                put '    if ( !elem )' cr;
                put '        return;' cr;
                put '    document.getElementById("contents").appendChild(elem);' cr;
                put cr;
                put '    if ( elem.options.length == 2 )' cr;
                put '    {' cr;
                put '        elem.selectedIndex = 1;' cr;
                put '        elem.onchange()' cr;
                put '    }' cr;
                put '}' cr;
                put cr;
                put 'function initializeContents(contents)' cr;
                put '//' cr;
                put '// Initialize DOM nodes for displaying and hiding select lists' cr;
                put '//' cr;
                put '{' cr;
                put '    // Create container for holding cascading select lists' cr;
                put '    var body = document.getElementsByTagName("body")[0];' cr;
                put '    var toc = document.createElement("div");' cr;
                put '    toc.setAttribute("id", "contents");' cr;
                put '    body.appendChild(toc);' cr;
                put cr;
                put '    // Create hidden container for holding non-visible select lists' cr;
                put '    var controls = document.createElement("div");' cr;
                put '    controls.style.display = "none";' cr;
                put '    controls.setAttribute("id", "controls");' cr;
                put '    body.appendChild(controls);' cr;
                put cr;
                put '    // Create all of the select lists' cr;
                put '    toc.appendChild(makeSelectList(contents, "contents-top"));' cr;
                put '}' cr;
                put cr;
                put 'initializeContents({"items": [' cr;
                ndent;
            finish:
                xdent;
                put ']});' cr;
                put '</script>' cr;
        end;

        define event contents_list_branch;
            start:
                put '{' cr; 
                ndent; 
                put '"label": "' value '",' cr '"items": [' cr;
                ndent;
            finish:
                xdent;
                put ']' cr;
                xdent;
                put '}, ' cr;
        end;

        define event contents_list_leaf;
            putq '{"label": ' value;
            putq ', "url": ' url;
            put '},' cr;
        end;
        
        define event contents_body_branch;
            start:
                open contents_body;
                put '{' cr; 
                put '"label": "' value '",' cr '"items": [' cr;
                close;
            finish:
                open contents_body;
                put ']' cr;
                put '}, ' cr;
                close;
        end;

        define event contents_body_leaf;
            open contents_body;
            putq '{"label": ' value;
            putq ', "url": ' url;
            put '},' cr;
            close;
        end;
    
    /*******************************************************************************************/

       define event contents_javascript;
           /* trigger contents_bullet_style; */
           trigger contents_inline_code /if !any(code_name, code_url);
           trigger contents_code_link /if any(code_name, code_url);
           /*
           put CR;
           put "<style type=""text/javascript"">" CR;
           put "<!--" CR;
           put "  contextual(tags.UL, tags.DL).display = 'block';" CR;
           put "//-->" CR;
           put "</style>" CR;
           */
       end;

       define event contents_inline_code;
           trigger javascript_tag start;
           trigger contents_code;
           trigger javascript_tag finish;
       end;

       define event javascript_tag;
           start:
               put "<script language=""javascript"" type=""text/javascript"">" CR;
               put "<!-- " CR;
           finish:
               put CR;
               put "//-->" CR;
               put "</script>" CR;
        end;

        define event contents_code;
            put "var defaultlevel = -1;" CR;
            put "var openimage = 'folderopen.gif';" CR;
            put "var closeimage = 'folderclosed.gif';" CR;
            put CR;
            put "var initialized = false;" CR;
            put "var expanded = false;" CR;
            put CR;
            put "// Check for DOM support" CR;
            put "var DOMsupport = false;" CR;
            put 'if (document.getElementById && ' CR;
            put '    document.createTextNode && ' CR;
            put "    document.createElement)" CR;
            put "    DOMsupport = true;" CR;
            put CR;
            put "function getAllLists()" CR;
            put "//" CR;
            put "// Get a list of all lists in the document" CR;
            put "// " CR;
            put "{" CR;
            put "    var lists = new Array();" CR;
            put "    var uls = document.getElementsByTagName('UL');" CR;
            put "    for (var i = 0; i < uls.length; i++)" CR;
            put "        lists[lists.length] = uls[i];" CR;
            put "    var ols = document.getElementsByTagName('OL');" CR;
            put "    for (var i = 0; i < ols.length; i++)" CR;
            put "        lists[lists.length] = ols[i];" CR;
            put "    return lists;" CR;
            put "}" CR;
            put CR;
            put "function getAllListItems()" CR;
            put "//" CR;
            put "// Get a list of all list items in the document" CR;
            put "//" CR;
            put "{" CR;
            put "    return document.getElementsByTagName('LI');" CR;
            put "}" CR;
            put CR;
            put "function expandCollapse()" CR;
            put "{" CR;
            put "    if ( expanded ) collapseAll();" CR;
            put "    else expandAll();" CR;
            put "}" CR;
            put CR;
            put "function collapseAll()" CR;
            put "//" CR;
            put "// Collapse all lists down to 'level' " CR;
            put "//" CR;
            put "{" CR;
            put "    initAll(null, false);" CR;
            put "    expanded = false;" CR;
            put "}" CR;
            put CR;
            put "function expandAll(level)" CR;
            put "//" CR;
            put "// Expand all lists up to 'level' " CR;
            put "//" CR;
            put "{" CR;
            put "    initAll(level, true);" CR;
            put "    expanded = true;" CR;
            put "}" CR;
            put "" CR;
            put "function initAll(level, visible)" CR;
            put "//" CR;
            put "// Expand/collapse all lists up to 'level' " CR;
            put "//" CR;
            put "{" CR;
            put "    if ( !DOMsupport ) return;" CR;
            put CR;
            put "    // Initialize list elements to their starting behavior" CR;
            put "    if ( !initialized ) " CR;
            put "    {" CR;
            put "        initialized = true;" CR;
            put CR;
            put "        // Set onclick events for all items with nested lists" CR;
            put "        var items = getAllListItems();" CR;
            put "        for (var i = 0; i < items.length; i++)" CR;
            put "        {" CR;
            put "            var elem = items[i];" CR;
            put "            if ( elem.getElementsByTagName('UL') ||" CR;
            put "                 elem.getElementsByTagName('OL') )" CR;
            put "            {" CR;
            put "                elem.onclick = toggleView;" CR;
            put "                elem.style.cursor = 'pointer';" CR;
            put "            }" CR;
            put "        }" CR;
            put CR;
            put "        collapseAll();" CR;
            put "    }" CR;
            put CR;
            put "    // If level is undefined or less than zero, expand everything" CR;
            put "    if ( !level || level < 0 ) " CR;
            put "        level = -1;" CR;
            put CR;
            put "    var lists = getAllLists();" CR;
            put CR;
            put "    for (var i=0; i < lists.length; i++)" CR;
            put "    {" CR;
            put "        nesting = getNestingLevel(lists[i]);" CR;
            put '        if ( nesting == 0 && visible == false )' CR;
            put "            continue;" CR;
            put "        if ( level == -1 || nesting < level )" CR;
            put "        {" CR;
            put "            setDisplay(lists[i], visible);" CR;
            put CR;
            put "            var li = lists[i].parentNode;" CR;
            put '            while ( li && li.nodeName != ''LI'' )' CR;
            put "                li = li.parentNode;" CR;
            put "            if ( li ) setImage(li, visible);" CR;
            put "        }" CR;
            put "    }" CR;
            put "}" CR;
            put CR;
            put "function setDisplay(elem, visible)" CR;
            put "{" CR;
            put "    var display = (visible) ? 'block' : 'none';" CR;
            put "    elem.style.display = display;" CR;
            put "}" CR;
            put CR;
            put "function setImage(elem, visible)" CR;
            put "{" CR;
            put "    if ( !openimage || !closeimage ) return;" CR;
            put CR;
            put "    var images = elem.getElementsByTagName('IMG');" CR;
            put "    " CR;
            put "    if ( !images.length ) return;" CR;
            put CR;
            put "    var image = images[0];" CR;
            put CR;
            put "    image.src = ( visible ) ? openimage : closeimage;" CR;
            put "}" CR;
            put CR;
            put "function toggleView(e)" CR;
            put "//" CR;
            put "// If the children of this item are hidden, display them." CR;
            put "// If they are displayed, hide them." CR;
            put "//" CR;
            put "{" CR;
            put "    var elem = (window.event) ? window.event.srcElement : e.target;" CR;
            put CR;
            put '    while ( elem && elem.nodeName != ''LI'' )' CR;
            put "        elem = elem.parentNode;" CR;
            put CR;
            put "    if ( !elem ) return;" CR;
            put CR;
            put "    var children = elem.childNodes;" CR;
            put CR;
            put "    for (var i = 0; i < children.length; i++)" CR;
            put "    {" CR;
            put "        c = children[i];" CR;
            put '        if ( c.nodeName != ''UL'' && c.nodeName != ''OL'' ) continue;' CR;
            put "        if ( !c.style ) continue;" CR;
            put "        setImage(elem, (c.style.display != 'block'));" CR;
            put "        setDisplay(c, (c.style.display != 'block'));" CR;
            put "    }" CR;
            put CR;
            put "    if (window.event) window.event.cancelBubble = true;" CR;
            put "    else if (e.stopPropagation) e.stopPropagation();" CR;
            put "" CR;
            put "    return true;" CR;
            put "}" CR;
            put "" CR;
            put "function getNestingLevel(elem)" CR;
            put "//" CR;
            put "// Get the nesting level of the given list" CR;
            put "//" CR;
            put "{" CR;
            put "    var parent = elem.parentNode;" CR;
            put "    var level = 0;" CR;
            put '    while ( parent && parent.nodeName != ''BODY'' )' CR;
            put "    { " CR;
            put "        if ( parent.nodeName == 'UL' || " CR;
            put "             parent.nodeName == 'OL' )" CR;
            put "            level++;" CR;
            put "        parent = parent.parentNode;" CR;
            put "    }" CR;
            put "    return level;" CR;
            put "}" CR;
            put CR;
            put "function _getElementsByClassName(name)" CR;
            put "//" CR;
            put "// DOM method that gets a list of elements by class name" CR;
            put "//" CR;
            put "{" CR;
            put "    var elems = document.getElementsByTagName('*');" CR;
            put "    var retvalue = new Array();" CR;
            put "    var i, j;" CR;
            put "" CR;
            put "    for (i = 0, j = 0; i < elems.length; i++)" CR;
            put "    {" CR;
            put "        var c = ' ' + elems[i].className + ' ';" CR;
            put "        if (c.indexOf(' ' + name + ' ') != -1)" CR;
            put "            retvalue[j++] = elems[i];" CR;
            put "    }" CR;
            put "    return retvalue;" CR;
            put "}" CR;
            put "" CR;
            put "document.getElementsByClassName = _getElementsByClassName;" CR;
            put "" CR;
            put "function setup() " CR;
            put "//" CR;
            put "// Onload event method to setup all initial parameters " CR;
            put "//" CR;
            put "{ " CR;
            put "    if ( initialized ) return;" CR;
            put "    if ( !document.getElementsByTagName('body')[0].hasAttribute('onload') )" CR;
            put "        expandAll(defaultlevel); " CR;
            put "}" CR;
            put "" CR;
            put "// Setup onload and onclick events" CR;
            put "if ( DOMsupport )" CR;
            put "{" CR;
            put "    if ( window.addEventListener )" CR;
            put "        window.addEventListener('load', setup, false);" CR;
            put "    else" CR;
            put "        window.onload = setup;" CR;
            put "}" CR;
        end;

        define event contents_head;
            start:
              trigger doc_head;
            finish:
              trigger contents_javascript;
              trigger doc_head;
        end;

        define event contents_code_link;
            put "<script";
            putq " src=" code_name /if !exists(code_url);
            putq " src=" code_url /if exists(code_url);
            put ' language="javascript" type="text/javascript">';
            put "</script>" CR;
        end;

        define event top_head;
            start:
                put "<head>" CR;
                put VALUE CR;
            finish:
                put "</head>" CR;
        end;

        define event doc_title;
               put "<title>";
               put "SAS Output" / if !exists(VALUE);
               put VALUE;
               put "</title>" CR;
        end;

        define event content_title;
               put "<title>";
               put "SAS Output" / if !exists(VALUE);
               put VALUE;
               put "</title>" CR;
        end;

        define event doc_meta;
            put '<meta name="Generator" content="SAS Software';
            set $generic getoption('generic');
            /*putlog "GENERIC: " $generic;*/
            put ' Version ' SASVERSION /if cmp($generic, 'NOGENERIC');
            put ', see www.sas.com"';
            put $empty_tag_suffix;
            put '>' CR;
            trigger show_charset;
            put "<meta " VALUE $empty_tag_suffix ">" nl /if exists(value);
            break /if !any( htmlcontenttype, encoding);
            break /if ^exists(htmlcontenttype) and ^exists($show_charset);
            put "<meta";
            put ' http-equiv="Content-type" content="';
            put HTMLCONTENTTYPE;
            put "; " / if exists(HTMLCONTENTTYPE, encoding, $show_charset);
            put "charset=" encoding / if exists($show_charset);
            put '"';
            put $empty_tag_suffix;
            put '>' CR;
        end;

        define event top_meta;
            put '<meta name="Generator" content="SAS Software';
            set $generic getoption('generic');
            /*putlog "GENERIC: " $generic;*/
            put ' Version ' SASVERSION /if cmp($generic,'NOGENERIC');
            put ', see www.sas.com"';
            put $empty_tag_suffix;
            put '>' CR;
            trigger show_charset;
            put "<meta " VALUE $empty_tag_suffix ">" nl /if exists(value);
            break /if !any( htmlcontenttype, encoding, $show_charset);
            put "<meta";
            put ' http-equiv="Content-Type" content="' / if any(HTMLCONTENTTYPE, encoding,
                                                                $show_charset);
            put HTMLCONTENTTYPE;
            put "; " / if exists(HTMLCONTENTTYPE, encoding, $show_charset);
            put "charset=" encoding / if exists($show_charset);
            put '"';
            put $empty_tag_suffix;
            put '>' CR;
        end;

        /* Web Accessibility Feature 1194.22 (I)   */
        /*-----------------------------------------*/
        define event doc_body;
            put '<body';
            do /if $scroll_tables;
                put ' onload="setupLongTables()"';
            else;
                put ' onload="startup()"';
            done;
            put ' onunload="shutdown()"';
            put  ' bgproperties="fixed"' / WATERMARK;
            putq " background=" BACKGROUNDIMAGE;
            trigger style_inline;
            put ">" CR;
            trigger pre_post;
            put          CR;
            trigger ie_check;
          finish:
            trigger pre_post;
            trigger contents_body_list;
            put "</body>" CR;
       end;
      
       define event contents_body_list;
            do /if $contents_body;
                trigger contents_list2 start;
                put $$contents_body;
                trigger contents_list2 finish;
            done;
                
            do /if $contents_tree;
                put '<div id="contents_tree" class="contents">' nl;
                put $$contents_tree nl;
                put "</div>" nl;
                trigger contents_tree_script;
            done;

            unset $$contents_body;
            unset $$contents_tree;
        end;
        
        define event contents_tree_script;
            putl '<script type="text/javascript">';
            putl '<!--';
                putl 'var width = 0; ';
                putl 'var height = 0;';
            putl '';
                putl "if ( typeof( window.innerWidth ) == 'number' ) ";
                putl '{';
                    putl 'width = window.innerWidth;';
                    putl 'height = window.innerHeight;';
                putl '} ';
                putl 'else if ( document.documentElement && ';
                          putl '( document.documentElement.clientWidth || ';
                            putl 'document.documentElement.clientHeight ) ) ';
                putl '{';
                    putl 'width = document.documentElement.clientWidth;';
                    putl 'height = document.documentElement.clientHeight;';
                putl '} ';
                putl 'else if ( document.body && ';
                          putl '( document.body.clientWidth || ';
                            putl 'document.body.clientHeight ) ) ';
                putl '{';
                    putl 'width = document.body.clientWidth;';
                    putl 'height = document.body.clientHeight;';
                putl '}';
            putl '';
                putl "var contents = document.getElementById('contents');";
                putl 'if ( height )';
                putl '{';
                    putl "contents.style.height = height + 'px';";
                    putl '// Adjust for scrollbars';
                    putl 'i = 1;';
                    putl 'while ( contents.offsetHeight > height )';
                    putl '{';
                        putl "contents.style.height = (height-i) + 'px';";
                        putl 'i++;';
                    putl '}';
                putl '}';
            putl '-->';
            putl '</script>';
            
        end;
            
        define event doc_foot;
            start:
                put "<foot>" CR;
            finish:
                put "</foot>" CR;
        end;

        define event startup_function;
            start:
                put "function startup(){" CR CR;
            finish:
                put TAGATTR CR;
                put "}" CR;
        end;

        define event shutdown_function;
            start:
                put "function shutdown(){" CR CR;
            finish:
                put TAGATTR CR;
                put "}" CR;
        end;

        define event windowload;
            put VALUE CR;
        end;

        define event contents;
            start:
                put HTMLDOCTYPE CR;
                put "<html>" CR;
            finish:
                put "</html>" CR;
        end;

        define event contents_body;
            start:
                put "<body";
                putq " class=" HTMLCLASS;
                trigger style_inline;
                put ">" CR;
            finish:
                put "</body>" CR;
        end;

        define event preformatted;
            start:
                put "<pre>";
            finish:
                put "</pre>";
        end;

        define event contents_title;
            put "<span";
            putq " class=" HTMLCLASS;
            put '>';
            put PREHTML CR ;
            put PREIMAGE CR;
            put PRETEXT CR ;
            put POSTIMAGE CR;
            put POSTTEXT CR ;
            put POSTHTML CR;
            put "</span>";
        end;

        define event list;
            start:
                put "<";
                trigger list_tag;
                trigger listclass;
                put ">" CR;
            finish:
                put "</";
                trigger list_tag;
                put ">" CR;
        end;

        /*-------------------------------------------------------eric-*/
        /*-- All this so we don't get the style class on the top    --*/
        /*-- level of the list.  If we did then the margins are     --*/
        /*-- much wider than we'd like.                             --*/
        /*----------------------------------------------------14Jun02-*/
        define event listclass;
            break /if cmp(htmlclass, "contents");
            break /if cmp(htmlclass, "pages");
            putq " class=" HTMLCLASS ;
        end;

        define event list_entry;
            start:
                put "<li";
                putq " class=" HTMLCLASS;
                put ">" nl;
                trigger do_link /if listentryanchor;
                trigger do_list_value/if !listentryanchor;
            finish:
                put "</li>" nl;
        end;


        define event do_link;
            trigger hyperlink_value / if any(URL, ANCHOR);
            put VALUE / if !any(URL, ANCHOR);
        end;

        define event do_list_value;
            put value;
        end;

        define event hyperlink_value;
            trigger hyperlink start;
            trigger hyperlink finish;
        end;

        define event hyperlink;
            start:
                break /if ^URL;
              put '<a href="' URL;
              set $close_hyperlink "TRUE";
            /*put "#" ANCHOR;*/
            put '"';
            do /if cmp(dest_file, 'contents');
              putq " target=" HREFTARGET / if frame_name;
            else;
              putq " target=" HREFTARGET /if ^$no_target;
            done;
            put ">";
            trigger preformatted start /if asis;
            put VALUE;
        finish:
            break /if ^$close_hyperlink;
            unset $close_hyperlink;
            trigger preformatted finish /if asis;
            put "</a>" CR;
        end;

        define event contents_list;
            start:
                putlog "CONTENTS LIST" ": " $contents_list;
                trigger contents_list2 /breakif $contents_list;
                put "<";
                trigger list_tag;
                trigger listclass;
                put ">" CR;
            finish:
                trigger contents_list2 /breakif $contents_list;
                put "</";
                trigger list_tag;
                put ">" CR;
        end;

        define event contents_branch;
            file=CONTENTS;
            start:
                trigger contents_list_branch /breakif $contents_list;
                trigger list_entry start;
                trigger list;
            finish:
                trigger contents_list_branch /breakif $contents_list;
                trigger list finish;
                trigger list_entry finish;
        end;

        define event contents_leaf;
            file=CONTENTS;
            trigger contents_list_leaf /breakif $contents_list;
            trigger list_entry start;
            trigger list_entry finish;
        end;

        define event body_branch;
            start:
                trigger contents_body_branch /if $contents_body;
                break /if ^$contents_tree;
                open contents_tree;
                set $no_target 'yes';
                trigger list_entry start;
                trigger list;
                unset $no_target;
                close;
            finish:
                trigger contents_body_branch /if $contents_body;
                break /if ^$contents_tree;
                open contents_tree;
                trigger list finish;
                trigger list_entry finish;
                close;
        end;

        define event body_leaf;
            trigger contents_body_leaf /if $contents_body;
            break /if ^$contents_tree;
            open contents_tree;
            set $no_target 'yes';
            trigger list_entry start;
            trigger list_entry finish;
            unset $no_target;
            close;
        end;
        /*putlog "list_tag:" $list_tag " event:" event_name " state:" state " class:" htmlclass;*/

        define event pages_branch;
            file=PAGES;
            start:
                trigger list_entry start;
                trigger Page_list;
            finish:
                trigger Page_list finish;
                trigger list_entry finish;
        end;

        define event page_list;
            style=PagesItem;
            start:
                put "<";
                trigger list_tag;
                trigger listclass;
                put ">" CR;
            finish:
                put "</";
                trigger list_tag;
                put ">" CR;
        end;

        define event list_tag;
            set $list_tag "ul";
            set $list_tag "ol" /if cmp(htmlclass, 'contents');
            set $list_tag "ol" /if cmp(htmlclass, 'pages');
            put $list_tag;
        end;

        define event page_anchor;
            file=PAGES;
            start:
                put "<li";
                putq " class=" HTMLCLASS;
                put ">" nl;
                put '<a href="' ;
                put body_name /if !exists(body_url);
                put body_url;
                put "#" ANCHOR;
                put '"';
                putq ' target="body" ';
                put ">";
                put 'Page ' total_page_count;
                put "</a>" CR;

            finish:
                put "</li>" nl;
        end;

        define event anchor;
            putq "<a name=" NAME "></a>" CR / if length(NAME);
        end;

        define event breakline;
            put "<br";
            put $empty_tag_suffix;
            put ">";
        end;

        define event splitline;
            put "<br";
            put $empty_tag_suffix;
            put ">";
        end;

        define event line;
            put "<hr";
            put $empty_tag_suffix;
            put ">";
        end;

        define event pagebreak;
            unset $no_pagebreak /breakif $no_pagebreak;
            do /if cmp($pagebreak, 'no');
                break;
            else /if cmp($pagebreak, 'yes');
                put PAGEBREAKHTML CR;
            else /if $pagebreak;
                put $pagebreak nl;
            done;
        end;

        define event map;
            start:
                put "<map";
                putq " name=" NAME ">" CR;
            finish:
                put "</map>" CR;
        end;

        define event map_area;
            start:
                put "<area";
                putq " shape=" shape;
               /*HREF STUFF GOES in HERE*/
                put " " value;
                put ' href="' /if any(url, htmlid);
                put url '#' htmlid;
                put '"' /if any(url, htmlid);
                putq ' target=' target;
        finish:
                put '"' /if exists($coord_started);
                unset $coord_started;
                put $empty_tag_suffix;
                put '>' CR;
        end;

        define event map_coordinate;
            put ' coords="' / if !exists($coord_started);
            put ',' / if exists($coord_started);
            set $coord_started "true";
            put coordinate;
        end;

        /*
        <embed height="100%" width="100%" name="SVGEmbed"
               style="height:3168px; width:815px"
               src="\\sashq\root\u\sasdza\svg\col3.svg"
               type="image/svg+xml"
               pluginspage="http://www.adobe.com/svg/viewer/install/"></embed>
        */

        define event embed_svg;
            style=Graph;
            pure_style;
            put '<div';
            trigger alt_align;
            put '>' nl;
            put '<embed  name="SVGEmbed"';
            put ' wmode="transparent"';
            set $outputwidth '100%';
            set $outputheight '100%';
            trigger graph_style_inline;
            put ' src="';
            put BASENAME / if !exists(NOBASE);
            put URL;
            put '"';
            put ' type="image/svg+xml"';
            put ' pluginspage="http://www.adobe.com/svg/viewer/install/"></embed>';
            put "</div>" CR;
        end;


        define event image;

            trigger embed_svg /breakif cmp(device_type, 'SVG');
            trigger embed_svg /breakif cmp(device_type, 'SVGZ');

/*
            put '<div';
            trigger alt_align;
            put '>' nl;
*/
            put "<img";
            putq ' alt=' alt;
            put ' src="';
            put BASENAME / if !exists(NOBASE);
            put URL;
            put '"';
            trigger graph_style_inline;
            put ' border="0"';
            put ' usemap="#' @CLIENTMAP;
            put ' usemap="#' NAME / if !exists(@CLIENTMAP);
            put '"' / if any(@CLIENTMAP , NAME);
            putq " id="    HTMLID;
            trigger classalign;
            put $empty_tag_suffix;
            put ">" CR;
/*
            put "</div>" CR;
*/

        end;

        define event paragraph;
            start:
                put "<div";
                putq " id="    HTMLID;
                trigger classalign;
                trigger style_inline;
                put ">";
                trigger pre_post start;
                put  VALUE;
                put  TEXT /if ^value;    /* could be text or value, or both.. */
                trigger pre_post finish;
                put "</div>" nl;
        end;

     /* Web Accessibility Feature 1194.2 (H) */
     /*--------------------------------------*/
     define event table;
         start:
             put "<div";
             trigger alt_align;
             put ">" CR;
             trigger table_caption;
             put "<table";
             trigger style_inline;
             putq " id="    HTMLID;
             trigger do_borders;
             trigger table_summary;
             put ">" CR;
         finish:
             put "</table>" CR;
             put "</div>" CR;
     end;

     define event verbatim_container;
         start:
             put "<div";
             trigger alt_align;
             put ">" CR;
             trigger pre_post;
         finish:
             trigger pre_post;
             put "</div>" CR;
     end;

     define event verbatim;
         start:
             trigger preformatted;
         finish:
             trigger preformatted;
     end;

     define event verbatim_text;
             put value;
             put nl;
     end;

     define event table_caption;
         break /if ^$summary_as_caption;
         put '<span style="caption">';
         trigger build_summary;
         put '</span>' nl;
     end;

     define event build_summary_stream;
            open table_summary;
            trigger build_summary;
            close;
     end;

     define event clean_string;
          set $string  tranwrd($string, '<', '&lt;');
          set $string  tranwrd($string, '>', '&gt;');
          set $string  tranwrd($string, '"', '&quot;');
          set $string  tranwrd($string, "'", '&apos;');
     end;

     define event build_summary;
             set $summary summary /if ^$summary;
             put $summary_attribute;
             put $summary_prefix;
         put $summary;
             do /if ^$summary;
                 put "Procedure " proc_name ": ";
               do /if $clean_summary;
                   set $string output_label;
                   trigger clean_string;
                   put $string;
                   unset $string;
               else;
                   put output_label;
               done;
               put output_name /if !exist(output_label);
             done;
             do /if $summary_byvars;
                 put ", By " /if $byvars;
                 iterate $byvars;
                 eval $count 0;
                 do /while _name_;
                     put ', ' /if $count > 0;
                     put _name_;
                     put '=' _value_ /if $summary_byvals;
                     next $byvars;
                     eval $count $count + 1;
                 done;
             done;

            done;
            put $summary_suffix;
     end;

     define event table_summary;
             set $clean_summary "TRUE";
             put ' summary="';
             trigger build_summary;
             put '"';
             unset $clean_summary;
     end;

        define event table_head;
            put "<thead>" CR;
        finish:
            put "</thead>" CR;
        end;

        define event table_body;
            put "<tbody>" CR;
        finish:
            put "</tbody>" CR;
        end;

        define event table_foot;
            put "<tfoot>" CR;
        finish:
            put "</tfoot>" CR;
        end;

        define event table_label;
            block breakline;
        finish:
            unblock breakline;
        end;

        define event table_headers;
            block breakline;
        finish:
            unblock breakline;
        end;

        define event colgroup;
            put "<colgroup>" CR;
        finish:
            put "</colgroup>" CR;
        end;

        define event colspec_entry;
            put "<col";
            put $empty_tag_suffix;
            put ">" CR;
        end;

        define event row;
            put "<tr>" CR;
        finish:
            put "</tr>" CR;
        end;

        /* Web Accessibility Feature 1194.22 (G&H) */
        /*-----------------------------------------*/
        define event rowcol;
            putq ' rowspan=' ROWSPAN;
            putq ' colspan=' COLSPAN;

            trigger rowhead / breakif contains(HTMLCLASS,"RowHeader");
            trigger colhead / if contains(HTMLCLASS,"eader");
        end;


        /* Web Accessibility Feature 1194.22 (G&H) */
        /*-----------------------------------------*/
        define event rowhead;                                 /* 508 */
            do /if exists(ROWSPAN);
              put ' scope="rowgroup"';
            else;
              put ' scope="row"';
            done;
        end;

        /* Web Accessibility Feature 1194.22 (G&H) */
        /*-----------------------------------------*/
        define event colhead;                                /* New Event */
            do /if exists(COLSPAN);
               put ' scope="colgroup"';
            else;
               put ' scope="col"';
            done;
        end;

        /* for compatibility with past releases and other tagsets */
        define event align;
             trigger real_align start;
             trigger real_align finish;
        end;

        define event real_align;
            start:

                do /if ^any(just,vjust);
                    put ' class="' /if htmlclass;;
                    break;
                done;

                set $vjust vjust;
                set $just just;
                set $just "r" /when cmp("d", just);
                set $vjust "m" /when cmp("c", vjust);
                put ' class="';
                put $just;
                put ' ' /if exists($just, $vjust);
                put $vjust;
                unset $vjust;
                unset $just;
            finish:
                put '"' /if any(just,vjust,htmlclass);
        end;

        define event classalign;
            trigger real_align start;
            put ' ' htmlclass;
            trigger real_align finish;
        end;

        define event header;
            start:
                put "<th";
                putq " id="    HTMLID;
                putq " headers=" headers / if $header_data_associations;
                trigger rowcol;
                trigger align;
                put " nowrap" /if no_wrap;
                put ">";
                trigger cell_value;
            finish:
                trigger cell_value;
                put "</th>" CR;
        end;

        define event data;
            start:
                put "<td";
                putq " id="    HTMLID;
                putq " headers=" headers / if $header_data_associations;
                trigger rowcol;
                trigger align;
                put " nowrap" /if no_wrap;
                put ">";
                trigger cell_value;
            finish:
                trigger cell_value;
                put "</td>" CR;
        end;

        define event data_note;
            start:
                trigger data;
            finish:
                trigger data;
        end;

        define event stacked_cell;
            start:
                put '<td class="stacked_cell ' htmlclass '">';
                put '<table width="100%" border="0" style="border-width: 0px"';
                do /if ^$css_table;
                    putq ' cellpadding=' $parent_table_padding;
                    putq ' cellspacing="0"';
                done;
                put '>' nl;
            finish:
                put '</table></td>' nl;
        end;

        define event stacked_value;
            start:
                put "<tr>" nl;
                trigger data;
            finish:
                trigger data;
                put "</tr>" nl;
        end;

        define event stacked_value_header;
            start:
                put "<tr>" nl;
                trigger header;
            finish:
                trigger header;
                put "</tr>" nl;
        end;

        define event cell_value;
          start:
            trigger preformatted /if asis;
            trigger hyperlink;
            do / if !exists(URL);
                trigger do_header_dots;
                put value ;
            done;
          finish:
            trigger hyperlink;
            trigger preformatted /if asis;
        end;

        define event cell_is_empty;
            put '&nbsp;';
        end;

        define event alt_align;
            putq ' align=' $just_lookup[just];
        end;

        /* Web Accessibility Feature 1194.22 (H) */
        /*---------------------------------------*/
        define event association;
            put '<div';
            trigger alt_align;
            put '>' nl;
            put '<table ';
            put ' summary="Page Layout"';
            trigger style_inline;
            put '>';
            put "<tr>" CR;
        finish:
            put "</tr>" CR;
            put "</table>" CR;
            put "</div>" CR;
        end;

        define event assoc_end_got_capt;
            put "</td>";
        end;

        define event caption;
            put "<td";
            putq " id=" htmlid;
            putq " title=" flyover;
            trigger classalign;
            trigger style_inline;
            put ">";
            put TEXT;
        finish:
            put "</td>" CR;
            put "</tr><tr><td>" / if cmp(TYPE, "T");
            put "<td>" / if cmp(TYPE, "L");
        end;

        /*==========ODA==========*/

        define event pre_post;
            start:
                put PREHTML;
                putq '<img alt="" src=' PREIMAGE;
                put  $empty_tag_suffix /if exists(PREIMAGE);
                put '>' /if exists(PREIMAGE);
                put PRETEXT;
            finish:
                put POSTTEXT;
                putq '<img alt="" src=' POSTIMAGE;
                put  $empty_tag_suffix /if exists(POSTIMAGE);
                put '>' /if exists(POSTIMAGE);
                put POSTHTML;
        end;

        define event proc;
            put "<div class=""branch"">" CR;
        finish:
            put "</div>" CR;
        end;

        define event output;
            put "<div>" CR;
        finish:
            put "</div>" CR;
            put "<br";
            put $empty_tag_suffix;
            put ">" CR;
        end;

        Define event align_output;
            put "<div ";
            trigger align;
            put ">" CR;
        finish:
            put "</div>" CR;
        end;

        define event byline;
            put "<h1";
            trigger align;
            put ">";
            put VALUE;
            put "</h1>" CR;
        end;

        define event proc_title;
            put "<h2";
            trigger align;
            put ">";
            put VALUE;
            put "</h2>" CR;
        end;

        /*-------------------------------------------------------eric-*/
        /*-- For inline formatting.  Currently, everything is       --*/
        /*-- a span function.  That could be enhanced to more       --*/
        /*-- varied events later.                                   --*/
        /*----------------------------------------------------5Mar 03-*/
        define event span;
            start:
             trigger pre_post;
             set $pre_post POSTTEXT;
             do /if postimage;
                 set $pre_post $pre_post '<img alt="" src=' '"' POSTIMAGE '"';
                 set $pre_post $pre_post  $empty_tag_suffix;
                 set $pre_post $pre_post  '>';
             done;
             set $pre_post $pre_post POSTHTML;
             put '<span';
             putq " title=" flyover;
             trigger classalign; /* fwh */
             trigger style_inline;
             put ">";
             do /if asis;
                 set $span_asis "TRUE";
                 trigger preformatted;
             done;
             trigger hyperlink;
             trigger do_value / if !exists(URL);
         finish:
             trigger hyperlink;
             trigger preformatted /if $span_asis;
             unset $span_asis;
             put "</span>";
             put $pre_post;
             unset $pre_post;
         end;

        define event format;
             put '<span';
             trigger style_inline;
             put ">";
             trigger preformatted start /if asis;
             put value;
             trigger preformatted finish /if asis;
             put "</span>";
        end;

        define event title_format_section;
             put '<span';
             trigger style_inline;
             put ">";
             trigger hyperlink_value;
             do / if !exists(URL);
                 trigger preformatted start /if asis;
                 put VALUE;
                 trigger preformatted finish /if asis;
             done;
             put "</span>";
        end;


        define event proc_title_group;
          finish:
            put "<p";
            put $empty_tag_suffix;
            put ">"  nl;
        end;

        define event proc_note_group;
          start:
            put "<br";
            put $empty_tag_suffix;
            put ">"  nl;
            put "<p";
            put $empty_tag_suffix;
            put ">"  nl;
          finish:
            put "<p";
            put $empty_tag_suffix;
            put ">"  nl;
        end;

        define event system_title;
          start:
            put "<h1";
            trigger align;
            put ">";
            put VALUE;
            break /if exists(value);
            put '&nbsp;' /if exists(empty);
          finish:
            put "</h1>" nl;
        end;

        define event system_footer;
          start:
            put "<h1";
            trigger align;
            put ">";
            put VALUE;
          finish:
            put "</h1>" CR;
        end;

        define event note;
            put "<h3";
            trigger align;
            put ">";
            put VALUE;
            put "</h3>" CR;
        end;

        define event warning;
            put "<h3";
            trigger align;
            put ">";
            put VALUE;
            put "</h3>" CR;
        end;

        define event error;
            put "<h3";
            trigger align;
            put ">";
            put VALUE;
            put "</h3>" CR;
        end;


        define event fatal;
            put "<h3";
            trigger align;
            put ">";
            put VALUE;
            put "</h3>" CR;
        end;

        define event branch;
            start:
                break / if hidden;
                trigger body_branch;
                trigger contents_branch;
            finish:
                break / if hidden;
                trigger body_branch;
                trigger contents_branch;
        end;

        define event proc_branch;
            start:
                break / if hidden;
                set $proc_name "true";
                trigger body_branch;
                trigger contents_branch;
                trigger pages_branch;
                unset $proc_name;
            finish:
                break / if hidden;
                set $proc_name "true";
                trigger body_branch;
                trigger contents_branch;
                trigger pages_branch;
                unset $proc_name;
        end;

        define event leaf;
        start:
           break / if hidden;
           trigger body_leaf;
           trigger contents_leaf;
        end;


        /**********************************/
        /* These events are specific to   */
        /* javameta output. Some of these */
        /* are also applicable to the     */
        /* MSOffice2k tagset (cdh)        */
        /**********************************/

        define event java_graph;
            start:
                put  "<APPLET " CR;
                putq " ID=" ref_id CR;
                put  " MAYSCRIPT" CR;

            finish:
                put "</APPLET> " CR;
        end;

        define event java_unsupported;
            put "Sorry, your browser does not support the applet tag." CR;
            putq 'The graph ' code ' cannot be displayed.' CR;
        end;

        define event metacode_parameter;
            start:
               put '<PARAM NAME="MetaCodes"';
               put ' VALUE="';
            finish:
               put ' ">' CR;
        end;

        define event graph_actx_width;
           style=Graph;
           pure_style;
           put ' WIDTH="' COLWIDTH 'px"' CR / breakif !cmp(COLWIDTH , "0" );
           putq " WIDTH=" OUTPUTWIDTH CR / if exists(OUTPUTWIDTH);
           put ' WIDTH="640px"' CR / if !exists(OUTPUTWIDTH);
        end;

        define event graph_actx_height;
           style=Graph;
           pure_style;
           put ' HEIGHT="' DEPTH 'px"' CR / breakif !cmp( DEPTH , "0" );
           putq " HEIGHT=" OUTPUTHEIGHT CR / if exists(OUTPUTHEIGHT);
           put ' HEIGHT="480px"' CR / if !exists(OUTPUTHEIGHT);
        end;


        define event graph_fxd_attributes;
            pure_style;
            trigger graph_actx_width;
            trigger graph_actx_height;
            putq " CLASS=" HTMLCLASS CR;
            put  ' ALIGN="top">' CR;
        end;

        define event graph_attribute;
            put " " NAME;
            putq "=" VALUE CR;
        end;

        define event graph_parameter;
            putq "<PARAM NAME=" NAME;
            putq " VALUE=" VALUE;
            put ">" CR;
        end;

        define event graph_border;
        end;

       /*** symbols **/
       define event super;
           start:
               put "<sup>" ;
               put VALUE;
               put "</sup>" ;
       end ;

       define event sub;
           start:
               put "<sub>" ;
               put VALUE;
               put "</sub>" ;
        end ;


        define event dagger;
            start:
                put '&dagger;' ;
        end ;

        define event nbspace;
            do /if value;
                break /if index(value,"-");
                eval $ncount inputn(value, "3.");
                do /if $ncount > 256;
                    eval $ncount 256;
                done;
            else;
                eval $ncount 1;
            done;

            do /while $ncount;
                put '&nbsp;' ;
                eval $ncount $ncount-1;
            done;
            unset $ncount;
        end;

        define event newline;
            unset $value;
            do /if value;
                break /if index(value,"-");
                eval $ncount inputn(value, "3.");
                do /if $ncount > 256;
                    eval $ncount 256;
                done;
            else;
                eval $ncount 1;
            done;

            do /while $ncount;
                put "<br>" nl;
                eval $ncount $ncount-1;
            done;
            unset $ncount;
        end;

        define event raw;
            start:
                put value;
        end;

        define event dest ;
         Notes "Dest function allows expansion of certain destination types";
         start :
            /* break it up, normalize it, put it out if it's friendly */
            set $dests scan(VALUE, 1, ']');
            set $argments scan(VALUE, 2, ']');
            set $dests lowcase($dests);
            put $argments /if  contains($dests, "html");
      end;


        define event sigma;
            start:
                put '&sigma;';
        end;
    end;

    /******************************************************/
    /******************************************************/
    /******************************************************/
    /*  XHTML1.0                                          */
    /******************************************************/
    /******************************************************/
    /******************************************************/

    define tagset tagsets.xhtml;
        notes "XHTML 1.0";
        parent=tagsets.html4;
        split="<br/>";

        define event doc;
            start:
                set $empty_tag_suffix ' /';
                set $doctype "<!DOCTYPE html PUBLIC ""-//W3C//DTD XHTML 1.0 Transitional//EN"">";
                set $framedoctype "<!DOCTYPE html PUBLIC ""-//W3C//DTD XHTML 1.0 Frameset//EN"">";
                put $doctype CR;
                put "<html>" CR;
            finish:
                put "</html>" CR;
        end;
    end;

    /******************************************************/
    /******************************************************/
    /******************************************************/
    /*  HTML4                                             */
    /******************************************************/
    /******************************************************/
    /******************************************************/

    define tagset tagsets.html4;
        notes "HTML 4.01";
        parent=tagsets.htmlcss;
        embedded_stylesheet=yes;


        define event doc;
            start:
                set $doctype "<!DOCTYPE html PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">";
                set $framedoctype "<!DOCTYPE html PUBLIC ""-//W3C//DTD HTML 4.01 Frameset//EN"">";
                put $doctype CR;
                put "<html>" CR;
            finish:
                put "</html>" CR;
         end;

         define event contents;
            start:
                put $doctype CR;
                put "<html>" CR;
            finish:
                put "</html>" CR;
         end;

         define event top_file;
            start:
                put $framedoctype CR;
                put "<html>" CR;
            finish:
                put "</html>" CR;
         end;

        define event contents_body;
            start:
                put "<body";
                putq " class=" HTMLCLASS;
                trigger style_inline;
                put ">" CR;
                trigger pre_post;
            finish:
                trigger pre_post;
                put "</body>" CR;
        end;

        define event preformatted;
            start:
                trigger nobreak /breakif cmp(data_viewer, 'Table');
                /*put '<a href="' anchor '-ascii">Skip ASCII Art</a>';*/
                put '<pre';
                putq " class=" HTMLCLASS;
                trigger style_inline;
                put '>';
            finish:
                trigger nobreak /breakif cmp(data_viewer, 'Table');
                put "</pre>";
                /*put '<a name="' anchor '-ascii"></a>';*/
        end;

        /*-------------------------------------------------------eric-*/
        /*-- translate the spaces to the string defined as the      --*/
        /*-- non-breaking space for this tagset.                    --*/
        /*----------------------------------------------------27Jan03-*/
        define event nobreak;
            start:
                set $nb_value tranwrd(value, ' ', space);
            finish:
                unset $nb_value;
        end;

        /*-------------------------------------------------------eric-*/
        /*-- This get's called by hyperlink and cell_value events   --*/
        /*-- to actually print the data value                       --*/
        /*----------------------------------------------------27Jan03-*/
        define event do_value;
            trigger do_header_dots;
            put VALUE /if !exists($nb_value);
            put $nb_value;
        end;

    end;


    /******************************************************/
    /******************************************************/
    /******************************************************/
    /*  MSOFFICE2K                                        */
    /******************************************************/
    /******************************************************/
    /******************************************************/

    define tagset tagsets.MSOffice2k;
        notes "Special tagset for MSOffice consumption.";
        output_type = 'ms2k';
        parent=tagsets.html4;
        embedded_stylesheet=yes;
        mvar _EXCELROWHEIGHT;
        mvar _INEXCEL;
        mvar _DECIMAL_SEPARATOR;
        mvar _THOUSANDS_SEPARATOR;

         define event initialize;
             trigger set_just_lookup;
             trigger set_nls_num;
             trigger grand_init;
             trigger set_options;
             trigger store_all_borders;
             trigger documentation;
         end;

         define event set_nls_num;
             unset $decimal_separator;
             unset $thousand_separator;

             set $decimal_separator $options['DECIMAL_SEPARATOR'] /if $options;
             set $decimal_separator _DECIMAL_SEPARATOR /if ^$decimal_separator;
             set $decimal_separator '\.' /if ^$decimal_separator;

             set $thousand_separator $options['THOUSAND_SEPARATOR'] /if $options;
             set $thousand_separator _THOUSANDS_SEPARATOR /if ^$thousand_separator;
             set $thousand_separator '\,' /if ^$thousand_separator;
         end;

         define event style_inline;
             trigger style_inline_w_just;
         end;

         define event doc_head;
             start:
                 put "<head>" CR;
                 put VALUE CR ;
             finish:
                 put '<style type="text/css">' nl;
                 put 'table {' nl;
                 putq '  mso-displayed-decimal-separator:' $decimal_separator ';' nl;
                 putq '  mso-displayed-thousand-separator:' $thousand_separator ';' nl;
                 put '}' nl;
                 put '</style>' nl;
                 put "</head>" CR;
         end;


        define event doc;
            start:
                put '<html xmlns:v="urn:schemas-microsoft-com:vml">' CR;
            finish:
                put "</html>" CR;
        end;

        define event title_container;
        end;

        define event title_container_row;
        end;

        define event system_title;
          start:
            put "<h1";
            putq ' class=' htmlclass;
            trigger align;
            trigger style_inline;
            put ">";
            put VALUE;
            break /if exists(value);
            put '&nbsp;' /if exists(empty);
          finish:
            put "</h1>" nl;
        end;

        define event system_footer;
          start:
            put "<h1";
            putq ' class=' htmlclass;
            trigger align;
            trigger style_inline;
            put ">";
            put VALUE;
          finish:
            put "</h1>" CR;
        end;

        define event note;
            put "<h3";
            putq ' class=' htmlclass;
            trigger align;
            put ">";
            put VALUE;
            put "</h3>" CR;
        end;

        define event warning;
            put "<h3";
            putq ' class=' htmlclass;
            trigger align;
            put ">";
            put VALUE;
            put "</h3>" CR;
        end;

        define event error;
            put "<h3";
            putq ' class=' htmlclass;
            trigger align;
            put ">";
            put VALUE;
            put "</h3>" CR;
        end;


        define event fatal;
            put "<h3";
            putq ' class=' htmlclass;
            trigger align;
            put ">";
            put VALUE;
            put "</h3>" CR;
        end;

        /*
        define event rowspancolspanfill;
            break /if $body_section;

                eval $count inputn(colspan, 'BEST') - 1;
                put "<td";
                putq " colspan=" colspan;
                put ">&nbsp;</td>" nl;
            end;
        */

      /* Web Accessibility Feature 1194.22 (G&H) */
      /*-----------------------------------------*/
       define event data;
          start:
             /* this would work but sometimes htmlclass is empty... */
             trigger header /breakif cmp(htmlclass, "RowHeader");
             trigger header /breakif cmp(htmlclass, "Header");

             do /if ^$cell_count;
                 do /if cmp(rowspan, "2");
                     open row;
                     eval $cell_count 1;
                 done;
             else;
                 eval $cell_count $cell_count + 1;
             done;

             put "<td";
             putq " id="    HTMLID;
             putq " headers=" headers / if $header_data_associations;
             putq " title=" flyover;
             trigger classalign;
             trigger style_inline;

            /*---------------------------------------------------------------eric-*/
            /*-- No spanning if we are saving the row.                          --*/
            /*------------------------------------------------------------17Nov03-*/
             trigger rowcol /if ^$cell_count;

             put " nowrap" /if no_wrap;
             put ">";
             trigger cell_value;
          finish:
             trigger header /breakif cmp(htmlclass, "RowHeader");
             trigger header /breakif cmp(htmlclass, "Header");

             trigger cell_value;
             put "</td>" CR;
        end;

        define event row;
            put "<tr>" CR;
        finish:
                /*---------------------------------------------------eric-*/
                /*-- End of row that had spans. put a spanning cell out.--*/
                /*------------------------------------------------17Nov03-*/
            do /if $cell_count;
                close;
                putq '<td colspan=' $cell_count '></td>' nl /if $cell_count;
                eval $cell_count 0;

                /*-----------------------------------------------------------eric-*/
                /*-- End of second row, only thing there is the                 --*/
                /*-- rowheaders. print the data cell that were saved            --*/
                /*-- from the row above.                                        --*/
                /*--------------------------------------------------------17Nov03-*/
            else /if $$row;
                put $$row;
                unset $$row;
            done;

            put "</tr>" CR;
        end;


        define event ms_graph_width;
           style=Graph;
           pure_style;
           set $local_width COLWIDTH / if !cmp( COLWIDTH , "0" );
           set $local_width OUTPUTWIDTH / if !exists(COLWIDTH);
           set $local_width "640" / if !exists($local_width);
           eval $extpos index($local_width,"px");
           put $local_width / breakif $extpos = 0;
           eval $extpos $extpos-1;
           set $local_width substr($local_width, 1, $extpos);
           put $local_width;
           unset $local_width;
           unset $extpos / if exists($extpos);
        end;

        define event ms_graph_height;
           style=Graph;
           pure_style;
           set $local_height DEPTH / if !cmp( DEPTH , "0" );
           set $local_height OUTPUTHEIGHT / if !exists(DEPTH);
           set $local_height "480" / if !exists($local_height);
           eval $extpos index($local_height,"px");
           do / if $extpos = 0;
              eval $heightnum inputn($local_height, "4.");
              put $local_height;
              unset $local_height;
              unset $extpos / if exists($extpos);
              break;
           done;
           eval $extpos $extpos-1;
           set $local_height substr($local_height, 1, $extpos);
           put $local_height;
           eval $heightnum inputn($local_height, "4.");
           unset $local_height;
           unset $extpos / if exists($extpos);
        end;


        define event activex_graph;
            start:
                do / if ^_INEXCEL;
                   put "<table cellspacing=1 cellpadding=1 rules=NONE frame=VOID border=0 width=";
                   trigger ms_graph_width;
                   put ">" CR;
                   put '<tr class="c" height="';
                   trigger ms_graph_height;
                   put  '">' CR;
                   put '<td class="c" height="';
                   trigger ms_graph_height;
                   put  '">' CR;
                   put "<v:shape id='" ref_id "_v' type='#_x0000_t201' style='position:absolute;" CR;
                   put " margin-left:0;margin-top:0;";
                   put "width:";
                   trigger ms_graph_width;
                   put "px;height:";
                   trigger ms_graph_height;
                   put "px'>" CR;
                   put "</v:shape>" CR;
                   put "<object " CR;
                   putq " id=" ref_id CR;
                   put ' v:shapes="' ref_id '_v"' CR;
                else;
                   do / if cmp(_INEXCEL,"true");
                      put "<table cellspacing=1 cellpadding=1 rules=NONE frame=VOID border=0 width=";
                      trigger ms_graph_width;
                      put ">" CR;
                      put '<tr class="c">' CR;
                      put '<td class="c">' CR;
                      put "<v:shape id='" ref_id "_v' type='#_x0000_t201' style='position:absolute;" CR;
                      put " margin-left:0;margin-top:0;";
                      put "width:";
                      trigger ms_graph_width;
                      put "px;height:";
                      trigger ms_graph_height;
                      put "px'>" CR;
                      put "</v:shape>" CR;
                      put "<object " CR;
                      putq " id=" ref_id CR;
                      put '  v:shapes="' ref_id '_v"' CR;
                   else;
                      put "<object " CR;
                      putq " id=" ref_id CR;
                   done;
                done;
            finish:
                put "</object> " CR;

                do / if ^_INEXCEL;
                   put "</td>" CR;
                   put "</tr>" CR;
                   put "</table>" CR;
                else;
                   do / if cmp(_INEXCEL,"true");
                      put "</td>" CR;
                      put "</tr>" CR;
                      do / if _EXCELROWHEIGHT;
                         eval $rowheight inputn(_EXCELROWHEIGHT,"3.");
                      else;
                         eval $rowheight 17;
                      done;
                      eval $ratio $heightnum*(1/$rowheight);
                      eval $span floor($ratio);
                      put '<tr style="mso-xlrowspan:';
                      put $span;
                      put '"></tr>' CR;
                      put "</table>" CR;
                      unset $ratio;
                      unset $span;
                      unset $rowheight;
                   done;
                done;
        end;

        define event image;
            trigger embed_svg /breakif cmp(validated_device, 'SVG');
            trigger embed_svg /breakif cmp(validated_device, 'SVGZ');

/*
            put '<div';
            trigger alt_align;
            put '>' nl;
*/
            put "<img";
            putq ' alt=' alt;
            put ' src="';
            put BASENAME / if !exists(NOBASE);
            put URL;
            put '"';
            put ' height="';
            trigger ms_graph_height;
            put '"';
            put ' width="';
            trigger ms_graph_width;
            put '"';
            put ' border="0"';
            put ' usemap="#' @CLIENTMAP;
            put ' usemap="#' NAME / if !exists(@CLIENTMAP);
            put '"' / if any(@CLIENTMAP , NAME);
            putq " id="    HTMLID;
            putq " id=" ref_id / if !exists(HTMLID);
            trigger classalign;
            put ">" CR;
/*
            put "</div>" CR;
*/
        end;

        define event html3_center;
            start:
               put "<CENTER>" CR;
            finish:
               put "</CENTER>" CR;
        end;

        define event java2_graph;
            start:
                pure_style;
                trigger ie_check / if !exists($ieCheckDone);
                trigger javascript start;
                put  '   document.writeln("<OBJECT");' CR;
                trigger graph_java_width;
                trigger graph_java_height;
                put  '   document.writeln("ALIGN=\"baseline\"");' CR;
                put  'if (_ie == true) {' CR;
                put  '   document.writeln("CLASSID=\"clsid:8AD9C840-044E-11D1-B3E9-00805F499D931\"");' CR;
                put  '   document.writeln("CODEBASE=\"http://java.sun.com/update/1.5.0/jinstall-1_5_0_12-windows-i586.cab#Version=1,5,0,0\"");' CR;
                put  '}' CR;
                put  'else {' CR;
                put  '   document.writeln("TYPE=\"application/x-java-applet;version=1.5\"");' CR;
                put  '   document.writeln("CODEBASE=\"http://java.sun.com/javase/downloads/index_jdk5.jsp\"");' CR;
                put  '}' CR;

            finish:
                put  '</OBJECT>' CR;
            end;

        define event java2_parameters;
                put  '<PARAM NAME="TYPE" VALUE="application/x-java-applet;version=1.5">' CR;
                put  '<PARAM NAME="SCRIPTABLE" VALUE="true">' CR;
        end;

        define event activex_unsupported;
            put "Sorry, there was a problem with the Graph control or plugin in your browser." CR;
            putq 'The graph ' code ' cannot be displayed.' CR;
        end;

        define event graph_java_width;
           style=Graph;
           pure_style;
           put '   document.writeln("WIDTH=' COLWIDTH '");' CR / breakif !cmp( COLWIDTH , "0" );
           put '   document.writeln("WIDTH=' OUTPUTWIDTH '");' CR / if exists(OUTPUTWIDTH);
           put '   document.writeln("WIDTH=640");' CR / if !exists(OUTPUTWIDTH);
        end;

        define event graph_java_height;
           style=Graph;
           pure_style;
           put '   document.writeln("HEIGHT=' DEPTH '");' CR / breakif !cmp( DEPTH , "0" );
           put '   document.writeln("HEIGHT=' OUTPUTHEIGHT '");' CR / if exists(OUTPUTHEIGHT);
           put '   document.writeln("HEIGHT=480");' CR / if !exists(OUTPUTHEIGHT);
        end;

        define event graph_java2_attribute;
           put '   document.writeln("';
           put NAME '=\"' VALUE '\"';
           put '");' CR;
        end;

        define event graph_java2_fxd_attributes;
           put '   document.writeln(">");' CR;
           trigger javascript finish;
        end;


        define event align;
        end;

        define event classalign;
            break / if ! htmlclass;
            put ' class="' htmlclass '"';
        end;

    end;

    /******************************************************/
    /******************************************************/
    /******************************************************/
    /*  Clean HTML with ODS defined CSS                   */
    /******************************************************/
    /******************************************************/
    /******************************************************/

    define tagset tagsets.htmlcss;
        notes "This is HTML with full CSS support";
        parent=tagsets.phtml;
        embedded_stylesheet=yes;


        define event put_value;
            put VALUE;
        end;

        define event shortstyles;
        end;

        define event style_class;
            trigger style_class2;
        end;

        define event spanhead1;
          start:
             put "<td";
            trigger classalign;
            putq " rowspan=" ROWSPAN /if !cmp(ROWSPAN, '1');
            putq " colspan=" COLSPAN /if !cmp(COLSPAN, '1');
            trigger style_inline;
            put ">";
            trigger pre_post start;
            do / if exists(URL);
                trigger hyperlink_value;
            else;
                trigger preformatted start /if asis;
                put VALUE;
                trigger preformatted finish /if asis;
            done;
            put '&nbsp;' /if !exists(strip(value));
          finish:
            trigger pre_post finish;
            put "</td>" nl;
        end;

        define event head1;
          start:
            put "<td>";
            trigger pre_post start;
            put "<div";
            trigger classalign;
            trigger style_inline;
            put ">";
            trigger hyperlink_value;
            put VALUE / if !exists(URL);
            put '&nbsp;' /if !exists(strip(value));
          finish:
            trigger hyperlink;
            put "</div>";
            trigger pre_post finish;
            put "</td>" nl;
        end;

        define event head2;
            trigger pre_post start;
            put "<div";
            trigger classalign;
            trigger style_inline;
            put ">";
            trigger hyperlink_value;
            put VALUE / if !exists(URL);
            put '&nbsp;' /if !exists(strip(value));
            put "</div>" CR;
            trigger pre_post finish;
        end;

        define event head3;
            trigger pre_post start;
            put "<div";
            trigger classalign;
            trigger style_inline;
            put ">";
            trigger hyperlink_value;
            put VALUE / if !exists(URL);
            put '&nbsp;' /if !exists(strip(value));
            put "</div>" CR;
            trigger pre_post finish;
        end;

        define event title_container;
          start:
             put "<table";
             putq " class=" HTMLCLASS;
             trigger style_inline;
             put  ' width="100%"';
             trigger do_borders;
             put  ' summary="Page Layout">' nl;
          finish:
            put "</table><br";
            put $empty_tag_suffix;
            put ">" nl;
        end;

        define event title_container_row;
          start:
            put '<tr>' nl;
          finish:
            put "</tr>"  nl;
        end;

       /*-----------------------------------------*/
       /* Web Accessibility Feature 1194.22 (I)   */
       /*-----------------------------------------*/
       define event doc_body;
           put '<body';
           do /if $scroll_tables;
               put ' onload="setupLongTables()"';
           else;
               put ' onload="startup()"';
           done;
           put ' onunload="shutdown()"';
           put  ' bgproperties="fixed"' / WATERMARK;
           putq " class=" HTMLCLASS;
           putq " background=" BACKGROUNDIMAGE;
           trigger style_inline;
           put ">" CR;
           trigger pre_post;
           put          CR;
           trigger ie_check;
         finish:
           trigger pre_post;
           trigger contents_body_list;
           put "</body>" CR;
        end;

         /* Web Accessibility Feature 1194.2 (H) */
         /*--------------------------------------*/
         define event table;
             start:
                 put "<div";
                 trigger alt_align;
                 put ">" CR;
                 trigger table_caption;
                 trigger pre_post;
                 put "<table";
                 putq " class=" HTMLCLASS;
                 putq " id="    HTMLID;
                 trigger style_inline;
                 trigger do_borders;
                 trigger table_summary;       /* 508 */
                 put ">" CR;
             finish:
                 put "</table>" CR;
                 trigger pre_post;
                 put "</div>" CR;
         end;

         define event verbatim_container;
             start:
                 put "<div";
                 trigger alt_align;
                 put ">" CR;
                 trigger pre_post;
                 put "<table";
                 do /if ^$css_table;
                     putq ' cellspacing="0"';
                     putq ' cellpadding="0"';
                 done;
                 put ' summary="Page Layout"';
                 put '>' CR;
                 put '<tr><td>' CR;
             finish:
                 put '</td></tr>' CR;
                 put '</table>' CR;
                 trigger pre_post;
                 put '</div>' CR;
         end;

         define event verbatim;
             start:
                 trigger preformatted;
             finish:
                 trigger preformatted;
         end;

         define event cell_value;
           start:
             trigger preformatted /if asis;
             trigger pre_post;
             trigger hyperlink;
             trigger do_value / if !exists(URL);
           finish:
             trigger hyperlink;
             trigger pre_post;
             trigger preformatted /if asis;
         end;

         define event header;
            start:
                put "<th";
                putq " id="    HTMLID;
                putq " headers=" headers / if $header_data_associations;
                putq " title=" flyover;
                trigger classalign;
                trigger style_inline;
                trigger rowcol;
                put ">";
                trigger cell_value;
            finish:
                trigger cell_value;
                put "</th>" CR;
         end;

      /* Web Accessibility Feature 1194.22 (G&H) */
      /*-----------------------------------------*/
       define event data;
          start:
             /* this would work but sometimes htmlclass is empty... */
             trigger header /breakif cmp(htmlclass, "RowHeader");
             trigger header /breakif cmp(htmlclass, "Header");

             put "<td";
             putq " id="    HTMLID;
             putq " headers=" headers / if $header_data_associations;
             putq " title=" flyover;
             trigger classalign;
             trigger style_inline;
             trigger rowcol;
             put " nowrap" /if no_wrap;
             put ">";
             trigger cell_value;
          finish:
             trigger header /breakif cmp(htmlclass, "RowHeader");
             trigger header /breakif cmp(htmlclass, "Header");

             trigger cell_value;
             put "</td>" CR;
      end;

        define event stacked_cell;
            start:
                put "<td";
                putq " title=" flyover;
                put ' class="stacked_cell ' htmlclass '"';
                trigger style_inline;
                trigger rowcol;
                put ">";
                put '<table width="100%" border="0"';
                do /if ^$css_table;
                    putq ' cellpadding=' $parent_table_padding;
                    putq ' cellspacing="0"';
                done;
                put '>' nl;
            finish:
                put '</table></td>' nl;
        end;

        define event stacked_value;
            start:
                put "<tr>" nl;
                put "<td";
                putq " title=" flyover;
                trigger real_align start;
                put ' ' htmlclass;
                do /if cmp(first_stacked_value, '1');
                    put ' top_stacked_value';
                else /if cmp(last_stacked_value, '1');
                    put ' bottom_stacked_value';
                else /if last_stacked_value;
                    put ' middle_stacked_value';
                done;
                trigger real_align finish;
                trigger style_inline;
                trigger rowcol;
                put " nowrap" /if no_wrap;
                put ">";
                trigger cell_value;
            finish:
                trigger cell_value;
                put "</td>" CR;
                put "</tr>" nl;
        end;

        define event stacked_value_header;
            start:
                put "<tr>" nl;
                put "<th";
                putq " title=" flyover;
                trigger real_align start;
                put ' ' htmlclass;
                do /if cmp(first_stacked_value, '1');
                    put ' top_stacked_value';
                else /if cmp(last_stacked_value, '1');
                    put ' bottom_stacked_value';
                else;
                    put ' middle_stacked_value';
                done;
                trigger real_align finish;
                trigger style_inline;
                trigger rowcol;
                put ">";
                trigger cell_value;
            finish:
                trigger cell_value;
                put "</th>" CR;
                put "</tr>" nl;
        end;

        define event preformatted;
            start:
                put '<pre';
                putq ' class=' htmlclass;
                trigger style_inline;
                put '>';
            finish:
                put "</pre>";
        end;

        define event list;
            start:
                put "<";
                trigger list_tag;
                putq " class=" HTMLCLASS;
                put ">" CR;
            finish:
                put "</";
                trigger list_tag;
                put ">" CR;
        end;

         /*-------------------------------------------------------eric-*/
         /*-- If it's a procedure and it's not the first one then    --*/
         /*-- put in spacing so there will be space between procs.   --*/
         /*----------------------------------------------------21May02-*/
        define event list_entry;
           start:
               put "<li";
               putq " class=" HTMLCLASS;
               /*put ' style="type: none"' /if any(prehtml, preimage); */
               put ">" nl;
               trigger do_link /if listentryanchor;
               trigger do_list_value/if !listentryanchor;
           finish:
               put "<br></li>" nl;
        end;


        define event do_link;
            trigger do_list_value_pre_post;
            trigger hyperlink_value / if any(URL, ANCHOR);
            put VALUE / if !any(URL, ANCHOR);
            trigger do_list_value_pre_post finish;
        end;

        define event do_list_value;
            trigger do_list_value_pre_post;
            put value;
            trigger do_list_value_pre_post finish;
        end;

        /*-------------------------------------------------------eric-*/
        /*-- All of this Logic mess is so that 'ods proclabel'      --*/
        /*-- doesn't get the 'The' and the 'Procedure' placed       --*/
        /*-- around it.  Those are pre and post text on the style.  --*/
        /*-- A better solution would be to have a different style   --*/
        /*-- for proclabels.                                        --*/
        /*----------------------------------------------------21May02-*/
        define event do_list_value_pre_post;
            start:
                unset $match;
                set $match "true" /if cmp(value, label);
                break /if exists($proc_name, $match);
                trigger pre_post /if !cmp('datastep', value);
            finish:
                unset $match;
                set $match "true" /if cmp(value, label);
                break /if exists($proc_name, $match);
                trigger pre_post finish /if !cmp('datastep', value);
                put nl /if cmp('datastep', value);
        end;


        define event hyperlinkvalue;
            trigger hyperlink start;
            trigger hyperlink finish;
        end;

        define event hyperlink;
            start:
                break /if ^URL;
                set $close_hyperlink "TRUE";
                put '<a href="' URL;
                /*put "#" ANCHOR;*/
                put '"';
                do /if cmp(dest_file, 'contents');
                  putq " target=" HREFTARGET / if frame_name;
                else;
                  putq " target=" HREFTARGET /if ^$no_target;
                done;
                put ">";
                trigger do_value;
            finish:
                break /if ^$close_hyperlink;
                put "</a>" CR;
                unset $close_hyperlink;
        end;

        define event do_value;
            trigger do_header_dots;
            put VALUE;
        end;

        define event contents_branch;
            file=CONTENTS;
            start:
                putlog "CONTENTS BRANCH" ": " $contents_list;
                trigger contents_list_branch /breakif $contents_list;
                trigger list_entry start;
                trigger list;
            finish:
                trigger contents_list_branch /breakif $contents_list;
                trigger list finish;
                trigger list_entry finish;
        end;

        define event contents_leaf;
            file=CONTENTS;
            putlog "CONTENTS LEAF" ": " $contents_list;
            trigger contents_list_leaf /breakif $contents_list;
            trigger list_entry start;
            trigger list_entry finish;
        end;

        define event page_anchor;
            file=PAGES;
            start:
                put "<li";
                putq " class=" HTMLCLASS;
                put ">" nl;
                put '<a href="' ;
                put body_name /if !exists(body_url);
                put body_url;
                put "#" ANCHOR;
                put '"';
                putq ' target="body" ';
                put ">";
                trigger pre_post;
                put 'Page ' total_page_count;
                trigger pre_post finish;
                put "</a>" CR;
            finish:
                put "</li>" nl;
        end;

        define event caption;
            put "<td";
            putq " id=" htmlid;
            putq " title=" flyover;
            trigger classalign;
            trigger style_inline;
            put ">";
            put TEXT;
        finish:
            put "</td>" CR;
            put "</tr><tr><td>" / if cmp(TYPE, "T");
            put "<td>" / if cmp(TYPE, "L");
        end;
        /*==========ODA==========*/

        define event byline;
            trigger head2;
            put '<p/>';
        end;

        define event proc_title;
            trigger head2;
        end;

        define event system_title;
          start:
            trigger spanhead1;
          finish:
            trigger spanhead1;
        end;

        define event system_footer;
          start:
            trigger spanhead1;
          finish:
            trigger spanhead1;
        end;

        define event Gnote;
            start:
                put "<div";
                trigger alt_align;
                put ">";
                put "<table";
                putq " class=" HTMLCLASS;
                put ">";
                put "<tr>" CR;
            finish:
                put "</tr>" CR;
                put "</table>" CR;
                put "</div>";
        end;

        define event GBanner;
            put "<td";
            trigger classalign;
            trigger style_inline;
            put ">" CR;
            trigger pre_post;
            put "</td>" CR;
        end;


        /*-------------------------------------------------------eric-*/
        /*-- This may seem strange to force the note content to     --*/
        /*-- left.  But that's exactly what has been happening all  --*/
        /*-- these years in the ods html code...                    --*/
        /*----------------------------------------------------21May02-*/
        define event GNContent;
            put "<td";
            put ' class="l';
            put ' ' HTMLCLASS;
            put '"';
            trigger style_inline;
            put ">";
            trigger pre_post start;
            put VALUE;
            trigger pre_post finish;
            put "</td>";
        end;

        define event noteBanner;
            style=NoteBanner;
            trigger GBanner;
        end;

        define event NoteContent;
            style=NoteContent;
            trigger GNContent;
        end;

        define event note;
            trigger Gnote start;
            trigger noteBanner;
            trigger noteContent;
            trigger Gnote finish;
        end;

        define event WarnBanner;
            style=WarnBanner;
            trigger GBanner;
        end;

        define event WarnContent;
            style=WarnContent;
            trigger GNContent;
        end;

        define event Warning;
            trigger Gnote start;
            trigger WarnBanner;
            trigger WarnContent;
            trigger Gnote finish;
        end;

        define event ErrorBanner;
        style=ErrorBanner;
            trigger GBanner;
        end;

        define event ErrorContent;
        style=ErrorContent;
           trigger GNContent;
        end;

        define event Error;
            trigger Gnote start;
            trigger ErrorBanner;
            trigger ErrorContent;
            trigger Gnote finish;
        end;

        define event FatalBanner;
            style=FatalBanner;
            trigger GBanner;
        end;

        define event FatalContent;
            style=FatalContent;
            trigger GNContent;
        end;

        define event Fatal;
            trigger Gnote start;
            trigger FatalBanner;
            trigger FatalContent;
            trigger Gnote finish;
        end;


    end;

    /*******************************************************************/
    /*******************************************************************/
    /*******************************************************************/
    /* mvshtml.    HTML fixed up to create correct urls on MVS         */
    /* Support:    Eric Gebhart (saseag)                               */
    /*******************************************************************/
    /*******************************************************************/
    /*******************************************************************/



    define tagset tagsets.mvshtml;
     parent=tagsets.html4;
        notes "This tagset is no longer needed. Generating valid URLs, and filenames have been fixed in production code. ";
    end;

   define tagset tagsets.cascading_stylesheet;

        /* for graph */
        parent = tagsets.SASfmt;

        define event init_css_regex;
            do / if ^exists($add_unit_re);
                eval $add_unit_re prxparse('s/(\.|\d)$/\1px/');
            done;
            do / if ^exists($to_int_re);
                eval $to_int_re prxparse('s/^.*?(\d+).*$/\1/');
                /*eval $to_int_re prxparse('s/^[^\d]*(\d+)(\.\d+)?[\w%]*$/\1/');*/
            done;
        end;

        define event stylesheet_link;
            break /if !exists(url);
            /* the default */
            set $urlList url;
            eval $colon index(stylesheet_url, ":");
            do /if 0 < $colon < 7;
                set $firstword scan(stylesheet_url, 1, ':');
                do /if cmp ($firstword, 'http') ;
                    set $urlList stylesheet_url;
                else /if cmp ($firstword, 'https') ;
                    set $urlList stylesheet_url;
                else /if cmp ($firstword, 'file') ;
                    set $urlList stylesheet_url;
                done;
            done;

            trigger urlLoop ;
            unset $urlList;
            put '<style type="text/css">' CR '<!--' CR;
            trigger alignstyle;
            put '-->' CR '</style>' CR ;
        end;

        define event contents_stylesheet_link;
            set $urlList url;
            trigger urlLoop / if exists(url);
            unset $urlList;
        end;

        define event link;
            putq '<link rel="stylesheet" type="text/css" href=' $current_url;
            put $empty_tag_suffix;
            put '>' nl;
        end;

        define event urlLoop;
            eval $index 1;
            set $current_url scan($urlList, $index, ' ');

            do /while !cmp($current_url, ' ');
                set $current_url trim($current_url);
                trigger link;
                eval $index $index + 1;
                set $current_url scan($urlList, $index, ' ');
            done;
        end;

/*
        define event urlLoop;
            eval $space_pos index($urlList, " ");

            do /while $space_pos ne 0;

                do /if $space_pos ne 0;
                    set $current_url substr($urlList,1,$space_pos);
                    set $current_url trim($current_url);
                done;

                trigger link;

                set $urlList substr($urlList,$space_pos);
                set $urlList strip($urlList);

                eval $space_pos index($urlList, " ");
            done;
*/
            /* when space_pos is 0 it's either the only link or the last link */
/*
            set $current_url $urlList;
            trigger link;
        end;
        */
        /*-------------------------------------------------------eric-*/
        /*-- for htmlcss and above, html4, xhtml, etc.              --*/
        /*----------------------------------------------------27Jul06-*/
        define event style_class2;
            set $htmlclass lowcase(htmlclass);
            trigger header_dots /if contains($htmlclass, 'eader');
            put "." HTMLCLASS CR;
            put "{" CR;
            trigger stylesheetclass;
            put "}" CR;
            trigger link_classes /if cmp(htmlclass, "document");
            trigger stacked_column_styles /if cmp(htmlclass, "table");
        end;

        define event header_dots;
            break /if ^$header_dots;
            put "." HTMLCLASS "_dots" nl;
            put "{" nl;
            put "color: " background ";" nl;
            put "font-size: 2pt;" nl;
            put "}" nl;
        end;

        define event stacked_column_styles;
            put ".top_stacked_value" CR;
            put "{" CR;
            put "  padding-bottom: 1px;" nl;
            put "}" CR;
            put ".middle_stacked_value" CR;
            put "{" CR;
            put "  padding-top: 1px;" nl;
            put "  padding-bottom: 1px;" nl;
            put "}" CR;
            put ".bottom_stacked_value" CR;
            put "{" CR;
            put "  padding-top: 1px;" nl;
            put "}" CR;
        end;

        define event link_classes;
            trigger linkclass /if exists(linkcolor);
            trigger vlinkclass /if exists(visitedlinkcolor);
            trigger alinkclass /if exists(activelinkcolor);
        end;

        define event style_class;
            put "." HTMLCLASS CR;
            put "{" CR;
            trigger stylesheetclass;
            put "}" CR;
        end;

        define event stylesheetclass;
            set $stylesheet 'true';
            trigger cssfont;
            trigger cssbackground;
            trigger cssmargins;
            trigger cssborder;
            trigger cssbullets;
            trigger cssdimensions;
            trigger csstextalign;
            trigger put_styles;
            unset $stylesheet;
        end;

        define event cache_css_borders;
            /* This event is here to store away border attributes, but
               not print them.  This is used to prevent jobs that use
               URL= from picking up too many border defaults. */
            set $stylesheet 'true';
            trigger cssmargins;
            trigger cssborder;
            unset $stylesheet;
        end;

        define event store_table_borders;
            style=Table; trigger cache_css_borders; unset $styles;
        end;

        define event store_title_container_borders;
            style=SysTitleAndFooterContainer; trigger cache_css_borders; unset $styles;
        end;

        define event store_note_container_borders;
            style=SysTitleAndFooterContainer; trigger cache_css_borders; unset $styles;
        end;

        define event store_byline_container_borders;
            style=SysTitleAndFooterContainer; trigger cache_css_borders; unset $styles;
        end;

        define event store_byline_borders;
            style=ByLine; trigger cache_css_borders; unset $styles;
        end;

        define event store_note_borders;
            style=Note; trigger cache_css_borders; unset $styles;
        end;

        define event store_batch_borders;
            style=Batch; trigger cache_css_borders; unset $styles;
        end;

        define event store_graph_borders;
            style=Graph; trigger cache_css_borders; unset $styles;
        end;

        define event store_all_borders;
            trigger store_table_borders;
            trigger store_batch_borders;
            trigger store_graph_borders;
            trigger store_byline_borders;
            trigger store_byline_container_borders;
            trigger store_note_borders;
            trigger store_title_container_borders;
            trigger store_note_container_borders;
        end;

        define event cssfont;
            trigger graph_title_font_size;
            break / if ^any(fontfamily, fontsize, $fontsize, fontweight,
                            fontstyle, foreground, textdecoration, whitespace);
            do / if fontfamily;
                /* quote font names with spaces */
                set $qfontfamily prxchange("s/([^,\s]+(?:\s+[^,\s]+)+)(\s*,|\s*$)/'\1'\2/", -1, fontfamily);
                set $qfontfamily strip($qfontfamily);
                set $qfontfamily tranwrd($qfontfamily, "'""", '"');
                set $qfontfamily tranwrd($qfontfamily, """'", '"');
                set $qfontfamily tranwrd($qfontfamily, "''", "'");
                set $styles["font-family"] $qfontfamily;
            done;
            do / if $fontsize;
                set $styles["font-size"] $fontsize;
                unset $fontsize;
            done;
            set $styles['font-weight'] fontweight / exists(fontweight);
            set $styles['font-style'] fontstyle / exists(fontstyle);
            set $styles['color'] foreground / exists(foreground);
            set $styles['text-decoration'] textdecoration / exists(textdecoration);
            set $styles['white-space'] whitespace / exists(whitespace);
        end;

        define event cssbackground;
            break / if ^any(background, backgroundrepeat, backgroundposition,
                            backgroundimage);
            set $styles['background-color'] background / exists(background);
            set $styles['background-repeat'] backgroundrepeat / exists(backgroundrepeat);
            set $styles['background-position'] backgroundposition / exists(backgroundposition);
            set $styles['background-image'] "url('" backgroundimage "')" / exists(backgroundimage);
        end;

        define event cssbullets;
            break / if ^any(liststyletype, liststyleimage);
            set $styles['list-style-type'] liststyletype / exists(liststyletype);
            set $styles['list-style-image'] "url('" liststyleimage "')" / exists(liststyleimage);
       end;

       define event cssdimensions;
            break / if ^any(outputheight, outputwidth, $outputheight, $outputwidth);
            trigger init_css_regex;
            set $styles['height'] prxchange($add_unit_re, -1, outputheight) / if outputheight;
            set $styles['height'] prxchange($add_unit_re, -1, $outputheight) / if $outputheight;
            set $styles['width'] prxchange($add_unit_re, -1, outputwidth) / if outputwidth;
            set $styles['width'] prxchange($add_unit_re, -1, $outputwidth) / if $outputwidth;
            unset $outputheight;
            unset $outputwidth;
        end;

        define event csstextalign;
            break / if ^any(just, vjust);
            set $styles['text-align'] $just_lookup[just] / exists(just);
            set $styles['vertical-align'] $vjust_lookup[vjust] / exists(vjust);
        end;

        define event cssmargins;
            break / if ^any(indent, margin, margintop, marginbottom,
                            marginleft, marginright, padding, paddingtop,
                            paddingbottom, paddingleft, paddingright);
            trigger init_css_regex;
            set $styles['text-indent'] prxchange($add_unit_re, -1, indent)
                / exists(indent);
            set $styles['margin'] prxchange($add_unit_re, -1, margin)
                / exists(margin);
            set $styles['margin-left'] prxchange($add_unit_re, -1, marginleft)
                / exists(marginleft);
            set $styles['margin-right'] prxchange($add_unit_re, -1, marginright)
                / exists(marginright);
            set $styles['margin-top'] prxchange($add_unit_re, -1, margintop)
                / exists(margintop);
            set $styles['margin-bottom'] prxchange($add_unit_re, -1, marginbottom)
                / exists(marginbottom);

            break /if cmp(htmlclass, 'Table');

            do / if exists(padding);
                eval $padding trimn(prxchange($add_unit_re, -1, padding));
                do / if exists($stylesheet);
                    set $styles['padding'] $padding;
                    set $paddings[htmlclass] $padding;
                else / if ^cmp($paddings[htmlclass], $padding);
                    set $styles['padding'] $padding;
                done;
            done;

            set $styles['padding-left'] prxchange($add_unit_re, -1, paddingleft)
                / exists(paddingleft);
            set $styles['padding-right'] prxchange($add_unit_re, -1, paddingright)
                / exists(paddingright);
            set $styles['padding-top'] prxchange($add_unit_re, -1, paddingtop)
                / exists(paddingtop);
            set $styles['padding-bottom'] prxchange($add_unit_re, -1, paddingbottom)
                / exists(paddingbottom);
        end;

        define event cssborder;
            break / if ^any(bordercolor, borderspacing, bordercollapse,
                            borderstyle, borderwidth, bordertopcolor,
                            bordertopstyle, bordertopwidth, borderbottomcolor,
                            borderbottomstyle, borderbottomwidth,
                            borderleftcolor, borderleftstyle, borderleftwidth,
                            borderrightcolor, borderrightwidth,
                            borderrightstyle, frame);

            trigger init_css_regex;

            do / if exists(bordercollapse);
                set $bordercollapses[htmlclass] bordercollapse;
                set $styles['border-collapse'] bordercollapse;
            done;

            do / if exists(borderspacing);
                set $borderspacings[htmlclass]
                        prxchange($add_unit_re, -1, borderspacing);
                set $styles['border-spacing']
                        prxchange($add_unit_re, -1, borderspacing);
            done;

            break / if ^any(bordercolor,
                            borderstyle, borderwidth, bordertopcolor,
                            bordertopstyle, bordertopwidth, borderbottomcolor,
                            borderbottomstyle, borderbottomwidth,
                            borderleftcolor, borderleftstyle, borderleftwidth,
                            borderrightcolor, borderrightwidth,
                            borderrightstyle, frame);

            set $bordersset[htmlclass] 'true';

            /* set defaults */
            set $styles['border-width'] '1px';
            do / if exists(borderwidth);
                set $styles['border-width'] prxchange($add_unit_re, -1, borderwidth);
                set $borderwidths[htmlclass] $styles['border-width'];
            done;
            set $styles['border-width'] '0px' / if cmp(frame, 'void');
            set $styles['border-top-width'] $styles['border-width'];
            set $styles['border-right-width'] $styles['border-width'];
            set $styles['border-bottom-width'] $styles['border-width'];
            set $styles['border-left-width'] $styles['border-width'];

            set $styles['border-color'] '#000000';
            set $bordercolors[htmlclass] bordercolor / if exists(bordercolor);
            set $styles['border-color'] bordercolor / if exists(bordercolor);
            set $styles['border-top-color'] $styles['border-color'];
            set $styles['border-top-color'] bordercolorlight / if exists(bordercolorlight);
            set $styles['border-right-color'] $styles['border-color'];
            set $styles['border-right-color'] bordercolordark / if exists(bordercolordark);
            set $styles['border-bottom-color'] $styles['border-color'];
            set $styles['border-bottom-color'] bordercolordark / if exists(bordercolordark);
            set $styles['border-left-color'] $styles['border-color'];
            set $styles['border-left-color'] bordercolorlight / if exists(bordercolorlight);

            set $styles['border-style'] 'solid';
            set $styles['border-style'] borderstyle / if exists(borderstyle);
            set $styles['border-top-style'] $styles['border-style'];
            set $styles['border-right-style'] $styles['border-style'];
            set $styles['border-bottom-style'] $styles['border-style'];
            set $styles['border-left-style'] $styles['border-style'];

            do / if frame;
                trigger apply_frame;
                set $frames[htmlclass] frame;
            done;

            /* top border overrides */
            set $styles['border-top-color'] bordertopcolor
                 / exists(bordertopcolor);
            set $styles['border-top-style'] bordertopstyle
                 / exists(bordertopstyle);
            set $styles['border-top-width'] prxchange($add_unit_re, -1, bordertopwidth)
                 / exists(bordertopwidth);

            /* right border overrides */
            set $styles['border-right-color'] borderrightcolor
                 / exists(borderrightcolor);
            set $styles['border-right-style'] borderrightstyle
                 / exists(borderrightstyle);
            set $styles['border-right-width'] prxchange($add_unit_re, -1, borderrightwidth)
                 / exists(borderrightwidth);

            /* bottom border overrides */
            set $styles['border-bottom-color'] borderbottomcolor
                 / exists(borderbottomcolor);
            set $styles['border-bottom-style'] borderbottomstyle
                 / exists(borderbottomstyle);
            set $styles['border-bottom-width'] prxchange($add_unit_re, -1, borderbottomwidth)
                 / exists(borderbottomwidth);

            /* left border overrides */
            set $styles['border-left-color'] borderleftcolor
                 / exists(borderleftcolor);
            set $styles['border-left-style'] borderleftstyle
                 / exists(borderleftstyle);
            set $styles['border-left-width'] prxchange($add_unit_re, -1, borderleftwidth)
                 / exists(borderleftwidth);

            unset $oneborderwidth;
            do / if exists($styles['border-top-width'], $styles['border-bottom-width']),
                           $styles['border-left-width'], $styles['border-right-width']);
                unset $styles['border-width'];
            do / if cmp($styles['border-top-width'], $styles['border-bottom-width']);
                do / if cmp($styles['border-left-width'], $styles['border-right-width']);
                    do / if cmp($styles['border-top-width'], $styles['border-left-width']);
                        set $oneborderwidth 'true';
                        set $styles['border-width'] $styles['border-top-width'];
                        unset $styles['border-top-width'];
                        unset $styles['border-bottom-width'];
                        unset $styles['border-right-width'];
                        unset $styles['border-left-width'];
            done; done; done; done;

            unset $onebordercolor;
            do / if exists($styles['border-top-color'], $styles['border-bottom-color']),
                           $styles['border-left-color'], $styles['border-right-color']);
                unset $styles['border-color'];
            do / if cmp($styles['border-top-color'], $styles['border-bottom-color']);
                do / if cmp($styles['border-left-color'], $styles['border-right-color']);
                    do / if cmp($styles['border-top-color'], $styles['border-left-color']);
                        set $onebordercolor 'true';
                        set $styles['border-color'] $styles['border-top-color'];
                        unset $styles['border-top-color'];
                        unset $styles['border-bottom-color'];
                        unset $styles['border-right-color'];
                        unset $styles['border-left-color'];
            done; done; done; done;

            unset $oneborderstyle;
            do / if exists($styles['border-top-style'], $styles['border-bottom-style']),
                           $styles['border-left-style'], $styles['border-right-style']);
                unset $styles['border-style'];
            do / if cmp($styles['border-top-style'], $styles['border-bottom-style']);
                do / if cmp($styles['border-left-style'], $styles['border-right-style']);
                    do / if cmp($styles['border-top-style'], $styles['border-left-style']);
                        set $oneborderstyle 'true';
                        set $styles['border-style'] $styles['border-top-style'];
                        unset $styles['border-top-style'];
                        unset $styles['border-bottom-style'];
                        unset $styles['border-right-style'];
                        unset $styles['border-left-style'];
            done; done; done; done;

            do / if exists($oneborderwidth, $onebordercolor, $oneborderstyle);
                set $styles['border'] $styles['border-width'] ' '
                                      $styles['border-style'] ' '
                                      $styles['border-color'];
                unset $styles['border-width'];
                unset $styles['border-style'];
                unset $styles['border-color'];
            done;
        end;

        define event apply_frame;
            do / if exists(frame);

                set $styles['border-width'] '1px' / if ^$styles['border-width'];

                /* apply frame= styles */
                do / if cmp(frame, 'box');
                    set $styles['border-top-width'] $styles['border-width'];
                    set $styles['border-right-width'] $styles['border-width'];
                    set $styles['border-bottom-width'] $styles['border-width'];
                    set $styles['border-left-width'] $styles['border-width'];
                done;

                do / if cmp(frame, 'void');
                    set $styles['border-top-width'] '0px';
                    set $styles['border-right-width'] '0px';
                    set $styles['border-bottom-width'] '0px';
                    set $styles['border-left-width'] '0px';
                done;

                do / if cmp(frame, 'above');
                    set $styles['border-top-width'] $styles['border-width'];
                    set $styles['border-right-width'] '0px';
                    set $styles['border-bottom-width'] '0px';
                    set $styles['border-left-width'] '0px';
                done;

                do / if cmp(frame, 'below');
                    set $styles['border-top-width'] '0px';
                    set $styles['border-right-width'] '0px';
                    set $styles['border-bottom-width'] $styles['border-width'];
                    set $styles['border-left-width'] '0px';
                done;

                do / if cmp(frame, 'lhs');
                    set $styles['border-top-width'] '0px';
                    set $styles['border-right-width'] '0px';
                    set $styles['border-bottom-width'] '0px';
                    set $styles['border-left-width'] $styles['border-width'];
                done;

                do / if cmp(frame, 'rhs');
                    set $styles['border-top-width'] '0px';
                    set $styles['border-right-width'] $styles['border-width'];
                    set $styles['border-bottom-width'] '0px';
                    set $styles['border-left-width'] '0px';
                done;

                do / if cmp(frame, 'hsides');
                    set $styles['border-top-width'] $styles['border-width'];
                    set $styles['border-right-width'] '0px';
                    set $styles['border-bottom-width'] $styles['border-width'];
                    set $styles['border-left-width'] '0px';
                done;

                do / if cmp(frame, 'vsides');
                    set $styles['border-top-width'] '0px';
                    set $styles['border-right-width'] $styles['border-width'];
                    set $styles['border-bottom-width'] '0px';
                    set $styles['border-left-width'] $styles['border-width'];
                done;

            done;
        end;

        define event cssborderoverride;
            break / if ^any(bordercolor, borderspacing, bordercollapse,
                            borderstyle, borderwidth, bordertopcolor,
                            bordertopstyle, bordertopwidth, borderbottomcolor,
                            borderbottomstyle, borderbottomwidth,
                            borderleftcolor, borderleftstyle, borderleftwidth,
                            borderrightcolor, borderrightwidth,
                            borderrightstyle, frame);

            /* do border overrides while using the style element
               border defaults set when writing the stylesheet */

            /* only print out border-spacing/border-collapse
               if it's different than what's in the class */

            trigger init_css_regex;

            do / if borderspacing;
                set $borderspacing prxchange($add_unit_re, -1, borderspacing);
                do / if ^cmp($borderspacings[htmlclass], $borderspacing);
                    set $styles['border-spacing'] prxchange($add_unit_re, -1, $borderspacing);
                done;
                unset $borderspacing;
            done;

            do / if bordercollapse;
                do / if ^cmp($bordercollapses[htmlclass], bordercollapse);
                    set $styles['border-collapse'] bordercollapse;
                done;
            done;

            break / if ^any(bordercolor,
                            borderstyle, borderwidth, bordertopcolor,
                            bordertopstyle, bordertopwidth, borderbottomcolor,
                            borderbottomstyle, borderbottomwidth,
                            borderleftcolor, borderleftstyle, borderleftwidth,
                            borderrightcolor, borderrightwidth,
                            borderrightstyle, frame);

            /* border widths */
            do / if ^borderwidth;
                do / if ^$bordersset[htmlclass];
                    set $styles['border-width'] '1px';
                    set $styles['border-top-width'] '1px';
                    set $styles['border-right-width'] '1px';
                    set $styles['border-bottom-width'] '1px';
                    set $styles['border-left-width'] '1px';
                done;
            else / if exists(borderwidth);
                set $styles['border-width'] prxchange($add_unit_re, -1, borderwidth);
                set $styles['border-top-width'] $styles['border-width'];
                set $styles['border-right-width'] $styles['border-width'];
                set $styles['border-bottom-width'] $styles['border-width'];
                set $styles['border-left-width'] $styles['border-width'];
            done;

            do / if ^cmp(frame, $frames[htmlclass]);
                trigger apply_frame;
            else / if exists(frame, borderwidth);
                trigger apply_frame;
            done;

            set $styles['border-top-width'] prxchange($add_unit_re, -1, bordertopwidth)
                 / if exists(bordertopwidth);
            set $styles['border-right-width'] prxchange($add_unit_re, -1, borderrightwidth)
                 / if exists(borderrightwidth);
            set $styles['border-bottom-width'] prxchange($add_unit_re, -1, borderbottomwidth)
                 / if exists(borderbottomwidth);
            set $styles['border-left-width'] prxchange($add_unit_re, -1, borderleftwidth)
                 / if exists(borderleftwidth);

            /* normalize border widths */
            unset $oneborderwidth;
            do / if exists($styles['border-top-width'], $styles['border-bottom-width']),
                           $styles['border-left-width'], $styles['border-right-width']);
                unset $styles['border-width'];
            do / if cmp($styles['border-top-width'], $styles['border-bottom-width']);
                do / if cmp($styles['border-left-width'], $styles['border-right-width']);
                    do / if cmp($styles['border-top-width'], $styles['border-left-width']);
                        set $oneborderwidth 'TRUE';
                        set $styles['border-width'] $styles['border-top-width'];
                        unset $styles['border-top-width'];
                        unset $styles['border-bottom-width'];
                        unset $styles['border-left-width'];
                        unset $styles['border-right-width'];
            done; done; done; done;

            /* border styles */
            do / if exists(borderstyle);
                set $styles['border-style'] borderstyle;
                set $styles['border-top-style'] borderstyle;
                set $styles['border-right-style'] borderstyle;
                set $styles['border-bottom-style'] borderstyle;
                set $styles['border-left-style'] borderstyle;
            done;
            set $styles['border-top-style'] bordertopstyle / if exists(bordertopstyle);
            set $styles['border-right-style'] borderrightstyle / if exists(borderrightstyle);
            set $styles['border-bottom-style'] borderbottomstyle / if exists(borderbottomstyle);
            set $styles['border-left-style'] borderleftstyle / if exists(borderleftstyle);

            /* normalize border styles */
            unset $oneborderstyle;
            do / if exists($styles['border-top-style'], $styles['border-bottom-style']),
                           $styles['border-left-style'], $styles['border-right-style']);
                unset $styles['border-style'];
            do / if cmp($styles['border-top-style'], $styles['border-bottom-style']);
                do / if cmp($styles['border-left-style'], $styles['border-right-style']);
                    do / if cmp($styles['border-top-style'], $styles['border-left-style']);
                        set $oneborderstyle 'TRUE';
                        set $styles['border-style'] $styles['border-top-style'];
                        unset $styles['border-top-style'];
                        unset $styles['border-bottom-style'];
                        unset $styles['border-left-style'];
                        unset $styles['border-right-style'];
            done; done; done; done;

            /* border colors */
            do / if exists(bordercolor);
                set $styles['border-color'] bordercolor;
                set $styles['border-top-color'] bordercolor;
                set $styles['border-right-color'] bordercolor;
                set $styles['border-bottom-color'] bordercolor;
                set $styles['border-left-color'] bordercolor;
            done;
            do / if exists(bordercolorlight);
                set $styles['border-top-color'] bordercolorlight;
                set $styles['border-left-color'] bordercolorlight;
            done;
            do / if exists(bordercolordark);
                set $styles['border-right-color'] bordercolordark;
                set $styles['border-bottom-color'] bordercolordark;
            done;
            set $styles['border-top-color'] bordertopcolor / if exists(bordertopcolor);
            set $styles['border-right-color'] borderrightcolor / if exists(borderrightcolor);
            set $styles['border-bottom-color'] borderbottomcolor / if exists(borderbottomcolor);
            set $styles['border-left-color'] borderleftcolor / if exists(borderleftcolor);

            /* normalize border colors */
            unset $onebordercolor;
            do / if exists($styles['border-top-color'], $styles['border-bottom-color']),
                           $styles['border-left-color'], $styles['border-right-color']);
                unset $styles['border-color'];
            do / if cmp($styles['border-top-color'], $styles['border-bottom-color']);
                do / if cmp($styles['border-left-color'], $styles['border-right-color']);
                    do / if cmp($styles['border-top-color'], $styles['border-left-color']);
                        set $onebordercolor 'TRUE';
                        set $styles['border-color'] $styles['border-top-color'];
                        unset $styles['border-top-color'];
                        unset $styles['border-bottom-color'];
                        unset $styles['border-left-color'];
                        unset $styles['border-right-color'];
            done; done; done; done;

            do / if ^exists($oneborderwidth, $onebordercolor, $oneborderstyle);
                /* make sure that all borders have a default style and color */
                do / if ^$bordersset[htmlclass];
                    do / if ^$styles['border-style'];
                        do / if ^$styles['border-color'];
                            do / if ^exists($styles['border-top-color'],
                                            $styles['border-bottom-color'],
                                            $styles['border-left-color'],
                                            $styles['border-right-color']);
                                set $styles['border-color'] '#000000';
                                set $onebordercolor 'true';
                            done;
                            do / if ^exists($styles['border-top-style'],
                                            $styles['border-right-style'],
                                            $styles['border-bottom-style'],
                                            $style['border-left-style']);
                                set $styles['border-style'] 'solid';
                                set $oneborderstyle 'true';
                            done;
                        else;
                            do / if ^exists($styles['border-top-style'],
                                            $styles['border-right-style'],
                                            $styles['border-bottom-style'],
                                            $style['border-left-style']);
                                set $styles['border-style'] 'solid';
                                set $oneborderstyle 'true';
                            done;
                        done;
                    else / if ^$styles['border-color'];
                        do / if ^exists($styles['border-top-color'],
                                        $styles['border-right-color'],
                                        $styles['border-bottom-color'],
                                        $style['border-left-color']);
                            set $styles['border-color'] '#000000';
                            set $onebordercolor 'true';
                        done;
                    done;
                done;
            done;

            do / if exists($oneborderwidth, $onebordercolor, $oneborderstyle);
                set $styles['border'] $styles['border-width'] ' '
                                      $styles['border-style'] ' '
                                      $styles['border-color'];
                unset $styles['border-width'];
                unset $styles['border-style'];
                unset $styles['border-color'];
            done;
        end;

        define event do_borders;
             do /if ^$css_table;

                 trigger init_css_regex;

                 unset $parent_table_spacing;
                 do / if exists(cellspacing);
                     eval $parent_table_spacing
                           trimn(prxchange($to_int_re, -1, cellspacing));
                 done;
                 putq " cellspacing=" prxchange($to_int_re, -1, cellspacing)
                       / exists(cellspacing);

                 unset $parent_table_padding;
                 do / if exists(cellpadding);
                     eval $parent_table_padding
                           trimn(prxchange($to_int_re, -1, cellpadding));
                 done;
                 putq " cellpadding=" prxchange($to_int_re, -1, cellpadding)
                       / exists(cellpadding);

                 putq " rules=" lowcase(rules) / exists(rules);
                 putq " frame=" lowcase(frame) / exists(frame);

                 do / if exists(borderwidth);
                     putq " border=" prxchange($to_int_re, -1, borderwidth);
                 else / if exists($borderwidths[htmlclass]);
                     putq ' border=' prxchange($to_int_re, -1, $borderwidths[htmlclass]);
                 done;

                 do / if exists(bordercolor);
                     putq " bordercolor=" bordercolor;
                 else / if exists($bordercolors[htmlclass]);
                     putq " bordercolor=" $bordercolors[htmlclass];
                 done;

                 /****
                 putq " bordercolordark=" bordercolordark
                       / exists(bordercolordark);
                 putq " bordercolorlight=" bordercolorlight
                       / exists(bordercolorlight);
                 ****/
             done;
         end;

        define event graph_title_font_size;
            break /if !fontsize;
            set $fontsize fontsize;
            break /if !cmp(tagset, 'tagsets.html4');
            break /if $percentage_font_size;
            do /if cmp(event_name, 'system_title') | cmp(event_name, 'system_footer');
                do /if index(fontsize, '%');
                    putlog "%3zPercentage font size will not be used in titles or footnotes, use the percentage_font_size option to disable this behavior.   Add options(doc='help') to the ods statement for more information.";
                    unset $fontsize;
                done;
            done;
        end;

        define event graph_style_inline;
            trigger cssbackground;
            trigger cssmargins;
            trigger cssborderoverride;
            trigger cssdimensions;
            trigger put_inline_styles;
        end;

        define event style_inline;
            trigger cssfont;
            trigger cssbackground;
            trigger cssmargins;
            trigger cssborderoverride;
            trigger cssbullets;
            trigger cssdimensions;
            trigger put_inline_styles;
        end;

        define event style_inline_w_just;
            trigger cssfont;
            trigger cssbackground;
            trigger cssmargins;
            trigger cssborderoverride;
            trigger cssbullets;
            trigger cssdimensions;
            trigger csstextalign;
            trigger put_inline_styles;
        end;

        define event embedded_stylesheet;
           start:
              put "<style type=""text/css"">" nl "<!--" nl;
           finish:
              trigger alignstyle;
              trigger contents_list_style;
              put "-->" nl "</style>" nl;
        end;

        define event style;
            put "<style type=""text/css"">" CR;
        finish:
            put "</style>" CR;
        end;

        define event shortstyles;
            trigger bodystyle;
            trigger titlestyle;
            trigger proctitlestyle;
            trigger tablestyle;
            trigger batchstyle;
            trigger tdstyle;
            trigger thstyle;
        end;

        define event alignstyle ;
            putl '.l {text-align: left }';
            putl '.c {text-align: center }';
            putl '.r {text-align: right }';
            putl '.d {text-align: right }';
            putl '.j {text-align: justify }';
            putl '.t {vertical-align: top }';
            putl '.m {vertical-align: middle }';
            putl '.b {vertical-align: bottom }';
            putl 'TD, TH {vertical-align: top }';
            putl '.stacked_cell{padding: 0 }';
        end;
        
        define event contents_list_style;
            putl "<!--";
            putl "div#contents {";
            putl "position: absolute;";
            putl "width: 175px;";
            putl "overflow: auto;";
            putl "height: 600px;";
            /* move the menu down a bit in the contents file */
            do /if cmp(dest_file, 'contents');
                putl "top: 25px;";
            else;
                putl "top: 0px;";
            done;
            putl "left: 0px;";
            putl "padding: 10px;";
            putl "}";
            putl "div#contents_tree {";
            putl "position: absolute;";
            putl "width: 175px;";
            putl "overflow: auto;";
            putl "height: 600px;";
            putl "top: 0px;";
            putl "left: 0px;";
            putl "padding: 10px;";
            putl "border-right: 1px solid #000000;";
            putl "}";
            putl "#contents {";
            putl "position: absolute;";
            putl "width: 175px;";
            putl "top: 10px;";
            putl "left: 10px;";
            putl "}";
            putl "body > #contents {";
            putl "    position: fixed;";
            putl "}";
            putl "body > #contents_tree {";
            putl "    position: fixed;";
            putl "}";
            putl ".body {";
            putl "    position: absolute;";
            putl "        top: 10px;";
            putl "        left: 10px;";
            putl "        margin-left: 200px;";
            putl "    }";
            putl "-->";
        end;

        define event bodystyle;
            style=body;
            put "body {" CR;
            trigger stylesheetclass;
            put "}" CR;
            trigger linkclass /if exists(linkcolor);
            trigger vlinkclass /if exists(visitedlinkcolor);
            trigger alinkclass /if exists(activelinkcolor);
        end;

        define event linkclass;
            put "a:link {" CR;
            put "color:" linkcolor CR;
            put "}" CR;
        end;

        define event vlinkclass;
            put "a:visited {" CR;
            put "color:" visitedlinkcolor CR;
            put "}" CR;
        end;

        define event alinkclass;
            put "a:active {" CR;
            put "color:" activelinkcolor CR;
            put "}" CR;
        end;

        define event titlestyle;
            style = systemtitle;
            put "h1 {" CR;
            trigger stylesheetclass;
            put "}" CR;
        end;

        define event proctitlestyle;
            style = proctitle;
            put "h2, h3, h4, h5, h6 {" CR;
            trigger stylesheetclass;
            put "}" CR;
        end;

        define event tablestyle;
            style = table;
            put "table {" CR;
            trigger stylesheetclass;
            put "}" CR;
        end;

        define event batchstyle;
            style = batch;
            put "pre {" CR;
            trigger stylesheetclass;
            put "}" CR;
        end;

        define event tdstyle;
            style = data;
            put "td {" CR;
            trigger stylesheetclass;
            put "}" CR;
        end;

        define event thstyle;
            style = header;
            put "th {" CR;
            trigger stylesheetclass;
            put "}" CR;
        end;

        define event style_align;
            trigger csstextalign;
            trigger put_inline_styles;
        end;

        define event put_inline_styles;
            put ' ' tagattr;
            do / if $styles;
                put ' style="';
                putvars $styles ' ' _name_ ': ' _value_ ';';
                put htmlstyle / if htmlstyle;
                put '"';
            done;
            unset $styles;
        end;

        define event put_styles;
            do / if $styles;
                putvars $styles '  ' _name_ ': ' _value_ ';' CR;
                put htmlstyle / if htmlstyle;
            done;
            unset $styles;
        end;

        define event set_just_lookup;
            set $just_lookup['c'] 'center';
            set $just_lookup['r'] 'right';
            set $just_lookup['d'] 'right';
            set $just_lookup['l'] 'left';
            set $just_lookup['C'] 'center';
            set $just_lookup['R'] 'right';
            set $just_lookup['D'] 'right';
            set $just_lookup['L'] 'left';
            set $vjust_lookup['t'] 'top';
            set $vjust_lookup['m'] 'middle';
            set $vjust_lookup['c'] 'middle';
            set $vjust_lookup['b'] 'bottom';
            set $vjust_lookup['T'] 'top';
            set $vjust_lookup['M'] 'middle';
            set $vjust_lookup['C'] 'middle';
            set $vjust_lookup['B'] 'bottom';
        end;

end;
run;
