# Release Notes — AI Development Tool Chain

Änderungsprotokoll der Tool Chain selbst (nicht projektspezifischer Artefakte).  
Projektspezifische Release Notes werden als `RN-NNNNNN` in `projects/<name>/docs/` abgelegt.

**Pflege-Regel:** Jede strukturelle Änderung an Commands, Agenten, Templates oder Protokollen
wird hier als neuer Eintrag dokumentiert — mit Datum, beteiligten Dateien und Auswirkung.
Diese Datei wird in CLAUDE.md referenziert und ist Pflicht-Output bei Tool-Chain-Änderungen.

---

## v1.5 — 2026-07-17

### Neu

**Root-`.gitignore` + vollständiges `projects/_template/`-Skelett**
- Jedes `projects/<name>/` ist als eigenes Git-Repository vorgesehen (nicht Teil des
  Toolchain-Repos). Neues Root-`.gitignore` schließt `projects/*` aus — Ausnahmen:
  `REGISTRY.md` und `_template/` bleiben getrackt. Zusätzlich generelle Ignores für
  OS-Dateien, Editor-Ordner, Logs/Temp, `.env*`, `node_modules/` etc.
- `projects/_template/` von zwei Dateien (`.phase`, `INDEX.md`) auf vollständiges
  Projekt-Skelett erweitert: `.toolchain.yml`, `.toolchain-config`, `README.md`,
  `.gitignore` (Vorlage für das jeweilige Projekt-Repo) sowie alle Artefakt-Unterordner
  (`discovery/` inkl. `DECISIONS.md`, `requirements/`, `architecture/`, `ux/`, `sprints/`,
  `testing/`, `reviews/`, `docs/`, `retros/`) mit `.gitkeep`.
- Bewusst NICHT im Template enthalten: `src/`, `tests/`, `infra/`, `scripts/` — diese
  sind technologieabhängig und werden erst nach ADR-000001 vom Architect-Agenten angelegt
  (Prinzip "Keine Technologie-Annahmen", `_base-agent.md`).
- `CLAUDE.md` ("Neues Projekt starten") und `.claude/commands/kickoff.md` aktualisiert:
  neuer Ablauf ist Kopie aus `_template/` + `git init` im Projektordner statt leerem `mkdir`.
- Betroffen: `.gitignore` (neu), `projects/_template/**` (neu), `CLAUDE.md`,
  `.claude/commands/kickoff.md`, `.claude/commands/commands_summary.md`

### Bekannte Inkonsistenz (nicht in diesem Release behoben)

- `toolchain/agents/pm-agent.md` legt `SB-000001` noch direkt unter `projects/<name>/` ab,
  nicht unter `projects/<name>/discovery/` wie in CLAUDE.md ("Projektordner-Struktur", seit
  v1.2) vorgesehen. Betrifft nur Artefakt-Pfade innerhalb eines Projekt-Repos, nicht die
  Git-Struktur dieses Releases — separat zu beheben.

---

## v1.4 — 2026-07-17

### Geändert

**Architect-Agent: Standardpräferenz Microservices vor Monolith**
- Neue verbindliche Default-Regel im Architekturschema-Entscheid: Microservices sind das
  bevorzugte Schema. Ein Monolith (oder Modularer Monolith) ist nur mit expliziter,
  im ADR dokumentierter Begründung zulässig (z. B. kleines Team, fehlende Ops-Kapazität,
  kleiner Scope, harte Time-to-Market-Vorgabe).
- System-Prompt-Schritt "Identifiziere technische Kernentscheidungen" um den Punkt
  "Architekturschema: Microservices vs. Monolith" ergänzt, inkl. Hinweis auf
  Data-per-Service vs. geteilte DB bei Microservices.
- Definition-of-Done um Prüfpunkt "Architekturschema entschieden (Microservices-Default
  oder begründeter Monolith)" ergänzt.
- Betroffen: `toolchain/agents/architect-agent.md` (v1.1), `toolchain/agents/agents_summary.md`

### Neu

**Container-Image-Größenoptimierung: kein neuer Agent, verteilt auf AR + BE**
- Geprüft, ob ein eigener Agent für Container-Größenoptimierung sinnvoll ist — verworfen,
  da es sich um eine schmale technische Praxis (kein eigenständiger SDLC-Phasen-Schritt)
  handelt. Stattdessen in bestehende Rollen integriert:
