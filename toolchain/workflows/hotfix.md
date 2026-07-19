---
id: WF-HOTFIX
title: Hotfix-Workflow
version: 1.0
status: ACTIVE
---

# Workflow: Hotfix

Verkürzter Workflow für kritische Fehler in laufenden Systemen.
Überspringt Discovery, Architecture und UX. Minimaler Artefakt-Footprint.

## Aktivierung

```
/hotfix [projektname] [bug-beschreibung]
```

## Einsatzbedingungen

Alle drei Bedingungen müssen erfüllt sein:

1. **Produktionsfehler** — Bug betrifft Live-System oder blockiert Release
2. **Kein Scope-Wechsel** — Nur Fehler-Korrektur, keine neuen Features
3. **Architektur unverändert** — `ADR-000001` bleibt gültig, kein neuer ADR nötig

Wenn eine der Bedingungen nicht erfüllt ist → normaler Sprint-Workflow.

## Phasen-Sequenz

```
HOTFIX-ANALYSE
  /hotfix-analyse [intern, Teil von /hotfix]
  [BA] — BUG-NNNNNN anlegen, Root-Cause, betroffene Komponenten
  Dauer: max. 30 Minuten
        ↓
HOTFIX-IMPLEMENT
  /implement [spezifische Dateien]
  [FE und/oder BE] — Nur betroffene Komponenten
  Dauer: richtet sich nach Komplexität
        ↓
HOTFIX-TESTING
  /test-run [projektname] [sprint-nr]
  [QA] — Smoke-Test + Regressionstest betroffener Bereiche (kein vollständiger Testlauf)
        ↓
HOTFIX-REVIEW
  /review [projektname] [sprint-nr]
  [RV] — Fokussierter Review der Änderung, ausgeführt auf dem Hotfix-Branch
```

## Gate 1: Analysis → Implementation

| Kriterium | Prüfung | Schwere |
|---|---|---|
| `BUG-NNNNNN` erstellt mit Root-Cause | Abschnitt "Root-Cause" in BUG-NNNNNN ausgefüllt | BLOCKER |
| Betroffene Komponenten identifiziert | Abschnitt "Betroffene Komponenten" in BUG-NNNNNN ausgefüllt | BLOCKER |
| Fix-Ansatz beschrieben (keine blindes Patchen) | Abschnitt "Fix-Ansatz" in BUG-NNNNNN ausgefüllt (kein Platzhalter) | BLOCKER |
| Regressionsrisiko eingeschätzt | BUG-NNNNNN: Hoch/Mittel/Gering + Begründung | MAJOR |

## Gate 2: Implementation → Testing

| Kriterium | Prüfung | Schwere |
|---|---|---|
| Nur betroffene Dateien geändert (kein Feature-Creep) | Diff-Vergleich gegen "Betroffene Komponenten" aus BUG-NNNNNN | BLOCKER |
| Fix adressiert Root-Cause, nicht nur Symptom | Selbstauskunft FE/BE: Root-Cause aus BUG-NNNNNN behoben | BLOCKER |
| Kein neuer Lint-Fehler | `lint`-Befehl aus `.toolchain.yml` | MAJOR |

## Gate 3: Testing → Review

| Kriterium | Prüfung | Schwere |
|---|---|---|
| `TR-NNNNNN` (Smoke Test) vorhanden | Datei vorhanden | BLOCKER |
| Smoke-Test: kein neuer BLOCKER-Bug | TR-NNNNNN Bug-Liste enthält keine neuen BLOCKER-Einträge | BLOCKER |
| Ursprünglicher Bug reproduzierbar getestet | TR-NNNNNN: expliziter Retest-Vermerk zum Original-Bug | BLOCKER |
| Regressionstest durchgeführt | Abschnitt "Regressionstest" in TR-NNNNNN ausgefüllt | MAJOR |

## Gate 4: Review → Merge

| Kriterium | Prüfung | Schwere |
|---|---|---|
| `RV-NNNNNN` mit `APPROVED` | Header-Feld `status: APPROVED` | BLOCKER |
| Keine Security-Anmerkungen (BLOCKER/MAJOR) | RV-NNNNNN Sicherheits-Dimension: keine offenen BLOCKER/MAJOR | BLOCKER |
| Kein ADR-Verstoß | RV-NNNNNN ADR-Konformitäts-Dimension | MAJOR |

## Rollback-Regeln

| Gate-Fehlschlag | Rollback-Ziel | Wer wird aktiviert |
|---|---|---|
| Gate 1 | HOTFIX-ANALYSE | BA (Root-Cause nachschärfen) |
| Gate 2 | HOTFIX-IMPLEMENT | FE/BE (Korrektur) |
| Gate 3 | HOTFIX-IMPLEMENT | FE/BE (Bug-Fix) |
| Gate 4 (REQUEST CHANGES) | HOTFIX-IMPLEMENT | FE/BE (Korrekturen) |
| Gate 4 (REJECTED) | HOTFIX-ANALYSE | BA (Root-Cause-Problem) |

## Artefakte (Minimal-Set)

| Artefakt | Pflicht | Inhalt |
|----------|---------|--------|
| `BUG-NNNNNN` | ✓ | Fehlerbeschreibung, Root-Cause, betroffene Komponenten |
| `TR-NNNNNN` | ✓ | Smoke-Test-Ergebnis |
| `RV-NNNNNN` | ✓ | Fokussierter Review |
| `TP-NNNNNN` | ✗ optional | Nur wenn umfangreichere Tests nötig |

## .phase Verhalten

Hotfix setzt `.phase` auf `HOTFIX-[ANALYSE|IMPLEMENT|TESTING|REVIEW]`.
Nach erfolgreichem Merge: `.phase` wieder auf vorherigen Wert setzen.

```yaml
# .phase während Hotfix
current-phase: HOTFIX-REVIEW
hotfix-for: BUG-000007
previous-stable-phase: DONE
sprint: 2
```
