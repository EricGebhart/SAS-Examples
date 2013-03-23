
proc template;

    /******************************************************/
    /******************************************************/
    /******************************************************/
    /*  Plain Jane HTML definition                        */
    /******************************************************/
    /******************************************************/
    /******************************************************/
    define tagset tagsets.phtml;
        notes "This is the plain HTML definition";

        /* until inheritance is fixed */
        %let  map =<>%nrstr(&)%str(%')%str(%");
        map="&map";
        mapsub = '/&lt;/&gt;/&amp;/&#39;/&quot;/';
        /*  old map
        map = '<>&';
        mapsub = '/&lt;/&gt;/&amp;/';
        */
        nobreakspace = '&nbsp;';
        split = '<br>';
        stacked_columns = yes;
        output_type = 'html';
        image_formats = 'gif,jpeg,png,java,activex,svg';
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

        define event stylesheet_link;
            break /if !exists(url);
            set $urlList url;
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

                put " frameborder=";
                put '"yes"'  / if !exists(FRAMEBORDER);
                putq FRAMEBORDER;

                put " framespacing=";
                put '"3"'  / if !exists(FRAMESPACING);
                putq FRAMESPACING;

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

                put " frameborder=";
                put '"yes"'  / if !exists(FRAMEBORDER);
                putq FRAMEBORDER;

                put " framespacing=";
                put '"3"'  / if !exists(FRAMESPACING);
                putq FRAMESPACING;

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
            trigger contents_code;
        end;

        define event contents_bullet_style;
           put "<style type=""text/css"">" CR;
           put "<!--" CR;
           put "/* Outline Style Sheet */" CR CR;
           put "UL { cursor: hand;" CR;
           put "    list-style-type: decimal;}" CR CR;
           put "DL { cursor: hand;" CR;
           put "    list-style-type: none;}" CR CR;
           put "// so Netscape wont indent so far" CR;
           put "DL {marginLeft: -12pt}" CR CR;
           put "SPAN {cursor: hand}" CR;
           put "-->" CR;
           put "</style>" CR CR;
       end;

       define event contents_javascript;
           trigger contents_bullet_style;
           trigger contents_inline_code /if !any(code_name, code_url);
           trigger contents_code_link /if any(code_name, code_url);
           put CR;
           put "<style type=""text/javascript"">" CR;
           put "<!--" CR;
           put "  contextual(tags.UL, tags.DL).display = 'block';" CR;
           put "//-->" CR;
           put "</style>" CR;
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
               put "<noscript></noscript>" CR;

        end;

        define event contents_code;
           put "// This script controls the expanding " CR;
           put "// and collapsing of lists in MSIE 4.0." CR;
           put "//" CR;
           put "// Check for MSIE 4.0." CR;
           put "var msie4 = 0;" CR;
           put "var ver = parseInt(navigator.appVersion);" CR;
           put "if (navigator.userAgent.indexOf(""MSIE"") > -1 && ver >= 4){" CR;
           put "  msie4 = 1;" CR;
           put "  // Add style sheet info that screws up Netscape 4" CR;
           put "  document.write('<style type=""text/css""> UL DL { display:none; cursor: hand; list-style-type: none; margin-left: 10pt}  </style>');" CR;
           put CR;
           put "  // Set document events" CR;
           put "  document.onclick = outline;" CR;
           put "  document.onmouseover = doAction;" CR;
           put "  document.onmouseout = undoAction;" CR;
           put CR;
           put "  // Initialize expander" CR;
           put "  var display_mode = 'none'" CR;
           put CR;
           put "  // Set images to use for folders" CR;
           put "  var openImage = '';" CR;
           put "  var closeImage = '';" CR;
           put CR;
           put "  // Preload images so they're in the cache" CR;
           put "  image1 = new Image ();" CR;
           put "  image1.src = openImage;" CR;
           put "  image2 = new Image ();" CR;
           put "  image2.src = closeImage;" CR;
           put "}" CR;
           put CR;
           put "// Change folder to open or close as appropriate" CR;
           put "function changeFolder(actionTag, tagPos) {" CR;
           put "  // Check all tags encapsulated by the clicked tag" CR;
           put "  while (actionTag.contains(document.all[tagPos])){" CR;
           put "    // If a UL or DL is hit, bail out" CR;
           put "    if (document.all[tagPos].tagName == 'DL' || document.all[tagPos].tagName == 'UL') return; " CR;
           put CR;
           put "    // If an image is hit, check for a folder and change as needed" CR;
           put "    if (document.all[tagPos].tagName == 'IMG'){" CR;
           put "      // Check for closed folder" CR;
           put "      if (document.all[tagPos].src.indexOf(closeImage) > -1){" CR;
           put "        document.all[tagPos].src = openImage;" CR;
           put "        break;" CR;
           put "      }" CR;
           put "      // Check for open folder" CR;
           put "      else if (document.all[tagPos].src.indexOf(openImage) > -1){" CR;
           put "        document.all[tagPos].src = closeImage;" CR;
           put "        break;" CR;
           put "      }" CR;
           put "    }" CR;
           put "    tagPos++;" CR;
           put "    // If you reach the end of the document, bail out." CR;
           put "    if (tagPos >= document.all.length-1) return;" CR;
           put "  }" CR;
           put "}" CR;
           put CR;
           put "// Source Code for Outlining" CR;
           put "function checkParent(src) {" CR;
           put "  // Search for a specific parent of the current element" CR;
           put "  while (src != null) {" CR;
           put "    // If an LI or DT is clicked, return src.  If not," CR;
           put "    //  look for at parent elements until you find" CR;
           put "    //  one, and return it." CR;
           put "    if (src.tagName == 'LI' || src.tagName == 'DT') return src;" CR;
           put "    src = src.parentElement;" CR;
           put "  }" CR;
           put "  // If there are no LIs or DTs in the current element or parent" CR;
           put "  //  elements, return null." CR;
           put "  return null;" CR;
           put "}" CR;
           put "  " CR;
           put "function outline() {     " CR;
           put "  // Make sure clicked inside an LI or DT. " CR;
           put "  // This test allows rich HTML inside lists." CR;
           put "  var clickedElement = checkParent(event.srcElement);" CR;
           put " " CR;
           put "  if (clickedElement != null) {" CR;
           put "    // Get the position of the clicked HTML element" CR;
           put "    var pos = clickedElement.sourceIndex+1;" CR;
           put " " CR;
           put "    // Change folder image as necessary" CR;
           put "    if (closeImage != '' && openImage != '') changeFolder(clickedElement, pos);" CR;
           put " " CR;
           put "    // Starting at the first HTML element index after the " CR;
           put "    //  clicked element, look at every HTML element until" CR;
           put "    //  another UL is found and break." CR;
           put "    while (clickedElement.contains(document.all[pos])){" CR;
           put "      if (document.all[pos].tagName == 'DL' || document.all[pos].tagName == 'UL'){" CR;
           put "        // If you get this far, toggle the display element of the tag" CR;
           put "        toggleView(pos);" CR;
           put "        break;" CR;
           put "      }" CR;
           put "  pos++;" CR;
           put "      if (pos >= document.all.length-1) return;" CR;
           put "    }" CR;
           put "  }else{" CR;
           put "    return;" CR;
           put "  }" CR;
           put " " CR;
           put "  event.cancelBubble = true;" CR;
           put "}" CR;
           put " " CR;
           put "function toggleView(pos){" CR;
           put "  // Now that we've found the next UL, decide whether it " CR;
           put "  //  should be visible or hidden." CR;
           put "  if (document.all[pos].style.display == '' ||" CR;
           put "      document.all[pos].style.display == 'none') {" CR;
           put "    document.all[pos].style.display = 'block';" CR;
           put "  }else{" CR;
           put "    document.all[pos].style.display = 'none';" CR;
           put "  }" CR;
           put "}" CR;
           put CR;
           put "// Display action class when mouse is over SPAN" CR;
           put "function doAction(){" CR;
           put "  if (event.srcElement != null && event.srcElement.tagName == 'SPAN'){" CR;
           put "    event.srcElement.className = 'action';" CR;
           put "  }" CR;
           put "}" CR;
           put CR;
           put "// Display no class when mouse moves off of SPAN" CR;
           put "function undoAction(){" CR;
           put "  if (event.srcElement != null && event.srcElement.tagName == 'SPAN'){" CR;
           put "    event.srcElement.className = '';" CR;
           put "  }" CR;
           put "}" CR;
           put CR;
           put "// Expand all lists and display all folders" CR;
           put "function expandAll(level){" CR;
           put "  display_mode = (display_mode == 'none') ? 'block' : 'none'" CR;
           put "  setDisplay('DL', level)" CR;
           put "  setDisplay('UL', level)" CR;
           put "}" CR;
           put "// Set the display to the proper mode." CR;
           put "// list_type is the tagname of the list to look at.  level" CR;
           put "// is the maximum nest level to display/hide." CR;
           put "function setDisplay(list_type, level) {" CR;
           put "  // If level is < 0 or undefined, expand/contract all lists." CR;
           put "  if (!level || level < 0) level = document.all.length" CR;
           put " " CR;
           put "  for(i=0; i < document.all.tags(list_type).length; i++){" CR;
           put "     level_count = 0" CR;
           put "     object = document.all.tags(list_type)[i]" CR;
           put "     pos = document.all.tags(list_type)[i].sourceIndex" CR;
           put "     " CR;
           put "     // Start at the current list object and work your way" CR;
           put "     // out until we hit a body tag.  Keep track of all of the" CR;
           put "     // lists we hit on the way out, so we know how deep we are." CR;
           put "     while (object.tagName != 'BODY') {" CR;
           put "        if (object.tagName == 'DL' || object.tagName == 'UL') " CR;
           put "           level_count++" CR;
           put "        // If we're already nested too deep, break out." CR;
           put "        if (level_count > level) break" CR;
           put "        object = object.parentElement" CR;
           put "     }" CR;
           put CR;
           put "     // If we are in legal range, change the display." CR;
           put "     if (level_count <= level && level_count > 0) {" CR;
           put "        document.all[pos].style.display = display_mode  " CR;
           put CR;
           put "        if (level_count != level && closeImage != '' && openImage != '') {" CR;
           put "           object = document.all[++pos]    " CR;
           put CR;
           put "           // Check for open/close folders to change." CR;
           put "           while (pos < document.all.length && object.tagName != 'IMG') {" CR;
           put "              if (object.tagName == 'UL' || object.tagName == 'DL') " CR;
           put "                 break" CR;
           put "              object = document.all[++pos]" CR;
           put "           }" CR;
           put " " CR;
           put "           // Change the image." CR;
           put "           if (pos < document.all.length && object.tagName == 'IMG' && " CR;
           put "               (object.src.indexOf(closeImage) > -1 ||" CR;
           put "                object.src.indexOf(openImage)  > -1)) {" CR;
           put "              if (!display_mode || display_mode == 'none')" CR;
           put "                 object.src = closeImage" CR;
           put "              else" CR;
           put "                 object.src = openImage" CR;
           put "           }" CR;
           put "        }" CR;
           put "     }" CR;
           put "  }" CR;
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
            put "<noscript></noscript>" CR;
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
            put '<meta name="Generator" content="SAS Software, see www.sas.com"';
            set $generic getoption('generic');
            /*putlog "GENERIC: " $generic;*/
            putq ' sasversion=' SASVERSION /if cmp($generic, 'NOGENERIC');
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
            put '<meta name="Generator" content="SAS Software, see www.sas.com"';
            set $generic getoption('generic');
            /*putlog "GENERIC: " $generic;*/
            putq ' sasversion=' SASVERSION /if cmp($generic,'NOGENERIC');
            put $empty_tag_suffix;
            put '>' CR;
            trigger show_charset;
            put "<meta " VALUE $empty_tag_suffix ">" nl /if exists(value);
            break /if !any( htmlcontenttype, encoding, $show_charset);
            put "<meta";
            put ' http-equiv="Content-Type" content="' / if any(HTMLCONTENTTYPE, encoding,
                                                                $showcharset);
            put HTMLCONTENTTYPE;
            put "; " / if exists(HTMLCONTENTTYPE, encoding, $show_charset);
            put "charset=" encoding / if exists($show_charset);
            put '"';
            put $empty_tag_suffix;
            put '>' CR;
        end;

        define event ie_check;
            trigger javascript start;
            put 'var _info = navigator.userAgent' CR;
            put 'var _ie = (_info.indexOf("MSIE") > 0' CR;
            put '          && _info.indexOf("Win") > 0' CR;
            put '          && _info.indexOf("Windows 3.1") < 0);' CR;
            set $ieCheckDone "true";
            trigger javascript finish;
        end;

        /* Web Accessibility Feature 1194.22 (I)   */
        /*-----------------------------------------*/
        define event doc_body;
            put '<body onload="startup()"';
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
            put "</body>" CR;
        end;

        define event doc_foot;
            start:
                put "<foot>" CR;
            finish:
                put "</foot>" CR;
        end;

        /* Web Accessibility Feature 1194.22 (I)   */
        /*-----------------------------------------*/
        define event javascript;
         start:
             put '<script language="javascript" type="text/javascript">' CR;
             put "<!-- " CR;
         finish:
             put CR "//-->"  CR;
             put "</script>" CR CR;
             put '<noscript></noscript>' CR;               /* 508 */
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

        define event stylesheetclass;
            put "  font-family: " FONT_FACE;
            put ";" CR  / exists(FONT_FACE);
            put "  font-size: " FONT_SIZE;
            put ";" CR  / exists(FONT_SIZE);
            put "  font-weight: " FONT_WEIGHT;
            put ";" CR  / exists(FONT_WEIGHT);
            put "  font-style: " FONT_STYLE;
            put ";" CR  / exists(FONT_STYLE);
            put "  color: " FOREGROUND;
            put ";" CR / exists(FOREGROUND);
            put "  text-decoration: " text_decoration;
            put ";" CR / exists(text_decoration);
            put "  background-color: " BACKGROUND;
            put ";" CR  / exists(BACKGROUND);
            put "  background-image: url('" BACKGROUNDIMAGE "')" /if exists(backgroundimage);
            put ";" CR  / exists(BACKGROUNDIMAGE);

            trigger margins;

            /*trigger Border_shadow / if exists(BORDERCOLORDARK, BORDERCOLORLIGHT ); */

            trigger Border;


            put "  list-style-type: " BULLET;
            put  ";" CR  / exists(BULLET);
            put "  height: " OUTPUTHEIGHT;
            put  ";" CR  / exists(OUTPUTHEIGHT);
            put "  width: " OUTPUTWIDTH;
            put  ";" CR  / exists(OUTPUTWIDTH);
            put "  text-align: " / exists(just);
            put $just_lookup[just];
            put  ";" CR  / exists(just);
            put "  vertical-align: " / exists(vjust);
            put $vjust_lookup[vjust];
            put  ";" CR  / exists(vjust);
            put  "  " htmlstyle;
            put  ";" CR / exists(htmlstyle);
        end;

        define event margins;
            put " text-indent: " indent;
            put  ";" nl / exists(indent);
            break /if cmp(htmlclass, 'contentItem');
            break /if cmp(htmlclass, 'pagesItem');
            break /if cmp(htmlclass, 'ContentFolder');
            break /if cmp(htmlclass, 'ByContentFolder');
            put "  margin-left: " MARGINLEFT;
            put ";" CR  / exists(MARGINLEFT);
            put "  margin-right: " MARGINRIGHT;
            put ";" CR  / exists(MARGINRIGHT);
            put "  margin-top: " MARGINTOP;
            put ";" CR  / exists(MARGINTOP);
            put "  margin-bottom: " MARGINBOTTOM;
            put ";" CR  / exists(MARGINBOTTOM);
        end;

        define event Border_shadow;
            put " border-left: " BORDERWIDTH;
            put " outset: " / exists(BORDERCOLORLIGHT);
            put ";" CR  / exists(BORDERCOLORLIGHT);
            put " border-top: " BORDERWIDTH;
            put " outset: " / exists(BORDERCOLORLIGHT);
            put ";" CR  / exists(BORDERCOLORLIGHT);
            put " border-right: " BORDERWIDTH;
            put " outset: " / exists(BORDERCOLORDARK);
            put ";" CR  / exists(BORDERCOLORDARK);
            put " border-bottom: " BORDERWIDTH;
            put " outset: " / exists(BORDERCOLORDARK);
            put ";" CR  / exists(BORDERCOLORDARK);
        end;

        define event Border;
            put "  border-width: " borderwidth;
            put ";" CR  / exists(borderwidth);

            put "  border-top-width: " bordertopwidth;
            put  ";" CR  / exists(bordertopwidth);
            put "  border-bottom-width: " borderbottomwidth;
            put  ";" CR  / exists(borderbottomwidth);
            put "  border-right-width: " borderrightwidth;
            put  ";" CR  / exists(borderrightwidth);
            put "  border-left-width: " borderleftwidth;
            put  ";" CR  / exists(borderleftwidth);

            put "  border-color: " bordercolor;
            put ";" CR  / exists(bordercolor);

            put "  border-top-color: " bordertopcolor;
            put  ";" CR  / exists(bordertopcolor);
            put "  border-bottom-color: " borderbottomcolor;
            put  ";" CR  / exists(borderbottomcolor);
            put "  border-right-color: " borderrightcolor;
            put  ";" CR  / exists(borderrightcolor);
            put "  border-left-color: " borderleftcolor;
            put  ";" CR  / exists(borderleftcolor);

            put "  border-style: " borderstyle;
            put  ";" CR  / exists(borderstyle);

            put "  border-top-style: " bordertopstyle;
            put  ";" CR  / exists(bordertopstyle);
            put "  border-bottom-style: " borderbottomstyle;
            put  ";" CR  / exists(borderbottomstyle);
            put "  border-right-style: " borderrightstyle;
            put  ";" CR  / exists(borderrightstyle);
            put "  border-left-style: " borderleftstyle;
            put  ";" CR  / exists(borderleftstyle);
        end;


        define event style_inline;
            put ' ' tagattr;
            break / if !any(font_face, font_size, font_weight, font_style,
                            foreground, background, backgroundimage,
                            marginleft, marginright, margintop, marginbottom,
                            bullet, outputheight, outputwidth, htmlstyle, indent, text_decoration,
                            borderwidth,
                            bordertopwidth, borderbottomwidth, borderrightwidth, borderleftwidth,
                            bordercolor,
                            bordertopcolor, borderbottomcolor, borderrightcolor, borderleftcolor,
                            borderstyle,
                            bordertopstyle, borderbottomstyle, borderrightstyle, borderleftstyle);
            put ' style="';
            put " font-family: " FONT_FACE;
            put  ";" / exists(FONT_FACE);
            put " font-size: " FONT_SIZE;
            put  ";" / exists(FONT_SIZE);
            put " font-weight: " FONT_WEIGHT;
            put  ";" / exists(FONT_WEIGHT);
            put " font-style: " FONT_STYLE;
            put  ";" / exists(FONT_STYLE);
            put " color: " FOREGROUND;
            put  ";" / exists(FOREGROUND);
            put " text-decoration: " text_decoration;
            put ";" / exists(text_decoration);
            put " background-color: " BACKGROUND;
            put  ";" / exists(BACKGROUND);
            put "  background-image: url('" BACKGROUNDIMAGE "')" /if exists(backgroundimage);
            put  ";" / exists(BACKGROUNDIMAGE);
            put " margin-left: " MARGINLEFT;
            put  ";" / exists(MARGINLEFT);
            put " margin-right: " MARGINRIGHT;
            put  ";" / exists(MARGINRIGHT);
            put " margin-top: " MARGINTOP;
            put  ";" / exists(MARGINTOP);
            put " margin-bottom: " MARGINBOTTOM;
            put  ";" / exists(MARGINBOTTOM);
            put " text-indent: " indent;
            put  ";" / exists(indent);

            trigger Border_inline ;

            put " list_style_type: " BULLET;
            put  ";" / exists(BULLET);
            put " height: " OUTPUTHEIGHT;
            put  ";" / exists(OUTPUTHEIGHT);
            put " width: " OUTPUTWIDTH;
            put  ";" / exists(OUTPUTWIDTH);

/*
            put "  text-align: " / exists(just);
            put 'center' /if cmp(just, 'c');
            put 'right' /if cmp(just, 'r');
            put 'left' /if cmp(just, 'l');
            put  ";" / exists(vjust);
            put "  vertical-align: " / exists(vjust);
            put 'middle' /if cmp(vjust, 'c');
            put 'top' /if cmp(vjust, 't');
            put 'bottom' /if cmp(vjust, 'b');
            put  ";" / exists(vjust);
*/
            put  " " htmlstyle;
            put  ";" / exists(htmlstyle);
            put '"';
        end;

        define event Border_inline;
            put "  border-width: " borderwidth;
            put ";"  / exists(borderwidth);

            put "  border-top-width: " bordertopwidth;
            put  ";"  / exists(bordertopwidth);
            put "  border-bottom-width: " borderbottomwidth;
            put  ";"  / exists(borderbottomwidth);
            put "  border-right-width: " borderrightwidth;
            put  ";"  / exists(borderrightwidth);
            put "  border-left-width: " borderleftwidth;
            put  ";"  / exists(borderleftwidth);

            put "  border-color: " bordercolor;
            put ";"  / exists(bordercolor);

            put "  border-top-color: " bordertopcolor;
            put  ";"  / exists(bordertopcolor);
            put "  border-bottom-color: " borderbottomcolor;
            put  ";"  / exists(borderbottomcolor);
            put "  border-right-color: " borderrightcolor;
            put  ";"  / exists(borderrightcolor);
            put "  border-left-color: " borderleftcolor;
            put  ";"  / exists(borderleftcolor);

            put "  border-style: " borderstyle;
            put  ";"  / exists(borderstyle);

            put "  border-top-style: " bordertopstyle;
            put  ";"  / exists(bordertopstyle);
            put "  border-bottom-style: " borderbottomstyle;
            put  ";"  / exists(borderbottomstyle);
            put "  border-right-style: " borderrightstyle;
            put  ";"  / exists(borderrightstyle);
            put "  border-left-style: " borderleftstyle;
            put  ";"  / exists(borderleftstyle);

        end;

        define event embedded_stylesheet;
           start:
              put "<style type=""text/css"">" nl "<!--" nl;
           finish:
              trigger alignstyle;
              put "-->" nl "</style>" nl;
        end;

        define event style;
            put "<style type=""text/css"">" CR;
        finish:
            put "</style>" CR;
        end;

        define event shortstyles;
             /*    put "<style type=""text/css"">" CR;
            put "<!--" CR; */
            trigger bodystyle;
            trigger titlestyle;
            trigger proctitlestyle;
            trigger tablestyle;
            trigger tdstyle;
            trigger thstyle;
             /*put "-->" CR;
            put "</style>" CR;*/
        end;

        define event alignstyle ;
            putl '.l {text-align: left }';
            putl '.c {text-align: center }';
            putl '.r {text-align: right }';
            putl '.d {text-align: "." }';
            putl '.t {vertical-align: top }';
            putl '.m {vertical-align: middle }';
            putl '.b {vertical-align: bottom }';
            putl 'TD, TH {vertical-align: top }';
            putl '.stacked_cell{padding: 0 }';
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
            /* a:link, a:visited, a:hover, a:active */
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
            put '<a href="' URL;
            /*put "#" ANCHOR;*/
            put '"';
            putq " target=" HREFTARGET;
            put ">";
            put VALUE;
          finish:
            put "</a>" CR;
        end;

        define event contents_list;
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

        define event contents_branch;
            file=CONTENTS;
            start:
                trigger list_entry start;
                trigger list;
            finish:
                trigger list finish;
                trigger list_entry finish;
        end;

        define event contents_leaf;
            file=CONTENTS;
            trigger list_entry start;
            trigger list_entry finish;
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
            put PAGEBREAKHTML CR;
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
            put '<div';
            trigger alt_align;
            put '>' nl;
            put '<embed height="100%" width="100%" name="SVGEmbed"';
            do /if any(outputheight, outputwidth);
                put ' style="';
                put "height:" OUTPUTHEIGHT ";" /if outputheight;
                put " width:" OUTPUTWIDTH ";" /if outputwidth;
                put '"';
            done;
            put ' src="';
            put BASENAME / if !exists(NOBASE);
            put URL;
            put '"';
            put ' type="image/svg+xml"';
            put ' pluginspage="http://www.adobe.com/svg/viewer/install/"></embed>';
            put "</div>" CR;
        end;


        define event image;

            unset $img_extension;
            set $img_extension reverse(url);
            set $img_extension scan($img_extension, 1, '.');
            set $img_extension reverse($img_extension);
            trigger embed_svg /breakif cmp($img_extension, 'SVG');

            put '<div';
            trigger alt_align;
            put '>' nl;
            put "<img";
            putq ' alt=' alt;
            put ' src="';
            put BASENAME / if !exists(NOBASE);
            put URL;
            put '"';
            put ' style="' /if any(outputheight, outputwidth);
            put "height:" OUTPUTHEIGHT ";" /if exists(outputheight);
            put " width:" OUTPUTWIDTH ";" /if exists(outputwidth);
            put '"' /if any(outputheight, outputwidth);
            put ' border="0"';
            put ' usemap="#' @CLIENTMAP;
            put ' usemap="#' NAME / if !exists(@CLIENTMAP);
            put '"' / if any(@CLIENTMAP , NAME);
            putq " id="    HTMLID;
            trigger classalign;
            put $empty_tag_suffix;
            put ">" CR;
            put "</div>" CR;

        end;

        define event style_align;
            break /if !any(just, vjust);
            put ' style="';
            trigger inline_just /if exists(just) ;
            trigger inline_vjust /if exists(just) ;
            put '"';
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

        define event inline_just;
            put ' text-align: ';
            put $just_lookup[just] ';';
        end;

        define event inline_vjust;
            put ' vertical-align: ';
            put $vjust_lookup[vjust] ';';
        end;

        define event paragraph;
            start:
                put "<p>" nl;
                put  VALUE;
            finish:
                put "</p>" nl;
        end;

     /* Web Accessibility Feature 1194.2 (H) */
     /*--------------------------------------*/
     define event table;
         start:
             put "<div";
             trigger alt_align;
             put ">" CR;
             put "<table";
             trigger style_inline;
             putq " cellspacing=" CELLSPACING;
             putq " cellpadding=" CELLPADDING;
             putq " rules=" LOWCASE(RULES);
             putq " frame=" LOWCASE(FRAME);
             trigger table_summary;
             put ">" CR;
             set $parent_table_spacing cellspacing;
             set $parent_table_padding cellpadding;
         finish:
             put "</table>" CR;
             put "</div>" CR;
     end;

     define event verbatim_container;
         start:
             put "<div";
             trigger alt_align;
             put ">" CR;
             put "<table";
             trigger style_inline;
             putq " cellspacing=" CELLSPACING;
             putq " cellpadding=" CELLPADDING;
             putq " rules=" LOWCASE(RULES);
             putq " frame=" LOWCASE(FRAME);
             put ' summary="Page Layout"';
             put ">" CR;
         finish:
             put "</table>" CR;
             put "</div>" CR;
     end;

     define event verbatim;
         start:
             put "<tr><td";
             put ">" CR;
             trigger preformatted;
         finish:
             trigger preformatted;
             put "</td></tr>" CR;
     end;

     define event verbatim_text;
             put value;
             put nl;
     end;

     define event table_summary;
             put ' summary=';                              /* 508 */
             putq summary;                                 /* 508 */
             break /if exists(summary);                    /* 508 */
             put '"';                                      /* 508 */
             put "Procedure " proc_name ": ";              /* 508 */
             put  output_label;                            /* 508 */
             put output_name /if !exist(output_label);     /* 508 */
             put '"';                                      /* 508 */
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
                set $vjust vjust;
                set $just just;
                set $just "r" /when cmp("d", just);
                set $vjust "m" /when cmp("c", vjust);
                put ' class="';
                put $just ' ' $vjust /if any($just, $vjust);
                unset $vjust;
                unset $just;
            finish:
                put '"';
        end;

        define event classalign;
            trigger real_align start;
            put ' ' htmlclass;
            trigger real_align finish;
        end;

        define event header;
            start:
                put "<th";
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
                put '<table width="100%" border="0"';
                putq ' cellpadding=' $parent_table_padding;
                putq ' cellspacing="0"';
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
            set $close_hyperlink "true" / if exists(URL);
            trigger hyperlink / if exists(URL);
            put value / if !exists(URL);
          finish:
            trigger hyperlink / if exists($close_hyperlink);
            unset $close_hyperlink;
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
            trigger align;
            put ">";
            put TEXT;
        finish:
            put "</td>" CR;
            put "</tr><tr><td>" / if cmp(TYPE, "T");
            put "</td><td>" / if cmp(TYPE, "L");
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
                 set $pre_post $pre_post  $empty_tag_suffix /if exists(POSTIMAGE);
                 set $pre_post $pre_post  '>' /if exists(POSTIMAGE);
             done;
             set $pre_post $pre_postput POSTHTML;
             put '<span';
             putq " title=" flyover;
             trigger classalign; /* fwh */
             trigger style_inline;
             put ">";
             put value;
        finish:
             put "</span>";
             put $pre_post;
             unset $pre_post;
         end;

        define event nbspace;
            start:
                put space ;
        end;

        define event format;
             put '<span';
             trigger style_inline;
             put ">";
             put value;
             put "</span>";
        end;

        define event title_format_section;
             put '<span';
             trigger style_inline;
             put ">";
             trigger hyperlink_value / if exists(URL);
             put VALUE / if !exists(URL);
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
                trigger contents_branch;
            finish:
                break / if hidden;
                trigger contents_branch;
        end;

        define event proc_branch;
            start:
                break / if hidden;
                set $proc_name "true";
                trigger contents_branch;
                trigger pages_branch;
                unset $proc_name;
            finish:
                break / if hidden;
                set $proc_name "true";
                trigger contents_branch;
                trigger pages_branch;
                unset $proc_name;
        end;

        define event leaf;
        start:
           break / if hidden;
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
          start:
            put '<table frame="box"';
            putq " border=" BORDERWIDTH / if exist( BORDERWIDTH );
            putq " borderstyle=" BORDERSTYLE /if exist( BORDERSTYLE);
            putq " bordercolor=" BORDERCOLOR / if exist( BORDERCOLOR );
            putq " bordercolordark=" BORDERCOLORDARK /if exist( BORDERCOLORDARK);
            putq " bordercolorlight=" BORDERCOLORLIGHT /if exist( BORDERCOLORLIGHT);
            putq " cellspacing=" CELLSPACING / if exist( CELLSPACING );
            putq " cellpadding=" CELLPADDING / if exist( CELLPADDING );
            putq " bgcolor=" PRETEXT / if exist( PRETEXT );
            put ' summary="Page Layout">' CR;
            put '<tr>' CR;
            put '<td>' CR;
          finish:
            put '</td>' CR;
            put '</tr>' CR;
            put '</table>' CR;
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

        define event newline;
            do /if value;
                eval $ncount inputn(value, "3.");
            else;
                eval $ncount 1;
            done;

            do /while $ncount;
                put "<br>" nl;
                eval $ncount $ncount-1;
            done;
            unset $ncount;
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

        define event style_class;
            put "." HTMLCLASS CR;
            put "{" CR;
            trigger stylesheetclass;
            put "}" CR;
            trigger link_classes /if cmp(htmlclass, "document");
            trigger table_border_vars /if cmp(htmlclass, "table");
            trigger batch_border_vars /if cmp(htmlclass, "batch");
            trigger graph_border_vars /if cmp(htmlclass, "graph");
            trigger container_border_vars /if cmp(htmlclass, "systitleandfootercontainer");
            trigger stacked_column_styles /if cmp(htmlclass, "table");
        end;


        define event container_border_vars;
           set $container_border_color borderColor;
           set $container_border_width borderWidth;
        end;

        define event table_border_vars;
           set $table_border_color borderColor;
           set $table_border_width borderWidth;
        end;

        define event batch_border_vars;
           set $batch_border_color borderColor;
           set $batch_border_width borderWidth;
        end;

        define event graph_border_vars;
           set $graph_border_color borderColor;
           set $graph_border_width borderWidth;
        end;

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

         /* Web Accessibility Feature 1194.2 (H) */
         /*--------------------------------------*/
         define event table;
             start:
                 put "<div";
                 trigger alt_align;
                 put ">" CR;
                 trigger pre_post;
                 put "<table";
                 putq " class=" HTMLCLASS;
                 trigger style_inline;
                 putq " cellspacing=" CELLSPACING;
                 putq " cellpadding=" CELLPADDING;
                 set $parent_table_spacing cellspacing;
                 set $parent_table_padding cellpadding;
                 putq " rules=" LOWCASE(RULES);
                 putq " frame=" LOWCASE(FRAME);
                 trigger put_table_border_vars;
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
                 putq " class=" HTMLCLASS;
                 trigger style_inline;
                 putq " cellspacing=" CELLSPACING;
                 putq " cellpadding=" CELLPADDING;
                 putq " rules=" LOWCASE(RULES);
                 putq " frame=" LOWCASE(FRAME);
                 trigger put_batch_border_vars;
                 put ' summary="Page Layout"';
                 put ">" CR;
             finish:
                 put "</table>" CR;
                 trigger pre_post;
                 put "</div>" CR;
         end;

         define event put_container_border_vars;
            putq " border=" $container_border_width /if !exists(borderWidth);
            putq " border=" borderwidth /if exists(borderWidth);
            putq " bordercolor=" $container_border_color /if !exists(bordercolor);
            putq " bordercolor=" bordercolor /if exists(bordercolor);
         end;

         define event put_table_border_vars;
            putq " border=" $table_border_width /if !exists(borderWidth);
            putq " border=" borderwidth /if exists(borderWidth);
            putq " bordercolor=" $table_border_color /if !exists(bordercolor);
            putq " bordercolor=" bordercolor /if exists(bordercolor);
         end;

         define event put_batch_border_vars;
            putq " border=" $batch_border_width /if !exists(borderWidth);
            putq " border=" borderwidth /if exists(borderWidth);
            putq " bordercolor=" $batch_border_color /if !exists(bordercolor);
            putq " bordercolor=" bordercolor /if exists(bordercolor);
         end;

        define event Border_inline;
            unset $border_width;
            unset $border_color;
            unset $border_style;

            set $border_width "true" /if any(borderwidth, bordertopwidth, borderbottomwidth,
                                       borderrightwidth, borderleftwidth);
            put "  border-width: " borderwidth;
            put ";"  / exists(borderwidth);

            put "  border-top-width: " bordertopwidth;
            put  ";"  / exists(bordertopwidth);
            put "  border-bottom-width: " borderbottomwidth;
            put  ";"  / exists(borderbottomwidth);
            put "  border-right-width: " borderrightwidth;
            put  ";"  / exists(borderrightwidth);
            put "  border-left-width: " borderleftwidth;
            put  ";"  / exists(borderleftwidth);

            set $border_color "true" /if any(bordercolor, bordertopcolor, borderbottomcolor,
                                       borderrightcolor, borderleftcolor);
            put "  border-color: " bordercolor;
            put ";"  / exists(bordercolor);

            put "  border-top-color: " bordertopcolor;
            put  ";"  / exists(bordertopcolor);
            put "  border-bottom-color: " borderbottomcolor;
            put  ";"  / exists(borderbottomcolor);
            put "  border-right-color: " borderrightcolor;
            put  ";"  / exists(borderrightcolor);
            put "  border-left-color: " borderleftcolor;
            put  ";"  / exists(borderleftcolor);

            set $border_style "true" /if any(borderstyle, bordertopstyle, borderbottomstyle,
                                       borderrightstyle, borderleftstyle);
            put "  border-style: " borderstyle;
            put  ";"  / exists(borderstyle);

            put "  border-top-style: " bordertopstyle;
            put  ";"  / exists(bordertopstyle);
            put "  border-bottom-style: " borderbottomstyle;
            put  ";"  / exists(borderbottomstyle);
            put "  border-right-style: " borderrightstyle;
            put  ";"  / exists(borderrightstyle);
            put "  border-left-style: " borderleftstyle;
            put  ";"  / exists(borderleftstyle);

        /*-------------------------------------------------------eric-*/
        /*-- If they gave a one or two of border width, style, and  --*/
        /*-- color then fill in the rest.  We need all three.  It's --*/
        /*-- a real kludge but it makes cell borders work better    --*/
        /*-- when someone doesn't specify all the the things they   --*/
        /*-- should.                                                --*/
        /*--                                                        --*/
        /*-- This will not work very well if the user expects the   --*/
        /*-- width, color, or style in the class to be the one      --*/
        /*-- that gets used.                                        --*/
        /*----------------------------------------------------20Dec02-*/
            break / if !any($border_color, $border_style, $border_width);
            break / if exists($border_color, $border_style, $border_width);

            trigger border_color_fake /if !exists($border_color);

            put " border-style: solid;" /if !exists($border_style);

            trigger border_width_fake /if !exists($border_width);

        end;

        define event border_color_fake;
            put " border-color:" $table_border_color ";" /if exists($table_border_color);
            put " border-color: #000000;" / if !exists($table_border_color);
        end;

        define event border_width_fake;
            put " border-width:" $table_border_width ";" /if exists($table_border_width);
            put " border-width: 1px;" /if !exists($table_border_width);
        end;

        define event preformatted;
            start:
                trigger nobreak /breakif cmp(data_viewer, 'Table');
                /*put '<a href="' anchor '-ascii">Skip ASCII Art</a>';*/
                put '<pre style="border:none"';
                trigger classalign;
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
        parent=tagsets.html4;
        embedded_stylesheet=yes;
        mvar _EXCELROWHEIGHT;
        mvar _INEXCEL;
        mvar _DECIMAL_SEPARATOR;
        mvar _THOUSANDS_SEPARATOR;

         define event initialize;
             trigger set_just_lookup;
             trigger set_nls_num;
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


        define event put_table_border_vars;
            do /if !exists(borderWidth);
                eval $borderW strip(tranwrd($table_border_width, "px", ""));
            else;
                eval $borderW strip(tranwrd(borderwidth, "px", ""));
            done;
            putq " border=" $borderW;
            putq " bordercolor=" $table_border_color /if !exists(bordercolor);
            putq " bordercolor=" bordercolor /if exists(bordercolor);
        end;


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
                putq '<td colspan=' $cell_count '</td>' /if $cell_count;
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
            unset $img_extension;
            set $img_extension reverse(url);
            set $img_extension scan($img_extension, '.', 1);
            trigger embed_svg /breakif cmp($img_extension, 'SVG');

            put '<div';
            trigger alt_align;
            put '>' nl;
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
            trigger classalign;
            put ">" CR;
            put "</div>" CR;
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
                put  '   document.writeln("CODEBASE=\"http://java.sun.com/products/plugin/autodl/jinstall-1_4_1-windows-i586.cab#Version=1,4,0,0\"");' CR;
                put  '}' CR;
                put  'else {' CR;
                put  '   document.writeln("TYPE=\"application/x-java-applet;version=1.4\"");' CR;
                put  '   document.writeln("CODEBASE=\"http://java.sun.com/products/plugin/index.html#download\"");' CR;
                put  '}' CR;

            finish:
                put  '</OBJECT>' CR;
            end;

        define event java2_parameters;
                put  '<PARAM NAME="TYPE" VALUE="application/x-java-applet;version=1.4">' CR;
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

        define event style_inline;
            put ' ' tagattr;
            break / if !any(font_face, font_size, font_weight, font_style,
                            foreground, background, backgroundimage,
                            marginleft, marginright, margintop,
                            marginbottom, bullet, outputheight, outputwidth,
                            htmlstyle, indent, text_decoration,
                            borderwidth, bordertopwidth, borderbottomwidth,
                            borderrightwidth, borderleftwidth,
                            bordercolor, bordertopcolor, borderbottomcolor,
                            borderrightcolor, borderleftcolor, borderstyle,
                            bordertopstyle, borderbottomstyle,
                            borderrightstyle, borderleftstyle,
                            just, vjust);
            put ' style="';
            put " font-family: " FONT_FACE;
            put  ";" / exists(FONT_FACE);
            put " font-size: " FONT_SIZE;
            put  ";" / exists(FONT_SIZE);
            put " font-weight: " FONT_WEIGHT;
            put  ";" / exists(FONT_WEIGHT);
            put " font-style: " FONT_STYLE;
            put  ";" / exists(FONT_STYLE);
            put " color: " FOREGROUND;
            put  ";" / exists(FOREGROUND);
            put " text-decoration: " text_decoration;
            put ";" / exists(text_decoration);
            put " background-color: " BACKGROUND;
            put  ";" / exists(BACKGROUND);
            put "  background-image: url('" BACKGROUNDIMAGE "')" /if exists(backgroundimage);
            put  ";" / exists(BACKGROUNDIMAGE);
            put " margin-left: " MARGINLEFT;
            put  ";" / exists(MARGINLEFT);
            put " margin-right: " MARGINRIGHT;
            put  ";" / exists(MARGINRIGHT);
            put " margin-top: " MARGINTOP;
            put  ";" / exists(MARGINTOP);
            put " margin-bottom: " MARGINBOTTOM;
            put  ";" / exists(MARGINBOTTOM);
            put " text-indent: " indent;
            put  ";" / exists(indent);

            trigger Border_inline ;

            put " list_style_type: " BULLET;
            put  ";" / exists(BULLET);
            put " height: " OUTPUTHEIGHT;
            put  ";" / exists(OUTPUTHEIGHT);
            put " width: " OUTPUTWIDTH;
            put  ";" / exists(OUTPUTWIDTH);

            put "  text-align: " / exists(just);
            put $just_lookup[just];
            put  ";" / exists(just);
            put "  vertical-align: " / exists(vjust);
            put $vjust_lookup[vjust];
            put  ";" / exists(vjust);

            put  " " htmlstyle;
            put  ";" / exists(htmlstyle);
            put '"';
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
            put "." HTMLCLASS CR;
            put "{" CR;
            trigger stylesheetclass;
            put "}" CR;
            trigger link_classes /if cmp(htmlclass, "document");
            trigger table_border_vars /if cmp(htmlclass, "table");
            trigger batch_border_vars /if cmp(htmlclass, "batch");
            trigger graph_border_vars /if cmp(htmlclass, "graph");
            trigger container_border_vars /if contains(htmlclass, "systitleandfootercontainer");
            trigger stacked_column_styles /if cmp(htmlclass, "table");
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

        define event spanhead1;
          start:
             put "<td";
            trigger classalign;
            putq " rowspan=" ROWSPAN /if !cmp(ROWSPAN, '1');
            putq " colspan=" COLSPAN /if !cmp(COLSPAN, '1');
            trigger style_inline;
            put ">";
            trigger pre_post start;
            trigger hyperlink_value / if exists(URL);
            put VALUE / if !exists(URL);
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
            trigger hyperlink_value / if exists(URL);
            put VALUE / if !exists(URL);
            put '&nbsp;' /if !exists(strip(value));
          finish:
            trigger hyperlink / if exists(URL);
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
            trigger hyperlink_value / if exists(URL);
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
            trigger hyperlink_value / if exists(URL);
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
             putq " cellspacing=" CELLSPACING;
             putq " cellpadding=" CELLPADDING;
             putq " rules=" LOWCASE(RULES);
             putq " frame=" LOWCASE(FRAME);
             trigger put_container_border_vars;
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
           put '<body onload="startup()"';
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
           put "</body>" CR;
        end;

         /* Web Accessibility Feature 1194.2 (H) */
         /*--------------------------------------*/
         define event table;
             start:
                 put "<div";
                 trigger alt_align;
                 put ">" CR;
                 trigger pre_post;
                 put "<table";
                 putq " class=" HTMLCLASS;
                 trigger style_inline;
                 putq " cellspacing=" CELLSPACING;
                 putq " cellpadding=" CELLPADDING;
                 putq " rules=" LOWCASE(RULES);
                 putq " frame=" LOWCASE(FRAME);
                 trigger table_summary;       /* 508 */
                 put ">" CR;
                 set $parent_table_spacing cellspacing;
                 set $parent_table_padding cellpadding;
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
                 putq " class=" HTMLCLASS;
                 trigger style_inline;
                 putq " cellspacing=" CELLSPACING;
                 putq " cellpadding=" CELLPADDING;
                 putq " rules=" LOWCASE(RULES);
                 putq " frame=" LOWCASE(FRAME);
                 put ' summary="Page Layout"';
                 put ">" CR;
             finish:
                 put "</table>" CR;
                 trigger pre_post;
                 put "</div>" CR;
         end;

         define event verbatim;
             start:
                 put "<tr><td";
                 put ">" CR;
                 trigger preformatted;
             finish:
                 trigger preformatted;
                 put "</td></tr>" CR;
         end;

         define event cell_value;
           start:
             trigger pre_post;
             trigger preformatted /if asis;
             set $close_hyperlink "true" / if exists(URL);
             trigger hyperlink / if exists(URL);
             trigger do_value / if !exists(URL);
           finish:
             trigger hyperlink / if exists($close_hyperlink);
             unset $close_hyperlink;
             trigger preformatted /if asis;
             trigger pre_post;
         end;

         define event header;
            start:
                put "<th";
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
                putq ' cellpadding=' $parent_table_padding;
                putq ' cellspacing="0"';
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
                put '<pre style="border:none"';
                trigger classalign;
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
         /*-- put in a <br> so there will be space between procs.    --*/
         /*----------------------------------------------------21May02-*/
        define event list_entry;
           start:
               unset $first_proc;
               set $first_proc "true" /if total_proc_count ne 1;
               put "<br>" /if exists($first_proc, $proc_name);
               put "<li";
               putq " class=" HTMLCLASS;
               /*put ' style="type: none"' /if any(prehtml, preimage); */
               put ">" nl;
               trigger do_link /if listentryanchor;
               trigger do_list_value/if !listentryanchor;
           finish:
               put "</li>" nl;
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
            put '<a href="' URL;
            /*put "#" ANCHOR;*/
            put '"';
            putq " target=" HREFTARGET;
            put ">";
            trigger do_value;
          finish:
            put "</a>" CR;
        end;

        define event do_value;
            put VALUE;
        end;

        define event contents_branch;
            file=CONTENTS;
            start:
                trigger list_entry start;
                trigger list;
            finish:
                trigger list finish;
                trigger list_entry finish;
        end;

        define event contents_leaf;
            file=CONTENTS;
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
                put path_name /if !exists(path_url);
                put path_url;
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
            trigger classalign;
            put ">";
            put TEXT;
        finish:
            put "</td>" CR;
            put "</tr><tr><td>" / if cmp(TYPE, "T");
            put "</td><td>" / if cmp(TYPE, "L");
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
     parent=tagsets.htmlcss;

     log_note = 'This tagset is create proper MVS pdse urls with ods. Use it like this:  ODS tagsets.mvshtml path="acct.PDSE.HTML" gpath="acct.PDSE.GIF" frame="FILEF" body="FILEB" contents="FILEC" base="http://your.server/MVSDS/" RS=None;';

    /*
    ODS MARKUP
        Tagset   = TAGSETS.MVSHTML
        Path     = 'SASMLM.PDSE.HTML'
        Gpath    = 'SASMLM.PDSE.GIF'
        Body     = 'WIDGET'
        Frame    = 'WIDGETF'
        Contents = 'WIDGETC'
        Base     = "http://mvs.sas.com/MVSDS/"
        RS       = None

    ;

    Then ODS would build the links to the HTML files like this:
    src="http://mvs.sas.com/MVSDS/'SASMLM.PDSE.HTML(WIDGETC)'"

    And:

    src="http://mvs.sas.com/MVSDS/'SASMLM.PDSE.HTML(WIDGET)'"
    While it builds the links to the GIF file(s) like this:
    src="http://mvs.sas.com/MVSDS/'SASMLM.PDSE.GIF(membername)'"
    */

    define event mvs_link;
      /* use the value of url by default */
      set $link url / if !exists($link);
      unset $base_len;
      unset $dot_pos;
      eval $sharp_pos 0;
      unset $name;
      unset $ext;

      eval $base_len length(basename);

      eval $base_len $base_len;

      /* move off of the last character */
      eval $base_len $base_len + 1;


    /*-----------------------------------------------------------eric-*/
    /*-- The link comes to us fully formed.  So we have             --*/
    /*-- to take it all back apart to get the filename and          --*/
    /*-- extension.                                                 --*/
    /*--------------------------------------------------------29Jun03-*/

      /* get the url minus the base */
      set $name substr($link, $base_len) / when $base_len ne 0;

      /* get the file minus the path We can just look for '/' */
      eval $slash_pos index($name, "/");

      /* If we found the slash then move past it and set the name. */
      /* otherwise the name we have must be ok.                    */
      do /if $slash_pos >= 0;
          /* move past the slash */
          eval $slash_pos $slash_pos + 1;
          set $name substr($name, $slash_pos);
      done;


      /* If an #anchor is on the end get rid of it */
      eval $sharp_pos index($name, '#');
      do /if $sharp_pos >= 0;
          eval $sharp_pos $sharp_pos - 1;
          set $name substr($name, 1, $sharp_pos) /
          when $sharp_pos gt 0;
      done;

        /*
        put "base_len: " $base_len nl;
        put " name: " $name nl;
        put " ext: " $ext nl;
        put " link: " $link nl;
        put "basename: " $basename nl;
        put "path: " path_name nl;
        put "gpath: " graph_path_name nl;
        put "Sharp Pos " ": " $sharp_pos nl;
        */

      /* put it all back together */
      put '"' ;
      put BASENAME ;
      put "'";
      put $name "'";
      put "#" anchor /if $sharp_pos gt 0;
      put '"';
    end;

      define event hyperlink;
         start:
           put '<a href=';
           trigger mvs_link;
           unset $link;
           putq " target=" HREFTARGET;
           put ">";
           put VALUE;
         finish:
           put "</a>" CR;
       end;

        define event embed_svg;
            put '<div';
            trigger alt_align;
            put '>' nl;
            put '<embed height="100%" width="100%" name="SVGEmbed"';
            do /if any(outputheight, outputwidth);
                put ' style="';
                put "height:" OUTPUTHEIGHT ";" /if outputheight;
                put " width:" OUTPUTWIDTH ";" /if outputwidth;
                put '"';
            done;
            put ' src="';
            trigger mvs_link;
            unset $link;
            put ' type="image/svg+xml"';
            put ' pluginspage="http://www.adobe.com/svg/viewer/install/"></embed>';
            put "</div>" CR;
        end;


      define event image;
          unset $img_extension;
          set $img_extension reverse(url);
          set $img_extension scan($img_extension, '.', 1);
          set $img_extension reverse($img_extension);
          trigger embed_svg /breakif cmp($img_extension, 'SVG');

        put '<div';
        trigger alt_align;
        put ">" CR;
        put "<img";
        putq ' alt=' alt;
        put ' src=';
        trigger mvs_link;
        unset $link;
        put ' border="0"';
        put ' usemap="#' @CLIENTMAP;
        put ' usemap="#' NAME / if !exists(@CLIENTMAP);
        put '"' / if any(@CLIENTMAP , NAME);
        putq " class=" HTMLCLASS;
        putq " id=" HTMLID;
        put ">" CR;
        put '</div>' nl;
      end;

      define event content_frame;
        put '<frame marginwidth="4"';
        put ' marginheight="0"';
        put ' src=';
        trigger mvs_link;
        unset $link;
        put ' name="contents" scrolling=';
        putq "auto" / if !exists(CONTENTSCROLLBAR);
        putq CONTENTSCROLLBAR;
        put ' title="The Table of Contents"';
        put ">" CR;
      end;

      define event body_frame;
        set $link_attribute "src";
        put '<frame marginwidth="9"';
        put ' marginheight="0"';
        put ' src=';
        trigger mvs_link;
        unset $link;
        put ' name="body" scrolling=';
        putq "auto" / if !exists(BODYSCROLLBAR);
        putq BODYSCROLLBAR;
        put ' title="SAS Output"';
        put ">" CR;
      end;

      define event top_code;
        start:
          set $content_position "first" /if cmp(type, 'f');
          set $content_position "last" /if cmp(type, 'l');
          set $content_orientation "horizontal" /if cmp(colcount, '1');
          set $content_orientation "vertical" /if cmp(colcount, '2');

          put "<frameset frameborder=";

          put "YES"  / if !exists(FRAMEBORDER);
          put FRAMEBORDER;
          put " framespacing=";

          put '"3"'  / if !exists(FRAMESPACING);
          putq FRAMESPACING;

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

          /* create a frameset to hold the two contents files
          if they both exist. */
          trigger contents_pages_frameset start/ if cmp(type, "f");

        finish:
          put "</frameset>" nl;
          put "<noframes>" nl;
          put "<ul>" nl ;

          do /if any(contents_name,contents_url);
              put '<li><a href="';
              put basename "'";
              put path_url;
              put path_name /if ^path_url;
              put "(";
              put contents_url;
              put contents_name /if ^contents_url;
              put ")'" '"';
              put ">The Table of Contents</a></li>" nl;
          done;

          unset $link;
          do /if any(pages_name,pages_url);
              put '<li><a href="';
              put basename "'";
              put path_url;
              put path_name /if ^path_url;
              put "(";
              put pages_url;
              put pages_name /if ^pages_url;
              put ")'" '"';
              put ">The Table of Pages</a></li>" nl;
          done;

          put '<li><a href="';
          put basename "'";
          put path_url;
          put path_name /if ^path_url;
          put "(";
          put body_url;
          put body_name /if ^body_url;
          put ")'" '"';
          put ">The Contents</a></li>" nl;

          put "</ul>" nl ;
          put "</noframes>" nl;

          unset $link;
      end;

    end;