- **AR-Agent:** Legt bei Containerisierung Base-Image-Strategie und Größenbudget im ADR
  fest (Distroless/Alpine/Slim bevorzugt, Multi-Stage-Build als Standard). Neues
  "Container-Prinzip" + DoD-Punkt.
- **BE-Agent:** Neue "Container-Checkliste" (parallel zur Sicherheits-Checkliste) — minimales
  Base-Image, Multi-Stage-Build, nur Produktions-Dependencies, cache-effiziente Layer,
  Image-Größe gegen ADR-Budget geprüft. Handoff an QA um Container-Image-Größe ergänzt.
  DoD-Punkt ergänzt.
- Betroffen: `toolchain/agents/architect-agent.md` (v1.1), `toolchain/agents/backend-agent.md`
  (v1.1), `toolchain/agents/agents_summary.md`

---

## v1.3 — 2026-06-21

### Geändert

**Artefakt-Nomenklatur: NNN → NNNNNN (drei → sechs Stellen)**
- Alle Artefakt-IDs und Dateinamen-Platzhalter verwenden ab sofort sechs Stellen: `NNNNNN`
- Beispiele: `SB-000001-projektname.md`, `US-000042-login.md`, `ADR-000001-tech-stack.md`
- `NNN = sechsstellig, sequenziell pro Projekt` (war: dreistellig)
- 58 Dateien aktualisiert: alle Agenten, Templates, Commands, Protokolle, Summary-Dateien
- Betroffen: gesamte `toolchain/`, `.claude/commands/`, `CLAUDE.md`

---

## v1.2 — 2026-06-21

### Neu

**Projektordner-Struktur — definierte Unterordner pro Artefakttyp**
- Neue Konvention in `CLAUDE.md` (Abschnitt "Projektordner-Struktur"):
  alle Artefakte liegen in typspezifischen Unterordnern von `projects/<name>/` —
  niemals im Projekt-Root: `discovery/`, `requirements/`, `architecture/`, `ux/`,
  `sprints/`, `testing/`, `reviews/`, `docs/`, `retros/`
- Alle betroffenen Agenten und Templates wurden mit Ordnerangaben aktualisiert

**`/review` — User Acceptance Review + Nutzer-Interview (2-stufige Abnahme)**
- Drei Phasen statt einer: (1) Test-Guide erstellen & präsentieren, (2) Nutzer-Interview,
  (3) technisches Code Review
- Phase 1: RV-Agent erstellt nutzerfreundlichen Test-Guide (klare Schritte, kein Jargon)
  aus US-NNNNNN und TP-NNNNNN — pausiert danach und wartet auf Nutzer
- Phase 2: Strukturiertes Interview zu jedem Feature — Befund: ACCEPTED / CONDITIONAL / REJECTED
- Phase 3: Technisches Review unverändert (6 Dimensionen)
- Gesamtentscheidung kombiniert Nutzer-Befund und technischen Review —
  REJECTED durch Nutzer überstimmt technisch APPROVED
- Betroffen: `.claude/commands/review.md`, `toolchain/agents/reviewer-agent.md` (v2.0),
  `toolchain/templates/review-checklist.md` (neuer Abschnitt "Teil 1: Nutzerabnahme"),
  `.claude/commands/commands_summary.md`, `toolchain/agents/agents_summary.md`

**Playwright E2E — explizite Integration in QA-Workflow**
- `test-plan.md` Template: neue Sektion 3.3 "Playwright E2E Testinventar"
  (Testdateien, Page Objects, benötigte `data-testid` Attribute, Voraussetzungen)
- `qa-agent.md`: Phase B System-Prompt mit Playwright-spezifischen Schritten erweitert
  (Config prüfen, `--reporter=html`, Report-Ablage, Screenshot/Trace-Pfade erfassen)
- `test-run.md`: Playwright-Befehle und Report-Ablage explizit dokumentiert
- Betroffen: `toolchain/templates/test-plan.md`, `toolchain/agents/qa-agent.md`,
  `.claude/commands/test-run.md`, `.claude/commands/commands_summary.md`,
  `toolchain/agents/agents_summary.md`

---

## v1.1 — 2026-06-19

### Neu

