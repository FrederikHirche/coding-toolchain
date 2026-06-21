# AI Development Tool Chain

Technologieneutrale, agentische Tool Chain für die gesamte Softwareentwicklung —
von der Stakeholder-Idee bis zum produktiven Release.

---

## Architektur: Drei Schichten

```
┌─────────────────────────────────────────────────────────────────┐
│  SCHICHT 1 — META (Tool Chain selbst)                           │
│  toolchain/agents/       Rollen + System-Prompts                │
│  toolchain/templates/    Artefakt-Templates                     │
│  toolchain/protocols/    Handoff, Gate, Lifecycle               │
│  toolchain/hooks/        Git Automation                         │
│  Definiert: WIE entwickelt wird                                 │
├─────────────────────────────────────────────────────────────────┤
│  SCHICHT 2 — ORCHESTRIERUNG                                     │
│  .claude/commands/       Slash Commands (Phasen-Aktivierung)    │
│  toolchain/workflows/    Sprint-Sequenzen + Gate-Logik          │
│  Steuert: WANN welcher Agent aktiv wird                         │
├─────────────────────────────────────────────────────────────────┤
│  SCHICHT 3 — PROJEKT                                            │
│  projects/<name>/        Projektspezifische Artefakte           │
│  projects/REGISTRY.md    Zentrale Projekt-Übersicht             │
│  Enthält: WAS in einem konkreten Projekt entsteht               │
└─────────────────────────────────────────────────────────────────┘
```

---

## Agenten-Rollen

| Kürzel | Rolle | Datei | Kernverantwortung |
|--------|-------|-------|-------------------|
| ORCH | Orchestrator | `toolchain/agents/orchestrator.md` | Projektzustand, Gates, Workflow-Steuerung |
| PM | Product Manager | `toolchain/agents/pm-agent.md` | Stakeholder-Interviews, Priorisierung, Vision |
| BA | Business Analyst | `toolchain/agents/ba-agent.md` | Requirements, User Stories, Akzeptanzkriterien |
| AR | Software Architect | `toolchain/agents/architect-agent.md` | Systemdesign, ADRs, Tech-Stack-Entscheidung |
| UX | UX Designer | `toolchain/agents/ux-agent.md` | User Journeys, Interaction Design, UX-Specs |
| FE | Frontend Developer | `toolchain/agents/frontend-agent.md` | UI-Implementierung, Komponenten, Accessibility |
| BE | Backend Developer | `toolchain/agents/backend-agent.md` | APIs, Business Logic, Datenschicht |
| QA | QA Engineer | `toolchain/agents/qa-agent.md` | Testplanung, automatisierte & manuelle Tests |
| RV | Code Reviewer | `toolchain/agents/reviewer-agent.md` | Code Review, Qualitäts-Gates, Merge-Entscheidung |
| MW | Manual Writer | `toolchain/agents/manual-writer-agent.md` | Nutzerorientierte Dokumentation, Feature-Guides, Release Notes |
| AC | Agile Coach | `toolchain/agents/agile-coach-agent.md` | Prozessreflexion, Retrospektiven, Tool-Chain-Verbesserung |

Alle Agenten erben die Basisregeln aus `toolchain/agents/_base-agent.md`.

---

## Slash Commands

### Orchestrierung

| Command | Beschreibung |
|---------|-------------|
| `/status [projekt]` | Projektzustand anzeigen — welche Phase, was fehlt, was als nächstes |
| `/sprint [projekt] [nr]` | Vollständigen Sprint orchestrieren (alle Phasen sequenziell) |
| `/hotfix [projekt] [bug]` | Verkürzter Notfall-Fix-Workflow |
| `/spike [projekt] [frage]` | Technische Erkundung ohne Implementierungsverpflichtung |

### Phasen-Commands (manuell oder durch `/sprint` aufgerufen)

| Command | Phase | Agent | Primäres Artefakt |
|---------|-------|-------|-------------------|
| `/kickoff` | Discovery | PM | `SB-NNN` |
| `/ba` | Requirements | BA | `REQ-NNN`, `US-NNN` |
| `/architect` | Architektur | AR | `ADR-NNN`, `STRUCTURE.md` |
| `/ux` | UX Design | UX | `UX-NNN` |
| `/refine` | Refinement | BA+FE+BE | `SP-NNN` |
| `/implement` | Implementierung | FE, BE | Code + API-Kontrakt |
| `/test-plan` | Testplan | QA | `TP-NNN` |
| `/test-run` | Testausführung | QA | `TR-NNN` |
| `/review` | Code Review | RV | `RV-NNN` |
| `/manual` | Dokumentation | MW | `DOC-NNN`, `RN-NNN` |

