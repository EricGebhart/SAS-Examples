
ods path sasuser.templat(write) sashelp.tmplmst(read);

proc template;

  define tagset tagsets.frame;
    parent=tagsets.html4;

        define event split_frame;
            put '<frame marginwidth="9" marginheight="0"';
            putq " src=" URL;
            put ' name="body" scrolling=';
            put "auto"  / if !exists(BODYSCROLLBAR);
            put BODYSCROLLBAR;
            putq " title=" body_title;
            putq ' title="The SAS Output"' /if !exists(body_title);
            put ">" CR;
        end;

        define event split_data;
            put '<frame marginwidth="9" marginheight="0"';
            putq " src=" data_name;
            put ' name="data" scrolling=';
            put "auto"  / if !exists(BODYSCROLLBAR);
            put BODYSCROLLBAR;
            putq " title=" data_title;
            putq ' title="The SAS Output"' /if !exists(data_title);
            put ">" CR;
        end;

        define event data_body;
           put "<html>" NL;
           put "<body>" NL;
           put "<h3> hello </h3>" NL;
           put "</body>" NL;
           put "</html>" NL;
        end;

        define event body_frame;
           trigger split_frameset;
           trigger split_frame;
           trigger split_data;
           trigger split_frameset finish;
        end;

        define event split_frameset;
           start:

                /* modified frame for defect S0076945 */
            
                put "<frameset frameborder=";

                put "YES"  / if !exists(FRAMEBORDER);
                put FRAMEBORDER;
                put " framespacing=";

                put '"3"'  / if !exists(FRAMESPACING);
                putq FRAMESPACING;
                put ' rows="50%,*">' NL;
           finish:
                put "</frameset>" NL;
        end;

    end;
  run;



 ods tagsets.frame file='kim.htm' contents='kimc.htm' frame='kimf.htm'
        data='kimd.htm' stylesheet='kim.css';

 proc print data=sashelp.class(obs=5);
 run;


 ods _all_ close;


