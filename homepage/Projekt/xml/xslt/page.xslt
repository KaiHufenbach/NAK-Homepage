<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns="http://www.w3.org/1999/xhtml">
    <xsl:output method="html" version="1.0" encoding="UTF-8" doctype-public="-//W3C//DTD XHTML 1.1//EN" doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd"/>
    
    <xsl:template match="page">
        <xsl:variable name="chapter" select="pageInfo/@chapter"/>
        <xsl:variable name="pagenr" select="pageInfo/@nr"/>
        <xsl:variable name="type" select="pageInfo/@typ"/>
        <xsl:variable name="lastPage" select="pageInfo/@lastPage"/>
        <xsl:variable name="chapters" select="document('../chapters.xml')"/>
        
        
        <html xmlns="http://www.w3.org/1999/xhtml">
            <head>
                <title>
                    Bahamas - <xsl:value-of select="$chapter"/>
                </title>
                <style type="text/css" media="screen">
                  @import"../css/standardStyle.css";
                  <!--body{background-image: url('../../img/<xsl:value-of select="test/@name"/>.jpg');}-->
                  <!-- leider ist hier die Duplette im Code notwendig. <xsl:call-template geht nicht mit select="$..." -->
                  <xsl:for-each select="$chapters/chapters/chapter">
                    <xsl:if test="@name = $chapter">
                      <xsl:variable name="chapterNr" select="@nr"/>
                      <xsl:call-template name="style">
                        <xsl:with-param select="$chapterNr" name="id"/>
                      </xsl:call-template>
                    </xsl:if>
                  </xsl:for-each>
                  <!-- Ende des Snippets-->
                </style>
            </head>
            <body>
              <div id="navigation">
                <!-- leider ist hier die Duplette im Code notwendig. <xsl:call-template geht nicht mit select="$..." -->
                <xsl:for-each select="$chapters/chapters/chapter">
                  <xsl:if test="@name = $chapter">
                    <xsl:variable name="chapterNr" select="@nr"/>
                    <xsl:call-template name="menu">
                      <xsl:with-param select="$chapterNr" name="id"/>
                    </xsl:call-template>
                  </xsl:if>
                </xsl:for-each>
                <!-- Ende des Snippets-->
              </div>
             <xsl:if test="$lastPage != 'true'">
              <div id="vorblättern">
                <xsl:element name="a">
                  <xsl:attribute name="id">ecke</xsl:attribute>
                  <xsl:attribute name="href">
                    <xsl:value-of select="$chapter"/>_<xsl:value-of select="$pagenr + 1"/>.xml
                  </xsl:attribute>
                </xsl:element>
              </div>
             </xsl:if>

              <xsl:if test ="$chapter != 'Start'"> 
              <div id="zurückblättern">
                <xsl:if test="$chapter != 'Start' and $pagenr = 1">
                  <div id="ohneAufklapp"></div>
                </xsl:if>
                <xsl:if test="$pagenr > 1">
                  <xsl:element name="a">
                    <xsl:attribute name="id">aufklapp</xsl:attribute>
                    <xsl:attribute name="href">
                      <xsl:value-of select="$chapter"/>_<xsl:value-of select="$pagenr - 1"/>.xml
                    </xsl:attribute>
                  </xsl:element>
                </xsl:if>
              </div>
              </xsl:if>

                <div id="logobox">
                <xsl:element name="img">
                  <xsl:attribute name="src">
                    ../img/layout/logo_<xsl:value-of select="$chapter"/>.png
                  </xsl:attribute>
                  <xsl:attribute name="alt">
                    <xsl:value-of select="$chapter"/>logo
                  </xsl:attribute>
                  <xsl:attribute name="id">logo</xsl:attribute>
                </xsl:element>
              </div>
              
              <div id="inhalt">
                  
                <xsl:if test="$type = 'normal'">
                  <xsl:call-template name="normal"/>
                </xsl:if>
 
                
              </div>
            </body>
        </html>

    </xsl:template>

  <xsl:template name="menu">
    <xsl:param name ="id"/>
      <xsl:variable name="chapters" select="document('../chapters.xml')"/>
    <xsl:for-each select="$chapters/chapters/chapter">
        <!-- Der IE benötigt im a Tag einen Inhalt ... sonst verrutscht alles, desweiteren wird so Barrierefreiheit hergestellt-->
      <xsl:element name='a'>
        <xsl:attribute name='href'><xsl:value-of select="@name"/>_1.xml</xsl:attribute>
        <xsl:attribute name='class'>sticky</xsl:attribute>
        <xsl:attribute name='id'><xsl:value-of select="@name"/><xsl:if test="$id = @nr">Active</xsl:if></xsl:attribute>
          <xsl:value-of select="@name"/>
      </xsl:element>
    </xsl:for-each>
  </xsl:template>


  <xsl:template name="style">
    <xsl:param name="id"/>
      <xsl:variable name="chapters" select="document('../chapters.xml')"/>
    <xsl:for-each select="$chapters/chapters/chapter">
      #<xsl:value-of select="@name"/>{background-image:url('../img/layout/nav_<xsl:value-of select="@name"/>_passiv.jpg'); top: <xsl:value-of select="81+(70*@nr)"/>px ;}
      #<xsl:value-of select="@name"/>:hover{background-image:url('../img/layout/nav_<xsl:value-of select="@name"/>_hover.jpg');}
      <xsl:if test="$id = @nr">#<xsl:value-of select="@name"/>Active{background-image:url('../img/layout/nav_<xsl:value-of select="@name"/>_aktiv.jpg'); top: <xsl:value-of select="81+(70*@nr)"/>px ;}</xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!-- Template für Content-Type Normal -->
  <xsl:template name="normal">
     
  <div id="inhalt_links">
   <!-- Iteration über alle Elmente unterhalb von left und Anwendung der Matching Rule --> 
   <xsl:apply-templates select="left/*"/>
   </div>
   <div id="inhalt_rechts">
   <!-- Iteration über alle Elemente unterhalb von right -->
   <xsl:apply-templates select="right/*"/>
   </div>
    
  </xsl:template>

    <xsl:template match="paragraph" priority="0">
        <xsl:element name="p">
            <xsl:attribute name="class">paragraph</xsl:attribute>
            <xsl:if test="@versalien = 'true'">
                <xsl:attribute name="id">versalien</xsl:attribute>
            </xsl:if>
            <xsl:if test="@headline != ''">
                <xsl:element name="h1">
                    <xsl:value-of select="@headline"/>
                </xsl:element>
            </xsl:if>
            <!-- Inhalt des Matches hier ausgeben -->
            <xsl:value-of select="."/>
        </xsl:element>
        
       
    </xsl:template>

    <xsl:template match="picture">
        <xsl:element name="img">
            <xsl:attribute name ="src">
                ../img/inhalt/<xsl:value-of select="@file"/>
            </xsl:attribute>
            <xsl:attribute name="alt">
                <xsl:value-of select="@name"/>
            </xsl:attribute>
        </xsl:element>
    </xsl:template>

  
  <!-- Backup
  <xsl:if test='$id > @nr'>
        Kleiner: <xsl:value-of select="@name"/>
      </xsl:if>
      <xsl:if test="$id = @nr">
        Gleich: <xsl:value-of select="@name"/>
      </xsl:if>
      <xsl:if test='@nr > $id'>
        Größer: <xsl:value-of select="@name"/>
      </xsl:if>
  
  
  
  -->

</xsl:stylesheet>
