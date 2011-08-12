<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns="http://www.w3.org/1999/xhtml">
    <xsl:output method="html" version="1.0" encoding="UTF-8" doctype-public="-//W3C//DTD XHTML 1.1//EN" doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd"/>
    
    <xsl:template match="page">
        <xsl:variable name="chapter" select="pageInfo/@chapter"/>
        <xsl:variable name="pagenr" select="pageInfo/@nr"/>
        
        <html xmlns="http://www.w3.org/1999/xhtml">
            <head>
                <title>
                    Test XSLT <xsl:value-of select="$chapter"/>
                </title>
                <style type="text/css">
                    <!--body{background-image: url('../../img/<xsl:value-of select="test/@name"/>.jpg');}-->
                </style>
            </head>
            <body>
                <xsl:
                <xsl:apply-templates select="document('../chapters.xml')">
                    <xsl:with-param name="Captter" select="123" />
                </xsl:apply-templates>
            </body>
        </html>

    </xsl:template>
    <!-- Dient der Erstellung des Menüs-->

    <xsl:template match="chapters">
        <xsl:param  name="Captter"/>
        <xsl:for-each select="chapter">
            test
            <xsl:value-of select="$Captter"/>
            {$Captter}

        </xsl:for-each>

    </xsl:template>


</xsl:stylesheet>
