# AUDIOSCRIPT — AI Development Tool Chain

> Quelldokument für NotebookLM (notebooklm.google.com) zur Erstellung einer Produktbeschreibung
> bzw. eines Audio-Überblicks ("Audio Overview"). **Zielformat: ca. 30 Minuten Sprechzeit** —
> das Dokument ist bewusst ausführlich, mit konkreten Beispielen und einem durchgehenden
> Fallbeispiel geschrieben, damit ein Zwei-Stimmen-Gespräch genug Substanz hat, um 30 Minuten zu
> füllen, ohne sich zu wiederholen oder mit Füllmaterial zu strecken. Es ist als durchgehender,
> erzählender Text geschrieben — bewusst nicht als reine Tabellen- oder Stichpunktsammlung —
> damit ein Sprachmodell daraus einen natürlich klingenden gesprochenen Beitrag erzeugen kann.
> Es beschreibt Zweck, Funktionsweise, Nutzung, Vorteile und Nachteile der Tool Chain aus einer
> produktnahen, für Außenstehende verständlichen Perspektive. Das durchgehende Beispielprojekt
> ("ein Buchungssystem für kleine Sportvereine") ist frei erfunden und dient ausschließlich der
> Veranschaulichung.

---

## 1. Elevator Pitch: Was ist das eigentlich?

Stell dir vor, du hast eine Idee für ein Softwareprodukt. Nicht mal eine besonders ausgereifte
Idee — nur ein Problem, das gelöst werden muss, und ein ungefähres Gefühl dafür, wer davon
profitieren würde. Sagen wir, ein kleiner Sportverein möchte ein einfaches Buchungssystem für
seine Trainingsplätze — nichts Weltbewegendes, aber genug Komplexität, um an den üblichen
Stellen schiefzugehen. Normalerweise beginnt jetzt ein mühsamer Prozess: Du müsstest ein Team aus
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
durchgereicht wird. Und, wie wir später sehen werden, inklusive Mechanismen, die selbst dann noch
greifen, wenn eine Arbeitssitzung mittendrin abbricht — etwa weil ein Kontextfenster oder ein
Token-Budget zur Neige geht, was bei größeren KI-gestützten Projekten kein exotischer
Randfall, sondern ein ziemlich alltägliches Ereignis ist.

---

## 2. Das Problem, das gelöst werden soll

Wer schon einmal versucht hat, mit einem KI-Assistenten direkt "baue mir eine App" zu sagen,
kennt das typische Ergebnis: Der Assistent springt sofort in die Implementierung, trifft dabei
implizite Annahmen über Technologie, Zielgruppe und Umfang, die nie explizit gemacht oder
hinterfragt wurden. Anforderungen bleiben vage, Architekturentscheidungen werden nebenbei und
unbegründet getroffen, Tests werden — wenn überhaupt — nachträglich und oberflächlich
geschrieben, und am Ende gibt es keine Dokumentation, die ein Mensch ohne Programmierkenntnisse
verstehen könnte. Bei unserem Sportverein-Beispiel hieße das im schlimmsten Fall: Die KI baut
sofort eine Datenbank und ein Login-System, ohne vorher zu fragen, ob es überhaupt mehrere
Trainingsplätze gibt, ob Mitglieder sich gegenseitig sehen dürfen, oder ob es rechtliche
Anforderungen an die Speicherung von Kontaktdaten Minderjähriger gibt.

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
Chain entwickelt wird — unser Sportverein-Buchungssystem zum Beispiel — bekommt einen eigenen
Ordner unter `projects/<projektname>/` — und ist technisch sogar ein komplett eigenständiges
Git-Repository, getrennt vom Tool-Chain-Repository selbst. Das ist ein bewusster Designentscheid:
Die Tool Chain ist wiederverwendbare Infrastruktur, die Projekte sind Nutzlast. Diese Schicht
enthält, WAS in einem konkreten Projekt tatsächlich entsteht.

Bemerkenswert an dieser Trennung: Die Tool Chain selbst bleibt technologisch neutral und
projektunabhängig, während jedes einzelne Projekt seine eigene Versionsgeschichte, seine eigenen
Entscheidungen und — wie wir gleich sehen werden — sogar seinen eigenen isolierten
Arbeitsbereich für laufende Sprints hat.

