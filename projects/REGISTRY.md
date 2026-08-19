# Projekt-Registry

Zentrale Übersicht aller Projekte, die die AI Development Tool Chain verwenden.

Letzte Aktualisierung: 2026-08-19

## Aktive Projekte

| Projekt | Phase | Sprint | Letzter Agent | Letztes Update | Pfad |
|---------|-------|--------|--------------|----------------|------|
| second-brain | RELEASED — Sprint 4: kontrollierte Ein-Datei-Notizänderungen mit Vorschau, Bestätigung, Konfliktschutz und Rollback als `v0.4.0` veröffentlicht | 4 | ORCH | 2026-08-12 | `projects/second-brain/` |
| campaignworld | DONE (Sprint 28) — `BUG-000025` (Optimistic-Locking-Race, BLOCKER, seit Sprint 20 offen, jetzt Root-Cause bestätigt + behoben + verifiziert über alle sieben betroffenen Repository-Call-Sites), `BUG-000026` (`response.ok()`-Testcode-Defekt, MINOR, VERIFIZIERT v1.4), GM-Digest-Recap (`US-000051`), personalisierter Spieler-Recap (`US-000052`), kampagnenweiter Mitleser-Rückblick (`US-000053`), Neuigkeiten-Feed für Mitleser (`US-000054`), Bring-your-own-API-Key/Superadmin-Exklusivität/MCP-Guide (`US-000067`) ausgeliefert; `RV-000024` APPROVED (Nutzerabnahme aller 7 Punkte ACCEPTED ohne Anmerkung, technisches Review 1 MAJOR [`DEBT-000037`, ADR-000030-Fail-fast-Lücke bei `PROVIDER_KEY_ENCRYPTION_KEY`] + 1 MINOR [sequenzielle Recap-Aggregation] + 1 SUGGESTION, kein BLOCKER). Drei neue Guides `DOC-000033` (gemeinsamer Recap-Guide für alle drei Varianten), `DOC-000034` (Neuigkeiten-Feed), `DOC-000035` (Eigene KI-API-Keys/Superadmin/MCP-Verweis), `DOC-000022` v1.2, `RN-000022`, `FAQ-000001` v2.7 erstellt (`/manual`). Voller E2E-Lauf erlitt einen echten Dev-Server-Absturz (`TR-000024` Abschnitt 3.1, über die übliche Sandbox-Ressourcenkontention hinausgehend) — durch vollständige gezielte Isolationsläufe für alle 126 Testfälle trotzdem reales Pass/Fail-Signal; drei neue MINOR-Testcode-Defekte (`BUG-000028`–`030`), kein Produktbug. Vorheriger Stand (Sprint 27, DONE 2026-08-18): `BUG-000027` behoben, weltweite Feld-/Relationstyp-Verwaltung + Kampagnen-Opt-out (`US-000068`), In-App-Hilfebereich (`US-000069`), In-App-Entwicklerbereich (`US-000070`) ausgeliefert. **Ein unabhängiger, paralleler Strang (eigene Session, kein Eingriff in obigen Stand):** `US-000071` (Mermaid-Diagramme für Entitäten, direkter Nutzerauftrag) durch Requirements→Architect→UX→Refine geführt — `ADR-000033` + `UX-000020` (beide APPROVED), `SP-000029` (~38 SP, REVIEW); noch nicht implementiert | 28 | MW | 2026-08-19 | `projects/campaignworld/` |
| stellaris-mcp | DISCOVERY | 1 | PM | 2026-07-23 | `projects/stellaris-mcp/` |

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
