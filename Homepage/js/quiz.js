/* <![CDATA[ */
var questions;
var correct;
var form;

//Array für das Alphabet, um eine Nummerierung der einzelnen Frageoptionen zu realisieren
var alphabet = new Array("a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z");



function initialize() {
    //Einfügen erfolgt hier via XSLT, der Rest ist generisch
    questions = new Array();
    selectQuestions(questionPool);
    correct = 0;
    form = new Form(amountOfQuestions);
    generateHTML();
}

function createElement(name) {
    //Um im richtigen Namespace zu agieren, sonst werden die CSS Regeln nicht angezogen, ist folgendes notwendig:
    //Der IE interpretiert dies jedoch anders:
    if (navigator.appName == "Microsoft Internet Explorer") {
        return document.createElement(name);
    } else {
        return document.createElementNS("http://www.w3.org/1999/xhtml", name);
    }
}

function generateHTML() {

    //Der IE schießt hier den Bock: Kommt ein Table Tag rein, so interpretiert der IE ein tbody hinein
    //dieses TBody wird benötigt, da sonst die Tabelle nicht richtig als Tabelle interpretiert wird und diese insbesondere bei rowspan verrutscht
    //Werden die Tags jedoch über Javascript hinzugefügt, so interpretiert der IE das tbody tag nicht hinzu. So nimmt das Unglück seinen Lauf...
    var table = createElement("tbody");
    for (var i = 0; i < questions.length; i++) {

        var tr = createElement("tr");
        var td = createElement("td");
        td.setAttribute("class", "frage");
        td.setAttribute("colspan", "4");
        td.appendChild(document.createTextNode(questions[i].question));
        tr.appendChild(td);
        table.appendChild(tr);

        var firstRun = true;



        for (var j = 0; j < questions[i].options.length; j++) {
            tr = createElement( "tr");
            if (firstRun) {
                firstRun = false;
                td = createElement( "td");
                td.setAttribute("rowspan", " " + questions[i].options.length + " ");
                td.setAttribute("class", "frageBild");
                tr.appendChild(td);
                if (questions[i].picture != null) {
                    var img = createElement("img");
                    img.setAttribute("src", "../img/inhalt/" + questions[i].picture.graphic);
                    img.setAttribute("alt", questions[i].picture.text);
                    img.setAttribute("class", "quizbild");
                    td.appendChild(img);
                }
                firstRun = false;
            }
            table.appendChild(tr);

            td = createElement( "td");
            tr.appendChild(td);
            td.setAttribute("class", "antwort");
            td.appendChild(document.createTextNode(alphabet[j] + ") " + questions[i].options[j]));

            td = createElement( "td");
            tr.appendChild(td);
            var radiobutton = createElement( "div");
            radiobutton.setAttribute("class", "radiobutton");
            //Auf diese Weise entsteht eine valide, technisch auswertbare ID
            radiobutton.setAttribute("id", hash(questions[i].question)+(j + ''));
            radiobutton.setAttribute("onclick", "form.set(" + i + "," + j + ")"); 
            td.appendChild(radiobutton);

            td = createElement( "td");
            td.setAttribute("class", "result");
            td.setAttribute("id",hash(questions[i].question+(questions[i].options[j])));
            tr.appendChild(td);

           
        }


        //elem.setAttribute("class", "question");
        //MD5 wird an dieser Stelle verwendet, um den Fragetext ohne Sonderzeichen einzufügen
        //elem.setAttribute("id", hash(questions[i].question));
    }

    var inhalt = createElement("div");
    var tableTag = createElement("table");
    var ergebnis = createElement("div");
    ergebnis.setAttribute("id", "ergebnis");

    tableTag.appendChild(table);
    inhalt.appendChild(tableTag);
    inhalt.appendChild(ergebnis);
    inhalt.setAttribute("id", "quizinhalt");

    tr = createElement( "tr");
    table.appendChild(tr);
    td = createElement("td");
    td.setAttribute("colspan", "2");
    tr.appendChild(td);
    var div = createElement( "div");
    div.setAttribute("id", "zuruecksetzen");
    div.setAttribute("onclick", "resetContent()");
    td.appendChild(div);
    div = createElement("div");
    div.setAttribute("id", "neueFragen");
    div.setAttribute("onclick", "newQuestions()");
    td.appendChild(div);
    td = createElement("td");
    td.setAttribute("colspan", "2");
    tr.appendChild(td);
    div = createElement( "div");
    div.setAttribute("id", "abschicken");
    div.setAttribute("class", "passiv");
    td.appendChild(div);

    document.getElementsByTagName("body")[0].appendChild(inhalt);
}

