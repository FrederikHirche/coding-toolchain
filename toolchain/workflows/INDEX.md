# Workflows-Verzeichnis

Wiederverwendbare, benannte Prozesssequenzen für unterschiedliche Entwicklungsszenarien.

Letzte Aktualisierung: 2026-08-17

## Inhalt

| Datei | ID | Szenario | Phasen |
|-------|-----|---------|--------|
| `full-sprint.md` | WF-FULL-SPRINT | Vollständiger Sprint (Discovery → Release) | 10 Nutzerphasen; Gate 5.5 als Implementierungs-Preflight |
| `hotfix.md` | WF-HOTFIX | Kritischer Produktionsfehler | 4 Phasen (vereinfacht) |
| `spike.md` | WF-SPIKE | Technische Erkundung ohne Implementierung | 3 Phasen |
| `converge.md` | WF-CONVERGE | Brownfield-Gap-Analyse (bestehender Code gegen Spec) | 3 Phasen |
| `harden.md` | WF-HARDEN | Konsolidierung/Hardening (toter Code, Duplikate, Vereinfachung) | 5 Phasen |
| `decompose.md` | WF-DECOMPOSE | Kopplungs-/Grenzenanalyse für Service-Aufspaltung | 4 Phasen |

## Auswahl des richtigen Workflows

```
Neues Feature / neues Projekt?       → full-sprint.md  (/sprint)
Produktionsfehler, kein Scope-Wechsel? → hotfix.md     (/hotfix)
Technologiefrage ungeklärt?           → spike.md        (/spike)
Bestehender Code, Spec unklar/fehlt?  → converge.md     (/converge)
Bestandscode härten (toter Code/Duplikate)? → harden.md (/harden)
Monolith zu stark gekoppelt, Service-Aufspaltung erwägen? → decompose.md (/decompose)
```

## Workflow-Aufbau

Jeder Workflow definiert:
- Phasensequenz mit klaren Übergaben
- Gate-Kriterien pro Phase (BLOCKER / MAJOR / MINOR)
- Rollback-Regeln bei Gate-Fehlschlag
- `.phase`-Verhalten für Zustandsverfolgung
