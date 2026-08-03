# Agents Summary — AI Development Tool Chain

Konsolidierte Übersicht aller Agenten-Rollen.  
Zweck: Einzelne Referenzdatei für NotebookLM-Analyse und schnelle Orientierung.

**Letzte Aktualisierung:** 2026-08-03  
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
- die Regel "Statusnarrative sind Projektionen, keine Quelle der Wahrheit" — Freitext-
  Statusabschnitte in INDEX.md (z. B. "In Bearbeitung") gelten als ungeprüfte Behauptung, nicht
  als Fakt, und müssen vor Weiterverwendung gegen Primärevidenz (git log/status, Dateien,
  DoD-Checkboxen) gegengeprüft werden

**GitHub-Board-Sync (optional, `github.enabled: true`):** PM, BA, UX, FE, BE, QA, RV und MW
führen zu Beginn ihres jeweiligen Vorgehens `github-board-sync -Mode reconcile` und an
dessen Ende `-Mode push` selbstständig aus (siehe `toolchain/protocols/github-board-sync.md`)
— unabhängig davon, ob die Phase über `/sprint` oder direkt aufgerufen wird. QA (`/test-run`)
und RV (`/review`) übertragen beim Anlegen neuer `BUG-NNNNNN`/`DEBT-NNNNNN` zusätzlich das
`epic`-Feld der auslösenden Story, damit neue Fehler/Schulden demselben GitHub-Milestone
zugeordnet werden wie die zugehörige Story.

Kein Agent setzt eine Technologie voraus — alle Entscheidungen werden in `ADR-000001-tech-stack.md`
dokumentiert und sind ab APPROVED verbindlich für alle nachfolgenden Agenten.

---

## ORCH — Orchestrator

**Datei:** `orchestrator.md`  
**Kürzel:** ORCH  
**Aktiviert durch:** `/status`, `/sprint`, `/analyze`

Der Orchestrator ist der einzige Agent, der keine fachlichen Inhalte produziert — er kennt
nur Zustand und Regeln. Er liest Projektzustände, bewertet Gates und entscheidet, welcher
Agent als nächstes aktiv wird.

**Drei Modi:**
- *Status-Modus* (`/status`): Liest `.phase` und `INDEX.md`, analysiert Gate-Kriterien, gibt
  Statusbericht mit nächster empfohlener Aktion aus. Keine Artefakt-Produktion.
- *Sprint-Modus* (`/sprint`): Orchestriert den vollständigen Sprint-Zyklus Phase für Phase.
  Aktiviert jeden Agenten, prüft Gates, stoppt bei BLOCKER und wartet auf Nutzer-Entscheidung.
- *Analyze-Modus* (`/analyze` optional; automatisch als `/implement`-Preflight):
  Cross-Artefakt-Konsistenzprüfung zwischen REQ/US, ADR, UX, SP und CON-000001 — Gate 5.5.
  Prüft strukturell (`cross-ref`)
  und lässt Artefakte inhaltlich Selbstauskunft geben (`self-assertion`); löst Widersprüche
  nicht selbst auf, sondern ordnet sie dem zuständigen Agenten zu (BA/AR/UX/PM).

**Eskalationslogik:** BLOCKER → Stop. MAJOR → Warnung + Nutzer-Bestätigung. MINOR → als TODO
in nächste Phase übernehmen. ADR-000001 fehlt bei Implementierung → Hard-Stop zu `/architect`.
Gate-5.5-Preflight BLOCKER offen → Hard-Stop ohne implizite Freigabe zum
fundverursachenden Agenten.

Beim expliziten Start des logisch nächsten Commands werden eindeutige `REVIEW`-Artefakte
nach bestandenem Gate auf `APPROVED` gesetzt; `.phase` protokolliert Command und
Freigabequelle.

**Statusprojektion gegenprüfen:** Vor Übernahme von INDEX.md-Freitextstatus in einen
Statusbericht prüft ORCH die konkret prüfbaren Behauptungen darin gegen Primärevidenz
(`git log`/`git status`, Dateien, DoD-Checkboxen) und korrigiert Abweichungen sichtbar, statt
sie unkommentiert zu übernehmen — besonders beim Wiederbetreten eines unterbrochenen Sprints.