//Wählt, wenn mehr als (amountOfQuestions) Fragen vorhanden sind diese Anzahl aus
function selectQuestions(questionPool) {
    var j = amountOfQuestions;

    if (amountOfQuestions > questionPool.length) {
        j = questionPool.length;
    }

    for (var i = 0; i < j; i++) {
        addToQuestions(removeRandomArrayElement(questionPool));
    }
}

//Fügt die Fragen zur Auswahl hinzu und mischt die Antwortmöglichkeiten
function addToQuestions(question) {
    shuffleOptions(question);
    questions.push(question);
}

//Mischt die Antwortoptionen einer Frage
function shuffleOptions(question) {
    var options = new Array();
    for (var i = 0; i < question.options.length; i++) {
        options.push(removeRandomArrayElement(question.options));
    }
    question.options = options;
}

//Wählt ein zufälliges Element eines Arrays aus und entfernt dieses aus dem Array. null Elemente werden hier schon ignoriert.
//Dies Funktioniert nur, da Javascript auf Verweissemantik aufbaut.
function removeRandomArrayElement(array) {
    var elem = null;
    var rand;
    while (elem == null) {
        rand = random(array.length);
        elem = array[rand];
    }
    array[rand] = null;
    return elem;
}

//Erzeugt eine Zufallszahl von 0 bis to (exkl.). Angelehnt an: http://www.javascriptkit.com/javatutors/randomnum.shtml
function random(to) {
    return Math.floor(Math.random() * to);
}


//Somit wird verhindert, dass ein MD5 hash mit einer Zahl anfängt
function hash(string) {
    return 'x' + MD5(string);
}



//Wertet die Antworten generisch anhand von 'answers' aus
function handIn() {
    correct = 0;
    for (var i = 0; i < questions.length; i++) {
        
            //Führt die Korrektur der Fragen aus, dabei wird ein question Objekt erzeugt, dass die Frage und die angekreuzte Antwort enthält. Zusätzlich wird übergeben, ob diese Antwort richtig ist.
            resetResult(i);
            correctQuestion(new question(questions[i].question, form.get(i)), form.get(i) == questions[i].answer);

        }

    for (var i = 0; i < ranks.length; i++) {
        if (ranks[i].from <= correct && correct <= ranks[i].to) {
            //Ist schon ein Bild vorhanden?
            var pic = document.getElementById("resultPicture");
            //Nein?
            if(pic == null){
                pic = createElement("img");
                document.getElementById("ergebnis").appendChild(pic);
                pic.setAttribute("id", "resultPicture");
            }
            //Dann gibt es das spätestens jetzt
            pic.setAttribute("src", "../img/inhalt/" + ranks[i].graphic);
            pic.setAttribute("alt", ranks[i].text);
        }
    }
}

//Prüft ein Array von Radio Inputs
//Gibt null zurück, wenn kein Kreuz gesetzt wurde, ansonsten die Stelle des Kreuzes 
function searchSelectedOption(radios) {
    for (var o = 0; o < radios.length; o++) {
        if (radios[o].checked) {
            return o;
        }
    }
    return null;
}

