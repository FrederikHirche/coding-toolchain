# AUDIOSCRIPT — AI Development Tool Chain

> Quelldokument für NotebookLM (notebooklm.google.com) zur Erstellung einer Produktbeschreibung
> bzw. eines Audio-Überblicks ("Audio Overview"). Dieses Dokument ist als durchgehender,
> erzählender Text geschrieben — bewusst nicht als reine Tabellen- oder Stichpunktsammlung —
> damit ein Sprachmodell daraus einen natürlich klingenden gesprochenen Beitrag erzeugen kann.
> Es beschreibt Zweck, Nutzung, Vorteile und Nachteile der Tool Chain aus einer produktnahen,
> für Außenstehende verständlichen Perspektive.

---

## 1. Elevator Pitch: Was ist das eigentlich?

Stell dir vor, du hast eine Idee für ein Softwareprodukt. Nicht mal eine besonders ausgereifte
Idee — nur ein Problem, das gelöst werden muss, und ein ungefähres Gefühl dafür, wer davon
profitieren würde. Normalerweise beginnt jetzt ein mühsamer Prozess: Du müsstest ein Team aus
Product Manager, Business Analyst, Softwarearchitekt, UX-Designerin, Frontend- und
Backend-Entwicklern, QA-Ingenieuren, Code-Reviewern und technischen Autoren zusammenstellen —
und dann all diese Rollen koordinieren, damit am Ende etwas Kohärentes, Getestetes und
Dokumentiertes entsteht.

Die AI Development Tool Chain ist der Versuch, genau diesen Prozess mit einem einzigen
KI-Assistenten — konkret Claude Code — nachzubilden. Es handelt sich nicht um eine
Programmbibliothek und nicht um ein SaaS-Produkt, sondern um ein sorgfältig strukturiertes
Regelwerk aus Textdateien: Rollenbeschreibungen, Vorlagen, Protokolle und Automatisierungs-Hooks,
die zusammen festlegen, WIE eine KI in der Rolle unterschiedlicher Fachexperten arbeitet, WANN
welche Rolle aktiv wird, und WAS am Ende jeder Phase als nachvollziehbares Artefakt
herauskommt. Man aktiviert eine Rolle mit einem einzigen Tastaturbefehl — einem sogenannten
Slash Command wie `/kickoff` oder `/architect` — und die KI übernimmt für die Dauer dieser
Sitzung vollständig die Denkweise, die Prioritäten und die Ausgabeformate dieser Rolle.

Das Ergebnis ist ein Softwareentwicklungsprozess, der von der ersten Stakeholder-Idee bis zum
produktiven Release durchgängig strukturiert ist — inklusive Qualitätskontrollen zwischen jeder
Phase, die verhindern sollen, dass unvollständige Arbeit einfach in die nächste Phase
durchgereicht wird.

---

## 2. Das Problem, das gelöst werden soll

Wer schon einmal versucht hat, mit einem KI-Assistenten direkt "baue mir eine App" zu sagen,
kennt das typische Ergebnis: Der Assistent springt sofort in die Implementierung, trifft dabei
implizite Annahmen über Technologie, Zielgruppe und Umfang, die nie explizit gemacht oder
hinterfragt wurden. Anforderungen bleiben vage, Architekturentscheidungen werden nebenbei und
unbegründet getroffen, Tests werden — wenn überhaupt — nachträglich und oberflächlich
geschrieben, und am Ende gibt es keine Dokumentation, die ein Mensch ohne Programmierkenntnisse
verstehen könnte.

Die Tool Chain adressiert das, indem sie erzwingt, dass jede dieser Fragen explizit und in der
richtigen Reihenfolge gestellt wird — durch spezialisierte Rollen, die jeweils nur einen
Ausschnitt der Verantwortung tragen, und durch Übergabepunkte, an denen geprüft wird, ob die
vorherige Rolle ihre Hausaufgaben tatsächlich gemacht hat.

---

## 3. Die Architektur: Drei Schichten

Die Tool Chain selbst ist in drei klar getrennte Schichten aufgeteilt.

Die erste Schicht ist die **Meta-Ebene** — die Tool Chain selbst. Hier liegen die
Agenten-Definitionen mit ihren Rollenbeschreibungen und System-Prompts, die Artefakt-Vorlagen,
mit denen jedes Dokument einheitlich strukturiert wird, die Protokolle für Übergaben,
Qualitäts-Gates und den Artefakt-Lebenszyklus, sowie Git-Automatisierungs-Hooks. Diese Schicht
definiert, WIE entwickelt wird.

