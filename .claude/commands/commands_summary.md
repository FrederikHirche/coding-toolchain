# Commands Summary — AI Development Tool Chain

Konsolidierte Übersicht aller Slash Commands.  
Zweck: Einzelne Referenzdatei für NotebookLM-Analyse und schnelle Orientierung.

**Letzte Aktualisierung:** 2026-06-21  
**Pflege-Regel:** Diese Datei wird bei jedem Hinzufügen oder Ändern eines Commands aktualisiert.

---

## Überblick

Die Slash Commands der Tool Chain aktivieren jeweils einen spezialisierten Agenten für eine
definierte Phase. Commands können manuell nacheinander aufgerufen werden (manuelle Variante)
oder durch `/sprint` automatisch orchestriert werden (Sprint-Variante).

Standard-Reihenfolge Full-Sprint:
`/kickoff` → `/ba` → `/architect` → `/ux` → `/refine` → `/implement` → `/test-plan` → `/test-run` → `/review` → `/manual`

---

## Orchestrierungs-Commands

### /status — Projektzustand anzeigen

**Aktiviert:** Orchestrator (ORCH)  
**Wann nutzen:** Jederzeit, um den aktuellen Stand eines Projekts zu überblicken — welche Phase ist aktiv, welche Artefakte fehlen, was blockiert den nächsten Schritt.  
**Was passiert:** Liest `.phase` und `INDEX.md` des Projekts, analysiert Gate-Kriterien, listet alle Artefakte mit Status und gibt eine klare Handlungsempfehlung mit dem nächsten Slash Command.  
**Output:** Strukturierter Statusbericht im Terminal (kein Artefakt)  
**Kein Vorgänger nötig.**

---

### /sprint — Vollständigen Sprint orchestrieren

**Aktiviert:** Orchestrator (ORCH)  
**Wann nutzen:** Wenn ein vollständiger Sprint ohne manuelle Steuerung durchgeführt werden soll. Der Orchestrator aktiviert alle Phasen sequenziell, prüft Gates und stoppt bei Blockern.  
**Was passiert:** Alle 9 Phasen (Discovery bis Dokumentation) werden nacheinander ausgeführt. Nach jeder Phase wird ein Gate-Check durchgeführt. BLOCKER stoppen den Sprint und warten auf Nutzer-Entscheidung.  
**Variante zu:** Manuellem Durchlaufen der einzelnen Phase-Commands  
**Vorbedingung:** Projektordner muss existieren oder wird angelegt.

---

### /hotfix — Notfall-Fix-Workflow

**Aktiviert:** Orchestrator (ORCH)  
**Wann nutzen:** Kritischer Produktionsfehler, der sofort behoben werden muss — ohne vollständigen Sprint-Zyklus.  
**Was passiert:** Verkürzter 4-Phasen-Workflow: Analyse → Implementierung → Test → Review. Kein UX, keine Requirements-Phase.  
**Verwendung:** `/hotfix [projektname] [bug-beschreibung]`

---

### /spike — Technischer Research-Spike

**Aktiviert:** Orchestrator (ORCH) / AR  
**Wann nutzen:** Technologie-Evaluierung oder Architektur-Entscheidung, bevor eine Implementierungsverpflichtung eingegangen wird.  
**Was passiert:** 3 Phasen: Frage definieren → Recherche & Prototyp → Spike Report (SRP-NNN). Keine Implementierung, keine User Stories.  
**Output:** `SRP-NNN` Spike Report

---

## Phasen-Commands (manuell oder durch /sprint aufgerufen)

### /kickoff — Discovery Phase

**Aktiviert:** PM (Product Manager)  
**Wann nutzen:** Start eines neuen Projekts. Kein Vorgänger nötig — das ist der Einstiegspunkt der Tool Chain.  
**Was passiert:** Strukturiertes Stakeholder-Interview in 5 Runden (Problemraum, Nutzer, Scope, Erfolgskriterien, Constraints). Nach dem Interview wird der Stakeholder Brief (SB-001) erstellt, MoSCoW-Priorisierung festgelegt und die Top-3-Risiken benannt. Projektordner, INDEX.md und `.phase`-Datei werden angelegt.  
**Output:** `SB-NNN` Stakeholder Brief  
**Nächste Phase:** `/ba [projektname]`

---

### /ba — Requirements Phase

**Aktiviert:** BA (Business Analyst)  
**Wann nutzen:** Nach Abschluss des Stakeholder Briefs.  
**Was passiert:** Analysiert den Stakeholder Brief, leitet funktionale und nicht-funktionale Anforderungen ab, erstellt User Stories im "Als [Rolle] möchte ich [Ziel], damit [Nutzen]"-Format mit Given/When/Then-Akzeptanzkriterien. Erstellt Story-Map mit Abhängigkeiten.  
**Vorbedingung:** `SB-NNN` im Status APPROVED  
**Output:** `REQ-NNN` Requirements-Dokument, `US-NNN` User Stories  
**Nächste Phase:** `/architect [projektname]`