---

## 4. Die elf Rollen — ein Entwicklungsteam aus einer Feder

Die Tool Chain modelliert ein vollständiges, technologieneutrales Entwicklungsteam. Jede Rolle
hat eine klar abgegrenzte Verantwortung, eigene Eingaben, eigene Ausgaben und ein eigenes
Qualitätskriterien-Set, das vor Abschluss einer Sitzung geprüft wird.

Der **Product Manager** ist der erste Ansprechpartner. Er führt ein strukturiertes,
fünf-rundiges Stakeholder-Interview — Problemraum und Vision, Nutzer und Stakeholder, Scope und
Abgrenzung, Erfolgskriterien und Messbarkeit, Constraints und Risiken — und verdichtet das
Ergebnis zu einem Stakeholder Brief mit MoSCoW-Priorisierung und benannten Top-Risiken. Aus
demselben Interview destilliert er zusätzlich ein zweites, oft unterschätztes Dokument: eine
**Projekt-Constitution**. Das ist eine kurze Liste nicht verhandelbarer Prinzipien und
prüfbarer Qualitäts-Mindeststandards — bei unserem Sportverein-Beispiel könnte das etwa lauten:
"Kontaktdaten Minderjähriger werden niemals ohne Einwilligung der Erziehungsberechtigten
gespeichert" oder "jede Buchung muss innerhalb von zwei Sekunden bestätigt werden". Diese
Constitution ist ab ihrer Freigabe für jede einzige nachfolgende Rolle bindend — ein Architekt,
der später eine Datenbanklösung vorschlägt, die diese Prinzipien verletzt, muss das aktiv als
Konflikt eskalieren, nicht stillschweigend ignorieren oder unbemerkt übernehmen.

Der **Business Analyst** übersetzt Stakeholder Brief und Constitution in entwicklungsfähige
Anforderungen: ein Requirements-Dokument sowie einzelne User Stories im klassischen "Als Rolle
möchte ich Ziel, damit Nutzen"-Format, jede mit mindestens drei Akzeptanzkriterien im
Given/When/Then-Stil.

Der **Software Architect** trifft alle Technologieentscheidungen und dokumentiert sie als
Architecture Decision Records — kurz ADRs. Jede Entscheidung muss begründet sein, inklusive der
verworfenen Alternativen. Bemerkenswert ist eine bewusste Grundhaltung der Tool Chain:
Microservices sind die Standardpräferenz gegenüber einem Monolithen, und wer sich für einen
Monolithen entscheidet, muss diese Abweichung explizit rechtfertigen — nicht umgekehrt. Bei
Containerisierung schreibt der Architekt zusätzlich eine verbindliche Base-Image-Strategie mit
Größenbudget fest, an die sich die Backend-Rolle später halten muss. Der Architekt kann darüber
hinaus in zwei besondere Modi wechseln: einen **Spike-Modus** für zeitlich strikt begrenzte
technische Erkundung ohne Implementierungsverpflichtung — dazu gleich mehr — und einen
**Converge-Modus** für die Übernahme bereits existierenden Codes in die Tool Chain, den wir uns
im nächsten Kapitel genauer ansehen.

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
sicherzustellen, dass keine User Story vergessen wurde. Und beide arbeiten, sobald ein Sprint
in die Implementierung geht, in einem eigenen isolierten Arbeitsbereich — auch dazu gleich mehr.

