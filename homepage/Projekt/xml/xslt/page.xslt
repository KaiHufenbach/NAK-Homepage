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
              <div id="vorblättern">
                <xsl:if test="$lastPage != true">
                <xsl:element name="a">
                  <xsl:attribute name="id">ecke</xsl:attribute>
                  <xsl:attribute name="href">
                    <xsl:value-of select="$chapter"/>_<xsl:value-of select="$pagenr + 1"/>.xml
                  </xsl:attribute>
                </xsl:element>
                </xsl:if>
              </div>
              
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
                <xsl:if test="$type = normal">
                  <xsl:call-template name="normal"></xsl:call-template>
                </xsl:if>
 
                
              </div>
            </body>
        </html>

    </xsl:template>

  <xsl:template name="menu">
    <xsl:param name ="id"/>
    <xsl:variable name="chapters" select="document('../chapters.xml')"/>
    <xsl:for-each select="$chapters/chapters/chapter">
      <xsl:element name='a'>
        <xsl:attribute name='href'><xsl:value-of select="@name"/>_1.xml</xsl:attribute>
        <xsl:attribute name='class'>sticky</xsl:attribute>
        <xsl:attribute name='id'><xsl:value-of select="@name"/><xsl:if test="$id = @nr">Active</xsl:if></xsl:attribute>
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
    <xsl:for-each select="/">
      <xsl:value-of select="name()"/>
    </xsl:for-each>
    
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