---

### /architect — Architektur-Phase

**Aktiviert:** AR (Software Architect)  
**Wann nutzen:** Nach Abschluss der Requirements.  
**Was passiert:** Trifft Technologieentscheidungen und dokumentiert sie als Architecture Decision Records (ADRs). ADR-001 definiert den vollständigen Tech-Stack. Weitere ADRs für jede wesentliche Einzelentscheidung (API-Stil, Datenhaltung, Auth, Observability). Erstellt Systemdesign-Diagramm und Projektverzeichnisstruktur (STRUCTURE.md).  
**Vorbedingung:** `REQ-NNN` APPROVED, mind. eine `US-NNN` vorhanden  
**Output:** `ADR-NNN` Architecture Decision Records, `STRUCTURE.md`  
**Nächste Phasen:** `/ux [projektname]` und/oder `/refine [projektname] [sprint-nr]`

---

### /ux — UX Design Phase

**Aktiviert:** UX (UX Designer)  
**Wann nutzen:** Nach Architektur-Phase, bevor Implementierung beginnt.  
**Was passiert:** Definiert User Journeys für alle primären Flows, beschreibt alle UI-Zustände (leer, loading, Fehler, Erfolg), dokumentiert Edge Cases und Fehlerflüsse, definiert Microcopy und Accessibility-Anforderungen (WCAG-Level). Verwendet ASCII-Layouts für komplexe Strukturen — kein Design-Tool erforderlich.  
**Vorbedingung:** `ADR-001` APPROVED, alle Must-Have US vorhanden  
**Output:** `UX-NNN` UX-Spec pro Feature-Bereich  
**Nächste Phase:** `/refine [projektname] [sprint-nr]`

---

### /refine — Refinement / Sprint Planning

**Aktiviert:** BA, FE, BE (gemeinsames Refinement)  
**Wann nutzen:** Vor dem Implementierungs-Sprint — User Stories werden in umsetzbare Tasks aufgeteilt und geschätzt.  
**Was passiert:** Verfeinert User Stories mit Subtasks, Story-Point-Schätzungen und Abhängigkeiten. Erstellt Sprint-Backlog-Dokument mit Sprint-Ziel, Abnahmekriterien und technischen Voraussetzungen.  
**Vorbedingung:** `UX-NNN` vorhanden, `ADR-001` APPROVED  
**Output:** `SP-NNN` Sprint Backlog  
**Nächste Phase:** `/implement [fe|be|all] [projektname]`

---

### /implement — Implementierungsphase

**Aktiviert:** FE (Frontend Developer) und/oder BE (Backend Developer)  
**Verwendung:** `/implement fe`, `/implement be`, oder `/implement all`  
**Wann nutzen:** Nach Refinement — tatsächliche Code-Implementierung.  
**Was passiert (BE):** API-First: Erst API-Kontrakt (OpenAPI/GraphQL) erstellen, dann Datenschicht → Business Logic → API-Layer implementieren. Vollständige Code-Kommentierung nach Standard.  
**Was passiert (FE):** Komponenten Bottom-Up implementieren (Atome → Moleküle → Seiten), basierend auf UX-Spec und API-Kontrakt. Accessibility-Attribute, Unit-Tests.  
**Vorbedingung:** `SP-NNN` vorhanden, UX-Specs vorhanden  
**Output:** Code + API-Kontrakt  
**Nächste Phase:** `/test-plan [projektname] [sprint-nr]`

---

### /test-plan — Testplan erstellen

**Aktiviert:** QA (QA Engineer)  
**Wann nutzen:** Nach Abschluss der Implementierung.  
**Was passiert:** Erstellt manuellen Testplan basierend auf User Stories und UX-Specs. Für jede Story: Happy Path + Negativtest + Boundary-Tests. Priorisierung in P0/P1/P2. Ergänzt fehlende automatisierte Tests. Definiert Testumgebungs-Anforderungen.  
**Vorbedingung:** Implementierung abgeschlossen, FE/BE-Übergabeprotokolle vorhanden  
**Output:** `TP-NNN` Testplan  
**Nächste Phase:** `/test-run [projektname] [sprint-nr]`

---

### /test-run — Tests ausführen

**Aktiviert:** QA (QA Engineer)  
**Wann nutzen:** Nach Abschluss des Testplans.  
**Was passiert:** Führt automatisierte Tests aus (Unit → Integration → E2E mit Playwright). Für E2E: prüft `playwright.config.ts`, führt `npx playwright test --reporter=html` aus, speichert HTML-Report in `projects/<name>/testing/playwright-report/`. Erfasst Fehler als BUG-NNN (inkl. Screenshot- und Trace-Pfad aus Playwright). Erstellt Coverage-Report und Freigabe-Empfehlung: APPROVED / CONDITIONAL / REJECTED.  
**Vorbedingung:** `TP-NNN` APPROVED, Testumgebung konfiguriert, App erreichbar für Playwright  
**Output:** `TR-NNN`, ggf. `BUG-NNN`, Playwright HTML-Report — alle in `projects/<name>/testing/`  
**Nächste Phase:** `/review [projektname] [sprint-nr]`