Der **QA-Engineer** sichert Qualität in zwei Phasen: erst ein Testplan mit Happy-Path-,
Negativ- und Grenzfall-Tests pro User Story, priorisiert in P0 bis P2, dann die eigentliche
Testausführung über Unit-, Integrations- und End-to-End-Tests — inklusive Playwright-Berichten
mit Screenshots und Traces bei Fehlern — bis hin zu Performance-Messungen gegen dokumentierte
Zielwerte. Findet er einen Fehler, legt er einen strukturierten Fehlerbericht an — Symptom,
Reproduktionsschritte, Evidenz — lässt aber den Abschnitt "Root-Cause" bewusst leer. Das ist kein
Versehen, sondern Absicht, wie wir im Kapitel zur Qualitätssicherung noch genauer sehen werden.

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
erfüllt. Er kann den Status berichten, einen kompletten Sprint eigenständig Phase für Phase
durchsteuern, oder — eine dritte, jüngere Fähigkeit — eine reine Konsistenzprüfung zwischen
bereits erstellten Dokumenten durchführen, bevor überhaupt eine Zeile Code geschrieben wird.

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
für die gemeinsame Sprint-Planung von Analyst und Entwicklern, `/analyze` für eine automatische
Konsistenzprüfung, `/implement` für die eigentliche Programmierung, `/test-plan` gefolgt von
`/test-run` für die Qualitätssicherung, `/review` für die Abnahme, und zuletzt `/manual` für die
Endnutzer-Dokumentation. Jeder dieser Befehle aktiviert die passende Rolle, liest automatisch
die relevanten vorherigen Artefakte, produziert ein neues, sauber benanntes und versioniertes
Dokument — und schließt niemals ab, ohne explizit den nächsten sinnvollen Befehl zu nennen. Man
muss also nie raten, was als Nächstes zu tun ist.

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

### 5.4 Wenn Code schon existiert — Converge

Nicht jedes Projekt startet bei null. Manchmal gibt es bereits eine Codebasis — vielleicht aus
einem früheren, weniger strukturierten Anlauf, vielleicht von einem anderen Entwickler
übernommen — und die Frage ist: Was davon ist eigentlich schon fertig, und stimmt der Code noch
mit dem überein, was auf dem Papier entschieden wurde? Dafür gibt es `/converge <projektname>
<pfad-zu-code>`. Der Architekt scannt die vorhandene Codebasis — Struktur, Frameworks,
Datenmodelle, vorhandene Tests — und gleicht sie, falls Anforderungen und Architekturentscheidungen
bereits dokumentiert sind, in einer Abdeckungsmatrix gegen jede einzelne User Story ab: vollständig
umgesetzt, teilweise, oder gar nicht gefunden. Existieren noch keine solchen Dokumente, beschreibt
er stattdessen die vorgefundene Ist-Architektur so, dass Requirements und Architekturentscheidungen
im Nachhinein daraus abgeleitet werden können. Das Ergebnis ist eine Gap-Analyse mit einer
expliziten Handlungsempfehlung — nie ein vages "kommt darauf an". Wichtig ist, was Converge
bewusst NICHT ist: kein Code-Review und kein automatischer Fix. Es ändert keinen Code, sondern
liefert nur die ehrliche Bestandsaufnahme, auf der die nächste Entscheidung aufbaut.

### 5.5 Wenn es schnell gehen muss — Hotfix

Für kritische Produktionsfehler gibt es einen bewusst verkürzten Weg: `/hotfix <projektname>
<bug-beschreibung>` überspringt Discovery, Architektur und UX komplett und durchläuft nur vier
Phasen — Analyse mit Ursachenklärung, gezielte Implementierung nur der betroffenen Komponenten,
einen Smoke-Test statt eines vollständigen Testlaufs, und ein fokussiertes Review. Der Hotfix
ist nur zulässig, wenn sich weder Architektur noch Scope ändern — sonst greift wieder der
normale Sprint-Prozess.

### 5.6 Wenn Unsicherheit vor Verpflichtung steht — Spike

Für technische Fragen, die zu unsicher für eine direkte Architekturentscheidung sind — etwa "ist
Bibliothek X für unseren Anwendungsfall geeignet?" — gibt es den `/spike`-Befehl. Er erzeugt
keine Implementierungsverpflichtung: Eine Fragestellung wird geschärft, eine strikte Zeitbox
festgelegt, recherchiert und im Zweifel ein minimaler Prototyp gebaut, und am Ende steht eine
klare, unausweichliche Empfehlung — kein "es kommt darauf an".

### 5.7 Nach dem Sprint — Prozessreflexion

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