**`/impediment` — Impediment-Interview-Command**
- Neuer Slash Command für den Agile Coach (AC)
- Unterschied zu `/coach`: Kein formuliertes Problem nötig — AC führt strukturiertes
  5–6-Fragen-Interview durch (Symptom → Frequenz → Auswirkung → Umgehungen → Ziel)
- Neues Artefakt `IMPD-NNNNNN` mit eigenem Template (`toolchain/templates/impediment.md`)
- Betroffen: `.claude/commands/impediment.md` (neu), `toolchain/agents/agile-coach-agent.md`,
  `toolchain/templates/impediment.md` (neu), `CLAUDE.md`, `toolchain/templates/INDEX.md`,
  `toolchain/agents/_base-agent.md`

**Summary-Dateien für NotebookLM-Kompatibilität**
- `.claude/commands/commands_summary.md` — Alle Commands konsolidiert in einer Datei
- `toolchain/agents/agents_summary.md` — Alle Agenten konsolidiert in einer Datei
- `toolchain/templates/templates_summary.md` — Alle Templates konsolidiert in einer Datei
- `RELEASENOTES.md` — Diese Datei (Tool-Chain-Änderungsprotokoll)
- Pflege-Regeln in `CLAUDE.md` verankert (Abschnitt "Pflege-Pflichten")

### Geändert

**Nächste-Phase-Pflicht in allen Agenten**
- Neue Sektion `Abschluss-Pflicht: Nächste Phase explizit benennen` in `_base-agent.md`
- Jeder Agent muss vor Abschluss den Projektstatus prüfen und den nächsten Slash Command
  (inkl. Projektname) als letzten Block der Chat-Antwort ausgeben — Format: `▶ **Nächste Phase:** /[command] [projektname]`
- Konkrete ABSCHLUSS-PFLICHT-Blöcke in allen Agenten-System-Prompts ergänzt:
  PM, BA, AR, UX, FE, BE, QA (beide Phasen), RV, MW, AC
- `toolchain/protocols/handoff-protocol.md`: Feld `Nächster Befehl` mit Pflicht-Hinweis versehen

---

## v1.0 — 2026-06-18

### Initiale Tool Chain

**Basis-Architektur (drei Schichten)**
- Schicht 1 — Meta: `toolchain/agents/`, `toolchain/templates/`, `toolchain/protocols/`, `toolchain/hooks/`
- Schicht 2 — Orchestrierung: `.claude/commands/`, `toolchain/workflows/`
- Schicht 3 — Projekt: `projects/`, `projects/REGISTRY.md`

**Agenten (11 Rollen)**
- ORCH (Orchestrator), PM (Product Manager), BA (Business Analyst), AR (Software Architect),
  UX (UX Designer), FE (Frontend Developer), BE (Backend Developer), QA (QA Engineer),
  RV (Code Reviewer), MW (Manual Writer), AC (Agile Coach)
- Basisregeln in `toolchain/agents/_base-agent.md` — alle Agenten erben diese

**Commands (17 Slash Commands)**
- Orchestrierung: `/status`, `/sprint`, `/hotfix`, `/spike`
- Phasen (Full Sprint): `/kickoff`, `/ba`, `/architect`, `/ux`, `/refine`, `/implement`,
  `/test-plan`, `/test-run`, `/review`, `/manual`
- Post-Sprint (AC): `/retro`, `/health-check`, `/coach`

**Templates (13 Artefakt-Templates)**
- `SB`, `REQ`, `US`, `ADR`, `UX`, `SP`, `TP`, `RV`, `DEBT`, `DECISIONS`, `RETRO`, `PC`, Branching-ADR

**Protokolle**
- Handoff-Protokoll: Verbindlicher Übergabe-Block am Ende jedes Artefakts
- Artifact-Lifecycle: DRAFT → REVIEW → APPROVED → ACTIVE → SUPERSEDED | ARCHIVED
- Gate-Protokoll: BLOCKER / MAJOR / MINOR — Eskalationsregeln

**Globale Konventionen**
- Code-Kommentierungsstandard (Datei-Header, DocStrings, TODO-Format)
- Artefakt-Benennung mit dreistelligen sequenziellen Nummern
- Ordner-Indizierung (INDEX.md in jedem Verzeichnis)
- Technologie-Agnostizität (kein Template, kein Agent setzt Technologie voraus)
