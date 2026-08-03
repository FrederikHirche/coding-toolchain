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
9. Markiert den Sprint als abgeschlossen (`REGISTRY.md` aktualisieren, `.phase` → `DONE`)
10. **Staged, committed und pusht den gesamten Sprint-Stand ins Projekt-eigene GitHub-Repository**
    (`git add`, `git commit -m "feat(sprint-N): ..."`, `git push`) — siehe Abschnitt
    „Git-Abschluss" unten

## Vorbedingungen

- `RV-NNNNNN` mit Entscheidung `APPROVED` vorhanden
- Keine offenen BLOCKER-Bugs

## Git-Abschluss (Schritt 10)

Seit `RETRO-000002` (campaignworld, Sprint 10–13) ist dies ein verbindlicher, standardmäßiger
Abschluss von `/manual` — kein optionaler Zusatzschritt und keine gesonderte Rückfrage pro
Sprint nötig, da hier als Tool-Chain-Prozessregel verankert (siehe `PC-000002`):

1. `git status` im Projektordner prüfen (nichts Unerwartetes/Fremdes einschließen)
2. `git add` gezielt auf die Dateien des Sprints (kein pauschales `-A`, wenn Fremdstände erkennbar sind)
3. `git commit -m "feat(sprint-N): <Sprint-Ziel in Kurzform>"` — Konvention aus vorherigen
   Sprint-Commits fortsetzen
4. `git push` zum konfigurierten Remote des Projekt-Repositories

**Hinweis:** Falls das Projekt-Repository einen anderen GitHub-Account als den zuletzt
aktiven erfordert (z. B. campaignworld → `1nf0-calypse`), vor dem Push mit `gh auth status`
prüfen und ggf. wechseln.

**Ausnahme:** Bei erkennbar sensiblen/uncommitteten Fremdständen (nicht zu diesem Sprint
gehörig) oder wenn der Nutzer im Sitzungsverlauf explizit widerspricht, pausiert MW vor
Schritt 4 (`git push`) und fragt nach.

## Nächster Schritt

Nach Abschluss (Sprint committed und gepusht):
- Optional: `/retro [projektname] [sprint-nr]` — Retrospektive mit Agile Coach
- Nächster Sprint: `/refine [projektname] [nächste-sprint-nr]`

---

**Agent:** MW (Manual Writer)
**Input:** US-NNNNNN, UX-NNNNNN, RV-NNNNNN
**Output:** `DOC-NNNNNN`, `RN-NNNNNN`, `GS-000001` (Sprint 1), Git-Commit + Push
**Template:** `toolchain/templates/` (DOC/RN aus user-story-Pattern)
**Agent-Definition:** `toolchain/agents/manual-writer-agent.md`
