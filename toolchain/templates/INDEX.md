# Templates-Verzeichnis

Artefakt-Templates für alle Phasen der Tool Chain.
Alle Templates sind technologieunabhängig und enthalten den Standard-Artefakt-Header.

Letzte Aktualisierung: 2026-06-18

## Inhalt

| Datei | Artefakt-Präfix | Erstellt von | Phase |
|-------|----------------|-------------|-------|
| `stakeholder-brief.md` | `SB-NNN` | PM | Discovery |
| `requirements.md` | `REQ-NNN` | BA | Requirements |
| `user-story.md` | `US-NNN` | BA | Requirements |
| `architecture-decision.md` | `ADR-NNN` | AR | Architecture |
| `ux-spec.md` | `UX-NNN` | UX | UX Design |
| `sprint-backlog.md` | `SP-NNN` | BA+FE+BE | Refinement |
| `test-plan.md` | `TP-NNN` | QA | Testing |
| `review-checklist.md` | `RV-NNN` | RV | Review |
| `tech-debt-registry.md` | `DEBT-REGISTRY` | RV | Review (einmalig pro Projekt) |
| `decisions.md` | `DECISIONS.md` | ORCH | Alle Phasen (fortlaufend) |
| `retrospective.md` | `RETRO-NNN` | AC | Post-Sprint (optional) |
| `process-change.md` | `PC-NNN` | AC | Post-Sprint (optional) |
| `branching-strategy.md` | `ADR-NNN` | AR | Architecture (einmalig pro Projekt) |

## Verwendung

```bash
# Neues Artefakt aus Template erzeugen:
cp toolchain/templates/user-story.md \
   projects/<projektname>/US-001-login.md
# Dann: Platzhalter ersetzen, Header ausfüllen
```

## Artefakt-Lebenszyklus

Alle Artefakte folgen dem Protokoll in `toolchain/protocols/artifact-lifecycle.md`.
