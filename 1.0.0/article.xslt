<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="2.0" xpath-default-namespace="http://www.tei-c.org/ns/1.0" xmlns:tei="http://www.tei-c.org/ns/1.0">
    
    <xsl:param name="apploc"><xsl:value-of select="/TEI/teiHeader/encodingDesc/variantEncoding/@location"/></xsl:param>
    <xsl:param name="notesloc"><xsl:value-of select="/TEI/teiHeader/encodingDesc/variantEncoding/@location"/></xsl:param>
    <xsl:variable name="title"><xsl:value-of select="/TEI/teiHeader/fileDesc/titleStmt/title"/></xsl:variable>
    <xsl:variable name="author"><xsl:value-of select="/TEI/teiHeader/fileDesc/titleStmt/author"/></xsl:variable>
    <xsl:variable name="editor"><xsl:value-of select="/TEI/teiHeader/fileDesc/titleStmt/editor"/></xsl:variable>
    <xsl:param name="targetdirectory">null</xsl:param>
  <!-- get versioning numbers -->
    <xsl:param name="sourceversion"><xsl:value-of select="/TEI/teiHeader/fileDesc/editionStmt/edition/@n"/></xsl:param>
    
    <!-- this xsltconvnumber should be the same as the git tag, and for any commit past the tag should be the tag name plus '-dev' -->
    <xsl:param name="conversionversion">dev</xsl:param>
    
    <!-- default is dev; if a unique version number for the print output is desired; it should be passed as a parameter -->
    
    <!-- combined version number should have mirror syntax of an equation x+y source+conversion -->
    <xsl:variable name="combinedversionnumber"><xsl:value-of select="$sourceversion"/>+<xsl:value-of select="$conversionversion"/></xsl:variable>
    <!-- end versioning numbers -->  
    <xsl:variable name="fs"><xsl:value-of select="/TEI/text/body/div/@xml:id"/></xsl:variable>
    <xsl:variable name="name-list-file">/Users/jcwitt/Projects/lombardpress/lombardpress-lists/Prosopography.xml</xsl:variable>
    <xsl:variable name="work-list-file">/Users/jcwitt/Projects/lombardpress/lombardpress-lists/workscited.xml</xsl:variable>
    
    <xsl:output method="text" indent="no"/>
    <!-- <xsl:strip-space elements="*"/> -->
    
    <xsl:template match="text()">
    <xsl:value-of select="replace(., '\s+', ' ')"/>    
    </xsl:template>
    
    <xsl:template match="/">
        %this tex file was auto produced from TEI by lbp-print-xslt 1.0.0 critical stylesheets on <xsl:value-of  select="current-dateTime()"/> using the  <xsl:value-of select="base-uri(document(''))"/> 
        \documentclass[twoside, openright]{report}
        
        % etex package is added to fix bug with eledmac package and mac-tex 2015
        % See http://tex.stackexchange.com/questions/250615/error-when-compiling-with-tex-live-2015-eledmac-package
        \usepackage{etex}
        
        %imakeidx must be loaded beore eledmac
        \usepackage{imakeidx}
        
        \usepackage{reledmac}
        \usepackage{titlesec}
        \usepackage [latin]{babel}
        \usepackage[style=american] {csquotes}
        \usepackage{geometry}
        \usepackage{fancyhdr}
        \usepackage[letter, center, cam]{crop}
        
        
        \geometry{paperheight=10in, paperwidth=7in, hmarginratio=3:2, inner=1.7in, outer=1.13in, bmargin=1in} 
        
        %fancyheading settings
        \pagestyle{fancy}
        
        %git package 
        \usepackage{gitinfo2}
        
        %watermark
        
        <xsl:if test="/TEI/teiHeader/revisionDesc/@status = 'draft'">
        \usepackage{draftwatermark}
        
        %\SetWatermarkText{Draft}
        %\SetWatermarkScale{.5}
        %\SetWatermarkAngle{0}
        %\SetWatermarkVerCenter{1 cm}
        </xsl:if>
        
        
        %quotes settings
        \MakeOuterQuote{"}
        
        %package for angle brackets
        \usepackage{textcomp}
        
        %title settings
        \titleformat{\section} {\normalfont\scshape}{\thesection}{1em}{}
        \titlespacing\section{0pt}{12pt plus 4pt minus 2pt}{12pt plus 2pt minus 2pt}
        \titleformat{\chapter} {\normalfont\Large\uppercase}{\thechapter}{50pt}{}
        
        %reledmac settings % these settings change footnotes to run inline as a paragraph, 
        %change paragraph to twocol, threecol, or normal for different effects
        \Xarrangement[A]{paragraph}
        \Xarrangement[B]{paragraph}
        \Xnotenumfont[A]{\normalfont\bfseries}
        \Xnotenumfont[B]{\normalfont\bfseries}
        
        %turn off line numbering
        \numberlinefalse
        %\linenummargin{outer}
        \sidenotemargin{inner}
        
        %other settings
        \linespread{1.1}
        
        %custom macros
        \newcommand{\name}[1]{\textsc{#1}}
        \newcommand{\worktitle}[1]{\textit{#1}}
        
        
        
        
        \newcommand{\crossref}[2]
        {
        \ifnum#1=000
          #2
        \else
          Vide #1
        \fi
        }
        
        
        
        
        \begin{document}
        \fancyhead[RO]{<xsl:value-of select="$title"/>}
        \fancyhead[LO]{<xsl:value-of select="$author"/>}
        \fancyhead[LE]{<xsl:value-of select="$combinedversionnumber"/>+\gitDescribe}
        \chapter*{<xsl:value-of select="$title"/>}
        \addcontentsline{toc}{chapter}{<xsl:value-of select="$title"/>}
        
        <xsl:apply-templates select="//body"/>
        \end{document}
    </xsl:template>
    
    <xsl:template match="div//head">\section*{<xsl:apply-templates/>}</xsl:template>
    <xsl:template match="div//div">
        \bigskip
        <xsl:apply-templates/>
        
    </xsl:template>
    <xsl:template match="hi[@rend='italic']">\textit{<xsl:apply-templates></xsl:apply-templates>}</xsl:template>
    <xsl:template match="p">
        <xsl:variable name="pn"><xsl:number level="any" from="tei:text"/></xsl:variable>
        \pstart
        \ledsidenote{\textbf{<xsl:value-of select="$pn"/>}}
        <xsl:apply-templates/>
        \pend
    </xsl:template>
    <xsl:template match="head">
    </xsl:template>
    <xsl:template match="div">
        \beginnumbering
        <xsl:apply-templates/>
        \endnumbering
        
    </xsl:template>
  <xsl:template match="list">
    \begin{itemize}
    <xsl:apply-templates/>
    \end{itemize}
  </xsl:template>
  <xsl:template match="item">
    \item[--]{<xsl:apply-templates/>}
  </xsl:template>
  <xsl:template match="cit[quote]">
      <xsl:apply-templates select="quote"/>
      <xsl:text>\footnote{</xsl:text>
      <xsl:apply-templates select="bibl"/>
      <xsl:text>}</xsl:text>
    </xsl:template>
    <xsl:template match="cit[ref]">
      <xsl:apply-templates select="ref"/>
      <xsl:text>\footnote{</xsl:text>
      <xsl:apply-templates select="bibl"/>
      <xsl:text>}</xsl:text>
    </xsl:template>
  <xsl:template match="note[not(parent::cit)]">
    <xsl:text>\footnote{</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>}</xsl:text>
  </xsl:template>
  <xsl:template match="ref"><xsl:apply-templates/></xsl:template>
  <xsl:template match="name">
    <xsl:variable name="nameid" select="substring-after(./@ref, '#')"/>
    <xsl:text>\name{</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>}</xsl:text>
  </xsl:template>
  <xsl:template match="title">
    <xsl:variable name="workid" select="substring-after(./@ref, '#')"/>
    <xsl:text>\worktitle{</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>}</xsl:text>
  </xsl:template>
  <xsl:template match="mentioned">
      <xsl:text>\enquote*{</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>}</xsl:text>
  </xsl:template>
  <xsl:template match="quote">\enquote{<xsl:apply-templates/>}</xsl:template>
</xsl:stylesheet>