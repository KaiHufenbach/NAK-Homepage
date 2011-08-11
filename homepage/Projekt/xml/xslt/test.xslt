<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html" version="1.0" encoding="UTF-8" doctype-public="-//W3C//DTD XHTML 1.1//EN" doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd"/>

    <xsl:template match="standard">
        <html xmlns="http://www.w3.org/1999/xhtml">
            <head>
                <title>
                    Test XSLT
                </title>
                <style type="text/css">
                        body{background-image: url('../../img/<xsl:value-of select="test/@name"/>.jpg');}
                </style>
            </head>
            <body>
            </body>
        </html>
        
    </xsl:template>
</xsl:stylesheet>