Ein besonders wichtiges Gate liegt zwischen Sprint-Planung und Implementierung: eine
Cross-Artefakt-Konsistenzprüfung, aktivierbar über `/analyze`. Der Orchestrator liest dabei
Requirements, User Stories, Architekturentscheidungen, UX-Spezifikationen und Sprint-Backlog
gemeinsam und prüft, ob sie sich widersprechen — verletzt eine geplante Sprint-Story eine bereits
getroffene Architekturentscheidung? Widerspricht ein UX-Fluss den Akzeptanzkriterien der
zugehörigen User Story? Verletzt irgendetwas ein Prinzip aus der Projekt-Constitution? Der
Orchestrator löst diese Widersprüche dabei nicht selbst — er hat keine fachliche Meinung —
sondern ordnet den Fund exakt der Rolle zu, die ihn verursacht hat, und schickt die Arbeit dorthin
zurück. Das Ziel: Spec-Drift wird erkannt, bevor Implementierungsaufwand in eine bereits
inkonsistente Grundlage investiert wird, nicht erst, wenn der fertige Code nicht zusammenpasst.

Ein weiteres, sehr konkretes Beispiel für erzwungene Sorgfalt ist der Umgang mit Fehlern. Wenn
der QA-Engineer einen Bug findet, dokumentiert er Symptom, Reproduktionsschritte und Evidenz —
aber der Abschnitt "Root-Cause" bleibt für ihn gesperrt. Erst Frontend- oder Backend-Entwickler,
bevor sie auch nur eine Zeile Code ändern, müssen diesen Abschnitt ausfüllen: Was ist die direkte
Ursache, was die dahinterliegende systemische Ursache, gibt es weitere Stellen mit demselben
Muster? Ein Fix ohne dokumentierte Root-Cause gilt als unvollständig — das verhindert das
klassische Muster, einen Nullpointer-Fehler mit einer zusätzlichen Null-Prüfung an genau der
Stelle zu "reparieren", an der er zufällig aufgefallen ist, während die eigentliche Ursache
irgendwo tiefer im System unangetastet bleibt und beim nächsten Mal an anderer Stelle wieder
zuschlägt. Nach dem Fix verlangt die Tool Chain zusätzlich einen Regressionstest, der den
ursprünglichen Fehler abdeckt, und erst eine erneute, unabhängige Verifikation durch den
QA-Engineer setzt den Bug tatsächlich auf "verifiziert" — nicht schon die Behauptung des
Entwicklers, er sei behoben.

Ein weiteres Prinzip zieht sich durch die gesamte Tool Chain: Technologie-Agnostizität. Keine
Rolle und keine Vorlage setzt eine bestimmte Programmiersprache, ein Framework oder eine
Plattform voraus, solange nicht der Architekt eine verbindliche Technologieentscheidung
getroffen und freigegeben hat. Erst danach — und nur innerhalb dieses einen Projekts — werden
diese Entscheidungen für alle nachfolgenden Rollen bindend.

---

## 7. Verlässlichkeit über lange Sitzungen hinweg

Die bislang jüngste Erweiterung der Tool Chain adressiert ein Problem, das bei
KI-gestützter Entwicklung größerer Projekte fast unvermeidlich auftritt: Eine Arbeitssitzung
bricht mittendrin ab. Ein Token-Budget oder ein Kontextfenster ist erschöpft, und die Arbeit an
einem Sprint muss Tage später fortgesetzt werden — von derselben oder einer komplett neuen
KI-Sitzung. Zwei eng miteinander verzahnte Mechanismen sorgen dafür, dass genau dieser Moment
nicht zum schwächsten Glied der ganzen Kette wird.

Der erste Mechanismus betrifft, wie Fortschritt überhaupt dokumentiert wird. In jedem
Projekt-Index gibt es einen Freitext-Abschnitt — "In Bearbeitung" — in dem eine KI-Sitzung für
die nächste hinterlässt, was schon erledigt ist und was noch fehlt. Das klingt zunächst
harmlos, ist aber ein klassisches Risiko: Freitext, den ein Agent geschrieben hat, wird von einem
späteren Agent oft ungeprüft für bare Münze genommen — und wenn diese Notiz veraltet oder schlicht
falsch ist, vererbt sich der Irrtum stillschweigend weiter. Die Tool Chain begegnet dem mit einer
einfachen, aber wirkungsvollen Regel: Eine solche Statusnotiz gilt ausdrücklich als Projektion,
nicht als Tatsache. Bevor eine Rolle darauf aufbaut — etwa eine Story als bereits fertig
behandelt, weil der Index das so vermerkt —, muss sie die konkret prüfbaren Behauptungen darin
gegen echte Evidenz gegenprüfen: Stimmt der behauptete Commit-Status wirklich mit der
Versionshistorie überein? Existieren die Dateien, von denen die Notiz behauptet, sie seien schon
angelegt? Sind die Häkchen in der Definition-of-Done der betroffenen User Story tatsächlich
erfüllt, oder wurde nur behauptet, sie seien es? Das ist kein aufwendiger Vollscan der gesamten
Codebasis, sondern eine gezielte Stichprobe genau der Behauptungen, die für die aktuelle Aufgabe
relevant sind — und bei einer Abweichung wird sie sichtbar korrigiert, nicht stillschweigend
übernommen oder unkommentiert stehen gelassen. Selbst der reine Statusbericht-Befehl, der
grundsätzlich nichts verändern darf, meldet eine gefundene Abweichung offen als eigenen Befund,
statt sie klammheimlich zu reparieren oder — schlimmer — einfach zu wiederholen.

