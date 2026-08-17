# Agenten-Verzeichnis

Dieses Verzeichnis enthält alle Agenten-Definitionen der Tool Chain.
Alle Agenten erben die Basisregeln aus `_base-agent.md`.

Letzte Aktualisierung: 2026-08-17

## Basis-Template

| Datei | Beschreibung |
|-------|-------------|
| `_base-agent.md` | Ererbte Regeln für alle Agenten (Aktivierung, Pflichten, Standards) |

## Agenten

| Datei | Kürzel | Rolle | Status | Phase |
|-------|--------|-------|--------|-------|
| `orchestrator.md` | ORCH | Orchestrator | ACTIVE | Alle (Meta) |
| `pm-agent.md` | PM | Product Manager | ACTIVE | 1 — Discovery |
| `ba-agent.md` | BA | Business Analyst | ACTIVE | 2 — Requirements |
| `architect-agent.md` | AR | Software Architect | ACTIVE | 3 — Architecture |
| `ux-agent.md` | UX | UX Designer | ACTIVE | 4 — UX |
| `frontend-agent.md` | FE | Frontend Developer | ACTIVE | 6 — Implementation |
| `backend-agent.md` | BE | Backend Developer | ACTIVE | 6 — Implementation |
| `qa-agent.md` | QA | QA Engineer | ACTIVE | 7 — Testing |
| `reviewer-agent.md` | RV | Code Reviewer | ACTIVE | 8 — Review |
| `manual-writer-agent.md` | MW | Manual Writer | ACTIVE | 9 — Documentation |
| `agile-coach-agent.md` | AC | Agile Coach | ACTIVE | Post-Sprint (optional) |
| `consolidator-agent.md` | CN | Consolidator | ACTIVE | Ad-hoc (kein Phasenwechsel) |

## Aktivierungsreihenfolge (Full Sprint)

```
ORCH → PM → BA → AR → UX → (BA+FE+BE Refine) → ORCH[Analyze] → (FE ∥ BE) → QA → RV → MW → ORCH
                                                                                             ↓
                                                                                        AC (optional, post-sprint)
```

FE und BE können parallel arbeiten sobald AR und UX abgeschlossen sind.
Der ORCH schließt jeden Sprint-Zyklus mit Gate-Auswertung und .phase-Update, und prüft vor
`/implement` zusätzlich die Cross-Artefakt-Konsistenz als Gate-5.5-Preflight; `/analyze`
bleibt als optionaler Diagnosebefehl verfügbar.
AC wird nicht automatisch aktiviert — nur durch `/retro`, `/health-check` oder `/coach`.
AR kann zusätzlich außerhalb der Sprint-Sequenz über `/converge` (Brownfield-Gap-Analyse)
oder `/decompose` (Kopplungs-/Grenzenanalyse für Service-Aufspaltung) aktiviert werden —
beides kein Phasenwechsel. CN kann zusätzlich außerhalb der Sprint-Sequenz über
`/harden` aktiviert werden (Konsolidierung/Hardening, kein Phasenwechsel).

## Jede Agenten-Datei enthält

- Rollenbeschreibung
- Kernverantwortlichkeiten
- Inputs / Outputs
- System-Prompt-Template (für Claude Code)
- Übergabeprotokoll → nächster Agent
- Definition of Done (Qualitätskriterien)
