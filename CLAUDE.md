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
| ORCH | Orchestrator | `toolchain/agents/orchestrator.md` | Projektzustand, Gates, Workflow-Steuerung, Cross-Artefakt-Konsistenz (`/analyze`) |
| PM | Product Manager | `toolchain/agents/pm-agent.md` | Stakeholder-Interviews, Priorisierung, Vision, Projekt-Constitution |
| BA | Business Analyst | `toolchain/agents/ba-agent.md` | Requirements, User Stories, Akzeptanzkriterien |
| AR | Software Architect | `toolchain/agents/architect-agent.md` | Systemdesign, ADRs, Tech-Stack-Entscheidung, Brownfield-Gap-Analyse (`/converge`) |
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
| `/converge [projekt] [pfad]` | Bestandscode gegen Spezifikation prüfen (Brownfield-Übernahme) |

### Phasen-Commands (manuell oder durch `/sprint` aufgerufen)

| Command | Phase | Agent | Primäres Artefakt |
|---------|-------|-------|-------------------|
| `/kickoff` | Discovery | PM | `SB-NNNNNN`, `CON-000001` |
| `/ba` | Requirements | BA | `REQ-NNNNNN`, `US-NNNNNN` |
| `/architect` | Architektur | AR | `ADR-NNNNNN`, `STRUCTURE.md` |
| `/ux` | UX Design | UX | `UX-NNNNNN` |
| `/refine` | Refinement | BA+FE+BE | `SP-NNNNNN` |
| `/analyze` | Optionale, vorgezogene Cross-Artefakt-Konsistenzprüfung | ORCH | Gate-Bericht (kein Artefakt) |
| `/implement` | Implementierung | FE, BE | Code + API-Kontrakt |
| `/test-plan` | Testplan | QA | `TP-NNNNNN` |
| `/test-run` | Testausführung | QA | `TR-NNNNNN` |
| `/review` | Code Review | RV | `RV-NNNNNN` |
| `/manual` | Dokumentation | MW | `DOC-NNNNNN`, `RN-NNNNNN` |

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
| Full Sprint | `/sprint` | Normaler Entwicklungssprint | 10 Nutzerphasen; Gate 5.5 als `/implement`-Preflight |
| Hotfix | `/hotfix` | Kritischer Produktionsfehler | 4 Phasen |
| Spike | `/spike` | Tech-Evaluierung ohne Impl. | 3 Phasen |
| Converge | `/converge` | Bestandscode gegen Spec prüfen (Brownfield) | 3 Phasen |

Details: `toolchain/workflows/`

---

## Globale Konventionen

### Code-Kommentierung (alle Sprachen, alle Code-Agenten)

```
DATEI-HEADER:
  Beschreibung: [Modul-Zweck]
  Artefakte:    [US-NNNNNN; ADR-NNNNNN]
  Agent:        [FE|BE] — YYYY-MM-DD

FUNKTION/METHODE:
  JSDoc/DocString mit @param, @returns, @throws
  Seiteneffekte benennen: "Schreibt in DB", "Dispatcht Event"

KOMPLEXE LOGIK:
  Kommentar ÜBER dem Block: Warum, nicht Was
  ADR-Verweis: // → ADR-000005

TODO-FORMAT:
  // TODO(KÜRZEL): Beschreibung — YYYY-MM-DD
  Erlaubte Kürzel: PM BA AR UX FE BE QA RV MW AC
```

### Artefakt-Benennung

| Typ | Präfix | Beispiel |
|-----|--------|---------|
| Stakeholder Brief | `SB-NNNNNN` | `SB-000001-projektname.md` |
| Projekt-Constitution | `CON-NNNNNN` | `CON-000001-projektname.md` (einmalig pro Projekt) |
| Requirements | `REQ-NNNNNN` | `REQ-000001-auth.md` |
| Architecture Decision Record | `ADR-NNNNNN` | `ADR-000001-tech-stack.md` |
| Gap-Analyse (Converge) | `GAP-NNNNNN` | `GAP-000001-legacy-scan.md` |
| User Story | `US-NNNNNN` | `US-000042-login.md` |
| UX-Spec | `UX-NNNNNN` | `UX-000001-onboarding.md` |
| Sprint Backlog | `SP-NNNNNN` | `SP-000001-sprint1.md` |
| Testplan | `TP-NNNNNN` | `TP-000001-smoke.md` |
| Testergebnis-Bericht | `TR-NNNNNN` | `TR-000001-sprint-1.md` |
| Fehlerbericht | `BUG-NNNNNN` | `BUG-000001-login-crash.md` |
| Review-Bericht | `RV-NNNNNN` | `RV-000001-sprint-1.md` |
| Technische Schuld | `DEBT-NNNNNN` | `DEBT-000001-n+1-queries.md` |
| Spike Report | `SRP-NNNNNN` | `SRP-000001-db-eval.md` |
| Feature-Guide | `DOC-NNNNNN` | `DOC-000001-login.md` |
| Release Notes | `RN-NNNNNN` | `RN-000001-sprint-1.md` |
| Getting Started | `GS-NNNNNN` | `GS-000001.md` |
| FAQ | `FAQ-NNNNNN` | `FAQ-000001-<thema>.md` |
| Entscheidungsprotokoll | `DECISIONS.md` | `DECISIONS.md` (pro Projekt) |
| Sprint-Retrospektive | `RETRO-NNNNNN` | `RETRO-000001-sprint-1.md` |
| Impediment | `IMPD-NNNNNN` | `IMPD-000001-handoff-luecke.md` |
| Process Change Proposal | `PC-NNNNNN` | `PC-000001-gate-reform.md` |

