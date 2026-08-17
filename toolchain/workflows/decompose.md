---
id: WF-DECOMPOSE
title: Kopplungs-/Grenzenanalyse für Service-Aufspaltung
version: 1.0
status: ACTIVE
---

# Workflow: Decompose

Ad-hoc Kopplungs- und Kohäsionsanalyse einer bereits existierenden Codebase, um belegte
Kandidaten für eine Aufspaltung in eigenständige Services zu identifizieren. Anders als
`/converge` (Spec-Abdeckung/Drift) prüft dieser Workflow keine Spezifikation, sondern die
strukturelle Kopplung des Codes selbst — und liefert pro Kandidat einen ratifizierbaren
ADR-Entwurf statt nur einer Handlungsempfehlung.

## Aktivierung

```
/decompose [projektname] [pfad-optional]
```

## Wann Decompose verwenden

- Verdacht, dass ein Modul/eine Komponente zu monolithisch gewachsen ist
- Vor einer größeren Architekturentscheidung, wenn unklar ist, ob eine Aufspaltung
  überhaupt technisch sinnvoll wäre (Kopplung könnte das verhindern)
- Nach mehreren Sprints, um zu prüfen, ob sich de-facto-Modulgrenzen im Code gebildet
  haben, die noch nicht als Services abgebildet sind

## Decompose ≠ Sprint-Phase

Decompose ist **kein Sprint-Phase**, **kein automatischer Refactor** und **kein Ersatz
für `/converge`** — es ändert keinen Code und prüft keine Spec-Abdeckung. Es produziert
eine Kopplungs-/Kohäsionsanalyse (`DCP-NNNNNN`) mit eingebettetem ADR-Entwurf, der erst
durch `/architect` zu einer bindenden `ADR-NNNNNN` wird.

## Phasen-Sequenz

```
SCAN
  [AR] — index_repository (falls nötig) + get_architecture(aspects: clusters,
  boundaries, layers) — de-facto-Module mit Cohesion-Score ermitteln
        ↓
ANALYZE
  [AR] — Fan-in/Fan-out-Hotspots (search_graph min_degree/max_degree), Cross-Cluster-
  Kopplung und Zyklen (query_graph), ggf. trace_path(cross_service); jeden Cluster als
  Kandidat oder Noch-nicht-bereit einstufen
        ↓
DRAFT
  [AR] — Für jeden Kandidaten einen vollständigen ADR-Entwurf (Status DRAFT) verfassen
        ↓
REPORT
  [AR] — Ergebnis zusammenfassen
  Output: DCP-NNNNNN (Decomposition-Analyse inkl. ADR-Entwurf/-Entwürfen)
```

## Decomposition-Analyse-Format (`DCP-NNNNNN`)

Vollständiges Template mit Header, allen Abschnitten und Übergabe-Block:
`toolchain/templates/decomposition-analysis.md`.

## Gates

### Gate: Scan → Analyze

| Kriterium | Prüfung | Schwere |
|---|---|---|
| Code-Pfad existiert und ist lesbar | Pfad-Check | BLOCKER |
| Jeder Cluster mit Cohesion-Score belegt (Abschnitt 2) | DCP-NNNNNN Abschnitt 2 Tabelle ausgefüllt | BLOCKER |

### Gate: Analyze → Draft

| Kriterium | Prüfung | Schwere |
|---|---|---|
| Jede Kopplungsaussage (Cross-Cluster-Kantenzahl, Zyklus) mit konkreter Kante/Fundstelle belegt | Stichprobe | BLOCKER |
| Jeder Cluster eindeutig als Kandidat oder Noch-nicht-bereit eingestuft | DCP-NNNNNN Abschnitt 4 | BLOCKER |

### Gate: Draft → Report

| Kriterium | Prüfung | Schwere |
|---|---|---|
| ADR-Entwurf vollständig nach `architecture-decision.md`-Struktur, Status DRAFT | DCP-NNNNNN Abschnitt 5 | BLOCKER |
| Kein ADR-Entwurf für Noch-nicht-bereit-Cluster | Stichprobe gegen Abschnitt 4 | BLOCKER |
| Nicht geprüfte Bereiche benannt | DCP-NNNNNN Abschnitt 7 | MAJOR |

## Rollback-Regeln

| Gate-Fehlschlag | Rollback-Ziel | Wer wird aktiviert |
|---|---|---|
| Gate Scan → Analyze | SCAN | AR (Pfad prüfen, Cluster-Erfassung nachbessern) |
| Gate Analyze → Draft | ANALYZE | AR (Kopplungsbelege/Einstufung vervollständigen) |
| Gate Draft → Report | DRAFT | AR (ADR-Entwurf nachbessern oder streichen) |

## .phase Verhalten

```yaml
current-phase: DECOMPOSE
decompose-code-pfad: "src/"
decompose-started: 2026-08-17
```

Nach Decompose-Abschluss: `.phase` auf vorherigen Wert zurücksetzen — Decompose ist kein
Phasenwechsel, unabhängig davon, ob ein ADR-Entwurf zur Ratifizierung ansteht.
