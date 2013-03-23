
/*---------------------------------------------------------------eric-*/
/*-- This tagset expects two data sets to be run through proc print --*/
/*-- in succession.  The first dataset defines the information in   --*/
/*-- the first two group tags.  This is generic document            --*/
/*-- information that is best kept separate from the actual records --*/
/*-- of data.                                                       --*/
/*--                                                                --*/
/*-- The second data set is the actual items, sorted by group type. --*/
/*-- If using the libname engine, the dataset name that contains    --*/
/*-- the items should be called 'items', if not, see below.         --*/
/*--                                                                --*/
/*-- The items data set should be sorted in order of group_type.    --*/
/*--                                                                --*/
/*--                                                                --*/
/*-- The order of the columns is unimportant.  The tagset will find --*/
/*-- the values and use them according to their names.              --*/
/*--                                                                --*/
/*-- The names of the data columns should match those names listed  --*/
/*-- in the initialize event.  If they do not, the names can be     --*/
/*-- changed in the dataset, or here in these column events.        --*/
/*------------------------------------------------------------3Feb 04-*/
proc template;

define tagset tagsets.xbrl;
    indent=2;

    /*-----------------------------------------------------------eric-*/
    /*-- This first set of events exist primarily to allow easy     --*/
    /*-- creation of an xbrl tagset which can match datasets with   --*/
    /*-- other names, and column names than those initially defined --*/
    /*-- in this tagset.                                            --*/
    /*--                                                            --*/
    /*--                                                            --*/
    /*-- If the column names do not match the names listed in the   --*/
    /*-- columns events then define a new tagset which              --*/
    /*-- over-rides the necessary events with the new values.       --*/
    /*--                                                            --*/
    /*-- If using the libname engine it will also be necessary to   --*/
    /*-- over-ride the items_dataset_name event if the dataset name --*/
    /*-- for the items data is not named 'items'                    --*/
    /*-- If the name does not match, the libname engine output will --*/
    /*-- have extra closing </group> tags between the two datasets. --*/
    /*--                                                            --*/
    /*-- The column name definitions have been broken up into       --*/
    /*-- multiple events, this could help keep things simple if     --*/
    /*-- Some of the names actually match your dataset.             --*/
    /*--                                                            --*/
    /*--------------------------------------------------------4Feb 04-*/
    
    
    /*-----------------------------------------------------------eric-*/
    /*-- These first four events define                             --*/
    /*-- a dictionary that can be redefined if the data             --*/
    /*-- names don't match those that we are expecting.  Just       --*/
    /*-- change the value on the right to match your name.          --*/
    /*--------------------------------------------------------4Feb 04-*/
    define event report_columns;
        /*-------------------------------------------------------eric-*/
        /*-- These are the columns for the outermost group tags.    --*/
        /*-- report_type is the type of report.  Most of these      --*/
        /*-- only occur once, in the first dataset, as a definition --*/
        /*-- for the overall report. Group type is used in the      --*/
        /*-- outermost group tag and report type is used as the     --*/
        /*-- type on the secondary group tag which identifies the   --*/
        /*-- report type.  - cashflow, conditions, etc.             --*/
        /*----------------------------------------------------3Feb 04-*/
        set $names['report_type']          'report_type';
        set $names['group_schemaLocation'] 'group_schemaLocation';
        set $names['group_entity']         'group_entity';
        set $names['group_units']          'group_units';
        set $names['group_scaleFactor']    'group_scaleFactor';
        set $names['group_precision']      'group_precision';
        set $names['group_decimalPattern'] 'group_decimalPattern';
        set $names['group_formatName']     'group_formatName';
        /* Change These as needed ----------^^^^^^^^^^^^^^^^^^^^^ */
    end;
        
    define event group_columns;
        /*-------------------------------------------------------eric-*/
        /*-- group_type and group_id define each group.  The first  --*/
        /*-- dataset has both a report_type and a group_type, which --*/
        /*-- creates two group tags.                                --*/
        /*----------------------------------------------------3Feb 04-*/
        set $names['group_type']  'group_type';
        set $names['group_id']    'group_id';
        /* Change These as needed -^^^^^^^^^^ */
    end;
        
    define event label_columns;
        /*-------------------------------------------------------eric-*/
        /*-- Sub-groups generally only have a type, and this label information.--*/
        /*----------------------------------------------------3Feb 04-*/
        set $names['label']       'label';
        set $names['label_href']  'label_href';
        set $names['label_lang']  'label_lang';
        /* Change These as needed -^^^^^^^^^^^ */
    end;
    
    define event item_columns;
        /*-------------------------------------------------------eric-*/
        /*-- Items have a period and a value...                     --*/
        /*----------------------------------------------------3Feb 04-*/
        set $names['item']        'item';
        set $names['item_period'] 'item_period';
        /* Change These as needed -^^^^^^^^^^^^ */
    end;

    /*-----------------------------------------------------------eric-*/
    /*-- Set your name spaces here.  put name space urls in either  --*/
    /*-- the generic_name_spaces list or the prefixed_name_spaces   --*/
    /*-- dictionary.  The prefixed dictionary will produce an entry --*/
    /*-- based on the key and the value, where the key becomes a    --*/
    /*-- part of the attribute name like this: xlmns:key="value".   --*/
    /*-- Over-ride this event as needed.                            --*/
    /*--------------------------------------------------------4Feb 04-*/
    define event define_name_spaces;
        /* xlmns="http://www.xbrl.org/core/2000-07-31/instance" */
        set $generic_name_spaces[] "http://www.xbrl.org/core/2000-07-31/instance";

        /* xlmns:ci="http://www.xbrl.org/us/gaap/ci/2000-07-31" */
        set $prefixed_name_spaces['ci'] "http://www.xbrl.org/us/gaap/ci/2000-07-31";
    end;
        
    /*-----------------------------------------------------------eric-*/
    /*-- This is the name of the dataset which holds the items.     --*/
    /*--                                                            --*/
    /*-- This is only required if using the libname engine.         --*/
    /*-- Proc Print and ODS do not care about this.                 --*/
    /*--                                                            --*/
    /*-- The easiest way to change these is by creating a new       --*/
    /*-- tagset which over-rides this event.                        --*/
    /*--------------------------------------------------------4Feb 04-*/
    define event items_dataset_name;
        set $Items_data           'Items';
    end;
    
    
    /*-----------------------------------------------------------eric-*/
    /*----------------------------------------------------------------*/
    /*----------------------------------------------------------------*/
    /*-- END OF EVENTS WHICH MAY NEED TO BE OVER-RIDDEN             --*/
    /*----------------------------------------------------------------*/
    /*----------------------------------------------------------------*/
    /*--------------------------------------------------------4Feb 04-*/
    

    /*-----------------------------------------------------------eric-*/
    /*-- The initialize event is called once when the               --*/
    /*-- tagset/document is opened.  It is not currently            --*/
    /*-- called by the libname engine.                              --*/
    /*--                                                            --*/
    /*-- To keep things simple, we just use a different name.       --*/
    /*-- at some point it might be nice to change it back to        --*/
    /*-- initialize.  But we'll have to wait until the libname      --*/
    /*-- engine calls it too.                                       --*/
    /*--------------------------------------------------------5Feb 04-*/
    /*define event initialize;   */
    define event initialize_lookups;   
        trigger column_names;    
        trigger items_dataset_name;
        trigger define_name_spaces;

        set $TableName $Items_data;
    end;

    define event column_names;
        trigger report_columns;
        trigger group_columns;
        trigger label_columns;
        trigger item_columns;
    end;
    

    /*-----------------------------------------------------------eric-*/
    /*-- If a options are given on the ods statement then those     --*/
    /*-- options are assumed to be column names.  The name/key      --*/
    /*-- should match the keys used in the ????_columns events.     --*/
    /*--                                                            --*/
    /*-- This allows column names to be changed without creating    --*/
    /*-- a new tagset.                                              --*/
    /*--------------------------------------------------------5Feb 04-*/
    define event set_column_names;
        break /if ^$options;
        iterate $options;
        do /while _name_;
            set $names[_name_] _value_;
            next $options;
        done;
    end;

    
    /*-----------------------------------------------------------eric-*/
    /*-- Write out the name_spaces list and dictionary.             --*/
    /*--------------------------------------------------------4Feb 04-*/
    define event write_name_spaces;
        putvars $generic_name_spaces  nl 'xmlns="' _value_ '"'; 
        putvars $prefixed_name_spaces nl 'xmlns:'  _name_  '="' _value_ '"'; 
    end;    
    

    define event doc;
        start:
           /* libname engine does not call the ODS initialize event */
           trigger initialize_lookups;
        finish:
           break / if ^cmp($TableName, $Items_data);
           trigger group finish;
           trigger report finish;
    end;
    

    /*-----------------------------------------------------------eric-*/
    /*-- A new dataset.  reset everything.                          --*/
    /*--------------------------------------------------------3Feb 04-*/
    define event table;
        unset $cols;
        unset $col_index;
        unset $lastgroup;
        eval  $index 1;

        /*-------------------------------------------------------eric-*/
        /*-- Keep track of the table name for the libname engine.   --*/
        /*-- If it's not Item, then we don't want to close up the   --*/
        /*-- document.  Name isn't set for proc print, so the       --*/
        /*-- default setting of items will make it past this when   --*/
        /*-- ods is being used.                                     --*/
        /*----------------------------------------------------4Feb 04-*/
        set   $TableName name / if name; 
    end;
    


    /*-----------------------------------------------------------eric-*/
    /*-- Build a list of column names.  It'll be used               --*/
    /*-- for indexing later.  1-n columns.                          --*/
    /*--------------------------------------------------------4Feb 04-*/
    define event colspec_entry;
        set $col_index[] name;
    end;


    /*-----------------------------------------------------------eric-*/
    /*-- This is where all the work happens.  If this is the head   --*/
    /*-- section of the table - do nothing.                         --*/
    /*--                                                            --*/
    /*-- If report_type is populated then this is the only          --*/
    /*-- observation in the first dataset.  So we write the first   --*/
    /*-- and second group tags with the report event.               --*/
    /*--                                                            --*/
    /*-- Otherwise this is an observation in the second dataset.    --*/
    /*-- If the group has changed, then close the old group and     --*/
    /*-- start a new one with the group_type from the current       --*/
    /*-- observation.                                               --*/
    /*--                                                            --*/
    /*-- Last we write out the item.                                --*/
    /*--                                                            --*/
    /*-- save the group_type and reset our values dictionary.       --*/
    /*--------------------------------------------------------3Feb 04-*/
    define event row;
        start:
            eval $index 1;
        finish:
            break /if cmp(section, 'head');

            /*---------------------------------------------------eric-*/
            /*-- If there is a report_type then this is the first   --*/
            /*-- piece of data that defines the document.           --*/
            /*--                                                    --*/
            /*-- Otherwise, if the lastgroup is different from the  --*/
            /*-- current group this observation is the beginning of --*/
            /*-- a new group.                                       --*/
            /*------------------------------------------------4Feb 04-*/
            do /if $cols[$names['report_type']];
                trigger report start;
            else;
                do /if ^cmp($lastgroup, $cols[$names['group_type']]);
                    trigger group finish /if $lastgroup;
                    trigger group start;
                done;
            done;

            /*---------------------------------------------------eric-*/
            /*-- Write out the item for this observation.  The      --*/
            /*-- document defining observation doesn't have an item.--*/
            /*------------------------------------------------4Feb 04-*/
            trigger item;
            set $lastgroup $cols[$names['group_type']];
            unset $cols;
    end;

        
    /* for proc print's obs column */
    define event header;
        break /if cmp(section, 'head');
        trigger data;
    end;
    
    
    /*-----------------------------------------------------------eric-*/
    /*-- Put the value in the dictionary for later use.             --*/
    /*--------------------------------------------------------3Feb 04-*/
    define event data;
        break /if cmp(section, 'head');

        /*-------------------------------------------------------eric-*/
        /*-- There has to be something in the list, otherwise       --*/
        /*-- everything will get out of sync.                       --*/
        /*----------------------------------------------------4Feb 04-*/
        set $name $col_index[$index];
        
        do /if value;
            set $cols[$name] value;
        else;
            set $cols[$name] ' ';
        done;
        eval $index $index+1;
    end;

    /*-----------------------------------------------------------eric-*/
    /*-- Write the initial two group tags from the report_type and  --*/
    /*-- group type in the first and only observation from the      --*/
    /*-- first data set.                                            --*/
    /*--------------------------------------------------------3Feb 04-*/
    define event report;
        start:
            put  '<?xml version="1.0"';
            putq ' encoding=' ENCODING;
            put  ' ?>' nl;
            
            put '<group';

            /*---------------------------------------------------eric-*/
            /*-- This is a pain.  But we want empty attributes to   --*/
            /*-- show as "" instead of not being present at all.    --*/
            /*------------------------------------------------4Feb 04-*/
            put ' type="'           ; 
            put strip($cols[$names['group_type']]) '"' ;
                                       
            put ' id="'             ; 
            put strip($cols[$names['group_id']]) '"' ;

            put ' entity="'; 
            put strip($cols[$names['group_entity']]) '"' ;
            
            put ' units="'; 
            put strip($cols[$names['group_units']]) '"' ;

            put ' scaleFactor="'; 
            put strip($cols[$names['group_scaleFactor']]) '"' ;

            put ' precision="'; 
            put strip($cols[$names['group_precision']]) '"' ;

            put ' decimalPattern="'; 
            put strip($cols[$names['group_decimalPattern']]) '"' ;

            put ' formatName="';
            put strip($cols[$names['group_formatName']]) '"' ;
                                       
            put nl 'SchemaLocation="' ; 
            put strip($cols[$names['group_schemaLocation']]) '"';
            
            /*---------------------------------------------------eric-*/
            /*-- Write out the xlmns attributes if we have some.    --*/
            /*------------------------------------------------4Feb 04-*/
            trigger write_name_spaces;

            put '>' nl;
            ndent;

            put '<group';
            putq ' type=' $cols[$names['report_type']];
            put '>' nl;
            ndent;

            /*<label href="xpointer(..)" xml:lang="en">Net income</label>*/
            break /if ^$cols[$names['label']];
            put '<label';
            putq ' href=' $cols[$names['label_href']];
            putq ' xml:lang=' $cols[$names['label_lang']];
            put  '>';
            put  $cols[$names['label']];
            put '</label>' nl;

        finish:
            xdent;
            put '</group>' nl;
            xdent;
            put '</group>' nl;
    end;


    /*-----------------------------------------------------------eric-*/
    /*-- Write a group tag.  This is triggered when the group       --*/
    /*-- changes from one observation to the next.                  --*/
    /*--------------------------------------------------------3Feb 04-*/
    define event group;
        start:
            put '<group';
            putq ' type=' $cols[$names['group_type']];
            put '>' nl;
            ndent;

            /*<label href="xpointer(..)" xml:lang="en">Net income</label>*/
            break /if ^$cols[$names['label']];
            put '<label';
            putq ' href=' $cols[$names['label_href']];
            putq ' xml:lang=' $cols[$names['label_lang']];
            put  '>';
            put  $cols[$names['label']];
            put '</label>' nl;

        finish:
            xdent;
            put '</group>' nl;
    end;
    
    
    /*-----------------------------------------------------------eric-*/
    /*-- Write out the item.  All observations in the second data   --*/
    /*-- set are items.                                             --*/
    /*--------------------------------------------------------3Feb 04-*/
    define event item;
        break /if ^$cols[$names['item_period']];

        /*<item period="P1Y/1999-12-31">7712</item>*/
        put '<item';
        putq ' period=' $cols[$names['item_period']];
        put '>';
        put strip($cols[$names['item']]);
        put '</item>' nl;
    end;
    
end;

run;
