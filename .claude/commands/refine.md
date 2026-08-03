# /refine — Refinement / Sprint Planning

Bereitet den Sprint Backlog vor: verfeinert User Stories, schätzt Aufwände und definiert Sprint-Ziele.

## Verwendung

```
/refine [projektname] [sprint-nummer]
```

## Was passiert

0. Falls `github.enabled: true`: `github-board-sync` im Modus `reconcile` ausführen (siehe
   `toolchain/protocols/github-board-sync.md`)
1. Liest alle APPROVED US-NNNNNN und UX-NNNNNN sowie die Grobplanung aus `RM-NNNNNN`
   (Roadmap — enthält bereits Estimate/Size/Iteration/Datum aus `/ba`, für den GESAMTEN
   Scope, nicht nur diesen Sprint)
2. Verfeinert NUR die Stories der anstehenden Iteration: Subtasks, Ist-Aufwand (Story
   Points/T-Shirt-Size — Abgleich gegen die RM-NNNNNN-Grobschätzung), Abhängigkeiten
3. Erstellt Sprint-Backlog-Dokument (`projects/<projektname>/sprints/SP-NNNNNN.md`)
4. Definiert Sprint-Ziel und Abnahmekriterien
5. Identifiziert technische Voraussetzungen (was muss vor dem Sprint fertig sein?)
6. Schreibt Abweichungen zwischen Grobplanung und Ist-Aufwand in den Abschnitt
   "Ist-Abweichungen" von `RM-NNNNNN` zurück — die Roadmap bleibt die Quelle für
   Estimate/Size/Iteration/Datum, `/refine` ersetzt sie nicht, sondern präzisiert sie
7. Aktualisiert INDEX.md
8. Falls `github.enabled: true`: `github-board-sync` im Modus `push` ausführen — überträgt
   aktualisierte Estimate/Iteration/Datumswerte auf das Board

## Vorbedingungen

- `UX-NNNNNN` für Sprint-Stories vorhanden
- `ADR-000001` approved
- `RM-NNNNNN` vorhanden (aus `/ba`) — enthält die Grobplanung, die hier verfeinert wird

## Nächster Schritt

Nach Abschluss: `/implement [modus] [projektname]` — der Implementierungs-Command führt die
Cross-Artefakt-Konsistenzprüfung (Gate 5.5) als Preflight aus.

---

**Beteiligte Agenten:** BA, FE, BE (gemeinsames Refinement)
**Output:** `SP-NNNNNN` Sprint Backlog
