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
        style AfterCaption/
            CellSpacing = 0
            CellPadding = 0
            Background = #E0E0E0
            Foreground = #000000
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 4, bold normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style Batch/
            Frame = box
            Rules = groups
            Borderwidth = 1px
            CellSpacing = 1
            CellPadding = 7
            Background = #D3D3D3
            Foreground = #000000
            BorderColor = #000000
            ContentPosition = left
            Font = ("SAS Monospace, Courier New, Courier, monospace", 2, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style BeforeCaption/
            CellSpacing = 0
            CellPadding = 0
            Background = #E0E0E0
            Foreground = #000000
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 4, bold normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style Body/
            PageBreakHTML = '<p style="page-break-after: always;"><br></p><hr size="3">'
            HTMLContentType = "text/html"
            HTMLDocType = '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">'
            LeftMargin = 8px
            RightMargin = 8px
            LinkColor = #0066AA
            VisitedLinkColor = #004488
            ActiveLinkColor = #004488
            Background = #E0E0E0
            Foreground = #002288
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
            ProtectSpecialChars = auto
        ;

        style BodyDate/
            CellSpacing = 0
            CellPadding = 0
            OutputWidth = 100%
            Background = #E0E0E0
            Foreground = #002288
            Just = r
            VJust = t
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style ByContentFolder/
            PreHTML = '<span><b>&#183;</b>'
            PostHTML = '</span>'
            Bullet = none
            LeftMargin = 6pt
            Foreground = #002288
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style Byline/
            CellSpacing = 0
            CellPadding = 0
            Background = #B0B0B0
            Foreground = #0033AA
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 4, bold normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style BylineContainer/
            Frame = void
            Rules = none
            Borderwidth = 0
            CellSpacing = 1
            CellPadding = 1
            OutputWidth = 100%
            Background = #E0E0E0
            Foreground = #002288
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style Caption/
            CellSpacing = 0
            CellPadding = 0
            Background = #E0E0E0
            Foreground = #000000
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 4, bold normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style Cell/
            Background = #E0E0E0
            Foreground = #002288
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style Container/
            Background = #E0E0E0
            Foreground = #002288
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style ContentFolder/
            PreHTML = '<span><b>&#183;</b>'
            PostHTML = '</span>'
            Bullet = none
            LeftMargin = 6pt
            Foreground = #002288
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style ContentItem/
            PreHTML = '<span><b>&#183;</b>'
            PostHTML = '</span>'
            Bullet = none
            LeftMargin = 6pt
            Foreground = #0033AA
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 3, normal normal)
            ListEntryAnchor = yes
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style ContentProcLabel/
            PreHTML = '<span>'
            PostHTML = '</span>'
            Bullet = decimal
            Foreground = #002288
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style ContentProcName/
            PreText = "The "
            PostText = " Procedure"
            PreHTML = '<span>'
            PostHTML = '</span>'
            Bullet = decimal
            Foreground = #002288
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style Contents/
            PageBreakHTML = '<br>'
            HTMLContentType = "text/html"
            HTMLDocType = '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">'
            Bullet = decimal
            TagAttr = ' onload="expandAll()"'
            LeftMargin = 8px
            RightMargin = 8px
            LinkColor = #0066AA
            VisitedLinkColor = #004488
            ActiveLinkColor = #004488
            Background = #B0B0B0
            Foreground = #0033AA
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
            ProtectSpecialChars = auto
        ;

        style ContentsDate/
            OutputWidth = 100%
            Background = #B0B0B0
            Foreground = #0033AA
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style ContentTitle/
            PreText = "Table of Contents"
            PreHTML = '<span onclick="expandCollapse()">'
            PostHTML = '</span><hr size="3">'
            Foreground = #002288
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 3, normal italic)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style Continued/
            PreText = "(Continued)"
            CellSpacing = 0
            CellPadding = 0
            OutputWidth = 100%
            Background = #E0E0E0
            Foreground = #002288
            Just = l
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 4, bold normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style Data/
            Background = #D3D3D3
            Foreground = #000000
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style DataEmphasis/
            Background = #D3D3D3
            Foreground = #000000
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 3, normal italic)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style DataEmphasisFixed/
            Background = #D3D3D3
            Foreground = #000000
            ContentPosition = left
            Font = ("Courier New, Courier, monospace", 2, normal italic)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style DataEmpty/
            Background = #D3D3D3
            Foreground = #000000
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style DataFixed/
            Background = #D3D3D3
            Foreground = #000000
            ContentPosition = left
            Font = ("Courier New, Courier", 2, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style DataStrong/
            Background = #D3D3D3
            Foreground = #000000
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 4, bold normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style DataStrongFixed/
            Background = #D3D3D3
            Foreground = #000000
            ContentPosition = left
            Font = ("Courier New, Courier, monospace", 2, bold normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style Date/
            OutputWidth = 100%
            Background = #B0B0B0
            Foreground = #0033AA
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style Document/
            HTMLContentType = "text/html"
            HTMLDocType = '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">'
            LinkColor = #0066AA
            VisitedLinkColor = #004488
            ActiveLinkColor = #004488
            Background = #E0E0E0
            Foreground = #002288
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
            ProtectSpecialChars = auto
        ;

        style ErrorBanner/
            PreText = "Error:"
            Background = #E0E0E0
            Foreground = #002288
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 3, bold normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style ErrorContent/
            Background = #E0E0E0
            Foreground = #002288
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style ErrorContentFixed/
            Background = #E0E0E0
            Foreground = #002288
            ContentPosition = left
            Font = ("Courier New, Courier", 2, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style ExtendedPage/
            PreText = "Continuing contents of page "
            PostText = ", which would not fit on a single physical page"
            Frame = box
            Borderwidth = 1pt
            CellPadding = 2pt
            FillRuleWidth = 0.5pt
            Background = #E0E0E0
            Foreground = #002288
            Just = c
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 3, normal italic)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style FatalBanner/
            PreText = "Fatal:"
            Background = #E0E0E0
            Foreground = #002288
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 3, bold normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style FatalContent/
            Background = #E0E0E0
            Foreground = #002288
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style FatalContentFixed/
            Background = #E0E0E0
            Foreground = #002288
            ContentPosition = left
            Font = ("Courier New, Courier", 2, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style FolderAction/
            PreHTML = '<span><b>&#183;</b>'
            PostHTML = '</span>'
            Bullet = none
            LeftMargin = 6pt
            Foreground = #0033AA
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 3, normal normal)
            ListEntryAnchor = yes
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style Footer/
            Background = #B0B0B0
            Foreground = #0033AA
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 4, bold normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style FooterEmphasis/
            Background = #B0B0B0
            Foreground = #0033AA
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 3, normal italic)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style FooterEmphasisFixed/
            Background = #B0B0B0
            Foreground = #0033AA
            ContentPosition = left
            Font = ("Courier New, Courier, monospace", 2, normal italic)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style FooterEmpty/
            Background = #B0B0B0
            Foreground = #0033AA
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 4, bold normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style FooterFixed/
            Background = #B0B0B0
            Foreground = #0033AA
            ContentPosition = left
            Font = ("Courier New, Courier", 2, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style FooterStrong/
            Background = #B0B0B0
            Foreground = #0033AA
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 4, bold normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style FooterStrongFixed/
            Background = #B0B0B0
            Foreground = #0033AA
            ContentPosition = left
            Font = ("Courier New, Courier, monospace", 2, bold normal)
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
            ActiveLinkColor = #004488
            Background = #E0E0E0
            Foreground = #002288
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 3, normal normal)
            FrameBorder = yes
            ContentScrollbar = auto
            BodyScrollbar = auto
            ProtectSpecialChars = auto
        ;

        style Graph/
            Frame = box
            Rules = groups
            Borderwidth = 1px
            CellSpacing = 1
            CellPadding = 0
            Background = #E0E0E0
            Foreground = #002288
            BorderColor = #000000
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style Header/
            Background = #B0B0B0
            Foreground = #0033AA
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 4, bold normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style HeaderEmphasis/
            Background = #B0B0B0
            Foreground = #0033AA
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 3, normal italic)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style HeaderEmphasisFixed/
            Background = #B0B0B0
            Foreground = #0033AA
            ContentPosition = left
            Font = ("Courier New, Courier, monospace", 2, normal italic)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style HeaderEmpty/
            Background = #B0B0B0
            Foreground = #0033AA
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 4, bold normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style HeaderFixed/
            Background = #B0B0B0
            Foreground = #0033AA
            ContentPosition = left
            Font = ("Courier New, Courier", 2, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style HeadersAndFooters/
            Background = #B0B0B0
            Foreground = #0033AA
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 4, bold normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style HeaderStrong/
            Background = #B0B0B0
            Foreground = #0033AA
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 4, bold normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style HeaderStrongFixed/
            Background = #B0B0B0
            Foreground = #0033AA
            ContentPosition = left
            Font = ("Courier New, Courier, monospace", 2, bold normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style Index/
            Background = #B0B0B0
            Foreground = #0033AA
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style IndexAction/
            PreHTML = '<span><b>&#183;</b>'
            PostHTML = '</span>'
            Bullet = none
            LeftMargin = 6pt
            Foreground = #0033AA
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 3, normal normal)
            ListEntryAnchor = yes
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style IndexItem/
            PreHTML = '<span><b>&#183;</b>'
            PostHTML = '</span>'
            Bullet = none
            LeftMargin = 6pt
            Foreground = #0033AA
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 3, normal normal)
            ListEntryAnchor = yes
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style IndexProcName/
            PreText = "The "
            PostText = " Procedure"
            PreHTML = '<span>'
            PostHTML = '</span>'
            Bullet = decimal
            Foreground = #002288
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style IndexTitle/
            PreHTML = '<span onclick="expandCollapse()">'
            PostHTML = '</span><hr size="3">'
            Foreground = #002288
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 3, normal italic)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style List/
            Bullet = disc
            OutputWidth = 100%
            Background = #E0E0E0
            Foreground = #002288
            Just = l
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style List10/
            Bullet = square
            OutputWidth = 100%
            Background = #E0E0E0
            Foreground = #002288
            Just = l
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style List2/
            Bullet = circle
            OutputWidth = 100%
            Background = #E0E0E0
            Foreground = #002288
            Just = l
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style List3/
            Bullet = square
            OutputWidth = 100%
            Background = #E0E0E0
            Foreground = #002288
            Just = l
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style List4/
            Bullet = square
            OutputWidth = 100%
            Background = #E0E0E0
            Foreground = #002288
            Just = l
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style List5/
            Bullet = square
            OutputWidth = 100%
            Background = #E0E0E0
            Foreground = #002288
            Just = l
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style List6/
            Bullet = square
            OutputWidth = 100%
            Background = #E0E0E0
            Foreground = #002288
            Just = l
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style List7/
            Bullet = square
            OutputWidth = 100%
            Background = #E0E0E0
            Foreground = #002288
            Just = l
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style List8/
            Bullet = square
            OutputWidth = 100%
            Background = #E0E0E0
            Foreground = #002288
            Just = l
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style List9/
            Bullet = square
            OutputWidth = 100%
            Background = #E0E0E0
            Foreground = #002288
            Just = l
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style ListItem/
            Background = #E0E0E0
            Foreground = #002288
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style ListItem10/
            Background = #E0E0E0
            Foreground = #002288
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style ListItem2/
            Background = #E0E0E0
            Foreground = #002288
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style ListItem3/
            Background = #E0E0E0
            Foreground = #002288
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style ListItem4/
            Background = #E0E0E0
            Foreground = #002288
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style ListItem5/
            Background = #E0E0E0
            Foreground = #002288
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style ListItem6/
            Background = #E0E0E0
            Foreground = #002288
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style ListItem7/
            Background = #E0E0E0
            Foreground = #002288
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style ListItem8/
            Background = #E0E0E0
            Foreground = #002288
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style ListItem9/
            Background = #E0E0E0
            Foreground = #002288
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style Note/
            Background = #E0E0E0
            Foreground = #002288
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style NoteBanner/
            PreText = "Note:"
            Background = #E0E0E0
            Foreground = #002288
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 3, bold normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style NoteContent/
            Background = #E0E0E0
            Foreground = #002288
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style NoteContentFixed/
            Background = #E0E0E0
            Foreground = #002288
            ContentPosition = left
            Font = ("Courier New, Courier", 2, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style Output/
            Frame = box
            Rules = groups
            Borderwidth = 1px
            CellSpacing = 1
            CellPadding = 7
            Background = #F0F0F0
            Foreground = #002288
            BorderColor = #000000
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style PageNo/
            CellSpacing = 0
            CellPadding = 0
            Background = #E0E0E0
            Foreground = #002288
            Just = r
            VJust = t
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 4, bold normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style Pages/
            PageBreakHTML = '<br>'
            HTMLContentType = "text/html"
            HTMLDocType = '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">'
            Bullet = decimal
            TagAttr = ' onload="expandAll()"'
            LeftMargin = 8px
            RightMargin = 8px
            LinkColor = #0066AA
            VisitedLinkColor = #004488
            ActiveLinkColor = #004488
            Background = #B0B0B0
            Foreground = #0033AA
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
            ProtectSpecialChars = auto
        ;

        style PagesDate/
            OutputWidth = 100%
            Background = #B0B0B0
            Foreground = #0033AA
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style PagesItem/
            PreHTML = '<span><b>&#183;</b>'
            PostHTML = '</span>'
            Bullet = none
            LeftMargin = 6pt
            Foreground = #0033AA
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 3, normal normal)
            ListEntryAnchor = yes
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style PagesProcLabel/
            PreHTML = '<span>'
            PostHTML = '</span>'
            Bullet = decimal
            Foreground = #002288
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style PagesProcName/
            PreText = "The "
            PostText = " Procedure"
            PreHTML = '<span>'
            PostHTML = '</span>'
            Bullet = decimal
            Foreground = #002288
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style PagesTitle/
            PreText = "Table of Pages"
            PreHTML = '<span onclick="expandCollapse()">'
            PostHTML = '</span><hr size="3">'
            Foreground = #002288
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 3, normal italic)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style Paragraph/
            OutputWidth = 100%
            Background = #E0E0E0
            Foreground = #002288
            Just = l
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style Parskip/
            Frame = void
            Rules = none
            Borderwidth = 0
            CellSpacing = 0
            CellPadding = 0
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 4, bold normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style PrePage/
            Background = #E0E0E0
            Foreground = #002288
            Just = l
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style ProcTitle/
            Background = #E0E0E0
            Foreground = #002288
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 4, bold italic)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style ProcTitleFixed/
            Background = #E0E0E0
            Foreground = #002288
            ContentPosition = left
            Font = ("Courier New, Courier, monospace", 2, bold normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style RowFooter/
            Background = #B0B0B0
            Foreground = #0033AA
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 4, bold normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style RowFooterEmphasis/
            Background = #B0B0B0
            Foreground = #0033AA
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 3, normal italic)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style RowFooterEmphasisFixed/
            Background = #B0B0B0
            Foreground = #0033AA
            ContentPosition = left
            Font = ("Courier New, Courier, monospace", 2, normal italic)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style RowFooterEmpty/
            Background = #B0B0B0
            Foreground = #0033AA
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 4, bold normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style RowFooterFixed/
            Background = #B0B0B0
            Foreground = #0033AA
            ContentPosition = left
            Font = ("Courier New, Courier", 2, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style RowFooterStrong/
            Background = #B0B0B0
            Foreground = #0033AA
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 4, bold normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style RowFooterStrongFixed/
            Background = #B0B0B0
            Foreground = #0033AA
            ContentPosition = left
            Font = ("Courier New, Courier, monospace", 2, bold normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style RowHeader/
            Background = #B0B0B0
            Foreground = #0033AA
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 4, bold normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style RowHeaderEmphasis/
            Background = #B0B0B0
            Foreground = #0033AA
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 3, normal italic)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style RowHeaderEmphasisFixed/
            Background = #B0B0B0
            Foreground = #0033AA
            ContentPosition = left
            Font = ("Courier New, Courier, monospace", 2, normal italic)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style RowHeaderEmpty/
            Background = #B0B0B0
            Foreground = #0033AA
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 4, bold normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style RowHeaderFixed/
            Background = #B0B0B0
            Foreground = #0033AA
            ContentPosition = left
            Font = ("Courier New, Courier", 2, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style RowHeaderStrong/
            Background = #B0B0B0
            Foreground = #0033AA
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 4, bold normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style RowHeaderStrongFixed/
            Background = #B0B0B0
            Foreground = #0033AA
            ContentPosition = left
            Font = ("Courier New, Courier, monospace", 2, bold normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style SystemFooter/
            Background = #E0E0E0
            Foreground = #002288
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 5, bold italic)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style SystemFooter10/
            Background = #E0E0E0
            Foreground = #002288
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 5, bold italic)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style SystemFooter2/
            Background = #E0E0E0
            Foreground = #002288
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 5, bold italic)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style SystemFooter3/
            Background = #E0E0E0
            Foreground = #002288
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 5, bold italic)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style SystemFooter4/
            Background = #E0E0E0
            Foreground = #002288
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 5, bold italic)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style SystemFooter5/
            Background = #E0E0E0
            Foreground = #002288
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 5, bold italic)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style SystemFooter6/
            Background = #E0E0E0
            Foreground = #002288
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 5, bold italic)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style SystemFooter7/
            Background = #E0E0E0
            Foreground = #002288
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 5, bold italic)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style SystemFooter8/
            Background = #E0E0E0
            Foreground = #002288
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 5, bold italic)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style SystemFooter9/
            Background = #E0E0E0
            Foreground = #002288
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 5, bold italic)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style SystemTitle/
            Background = #E0E0E0
            Foreground = #002288
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 5, bold italic)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style SystemTitle10/
            Background = #E0E0E0
            Foreground = #002288
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 5, bold italic)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style SystemTitle2/
            Background = #E0E0E0
            Foreground = #002288
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 5, bold italic)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style SystemTitle3/
            Background = #E0E0E0
            Foreground = #002288
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 5, bold italic)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style SystemTitle4/
            Background = #E0E0E0
            Foreground = #002288
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 5, bold italic)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style SystemTitle5/
            Background = #E0E0E0
            Foreground = #002288
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 5, bold italic)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style SystemTitle6/
            Background = #E0E0E0
            Foreground = #002288
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 5, bold italic)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style SystemTitle7/
            Background = #E0E0E0
            Foreground = #002288
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 5, bold italic)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style SystemTitle8/
            Background = #E0E0E0
            Foreground = #002288
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 5, bold italic)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style SystemTitle9/
            Background = #E0E0E0
            Foreground = #002288
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 5, bold italic)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style SysTitleAndFooterContainer/
            Frame = void
            Rules = none
            Borderwidth = 0
            CellSpacing = 1
            CellPadding = 1
            OutputWidth = 100%
            Background = #E0E0E0
            Foreground = #002288
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style Table/
            Frame = box
            Rules = groups
            Borderwidth = 1px
            CellSpacing = 1
            CellPadding = 7
            Background = #F0F0F0
            Foreground = #002288
            BorderColor = #000000
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style TitleAndNoteContainer/
            Frame = void
            Rules = none
            Borderwidth = 0
            CellSpacing = 1
            CellPadding = 1
            OutputWidth = 100%
            Background = #E0E0E0
            Foreground = #002288
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style TitlesAndFooters/
            Background = #E0E0E0
            Foreground = #002288
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 4, bold italic)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style UserText/
            Background = #E0E0E0
            Foreground = #002288
            Just = l
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style WarnBanner/
            PreText = "Warning:"
            Background = #E0E0E0
            Foreground = #002288
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 3, bold normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style WarnContent/
            Background = #E0E0E0
            Foreground = #002288
            ContentPosition = left
            Font = ("Arial, Helvetica, sans-serif", 3, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

        style WarnContentFixed/
            Background = #E0E0E0
            Foreground = #002288
            ContentPosition = left
            Font = ("Courier New, Courier", 2, normal normal)
            ContentScrollbar = auto
            BodyScrollbar = auto
        ;

    end;
run;
