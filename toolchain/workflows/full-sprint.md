---
id: WF-FULL-SPRINT
title: Vollständiger Sprint-Zyklus
version: 1.0
status: ACTIVE
---

# Workflow: Full Sprint

Der Standard-Workflow für einen vollständigen Entwicklungssprint — von Discovery bis Merge.

## Aktivierung

```
/sprint [projektname] [sprint-nummer]
```

## Phasen-Sequenz

```
┌─────────────────────────────────────────────────────────────────┐
│  1. DISCOVERY    2. REQUIREMENTS   3. ARCHITECTURE   4. UX      │
│  /kickoff   ──▶  /ba         ──▶  /architect    ──▶  /ux        │
│  [PM]            [BA]             [AR]               [UX]       │
│  ──── GATE ────  ──── GATE ────   ──── GATE ────  ──── GATE ── │
└─────────────────────────────────────────────────────────────────┘
         ↓
┌─────────────────────────────────────────────────────────────────┐
│  5. REFINEMENT   6. IMPLEMENT     7. TEST         8. REVIEW     │
│  /refine    ──▶  /implement  ──▶  /test-plan ──▶  /review       │
│  [BA+FE+BE]      [FE ∥ BE]        /test-run        [RV]         │
│                                   [QA]                          │
│  ──── GATE ────  ──── GATE ────   ──── GATE ────  ──── GATE ── │
└─────────────────────────────────────────────────────────────────┘
         ↓
┌─────────────────────────────────────────────────────────────────┐
│  9. DOCUMENTATION                                               │
│  /manual                                                        │
│  [MW]                                                           │
│  ──── GATE ──── → DONE                                          │
└─────────────────────────────────────────────────────────────────┘
```

---

## Phase 1: Discovery

**Befehl:** `/kickoff`  
**Agent:** PM  
**Ergebnis:** `SB-NNNNNN`

### Gate 1 → Phase 2

| Kriterium | Prüfung | Schwere |
|---|---|---|
| `SB-NNNNNN` existiert | Datei vorhanden | BLOCKER |
| Status `APPROVED` | Header-Feld `status: APPROVED` | BLOCKER |
| Scope definiert | Abschnitt "In Scope" und "Out of Scope" ausgefüllt | BLOCKER |
| ≥ 3 Must-Have-Features | MoSCoW-Tabelle zählen | MAJOR |
| Erfolgskriterien messbar | Abschnitt "Erfolgskriterien" hat KPIs | MAJOR |
| Übergabe-Block vorhanden | Abschnitt "Übergabe an BA" | MINOR |

**Bei PASS:** `.phase` auf `REQUIREMENTS` setzen  
**Bei FAIL:** PM-Agent-Session erneut öffnen

---

## Phase 2: Requirements

**Befehl:** `/ba`  
**Agent:** BA  
**Ergebnis:** `REQ-NNNNNN`, `US-NNNNNN` (mehrere)

### Gate 2 → Phase 3

| Kriterium | Prüfung | Schwere |
|---|---|---|
| `REQ-NNNNNN` status `APPROVED` | Header prüfen | BLOCKER |
| Alle Must-Have-Features haben ≥1 US | Zählen | BLOCKER |
| Jede US hat ≥3 Akzeptanzkriterien | Given/When/Then-Blöcke zählen | BLOCKER |
| Non-Functional Requirements dokumentiert | Abschnitt 2 in REQ | MAJOR |
| Story-Map erstellt | Abschnitt 3 in REQ | MAJOR |
| Edge Cases dokumentiert | Abschnitt 4 in REQ | MINOR |

**Bei PASS:** `.phase` auf `ARCHITECTURE` setzen

---

## Phase 3: Architektur

**Befehl:** `/architect`  
**Agent:** AR  
**Ergebnis:** `ADR-000001` (Tech-Stack), weitere ADRs, `STRUCTURE.md`

### Gate 3 → Phase 4

| Kriterium | Prüfung | Schwere |
|---|---|---|
| `ADR-000001` status `APPROVED` | Header prüfen | BLOCKER |
| Alle NFRs aus REQ adressiert | Kreuzreferenz REQ ↔ ADRs | BLOCKER |
| `STRUCTURE.md` existiert | Datei vorhanden | BLOCKER |
| Systemdesign-Diagramm | In ADR-000001 oder eigenem Dok | MAJOR |
| Jeder ADR hat Alternativen-Sektion | Abschnitt prüfen | MAJOR |
| Reversibilität dokumentiert | Checkbox in ADR | MINOR |

**Bei PASS:** `.phase` auf `UX` setzen

---

## Phase 4: UX Design

**Befehl:** `/ux`  
**Agent:** UX  
**Ergebnis:** `UX-NNNNNN` pro Feature-Bereich

