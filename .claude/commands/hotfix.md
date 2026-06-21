# /hotfix — Notfall-Fix-Workflow

Aktiviert den **verkürzten Hotfix-Workflow**. Überspringt Discovery, Requirements und Architecture — geht direkt zur Implementierung.

## Verwendung

```
/hotfix [projektname] [bug-beschreibung]
/hotfix mein-projekt "Login schlägt fehl nach Passwort-Reset"
```

## Wann verwenden

- Kritischer Produktionsfehler (BLOCKER oder CRITICAL)
- Fix ist klar umrissen, keine neuen Requirements nötig
- Bestehende Architektur bleibt unverändert

## Workflow

```
HOTFIX-ANALYSIS  → BA-Agent (minimal: BUG-NNNNNN anlegen, Ursache analysieren)
     ↓
HOTFIX-IMPLEMENT → FE/BE-Agent (nur betroffene Komponenten)
     ↓
HOTFIX-TEST      → QA-Agent (Smoke Test + Regressionstest betroffener Bereiche)
     ↓
HOTFIX-REVIEW    → RV-Agent (fokussierter Review nur der Änderung)
```

## Artefakte

Minimale Artefakt-Produktion:
- `BUG-NNNNNN` — Fehlerbeschreibung + Root Cause
- `TR-NNNNNN` — Testergebnis (Smoke Test)
- `RV-NNNNNN` — Review-Bericht (vereinfacht)

## Vorbedingungen

- Projekt muss sich in Phase `DONE` oder `IMPLEMENTATION` befinden
- `ADR-000001` muss `APPROVED` sein (kein Architektur-Wechsel)
- Mindestens ein Mensch autorisiert den Hotfix

---

**Agent:** ORCH (Orchestrator) → BA → FE/BE → QA → RV
**Workflow:** `toolchain/workflows/hotfix.md`
