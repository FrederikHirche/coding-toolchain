# Projekt-Registry

Zentrale Übersicht aller Projekte, die die AI Development Tool Chain verwenden.

Letzte Aktualisierung: 2026-07-30

## Aktive Projekte

| Projekt | Phase | Sprint | Letzter Agent | Letztes Update | Pfad |
|---------|-------|--------|--------------|----------------|------|
| second-brain | REQUIREMENTS — Discovery Gate 1 bestanden, nächster Schritt `/ba` | 1 | PM | 2026-07-30 | `projects/second-brain/` |
| campaignworld | TESTING (Sprint 9, test-run) abgeschlossen — APPROVED, nächster Schritt `/review` | 9 | QA | 2026-07-30 | `projects/campaignworld/` |
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
