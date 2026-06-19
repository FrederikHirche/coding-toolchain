---
id: AGENT-BASE
title: Basis-Agent-Template
version: 1.0
status: ACTIVE
note: Dieses Dokument wird von allen Agenten-Definitionen geerbt. Nicht direkt aktivieren.
---

# Basis-Agent-Template

Alle Agenten in dieser Tool Chain folgen dem folgenden Aufbau und erben die hier definierten Regeln. Spezifische Agenten-Dateien überschreiben einzelne Abschnitte, ergänzen sie oder referenzieren sie.

---

## Aktivierungsregel

Ein Agent wird aktiviert, wenn Claude das zugehörige Slash Command in Claude Code ausführt. Claude liest dabei:
1. Diese Basisdatei (implizit über CLAUDE.md)
2. Die spezifische Agenten-Datei (`toolchain/agents/<name>-agent.md`)
3. Alle für den Agenten relevanten Artefakte aus dem Projektordner

Claude übernimmt für die Dauer der Session vollständig die Rolle des aktivierten Agenten. Rollenwechsel nur durch expliziten neuen Slash Command.

---

## Pflicht-Verhalten aller Agenten

### Artefakt-Eröffnung

Jedes produzierte Artefakt beginnt mit dem Standard-Header:

```markdown
---
id: [PRÄFIX-NNN]
title: [Kurztitel]
version: 1.0
status: DRAFT
author-agent: [KÜRZEL] ([Vollname])
date: YYYY-MM-DD
project: [Projektname]
based-on: [Eingabe-Artefakt-IDs, kommagetrennt]
supersedes: —
superseded-by: —
---
```

### INDEX.md-Pflicht

Nach jeder Artefakt-Erstellung **muss** der Agent die `INDEX.md` des Zielordners aktualisieren. Format:

```markdown
| `dateiname.md` | PRÄFIX-NNN | DRAFT | Kurzbeschreibung |
```

### Handoff-Protokoll

Am Ende jeder Session produziert der Agent ein Übergabe-Block nach dem Format in `toolchain/protocols/handoff-protocol.md`. Dieser Block wird am Ende des primären Ausgabe-Artefakts eingefügt.

### Gate-Selbstprüfung

Vor Abschluss führt jeder Agent eine Selbstprüfung seiner Definition-of-Done-Checkliste durch. Nicht erfüllte Kriterien werden explizit als `OFFEN` markiert — der Agent schließt nicht ab ohne diesen Abschnitt.

### Rückfragen-Protokoll

Falls der Agent zur Weiterarbeit externe Informationen benötigt, die er nicht aus Artefakten ableiten kann:
1. Offene Fragen auflisten (nummeriert)
2. Jeweils: Was ist die Frage, wer kann antworten, wie kritisch ist sie?
3. Mit Arbeit am Rest fortfahren, offen gebliebene Stellen mit `[AUSSTEHEND: Frage-N]` markieren

### Keine Technologie-Annahmen

Kein Agent darf Sprache, Framework, Plattform oder Tooling voraussetzen, solange kein `ADR-001-tech-stack.md` im Status `APPROVED` im Projektordner existiert. Erst danach sind projektspezifische Technologien verbindlich.

---

## Code-Kommentierungsstandard (für FE- und BE-Agent)

```
DATEI-HEADER (erste Zeilen jeder Code-Datei):
  Beschreibung: [Was tut dieses Modul?]
  Artefakte:    [Implementiert US-NNN; siehe ADR-NNN]
  Agent:        [FE|BE] — YYYY-MM-DD

FUNKTION/METHODE:
  - JSDoc / DocString / Doccomment je nach Sprache
  - @param / @returns / @throws immer (auch wenn void)
  - Seiteneffekte explizit: "Schreibt in DB", "Dispatcht Event"

KOMPLEXE LOGIK:
  - Kommentar ÜBER dem Block: Warum, nicht Was
  - ADR-Verweis wenn relevant: // → ADR-005

TODO-FORMAT:
  // TODO(KÜRZEL): Beschreibung — YYYY-MM-DD
  Erlaubte Kürzel: PM BA AR UX FE BE QA RV MW AC
```

---

## Artefakt-Benennung (Referenz)

| Typ | Präfix | Sequenz |
|-----|--------|---------|
| Stakeholder Brief | `SB` | pro Projekt ab 001 |
| Requirements | `REQ` | pro Projekt ab 001 |
| User Story | `US` | pro Projekt ab 001 |
| Architecture Decision Record | `ADR` | pro Projekt ab 001 |
| UX-Spec | `UX` | pro Projekt ab 001 |
| Sprint Backlog | `SP` | pro Projekt ab 001 |
| Testplan | `TP` | pro Sprint ab 001 |
| Testergebnis | `TR` | pro Testplan ab 001 |
| Review-Bericht | `RV` | pro Sprint ab 001 |
| Bug | `BUG` | pro Projekt ab 001 |
| Technische Schulden | `DEBT` | pro Projekt ab 001 |
| Feature-Guide | `DOC` | pro Projekt ab 001 |
| Release Notes | `RN` | pro Projekt ab 001 |
| Sprint-Retrospektive | `RETRO` | pro Projekt ab 001 |
| Process Change Proposal | `PC` | pro Projekt ab 001 |

---

## Statuswerte-Referenz

```
DRAFT       → In Bearbeitung durch den Autor-Agenten
REVIEW      → Fertig, wartet auf Freigabe
APPROVED    → Freigegeben, verbindlich für nachfolgende Agenten
ACTIVE      → In aktivem Einsatz
SUPERSEDED  → Ersetzt durch neuere Version [SUPERSEDED by ID]
ARCHIVED    → Abgeschlossen, nicht mehr aktiv
```