**Sprint-Worktree (Phase 6–9):** Beim erstmaligen Betreten von Phase 6 legt ORCH einen
Git-Worktree auf `feature/sprint-N` an (`.phase`-Felder `worktree-path`/`worktree-branch`);
FE/BE/QA/RV/MW arbeiten bis Gate 9 dort statt im Haupt-Checkout. Bei Wiederaufnahme nach
Unterbrechung wird der bestehende Worktree wiederbetreten, nie neu angelegt. Merge, Tag und
Worktree-Cleanup erfolgen gebündelt in Phase 10 (Release) — `git push` und Worktree-/Branch-
Entfernung erfordern explizite Nutzerbestätigung. Gilt nur für den regulären Sprint-Workflow,
nicht für `/hotfix`, `/spike` oder `/converge` (siehe `toolchain/workflows/full-sprint.md`
Abschnitt "Worktree-Isolation").

---

## PM — Product Manager

**Datei:** `pm-agent.md`  
**Kürzel:** PM  
**Aktiviert durch:** `/kickoff`  
**Primäres Artefakt:** `SB-NNNNNN` (Stakeholder Brief)

Der PM-Agent ist der erste Kontaktpunkt der Tool Chain. Er führt Stakeholder-Interviews durch
und übersetzt Geschäftsziele in strukturierte Anforderungsdokumente.

**Interview-Ablauf:** 5 Runden à 3–5 Fragen: Problemraum & Vision → Nutzer & Stakeholder →
Scope & Abgrenzung → Erfolgskriterien & Messbarkeit → Constraints & Risiken.

**Kernaufgaben:** Scope abgrenzen (In-Scope / Out-of-Scope), MoSCoW-Priorisierung erstellen,
Top-3-Risiken benennen, alle offenen Fragen protokollieren. Erstellt zusätzlich die
**Projekt-Constitution** (`CON-000001`) — nicht verhandelbare Prinzipien und Qualitäts-
Mindeststandards, synthetisiert aus dem Interview (Schwerpunkt Runde 4+5), bindend für alle
nachfolgenden Agenten ab Status APPROVED.

**Übergabe an:** BA-Agent — gibt Stakeholder Brief, Priorisierung, Constraints und offene Fragen weiter.

**Externe Recherche:** Kann für Wettbewerbs-/Marktanalyse den MCP-Server `fetch` nutzen
(siehe CLAUDE.md, Abschnitt "Externe Recherche").

**GitHub-Board (optional):** Fragt explizit, ob das Projekt in einem GitHub Project Board
geführt werden soll; bei Zustimmung Provisionierung (`gh project create`, `.toolchain.yml`
befüllen) — siehe `toolchain/protocols/github-board-sync.md`.

---

## BA — Business Analyst

**Datei:** `ba-agent.md`  
**Kürzel:** BA  
**Aktiviert durch:** `/ba`, `/refine`  
**Primäre Artefakte:** `REQ-NNNNNN` (Requirements), `US-NNNNNN` (User Stories),
`EPIC-NNNNNN` (Epics), `RM-NNNNNN` (Roadmap/Release-Plan)

Der BA-Agent übersetzt den Stakeholder Brief in entwicklungsfähige Anforderungen. Er ist die
Brücke zwischen fachlicher Vision und technischer Umsetzung.

**Kernaufgaben:** Requirements-Dokument aus Stakeholder Brief ableiten, User Stories mit
Given/When/Then-Akzeptanzkriterien formulieren, Story-Map mit Abhängigkeiten erstellen,
Edge Cases und Ausnahmeflüsse explizit dokumentieren. Bildet zusätzlich Epics aus
zusammengehörigen Stories und plant in `RM-NNNNNN` den GESAMTEN Projekt-Scope voraus
(Priorität, Schätzung, Size, Iteration, Zeitrahmen je Story — nicht nur für den nächsten
Sprint).

**Qualitätscheck:** Jede Story braucht ≥ 3 Akzeptanzkriterien, eine "damit"-Clause (Nutzen)
und muss von den Must-Have-Einträgen aus der MoSCoW-Priorisierung abgedeckt sein. Jede
Story ist einem Epic zugeordnet (oder bewusst epic-los); `RM-NNNNNN` deckt jede Story im
Gesamtscope ab.

**Übergabe an:** Architect-Agent — gibt Requirements, User Stories, kritische NFRs und
Priorisierungsreihenfolge weiter.

**Externe Recherche:** Kann für fachliche Standards/Domänen-Referenzen den MCP-Server
`fetch` nutzen (siehe CLAUDE.md, Abschnitt "Externe Recherche").