Der zweite Mechanismus betrifft, WO während eines Sprints tatsächlich gearbeitet wird. Sobald ein
Sprint die Implementierungsphase erreicht, legt die Tool Chain einen eigenen, isolierten
Arbeitsbereich an — technisch ein sogenannter Git-Worktree auf einem eigenen Branch, benannt nach
dem Sprint. Frontend- und Backend-Entwicklung, Tests, Review und sogar die
Endnutzer-Dokumentation finden bis zum Abschluss des Sprints ausschließlich dort statt, nicht im
Haupt-Arbeitsverzeichnis des Projekts. Der Effekt: Wird eine Sitzung mittendrin unterbrochen,
bleibt exakt nachvollziehbar, was tatsächlich schon vorliegt — der isolierte Arbeitsbereich lässt
sich später einfach wiederbetreten, statt dass man raten muss, welcher Teil der Änderungen bereits
committet war und welcher nur lose auf der Festplatte lag. Erst wenn ein Sprint vollständig durch
Review UND Dokumentationsphase ist, führt die Tool Chain den eigentlichen Merge in den
Hauptzweig durch — mit derselben bewährten, historienerhaltenden Merge-Strategie, die schon vorher
galt, nicht mit einer verdichtenden Zusammenfassung, die Zwischenschritte verschluckt. Und weil
ein tatsächlicher Push in ein geteiltes Repository oder das endgültige Entfernen eines
Arbeitsbereichs schwer rückgängig zu machende Aktionen sind, verlangt die Tool Chain an genau
dieser Stelle immer eine explizite menschliche Bestätigung — selbst wenn alle vorherigen
Qualitäts-Gates bereits vollständig bestanden wurden.

Beide Mechanismen gelten bewusst nur für den regulären Sprint-Workflow. Ein Hotfix, bei dem
Geschwindigkeit zählt, oder ein Spike, der ohnehin meist verworfen wird, bekommen diese Ceremony
nicht aufgezwungen — die Tool Chain wägt hier bewusst ab, wo Isolation einen echten Mehrwert
bietet und wo sie nur zusätzlichen Aufwand ohne Gegenwert wäre.

---

## 8. Externe Anbindungen: Recherche und Codebase-Intelligenz

Die Tool Chain arbeitet nicht vollständig isoliert. Zwei angebundene Werkzeuge erweitern, was
einzelne Rollen tun können, ohne dass die Tool Chain selbst dafür Code enthalten müsste.

Das erste ist ein Web-Recherche-Dienst, der es den recherchelastigen Rollen — Product Manager,
Business Analyst und vor allem dem Architekten im Architektur- und Spike-Modus — erlaubt,
öffentlich erreichbare Webinhalte direkt abzurufen und in lesbarer Textform auszuwerten: für
Marktanalysen, Wettbewerbsbeobachtung, fachliche Standards oder technische Dokumentation.
Ergebnisse fließen dabei immer mit Quellenangabe in das jeweilige Artefakt ein, nie als
unreflektierte Kopie.

