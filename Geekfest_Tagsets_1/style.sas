/*************************************************************************************/
/* This is approximate proc template code for an ods style.                          */
/* It is a flattened representation of the style chosen on the ods markup            */
/* statement.  There is no inheritance, no list elements.  Everything is             */
/* repeated as necessary.  Verbose, repetitive and simple...                         */
/* there are a few known errors with it.                                             */
/* 1. The quoting isn't too smart so anything that has ' in it might cause problems  */
/* 2. I don't know the style name so I can't give it a proper name.                  */
/*************************************************************************************/

proc template;
    define style styles.mystyle;
        style ContentTitle/
            PreText = "Table of Contents"
            PreHTML = '<SPAN onClick="if(msie4==1)expandAll()">'
            PostHTML = '</SPAN><HR size="3">'
            Background = #B0B0B0
            Foreground = #002288
            ContentPosition = left
            Font = ("Verdana, Helvetica, Helv", 3, normal italic)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style Output/
            Frame = BOX
            Rules = GROUPS
            Borderwidth = 1px
            CellSpacing = 1
            CellPadding = 7
            Background = #F0F0F0
            Foreground = #002288
            BorderColor = #000000
            ContentPosition = left
            Font = ("Verdana, Helvetica, Helv", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style HeaderEmphasis/
            Background = #B0B0B0
            Foreground = #0033AA
            ContentPosition = left
            Font = ("Verdana, Helvetica, Helv", 3, normal italic)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style NoteContent/
            Background = #E0E0E0
            Foreground = #002288
            ContentPosition = left
            Font = ("Verdana, Helvetica, Helv", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style DropShadowStyle/
            Foreground = #000000
            ContentPosition = left
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style FatalContent/
            Background = #E0E0E0
            Foreground = #002288
            ContentPosition = left
            Font = ("Verdana, Helvetica, Helv", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style Graph/
            Frame = BOX
            Rules = GROUPS
            Borderwidth = 1px
            CellSpacing = 0
            CellPadding = 0
            Background = #E0E0E0
            Foreground = #002288
            BorderColor = #000000
            ContentPosition = left
            Font = ("Verdana, Helvetica, Helv", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style WarnContentFixed/
            Background = #E0E0E0
            Foreground = #002288
            ContentPosition = left
            Font = ("Courier", 2, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style NoteBanner/
            PreText = "NOTE:"
            Background = #E0E0E0
            Foreground = #002288
            ContentPosition = left
            Font = ("Verdana, Helvetica, Helv", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style GraphLegendBackground/
            Background = #FFFFFF
            ContentPosition = left
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style DataStrong/
            Background = #D3D3D3
            Foreground = #000000
            ContentPosition = left
            Font = ("Verdana, Helvetica, Helv", 4, bold normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style Document/
            HTMLContentType = "text/html"
            HTMLDocType = '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">'
            LinkColor = #0066AA
            VisitedLinkColor = #004488
            Background = #E0E0E0
            Foreground = #002288
            ContentPosition = left
            Font = ("Verdana, Helvetica, Helv", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
            ProtectSpecialChars = auto
        ;

        style GraphLabelText/
            Foreground = #000000
            ContentPosition = left
            Font = ("Verdana", 12pt, bold normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style BeforeCaption/
            CellSpacing = 0
            CellPadding = 0
            Background = #E0E0E0
            Foreground = #000000
            ContentPosition = left
            Font = ("Verdana, Helvetica, Helv", 4, bold normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style ContentsDate/
            OutputWidth = 100%
            Background = #B0B0B0
            Foreground = #0033AA
            ContentPosition = left
            Font = ("Verdana, Helvetica, Helv", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style Pages/
            PageBreakHTML = '<br>'
            HTMLContentType = "text/html"
            HTMLDocType = '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">'
            Bullet = decimal
            TagAttr = ' onload="if (msie4 == 1)expandAll()"'
            LeftMargin = 8px
            RightMargin = 8px
            LinkColor = #0066AA
            VisitedLinkColor = #004488
            Background = #B0B0B0
            Foreground = #0033AA
            ContentPosition = left
            Font = ("Verdana, Helvetica, Helv", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
            ProtectSpecialChars = auto
        ;

        style TitlesAndFooters/
            Background = #E0E0E0
            Foreground = #002288
            ContentPosition = left
            Font = ("Verdana, Helvetica, Helv", 4, bold italic)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style IndexProcName/
            PreText = "The "
            PostText = " Procedure"
            PreHTML = '<SPAN>'
            PostHTML = '</SPAN>'
            Bullet = decimal
            Background = #B0B0B0
            Foreground = #002288
            ContentPosition = left
            Font = ("Verdana, Helvetica, Helv", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style ProcTitle/
            Background = #E0E0E0
            Foreground = #002288
            ContentPosition = left
            Font = ("Verdana, Helvetica, Helv", 4, bold italic)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style IndexAction/
            Background = #B0B0B0
            Foreground = #0033AA
            ContentPosition = left
            Font = ("Verdana, Helvetica, Helv", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style Data/
            Background = #D3D3D3
            Foreground = #000000
            ContentPosition = left
            Font = ("Verdana, Helvetica, Helv", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style GraphValueText/
            Foreground = #000000
            ContentPosition = left
            Font = ("Verdana", 10pt, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style GraphBorderLines/
            Foreground = #000000
            ContentPosition = left
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style Table/
            Frame = BOX
            Rules = GROUPS
            Borderwidth = 1px
            CellSpacing = 1
            CellPadding = 7
            Background = #F0F0F0
            Foreground = #002288
            BorderColor = #000000
            ContentPosition = left
            Font = ("Verdana, Helvetica, Helv", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style FooterEmpty/
            Background = #B0B0B0
            Foreground = #0033AA
            ContentPosition = left
            Font = ("Verdana, Helvetica, Helv", 4, bold normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style SysTitleAndFooterContainer/
            Frame = VOID
            Rules = NONE
            Borderwidth = 0
            CellSpacing = 1
            CellPadding = 1
            OutputWidth = 100%
            Background = #E0E0E0
            Foreground = #002288
            ContentPosition = left
            Font = ("Verdana, Helvetica, Helv", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style GraphAxisLines/
            Foreground = #000000
            ContentPosition = left
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style RowFooterEmpty/
            Background = #B0B0B0
            Foreground = #0033AA
            ContentPosition = left
            Font = ("Verdana, Helvetica, Helv", 4, bold normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style ExtendedPage/
            PreText = "Continuing contents of page "
            PostText = ", which would not fit on a single physical page"
            Frame = box
            Borderwidth = 1pt
            CellPadding = 2pt
            Background = #E0E0E0
            Foreground = #002288
            Just = c
            ContentPosition = left
            Font = ("Verdana, Helvetica, Helv", 3, normal italic)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style GraphWalls/
            Background = #FFFFFF
            ContentPosition = left
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style FooterFixed/
            Background = #B0B0B0
            Foreground = #0033AA
            ContentPosition = left
            Font = ("Courier", 2, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style RowFooterStrongFixed/
            Background = #B0B0B0
            Foreground = #0033AA
            ContentPosition = left
            Font = ("Courier", 2, bold normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style RowFooterEmphasis/
            Background = #B0B0B0
            Foreground = #0033AA
            ContentPosition = left
            Font = ("Verdana, Helvetica, Helv", 3, normal italic)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style ContentFolder/
            PreHTML = '<SPAN><b>&#183;</b>'
            PostHTML = '</SPAN>'
            Bullet = NONE
            LeftMargin = 6pt
            Background = #B0B0B0
            Foreground = #002288
            ContentPosition = left
            Font = ("Verdana, Helvetica, Helv", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style Container/
            Background = #E0E0E0
            Foreground = #002288
            ContentPosition = left
            Font = ("Verdana, Helvetica, Helv", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style Date/
            OutputWidth = 100%
            Background = #B0B0B0
            Foreground = #0033AA
            ContentPosition = left
            Font = ("Verdana, Helvetica, Helv", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style RowFooterFixed/
            Background = #B0B0B0
            Foreground = #0033AA
            ContentPosition = left
            Font = ("Courier", 2, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style Caption/
            CellSpacing = 0
            CellPadding = 0
            Background = #E0E0E0
            Foreground = #000000
            ContentPosition = left
            Font = ("Verdana, Helvetica, Helv", 4, bold normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style WarnBanner/
            PreText = "WARNING:"
            Background = #E0E0E0
            Foreground = #002288
            ContentPosition = left
            Font = ("Verdana, Helvetica, Helv", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style Frame/
            HTMLContentType = "text/html"
            HTMLDocType = '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">'
            FrameBorderWidth = 4px
            FrameSpacing = 1px
            ContentSize = 23%
            BodySize = *
            LinkColor = #0066AA
            VisitedLinkColor = #004488
            Background = #E0E0E0
            Foreground = #002288
            ContentPosition = left
            Font = ("Verdana, Helvetica, Helv", 3, normal normal)
            FrameBorder = yes
            ContentScrollbar = auto
            BodyScrollbar = auto
            ProtectSpecialChars = auto
        ;

        style HeaderStrongFixed/
            Background = #B0B0B0
            Foreground = #0033AA
            ContentPosition = left
            Font = ("Courier", 2, bold normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style IndexTitle/
            PreHTML = '<SPAN onClick="if(msie4==1)expandAll()">'
            PostHTML = '</SPAN><HR size="3">'
            Background = #B0B0B0
            Foreground = #002288
            ContentPosition = left
            Font = ("Verdana, Helvetica, Helv", 3, normal italic)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style NoteContentFixed/
            Background = #E0E0E0
            Foreground = #002288
            ContentPosition = left
            Font = ("Courier", 2, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style DataEmphasisFixed/
            Background = #D3D3D3
            Foreground = #000000
            ContentPosition = left
            Font = ("Courier", 2, normal italic)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style Note/
            Background = #E0E0E0
            Foreground = #002288
            ContentPosition = left
            Font = ("Verdana, Helvetica, Helv", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style Byline/
            CellSpacing = 0
            CellPadding = 0
            Background = #B0B0B0
            Foreground = #0033AA
            ContentPosition = left
            Font = ("Verdana, Helvetica, Helv", 4, bold normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style FatalBanner/
            PreText = "FATAL:"
            Background = #E0E0E0
            Foreground = #002288
            ContentPosition = left
            Font = ("Verdana, Helvetica, Helv", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style ProcTitleFixed/
            Background = #E0E0E0
            Foreground = #002288
            ContentPosition = left
            Font = ("Courier", 2, bold normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style ByContentFolder/
            PreHTML = '<SPAN><b>&#183;</b>'
            PostHTML = '</SPAN>'
            Bullet = NONE
            LeftMargin = 6pt
            Background = #B0B0B0
            Foreground = #002288
            ContentPosition = left
            Font = ("Verdana, Helvetica, Helv", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style PagesProcLabel/
            PreHTML = '<SPAN>'
            PostHTML = '</SPAN>'
            Bullet = decimal
            Background = #B0B0B0
            Foreground = #002288
            ContentPosition = left
            Font = ("Verdana, Helvetica, Helv", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style LayoutRegion/
            Frame = void
            Rules = none
            Borderwidth = 0
            CellSpacing = 30
            ContentPosition = left
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style GraphData8/
            Foreground = #D6C66E
            ContentPosition = left
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style GraphData9/
            Foreground = #5E528B
            ContentPosition = left
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style RowHeaderFixed/
            Background = #B0B0B0
            Foreground = #0033AA
            ContentPosition = left
            Font = ("Courier", 2, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style RowFooterEmphasisFixed/
            Background = #B0B0B0
            Foreground = #0033AA
            ContentPosition = left
            Font = ("Courier", 2, normal italic)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style WarnContent/
            Background = #E0E0E0
            Foreground = #002288
            ContentPosition = left
            Font = ("Verdana, Helvetica, Helv", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style DataEmpty/
            Background = #D3D3D3
            Foreground = #000000
            ContentPosition = left
            Font = ("Verdana, Helvetica, Helv", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style Cell/
            Background = #E0E0E0
            Foreground = #002288
            ContentPosition = left
            Font = ("Verdana, Helvetica, Helv", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style Header/
            Background = #B0B0B0
            Foreground = #0033AA
            ContentPosition = left
            Font = ("Verdana, Helvetica, Helv", 4, bold normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style PageNo/
            CellSpacing = 0
            CellPadding = 0
            Background = #E0E0E0
            Foreground = #002288
            ContentPosition = left
            Font = ("Verdana, Helvetica, Helv", 4, bold normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style ContentProcLabel/
            PreHTML = '<SPAN>'
            PostHTML = '</SPAN>'
            Bullet = decimal
            Background = #B0B0B0
            Foreground = #002288
            ContentPosition = left
            Font = ("Verdana, Helvetica, Helv", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style HeaderFixed/
            Background = #B0B0B0
            Foreground = #0033AA
            ContentPosition = left
            Font = ("Courier", 2, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style PagesTitle/
            PreText = "Table of Pages"
            PreHTML = '<SPAN onClick="if(msie4==1)expandAll()">'
            PostHTML = '</SPAN><HR size="3">'
            Background = #B0B0B0
            Foreground = #002288
            ContentPosition = left
            Font = ("Verdana, Helvetica, Helv", 3, normal italic)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style RowHeaderEmpty/
            Background = #B0B0B0
            Foreground = #0033AA
            ContentPosition = left
            Font = ("Verdana, Helvetica, Helv", 4, bold normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style PagesProcName/
            PreText = "The "
            PostText = " Procedure"
            PreHTML = '<SPAN>'
            PostHTML = '</SPAN>'
            Bullet = decimal
            Background = #B0B0B0
            Foreground = #002288
            ContentPosition = left
            Font = ("Verdana, Helvetica, Helv", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style Batch/
            Frame = BOX
            Rules = GROUPS
            Borderwidth = 1px
            CellSpacing = 1
            CellPadding = 7
            Background = #D3D3D3
            Foreground = #000000
            BorderColor = #000000
            ContentPosition = left
            Font = ("SAS Monospace, Courier", 2, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style ContentItem/
            PreHTML = '<SPAN><b>&#183;</b>'
            PostHTML = '</SPAN>'
            Bullet = NONE
            LeftMargin = 6pt
            Background = #B0B0B0
            Foreground = #002288
            ContentPosition = left
            Font = ("Verdana, Helvetica, Helv", 3, normal normal)
            ListEntryAnchor = yes
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style Body/
            PageBreakHTML = '<p style="page-break-after: always;">&#160</p><HR size="3">'
            HTMLContentType = "text/html"
            HTMLDocType = '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">'
            LeftMargin = 8px
            RightMargin = 8px
            LinkColor = #0066AA
            VisitedLinkColor = #004488
            Background = #E0E0E0
            Foreground = #002288
            ContentPosition = left
            Font = ("Verdana, Helvetica, Helv", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
            ProtectSpecialChars = auto
        ;

        style PagesDate/
            OutputWidth = 100%
            Background = #B0B0B0
            Foreground = #0033AA
            ContentPosition = left
            Font = ("Verdana, Helvetica, Helv", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style Index/
            Background = #B0B0B0
            Foreground = #0033AA
            ContentPosition = left
            Font = ("Verdana, Helvetica, Helv", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style HeaderEmpty/
            Background = #B0B0B0
            Foreground = #0033AA
            ContentPosition = left
            Font = ("Verdana, Helvetica, Helv", 4, bold normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style GraphData1/
            Foreground = #6173A9
            ContentPosition = left
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style FooterStrong/
            Background = #B0B0B0
            Foreground = #0033AA
            ContentPosition = left
            Font = ("Verdana, Helvetica, Helv", 4, bold normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style FooterEmphasis/
            Background = #B0B0B0
            Foreground = #0033AA
            ContentPosition = left
            Font = ("Verdana, Helvetica, Helv", 3, normal italic)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style ErrorContent/
            Background = #E0E0E0
            Foreground = #002288
            ContentPosition = left
            Font = ("Verdana, Helvetica, Helv", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style DataFixed/
            Background = #D3D3D3
            Foreground = #000000
            ContentPosition = left
            Font = ("Courier", 2, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style GraphData3/
            Foreground = #98341C
            ContentPosition = left
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style HeaderStrong/
            Background = #B0B0B0
            Foreground = #0033AA
            ContentPosition = left
            Font = ("Verdana, Helvetica, Helv", 4, bold normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style GraphBackground/
            Background = #E0E0E0
            ContentPosition = left
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style DataEmphasis/
            Background = #D3D3D3
            Foreground = #000000
            ContentPosition = left
            Font = ("Verdana, Helvetica, Helv", 3, normal italic)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style GraphData2/
            Foreground = #8DA642
            ContentPosition = left
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style TitleAndNoteContainer/
            Frame = VOID
            Rules = NONE
            Borderwidth = 0
            CellSpacing = 1
            CellPadding = 1
            OutputWidth = 100%
            Background = #E0E0E0
            Foreground = #002288
            ContentPosition = left
            Font = ("Verdana, Helvetica, Helv", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style RowFooter/
            Background = #B0B0B0
            Foreground = #0033AA
            ContentPosition = left
            Font = ("Verdana, Helvetica, Helv", 4, bold normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style IndexItem/
            PreHTML = '<SPAN><b>&#183;</b>'
            PostHTML = '</SPAN>'
            Bullet = NONE
            LeftMargin = 6pt
            Background = #B0B0B0
            Foreground = #002288
            ContentPosition = left
            Font = ("Verdana, Helvetica, Helv", 3, normal normal)
            ListEntryAnchor = yes
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style BylineContainer/
            Frame = VOID
            Rules = NONE
            Borderwidth = 0
            CellSpacing = 1
            CellPadding = 1
            OutputWidth = 100%
            Background = #E0E0E0
            Foreground = #002288
            ContentPosition = left
            Font = ("Verdana, Helvetica, Helv", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style GraphData11/
            Foreground = #C8573C
            ContentPosition = left
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style GraphData5/
            Foreground = #8AA4C9
            ContentPosition = left
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style FatalContentFixed/
            Background = #E0E0E0
            Foreground = #002288
            ContentPosition = left
            Font = ("Courier", 2, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style GraphFloor/
            Background = #FFFFFF
            ContentPosition = left
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style GraphData10/
            Foreground = #679920
            ContentPosition = left
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style GraphData4/
            Foreground = #FDC861
            ContentPosition = left
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style BodyDate/
            CellSpacing = 0
            CellPadding = 0
            OutputWidth = 100%
            Background = #E0E0E0
            Foreground = #002288
            Just = r
            ContentPosition = left
            Font = ("Verdana, Helvetica, Helv", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style GraphData7/
            Foreground = #B87F32
            ContentPosition = left
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style GraphData12/
            Foreground = #7F5934
            ContentPosition = left
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style GraphData6/
            Foreground = #6F7500
            ContentPosition = left
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style RowFooterStrong/
            Background = #B0B0B0
            Foreground = #0033AA
            ContentPosition = left
            Font = ("Verdana, Helvetica, Helv", 4, bold normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style UserText/
            Background = #E0E0E0
            Foreground = #002288
            ContentPosition = left
            Font = ("Verdana, Helvetica, Helv", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style HeadersAndFooters/
            Background = #B0B0B0
            Foreground = #0033AA
            ContentPosition = left
            Font = ("Verdana, Helvetica, Helv", 4, bold normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style RowHeaderEmphasisFixed/
            Background = #B0B0B0
            Foreground = #0033AA
            ContentPosition = left
            Font = ("Courier", 2, normal italic)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style ErrorBanner/
            PreText = "ERROR:"
            Background = #E0E0E0
            Foreground = #002288
            ContentPosition = left
            Font = ("Verdana, Helvetica, Helv", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style ContentProcName/
            PreText = "The "
            PostText = " Procedure"
            PreHTML = '<SPAN>'
            PostHTML = '</SPAN>'
            Bullet = decimal
            Background = #B0B0B0
            Foreground = #002288
            ContentPosition = left
            Font = ("Verdana, Helvetica, Helv", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style RowHeaderStrong/
            Background = #B0B0B0
            Foreground = #0033AA
            ContentPosition = left
            Font = ("Verdana, Helvetica, Helv", 4, bold normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style FooterEmphasisFixed/
            Background = #B0B0B0
            Foreground = #0033AA
            ContentPosition = left
            Font = ("Courier", 2, normal italic)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style Contents/
            PageBreakHTML = '<br>'
            HTMLContentType = "text/html"
            HTMLDocType = '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">'
            Bullet = decimal
            TagAttr = ' onload="if (msie4 == 1)expandAll()"'
            LeftMargin = 8px
            RightMargin = 8px
            LinkColor = #0066AA
            VisitedLinkColor = #004488
            Background = #B0B0B0
            Foreground = #0033AA
            ContentPosition = left
            Font = ("Verdana, Helvetica, Helv", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
            ProtectSpecialChars = auto
        ;

        style FooterStrongFixed/
            Background = #B0B0B0
            Foreground = #0033AA
            ContentPosition = left
            Font = ("Courier", 2, bold normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style PagesItem/
            PreHTML = '<SPAN><b>&#183;</b>'
            PostHTML = '</SPAN>'
            Bullet = NONE
            LeftMargin = 6pt
            Background = #B0B0B0
            Foreground = #002288
            ContentPosition = left
            Font = ("Verdana, Helvetica, Helv", 3, normal normal)
            ListEntryAnchor = yes
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style RowHeader/
            Background = #B0B0B0
            Foreground = #0033AA
            ContentPosition = left
            Font = ("Verdana, Helvetica, Helv", 4, bold normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style GraphOutlines/
            Foreground = #000000
            ContentPosition = left
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style AfterCaption/
            CellSpacing = 0
            CellPadding = 0
            Background = #E0E0E0
            Foreground = #000000
            ContentPosition = left
            Font = ("Verdana, Helvetica, Helv", 4, bold normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style RowHeaderStrongFixed/
            Background = #B0B0B0
            Foreground = #0033AA
            ContentPosition = left
            Font = ("Courier", 2, bold normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style GraphTitleText/
            Foreground = #002288
            ContentPosition = left
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style LayoutContainer/
            Frame = void
            Rules = none
            Borderwidth = 0
            CellSpacing = 30
            ContentPosition = left
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style RowHeaderEmphasis/
            Background = #B0B0B0
            Foreground = #0033AA
            ContentPosition = left
            Font = ("Verdana, Helvetica, Helv", 3, normal italic)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style DataStrongFixed/
            Background = #D3D3D3
            Foreground = #000000
            ContentPosition = left
            Font = ("Courier", 2, bold normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style Footer/
            Background = #B0B0B0
            Foreground = #0033AA
            ContentPosition = left
            Font = ("Verdana, Helvetica, Helv", 4, bold normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style GraphGridLines/
            Foreground = #808080
            ContentPosition = left
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style FolderAction/
            Background = #B0B0B0
            Foreground = #0033AA
            ContentPosition = left
            Font = ("Verdana, Helvetica, Helv", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style HeaderEmphasisFixed/
            Background = #B0B0B0
            Foreground = #0033AA
            ContentPosition = left
            Font = ("Courier", 2, normal italic)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style SystemTitle/
            Background = #E0E0E0
            Foreground = #002288
            ContentPosition = left
            Font = ("Verdana, Helvetica, Helv", 5, bold italic)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style ErrorContentFixed/
            Background = #E0E0E0
            Foreground = #002288
            ContentPosition = left
            Font = ("Courier", 2, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style SystemFooter/
            Background = #E0E0E0
            Foreground = #002288
            ContentPosition = left
            Font = ("Verdana, Helvetica, Helv", 5, bold italic)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

    end;
run;
