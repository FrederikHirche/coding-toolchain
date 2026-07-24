---
id: WF-CONVERGE
title: Brownfield-Gap-Analyse
version: 1.0
status: ACTIVE
---

# Workflow: Converge

Strukturierte Bestandsaufnahme einer bereits existierenden Codebase gegenüber der (falls
vorhandenen) Spezifikation — für die Übernahme von Altprojekten in die Tool Chain oder bei
Verdacht auf Drift zwischen Spec und Code.

## Aktivierung

```
/converge [projektname] [pfad-zu-code]
```

## Wann Converge verwenden

- Ein Projekt mit bereits existierendem Code wird in die Tool Chain aufgenommen (Brownfield)
- Verdacht auf Drift zwischen Spezifikation (REQ/ADR) und tatsächlichem Code
- Vor Sprint-Planung bei Übernahme eines Altprojekts — um zu wissen, was schon fertig ist

## Converge ≠ Sprint-Phase

Converge ist **kein Sprint-Phase**, **kein Code Review** und **kein automatischer Fix**. Es
produziert eine Bestandsaufnahme (`GAP-NNNNNN`), die als Input für `/kickoff`, `/ba` oder
`/architect` dient — je nachdem, was an Spezifikation bereits vorhanden ist oder fehlt.

## Phasen-Sequenz

```
SCAN
  [AR] — Codebase am angegebenen Pfad untersuchen: Struktur, Entry-Points, Datenmodelle,
  Frameworks/Libraries, vorhandene Tests
        ↓
MATCH
  [AR] — Abgleich mit vorhandenen REQ/US (Abdeckungsmatrix) und ADRs (Architektur-Drift);
  falls keine Spezifikation existiert: Ist-Architektur dokumentieren
        ↓
REPORT
  [AR] — Ergebnis zusammenfassen, explizite Empfehlung aussprechen
  Output: GAP-NNNNNN (Gap-Analyse)
```

## Gap-Analyse-Format (`GAP-NNNNNN`)

Vollständiges Template mit Header, allen Abschnitten und Übergabe-Block:
`toolchain/templates/gap-analysis.md`.

## Gates

### Gate: Scan → Match

| Kriterium | Prüfung | Schwere |
|---|---|---|
| Code-Pfad existiert und ist lesbar | Pfad-Check | BLOCKER |
| Vorhandene Toolchain-Artefakte erfasst (Abschnitt 1) | GAP-NNNNNN Abschnitt 1 Tabelle ausgefüllt | BLOCKER |

### Gate: Match → Report

| Kriterium | Prüfung | Schwere |
|---|---|---|
| Abdeckungsmatrix bzw. Ist-Architektur-Tabelle vollständig für den geprüften Scope | GAP-NNNNNN Abschnitt 2/4 | BLOCKER |
| Jede Abweichung hat konkrete Fundstelle (`pfad/datei.ext:Zeile`) | Stichprobe | MAJOR |
| Empfehlung explizit (keine "es kommt drauf an"-Antworten) | GAP-NNNNNN Abschnitt 6 | BLOCKER |
| Nicht geprüfte Bereiche benannt | GAP-NNNNNN Abschnitt 7 | MAJOR |

## Rollback-Regeln

| Gate-Fehlschlag | Rollback-Ziel | Wer wird aktiviert |
|---|---|---|
| Gate Scan → Match | SCAN | AR (Pfad prüfen, Artefakt-Bestand erneut erfassen) |
| Gate Match → Report | MATCH | AR (Abdeckungsmatrix/Ist-Architektur vervollständigen) |

## .phase Verhalten

```yaml
current-phase: CONVERGE
converge-code-pfad: "src/"
converge-started: 2026-07-24
```

Nach Converge-Abschluss: `.phase` auf vorherigen Wert zurücksetzen — Converge ist kein
Phasenwechsel, unabhängig davon, welche Folgebefehle die Empfehlung auslöst.
