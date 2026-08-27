# Projekt-Registry

Zentrale Übersicht aller Projekte, die die AI Development Tool Chain verwenden.

Letzte Aktualisierung: 2026-08-21

## Aktive Projekte

| Projekt | Phase | Sprint | Letzter Agent | Letztes Update | Pfad |
|---------|-------|--------|--------------|----------------|------|
| second-brain | DONE — Sprint 8: lokaler read-only Graph mit vollständiger Relationship-Liste, Quellenfundstellen und Offline-Hinweisen dokumentiert | 8 | MW | 2026-08-20 | `projects/second-brain/` |
| campaignworld | REFINEMENT (Sprint 30) — `SP-000022`/Sprint 30 (SB-000003-Strang reaktiviert: `US-000056`–`059` Antwort-Provenienz/Content-Provenance/Konsistenz-Scan/Ablehnungsgründe, ~63 SP), `ADR-000027`/`028` per explizitem Nutzer-Sign-off auf APPROVED gehoben, REVIEW, startbereit für `/implement`. Vorheriger Stand (Sprint 29, DONE 2026-08-27): `US-000071` (Mermaid-Diagramm-Fähigkeit: eigene, frei eingegebene Diagramme pro Entität UND automatisch generiertes, sichtbarkeitsgefiltertes, klickbares Beziehungsdiagramm) ausgeliefert; `RV-000025` APPROVED (Nutzerabnahme aller 3 Feature-Bereiche ACCEPTED, technisches Review kein BLOCKER, 1 MAJOR [`DEBT-000038`, fehlender echter `mermaid.render()`-Test für den a11y-Pass] + mehrere MINOR/SUGGESTION, als Debt vorgemerkt statt Merge-Blocker). Während `/review` entdeckt+behoben: `feature/sprint-29` war nie nach `master` gemergt (Merge-Commit `7ee5ae1`), Container-Build-Fix (`PROVIDER_KEY_ENCRYPTION_KEY` als Docker-Build-Arg), `TR-000025` v4.0 REJECTED → v5.0 CONDITIONAL konsolidiert (`BUG-000032`–`036` alle `VERIFIZIERT`). Neuer Guide `DOC-000036` (Mermaid-Diagramme), `RN-000023` erstellt (`/manual`). Vorheriger Stand (Sprint 28, DONE 2026-08-19): `BUG-000025` (Optimistic-Locking-Race, BLOCKER, seit Sprint 20 offen, jetzt Root-Cause bestätigt + behoben + verifiziert über alle sieben betroffenen Repository-Call-Sites), `BUG-000026` (`response.ok()`-Testcode-Defekt, MINOR, VERIFIZIERT v1.4), GM-Digest-Recap (`US-000051`), personalisierter Spieler-Recap (`US-000052`), kampagnenweiter Mitleser-Rückblick (`US-000053`), Neuigkeiten-Feed für Mitleser (`US-000054`), Bring-your-own-API-Key/Superadmin-Exklusivität/MCP-Guide (`US-000067`) ausgeliefert; `RV-000024` APPROVED. Drei neue Guides `DOC-000033`–`035`, `RN-000022`, `FAQ-000001` v2.7 erstellt (`/manual`). Vorheriger Stand (Sprint 27, DONE 2026-08-18): `BUG-000027` behoben, weltweite Feld-/Relationstyp-Verwaltung + Kampagnen-Opt-out (`US-000068`), In-App-Hilfebereich (`US-000069`), In-App-Entwicklerbereich (`US-000070`) ausgeliefert | 30 | BA | 2026-08-27 | `projects/campaignworld/` |
| stellaris-mcp | DISCOVERY | 1 | PM | 2026-07-23 | `projects/stellaris-mcp/` |
| .openclaw | INIT — Scaffold aus `_template` angelegt (`.toolchain.yml`, `.phase`, `INDEX.md`, Unterordner, eigenes Git-Repo + Hooks); Ordner enthielt bereits Laufzeitdaten (`state/openclaw.sqlite*`, `tui/last-session.json`, leere `crestodian/sessions`+`workspace`) ohne Quellcode — `/kickoff` steht noch aus | 0 | — | 2026-08-21 | `projects/.openclaw/` |

## Abgeschlossene Projekte

| Projekt | Sprints | Abgeschlossen | Pfad |
|---------|---------|--------------|------|
| _(noch keine)_ | — | — | — |

## Pausierte / Abgebrochene Projekte

| Projekt | Letzte Phase | Pausiert seit | Grund | Pfad |
|---------|-------------|--------------|-------|------|
| campaignworld *(v1, siehe unten)* | TESTING (Sprint 3) abgeschlossen — Übergang zu REVIEW nicht vollzogen: der anschließende `/review`-Aufruf brach mit einem Server-Hänger ab, die REVIEW-Phase wurde nie erreicht | 2026-07-19 | Vom Stakeholder auf direkten Userbefehl vollständig gelöscht (kein Backup, kein Remote) — wiederholte Performance-/Stabilitätsprobleme über mehrere Sprints trotz Fixversuchen (siehe TR-000001/002/004/005/006, DEBT-000017). Vorgeschichte: Sprint 2.5 wurde nach Freigabe von US-000031 in REVIEW abgeschlossen (2026-07-18); Sprint 3 durchlief anschließend regulär TESTING, wo ein Dashboard-Routing-Bug (`ENTITY_TYPE_REGISTRY`) gefunden wurde, bevor der `/review`-Aufruf mit dem oben genannten Server-Hänger scheiterte. Stakeholder bewertete dies als strukturelles statt punktuelles Risiko. **Hinweis (2026-07-20):** Projektname wurde für einen eigenständigen Neuanlauf wiederverwendet, siehe Eintrag in „Aktive Projekte" oben — kein Zusammenhang mit diesem gelöschten Artefaktbestand, Nummerierung beginnt neu bei SB-000001. | `projects/campaignworld/` (Ordnerinhalt vollständig gelöscht, 2026-07-19; Pfad seit 2026-07-20 mit neuem, eigenständigem Projektanlauf belegt) |

---

## Neues Projekt registrieren

Wenn `/kickoff` ein neues Projekt anlegt, wird diese Datei automatisch aktualisiert:

```markdown
| mein-projekt | DISCOVERY | 1 | PM | 2026-06-18 | `projects/mein-projekt/` |
```

## Phasen-Referenz

```
INIT → DISCOVERY → REQUIREMENTS → ARCHITECTURE → UX →
REFINEMENT → IMPLEMENTATION → TESTING → REVIEW → DOCUMENTATION → DONE → RELEASED

DONE = Sprint inhaltlich abgeschlossen, noch nicht gemerged/getaggt.
RELEASED = Gemerged und getaggt (Phase 10 abgeschlossen) — danach beginnt der nächste
Sprint wieder bei REFINEMENT.

Sonder-Phasen: HOTFIX-* | SPIKE
```
