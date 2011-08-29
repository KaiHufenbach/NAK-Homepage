<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns="http://www.w3.org/1999/xhtml">
    <!-- encoding="UTF-8"  darf hier nicht stehen, sonst bekommt der IE 8 Umlautprobleme-->
    <xsl:output method="xml" version="1.0" indent="yes" doctype-public="-//W3C//DTD XHTML 1.1//EN" doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd"/>
    
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
                    
                    <!-- Dynamische Imports für Steckbrief -->
                    <xsl:if test="$type = 'overview'">
                        <xsl:call-template name="overviewStyle"/>
                    </xsl:if>
                </style>
                
                <style type="text/css" media="print">
                    @import"../css/printStyle.css";
                </style>

                <xsl:if test="$type = 'quiz'">
                    <script type="text/javascript">
                        <!-- Hier folgt kein XHTML, somit ist der Code valide, für Browser, die das nicht verstehen ist der Kommentar gedacht. -->
                        <xsl:text disable-output-escaping="yes">/* &lt;![CDATA[ */</xsl:text>  
                        <xsl:text disable-output-escaping="yes">
                        //ist Javascript nicht aktiviert, wird nichts eingefügt
                       

                        //Objekt, dass eine Frage repräsentiert
                        //Parameter:
                        //question - Frage
                        //answer - die Korrekte Antwort
                        //options - Array der Antwortmöglichkeiten
                        //picture - Name eines anzuzeigenden Bildes
                        //Dieses Objekt muss ebenfalls hier stehen, da es sonst nicht geladen werden kann
                        function question(question, answer, options, picture) {
                        this.question = question;
                        this.answer = answer;
                        this.picture = picture;
                        this.options = options;
                        }
                        
                        //Repräsentiert ein Bild
                        function Picture(graphic, text) {
                            this.graphic = graphic;
                            this.text = text;
                        }

                        //Repräsentiert einen Rang
                        function Rank(graphic, text, from, to){
                            this.graphic = graphic;
                            this.text = text;
                            this.from = from;
                            this.to = to;
                        }
                        </xsl:text>

                        //Wird via XSLT gesetzt werden
                        var amountOfQuestions =  <xsl:value-of select="quizOptions/@questions"/>;
                        <!-- Muss hier leider in eine Zeile geschrieben werden, damit der Javascript Interpreter damit klar kommt. -->
                        var questionPool = new Array(<xsl:for-each select="question">new question("<xsl:value-of select="@question"/>",<xsl:for-each select="option"><xsl:if test="@rightAnswer = 'true'">"<xsl:value-of select="."/>",</xsl:if></xsl:for-each>new Array(<xsl:for-each select="option">"<xsl:value-of select="."/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>)<xsl:for-each select="picture">, new Picture("<xsl:value-of select="@file"/>","<xsl:value-of select="@name"/>")</xsl:for-each>)<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>);
                        var ranks = new Array(<xsl:for-each select="quizOptions/rank">new Rank("<xsl:value-of select="picture/@file"/>","<xsl:value-of select="picture/@name"/>",<xsl:value-of select="@from"/>,<xsl:value-of select="@to"/>)<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>);
                        <xsl:text disable-output-escaping="yes"> /* ]]&gt; */</xsl:text>
                    </script>
                    <!-- Der IE u. FF5 benötigt ein langgeschriebenes Tag -->
                    <script type="text/javascript" src="../js/quiz.js"></script>
                    <script type="text/javascript" src="../js/md5.js"></script>
                    
                </xsl:if>
                
            </head>

            
            
            <xsl:element name="body">
                <xsl:if test="$type ='quiz'">
                    <xsl:attribute name="onload">initialize()</xsl:attribute>
                </xsl:if>

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
                  <!-- Das a Tag benötigt im IE einen Inhalt, sonst wird die Seite falsch dargestellt.-->
                <xsl:element name="a">
                  <xsl:attribute name="id">ecke</xsl:attribute>
                  <xsl:attribute name="href">
                    <xsl:value-of select="$chapter"/>_<xsl:value-of select="$pagenr + 1"/>.xml
                  </xsl:attribute>
                  Vorblättern
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
                    Zurückblättern
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
                  <xsl:attribute name="id">logo<xsl:if test="$type = 'start'">_start</xsl:if>
              </xsl:attribute>
                </xsl:element>
              </div>


                <!-- Für die Startseite existiert ein Sonderfall: Das Weiterblättern auf das nächste Kapitel ist möglich -->
                <xsl:if test="$type ='start'">
                    <div id="vorblättern">
                        <xsl:element name="a">
                            <xsl:attribute name="id">start_ecke</xsl:attribute>
                            <xsl:attribute name="href">
                                <xsl:for-each select="$chapters/chapters/chapter">
                                    <xsl:if test="@nr = 2">
                                        <xsl:value-of select="@name"/>_1.xml
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:attribute>
                            Vorblättern
                        </xsl:element>
                    </div>
                </xsl:if>
              
              
                  
                <xsl:if test="$type = 'normal'">
                    <div id="inhalt">
                  <xsl:call-template name="normal"/>
                    </div>
                </xsl:if>

                <xsl:if test="$type = 'overview'">
                    <div id="inhalt">
                        <xsl:call-template name="overview"/>
                    </div>
                </xsl:if>



            </xsl:element>
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

    <!-- Template für das Quiz (es erzeugt KEINEN HTML Content, sondern befüllt lediglich ein Javascript) -->
    <xsl:template name="quiz">
        
    </xsl:template>

    <!-- Template für den Steckbrief -->
    <xsl:template name ="overview">
        <xsl:call-template name="overviewPictureArea"/>
        <xsl:for-each select="table">
            <xsl:call-template name="table">
                <xsl:with-param name="idTable" select="'statische_steckbrieftabelle'"/>
                <xsl:with-param name="idFirstColumn" select="'steckbrief_links'"/>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="overviewPictureArea">
        <div id="alleinselnaufderkarte">
            <xsl:apply-templates select="overviewPictureArea"/>
        </div>
    </xsl:template>

  <xsl:template match="hoverArea">
      <div class="hoverbild_start">
          <xsl:apply-templates select="picture"/>
      </div>
      <xsl:for-each select="hoverPart">
          <div>
              <xsl:variable name="hoverid" select="picture/@name"/>
              <xsl:attribute name="id">
                  <xsl:value-of select="$hoverid"/>
              </xsl:attribute>
              <div>
                  <xsl:attribute name="id">
                      <xsl:value-of select="$hoverid"/>_filler</xsl:attribute>
                  <xsl:attribute name="class">filler</xsl:attribute>
              </div>
                  <!-- Über dieses Konstrukt kann ein bestimmtes Element angefahren werden, da xsl:apply-templates mit with Param nicht funktioniert. Somit ist ein Funktionales Programmieren leider nicht möglich (Die Funktionen bekommen Side-Effects).  -->
                  <xsl:for-each select="picture">
                      <xsl:call-template name="picture">
                          <xsl:with-param name="class">hoverbild</xsl:with-param>
                      </xsl:call-template>
                  </xsl:for-each>
              <div class="infobox">
                  <!-- Dieses Konstrukt ist ein Workaround für <xsl:apply-templates><xsl:with-param ... -->
                  <xsl:for-each select ="descriptionBox/*">
                      <xsl:if test="name() = 'table'">
                          <xsl:call-template name="table">
                              <xsl:with-param name="classTable">steckbriefhoverinfoboxtabelle</xsl:with-param>
                              <xsl:with-param name="classFirstRowFirstColumn">steckbriefhoverinfotabelle_ueberschrift</xsl:with-param>
                          </xsl:call-template>
                      </xsl:if>
                      <xsl:if test="name() = 'picture'">
                          <xsl:call-template name="picture"/>
                      </xsl:if>
                      <xsl:if test="name() = 'paragraph'">
                          <xsl:call-template name="paragraph"/>
                      </xsl:if>
                  </xsl:for-each>
              </div>
              
          </div>
      </xsl:for-each>
  </xsl:template>

    <!-- CSS-Stil-Erweiterung für Steckbrief -->
    <xsl:template name="overviewStyle">
        <!-- Festlegung des Ziels, um die Zielkoordinaten der Infoboxen anzuzeigen -->
        <xsl:variable name="targetx" select="overviewPictureArea/hoverArea/@targetx"/>
        <xsl:variable name="targety" select="overviewPictureArea/hoverArea/@targety"/>

        <xsl:for-each select="overviewPictureArea/hoverArea/hoverPart">
            #<xsl:value-of select="picture/@name"/>{
            width: <xsl:value-of select="@sizex"/>px;
            height: <xsl:value-of select="@sizey"/>px;
            top: <xsl:value-of select="@posy"/>px;
            left: <xsl:value-of select="@posx"/>px;
            }

            #<xsl:value-of select="picture/@name"/>_filler{
            width: <xsl:value-of select="@sizex"/>px;
            height: <xsl:value-of select="@sizey"/>px;
            }

            #alleinselnaufderkarte #<xsl:value-of select="picture/@name"/> .infobox
            {
            top: <xsl:value-of select="@posy - $targety - 5"/>px ;
            left:<xsl:value-of select="$targetx - @posx"/>px;
            }
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

    <xsl:template match="paragraph" name="paragraph">
        <xsl:element name="p">
            <xsl:attribute name="class">paragraph</xsl:attribute>
            <xsl:if test="@versalien = 'true'">
                <xsl:attribute name="id">versalien</xsl:attribute>
            </xsl:if>
            <xsl:if test="@headline != ''">
                <xsl:element name="span">
                    <xsl:attribute name="class">h1</xsl:attribute>
                    <xsl:value-of select="@headline"/>
                </xsl:element>
            </xsl:if>
            <!-- Inhalt des Matches hier ausgeben -->
            <xsl:value-of select="." disable-output-escaping="yes"/>
        </xsl:element>
        
       
    </xsl:template>

    <xsl:template name="picture" match="picture">
        <xsl:param name="class"/>
        <xsl:element name="img">
            <xsl:if test="$class != ''">
                <xsl:attribute name="class">
                    <xsl:value-of select="$class"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:attribute name ="src">
                ../img/inhalt/<xsl:value-of select="@file"/>
            </xsl:attribute>
            <xsl:attribute name="alt">
                <xsl:value-of select="@name"/>
            </xsl:attribute>
        </xsl:element>
    </xsl:template>

    <xsl:template name="table" match="table">
        <!-- IDs für die Tabelle, erste Reihe, erste Spalte -->
        <xsl:param name="idTable"/>
        <xsl:param name="classTable"/>
        <xsl:param name="idFirstRow"/>
        <xsl:param name="classFirstRow"/>
        <xsl:param name="idFirstColumn"/>
        <xsl:param name="classFirstColumn"/>
        <xsl:param name="classFirstRowFirstColumn"/>
        
        <xsl:element name="table">  
            <!-- Alternativ können diese auch direkt für die jeweiligen Elemente übergeben werden übergeben werden -->
            <xsl:call-template name="testIDClass"/>
            <!-- Für späteren Zugriff innerhalb der Children merken -->
            <xsl:variable name="root" select="."/>
            <xsl:if test="$idTable != ''">
                <xsl:attribute name="id">
                    <xsl:value-of select="$idTable"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="$classTable != ''">
                <xsl:attribute name="class">
                    <xsl:value-of select="$classTable"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:element name="tbody">
                <xsl:for-each select="./row">
                    <xsl:element name="tr">
                        <xsl:if test="$idFirstRow != '' and (position() = 1)">
                            <xsl:attribute name="id">
                                <xsl:value-of select="$idFirstRow"/>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:if test="$classFirstRow != '' and (position() = 1)">
                            <xsl:attribute name="class">
                                <xsl:value-of select="$classFirstRow"/>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:call-template name="testIDClass"/>
                        <xsl:variable select="." name="parentRow"/>
                        <xsl:variable select="position()" name="parentRowPosition"/>
                        <xsl:for-each select="column">
                            <xsl:element name="td">
                                <!-- Sollte eine Zeile nur eine Spalte enthalten, wird ein Colspan gesetzt -->
                                <xsl:if test="count($parentRow/column) = 1">
                                    <xsl:for-each select="$root/row">
                                        <xsl:if test="count(column) != 1">
                                            <xsl:attribute name="colspan">
                                                <xsl:value-of select="count(column)"/>
                                            </xsl:attribute>
                                        </xsl:if>
                                    </xsl:for-each>
                                </xsl:if>
                                <xsl:if test="$idFirstColumn != '' and (position() = 1)">
                                    <xsl:attribute name="id">
                                        <xsl:value-of select="$idFirstColumn"/>
                                    </xsl:attribute>
                                </xsl:if>
                                <xsl:if test="$classFirstColumn != '' and (position() = 1)">
                                    <xsl:attribute name="class">
                                        <xsl:value-of select="$classFirstColumn"/>
                                    </xsl:attribute>
                                </xsl:if>
                                <xsl:if test="$classFirstRowFirstColumn != '' and (position() = 1) and($parentRowPosition = 1)">
                                    <xsl:attribute name="class">
                                        <xsl:value-of select="$classFirstRowFirstColumn"/>
                                    </xsl:attribute>
                                </xsl:if>
                                <xsl:call-template name="testIDClass"/>
                                <xsl:value-of select="."/>
                            </xsl:element>
                        </xsl:for-each>
                    </xsl:element>
                </xsl:for-each>
            </xsl:element>
        </xsl:element>
        
    </xsl:template>

    <xsl:template name="testIDClass">
        <xsl:call-template name="testID"/>
        <xsl:call-template name="testClass"/>
    </xsl:template>
    
    <xsl:template name="testID">
        <xsl:if test="@id != ''">
            <xsl:attribute name="id">
                <xsl:value-of select="@id"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
        
    <xsl:template name = "testClass">
        <xsl:if test="@class != ''">
            <xsl:attribute name="class">
                <xsl:value-of select="@class"/>
            </xsl:attribute>
        </xsl:if>
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