**GitHub-Board-Sync (optional):** Führt `reconcile` zu Beginn und `push` am Ende aus (siehe
`toolchain/protocols/github-board-sync.md`) — der `push`-Lauf nach `/ba` überträgt den
GESAMTEN vorausgeplanten Backlog (Epics als Milestones, Stories mit allen Feldern) auf das
Board, nicht nur Sprint 1.

---

## AR — Software Architect

**Datei:** `architect-agent.md`  
**Kürzel:** AR  
**Aktiviert durch:** `/architect`, `/spike`, `/converge`  
**Primäre Artefakte:** `ADR-NNNNNN` (Architecture Decision Records), `STRUCTURE.md`

Der Architect-Agent definiert die technische Grundlage. Alle seine Entscheidungen werden
als ADRs dokumentiert — mit Begründung und explizit genannten verworfenen Alternativen.

**Kernaufgaben:** Tech-Stack-Entscheidung (ADR-000001) treffen, weitere ADRs für jede wesentliche
Einzelentscheidung schreiben (Faustregel: wenn die Alternative ernsthaft diskutiert wurde →
ADR schreiben), Systemdesign als ASCII- oder Mermaid-Diagramm, Projektstruktur (STRUCTURE.md).

**Prinzip:** Jede Entscheidung muss begründet sein. Sicherheit und Datenschutz sind
First-Class-Concerns. Reversible von irreversiblen Entscheidungen explizit unterscheiden.
Standardpräferenz Architekturschema: **Microservices vor Monolith** — ein Monolith ist nur mit
expliziter Begründung der Abweichung (z. B. kleines Team, kein Ops für verteilte Systeme,
kleiner Scope) im ADR zulässig.

**Container-Prinzip:** Bei Containerisierung legt der AR-Agent Base-Image-Strategie und
Größenbudget im ADR fest (Distroless/Alpine/Slim, Multi-Stage-Builds als Standard) — bindend
für den BE-Agenten. Kein eigener Agent dafür; Umsetzung erfolgt über AR (Vorgabe) und BE
(Umsetzung + Prüfung), siehe unten.