### Gate 4 → Phase 5

| Kriterium | Prüfung | Schwere |
|---|---|---|
| `UX-NNNNNN` für alle Sprint-Stories | Kreuzreferenz US ↔ UX | BLOCKER |
| Alle UI-Zustände beschrieben | loading, error, empty, success | BLOCKER |
| Accessibility-Level definiert | WCAG-Angabe in UX | MAJOR |
| Microcopy vollständig | Alle User-facing Texte | MAJOR |
| Edge Cases / Fehlerflüsse | Mindestens 1 pro Journey | MAJOR |
| Responsive-Strategie | Falls Web-Produkt | MINOR |

**Bei PASS:** `.phase` auf `REFINEMENT` setzen

---

## Phase 5: Refinement

**Befehl:** `/refine`  
**Agenten:** BA + FE + BE  
**Ergebnis:** `SP-NNNNNN` (Sprint Backlog)

### Gate 5 → Phase 6

| Kriterium | Prüfung | Schwere |
|---|---|---|
| `SP-NNNNNN` existiert | Datei vorhanden | BLOCKER |
| Alle Sprint-Stories geschätzt | Keine leere Schätzung | BLOCKER |
| Sprint-Ziel definiert | Abschnitt im SP | MAJOR |
| Technische Voraussetzungen gelistet | Abschnitt im SP | MAJOR |
| Keine ungelösten Tech-Blocker | Prüfen | MAJOR |

**Bei PASS:** `.phase` auf `IMPLEMENTATION` setzen

---

## Phase 6: Implementierung

**Befehl:** `/implement`  
**Agenten:** BE (zuerst) → FE  
**Ergebnis:** Code + API-Kontrakt + Tests

### Gate 6 → Phase 7

| Kriterium | Prüfung | Schwere |
|---|---|---|
| API-Kontrakt existiert | OpenAPI/Schema-Datei vorhanden | BLOCKER |
| Keine Lint-Fehler | `lint`-Befehl aus `.toolchain.yml` | BLOCKER |
| Alle US-Akzeptanzkriterien umgesetzt | Selbstauskunft FE+BE | BLOCKER |
| Datei-Header in Code-Dateien | Stichprobe 3 Dateien | MAJOR |
| Funktions-Kommentare | Stichprobe 5 Funktionen | MAJOR |
| Unit-Tests vorhanden | Test-Dateien existieren | MAJOR |
| Keine `any`-Typen (bei TS) | Lint-Regel | MINOR |

**Bei PASS:** `.phase` auf `TESTING` setzen

---

## Phase 7: Test

**Befehle:** `/test-plan` → `/test-run`  
**Agent:** QA  
**Ergebnis:** `TP-NNNNNN`, `TR-NNNNNN`, ggf. `BUG-NNNNNN`

### Gate 7 → Phase 8

| Kriterium | Prüfung | Schwere |
|---|---|---|
| `TP-NNNNNN` status `APPROVED` | Header prüfen | BLOCKER |
| Keine offenen `BLOCKER`-Bugs | BUG-Dateien prüfen | BLOCKER |
| Automatisierte Tests: alle grün | `test`-Befehl aus `.toolchain.yml` | BLOCKER |
| `TR-NNNNNN` mit Freigabe `APPROVED` oder `CONDITIONAL` | Header prüfen | BLOCKER |
| Coverage-Ziel erreicht | Coverage-Report prüfen | MAJOR |
| P0-Testfälle alle `✅ Bestanden` | TP-Tabelle prüfen | MAJOR |

**Bei PASS:** `.phase` auf `REVIEW` setzen

---

## Phase 8: Review

**Befehl:** `/review`  
**Agent:** RV  
**Ergebnis:** `RV-NNNNNN` mit Merge-Entscheidung

### Gate 8 → DONE

| Kriterium | Prüfung | Schwere |
|---|---|---|
| `RV-NNNNNN` status `APPROVED` | Header prüfen | BLOCKER |
| Entscheidung: `APPROVED` | Review-Entscheidungsfeld | BLOCKER |
| Keine `BLOCKER`-Anmerkungen | Review-Bericht | BLOCKER |
| Technische Schulden erfasst | DEBT-NNNNNN erstellt oder explizit "keine" | MAJOR |

**Bei PASS:** `.phase` auf `DOCUMENTATION` setzen

---

## Phase 9: Dokumentation

**Befehl:** `/manual`  
**Agent:** MW (Manual Writer)  
**Ergebnis:** `DOC-NNNNNN` (Feature-Guides), `RN-NNNNNN` (Release Notes), `GS-000001` (erster Sprint)

### Gate 9 → DONE

