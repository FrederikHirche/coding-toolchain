# AI Development Tool Chain — Codex-Adapter

Diese Datei ergänzt die Claude-Code-Toolchain um Codex-Unterstützung. Sie ersetzt keine
Claude-Anweisung.

## Kanonische Quelle

`CLAUDE.md` hat fachlich und funktional immer Vorrang. Lies `CLAUDE.md` vollständig, bevor
du einen Toolchain-Command ausführst oder die Toolchain selbst änderst. Bei Widersprüchen
gilt folgende Reihenfolge:

1. Laufzeit-, Sicherheits- und Nutzeranweisungen
2. `CLAUDE.md`
3. referenzierte Dateien unter `.claude/commands/` und `toolchain/`
4. diese Codex-spezifische Übersetzung

Ändere `.claude/` nicht allein zur Codex-Kompatibilität. Neue Codex-Integration bleibt
additiv unter `.codex/`, `.agents/` oder in `AGENTS.md`.

## Commands in Codex

Behandle Eingaben wie `/kickoff`, `/status`, `/sprint`, `/ba`, `/architect`, `/ux`,
`/refine`, `/implement`, `/test-plan`, `/test-run`, `/review`, `/manual`, `/hotfix`,
`/spike`, `/converge`, `/harden`, `/retro`, `/health-check`, `/coach` und `/impediment`
als Toolchain-Commands.

Für jeden Command:

1. Lies `.claude/commands/<command>.md` vollständig.
2. Lies `toolchain/agents/_base-agent.md` vollständig.
3. Lies die vom Command referenzierte Rollen-Datei vollständig.
4. Lies den referenzierten Workflow, die benötigten Protokolle und relevanten
   Projektartefakte.
5. Führe den Command gemäß der Claude-Spezifikation aus.

Nutze den Repository-Skill `$coding-toolchain`, wenn die Aufgabe einen dieser Commands,
eine Toolchain-Rolle, einen Gate-Check oder ein Toolchain-Artefakt betrifft.

## Native Codex-Agenten

Die Rollen unter `.codex/agents/` sind Adapter. Ihre fachlichen Prompts bleiben die
entsprechenden Dateien unter `toolchain/agents/`.

- Bei einem ausdrücklich gewünschten `/sprint` darf der Orchestrator unabhängige Rollen
  als native Subagenten delegieren, sofern Gates und Handoffs dadurch nicht übersprungen
  werden.
- Bei `/implement all` dürfen Backend und Frontend nach freigegebenem API-Vertrag parallel
  arbeiten.
- Bei `/review` muss die Reviewer-Rolle unabhängig von den Implementierungsrollen bleiben.
- Außerhalb dieser Fälle keine Delegation allein wegen vorhandener Agenten erzwingen.

## Projekt- und Artefaktregeln

- Projekte liegen ausschließlich unter `projects/<name>/` und sind eigene Git-Repositories.
- Ermittle den Zustand aus `.phase`, `INDEX.md` und den vorhandenen Artefakten.
- Aktualisiere `.phase` nur bei tatsächlich bestandenem Gate.
- Folge `toolchain/protocols/gate-protocol.md`,
  `toolchain/protocols/handoff-protocol.md` und
  `toolchain/protocols/artifact-lifecycle.md`.
- Nutze die Templates unter `toolchain/templates/`.
- Aktualisiere nach jeder Artefakterstellung die zugehörige `INDEX.md`.
- Lösche keine Artefakte ohne direkten Nutzerauftrag.
- Triff keine Technologieannahme ohne freigegebenes `ADR-000001-tech-stack.md`.
- Führe vor Phasenabschluss die Definition-of-Done-Selbstprüfung der aktiven Rolle durch.
- Beende Rollenphasen mit dem konkreten nächsten Command einschließlich Projektname.

## Änderungen und Verifikation

Bei Änderungen an Commands, Agenten, Templates oder Protokollen gelten die Pflegepflichten
aus `CLAUDE.md`, einschließlich Summary-Dateien und `RELEASENOTES.md`.

Nach Änderungen an der Kompatibilitätsschicht ausführen:

```powershell
pwsh -NoProfile -File toolchain/scripts/validate-codex-compat.ps1
```

Bestehende Nutzeränderungen, insbesondere unversionierte Dateien, bleiben unangetastet.