---

### /review — User Review + Code Review mit User-Story-Abnahme

**Aktiviert:** RV (Code Reviewer)  
**Wann nutzen:** Nach bestandenem Test-Lauf, vor dem Merge.  
**Was passiert (3 Phasen):**
1. **Test-Guide erstellen:** RV-Agent erstellt nutzerfreundlichen Test-Guide (klare Schritte, kein Tech-Jargon) aus US-NNN und TP-NNN — dann ⏸ pausieren, Nutzer testet.
2. **Nutzer-Interview:** Wenn Nutzer zurückkommt: strukturiertes Interview pro Feature (funktioniert? unerwartetes? UX-Eindruck?). Ergibt Nutzer-Befund: ACCEPTED / CONDITIONAL / REJECTED.
3. **Technisches Code Review:** 6 Dimensionen (Korrektheit → Sicherheit → ADR-Konformität → Code-Qualität → Testabdeckung → Performance). Gesamtentscheidung kombiniert Nutzer + Technik.  
**Vorbedingung:** `TR-NNN` vorhanden, keine BLOCKER-Bugs offen, App zugänglich  
**Output:** `RV-NNN` (in `projects/<name>/reviews/`)  
**Nächste Phase (APPROVED):** `/manual [projektname] [sprint-nr]`  
**Nächste Phase (REQUEST CHANGES):** `/implement [fe|be] [projektname]`  
**Nächste Phase (REJECTED):** `/ba [projektname]`

---

### /manual — Nutzer-Dokumentation schreiben

**Aktiviert:** MW (Manual Writer)  
**Wann nutzen:** Nach erfolgreichem Code Review — letzte Phase des Sprints.  
**Was passiert:** Erstellt nutzerorientierte Feature-Guides (DOC-NNN) pro Feature-Gruppe — keine technischen Details, sondern schrittweise Anleitungen aus Nutzerperspektive. Erstellt Release Notes (RN-NNN). Beim ersten Sprint: Getting-Started-Guide (GS-001).  
**Vorbedingung:** `RV-NNN` mit APPROVED, keine offenen BLOCKER-Bugs  
**Output:** `DOC-NNN` Feature-Guides, `RN-NNN` Release Notes, ggf. `GS-001`  
**Sprint-Abschluss:** REGISTRY.md aktualisieren, optional `/retro [projektname] [sprint-nr]`

---

## Post-Sprint-Commands (Agile Coach)

### /retro — Sprint-Retrospektive

**Aktiviert:** AC (Agile Coach)  
**Wann nutzen:** Nach Sprint-Abschluss — optional aber empfohlen.  
**Was passiert:** Strukturierte Retrospektive in 5 Dimensionen: Prozess-Fluss, Artefakt-Qualität, Agenten-Performance, Entscheidungsqualität, Keep/Stop/Start. Stellt zuerst 2–3 Fragen an den Nutzer, dann Analyse.  
**Output:** `RETRO-NNN` Retrospektiven-Protokoll, ggf. `PC-NNN`

---

### /health-check — Übergreifende Prozessanalyse

**Aktiviert:** AC (Agile Coach)  
**Wann nutzen:** Nach 3 oder mehr abgeschlossenen Sprints — für systemische Muster.  
**Was passiert:** Analysiert alle Sprints übergreifend: wiederkehrende Muster, Gate-Statistik, Artefakt-Lücken, Übergabe-Schwachstellen, Velocity-Entwicklung. Gibt priorisierte Verbesserungsvorschläge.  
**Output:** `PC-NNN` Process Change Proposal mit 3–7 priorisierten Änderungen

---

### /coach — Ad-hoc Prozessberatung

**Aktiviert:** AC (Agile Coach)  
**Wann nutzen:** Wenn ein konkretes Prozess-Problem bereits bekannt und formuliert ist.  
**Was passiert:** Nimmt die Problembeschreibung entgegen, stellt 1–2 Klärungsfragen, liest relevante Artefakte, erstellt Diagnose und handlungsorientierte Empfehlung mit Dateireferenz.  
**Verwendung:** `/coach [projektname] "Beschreibung des Problems"`  
**Output:** Empfehlung (Text), ggf. `PC-NNN`

---

### /impediment — Impediment-Interview

**Aktiviert:** AC (Agile Coach)  
**Wann nutzen:** Wenn Friction spürbar ist, das Problem aber noch nicht präzise benannt werden kann — im Unterschied zu `/coach`, das ein formuliertes Problem voraussetzt.  
**Was passiert:** Führt ein strukturiertes 5–6-Fragen-Interview durch: Symptom → Frequenz → Auswirkung → bisherige Umgehungen → gewünschtes Ergebnis. Danach: Diagnose, Sofortmaßnahme und strukturelle Empfehlung. Erstellt Impediment-Dokument.  
**Output:** `IMPD-NNN` Impediment-Dokument, ggf. `PC-NNN`