| Kriterium | Prüfung | Schwere |
|---|---|---|
| `DOC-NNNNNN` für alle APPROVED US | Kreuzreferenz RV-NNNNNN ↔ DOC | BLOCKER |
| `RN-NNNNNN` existiert | Datei vorhanden | BLOCKER |
| Kein Entwicklerjargon ohne Erklärung | Selbstauskunft MW | MAJOR |
| Jede Anleitung hat Happy Path + ≥1 Fehlerfall | Inhaltsprüfung | MAJOR |
| Screenshot-Platzhalter gesetzt | `[SCREENSHOT: ...]`-Marker | MINOR |
| `DECISIONS.md` aktualisiert | Neue Einträge wenn Terminologieentscheid | MINOR |
| `docs/INDEX.md` aktualisiert | Datei vorhanden und vollständig | MINOR |

**Bei PASS:** `.phase` auf `DONE` setzen, Sprint als abgeschlossen markieren

---

## Phase 10: Release

**Befehl:** Automatisch nach Gate 9 durch ORCH (kein eigener Slash Command)  
**Agent:** ORCH  
**Ergebnis:** Release-Tag, aktualisiertes `.phase`

Diese Phase führt den Code-Merge gemäß der im Projekt festgelegten Branching-Strategie durch.
Die Strategie ist verbindlich in `ADR-NNNNNN-branching-strategy.md` dokumentiert — ORCH entscheidet
nichts Strategisches, sondern führt das vereinbarte Protokoll aus.

### Gate 10 → RELEASED

| Kriterium | Prüfung | Schwere |
|---|---|---|
| Branching-Strategie in ADR vorhanden | `ADR-NNNNNN-branching-strategy.md` status `APPROVED` | BLOCKER |
| Merge-Ziel-Branch korrekt | Gemäß ADR: main / develop / release/x.y | BLOCKER |
| Git-Tag gesetzt | `vSPRINT-N` oder semver gemäß ADR | BLOCKER |
| `REGISTRY.md` aktualisiert | Sprint als RELEASED markiert | MAJOR |
| Release Notes verlinkt | `RN-NNNNNN` in REGISTRY-Eintrag | MAJOR |
| `.phase` auf `RELEASED` gesetzt | Header prüfen | MAJOR |

### Release-Checkliste (ORCH führt aus)

```
1. git checkout <merge-target-branch>       # gemäß ADR
2. git merge --no-ff feature/<sprint>       # kein Fast-Forward für History
3. git tag -a v<sprint> -m "Sprint N: <sprint-ziel>"
4. git push origin <merge-target-branch> --tags
5. .phase auf RELEASED setzen
6. REGISTRY.md: Sprint-Status auf RELEASED + Datum
```

**Hinweis:** Cherry-Picking (selektive Commit-Übernahme) ist eine Ausnahme-Operation
und erfordert explizite Nutzeranweisung mit Begründung — kein automatischer Schritt.

**Bei PASS:** Sprint vollständig abgeschlossen (`RELEASED`)  
**Bei FAIL (kein ADR):** Hard-Stop → `/architect` zur Branching-Entscheidung

---

## Rollback-Regeln

| Gate-Fehlschlag | Rollback-Ziel | Wer wird aktiviert |
|---|---|---|
| Gate 1 | Phase 1 | PM |
| Gate 2 | Phase 1 oder 2 | PM (falls Stakeholder-Frage) / BA |
| Gate 3 | Phase 2 oder 3 | BA (falls Req-Problem) / AR |
| Gate 4 | Phase 3 oder 4 | AR (falls Constraint) / UX |
| Gate 5 | Phase 3 | AR (falls Tech-Blocker) |
| Gate 6 | Phase 6 | FE/BE (Korrekturen) |
| Gate 7 | Phase 6 | FE/BE (Bug-Fixes) |
| Gate 8 (REQUEST CHANGES) | Phase 6 | FE/BE (Korrekturen) |
| Gate 8 (REJECTED) | Phase 1 | PM (Scope-Problem) |
| Gate 9 | Phase 9 | MW (Dokumentation vervollständigen) |

---

## Sprint-Abschluss-Checkliste

Nach erfolgreichem Release (Phase 10):
- [ ] `.phase` auf `RELEASED` gesetzt
- [ ] `REGISTRY.md` aktualisiert (Sprint als RELEASED markiert)
- [ ] Technische Schulden in `DEBT-NNNNNN` dokumentiert
- [ ] Abgelöste Artefakte auf `SUPERSEDED` gesetzt
- [ ] Release-Tag in Git gesetzt und gepusht
- [ ] Nächster Sprint: `/refine` vorbereiten
- [ ] Optional: `/retro` — Sprint-Retrospektive mit AC-Agent durchführen
