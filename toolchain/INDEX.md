# Tool Chain — Übersicht

Kernbestandteile der AI Development Tool Chain (Schicht 1: Meta-Schicht).

Letzte Aktualisierung: 2026-06-18

## Verzeichnisse

| Ordner | Beschreibung |
|--------|-------------|
| `agents/` | 9 Agenten-Definitionen (inkl. Orchestrator + Basis-Template) |
| `workflows/` | Benannte Prozesssequenzen (Full Sprint, Hotfix, Spike) |
| `protocols/` | Formale Protokolle: Handoff, Gate, Artefakt-Lifecycle |
| `templates/` | Artefakt-Templates für alle 8 Phasen |
| `hooks/` | Git Hooks + Installationsscript |

## Dokumente

| Datei | Beschreibung |
|-------|-------------|
| `PROCESS.md` | Detaillierter 8-Phasen-Prozess mit Gates und Rollback-Regeln |
| `INDEX.md` | Diese Datei |

## Architektur-Schichten (Übersicht)

```
Schicht 1: toolchain/          ← WIE (Regeln, Templates, Protokolle)
Schicht 2: .claude/commands/   ← WANN (Aktivierung, Sequenzierung)
Schicht 3: projects/           ← WAS (Projektspezifische Artefakte)
```

## Schnellreferenz

| Ziel | Datei |
|------|-------|
| Neues Projekt starten | CLAUDE.md → Abschnitt "Neues Projekt" |
| Agenten verstehen | `agents/INDEX.md` |
| Workflow auswählen | `workflows/INDEX.md` |
| Gate-Kriterien | `protocols/gate-protocol.md` |
| Übergabe-Format | `protocols/handoff-protocol.md` |
| Artefakt-Status | `protocols/artifact-lifecycle.md` |
