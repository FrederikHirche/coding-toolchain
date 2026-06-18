# /manual — Nutzer-Dokumentation schreiben

Aktiviert den **Manual Writer Agent (MW)** für die Erstellung nutzerseitiger Dokumentation.

## Verwendung

```
/manual [projektname] [sprint-nummer]
```

## Was passiert

1. Liest alle APPROVED US-NNN des Sprints
2. Liest zugehörige UX-NNN für UI-Details
3. Liest RV-NNN zur Bestätigung welche Features freigegeben sind
4. Erstellt Feature-Guides (`DOC-NNN`) pro Feature-Gruppe
5. Erstellt Release Notes (`RN-NNN`) für den Sprint
6. Erstellt Getting-Started-Guide (`GS-001`) beim ersten Sprint
7. Aktualisiert `DECISIONS.md` mit Dokumentationsentscheidungen
8. Erstellt `projects/<name>/docs/INDEX.md`

## Vorbedingungen

- `RV-NNN` mit Entscheidung `APPROVED` vorhanden
- Keine offenen BLOCKER-Bugs

## Nächster Schritt

Nach Abschluss: Sprint als abgeschlossen markieren (`REGISTRY.md` aktualisieren, `.phase` → `DONE`)

---

**Agent:** MW (Manual Writer)
**Input:** US-NNN, UX-NNN, RV-NNN
**Output:** `DOC-NNN`, `RN-NNN`, `GS-001` (Sprint 1)
**Template:** `toolchain/templates/` (DOC/RN aus user-story-Pattern)
**Agent-Definition:** `toolchain/agents/manual-writer-agent.md`
