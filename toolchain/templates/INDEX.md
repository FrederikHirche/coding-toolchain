# Templates-Verzeichnis

Artefakt-Templates für alle Phasen der Tool Chain.
Alle Templates sind technologieunabhängig und enthalten den Standard-Artefakt-Header.

Letzte Aktualisierung: 2026-06-18

## Inhalt

| Datei | Artefakt-Präfix | Erstellt von | Phase |
|-------|----------------|-------------|-------|
| `stakeholder-brief.md` | `SB-NNNNNN` | PM | Discovery |
| `requirements.md` | `REQ-NNNNNN` | BA | Requirements |
| `user-story.md` | `US-NNNNNN` | BA | Requirements |
| `architecture-decision.md` | `ADR-NNNNNN` | AR | Architecture |
| `ux-spec.md` | `UX-NNNNNN` | UX | UX Design |
| `sprint-backlog.md` | `SP-NNNNNN` | BA+FE+BE | Refinement |
| `test-plan.md` | `TP-NNNNNN` | QA | Testing |
| `review-checklist.md` | `RV-NNNNNN` | RV | Review |
| `tech-debt-registry.md` | `DEBT-REGISTRY` | RV | Review (einmalig pro Projekt) |
| `decisions.md` | `DECISIONS.md` | ORCH | Alle Phasen (fortlaufend) |
| `retrospective.md` | `RETRO-NNNNNN` | AC | Post-Sprint (optional) |
| `impediment.md` | `IMPD-NNNNNN` | AC | Jederzeit via `/impediment` |
| `process-change.md` | `PC-NNNNNN` | AC | Post-Sprint (optional) |
| `branching-strategy.md` | `ADR-NNNNNN` | AR | Architecture (einmalig pro Projekt) |

## Verwendung

```bash
# Neues Artefakt aus Template erzeugen:
cp toolchain/templates/user-story.md \
   projects/<projektname>/US-000001-login.md
# Dann: Platzhalter ersetzen, Header ausfüllen
```

## Artefakt-Lebenszyklus

Alle Artefakte folgen dem Protokoll in `toolchain/protocols/artifact-lifecycle.md`.
