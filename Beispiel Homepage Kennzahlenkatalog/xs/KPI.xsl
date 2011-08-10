<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" doctype-public="-//W3C//DTD XHTML 1.1//EN" doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd"/>


  <xsl:template match="KPI">



    <html xmlns="http://www.w3.org/1999/xhtml">
      <head>
        <title>
          <xsl:value-of select="TITEL" />
        </title>
        <link rel="Stylesheet" type="text/css" href="css/style.css" />
        <meta http-equiv="content-type"
            content="text/html; charset=UTF-8"/>

      </head>
      <body bgcolor="#261B1E">

        <img id="headline" src="kennzahlenkatalog.png" alt="Kennzahlenkatalog"/>

        <div id="maincontainer">

          <div id="kennzahlenbox">
            <p>
              <a href="index.htm" class="menulink">Kennzahl1</a>
            </p>
            <p>
              <a href="index.htm" class="menulink">Kennzahl2</a>
            </p>
            <p>
              <a href="index.htm" class="menulink">Kennzahl3</a>
            </p>
            <p>
              <a href="index.htm" class="menulink">Kennzahl4</a>
            </p>
            <p>
              <a href="index.htm" class="menulink">Kennzahl5</a>
            </p>
          </div>

          <div id="beschreibungsbox">
            <h1>
              <xsl:value-of select="ID" />: <xsl:value-of select="TITEL" />
            </h1>

            <h3>
              Typ: <xsl:value-of select="TYPE" />
            </h3>

            <h4>Verwendet in Formeln:</h4>


            <xsl:for-each select="USED/BY">
              -><a class="menulink">
                <xsl:attribute name="href">
                  <xsl:value-of select="LINK" />.xml
                </xsl:attribute>

                <xsl:value-of select="ALIAS"/>
                <br/>
              </a>
            </xsl:for-each>




            <p>
              <xsl:value-of select="COMMENT" />
            </p>
          </div>

        </div>

        <div id="footer">
          <p>Oliver Plehn 2011</p>
        </div>

      </body>
    </html>













  </xsl:template>


</xsl:stylesheet>
