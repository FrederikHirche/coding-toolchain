# Toolchain-Skripte

Hilfsskripte zur deterministischen Prüfung und Pflege der Tool Chain.

Letzte Aktualisierung: 2026-08-03

## Inhalt

| Datei | Zweck |
|---|---|
| `validate-codex-compat.ps1` | Prüft die additive Codex-Konfiguration, Rollenadapter, projektlokale Skill-Erkennung und alle Command-Routen |
| `github-board-sync.ps1` / `github-board-sync.sh` | Synchronisiert US/BUG/DEBT/IMPD/EPIC-Artefakte (gesamter Backlog inkl. Estimate/Size/Priority/Iteration/Datum/Milestone/Issue-Body) mit einem optionalen GitHub Project (v2) Board — `-Mode push\|reconcile`, siehe `toolchain/protocols/github-board-sync.md` |