Das zweite, neuere Werkzeug ist eine Art Gedächtnis für Code-Struktur — ein externer Dienst, der
eine Codebasis einmalig einliest und daraus einen strukturellen Graphen aufbaut: welche Datei
definiert welche Funktion, welche Funktion ruft welche andere auf, welche Datei importiert was
von wo. Anschließend lassen sich gezielte Struktur-Fragen an diesen Graphen stellen, statt bei
jeder Frage die gesamte Codebasis Datei für Datei zu durchsuchen. Der Größenordnungs-Unterschied
ist erheblich: Ein Satz struktureller Abfragen gegen den Graphen verbraucht typischerweise nur
wenige Tausend Wörter an Kontext, während dieselbe Information über klassisches
Volltext-Durchsuchen einer größeren Codebasis leicht das Hundertfache verschlingen kann. Genutzt
wird das vor allem an vier Stellen: vom Architekten bei der Ist-Architektur-Erfassung und beim
Converge-Scan bestehenden Codes, von Frontend- und Backend-Entwicklern, um Aufrufketten und
betroffene Stellen in bereits existierendem Code zu finden — besonders bei der Ursachensuche für
Bugs —, vom Code Reviewer, um den Änderungsumfang eines Diffs samt betroffener Aufrufer
einzuschätzen, bevor eine Merge-Entscheidung fällt, und vom QA-Engineer zur Identifikation von
totem Code und ungetesteten Pfaden. In keinem Fall ersetzt dieses Werkzeug fachliches Verständnis
oder ein echtes Code-Review — es liefert nur die strukturellen Fakten schneller und günstiger,
als sie sich durch Lesen jeder einzelnen Datei erschließen ließen.

---

## 9. Portabilität über Claude Code hinaus

Claude Code bleibt die kanonische, primär vorgesehene Ausführungsumgebung der Tool Chain — alle
Rollen, Vorlagen und Regeln sind zuerst für sie geschrieben. Zusätzlich existiert aber eine rein
additive Kompatibilitätsschicht für Codex, ein alternatives KI-Coding-Werkzeug: ein kurzer
Adapter, der ausdrücklich der kanonischen Konfiguration den Vorrang einräumt, sowie ein nativer
Router, der dieselben Befehle unter Codex verfügbar macht. Wichtig ist die Reihenfolge: Diese
Codex-spezifischen Dateien dürfen niemals Befehle, Rollen, Vorlagen oder Prioritäten der
Claude-Code-Konfiguration überschreiben — sie können nur das nutzbar machen, was ohnehin schon
kanonisch definiert ist. Ein eigenes Prüfskript stellt sicher, dass beide Seiten konsistent
bleiben. Für Teams, die aus welchem Grund auch immer nicht ausschließlich in Claude Code
arbeiten, ist das ein pragmatischer Weg, ohne doppelte Pflege an derselben Struktur
teilzunehmen.

---

## 10. Vorteile

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
Nicht jede Änderung braucht den vollen Zehn-Phasen-Zyklus — Hotfix- und Spike-Workflow erlauben
bewusst abgekürzte, aber trotzdem strukturierte Wege, und Converge erlaubt sogar den nachträglichen
Einstieg bei bereits existierendem Code.

Der fünfte Vorteil ist Technologieneutralität. Die Tool Chain legt sich nicht auf ein
bestimmtes Ökosystem fest — sie funktioniert für ein Python-Backend genauso wie für eine
TypeScript-Anwendung oder ein völlig anderes Projekt, weil die Technologieentscheidung selbst
Teil des Prozesses ist, nicht eine Voraussetzung dafür.

Der sechste Vorteil ist eingebaute Prozessverbesserung. Durch die Agile-Coach-Rolle ist die Tool
Chain nicht statisch — Retrospektiven und Health-Checks erzeugen konkrete
Verbesserungsvorschläge für den Prozess selbst, nicht nur für das Produkt.

Der siebte Vorteil ist Widerstandsfähigkeit gegen Unterbrechungen. Die Kombination aus
gegengeprüften Statusnotizen und isolierten Sprint-Arbeitsbereichen bedeutet, dass eine
abgebrochene Sitzung kein mehrdeutiges Chaos hinterlässt, sondern einen exakt lokalisierbaren,
sicher wiederaufnehmbaren Zustand — ein Detail, das bei kurzen Experimenten kaum auffällt, bei
mehrtägigen, mehrstufigen Sprints aber den Unterschied zwischen "ich weiß genau, wo ich
weitermache" und "ich muss erstmal alles nachprüfen" ausmacht.

---

## 11. Nachteile und Grenzen

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
Prüfmethoden ersetzt — etwa durch die Gegenprüfung von Statusnotizen gegen echte Evidenz —, aber
nicht überall, und das bleibt ein struktureller Kompromiss.

