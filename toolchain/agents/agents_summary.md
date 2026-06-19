# Agents Summary — AI Development Tool Chain

Konsolidierte Übersicht aller Agenten-Rollen.  
Zweck: Einzelne Referenzdatei für NotebookLM-Analyse und schnelle Orientierung.

**Letzte Aktualisierung:** 2026-06-19  
**Pflege-Regel:** Diese Datei wird bei jedem Hinzufügen oder Ändern einer Agenten-Datei aktualisiert.

---

## Architektur-Prinzip

Alle Agenten erben die Basisregeln aus `_base-agent.md`. Diese Basisregeln definieren:
- den Artefakt-Header-Standard (Frontmatter mit id, title, version, status)
- die INDEX.md-Pflicht (jeder Agent aktualisiert die INDEX.md seines Zielordners)
- das Handoff-Protokoll (jedes Artefakt endet mit einem Übergabe-Block)
- die Abschluss-Pflicht (jede Agenten-Antwort endet mit dem nächsten Slash Command)
- die Gate-Selbstprüfung (Definition-of-Done-Checkliste vor Abschluss)
- das Rückfragen-Protokoll (offene Fragen strukturiert auflisten statt raten)

Kein Agent setzt eine Technologie voraus — alle Entscheidungen werden in `ADR-001-tech-stack.md`
dokumentiert und sind ab APPROVED verbindlich für alle nachfolgenden Agenten.

---

## ORCH — Orchestrator

**Datei:** `orchestrator.md`  
**Kürzel:** ORCH  
**Aktiviert durch:** `/status`, `/sprint`

Der Orchestrator ist der einzige Agent, der keine fachlichen Inhalte produziert — er kennt
nur Zustand und Regeln. Er liest Projektzustände, bewertet Gates und entscheidet, welcher
Agent als nächstes aktiv wird.

**Zwei Modi:**
- *Status-Modus* (`/status`): Liest `.phase` und `INDEX.md`, analysiert Gate-Kriterien, gibt
  Statusbericht mit nächster empfohlener Aktion aus. Keine Artefakt-Produktion.
- *Sprint-Modus* (`/sprint`): Orchestriert den vollständigen Sprint-Zyklus Phase für Phase.
  Aktiviert jeden Agenten, prüft Gates, stoppt bei BLOCKER und wartet auf Nutzer-Entscheidung.

**Eskalationslogik:** BLOCKER → Stop. MAJOR → Warnung + Nutzer-Bestätigung. MINOR → als TODO
in nächste Phase übernehmen. ADR-001 fehlt bei Implementierung → Hard-Stop zu `/architect`.

---

## PM — Product Manager

**Datei:** `pm-agent.md`  
**Kürzel:** PM  
**Aktiviert durch:** `/kickoff`  
**Primäres Artefakt:** `SB-NNN` (Stakeholder Brief)

Der PM-Agent ist der erste Kontaktpunkt der Tool Chain. Er führt Stakeholder-Interviews durch
und übersetzt Geschäftsziele in strukturierte Anforderungsdokumente.

**Interview-Ablauf:** 5 Runden à 3–5 Fragen: Problemraum & Vision → Nutzer & Stakeholder →
Scope & Abgrenzung → Erfolgskriterien & Messbarkeit → Constraints & Risiken.

**Kernaufgaben:** Scope abgrenzen (In-Scope / Out-of-Scope), MoSCoW-Priorisierung erstellen,
Top-3-Risiken benennen, alle offenen Fragen protokollieren.

**Übergabe an:** BA-Agent — gibt Stakeholder Brief, Priorisierung, Constraints und offene Fragen weiter.

---

## BA — Business Analyst

**Datei:** `ba-agent.md`  
**Kürzel:** BA  
**Aktiviert durch:** `/ba`, `/refine`  
**Primäre Artefakte:** `REQ-NNN` (Requirements), `US-NNN` (User Stories)

Der BA-Agent übersetzt den Stakeholder Brief in entwicklungsfähige Anforderungen. Er ist die
Brücke zwischen fachlicher Vision und technischer Umsetzung.

**Kernaufgaben:** Requirements-Dokument aus Stakeholder Brief ableiten, User Stories mit
Given/When/Then-Akzeptanzkriterien formulieren, Story-Map mit Abhängigkeiten erstellen,
Edge Cases und Ausnahmeflüsse explizit dokumentieren.

**Qualitätscheck:** Jede Story braucht ≥ 3 Akzeptanzkriterien, eine "damit"-Clause (Nutzen)
und muss von den Must-Have-Einträgen aus der MoSCoW-Priorisierung abgedeckt sein.

**Übergabe an:** Architect-Agent — gibt Requirements, User Stories, kritische NFRs und
Priorisierungsreihenfolge weiter.

---

## AR — Software Architect

