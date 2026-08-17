---
id: WF-HARDEN
title: Konsolidierung / Hardening
version: 1.0
status: ACTIVE
---

# Workflow: Harden

Ad-hoc Härtungsrunde über die bestehende Codebase — entfernt toten Code, dedupliziert und
vereinfacht mit Beweispflicht und Test-Gate. Anders als `/converge` (reiner Report) und
`/review` (Diff-Scope des aktuellen Sprints) ändert dieser Workflow Code direkt, aber nur
innerhalb enger Sicherheitsleitplanken.

## Aktivierung

```
/harden [projektname] [pfad-optional]
```

## Wann Harden verwenden

- Vor einem Release, wenn sich technische Schulden angesammelt haben
- Nach mehreren Sprints, wenn tote Pfade/Duplikate vermutet werden
- Bei explizitem Wunsch nach einer Cleanup-Runde außerhalb des normalen Sprint-Rhythmus

## Harden ≠ Sprint-Phase

Harden ist **kein Sprint-Phase** und **kein Ersatz für `/review`** — es prüft nicht die
Akzeptanzkriterien eines Sprints, sondern härtet Bestandscode unabhängig vom Sprint-Zyklus.
Es ist auch **kein `/converge`** — anders als die reine Gap-Analyse ändert Harden Code
direkt, innerhalb der in `consolidator-agent.md` definierten Sicherheitsleitplanken.

## Phasen-Sequenz

```
SCAN
  [CN] — Git-Tree-Sauberkeit prüfen (BLOCKER-Vorbedingung), Codebase über
  codebase-memory nach toten Symbolen, Duplikaten und unnötiger Komplexität durchsuchen
        ↓
PLAN
  [CN] — Jeden Kandidaten mit Beweis (0 Aufrufer) belegen und als SICHER oder UNSICHER
  einstufen; Abgleich gegen bestehende DEBT-REGISTRY, CON-000001 und APPROVED ADRs
        ↓
HARDEN
  [CN] — Nur SICHER eingestufte Fixes anwenden, in einem einzigen benannten Commit
  sichern (kein Push/Force/Amend)
        ↓
VERIFY
  [CN] — Testsuite (falls konfiguriert) vor und nach den Änderungen ausführen; bei
  Fehlschlag betroffene Änderung revertieren und stattdessen als DEBT-NNNNNN loggen
        ↓
REPORT
  [CN] — Ergebnis zusammenfassen
  Output: CNS-NNNNNN (Konsolidierungsbericht), ggf. neue DEBT-NNNNNN
```

## Konsolidierungsbericht-Format (`CNS-NNNNNN`)

Vollständiges Template mit Header, allen Abschnitten und Übergabe-Block:
`toolchain/templates/consolidation-report.md`.

## Gates

### Gate: Scan → Plan

| Kriterium | Prüfung | Schwere |
|---|---|---|
| Git-Tree war vor Start sauber (`git status`) | Direkter Check vor jeder Code-Änderung | BLOCKER |
| Codebase indiziert / aktuell | `index_repository`-Status | BLOCKER |

### Gate: Plan → Harden

| Kriterium | Prüfung | Schwere |
|---|---|---|
| Jeder Kandidat mit Beweis (0 Aufrufer, Fundstelle) belegt | CNS-NNNNNN Abschnitt 2 | BLOCKER |
| Jeder Kandidat eindeutig als SICHER oder UNSICHER eingestuft | CNS-NNNNNN Abschnitt 2 | BLOCKER |
| Kein SICHER-Fund widerspricht CON-000001 (Abschnitt 4) oder einem APPROVED ADR | Stichprobe gegen Constitution/ADRs | BLOCKER |

### Gate: Harden → Verify

| Kriterium | Prüfung | Schwere |
|---|---|---|
| Nur SICHER eingestufte Kandidaten wurden angewendet | Diff gegen Plan-Abschnitt | BLOCKER |
| Alle Fixes in genau einem benannten Commit gesichert | `git log` (ein neuer Commit) | BLOCKER |

### Gate: Verify → Report

| Kriterium | Prüfung | Schwere |
|---|---|---|
| Testsuite nach Änderung grün (falls konfiguriert) | Testlauf-Ergebnis | BLOCKER |
| Bei Testfehlschlag: verantwortliche Änderung revertiert, als DEBT-NNNNNN geloggt | CNS-NNNNNN Abschnitt 4 | BLOCKER |
| Fehlende Testsuite explizit vermerkt (kein stillschweigendes Überspringen) | CNS-NNNNNN Abschnitt 5 | MAJOR |

## Rollback-Regeln

| Gate-Fehlschlag | Rollback-Ziel | Wer wird aktiviert |
|---|---|---|
| Gate Scan → Plan (unsauberer Git-Tree) | Abbruch vor jeder Code-Änderung | Nutzer (Arbeitsstand aufräumen/committen), danach CN erneut |
| Gate Plan → Harden | PLAN | CN (Einstufung/Beweisführung nachbessern) |
| Gate Harden → Verify | HARDEN | CN (nur SICHER-Fixes anwenden, Commit korrigieren) |
| Gate Verify → Report (Testfehlschlag) | VERIFY | CN (einzelne Änderung revertieren, als DEBT loggen, danach erneut verifizieren) |

## .phase Verhalten

```yaml
current-phase: HARDEN
harden-pfad: "src/"
harden-started: 2026-08-16
```

Nach Harden-Abschluss: `.phase` auf vorherigen Wert zurücksetzen — Harden ist kein
Phasenwechsel, unabhängig vom Ergebnis (analog Converge/Spike).