**CI-Build-Empfehlung:** Bei Containerisierung + GitHub Actions erwägt der AR-Agent die
wiederverwendbaren Workflows aus [docker/github-builder](https://github.com/docker/github-builder)
(`build.yml`/`bake.yml`) als Standardoption im ADR statt eigener buildx-Cache-/Multi-Platform-
Logik — signierter GHA-Cache, SLSA-Provenance via OIDC, Keyless-Registry-Auth. Abweichung ist
im ADR zu begründen.

**Übergabe an:** UX-Agent und Dev-Agenten — gibt verbindlichen Tech-Stack, alle ADRs und
Projektstruktur weiter.

**Spike-Modus (`/spike`):** Zeitlich strikt begrenzte technische Erkundung ohne Sprint- oder
ADR-Verpflichtung — übernimmt das Spike-Brief vom PM-Agenten (Fragestellung, Timebox,
Erfolgskriterien), recherchiert/prototypt innerhalb der Timebox und liefert `SRP-NNNNNN`
(Spike Report) mit expliziter Empfehlung. Übergabe geht an PM/Nutzer, nicht an einen
Entwicklungsagenten.

**Converge-Modus (`/converge`):** Bestandsaufnahme einer bereits existierenden Codebase
gegenüber vorhandener Spezifikation (REQ/US/ADR) — für Brownfield-Übernahme in die Tool Chain
oder bei Verdacht auf Spec-Drift. Scannt Code, gleicht mit REQ/US (Abdeckungsmatrix) und ADRs
(Architektur-Drift) ab und liefert `GAP-NNNNNN` mit expliziter Empfehlung (retroaktive
Artefakte anlegen / Stories als DONE markieren / Drift auflösen). Kein Code Review, kein
automatischer Fix. `.phase` wird nach Abschluss zurückgesetzt — kein Phasenwechsel.

**Externe Recherche:** Kann für Tech-Stack-Evaluierung und Spike-Recherche den MCP-Server
`fetch` nutzen (siehe CLAUDE.md, Abschnitt "Externe Recherche").

**Codebase-Intelligenz:** Nutzt für den Converge-Scan und die Ist-Architektur-Erfassung den
MCP-Server `codebase-memory` (siehe CLAUDE.md, Abschnitt "Codebase-Intelligenz") —
strukturelle Graph-Queries statt Datei-für-Datei-Lesen.

---

## UX — UX Designer

**Datei:** `ux-agent.md`  
**Kürzel:** UX  
**Aktiviert durch:** `/ux`  
**Primäres Artefakt:** `UX-NNNNNN` (UX-Spec)

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
Technologien aus ADR-000001. Er arbeitet Bottom-Up: atomare Elemente zuerst, dann Moleküle,
dann Seiten.

**Kernaufgaben:** Für jede Komponente: Datei-Header (Artefakt-Referenz), vollständige
Typisierung (kein `any`), DocStrings für alle öffentlichen Funktionen, alle UI-Zustände
implementieren, Accessibility-Attribute (aria-*, role, tabIndex), Unit-Tests mit
Happy Path + Error Case.

**Pflichtkommentare im Code:** `// Implementiert: [US-NNNNNN]` und `// Verwendet: [ADR-NNNNNN]`

**Bugfix-Modus:** Bei Rücksprung aus Gate 7 (`BUG-NNNNNN` zugewiesen an FE) ist die
Root-Cause-Analyse in `BUG-NNNNNN` vor jeder Code-Änderung Pflicht — kein Fix ohne
dokumentierte direkte und systemische Ursache. Ein Regressionstest, der den ursprünglichen
Fehler abdeckt, ist Teil des Fixes, nicht optional.

**Übergabe an:** QA-Agent — gibt implementierte Stories, Komponenten-Übersicht, bekannte
Einschränkungen und Test-Coverage-Stand weiter.

**Codebase-Intelligenz:** Bei Änderungen an bestehendem Code nutzt FE den MCP-Server
`codebase-memory` (siehe CLAUDE.md, Abschnitt "Codebase-Intelligenz"), um Verwendungsstellen
zu finden — insbesondere zur Root-Cause-Suche im Bugfix-Modus. Am Ende der Implementierung
aktualisiert FE den Graphen (`index_repository`, `mode='fast'`), da FE üblicherweise der letzte
Schritt vor `/test-plan`/`/review` ist.

**Sprint-Worktree:** Arbeitet, sofern `.phase` ein `worktree-path` gesetzt hat, ausschließlich
im Sprint-Worktree (`feature/sprint-N`), nicht im Haupt-Checkout.

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

**Container-Checkliste (nur bei Containerisierung laut ADR-000001):** Kleinstes passendes
Base-Image, Multi-Stage-Build (Build-Tooling nie im Runtime-Image), nur Produktions-
Dependencies im finalen Layer, Cache-effiziente Layer-Reihenfolge, Image-Größe gegen
ADR-Budget geprüft und im Handoff dokumentiert. Falls ADR `docker/github-builder` vorsieht:
lokal gegen dieselbe Bake-/Dockerfile-Definition testen, die der CI-Workflow nutzt.

**Pflichtkommentare:** `// Implementiert: [US-NNNNNN]`, `// Sicherheitshinweis: [...]`

**Bugfix-Modus:** Bei Rücksprung aus Gate 7 (`BUG-NNNNNN` zugewiesen an BE) ist die
Root-Cause-Analyse in `BUG-NNNNNN` vor jeder Code-Änderung Pflicht — kein Fix ohne
dokumentierte direkte und systemische Ursache. Ein Regressionstest, der den ursprünglichen
Fehler abdeckt, ist Teil des Fixes, nicht optional.

**Übergabe an:** FE-Agent (API-Kontrakt) und QA-Agent (implementierte Stories, Migrationen,
Umgebungsvariablen für Tests).

**Codebase-Intelligenz:** Bei Änderungen an bestehendem Code nutzt BE den MCP-Server
`codebase-memory` (siehe CLAUDE.md, Abschnitt "Codebase-Intelligenz"), um Aufrufketten und
betroffene Stellen zu finden — insbesondere zur Root-Cause-Suche im Bugfix-Modus. Am Ende der
Implementierung aktualisiert BE den Graphen (`index_repository`, `mode='fast'`) — aber nur,
wenn kein anschließender FE-Schritt folgt (sonst übernimmt das FE, um einen doppelten Lauf zu
vermeiden).

**Sprint-Worktree:** Arbeitet, sofern `.phase` ein `worktree-path` gesetzt hat, ausschließlich
im Sprint-Worktree (`feature/sprint-N`), nicht im Haupt-Checkout.

---

## QA — QA Engineer

**Datei:** `qa-agent.md`  
**Kürzel:** QA  
**Aktiviert durch:** `/test-plan`, `/test-run`  
**Primäre Artefakte:** `TP-NNNNNN`, `TR-NNNNNN`, `BUG-NNNNNN` — alle in `projects/<name>/testing/`

Der QA-Agent sichert die Qualität auf zwei Ebenen: Testplan erstellen (Phase A) und
Tests ausführen (Phase B).

**Phase A — Testplan:** Für jede User Story mindestens einen positiven Testfall (Happy Path),
einen negativen Testfall und Boundary-Tests. Sicherheitstests für auth-relevante Features.
Priorisierung in P0 (blocker), P1 (kritisch), P2 (normal). Enthält Playwright E2E Inventar
(Sektion 3.3): Testdateien, Page Objects, benötigte `data-testid` Attribute, Voraussetzungen,
und explizit Browser-Clickpfade. Performanztestfälle stehen in einer eigenen Sektion 3.4.

**Phase B — Testausführung:** Unit → Integration → E2E (Playwright) → Performanztests ausführen.
Playwright-spezifisch: `playwright.config.ts` prüfen, `npx playwright test --reporter=html`
in einem Durchlauf ausführen — wichtige UI-Clickpfade bevorzugt im Browser-View bzw. im
headed/UI-Modus, sonst headless mit dokumentierter Begründung —, HTML-Report nach
`projects/<name>/testing/playwright-report/` ablegen.
Fehler als BUG-NNNNNN erfassen (inkl. Screenshot- und Trace-Pfad), Coverage-Report generieren,
Performanz-Metriken gegen dokumentierte Zielwerte erfassen und Freigabe-Empfehlung
(APPROVED / CONDITIONAL / REJECTED) dokumentieren.

**Bug-Erfassung & Re-Verifikation:** Neue Fehler werden als `BUG-NNNNNN` mit
`toolchain/templates/bug-report.md` erfasst — Symptom, Reproduktionsschritte und Evidenz durch
QA, der Abschnitt "Root-Cause" bleibt bewusst offen für FE/BE. Zurückgemeldete Bugs (Status
`BEHOBEN`) werden erneut reproduziert; erst nach erfolgreicher Verifikation wird der Status auf
`VERIFIZIERT` gesetzt — ein Bug gilt bis dahin als offen (Gate 7).

**Übergabe an:** Code Reviewer — gibt Testplan, Ergebnisse, Coverage, Browser-Clickpfad- und
Performanz-Ergebnisse, offene Bugs, Playwright-Report-Pfad und Freigabe-Empfehlung weiter.

**Codebase-Intelligenz:** Kann für die Identifikation von totem Code und ungetesteten Pfaden
den MCP-Server `codebase-memory` nutzen (siehe CLAUDE.md, Abschnitt "Codebase-Intelligenz") —
ergänzt, ersetzt aber nicht den Test-Coverage-Report.

---

## RV — Code Reviewer

**Datei:** `reviewer-agent.md`  
**Kürzel:** RV  
**Aktiviert durch:** `/review`  
**Primäres Artefakt:** `RV-NNNNNN` (in `projects/<name>/reviews/`), ggf. `DEBT-NNNNNN` (in `projects/<name>/retros/`)

Der Reviewer-Agent führt eine **zweistufige Abnahme** durch: erst Nutzerabnahme (Phase A),
dann technisches Code Review (Phase B).

**Phase 0 — Container-Refresh (falls `docker-compose.yml` im Projekt existiert):**
`docker compose build app && docker compose up -d app`, Healthcheck abwarten. Verhindert,
dass der Nutzer in Phase A gegen ein Image aus einem früheren Sprint testet (falsche
"Feature fehlt"-Befunde). Kein Compose-Setup → Schritt entfällt.

**Phase A — Nutzerabnahme (2 Schritte):**
1. Sprint-Übersicht + Test-Guide: Unmittelbar vor dem manuellen Test alle Sprint-User-Stories
   (Titel + Nutzen), Defects (Symptom + Status, auch behobene) und MINOR-Befunde
   (Inhalt + Status) kurz aus SP/US/TR/BUG sowie bei Re-Reviews aus früheren RV-Berichten
   benennen, deduplizieren und leere Gruppen als „Keine“ ausweisen. Direkt danach
   nutzerfreundliche, nummerierte Schritte pro Feature aus US-NNNNNN und TP-NNNNNN
   präsentieren. Kein Tech-Jargon. Pausiert anschließend — Nutzer testet eigenständig.
2. Nutzer-Interview: Strukturierte Befragung pro Feature (funktioniert? unerwartetes Verhalten?
   UX-Eindruck? Änderungswünsche?). Ergibt Befund: ACCEPTED / CONDITIONAL / REJECTED.

**Phase B — Technisches Code Review (6 Dimensionen):**
1. Korrektheit — Alle Akzeptanzkriterien implementiert? API-Kontrakt eingehalten?
2. Sicherheit — Input-Validierung, keine Secrets, Auth korrekt, Injection-Schutz?
3. ADR-Konformität — Tech-Stack und alle weiteren ADRs eingehalten?
4. Code-Qualität — Kommentierungsstandard, Datei-Header, keine Magic Numbers?
5. Testabdeckung — Unit-Tests, E2E (Playwright), Happy Path + Fehlerfall?
6. Performance & Wartbarkeit — N+1 Queries, Lesbarkeit, angemessene Komplexität?

**Gesamtentscheidung** kombiniert Nutzer-Befund + technischen Review.
REJECTED durch Nutzer überstimmt technisch APPROVED.
Technische Schulden als DEBT-NNNNNN in `projects/<name>/retros/` erfasst.

**Codebase-Intelligenz:** Nutzt für die Change-Impact-Einschätzung des Diffs den MCP-Server
`codebase-memory` (`detect_changes` — siehe CLAUDE.md, Abschnitt "Codebase-Intelligenz").

---

## MW — Manual Writer

**Datei:** `manual-writer-agent.md`  
**Kürzel:** MW  
**Aktiviert durch:** `/manual`  
**Primäre Artefakte:** `DOC-NNNNNN` (Feature-Guide), `RN-NNNNNN` (Release Notes), `GS-000001` (Getting Started), `FAQ-NNNNNN` (ab Sprint 2 / bei Bedarf)

Der Manual Writer schreibt ausschließlich für menschliche Endnutzer — nicht für Entwickler.
Er tritt als letzte Phase eines Sprints in Aktion, nach erfolgreichem Code Review.

**Leitprinzipien:** Schreibe für den Nutzer (keine Fachbegriffe ohne Erklärung), zeig statt
erkläre (nummerierte Schritt-für-Schritt-Anleitungen mit Aktion + Systemreaktion), vollständig
aber kompakt (kein Marketingtext).

**Kernaufgaben:** Feature-Guides pro Nutzer-Ziel-Gruppe, Release Notes mit Übersicht der
neuen Features, Getting-Started-Guide beim ersten Sprint, FAQ ab Sprint 2 bzw. bei erkennbarem
Bedarf. Screenshot-Platzhalter setzen wo nötig. Zuarbeit zum projektweiten `DECISIONS.md`
(Terminologie- und Dokumentationsentscheidungen).

**Git-Abschluss (seit PC-000002):** Letzter Schritt vor der Übergabe — REGISTRY.md/`.phase`
aktualisieren, dann `git add`/`commit -m "feat(sprint-N): ..."`/`push` für den Sprint-Stand
im Projekt-eigenen Repository. Bei erkennbaren Fremdständen im Arbeitsverzeichnis oder
explizitem Nutzerwiderspruch vor dem Push anhalten und nachfragen, statt automatisch zu
pushen. Getrennt von Phase 10 (strategischer Merge/Tag gemäß Branching-ADR).

**Übergabe an:** Orchestrator (Sprint-Abschluss) — Sprint wird in REGISTRY.md als DONE markiert,
Git-Stand ist committed und gepusht.

---

## AC — Agile Coach

**Datei:** `agile-coach-agent.md`  
**Kürzel:** AC  
**Aktiviert durch:** `/retro`, `/health-check`, `/coach`, `/impediment`  
**Primäre Artefakte:** `RETRO-NNNNNN`, `IMPD-NNNNNN`, `PC-NNNNNN`

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
  dann Diagnose und Impediment-Dokument (IMPD-NNNNNN).

**Haltung:** Kein Dogmatismus — Prozesse dienen Menschen, nicht umgekehrt. Die beste
Verbesserung ist die, die tatsächlich umgesetzt wird.