Die zweite Schicht ist die **Orchestrierung** — die Slash Commands, die einzelne Phasen
aktivieren, und die Workflow-Definitionen, die festlegen, in welcher Reihenfolge Phasen
aufeinander folgen und welche Gate-Kriterien zwischen ihnen liegen. Diese Schicht steuert, WANN
welcher Agent aktiv wird.

Die dritte Schicht ist die **Projekt-Ebene**. Jedes konkrete Softwareprojekt, das mit der Tool
Chain entwickelt wird, bekommt einen eigenen Ordner unter `projects/<projektname>/` — und ist
technisch sogar ein komplett eigenständiges Git-Repository, getrennt vom Tool-Chain-Repository
selbst. Das ist ein bewusster Designentscheid: Die Tool Chain ist wiederverwendbare
Infrastruktur, die Projekte sind Nutzlast. Diese Schicht enthält, WAS in einem konkreten Projekt
tatsächlich entsteht.

---

## 4. Die elf Rollen — ein Entwicklungsteam aus einer Feder

Die Tool Chain modelliert ein vollständiges, technologieneutrales Entwicklungsteam. Jede Rolle
hat eine klar abgegrenzte Verantwortung, eigene Eingaben, eigene Ausgaben und ein eigenes
Qualitätskriterien-Set, das vor Abschluss einer Sitzung geprüft wird.

Der **Product Manager** ist der erste Ansprechpartner. Er führt ein strukturiertes,
fünf-rundiges Stakeholder-Interview — Problemraum und Vision, Nutzer und Stakeholder, Scope und
Abgrenzung, Erfolgskriterien und Messbarkeit, Constraints und Risiken — und verdichtet das
Ergebnis zu einem Stakeholder Brief mit MoSCoW-Priorisierung und benannten Top-Risiken.

Der **Business Analyst** übersetzt diesen Stakeholder Brief in entwicklungsfähige Anforderungen:
ein Requirements-Dokument sowie einzelne User Stories im klassischen "Als Rolle möchte ich Ziel,
damit Nutzen"-Format, jede mit mindestens drei Akzeptanzkriterien im Given/When/Then-Stil.

Der **Software Architect** trifft alle Technologieentscheidungen und dokumentiert sie als
Architecture Decision Records — kurz ADRs. Jede Entscheidung muss begründet sein, inklusive der
verworfenen Alternativen. Bemerkenswert ist eine bewusste Grundhaltung der Tool Chain:
Microservices sind die Standardpräferenz gegenüber einem Monolithen, und wer sich für einen
Monolithen entscheidet, muss diese Abweichung explizit rechtfertigen — nicht umgekehrt. Bei
Containerisierung schreibt der Architekt zusätzlich eine verbindliche Base-Image-Strategie mit
Größenbudget fest, an die sich die Backend-Rolle später halten muss. Der Architekt kann außerdem
in einen speziellen Spike-Modus wechseln — dazu gleich mehr.

Die **UX-Designerin** entwirft die Nutzererfahrung, ohne irgendein bestimmtes Design-Werkzeug
vorauszusetzen: User Journeys als nummerierte Schritt-Listen, alle UI-Zustände von leer über
ladend bis fehlerhaft, Microcopy und ein definiertes Accessibility-Niveau nach WCAG. Für
komplexe Layouts genügen textuelle ASCII-Skizzen — es muss kein Bild gemalt werden.

**Frontend-** und **Backend-Entwickler** implementieren anschließend tatsächlichen Code. Der
Backend-Agent arbeitet API-first: Erst der Vertrag — etwa als OpenAPI-Spezifikation —, dann
Datenschicht, Geschäftslogik und zuletzt die API-Schicht selbst. Der Frontend-Agent baut
Bottom-Up, von atomaren UI-Elementen über zusammengesetzte Komponenten bis zu ganzen Seiten,
immer mit Barrierefreiheits-Attributen und Unit-Tests. Beide folgen einem verbindlichen
Kommentierungsstandard mit Datei-Header, Artefakt-Referenzen und Pflichtkommentaren wie
`// Implementiert: US-000042` — genau diese Kommentare werden später maschinell geprüft, um
sicherzustellen, dass keine User Story vergessen wurde.

