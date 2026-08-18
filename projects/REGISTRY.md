# Projekt-Registry

Zentrale Übersicht aller Projekte, die die AI Development Tool Chain verwenden.

Letzte Aktualisierung: 2026-08-18

## Aktive Projekte

| Projekt | Phase | Sprint | Letzter Agent | Letztes Update | Pfad |
|---------|-------|--------|--------------|----------------|------|
| second-brain | RELEASED — Sprint 4: kontrollierte Ein-Datei-Notizänderungen mit Vorschau, Bestätigung, Konfliktschutz und Rollback als `v0.4.0` veröffentlicht | 4 | ORCH | 2026-08-12 | `projects/second-brain/` |
| campaignworld | DONE (Sprint 27) — `BUG-000027` (fehlende Rollenprüfung Feld-/Relationstyp-Schreibpfade, behoben+verifiziert), weltweite Feld-/Relationstyp-Verwaltung + Kampagnen-Opt-out (`US-000068`), In-App-Hilfebereich (`US-000069`), In-App-Entwicklerbereich (`US-000070`) ausgeliefert; `RV-000023` APPROVED (Nutzerabnahme aller drei Stories ACCEPTED, technisches Review ohne BLOCKER/MAJOR/MINOR). `DOC-000010` v1.3, `DOC-000022` v1.1, zwei neue Guides `DOC-000031`/`032`, `RN-000021`, `FAQ-000001` v2.6 erstellt (`/manual`). Voller E2E-Lauf + isolierter Nachlauf (`TR-000023`) klassifizieren alle Fehlschläge außerhalb der drei neuen Specs als Sandbox-Ressourcenkontention. Ad-hoc `/impediment`-Läufe während `/implement`/`/test-run` (`IMPD-000004`/`PC-000010` Doppellauf-Vermeidung, `IMPD-000005`/`PC-000011` Playwright-Fortschrittsmeldung) toolchain-weit umgesetzt. Vorheriger Stand (Sprint 26, DONE 2026-08-18): Sichtbarkeit für einzelne Felder (US-000043), Wer darf Kampagnen anlegen (US-000044) ausgeliefert; `RV-000022` v1.1 APPROVED nach Fix-Zyklus zu S-001. **`BUG-000025`** (Optimistic-Locking-Regression, BLOCKER) läuft weiterhin als unabhängiger Hotfix-Strang außerhalb aller Sprint-Abschlüsse (`D-000086`). `BUG-000026` (MINOR, Testcode-Defekt `response.ok()`-Muster) auf v1.1 — Muster zusätzlich in `role-matrix.spec.ts` bestätigt, weiterhin nicht freigabekritisch. **Zwei weitere unabhängige parallele Stränge (eigene Sessions, kein Eingriff in obigen Stand):** (1) `SB-000003`-Multi-Perspektiven-Ausbau vollständig durch Discovery→BA→Architect→UX→Refine geführt — 16 neue Stories (US-000051–066, Epic 10), ADR-000027/028/029 (REVIEW), UX-000014–016 (APPROVED), vier neue Sprint-Backlogs SP-000021–024 (~76/63/42/39 SP); noch nicht implementiert. (2) Direkter Nutzerauftrag: `US-000067` (BYOK-API-Keys, Superadmin-Exklusivität, MCP-Guide) durch BA→Architect→UX→Refine geführt — ADR-000030 + UX-000017 (beide APPROVED), SP-000025 (~21 SP, REVIEW); noch nicht implementiert | 27 | MW | 2026-08-18 | `projects/campaignworld/` |
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