**Datei:** `architect-agent.md`  
**Kürzel:** AR  
**Aktiviert durch:** `/architect`, `/spike`  
**Primäre Artefakte:** `ADR-NNN` (Architecture Decision Records), `STRUCTURE.md`

Der Architect-Agent definiert die technische Grundlage. Alle seine Entscheidungen werden
als ADRs dokumentiert — mit Begründung und explizit genannten verworfenen Alternativen.

**Kernaufgaben:** Tech-Stack-Entscheidung (ADR-001) treffen, weitere ADRs für jede wesentliche
Einzelentscheidung schreiben (Faustregel: wenn die Alternative ernsthaft diskutiert wurde →
ADR schreiben), Systemdesign als ASCII- oder Mermaid-Diagramm, Projektstruktur (STRUCTURE.md).

**Prinzip:** Jede Entscheidung muss begründet sein. Sicherheit und Datenschutz sind
First-Class-Concerns. Reversible von irreversiblen Entscheidungen explizit unterscheiden.

**Übergabe an:** UX-Agent und Dev-Agenten — gibt verbindlichen Tech-Stack, alle ADRs und
Projektstruktur weiter.

---

## UX — UX Designer

**Datei:** `ux-agent.md`  
**Kürzel:** UX  
**Aktiviert durch:** `/ux`  
**Primäres Artefakt:** `UX-NNN` (UX-Spec)

Der UX-Agent gestaltet die Nutzererfahrung auf Basis der User Stories und technischen
Constraints. Er produziert UX-Specs, die dem Frontend-Agenten als verbindliche Grundlage
dienen — ohne bestimmte Design-Tools vorauszusetzen.

**Kernaufgaben:** User Journeys als nummerierte Schritt-Listen (Schritt → Aktion →
Systemreaktion → Nächster State), alle UI-Zustände beschreiben (leer, geladen, loading,
Fehler, Erfolg), Edge Cases und Fehlerflüsse, Microcopy, Accessibility-Level (WCAG).

**Format:** Keine Wireframe-Bilder nötig — beschreibende Text-Specs mit ASCII-Layouts
für komplexe Strukturen sind ausreichend.

**Übergabe an:** Frontend-Agent — gibt UX-Specs, primäre Journeys, Design-System und
Accessibility-Level weiter.

---

## FE — Frontend Developer

**Datei:** `frontend-agent.md`  
**Kürzel:** FE  
**Aktiviert durch:** `/implement fe`, `/implement all`  
**Output:** Komponenten-Code + Unit-Tests

Der Frontend-Agent implementiert die Benutzeroberfläche nach UX-Spec und den festgelegten
Technologien aus ADR-001. Er arbeitet Bottom-Up: atomare Elemente zuerst, dann Moleküle,
dann Seiten.

**Kernaufgaben:** Für jede Komponente: Datei-Header (Artefakt-Referenz), vollständige
Typisierung (kein `any`), DocStrings für alle öffentlichen Funktionen, alle UI-Zustände
implementieren, Accessibility-Attribute (aria-*, role, tabIndex), Unit-Tests mit
Happy Path + Error Case.

**Pflichtkommentare im Code:** `// Implementiert: [US-NNN]` und `// Verwendet: [ADR-NNN]`

**Übergabe an:** QA-Agent — gibt implementierte Stories, Komponenten-Übersicht, bekannte
Einschränkungen und Test-Coverage-Stand weiter.

---

## BE — Backend Developer

**Datei:** `backend-agent.md`  
**Kürzel:** BE  
**Aktiviert durch:** `/implement be`, `/implement all`  
**Output:** API-Kontrakt + Backend-Code + DB-Migrationen + Tests

Der Backend-Agent implementiert serverseitige Logik, Datenschicht und APIs. Er arbeitet
API-First: Der API-Kontrakt (OpenAPI / GraphQL Schema) wird erstellt, bevor eine einzige
Code-Zeile geschrieben wird.

**Kernaufgaben:** API-Kontrakt erstellen, dann Datenschicht (Modelle, Migrationen) →
Business Logic (Services, Use Cases) → API-Layer (Controller, Resolver, Handler).

**Sicherheits-Checkliste (für jede Funktion):** Input-Validierung, parametrisierte Queries
(SQL-Injection-Schutz), Auth-Check für geschützte Endpoints, keine Secrets in Logs.

**Pflichtkommentare:** `// Implementiert: [US-NNN]`, `// Sicherheitshinweis: [...]`

**Übergabe an:** FE-Agent (API-Kontrakt) und QA-Agent (implementierte Stories, Migrationen,
Umgebungsvariablen für Tests).

---

## QA — QA Engineer

**Datei:** `qa-agent.md`  
**Kürzel:** QA  
**Aktiviert durch:** `/test-plan`, `/test-run`  
**Primäre Artefakte:** `TP-NNN` (Testplan), `TR-NNN` (Testergebnis), `BUG-NNN` (Fehler)

