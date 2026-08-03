---
id: EPIC-NNNNNN
title: Epic — [Kurztitel]
version: 1.0
status: DRAFT
author-agent: BA (Business Analyst)
date: YYYY-MM-DD
project: [projektname]
based-on: SB-NNNNNN, REQ-NNNNNN
supersedes: —
superseded-by: —
github-milestone: —                # Nummer/Titel des gespiegelten GitHub Milestones, nur gesetzt wenn github.enabled
---

# EPIC-NNNNNN: [Kurztitel]

> **Ablage:** `projects/[projektname]/requirements/EPIC-NNNNNN-[kurztitel].md`
> Ein Epic bündelt mehrere zusammengehörige User Stories (und ggf. Bugs/Tech-Schulden/
> Impediments, die auf dasselbe Ziel einzahlen) zu einem größeren, für sich abnahmefähigen
> Vorhaben. Epics werden von BA während `/ba` aus dem Gesamtscope gebildet — nicht erst
> sprintweise. In GitHub Projects entspricht ein Epic einem repo-weiten **Milestone**
> (kein eigenes Issue).

---

## Zielbild

**Outcome:** [Welcher Nutzen entsteht, wenn dieses Epic vollständig abgeschlossen ist?]

**Abgrenzung:** [Was gehört klar dazu, was ausdrücklich nicht — verhindert Scope Creep über
Sprints hinweg]

---

## Zugehörige Artefakte

| Artefakt-ID | Typ | Priorität (MoSCoW) | Status |
|---|---|---|---|
| US-NNNNNN | Story | Must | DRAFT |
| US-NNNNNN | Story | Should | DRAFT |
| DEBT-NNNNNN | Tech-Schuld | — | OFFEN |

*Vollständige Liste wird von BA beim Anlegen aller Stories im Gesamtscope befüllt — nicht
nur die Stories des nächsten Sprints.*

---

## Grober Zeitrahmen

**Ziel-Meilenstein / Ziel-Sprint:** [z. B. „Sprint 4" oder Datum]
**Ziel-Datum:** YYYY-MM-DD
**Abhängig von:** [Andere EPIC-NNNNNN, ADR-NNNNNN, oder externe Voraussetzung]

---

## Status-Verlauf

| Datum | Status | Kommentar |
|-------|--------|-----------|
| YYYY-MM-DD | DRAFT | Aus Requirements-Analyse gebildet |
| | ACTIVE | Erste zugehörige Story in Umsetzung |
| | DONE | Alle zugehörigen Must/Should-Stories abgeschlossen |

---

*Erstellt von: BA-Agent | Datum: YYYY-MM-DD | Version: 1.0*
*Ablage: projects/[projektname]/requirements/EPIC-NNNNNN-[kurztitel].md*