NNNNNN = sechsstellig, sequenziell pro Projekt.

### Projektordner-Struktur

Alle projektspezifischen Artefakte liegen in `projects/<name>/` — **niemals im Projekt-Root**.
Jeder Artefakttyp hat einen definierten Unterordner:

```
projects/<name>/
  discovery/        SB-NNNNNN, CON-000001, DECISIONS.md
  requirements/     REQ-NNNNNN, US-NNNNNN
  architecture/     ADR-NNNNNN, STRUCTURE.md, GAP-NNNNNN
  ux/               UX-NNNNNN
  sprints/          SP-NNNNNN
  testing/          TP-NNNNNN, TR-NNNNNN, BUG-NNNNNN, playwright-report/
  reviews/          RV-NNNNNN
  docs/             DOC-NNNNNN, RN-NNNNNN, GS-NNNNNN
  retros/           RETRO-NNNNNN, IMPD-NNNNNN, PC-NNNNNN, DEBT-NNNNNN, SRP-NNNNNN
  INDEX.md
  .phase
  .toolchain.yml
```

Jeder Agent erstellt den Unterordner falls nicht vorhanden und schreibt **ausschließlich**
in den zugehörigen Unterordner. Die `INDEX.md` im Projektroot verweist auf alle Unterordner.

### Artefakt-Lebenszyklus

```
DRAFT → REVIEW → APPROVED → ACTIVE → SUPERSEDED | ARCHIVED

- Artefakte werden NIE von der KI ohne direkten Userbefehl gelöscht
- Ersetzt: [SUPERSEDED by ADR-000007]
- Versionierung: v1.0, v1.1, v2.0 (Minor = Inhalt, Major = Struktur)
```

Details: `toolchain/protocols/artifact-lifecycle.md`

Der explizite Start des logisch nächsten Phasen-Commands gilt nach erfolgreichem Gate als
Freigabe der eindeutigen `REVIEW`-Artefakte aus der unmittelbar vorherigen Phase. Offene
`BLOCKER` oder `MAJOR` verhindern Freigabe und Phasenwechsel. Gate 5.5 wird im
Standardworkflow durch `/implement` ausgeführt; `/analyze` bleibt optional.

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
werden projektspezifisch in `ADR-000001-tech-stack.md` festgehalten und sind ab APPROVED
für alle nachfolgenden Agenten verbindlich.

### Thinking-Transparenz (Claude-Code-Session-Einstellungen)

Jedes Projekt (`projects/_template/.claude/settings.json`, von dort in jedes neue Projekt
übernommen) aktiviert standardmäßig:

```json
{
  "alwaysThinkingEnabled": true,
  "showThinkingSummaries": true,
  "verbose": true
}
```

`alwaysThinkingEnabled` sorgt dafür, dass Claude Code in jeder Session Extended Thinking
nutzt — ohne aktives Thinking gibt es keine Zusammenfassung, die sich anzeigen ließe.
`showThinkingSummaries`/`verbose` machen diese Zusammenfassung sichtbar statt sie zu
unterdrücken.

**Ausklappen/Lesen in der laufenden Session:** `Ctrl+O` öffnet den Transcript Viewer (zeigt
Tool-Aufrufe inkl. Zeitstempel und genutztem Modell zu jeder Assistant-Nachricht); darin
schaltet `Ctrl+E` auf „vollständigen Inhalt anzeigen" um, was die komplette Thinking-
Zusammenfassung statt nur eines Kurzauszugs offenlegt. `Alt+T` (Windows/Linux) bzw.
`Option+T` (macOS) schaltet Extended Thinking für die laufende Session komplett an/aus,
unabhängig von der Projekt-Voreinstellung.