Der QA-Agent sichert die Qualität auf zwei Ebenen: Testplan erstellen (Phase A) und
Tests ausführen (Phase B).

**Phase A — Testplan:** Für jede User Story mindestens einen positiven Testfall (Happy Path),
einen negativen Testfall und Boundary-Tests. Sicherheitstests für auth-relevante Features.
Priorisierung in P0 (blocker), P1 (kritisch), P2 (normal).

**Phase B — Testausführung:** Unit → Integration → E2E ausführen, Fehler als BUG-NNN
erfassen (Schweregrad: BLOCKER / CRITICAL / MAJOR / MINOR), Coverage-Report generieren,
Freigabe-Empfehlung (APPROVED / CONDITIONAL / REJECTED) dokumentieren.

**Übergabe an:** Code Reviewer — gibt Testplan, Ergebnisse, Coverage, offene Bugs und
Freigabe-Empfehlung weiter.

---

## RV — Code Reviewer

**Datei:** `reviewer-agent.md`  
**Kürzel:** RV  
**Aktiviert durch:** `/review`  
**Primäres Artefakt:** `RV-NNN` (Review-Bericht)

Der Reviewer-Agent führt die finale technische Qualitätsprüfung durch — unabhängig von
den Entwicklungsagenten, objektiv.

**6 Review-Dimensionen (in dieser Reihenfolge):**
1. Korrektheit — Alle Akzeptanzkriterien implementiert? API-Kontrakt eingehalten?
2. Sicherheit — Input-Validierung, keine Secrets, Auth korrekt, Injection-Schutz?
3. ADR-Konformität — Tech-Stack und alle weiteren ADRs eingehalten?
4. Code-Qualität — Kommentierungsstandard, Datei-Header, keine Magic Numbers?
5. Testabdeckung — Unit-Tests für Kernfunktionen, Happy Path + Fehlerfall?
6. Performance & Wartbarkeit — N+1 Queries, Lesbarkeit, angemessene Komplexität?

**Entscheidungen:** APPROVED / REQUEST CHANGES / REJECTED — jeweils mit Begründung.
Technische Schulden werden als DEBT-NNN erfasst.

---

## MW — Manual Writer

**Datei:** `manual-writer-agent.md`  
**Kürzel:** MW  
**Aktiviert durch:** `/manual`  
**Primäre Artefakte:** `DOC-NNN` (Feature-Guide), `RN-NNN` (Release Notes), `GS-001` (Getting Started)

Der Manual Writer schreibt ausschließlich für menschliche Endnutzer — nicht für Entwickler.
Er tritt als letzte Phase eines Sprints in Aktion, nach erfolgreichem Code Review.

**Leitprinzipien:** Schreibe für den Nutzer (keine Fachbegriffe ohne Erklärung), zeig statt
erkläre (nummerierte Schritt-für-Schritt-Anleitungen mit Aktion + Systemreaktion), vollständig
aber kompakt (kein Marketingtext).

**Kernaufgaben:** Feature-Guides pro Nutzer-Ziel-Gruppe, Release Notes mit Übersicht der
neuen Features, Getting-Started-Guide beim ersten Sprint. Screenshot-Platzhalter setzen wo nötig.

**Übergabe an:** Orchestrator (Sprint-Abschluss) — Sprint wird in REGISTRY.md als DONE markiert.

---

## AC — Agile Coach

**Datei:** `agile-coach-agent.md`  
**Kürzel:** AC  
**Aktiviert durch:** `/retro`, `/health-check`, `/coach`, `/impediment`  
**Primäre Artefakte:** `RETRO-NNN`, `IMPD-NNN`, `PC-NNN`

Der Agile Coach ist der einzige Agent, der den **Prozess selbst** hinterfragt — nicht die
Inhalte. Er hat keine fachliche Meinung, analysiert aber wie die Tool Chain arbeitet.

**Vier Aktivierungsszenarien:**
- `/retro`: Nach Sprint-Abschluss — strukturierte Retrospektive mit Keep/Stop/Start.
  Stellt 2–3 gezielte Fragen an den Nutzer vor der Analyse.
- `/health-check`: Nach 3+ Sprints — systemische Muster über mehrere Sprints hinweg.
  Gibt priorisierten Process Change Proposal mit 3–7 Verbesserungen.
- `/coach`: Nutzer hat ein konkretes Prozess-Problem formuliert. Diagnose und
  handlungsorientierte Empfehlung mit Dateireferenz.
- `/impediment`: Nutzer spürt Friction, kann sie aber noch nicht benennen. Führt
  5–6-Fragen-Interview durch (Symptom → Frequenz → Auswirkung → Umgehungen → Ziel),
  dann Diagnose und Impediment-Dokument (IMPD-NNN).

**Haltung:** Kein Dogmatismus — Prozesse dienen Menschen, nicht umgekehrt. Die beste
Verbesserung ist die, die tatsächlich umgesetzt wird.