Der **QA-Engineer** sichert Qualität in zwei Phasen: erst ein Testplan mit Happy-Path-,
Negativ- und Grenzfall-Tests pro User Story, priorisiert in P0 bis P2, dann die eigentliche
Testausführung über Unit-, Integrations- und End-to-End-Tests — inklusive Playwright-Berichten
mit Screenshots und Traces bei Fehlern — bis hin zu Performance-Messungen gegen dokumentierte
Zielwerte.

Der **Code Reviewer** führt eine zweistufige Abnahme durch. Zuerst eine menschliche
Nutzerabnahme: Ein verständlicher, jargonfreier Test-Guide wird erstellt, der Mensch testet
selbst, und ein strukturiertes Interview erfasst, ob alles wie erwartet funktioniert. Danach
folgt ein technisches Review entlang sechs Dimensionen — Korrektheit, Sicherheit,
ADR-Konformität, Code-Qualität, Testabdeckung, Performance und Wartbarkeit. Wichtig dabei: Eine
Ablehnung durch den Menschen sticht ein technisch positives Review — die Endnutzerin hat das
letzte Wort.

Der **Manual Writer** schreibt als letzte Sprint-Phase ausschließlich für menschliche Endnutzer,
nie für Entwickler: Feature-Guides mit nummerierten Schritt-für-Schritt-Anleitungen, Release
Notes, beim allerersten Sprint einen Getting-Started-Guide und ab dem zweiten Sprint bei Bedarf
eine FAQ.

Der **Agile Coach** ist die einzige Rolle, die nicht an Inhalten, sondern am Prozess selbst
arbeitet. Er moderiert Retrospektiven nach Sprintabschluss, erkennt nach mehreren Sprints
systemische Muster in einem übergreifenden Health-Check, berät ad hoc bei bereits benannten
Prozessproblemen, und führt bei noch unbenannter Reibung ein strukturiertes
Impediment-Interview durch.

Und schließlich der **Orchestrator** — die einzige Rolle ohne fachlichen Inhalt. Er kennt nur
Zustand und Regeln: Welche Phase ist aktiv, welche Artefakte fehlen, welche Gate-Kriterien sind
erfüllt. Er kann entweder nur den Status berichten oder einen kompletten Sprint eigenständig
Phase für Phase durchsteuern.

---

## 5. Wie benutzt man die Tool Chain? — Der Weg von der Idee zum Release

### 5.1 Ein neues Projekt anlegen

Der erste Schritt ist rein mechanisch: Ein Projektordner wird aus einer Vorlage kopiert, erhält
ein eigenes Git-Repository mit eigenen Automatisierungs-Hooks, und eine kleine Konfigurationsdatei
wird mit Projektname und Beschreibung befüllt. Ab hier beginnt die eigentliche Arbeit mit einem
einzigen Befehl in Claude Code: entweder `/kickoff <projektname>`, um manuell Phase für Phase
durchzugehen, oder `/sprint <projektname> 1`, um den gesamten ersten Sprint automatisch
orchestrieren zu lassen.

### 5.2 Der manuelle Weg — Phase für Phase

Wer lieber die Kontrolle behält, ruft die Phasen-Befehle einzeln auf, in dieser Standard-Reihenfolge:
`/kickoff` für die Discovery-Phase mit dem Product Manager, `/ba` für Requirements mit dem
Business Analyst, `/architect` für Architekturentscheidungen, `/ux` für das Design, `/refine`
für die gemeinsame Sprint-Planung von Analyst und Entwicklern, `/implement` für die eigentliche
Programmierung, `/test-plan` gefolgt von `/test-run` für die Qualitätssicherung, `/review` für
die Abnahme, und zuletzt `/manual` für die Endnutzer-Dokumentation. Jeder dieser Befehle
aktiviert die passende Rolle, liest automatisch die relevanten vorherigen Artefakte, produziert
ein neues, sauber benanntes und versioniertes Dokument — und schließt niemals ab, ohne
explizit den nächsten sinnvollen Befehl zu nennen. Man muss also nie raten, was als Nächstes zu
tun ist.

### 5.3 Der automatisierte Weg — der vollständige Sprint

