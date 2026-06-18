---
id: US-NNN
title: [Kurztitel]
version: 1.0
status: DRAFT
author-agent: BA (Business Analyst)
date: YYYY-MM-DD
epic: [Epic-Name]
priority: Must | Should | Could | Won't
sprint: —
supersedes: —
superseded-by: —
---

# US-NNN: [Kurztitel]

## User Story

**Als** [Nutzerrolle / Persona]
**möchte ich** [Ziel / Aktion]
**damit** [Nutzen / Mehrwert]

---

## Kontext

[Optionaler Hintergrund: Warum ist diese Story wichtig? Woher kommt sie?
Verweis auf SB-NNN oder REQ-F-NNN wenn sinnvoll.]

---

## Akzeptanzkriterien

### Szenario 1: [Happy Path Name]

```
GEGEBEN  [Ausgangszustand / Vorbedingung]
WENN     [Nutzer-Aktion / Ereignis]
DANN     [Erwartetes Systemverhalten]
```

### Szenario 2: [Fehlerfall / Edge Case]

```
GEGEBEN  [Ausgangszustand]
WENN     [Auslöser des Fehlerfalls]
DANN     [Erwartetes Fehlerverhalten — z. B. Fehlermeldung, Rollback]
```

### Szenario 3: [Weiterer relevanter Fall]

```
GEGEBEN  [...]
WENN     [...]
DANN     [...]
```

*Mindestens 3 Szenarien. Minimum: 1 Happy Path, 1 Fehlerfall, 1 Boundary/Edge Case.*

---

## Nicht-Ziele dieser Story

*Was ist explizit NICHT Bestandteil dieser Story? (Verhindert Scope Creep)*

- [Nicht-Ziel 1]
- [Nicht-Ziel 2]

---

## Abhängigkeiten

| Typ | Referenz | Beschreibung |
|---|---|---|
| Blockiert durch | US-NNN | [Diese Story kann erst starten wenn US-NNN fertig ist] |
| Blockiert | US-NNN | [Diese Story muss fertig sein bevor US-NNN beginnen kann] |
| ADR | ADR-NNN | [Diese Story hängt von Architekturentscheidung ab] |

---

## UX-Referenz

- UX-Spec: [UX-NNN — Titel] *(wird nach /ux befüllt)*

---

## Technische Notizen

*(Wird während Refinement oder Implementierung befüllt)*

**Frontend-Aufwand:** [Story Points / T-Shirt-Size]
**Backend-Aufwand:** [Story Points / T-Shirt-Size]
**Besondere technische Risiken:** [Falls bekannt]

---

## Definition of Done

- [ ] Alle Akzeptanzkriterien implementiert und verifiziert
- [ ] Unit-Tests für alle neuen Funktionen
- [ ] Code kommentiert nach CLAUDE.md-Standard
- [ ] Code Review abgeschlossen (RV-NNN)
- [ ] Kein offener BLOCKER-Bug
- [ ] Dokumentation (INDEX.md, API-Kontrakt) aktualisiert

---

*Erstellt von: BA-Agent | Datum: YYYY-MM-DD | Version: 1.0*
