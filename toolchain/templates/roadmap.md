---
id: RM-NNNNNN
title: Roadmap / Release-Plan — [Projekttitel]
version: 1.0
status: DRAFT
author-agent: BA (Business Analyst)
date: YYYY-MM-DD
project: [projektname]
based-on: REQ-NNNNNN, alle EPIC-NNNNNN und US-NNNNNN
supersedes: —
superseded-by: —
---

# RM-NNNNNN: Roadmap / Release-Plan — [Projekttitel]

> **Ablage:** `projects/[projektname]/requirements/RM-NNNNNN-roadmap.md`
> Grobplanung des **gesamten** Projekt-Scopes — nicht nur des nächsten Sprints. Wird von BA
> als letzter Schritt von `/ba` erstellt, nachdem alle Epics und Stories für den kompletten
> Scope stehen. `/refine` verfeinert pro Sprint nur die jeweils anstehende Iteration
> (Subtasks, Ist-Aufwand) und schreibt Abweichungen hierher zurück — diese Datei bleibt die
> Quelle für Iteration/Datum/Schätzung, die der GitHub-Board-Sync auf das Board überträgt.

---

## Gesamtscope-Übersicht

| Epic | Priorität | Ziel-Iteration | Ziel-Datum |
|---|---|---|---|
| EPIC-NNNNNN | Must | 1–2 | YYYY-MM-DD |
| EPIC-NNNNNN | Should | 3 | YYYY-MM-DD |

---

## Vollständiger Backlog mit Vorausplanung

Eine Zeile pro Artefakt (US/BUG/DEBT/IMPD) im **gesamten** Scope — nicht nur Sprint 1.

| ID | Epic | Priorität (MoSCoW) | Schätzung (SP) | Size | Iteration | Start | Ziel | Abhängigkeiten |
|---|---|---|---|---|---|---|---|---|
| US-000001 | EPIC-000001 | Must | 3 | M | 1 | YYYY-MM-DD | YYYY-MM-DD | — |
| US-000002 | EPIC-000001 | Must | 5 | L | 1 | YYYY-MM-DD | YYYY-MM-DD | Blockiert durch US-000001 |
| US-000010 | EPIC-000002 | Should | 2 | S | 2 | YYYY-MM-DD | YYYY-MM-DD | — |

*Schätzung in Story Points (Fibonacci: 1/2/3/5/8/13). Size: XS/S/M/L/XL. Iteration = geplante
Sprint-Nummer. Diese Tabelle ist die Quelle für die Frontmatter-Felder `estimate`, `size`,
`iteration`, `start-date`, `target-date` in den jeweiligen US/BUG/DEBT/IMPD-Artefakten und
wird beim GitHub-Board-Sync in Estimate-/Size-/Iteration-/Datumsfelder des Boards übertragen
(siehe `toolchain/protocols/github-board-sync.md`).*

---

## Iterationskadenz

**Iterationslänge:** [Tage, z. B. 14 — muss mit `github.iteration-length-days` in
`.toolchain.yml` übereinstimmen]
**Start der ersten Iteration:** YYYY-MM-DD
**Anzahl geplanter Iterationen im Scope:** [N]

---

## Ist-Abweichungen (wird pro Sprint durch `/refine` nachgetragen)

| Sprint | Betroffene ID | Ursprünglich geplant | Tatsächlich | Grund |
|---|---|---|---|---|
| | | | | |

---

## Offene Annahmen

- [Was wurde bei der Schätzung angenommen, ist aber unsicher?]

---

*Erstellt von: BA-Agent | Datum: YYYY-MM-DD | Version: 1.0*
*Ablage: projects/[projektname]/requirements/RM-NNNNNN-roadmap.md*