### Post-Sprint Commands (optional, durch AC)

| Command | Beschreibung |
|---------|-------------|
| `/retro [projekt] [nr]` | Sprint-Retrospektive — Keep/Stop/Start, Prozessanalyse |
| `/health-check [projekt]` | Übergreifende Analyse nach 3+ Sprints |
| `/coach [projekt]` | Ad-hoc Prozessberatung wenn Problem bereits bekannt |
| `/impediment [projekt]` | Interview-geführte Impediment-Erkennung bei unbenannter Friction |

---

## Workflows

| Workflow | Command | Szenario | Phasen |
|----------|---------|---------|--------|
| Full Sprint | `/sprint` | Normaler Entwicklungssprint | 9 Phasen |
| Hotfix | `/hotfix` | Kritischer Produktionsfehler | 4 Phasen |
| Spike | `/spike` | Tech-Evaluierung ohne Impl. | 3 Phasen |

Details: `toolchain/workflows/`

---

## Globale Konventionen

### Code-Kommentierung (alle Sprachen, alle Code-Agenten)

```
DATEI-HEADER:
  Beschreibung: [Modul-Zweck]
  Artefakte:    [US-NNN; ADR-NNN]
  Agent:        [FE|BE] — YYYY-MM-DD

FUNKTION/METHODE:
  JSDoc/DocString mit @param, @returns, @throws
  Seiteneffekte benennen: "Schreibt in DB", "Dispatcht Event"

KOMPLEXE LOGIK:
  Kommentar ÜBER dem Block: Warum, nicht Was
  ADR-Verweis: // → ADR-005

TODO-FORMAT:
  // TODO(KÜRZEL): Beschreibung — YYYY-MM-DD
  Erlaubte Kürzel: PM BA AR UX FE BE QA RV MW AC
```

### Artefakt-Benennung

| Typ | Präfix | Beispiel |
|-----|--------|---------|
| Stakeholder Brief | `SB-NNN` | `SB-001-projektname.md` |
| Requirements | `REQ-NNN` | `REQ-001-auth.md` |
| Architecture Decision Record | `ADR-NNN` | `ADR-001-tech-stack.md` |
| User Story | `US-NNN` | `US-042-login.md` |
| UX-Spec | `UX-NNN` | `UX-001-onboarding.md` |
| Sprint Backlog | `SP-NNN` | `SP-001-sprint1.md` |
| Testplan | `TP-NNN` | `TP-001-smoke.md` |
| Review-Bericht | `RV-NNN` | `RV-001-sprint-1.md` |
| Technische Schuld | `DEBT-NNN` | `DEBT-001-n+1-queries.md` |
| Spike Report | `SRP-NNN` | `SRP-001-db-eval.md` |
| Feature-Guide | `DOC-NNN` | `DOC-001-login.md` |
| Release Notes | `RN-NNN` | `RN-001-sprint-1.md` |
| Getting Started | `GS-NNN` | `GS-001.md` |
| Entscheidungsprotokoll | `DECISIONS.md` | `DECISIONS.md` (pro Projekt) |
| Sprint-Retrospektive | `RETRO-NNN` | `RETRO-001-sprint-1.md` |
| Impediment | `IMPD-NNN` | `IMPD-001-handoff-luecke.md` |
| Process Change Proposal | `PC-NNN` | `PC-001-gate-reform.md` |

NNN = dreistellig, sequenziell pro Projekt.

### Projektordner-Struktur

Alle projektspezifischen Artefakte liegen in `projects/<name>/` — **niemals im Projekt-Root**.
Jeder Artefakttyp hat einen definierten Unterordner:

```
projects/<name>/
  discovery/        SB-NNN, DECISIONS.md
  requirements/     REQ-NNN, US-NNN
  architecture/     ADR-NNN, STRUCTURE.md
  ux/               UX-NNN
  sprints/          SP-NNN
  testing/          TP-NNN, TR-NNN, BUG-NNN, playwright-report/
  reviews/          RV-NNN
  docs/             DOC-NNN, RN-NNN, GS-NNN
  retros/           RETRO-NNN, IMPD-NNN, PC-NNN, DEBT-NNN, SRP-NNN
  INDEX.md
  .phase
  .toolchain.yml
```

Jeder Agent erstellt den Unterordner falls nicht vorhanden und schreibt **ausschließlich**
in den zugehörigen Unterordner. Die `INDEX.md` im Projektroot verweist auf alle Unterordner.

### Artefakt-Lebenszyklus