//Um die Symbole richtig setzen zu können, wird die Frage und die angekreuzte Antwort, sowie deren Richtigkeit übergeben
//Frage + Antwort wird für den Zugriff auf die ID der Tabelle benötigt
function correctQuestion(q, answerCorrect) {
    var img = createElement( "img");
    var elem = document.getElementById(hash(q.question + q.answer));
    if (answerCorrect) {
        correct++;
        img.setAttribute("src", "../img/layout/richtig.png");
        img.setAttribute("alt", "richtig");
        elem.appendChild(img);
    } else {
        img.setAttribute("src", "../img/layout/falsch.png");
        img.setAttribute("alt", "falsch");
        elem.appendChild(img);
    }

}

//Repräsentiert das Formular
function Form(size) {
    this.radios = new Array();
    this.set = set;
    this.reset = reset;
    this.get = get;
    this.getTicks = getTicks;

    for (var i = 0; i < size; i++) {
        this.radios.push(new FormularElement());
    }

    function reset() {
        for (var i = 0; i < this.radios.length; i++) {
            this.radios[i].reset();
        }
    }

    //Setzt im Datenmodell des Bogens
    function set(i, value) {
        this.radios[i].setValue(questions[i].options[value]);
        //setzt den Hintergrund und schaltet über die Klasse den hover Effekt aus.

        //zuerst die schon bestehenden zurücksetzen:
        resetQuestionTicks(i);

        var hashValue = hash(questions[i].question);

        //geklickten button setzen:
        document.getElementById(hashValue + (value + '')).setAttribute("class", "radiobutton_active");

        //Ggf. abschicken auf aktiv setzen
        if (this.getTicks() == questions.length) {
            document.getElementById("abschicken").setAttribute("class", "aktiv");
            document.getElementById("abschicken").setAttribute("onclick", "handIn()");
        } else {
            document.getElementById("abschicken").setAttribute("class", "passiv");
            document.getElementById("abschicken").removeAttribute("onclick");
        }

    }

    //Gibt die Anzahl von Kreuzen im Datenmodell zurück
    function getTicks() {

        var ticks = 0;
        for (var i = 0; i < this.radios.length; i++) {
            if (this.radios[i].value != null) {
                ticks++;
            }
        }

        return ticks;
    }

    function get(i) {
        return this.radios[i].value;
    }

}

//Setzt die Haken zur übergebenen Fragennummer zurück.
function resetQuestionTicks(questionNr) {
    var j = 0;
    var hashValue = hash(questions[questionNr].question);
    while (document.getElementById(hashValue + (j + '')) != null) {
        document.getElementById(hashValue + (j + '')).setAttribute("class", "radiobutton");
        j++;
    }
}

//Setzt das Ergebnis einer angegebenen Frage zurück
function resetResult(questionNr) {
    for (var j = 0; j < questions[questionNr].options.length; j++) {
        var elem = document.getElementById(hash(questions[questionNr].question + questions[questionNr].options[j]));
        if (elem.firstChild != null) {
            document.getElementById(hash(questions[questionNr].question + questions[questionNr].options[j])).removeChild(elem.firstChild);
        }
    }
}

//Repräsentiert ein FormularElement
function FormularElement() {
    this.value = null;
    this.setValue = setValue;
    this.reset = reset;

    function setValue(value) {
        this.value = value;
    }

    function reset() {
        this.value = null;
    }
}

//Setzt den Inhalt des Formulars zurück
function resetContent() {
    //Model zurücksetzen
    form.reset();

    //Correct Zähler zurücksetzen
    corret = 0;

    //View zurücksetzen: Felder
    for (var i = 0; i < questions.length; i++) {
        resetQuestionTicks(i);
        resetResult(i);
    }
    //AbschickenButton deaktivieren
    document.getElementById("abschicken").setAttribute("class", "passiv");
    document.getElementById("abschicken").removeAttribute("onclick");
    var resultPic = document.getElementById("resultPicture");
    if (resultPic != null) {
        document.getElementById("ergebnis").removeChild(resultPic);
    }
    
}

//Setzt das Formular zurück und gibt neue Fragen
function newQuestions() {
    document.location = document.location;
}

/* ]]> */