Wer den gesamten Zyklus nicht manuell steuern möchte, ruft `/sprint <projektname> <nummer>` auf.
Der Orchestrator arbeitet dann alle zehn Phasen — von Discovery bis hin zum eigentlichen
Code-Merge und Release-Tag — automatisch nacheinander ab. Zwischen jeder Phase steht ein
Qualitäts-Gate. Kritische Kriterien, so genannte Blocker, stoppen den Sprint hart und geben die
Kontrolle an den Nutzer zurück. Weniger kritische Kriterien werden entweder mit expliziter
Nutzerbestätigung übersprungen oder als offene Aufgabe automatisch in die nächste Phase
mitgenommen. Am Ende — wenn alle Gates bestanden sind — führt der Orchestrator sogar den
eigentlichen Git-Merge samt Versions-Tag gemäß der zuvor im Architektur-ADR festgelegten
Branching-Strategie durch.

### 5.4 Wenn es schnell gehen muss — Hotfix

Für kritische Produktionsfehler gibt es einen bewusst verkürzten Weg: `/hotfix <projektname>
<bug-beschreibung>` überspringt Discovery, Architektur und UX komplett und durchläuft nur vier
Phasen — Analyse mit Ursachenklärung, gezielte Implementierung nur der betroffenen Komponenten,
einen Smoke-Test statt eines vollständigen Testlaufs, und ein fokussiertes Review. Der Hotfix
ist nur zulässig, wenn sich weder Architektur noch Scope ändern — sonst greift wieder der
normale Sprint-Prozess.

### 5.5 Wenn Unsicherheit vor Verpflichtung steht — Spike

Für technische Fragen, die zu unsicher für eine direkte Architekturentscheidung sind — etwa "ist
Bibliothek X für unseren Anwendungsfall geeignet?" — gibt es den `/spike`-Befehl. Er erzeugt
keine Implementierungsverpflichtung: Eine Fragestellung wird geschärft, eine strikte Zeitbox
festgelegt, recherchiert und im Zweifel ein minimaler Prototyp gebaut, und am Ende steht eine
klare, unausweichliche Empfehlung — kein "es kommt darauf an". Für die Recherche steht dem
Architekten dabei sogar externer Web-Zugriff über einen angebundenen Recherche-Dienst zur
Verfügung, sodass Bibliotheks-Dokumentation oder API-Referenzen direkt eingebunden werden
können.

### 5.6 Nach dem Sprint — Prozessreflexion

Optional, aber empfohlen, schließt sich nach jedem Sprint eine Retrospektive mit dem Agile Coach
an. Nach mehreren Sprints kann ein übergreifender Health-Check systemische Muster erkennen, und
wann immer akute Prozess-Reibung auftritt, stehen ad-hoc-Beratung und ein strukturiertes
Impediment-Interview zur Verfügung.

---

## 6. Die Qualitätssicherungs-Mechanik im Detail

Was die Tool Chain von einem bloßen Sammelsurium an Prompt-Vorlagen unterscheidet, ist ihr
Beharren auf überprüfbaren Übergängen.

Jedes Artefakt — vom Stakeholder Brief bis zum Review-Bericht — folgt einem festen
Lebenszyklus: Entwurf, Review, Freigabe, aktiver Einsatz, und irgendwann entweder Ablösung durch
eine neuere Version oder Archivierung. Nichts wird von der KI ohne direkten Nutzerbefehl
gelöscht; abgelöste Dokumente werden explizit als "ersetzt durch" markiert, niemals stillschweigend
entfernt.

Zwischen den Phasen liegen benannte Qualitäts-Gates mit drei Schweregraden. Ein Blocker-Kriterium
verhindert den Phasenwechsel vollständig, bis es behoben ist — zum Beispiel: Existiert überhaupt
ein freigegebenes Architekturdokument, bevor Implementierung beginnen darf? Ein
Major-Kriterium erzeugt eine Warnung, die der Mensch bewusst bestätigen muss, bevor es
weitergeht. Ein Minor-Kriterium wird automatisch als Aufgabe in die nächste Phase übernommen,
ohne den Fluss zu unterbrechen. Diese Kriterien sind wo immer möglich objektiv und maschinell
prüfbar — etwa "existiert die Datei", "hat das Statusfeld den Wert APPROVED", "gibt es für jede
User Story mindestens einen Verweis im Code" — und nicht bloß eine Selbstauskunft der Rolle, die
gerade selbst geliefert hat.

Jedes Artefakt endet außerdem mit einem standardisierten Übergabeblock: Wer übergibt an wen,
welche Dokumente werden mitgegeben, was sind kritische Informationen für die Empfängerrolle,
welche Fragen sind noch offen, und was wird explizit nicht mitgeliefert. Das verhindert den in
klassischen Projekten häufigen Kontextverlust an Rollenübergängen.

