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
HOTFIX-ANALYSIS
  /hotfix-analyse [intern, Teil von /hotfix]
  [BA] — BUG-NNNNNN anlegen, Root-Cause, betroffene Komponenten
  Dauer: max. 30 Minuten
        ↓
HOTFIX-IMPLEMENTATION
  /implement [spezifische Dateien]
  [FE und/oder BE] — Nur betroffene Komponenten
  Dauer: richtet sich nach Komplexität
        ↓
HOTFIX-TESTING
  /test-run [smoke]
  [QA] — Smoke-Test + Regressionstest betroffener Bereiche
        ↓
HOTFIX-REVIEW
  /review [hotfix-branch]
  [RV] — Fokussierter Review der Änderung
```

## Gate 1: Analysis → Implementation

| Kriterium | Schwere |
|---|---|
| `BUG-NNNNNN` erstellt mit Root-Cause | BLOCKER |
| Betroffene Komponenten identifiziert | BLOCKER |
| Fix-Ansatz beschrieben (keine blindes Patchen) | BLOCKER |
| Regressionsrisiko eingeschätzt | MAJOR |

## Gate 2: Implementation → Testing

| Kriterium | Schwere |
|---|---|
| Nur betroffene Dateien geändert (kein Feature-Creep) | BLOCKER |
| Fix adressiert Root-Cause, nicht nur Symptom | BLOCKER |
| Kein neuer Lint-Fehler | MAJOR |

## Gate 3: Testing → Review

| Kriterium | Schwere |
|---|---|
| `TR-NNNNNN` (Smoke Test) vorhanden | BLOCKER |
| Smoke-Test: kein neuer BLOCKER-Bug | BLOCKER |
| Ursprünglicher Bug reproduzierbar getestet | BLOCKER |
| Regressionstest durchgeführt | MAJOR |

## Gate 4: Review → Merge

| Kriterium | Schwere |
|---|---|
| `RV-NNNNNN` mit `APPROVED` | BLOCKER |
| Keine Security-Anmerkungen (BLOCKER/MAJOR) | BLOCKER |
| Kein ADR-Verstoß | MAJOR |

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