```
DRAFT → REVIEW → APPROVED → ACTIVE → SUPERSEDED | ARCHIVED

- Artefakte werden NIE gelöscht
- Ersetzt: [SUPERSEDED by ADR-007]
- Versionierung: v1.0, v1.1, v2.0 (Minor = Inhalt, Major = Struktur)
```

Details: `toolchain/protocols/artifact-lifecycle.md`

### Ordner-Indizierung

Jedes Verzeichnis enthält eine `INDEX.md`:
- Zweck des Ordners
- Tabellarisches Inhaltsverzeichnis: Dateiname | ID | Status | Kurzbeschreibung
- Letztes Update-Datum

Jeder Agent, der Artefakte erzeugt, aktualisiert die `INDEX.md` des Zielordners.

### Übergabe-Standard

Jedes Artefakt endet mit einem Übergabe-Block nach `toolchain/protocols/handoff-protocol.md`.
Kein Agent schließt eine Session ohne diesen Block ab.

### Technologie-Agnostizität

Kein Template und kein Agent setzt eine Technologie voraus. Technologieentscheidungen
werden projektspezifisch in `ADR-001-tech-stack.md` festgehalten und sind ab APPROVED
für alle nachfolgenden Agenten verbindlich.

---

## Pflege-Pflichten (Tool Chain)

Diese Regeln gelten immer dann, wenn Claude Änderungen an der Tool Chain selbst vornimmt
(Commands, Agenten, Templates, Protokolle) — nicht bei projektspezifischen Artefakten.

### Summary-Dateien aktuell halten

Drei konsolidierte Dateien fassen die Tool Chain für NotebookLM-Analyse zusammen.
**Bei jeder Änderung an Command-, Agenten- oder Template-Dateien muss die zugehörige
Summary-Datei mitaktualisiert werden.**

| Geänderte Datei liegt in | → Summary aktualisieren |
|--------------------------|------------------------|
| `.claude/commands/` | `.claude/commands/commands_summary.md` |
| `toolchain/agents/` | `toolchain/agents/agents_summary.md` |
| `toolchain/templates/` | `toolchain/templates/templates_summary.md` |

### RELEASENOTES.md pflegen

`RELEASENOTES.md` im Projekt-Root dokumentiert alle strukturellen Änderungen der Tool Chain.

**Bei jeder Änderung an Commands, Agenten, Templates oder Protokollen:**
1. Neue Version anlegen (Format: `v1.x — YYYY-MM-DD`) oder bestehende Tagesversion ergänzen
2. Unter `### Neu`, `### Geändert` oder `### Behoben` eintragen
3. Betroffene Dateien explizit nennen
4. Auswirkung in einem Satz beschreiben

**Versionierung:** Minor-Version (1.x) für jede inhaltliche Änderung. Major-Version (x.0)
nur bei grundlegender Umstrukturierung der Tool Chain.

---

## Neues Projekt starten

```bash
# 1. Projektordner anlegen (manuell oder durch /kickoff automatisch)
mkdir -p projects/<projektname>

# 2. Git Hooks installieren (einmalig pro Repository)
bash toolchain/hooks/setup-hooks.sh

# 3. Tool Chain Config anlegen
cp .toolchain.yml projects/<projektname>/.toolchain.yml
# Danach: project.name befüllen

# 4. Starten
# In Claude Code: /kickoff
# Oder: /sprint <projektname> 1    ← orchestriert alles automatisch
```

---

## Referenzen

| Dokument | Pfad |
|----------|------|
| Prozessfluss (ausführlich) | `toolchain/PROCESS.md` |
| Agenten-Verzeichnis | `toolchain/agents/INDEX.md` |
| Basis-Agent-Regeln | `toolchain/agents/_base-agent.md` |
| Orchestrator | `toolchain/agents/orchestrator.md` |
| Workflows | `toolchain/workflows/INDEX.md` |
| Protokolle | `toolchain/protocols/INDEX.md` |
| Templates | `toolchain/templates/INDEX.md` |
| Hooks | `toolchain/hooks/INDEX.md` |
| Projekt-Registry | `projects/REGISTRY.md` |
| Architektur-Übersicht | `architecture.html` |
| API &amp; Protokoll-Dokumentation | `api_documentation.html` |
| Entscheidungsprotokoll-Template | `toolchain/templates/decisions.md` |
| Tool-Chain-Änderungsprotokoll | `RELEASENOTES.md` |
| Commands-Übersicht (konsolidiert) | `.claude/commands/commands_summary.md` |
| Agenten-Übersicht (konsolidiert) | `toolchain/agents/agents_summary.md` |
| Templates-Übersicht (konsolidiert) | `toolchain/templates/templates_summary.md` |
