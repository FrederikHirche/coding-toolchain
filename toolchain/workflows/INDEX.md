# Workflows-Verzeichnis

Wiederverwendbare, benannte Prozesssequenzen für unterschiedliche Entwicklungsszenarien.

Letzte Aktualisierung: 2026-06-18

## Inhalt

| Datei | ID | Szenario | Phasen |
|-------|-----|---------|--------|
| `full-sprint.md` | WF-FULL-SPRINT | Vollständiger Sprint (Discovery → Review) | 8 Phasen |
| `hotfix.md` | WF-HOTFIX | Kritischer Produktionsfehler | 4 Phasen (vereinfacht) |
| `spike.md` | WF-SPIKE | Technische Erkundung ohne Implementierung | 3 Phasen |

## Auswahl des richtigen Workflows

```
Neues Feature / neues Projekt?       → full-sprint.md  (/sprint)
Produktionsfehler, kein Scope-Wechsel? → hotfix.md     (/hotfix)
Technologiefrage ungeklärt?           → spike.md        (/spike)
```

## Workflow-Aufbau

Jeder Workflow definiert:
- Phasensequenz mit klaren Übergaben
- Gate-Kriterien pro Phase (BLOCKER / MAJOR / MINOR)
- Rollback-Regeln bei Gate-Fehlschlag
- `.phase`-Verhalten für Zustandsverfolgung