Gilt projektweit, da jedes `projects/<name>/` ein eigenes Git-Repository ist — `.claude/
settings.json` muss daher pro Projekt (nicht nur im Toolchain-Root) committet werden, um für
alle Mitwirkenden zu greifen. Scope-Präzedenz von Claude Code: Managed (`managed-settings.
json`) > Local (`settings.local.json`, gitignored, pro Maschine) > Project (`settings.json`,
committet, gilt für alle) > User (`~/.claude/settings.json`, nur lokal).

### Externe Recherche (MCP `fetch`)

Für Recherche-lastige Phasen steht der MCP-Server `fetch` zur Verfügung (registriert in
`.mcp.json` im Repo-Root, Referenzimplementierung aus
[modelcontextprotocol/servers](https://github.com/modelcontextprotocol/servers/tree/main/src/fetch)).
Er ruft eine URL ab und liefert den Inhalt als Markdown zurück (Parameter `url`, optional
`max_length`, `start_index` für Chunking, `raw` für unformatierten Inhalt).

Genutzt von:
- **PM** (`/kickoff`) — Marktanalyse, Wettbewerber, Trends
- **BA** (`/ba`) — fachliche Referenzen, externe Standards
- **AR** (`/architect`, `/spike`) — Tech-Evaluierung, API-/Library-Dokumentation

Grenzen: liefert nur öffentlich erreichbare Inhalte, respektiert `robots.txt` (Default),
kein Ersatz für authentifizierten Zugriff auf interne Systeme. Rechercheergebnisse fließen
als Quellenangabe (URL) in das jeweilige Artefakt ein — kein Copy-Paste ohne Einordnung.

### Codebase-Intelligenz (MCP `codebase-memory`)

Für code-nahe Phasen steht der MCP-Server `codebase-memory` zur Verfügung (registriert in
`.mcp.json` im Repo-Root, Referenzimplementierung
[DeusData/codebase-memory-mcp](https://github.com/DeusData/codebase-memory-mcp)). Er baut
einen strukturellen Code-Graphen (Tree-sitter-Parsing + SQLite-Speicher, pro Projekt
indiziert) auf und beantwortet Struktur-, Aufruf- und Änderungsfragen per Tool-Call statt
per Datei-für-Datei-Grep — bei größeren Codebases ein erheblicher Token-Vorteil gegenüber
klassischem Grep/Glob.

Werkzeuge (Auszug): `index_repository`, `search_graph`, `trace_path`, `query_graph`,
`detect_changes`, `get_architecture`, `search_code`, `semantic_query`, `manage_adr`.

Genutzt von:
- **AR** (`/architect`, `/converge`) — Ist-Architektur erfassen (`get_architecture`),
  Gap-Analyse gegen Spezifikation (`detect_changes`, `search_graph`, `trace_path`)
- **BE/FE** (`/implement`) — Aufrufketten und betroffene Stellen in bestehendem Code
  nachvollziehen (`trace_path`, `search_code`, `query_graph`) statt breitem Grep
- **RV** (`/review`) — Change-Impact eines Diffs vor der Merge-Entscheidung einschätzen
  (`detect_changes`)
- **QA** (`/test-plan`, `/test-run`) — toten Code und ungetestete Pfade identifizieren

Grenzen: liefert strukturelle/graphbasierte Fakten über den Code — kein Ersatz für
fachliches Verständnis, Code Review oder Testausführung. Vor dem ersten Einsatz in einem
Projekt einmalig `index_repository` gegen den Projektpfad ausführen; ein Background-Watcher
hält den Index danach automatisch aktuell.

**Bekanntes Windows-Problem (Pin):** Die offiziell über npm ausgelieferte Windows-Binary
von v0.9.0 hat einen Bug in `--ui=true` (Graph-UI startet nicht zuverlässig). `.mcp.json`
zeigt deshalb absichtlich nicht auf den npm-Befehl `codebase-memory-mcp`, sondern auf eine
fest gepinnte, funktionierende Binary unter
`C:\Users\frede\.codebase-memory-mcp\bin\codebase-memory-mcp-ui-v0.9.0-pinned.exe` (außerhalb
von `node_modules`, überlebt daher jedes `npm install/update -g`). Sobald ein Release den Fix
enthält, `.mcp.json` wieder auf `"command": "codebase-memory-mcp"` zurückstellen und den Pin
entfernen.

**3D-Graph-Visualisierung (optional):** `codebase-memory-mcp` bringt eine browserbasierte
3D-Visualisierung des Code-Graphen mit (Multi-Galaxy-Layout über mehrere indizierte
Projekte hinweg). Sie ist über `--ui=true --port=9749` in `.mcp.json` aktiviert und läuft
als HTTP-Server unter `http://localhost:9749`, sobald eine Claude-Code-Session den
`codebase-memory`-Server startet — verwaltet vom gemeinsamen Coordination-Daemon, sodass
mehrere parallele Sessions keine doppelten HTTP-Server öffnen. Rein explorativ (Menschen im
Browser), kein Tool-Call und kein Ersatz für die MCP-Werkzeuge oben; nützlich, um sich vor
`/architect`- oder `/converge`-Sessions einen visuellen Überblick über eine Bestandscodebase
zu verschaffen.

---

## Additive Codex-Kompatibilität

Claude Code und diese Datei bleiben die kanonische Ausführungsumgebung und fachliche Quelle
der Tool Chain. Die Codex-Integration ist ausschließlich additiv:

| Pfad | Zweck |
|------|-------|
| `AGENTS.md` | Kurzer Codex-Adapter mit explizitem Vorrang dieser `CLAUDE.md` |
| `.agents/skills/coding-toolchain/` | Nativer Codex-Router für die bestehenden Commands |
| `.codex/config.toml` | Registrierung der Codex-Rollenadapter |
| `.codex/agents/` | Codex-Agenten, die auf die kanonischen Definitionen unter `toolchain/agents/` verweisen |
| `projects/_template/AGENTS.md` | Codex-Anweisungen für eigenständige Projekt-Repositories |
| `projects/_template/.agents/skills/coding-toolchain/` | Projektlokaler Skill, damit eigenständige Codex-Sitzungen alle Toolchain-Commands erkennen |

Codex unterstützt keine repository-definierten nackten Slash-Commands. In einer
Codex-Sitzung wird deshalb die portable Skill-Syntax
`$coding-toolchain /<command>` verwendet, beispielsweise `$coding-toolchain /ba`.
Natürliche Anfragen wie „Führe /ba aus“ können denselben Skill implizit aktivieren.

Codex-spezifische Dateien dürfen Commands, Rollen, Templates, Protokolle oder Prioritäten
von Claude Code nicht überschreiben. Konsistenzprüfung:

```powershell
pwsh -NoProfile -File toolchain/scripts/validate-codex-compat.ps1
```

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

Jedes Projekt unter `projects/<projektname>/` ist ein **eigenes Git-Repository** — nicht Teil
des Toolchain-Repositorys. Das Root-`.gitignore` schließt `projects/*` bewusst aus (Ausnahmen:
`REGISTRY.md` und `_template/`), damit kein Projektinhalt versehentlich ins Toolchain-Repo
gerät.

```bash
# 1. Projektordner aus der Vorlage anlegen (manuell oder durch /kickoff automatisch)
cp -r projects/_template projects/<projektname>
cd projects/<projektname>

# 2. Eigenes Git-Repository initialisieren
git init

# 3. Git Hooks installieren (einmalig pro Projekt-Repository)
# Linux/Mac/WSL/Git-Bash:
bash ../../toolchain/hooks/setup-hooks.sh
# Windows/PowerShell (nativ, kein Git-Bash/WSL nötig):
pwsh ../../toolchain/hooks/setup-hooks.ps1

# 4. Tool Chain Config befüllen
# .toolchain.yml wurde aus der Vorlage kopiert — project.name, description, created befüllen

# 5. Starten
cd ../..
# In Claude Code: /kickoff <projektname>
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
| MCP-Server-Konfiguration (externe Recherche + Codebase-Intelligenz) | `.mcp.json` |
| Codebase-Intelligenz (Referenzimplementierung) | [DeusData/codebase-memory-mcp](https://github.com/DeusData/codebase-memory-mcp) |
| CI-Build-Empfehlung Container (Referenzimplementierung) | [docker/github-builder](https://github.com/docker/github-builder) |
| Architektur-Übersicht | `architecture.html` |
| API &amp; Protokoll-Dokumentation | `api_documentation.html` |
| Entscheidungsprotokoll-Template | `toolchain/templates/decisions.md` |
| Tool-Chain-Änderungsprotokoll | `RELEASENOTES.md` |
| Produktbeschreibung (NotebookLM-Quelldokument) | `AUDIOSCRIPT.md` |
| Commands-Übersicht (konsolidiert) | `.claude/commands/commands_summary.md` |
| Agenten-Übersicht (konsolidiert) | `toolchain/agents/agents_summary.md` |
| Templates-Übersicht (konsolidiert) | `toolchain/templates/templates_summary.md` |
| Additive Codex-Anweisungen | `AGENTS.md` |
| Codex-Kompatibilitätsprüfung | `toolchain/scripts/validate-codex-compat.ps1` |
