# /sprint — Vollständigen Sprint orchestrieren

Aktiviert den **Orchestrator** im Sprint-Modus. Führt automatisch den gesamten Sprint-Zyklus durch: Phase für Phase, Gate für Gate.

## Verwendung

```
/sprint [projektname] [sprint-nummer]
/sprint mein-projekt 1
```

## Was passiert

Der Orchestrator liest den aktuellen Projektzustand und orchestriert den Rest des Sprints automatisch:

```
Aktueller Stand → Gate prüfen → Agent aktivieren → Artefakt warten →
Gate prüfen → [PASS] nächste Phase | [FAIL] Stop + Bericht
```

Phasen-Sequenz (Full Sprint):
1. Discovery (`/kickoff`) → Gate → SB approved?
2. Requirements (`/ba`) → Gate → REQ + US approved?
3. Architecture (`/architect`) → Gate → ADR-001 approved?
4. UX (`/ux`) → Gate → UX-Specs vollständig?
5. Refinement (`/refine`) → Gate → Sprint-Backlog ready?
6. Implementation (`/implement`) → Gate → Code + Tests?
7. Test (`/test-plan` + `/test-run`) → Gate → Keine Blocker-Bugs?
8. Review (`/review`) → Gate → APPROVED?

## Gate-Verhalten

- `BLOCKER` → Hard-Stop, Nutzer-Entscheidung
- `MAJOR` → Warnung + Bestätigung erforderlich
- `MINOR` → Weiter, als TODO in nächste Phase übernehmen

## Einstiegspunkt

Der Orchestrator erkennt automatisch wo der Sprint gerade steht (aus `.phase`) und setzt dort an. Kein manueller Einstiegspunkt nötig.

---

**Agent:** ORCH (Orchestrator) — Sprint-Modus
**Workflow:** `toolchain/workflows/full-sprint.md`
**Agent-Definition:** `toolchain/agents/orchestrator.md`
