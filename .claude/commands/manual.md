# /manual — Nutzer-Dokumentation schreiben

Aktiviert den **Manual Writer Agent (MW)** für die Erstellung nutzerseitiger Dokumentation.

## Verwendung

```
/manual [projektname] [sprint-nummer]
```

## Was passiert

1. Liest alle APPROVED US-NNNNNN des Sprints
2. Liest zugehörige UX-NNNNNN für UI-Details
3. Liest RV-NNNNNN zur Bestätigung welche Features freigegeben sind
4. Erstellt Feature-Guides (`DOC-NNNNNN`) pro Feature-Gruppe
5. Erstellt Release Notes (`RN-NNNNNN`) für den Sprint
6. Erstellt Getting-Started-Guide (`GS-000001`) beim ersten Sprint
7. Aktualisiert `DECISIONS.md` mit Dokumentationsentscheidungen
8. Erstellt `projects/<name>/docs/INDEX.md`

## Vorbedingungen

- `RV-NNNNNN` mit Entscheidung `APPROVED` vorhanden
- Keine offenen BLOCKER-Bugs

## Nächster Schritt

Nach Abschluss: Sprint als abgeschlossen markieren (`REGISTRY.md` aktualisieren, `.phase` → `DONE`)

---

**Agent:** MW (Manual Writer)
**Input:** US-NNNNNN, UX-NNNNNN, RV-NNNNNN
**Output:** `DOC-NNNNNN`, `RN-NNNNNN`, `GS-000001` (Sprint 1)
**Template:** `toolchain/templates/` (DOC/RN aus user-story-Pattern)
**Agent-Definition:** `toolchain/agents/manual-writer-agent.md`