Ein vierter Nachteil ist die Abhängigkeit von Disziplin. Die Tool Chain funktioniert nur so gut,
wie ihre Regeln tatsächlich befolgt werden. Nichts hindert einen Nutzer technisch daran, Gates zu
ignorieren, Phasen zu überspringen oder Freigaben ohne echte Prüfung zu setzen — die Struktur
gibt Orientierung und macht Abweichungen sichtbar, erzwingt sie aber nicht mit harter Technik
wie etwa eine CI-Pipeline es täte.

Ein fünfter Nachteil ist die aktuelle Sprachbindung: Sämtliche Rollen, Vorlagen und Dokumente
sind auf Deutsch verfasst. Für international zusammengesetzte Teams oder englischsprachige
Stakeholder bedeutet das zusätzlichen Übersetzungsaufwand.

Ein sechster Nachteil betrifft die neueren Erweiterungen selbst: Sowohl die
Worktree-Isolation als auch die Codebase-Intelligenz bringen zusätzliche technische Abhängigkeiten
mit sich — Vertrautheit mit Git-Worktrees auf der einen, ein zusätzliches, extern gepflegtes
Werkzeug eines einzelnen Anbieters auf der anderen Seite. Beides ist optional und rein additiv,
aber beides ist auch neue Komplexität, die gewartet und im Zweifel wieder ausgebaut werden muss.

Ein siebter Punkt ist grundsätzlicher Natur: Die Tool Chain ersetzt kein echtes menschliches
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

## 12. Für wen eignet sich das?

Am meisten Nutzen zieht aus der Tool Chain, wer alleine oder in einem kleinen Team ein Projekt
von Grund auf mit KI-Unterstützung entwickeln möchte — oder ein bereits bestehendes Projekt
strukturiert übernehmen will — und dabei nicht auf Struktur, Nachvollziehbarkeit und
verständliche Endnutzer-Dokumentation verzichten will, ohne selbst ein vollständiges Product-,
Architektur- und QA-Team aufzubauen. Besonders wertvoll wird das bei Projekten, die sich über
mehrere Tage oder Sitzungen erstrecken, weil genau dort die Mechanismen zur Wiederaufnahme nach
Unterbrechung ihren größten Nutzen entfalten. Wer stattdessen möglichst schnell experimentieren,
einen Wegwerf-Prototyp bauen oder in einem bereits etablierten Enterprise-Prozess mit eigenen
Tools arbeiten möchte, wird den vollen Prozess vermutlich als zu schwergewichtig empfinden und
eher punktuell einzelne Rollen oder den Hotfix-Workflow nutzen wollen.

---

## 13. Fazit

Die AI Development Tool Chain ist im Kern eine Wette: dass strukturierte Rollentrennung,
erzwungene Dokumentation und überprüfbare Übergänge — Prinzipien, die klassische
Softwareentwicklungsmethoden seit Jahrzehnten predigen — auch dann noch wertvoll sind, wenn ein
einzelner KI-Assistent alle diese Rollen nacheinander selbst spielt. Die jüngeren Erweiterungen —
Cross-Artefakt-Konsistenzprüfung, Root-Cause-Disziplin bei Bugfixes, die Möglichkeit, bestehenden
Code strukturiert zu übernehmen, und zuletzt die Gegenprüfung von Statusnotizen samt isolierten
Sprint-Arbeitsbereichen — verfolgen alle dasselbe Grundmotiv: dass die Tool Chain nicht nur beim
ersten Durchlauf funktioniert, sondern auch dann noch verlässlich bleibt, wenn ein Projekt größer
wird, länger dauert, mehrere Sitzungen überspannt oder mittendrin unterbrochen wird. Der Gewinn
ist Nachvollziehbarkeit, Vollständigkeit und eine für Menschen lesbare Spur jeder Entscheidung —
selbst über Wochen und Unterbrechungen hinweg. Der Preis ist zusätzlicher Prozess-Overhead, der
sich nur auszahlt, wenn das Projekt groß genug ist, um von echter Struktur zu profitieren — und
nur so lange, wie die Disziplin gewahrt bleibt, die Regeln auch tatsächlich zu befolgen.
