# Tool Chain — Übersicht

Kernbestandteile der AI Development Tool Chain (Schicht 1: Meta-Schicht).

Letzte Aktualisierung: 2026-07-23

## Verzeichnisse

| Ordner | Beschreibung |
|--------|-------------|
| `agents/` | 11 aktive Rollen-Agenten plus Basis-Template |
| `workflows/` | Benannte Prozesssequenzen (Full Sprint, Hotfix, Spike) |
| `protocols/` | Formale Protokolle: Handoff, Gate, Artefakt-Lifecycle |
| `templates/` | Artefakt-Templates für alle Entwicklungsphasen |
| `hooks/` | Git Hooks + Installationsscript |
| `scripts/` | Toolchain-Validatoren und Pflegehilfen |

## Dokumente

| Datei | Beschreibung |
|-------|-------------|
| `PROCESS.md` | Detaillierter 10-Phasen-Prozess mit Gates und Rollback-Regeln |
| `INDEX.md` | Diese Datei |

## Architektur-Schichten (Übersicht)

```
Schicht 1: toolchain/          ← WIE (Regeln, Templates, Protokolle)
Schicht 2: .claude/commands/   ← WANN (kanonische Aktivierung, Sequenzierung)
Schicht 3: projects/           ← WAS (Projektspezifische Artefakte)
```

Die additive Codex-Schicht liegt in `AGENTS.md`, `.agents/skills/` und `.codex/`.
`CLAUDE.md` und `.claude/commands/` bleiben die kanonischen Quellen.

## Schnellreferenz

| Ziel | Datei |
|------|-------|
| Neues Projekt starten | CLAUDE.md → Abschnitt "Neues Projekt" |
| Agenten verstehen | `agents/INDEX.md` |
| Workflow auswählen | `workflows/INDEX.md` |
| Gate-Kriterien | `protocols/gate-protocol.md` |
| Übergabe-Format | `protocols/handoff-protocol.md` |
| Artefakt-Status | `protocols/artifact-lifecycle.md` |