Ein weiteres Prinzip zieht sich durch die gesamte Tool Chain: Technologie-Agnostizität. Keine
Rolle und keine Vorlage setzt eine bestimmte Programmiersprache, ein Framework oder eine
Plattform voraus, solange nicht der Architekt eine verbindliche Technologieentscheidung
getroffen und freigegeben hat. Erst danach — und nur innerhalb dieses einen Projekts — werden
diese Entscheidungen für alle nachfolgenden Rollen bindend.

---

## 7. Externe Recherche

Seit Kurzem ist die Tool Chain um einen angebundenen Web-Recherche-Dienst erweitert, der es
den recherchelastigen Rollen — Product Manager, Business Analyst und vor allem dem Architekten
im Architektur- und Spike-Modus — erlaubt, öffentlich erreichbare Webinhalte direkt abzurufen
und in lesbarer Textform auszuwerten: für Marktanalysen, Wettbewerbsbeobachtung, fachliche
Standards oder technische Dokumentation. Ergebnisse fließen dabei immer mit Quellenangabe in
das jeweilige Artefakt ein, nie als unreflektierte Kopie.

---

## 8. Vorteile

Der größte Vorteil ist erzwungene Vollständigkeit. Weil jede Rolle ihre eigene
Definition-of-Done-Checkliste vor Abschluss prüfen muss, ist es strukturell schwer, eine Phase
zu überspringen, ohne dass es auffällt. Anforderungen ohne Akzeptanzkriterien, Architekturen
ohne begründete Alternativen, oder Code ohne Testabdeckung werden nicht stillschweigend
durchgereicht, sondern von den Gates aktiv zurückgehalten.

Der zweite Vorteil ist Nachvollziehbarkeit. Jede Entscheidung — von der Marktpriorisierung bis
zur Wahl der Datenbanktechnologie — ist als eigenständiges, versioniertes Dokument mit
Begründung und verworfenen Alternativen festgehalten. Für ein Team, das Monate später
nachvollziehen möchte, warum eine bestimmte Entscheidung getroffen wurde, ist das erheblich
wertvoller als verstreute Chat-Verläufe oder ungeschriebenes Wissen im Kopf einer einzelnen
Person.

Der dritte Vorteil ist die konsequente Trennung zwischen technischer und menschlicher
Perspektive. Der Manual Writer schreibt nie für Entwickler, der Reviewer holt sich vor dem
technischen Urteil erst die Meinung der tatsächlichen Endnutzerin ein. Das ist ein Detail, das
in vielen realen Softwareprojekten fehlt — Dokumentation und Abnahme werden dort oft von
denselben Personen erledigt, die den Code geschrieben haben.

Der vierte Vorteil ist die eingebaute Flexibilität für unterschiedliche Dringlichkeitsstufen.
Nicht jede Änderung braucht den vollen Zehn-Phasen-Zyklus — der Hotfix-Workflow und der
Spike-Workflow erlauben bewusst abgekürzte, aber trotzdem strukturierte Wege für die jeweils
passende Situation.

Der fünfte Vorteil ist Technologieneutralität. Die Tool Chain legt sich nicht auf ein
bestimmtes Ökosystem fest — sie funktioniert für ein Python-Backend genauso wie für eine
TypeScript-Anwendung oder ein völlig anderes Projekt, weil die Technologieentscheidung selbst
Teil des Prozesses ist, nicht eine Voraussetzung dafür.

Der sechste Vorteil ist eingebaute Prozessverbesserung. Durch die Agile-Coach-Rolle ist die Tool
Chain nicht statisch — Retrospektiven und Health-Checks erzeugen konkrete
Verbesserungsvorschläge für den Prozess selbst, nicht nur für das Produkt.

---

## 9. Nachteile und Grenzen

Diese Struktur hat ihren Preis, und der sollte ehrlich benannt werden.

Der offensichtlichste Nachteil ist der Overhead für kleine Aufgaben. Ein einzeiliger Bugfix oder
ein triviales Feature durchläuft im Vollmodus theoretisch zehn Phasen mit jeweils eigenen
Artefakten — das kann für sehr kleine Projekte oder Experimente unverhältnismäßig schwerfällig
wirken. Der Hotfix-Workflow mildert das ab, ersetzt aber nicht jede Ad-hoc-Änderung.

