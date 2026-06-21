# /refine — Refinement / Sprint Planning

Bereitet den Sprint Backlog vor: verfeinert User Stories, schätzt Aufwände und definiert Sprint-Ziele.

## Verwendung

```
/refine [projektname] [sprint-nummer]
```

## Was passiert

1. Liest alle APPROVED US-NNNNNN und UX-NNNNNN
2. Verfeinert Stories: Subtasks, Schätzungen (Story Points oder T-Shirt-Sizes), Abhängigkeiten
3. Erstellt Sprint-Backlog-Dokument (`projects/<projektname>/sprints/SPRINT-NNNNNN.md`)
4. Definiert Sprint-Ziel und Abnahmekriterien
5. Identifiziert technische Voraussetzungen (was muss vor dem Sprint fertig sein?)
6. Aktualisiert INDEX.md

## Vorbedingungen

- `UX-NNNNNN` für Sprint-Stories vorhanden
- `ADR-000001` approved

## Nächster Schritt

Nach Abschluss: `/implement`

---

**Beteiligte Agenten:** BA, FE, BE (gemeinsames Refinement)
**Output:** `SPRINT-NNNNNN.md` Sprint Backlog
