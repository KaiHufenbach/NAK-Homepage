<xsl:stylesheet version="2.0"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns="http://www.w3.org/1999/xhtml">

    <xsl:template match="/">
        <table border="1">
            <xsl:call-template name="RowColumn">
                <xsl:with-param name="Row" select=" 'First' " />
            </xsl:call-template>
            <xsl:call-template name="RowColumn">
                <xsl:with-param name="Row" select=" 'Second' " />
            </xsl:call-template>
            <xsl:call-template name="RowColumn">
                <xsl:with-param name="Row" select="3" />
            </xsl:call-template>
        </table>
    </xsl:template>

    <xsl:template name="RowColumn">
        <xsl:param name="Row" />
        <tr>
            <td id="{$Row}">
                <xsl:value-of select="$Row" />
            </td>
        </tr>
    </xsl:template>
</xsl:stylesheet>