Ein zweiter Nachteil ist die Artefakt-Menge. Jede Phase erzeugt mindestens ein, oft mehrere
Dokumente mit eigener ID, eigenem Statusfeld und eigener Indexpflege. Für ein Team, das lieber
schnell im Code selbst kommuniziert als in separaten Markdown-Dateien, kann das zusätzliche
organisatorische Last statt Entlastung bedeuten — insbesondere, wenn Indizes und
Übergabeblöcke nicht konsequent gepflegt werden.

Ein dritter, subtilerer Nachteil betrifft die Prüfmethoden selbst. Nicht jedes Gate-Kriterium
ist maschinell objektiv verifizierbar — manche sind bewusst als reine Selbstauskunft der
ausführenden Rolle definiert. Das bedeutet: Eine Rolle kann in bestimmten Fällen ihre eigene
Arbeit als abgeschlossen bewerten, ohne dass eine wirklich unabhängige Prüfinstanz das
gegenprüft. Für besonders kritische Kriterien wurde das bereits durch objektivere
Prüfmethoden ersetzt — aber nicht überall, und das bleibt ein struktureller Kompromiss.

Ein vierter Nachteil ist die Abhängigkeit von Disziplin. Die Tool Chain funktioniert nur so gut,
wie ihre Regeln tatsächlich befolgt werden. Nichts hindert einen Nutzer technisch daran, Gates zu
ignorieren, Phasen zu überspringen oder Freigaben ohne echte Prüfung zu setzen — die Struktur
gibt Orientierung und macht Abweichungen sichtbar, erzwingt sie aber nicht mit harter Technik
wie etwa eine CI-Pipeline es täte.

Ein fünfter Nachteil ist die aktuelle Sprachbindung: Sämtliche Rollen, Vorlagen und Dokumente
sind auf Deutsch verfasst. Für international zusammengesetzte Teams oder englischsprachige
Stakeholder bedeutet das zusätzlichen Übersetzungsaufwand.

Ein sechster Punkt ist grundsätzlicher Natur: Die Tool Chain ersetzt kein echtes menschliches
Fachwissen. Sie strukturiert, wie eine KI in verschiedenen Rollen denkt und dokumentiert — sie
kann aber eine tatsächliche Marktkenntnis, eine belastbare rechtliche Einschätzung oder echtes
Nutzer-Feedback nicht ersetzen. Interviews, Reviews und Abnahmen sind nur so gut wie die
Menschen, die tatsächlich antworten und testen.

Und schließlich: Der Prozess ist für Einzelprojekte und kleine bis mittlere Teams konzipiert.
Für sehr große, verteilte Organisationen mit eigenen etablierten Tools für Anforderungsmanagement,
Ticketing oder Testmanagement kann eine zusätzliche, parallele Dokumentenstruktur eher zu
Redundanz als zu Klarheit führen, wenn sie nicht bewusst mit den bestehenden Systemen
verzahnt wird.

---

## 10. Für wen eignet sich das?

Am meisten Nutzen zieht aus der Tool Chain, wer alleine oder in einem kleinen Team ein Projekt
von Grund auf mit KI-Unterstützung entwickeln möchte und dabei nicht auf Struktur, Nachvollziehbarkeit
und verständliche Endnutzer-Dokumentation verzichten will — ohne selbst ein
vollständiges Product-, Architektur- und QA-Team aufzubauen. Wer stattdessen möglichst schnell
experimentieren, einen Wegwerf-Prototyp bauen oder in einem bereits etabliertem
Enterprise-Prozess mit eigenen Tools arbeiten möchte, wird den vollen Prozess vermutlich als zu
schwergewichtig empfinden und eher punktuell einzelne Rollen oder den Hotfix-Workflow nutzen
wollen.

---

## 11. Fazit

Die AI Development Tool Chain ist im Kern eine Wette: dass strukturierte Rollentrennung,
erzwungene Dokumentation und überprüfbare Übergänge — Prinzipien, die klassische
Softwareentwicklungsmethoden seit Jahrzehnten predigen — auch dann noch wertvoll sind, wenn ein
einzelner KI-Assistent alle diese Rollen nacheinander selbst spielt. Der Gewinn ist
Nachvollziehbarkeit, Vollständigkeit und eine für Menschen lesbare Spur jeder Entscheidung. Der
Preis ist zusätzlicher Prozess-Overhead, der sich nur auszahlt, wenn das Projekt groß genug ist,
um von echter Struktur zu profitieren — und nur so lange, wie die Disziplin gewahrt bleibt, die
Regeln auch tatsächlich zu befolgen.
