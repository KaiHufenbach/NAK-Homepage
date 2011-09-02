<?xml version="1.0" encoding="utf-8"?>
<!-- Autor: Kai Hufenbach -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns="http://www.w3.org/1999/xhtml">
    <!-- encoding="UTF-8"  darf hier nicht stehen, sonst bekommt der IE 8 Umlautprobleme-->
    <xsl:output method="xml" version="1.0" indent="yes" doctype-public="-//W3C//DTD XHTML 1.1//EN" doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd"/>
    
    <!-- Template mit Match auf das Root-Element, um  Seitenübergreifende Informationen zur Verfügung zu stellen -->
    <xsl:template match="page">
        <xsl:variable name="chapter" select="pageInfo/@chapter"/>
        <xsl:variable name="pagenr" select="pageInfo/@nr"/>
        <xsl:variable name="type" select="pageInfo/@typ"/>
        <xsl:variable name="lastPage" select="pageInfo/@lastPage"/>
        <xsl:variable name="chapters" select="document('../chapters.xml')"/>
            
        
        
        <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="de">
            <head>
                <title>
                    Bahamas - <xsl:value-of select="$chapter"/>
                </title>
                <style type="text/css" media="screen">
                  @import"../css/standardStyle.css";
                  <!-- Code Snippet für Dictionary Nutzung: leider ist hier die Duplette im Code notwendig. Funktionen werden vom IE + FF nicht verstanden... <xsl:call-template geht nicht mit select="$..." xsl:apply-templates hat im IE + FF einen Bug: Parameter können nicht übergeben werden (laut W3C ist das möglich) -->
                  <xsl:for-each select="$chapters/chapters/chapter">
                    <xsl:if test="@name = $chapter">
                      <xsl:variable name="chapterNr" select="@nr"/>
                      <xsl:call-template name="navigationStyle">
                        <xsl:with-param select="$chapterNr" name="id"/>
                      </xsl:call-template>
                        <!-- Verschiebung des Inhaltes, je nachdem, auf welcher Seite man sich befindet. -->
                        <!-- Da in diesem Falle mit absoluten Angaben gearbeitet wird, kann über margin der Inhalt problemlos relativ verschoben werden -->
                        <xsl:if test="@xConstraint != ''">
                            #logo, #inhalt, #ecke{margin-left: <xsl:value-of select="@xConstraint"/>px;}
                        </xsl:if>
                        <xsl:if test="@yConstraint != ''">
                            #logo, #inhalt, #ecke{margin-top: <xsl:value-of select="@yConstraint"/>px;}
                        </xsl:if>
                    </xsl:if>
                  </xsl:for-each>
                  <!-- Ende des Snippets-->
                    
                    <!-- Dynamische Style-Imports für Steckbrief -->
                    <xsl:if test="$type = 'overview'">
                        <xsl:call-template name="overviewStyle"/>
                    </xsl:if>
                </style>
                
                <style type="text/css" media="print">
                    @import"../css/printStyle.css";
                </style>

                <xsl:if test="$type = 'quiz'">
                    <script type="text/javascript">
                        <!-- Hier folgt kein XHTML, somit ist der Code valide und das Javascript wird als CharacterData für sich genommen, für Browser, die das nicht verstehen ist der Kommentar gedacht. -->
                        <xsl:text disable-output-escaping="yes">/* &lt;![CDATA[ */</xsl:text>  
                        <xsl:text disable-output-escaping="yes">
                        //ist Javascript nicht aktiviert, wird nichts eingefügt
                       
                        //Die folgenden Objekte müssen an dieser Stelle schon deklariert werden, damit diese darunter schon nutzbar sind, sonst kann es zu Loading Problemen kommen                        

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

                        //Wird via XSLT gesetzt
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
  
            <!-- Erzeugt das Body Tag und fügt beim Quiz noch die onload-Action hinzu -->
            <xsl:element name="body">
                <xsl:if test="$type ='quiz'">
                    <xsl:attribute name="onload">initialize()</xsl:attribute>
                </xsl:if>

                <!-- Box im Hintergrund zur Realisierung des Abnehmenden Seitenstapels -->
                <div id="buch">
                    <xsl:element name="img">
                        <xsl:attribute name="src">
                            <!-- Nutzung des Dictionaries -->
                            <xsl:for-each select="$chapters/chapters/chapter">
                                <!-- Um mit der aktuellen Kapitelnummer die richtige Hintergrundseite einzufügen -->
                                <xsl:if test="@name = $chapter">
                                    ../img/layout/buch<xsl:value-of select="@nr"/>.jpg
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:attribute>
                        <xsl:attribute name="alt">
                            Buch
                        </xsl:attribute>
                    </xsl:element>
                </div>

                <div id="navigation">
                <!-- Code Snippet für Dictionary Nutzung -->
                <xsl:for-each select="$chapters/chapters/chapter">
                  <xsl:if test="@name = $chapter">
                    <xsl:variable name="chapterNr" select="@nr"/>
                      <!-- ... zur Erzeugung des Menüs. -->
                    <xsl:call-template name="menu">
                      <xsl:with-param select="$chapterNr" name="id"/>
                      <xsl:with-param select="$pagenr" name="pagenr"/>
                    </xsl:call-template>
                  </xsl:if>
                </xsl:for-each>
                <!-- Ende des Snippets-->
              </div>

             <!-- Stellt die Möglichkeit zur Verfügung, weiterblättern zu können, wenn die letzte Seite nicht erreicht ist. Zuordnung erfolgt über Namenskonventionen. -->   
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

              <!-- Nur für Seiten unterhalb von Start wird die Option des Zurückblätterns auch vorgesehen. -->
              <xsl:if test ="$chapter != 'Start'"> 
              <div id="zurückblättern">
                <xsl:if test="$pagenr = 1">
                  <div class="linksBlatt">
                      <xsl:attribute name="id">
                          <!-- Code Snippet: Durchlauf des Dictionaries -->
                          <xsl:for-each select="$chapters/chapters/chapter">
                              <xsl:if test="@name = $chapter">
                                  <!-- ... und setzen der entsprechenden Seitenzahl ohne Aufklappfunktion -->
                                  <xsl:variable name="chapterNr" select="@nr"/>ohneAufklapp<xsl:value-of select ="$chapterNr"/>
                              </xsl:if>
                          </xsl:for-each>
                          <!-- Ende Code Snippet -->
                      </xsl:attribute>
                  </div>
                </xsl:if>
                  <!-- Zurückblättern, wenn die Seitennummer des Kapitels > 1 -->
                <xsl:if test="$pagenr > 1">
                  <xsl:element name="a">
                    <xsl:attribute name="id">
                            <xsl:for-each select="$chapters/chapters/chapter">
                                <xsl:if test="@name = $chapter">
                                    <xsl:variable name="chapterNr" select="@nr"/>aufklapp<xsl:value-of select ="$chapterNr"/>
                                </xsl:if>
                            </xsl:for-each>
                    </xsl:attribute>
                      <xsl:attribute name="class">linksBlatt</xsl:attribute>
                    <xsl:attribute name="href">
                        <!-- Link wird über Namenskonventionen gesetzt -->
                      <xsl:value-of select="$chapter"/>_<xsl:value-of select="$pagenr - 1"/>.xml
                    </xsl:attribute>
                    Zurückblättern
                  </xsl:element>
                </xsl:if>
              </div>
              </xsl:if>

                <!-- Einbau des entsprechenden Seitenlogos über den Seitennamen -->
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
                  
                <!-- Behandlung verschiedener Seitentypen. Mit besonderen Template aufrufen. -->
                <!-- An dieser Stelle ist somit eine Übergabe von Parametern möglich -->
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

    <!-- Template für das Menü -->
  <xsl:template name="menu">
    <xsl:param name ="id"/>
      <xsl:param name="pagenr"/>
      <xsl:variable name="chapters" select="document('../chapters.xml')"/>
      <!-- Nutzung des Dictionary Snippets -->
    <xsl:for-each select="$chapters/chapters/chapter">
        <!-- Der IE benötigt im a Tag einen Inhalt ... sonst verrutscht alles, desweiteren wird so Barrierefreiheit hergestellt-->
      <xsl:element name='a'>
          <!-- Verlinkung erfolgt über Namenskonventionen -->
        <xsl:attribute name='href'><xsl:value-of select="@name"/>_1.xml</xsl:attribute>
        <xsl:attribute name='class'><xsl:if test='$id > @nr or ($id = @nr and ($pagenr > 1))'>tisch_</xsl:if>sticky</xsl:attribute>
        <xsl:attribute name='id'>
            <!-- Alle die vor der aktuellen ID liegen, oder wenn die Seite fortgeschritten ist, werden auf dem Tisch liegend angezeigt. Bei gleicher Nummer und Seite = 1 wird auf aktiv gesetzt. -->
            <xsl:if test='$id > @nr or ($id = @nr and ($pagenr > 1))'>tisch_</xsl:if><xsl:value-of select="@name"/><xsl:if test="$id = @nr and ($pagenr = 1)">Active</xsl:if></xsl:attribute>
          <xsl:value-of select="@name"/>
      </xsl:element>
    </xsl:for-each>
      <!-- Ende Dictionary -->
  </xsl:template>


  <!-- Template für CSS-Style Ergänzungen, die das Menü betreffen. -->
  <xsl:template name="navigationStyle">
    <xsl:param name="id"/>
      <xsl:variable name="chapters" select="document('../chapters.xml')"/>
      <!-- Alle Chapters durchgehen, die Styleergänzungen sollen nicht größer werden, als nöltig -->
    <xsl:for-each select="$chapters/chapters/chapter">
        <!-- ... und entsprechende Werte für die Navigationselemente setzen -->
        <!-- Ist die aktuelle KapitelID kleienr als das Element, so sind die Stickys am/imBuch -->
        <xsl:if test="@nr > $id">
            <!-- Die Verschiebung kann aufgrund von position:absolute in Y-Richtung mit Margin-Top erfolgen. So bleibt die Flexibilität erhalten, die Größe der Elemente muss jedoch im XSLT hinterlegt werden... -->
            #<xsl:value-of select="@name"/>{background-image:url('../img/layout/nav_<xsl:value-of select="@name"/>_passiv.png'); margin-top: <xsl:value-of select="70*@nr"/>px ;}
            #<xsl:value-of select="@name"/>:hover{background-image:url('../img/layout/nav_<xsl:value-of select="@name"/>_hover.png');}
        </xsl:if>
        <!-- Ist die aktuelle KapitelId größer, so liegen die Stickys auf dem Tisch -->
        <xsl:if test="$id > @nr">
            #tisch_<xsl:value-of select="@name"/>{background:url('../img/layout/nav_tisch_<xsl:value-of select="@name"/>.png') no-repeat 0 0; margin-top: <xsl:value-of select="70*@nr"/>px ;}
            #tisch_<xsl:value-of select="@name"/>:hover{background:url('../img/layout/nav_tisch_<xsl:value-of select="@name"/>_hover.png') no-repeat 0 0;}
        </xsl:if>
        <!-- Sind die IDs gleich, ist das Element aktiv -->
        <xsl:if test="$id = @nr">
            #<xsl:value-of select="@name"/>Active{background-image:url('../img/layout/nav_<xsl:value-of select="@name"/>_aktiv.png'); margin-top: <xsl:value-of select="70*@nr"/>px ;}
        </xsl:if>
        
    </xsl:for-each>
      <!-- Für das Mehr- und Wenigerwerden der Seiten wird nur die Hintergrundgrafik ausgetauscht -->
      #ohneAufklapp<xsl:value-of select="$id"/>{background:#000 url('../img/layout/aufklapp_ohneknick_<xsl:value-of select="$id"/>.jpg') no-repeat 0 0;}
      #aufklapp<xsl:value-of select="$id"/>{background:#000 url('../img/layout/aufklapp_klein_<xsl:value-of select="$id"/>.jpg') no-repeat 0 0;}
      #aufklapp<xsl:value-of select="$id"/>:hover{background:#000 url('../img/layout/aufklapp_gross_<xsl:value-of select="$id"/>.jpg') no-repeat 0 0;}
  </xsl:template>

    <!-- Template für den Steckbrief -->
    <xsl:template name ="overview">
        <div id="alleinselnaufderkarte">
            <xsl:apply-templates select="overviewPictureArea"/>
        </div>
        <!-- Workaround für <xsl:call-template select="..." mit Parameterübergabe -->
        <xsl:for-each select="table">
            <xsl:call-template name="table">
                <xsl:with-param name="idTable" select="'statische_steckbrieftabelle'"/>
                <xsl:with-param name="classFirstColumn" select="'steckbrief_links'"/>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>

  <!-- Template für eine hoverArea -->
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
                  <!-- Der IE 8 hat ein Problem mit dem Parsen von leeren Divboxen. Diese werden ansonsten verschachtelt -->
                  a
              </div>
                  <!-- Über dieses Konstrukt kann ein bestimmtes Element angefahren werden, da xsl:apply-templates mit with Param nicht funktioniert. Somit ist ein Funktionales Programmieren leider nicht möglich (Die Funktionen bekommen Side-Effects).  -->
                  <xsl:for-each select="picture">
                      <xsl:call-template name="picture">
                          <xsl:with-param name="class">hoverbild</xsl:with-param>
                      </xsl:call-template>
                  </xsl:for-each>
              <div class="infobox">
                  <!-- Dieses Konstrukt ist ein Workaround für <xsl:apply-templates select=... ><xsl:with-param ...> ... imperativ gelöst -->
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
            <!-- Erzeugung eines Hoverelements mit den Werten aus der XML Datei -->
            #<xsl:value-of select="picture/@name"/>{
            width: <xsl:value-of select="@sizex"/>px;
            height: <xsl:value-of select="@sizey"/>px;
            top: <xsl:value-of select="@posy"/>px;
            left: <xsl:value-of select="@posx"/>px;
            }

            <!-- Für jedes Hover Element wird ein Filler erzeugt, mit derselben Größe -->
            #<xsl:value-of select="picture/@name"/>_filler{
            width: <xsl:value-of select="@sizex"/>px;
            height: <xsl:value-of select="@sizey"/>px;
            }

            <!-- Realisiert die relative Verschiebung der Infobox -->
            #alleinselnaufderkarte #<xsl:value-of select="picture/@name"/> .infobox
            {
            top: <xsl:value-of select="$targety - @posy - 5"/>px ;
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

    <!-- Template für Paragrafen, kann allgemein über Pattern-Matching angesprochen werden -->
    <xsl:template match="paragraph" name="paragraph">
        <xsl:element name="p">
            <xsl:attribute name="class">paragraph</xsl:attribute>
            <xsl:if test="@headline != ''">
                <xsl:element name="span">
                    <xsl:attribute name="class">h1</xsl:attribute>
                    <xsl:value-of select="@headline"/>
                </xsl:element>
            </xsl:if>
            <!-- Inhalt des Matches hier ausgeben -->
       <!--  <xsl:value-of select="." disable-output-escaping="yes"/> -->
            <xsl:apply-templates/>    
        </xsl:element>
    </xsl:template>

    <!-- Möglichkeit, in einem Paragrafen für Zeilenumbrüche -->
    <xsl:template name="break" match="br">
        <br/>
    </xsl:template>
    <!-- Paragraf Ende -->
    
    <!-- Fügt ein Bildelement ein -->
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

    <!-- Tabellen-Template  -->
    
    <xsl:template name="table" match="table">
        <!-- IDs für die Tabelle, erste Reihe, erste Spalte als mögliche Parameterwerte -->
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
                        <!-- Die Parameterwerte werden angezogen, wenn die jeweilige Bedingung erfüllt und diese auch tatsächlich gesetzt wurden. -->
                        <!-- Diese können jedoch noch über besondere Benutzereingaben überschrieben werden. -->
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

    <!-- Kombiniertes Template zum Testen auf Attribut ID u. Klasse -->
    <xsl:template name="testIDClass">
        <xsl:call-template name="testID"/>
        <xsl:call-template name="testClass"/>
    </xsl:template>

    <!-- Test auf vorhandene ID + setzen von dieser -->
    <xsl:template name="testID">
        <xsl:if test="@id != ''">
            <xsl:attribute name="id">
                <xsl:value-of select="@id"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>

    <!-- Test auf vorhandene Klasse + setzen von dieser -->
    <xsl:template name = "testClass">
        <xsl:if test="@class != ''">
            <xsl:attribute name="class">
                <xsl:value-of select="@class"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    
    <!-- Ende: Tabellen-Template -->

</xsl:stylesheet>
