
proc temlplate;

   define tagset tagsets.gtable;

      parent=tagsets.html4;

      define event view_table;
         start:
           open view;
           put "<View>" nl;
           put "<Table";
           putq ' data=' anchor;
           trigger inline_style;
           put '>' nl;
           close;
           put '<Data>' nl;
           ndent;
         finish:
           xdent;
           put '</Data>' nl;
           open view;
           put "</Table>" nl;
           put "</View>" nl;
           flush;
           close;
      end;

      define event table;
         start:
           trigger view_table;
           put "<IQData" ;
           putq ' name=' anchor ' type="2DEmbedded">' nl;
           ndent;
           put "<EmbeddedData>" nl;
           ndent;
         finish:
           xdent;
           put "</EmbeddedData>" nl;
           xdent;
           put "</IQData>" nl;
           trigger view_table;
      end;

      define event row;
         start:
            put '<Values>' nl;
            ndent;
         finish:
            xdent;
            put '</Values>' nl;
      end;

      define event header;
         start:
            trigger data;
         finish:
            trigger data;
      end;

      define event data;
         start:
            put '<Value';
            put ' /' / if exists(empty);
            put '>';
            put nl / if exists(empty);
            break / if exists(empty);
            put value;
         finish:
            break / if exists(empty);
            put '</Value>' nl;
      end;

      define event table_body;
         start:
            put '<ValuesList';
            putq ' valuesCount=' $valuecount;
            put '>' nl;
            ndent;
         finish:
            xdent;
            put '</ValuesList>' nl;
      end;


      define event colspecs;
         start:
           trigger view_columns;
           put "<Variables> " nl;
           set $valuecount colcount;
         finish:
           trigger view_columns;
           put "</Variables> " nl;
      end;

      define event view_columns;
         start:
           open view;
           put "<Columns> " nl;
           ndent;
           close;
         finish:
           open view;
           xdent;
           put "</Columns> " nl;
           close;
      end;

      define event colspec_entry;
        start:
           put '<Variable';
           putq ' label=' value;
           put  ' encoding="Text"';
           putq ' type=';
           put '"Numeric"' /if cmp(type, "double");
           put '"Numeric"' /if cmp(type, "int");
           put '"Numeric"' /if cmp(type, "bool");
           put '"String"' /if cmp(type, "char");
           put '"String"' /if cmp(type, "string");
           put '"String"' /if cmp(type, "unknown");
           put  ' name="var' col_id '">' nl;
           /*putq ' name=' name;*/
           trigger view_column;
        finish:
           put '</Variable>' nl;
           trigger view_column;
      end;

      define event span_group;
        start:
           open view;
           put '<LabelGroup';
           put ' isStacked="true"' /if exists(is_stacked);
           put '>' nl;
           ndent;
           put  '<MyLabel';
           put  ' isVisible="false"' /if !exists(value);
           trigger stylename;
           trigger text_align;
           put '>';
           put value;
           put '</Label>' nl;
           close;
        finish:
           open view;
           xdent;
           put '</LabelGroup>' nl;
           close;
      end;

      define event span_header_colspec;
        start:
           open view;
           put  '<Value';
           put  ' member="var' col_id '">' nl;
           close;
        finish:
           open view;
           put '</Value>' nl;
           close;
      end;

      define event view_column;
        start:
           open view;
           put '<Column';
           trigger stylename;
           trigger text_align;
           /*putq ' Name=' name;*/
           put ' variable="var' col_id '"';
           put  '>' nl;
           ndent;
           close;
        finish:
           open view;
           xdent;
           put '</Column>' nl;
           close;
      end;

      define event sub_colspec_header;
        start:
           open view;
           put  '<Label';
           put  ' isVisible="false"' /if !exists(value);
           trigger stylename;
           trigger text_align;
           put '>';
           put value;
           close;
        finish:
           open view;
           put '</Label>' nl;
           close;
      end;

      define event table_head;
         start:
            block data;
            block row;
            block header;
         finish:
            unblock data;
            unblock row;
            unblock header;
      end;
   end;
run;

