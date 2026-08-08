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
│  5. REFINEMENT                    6. IMPLEMENT     7. TEST       │
│  /refine       ────────────────▶  /implement  ──▶  /test-plan    │
│  [BA+FE+BE]                       [FE ∥ BE]        /test-run     │
│                                  [Gate 5.5 Preflight] [QA]       │
│  ──── GATE ─────────────────────  ──── GATE ────   ──── GATE ── │
└─────────────────────────────────────────────────────────────────┘
         ↓
┌─────────────────────────────────────────────────────────────────┐
│  8. REVIEW                                                       │
│  /review                                                         │
│  [RV]                                                             │
│  ──── GATE ────                                                  │
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

## Worktree-Isolation (Phase 6–9)

**Standard-Mechanismus, nicht optional** (Abweichung erfordert Begründung in
`ADR-NNNNNN-branching-strategy.md`, siehe Phase 10): Ab Betreten von Phase 6
(Implementierung) arbeiten FE/BE (und danach QA/RV/MW für denselben Sprint) auf einem
eigenen Git-Worktree statt direkt im Haupt-Checkout des Projekt-Repositories. Grund:
Ein unterbrochener Sprint (z. B. Token-Limit-Pause) hinterlässt sonst einen mehrdeutigen
Zustand im Haupt-Checkout — halb committeter Code, unklar welcher Stand tatsächlich auf
der Platte liegt. Ein isolierter Worktree macht den Sprint-Fortschritt jederzeit eindeutig
lokalisierbar und lässt den Haupt-Checkout unberührt, bis der Sprint durch Gate 8 (Review)
und Gate 9 (Dokumentation) ist.

**Geltungsbereich:** Nur Phase 6–9 des regulären Sprint-Workflows. **Nicht** für `/hotfix`
(Geschwindigkeit ist hier wichtiger als Isolation — Bedingung 2 des Hotfix-Workflows schließt
größeren Scope ohnehin aus), **nicht** für `/spike` (explizit unverbindliche Erkundung, meist
verworfen) und **nicht** für `/converge` (liest nur, schreibt keinen Code).

**Anlegen (Betreten von Phase 6, erstmalig für diesen Sprint):**

```bash
cd projects/<projektname>
git worktree add .worktrees/sprint-<N> -b feature/sprint-<N>
```

In Claude-Code-Umgebungen mit `EnterWorktree`/`ExitWorktree`-Tools: dieselbe Semantik über
diese Tools abbilden, sofern verfügbar — Fallback ist immer der reine `git worktree`-Befehl
(technologieneutral, funktioniert auch unter Codex/anderen Umgebungen). `.worktrees/` gehört
in die `.gitignore` des Projekt-Repositories (bereits in `projects/_template/.gitignore`
vorgesehen).

`.phase` wird um `worktree-path: projects/<projektname>/.worktrees/sprint-<N>` und
`worktree-branch: feature/sprint-<N>` ergänzt (siehe `orchestrator.md`).

**Wiederaufnahme (Phase 6–9 nach Unterbrechung, z. B. Token-Limit-Pause):** Bestehenden
Worktree über `worktree-path` aus `.phase` wiederbetreten — niemals neu anlegen. Vor
Fortsetzung: Statusprojektion gegenprüfen (siehe `_base-agent.md` Abschnitt "Statusnarrative
sind Projektionen" und `orchestrator.md` Sprint-Modus).

**Bei Gate 8 REJECTED** (Rollback zu PM, Scope-Problem): Worktree bleibt bestehen — wird
nicht automatisch verworfen. Ob die bereits implementierte Arbeit weiterverwendet, angepasst
oder verworfen wird, ist eine Entscheidung von PM/Nutzer nach Klärung des Scope-Problems,
keine automatische Aktion.

**Auflösen:** Siehe Phase 10 (Release) — Merge und Worktree-Cleanup erfolgen gemeinsam, erst
nachdem Gate 8 (Review) und Gate 9 (Dokumentation) bestanden sind.

---

## GitHub-Board-Sync (optional, opt-in)

**Standard-Mechanismus, sofern aktiviert** (`github.enabled: true` in `.toolchain.yml`,
siehe `toolchain/protocols/github-board-sync.md`): Sowohl ORCH im Sprint-Modus als auch
JEDER einzelne Phasen-Agent führt `github-board-sync -Mode reconcile` zu Beginn seines
eigenen Vorgehens aus (Board-Stand lesen, Konflikte mit Gate-Historie melden) und
`github-board-sync -Mode push` an dessen Ende (neue/geänderte `US`/`BUG`/`DEBT`/`IMPD`/
`EPIC`-Artefakte als Issues/Milestones anlegen/aktualisieren). Das gilt unabhängig davon,
ob die Phase über `/sprint` oder direkt (`/ba`, `/ux`, `/refine`, `/implement`,
`/test-plan`, `/test-run`, `/review`, `/manual`) aufgerufen wird — jeder dieser Commands
ist damit für den Board-Sync eigenständig funktionsfähig, ein Aufruf über ORCH ist keine
Voraussetzung. Der Sync ist idempotent: ein zusätzlicher Lauf durch ORCH im Sprint-Modus
ändert nichts, wenn der Phasen-Agent den Sync bereits selbst ausgeführt hat.

**Vorausplanung des Gesamtscopes:** `/ba` erzeugt beim ersten `push`-Lauf Milestones für
alle `EPIC-NNNNNN` und überträgt Estimate/Size/Priority/Iteration/Start-/Zieldatum für
JEDE Story im kompletten Backlog (`RM-NNNNNN`) — nicht nur für Sprint 1.

**Bugs/Tech-Schulden aus der Umsetzung:** Neue `BUG-NNNNNN` (QA in `/test-run`) und neue
`DEBT-NNNNNN` (RV in `/review`) übernehmen das `epic`-Feld der auslösenden Story, damit sie
beim Sync demselben GitHub-Milestone zugeordnet werden wie die zugehörige Story — kein
unverknüpftes Issue im Board.

**Geltungsbereich:** Alle Phasen 1–10, sofern `github.enabled`. Tool-Chain-Gates
entscheiden immer über den fachlichen Fortschritt — ein Board ist eine Ansicht, kein
zweiter Entscheider (siehe Konfliktregel im Protokoll). Fehlt `gh`, Auth oder Board:
Sync-Schritt wird übersprungen, kein Gate wird dadurch blockiert oder verzögert.

**Aktivierung:** Bei `/kickoff` fragt PM explizit nach dem Wunsch (siehe `pm-agent.md`);
bei Zustimmung provisioniert PM Board, Custom Fields und Konfiguration.

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
| `CON-000001` existiert und Status `APPROVED` | Header prüfen | BLOCKER |
| CON-000001 hat ≥ 3 Prinzipien mit Begründung | Abschnitt 2 zählen | MAJOR |
| ≥ 3 Must-Have-Features | MoSCoW-Tabelle zählen | MAJOR |
| Erfolgskriterien messbar | Abschnitt "Erfolgskriterien" hat KPIs | MAJOR |
| Übergabe-Block vorhanden | Abschnitt "Übergabe an BA" | MINOR |

**Bei PASS:** `.phase` auf `REQUIREMENTS` setzen  
**Bei FAIL:** PM-Agent-Session erneut öffnen

---

## Phase 2: Requirements

**Befehl:** `/ba`  
**Agent:** BA  
**Ergebnis:** `REQ-NNNNNN`, `US-NNNNNN` (mehrere), `EPIC-NNNNNN` (mehrere), `RM-NNNNNN`
(Roadmap — Vorausplanung des GESAMTEN Scopes)

### Gate 2 → Phase 3

| Kriterium | Prüfung | Schwere |
|---|---|---|
| `REQ-NNNNNN` status `APPROVED` | Header prüfen | BLOCKER |
| Alle Must-Have-Features haben ≥1 US | Zählen | BLOCKER |
| Jede US hat ≥3 Akzeptanzkriterien | Given/When/Then-Blöcke zählen | BLOCKER |
| `RM-NNNNNN` deckt jede Story im Gesamtscope ab (nicht nur Sprint 1) | Zeilenabgleich RM ↔ alle US | BLOCKER |
| Non-Functional Requirements dokumentiert | Abschnitt 2 in REQ | MAJOR |
| Story-Map erstellt | Abschnitt 3 in REQ | MAJOR |
| Jede Story einem Epic zugeordnet oder bewusst epic-los | Frontmatter-Feld `epic` je US | MAJOR |
| Edge Cases dokumentiert | Abschnitt 4 in REQ | MINOR |

**Bei PASS:** `.phase` auf `ARCHITECTURE` setzen. Falls `github.enabled`: erster `push`-Lauf
synchronisiert den gesamten vorausgeplanten Backlog (siehe Abschnitt "GitHub-Board-Sync").

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
**Ergebnis:** `SP-NNNNNN` (Sprint Backlog) — verfeinert die in `RM-NNNNNN` bereits
vorausgeplante Iteration (Subtasks, Ist-Aufwand), ersetzt die Grobplanung nicht

### Gate 5 → Phase 6

| Kriterium | Prüfung | Schwere |
|---|---|---|
| `SP-NNNNNN` existiert | Datei vorhanden | BLOCKER |
| Alle Sprint-Stories geschätzt | Keine leere Schätzung | BLOCKER |
| Sprint-Ziel definiert | Abschnitt im SP | MAJOR |
| Technische Voraussetzungen gelistet | Abschnitt im SP | MAJOR |
| Abweichungen zur RM-NNNNNN-Grobschätzung dokumentiert | Abschnitt "Ist-Abweichungen" in RM-NNNNNN | MINOR |
| Keine ungelösten Tech-Blocker | Selbstauskunft BA+FE+BE: SP-NNNNNN Abschnitt "Risiken & Unsicherheiten" — keine offenen Blocker-Einträge | MAJOR |

**Bei PASS:** Refinement ist bereit für `/implement`. Der explizite `/implement`-Aufruf
bestätigt eindeutige `REVIEW`-Artefakte und führt Gate 5.5 als Preflight aus.

---

## Gate 5.5: Analyse-Preflight

**Standard-Auslöser:** `/implement`
**Optionaler Diagnosebefehl:** `/analyze`
**Agent:** ORCH
**Ergebnis:** Gate-Report (kein eigenständiges Artefakt) + Eintrag in `INDEX.md` Abschnitt "Gate-History"

Cross-Artefakt-Konsistenzprüfung zwischen `REQ`/`US`, `ADR`, `UX` und `SP` — bevor Implementierungsaufwand
in eine möglicherweise widersprüchliche Spezifikation investiert wird. ORCH trifft dabei keine
fachliche Entscheidung; es prüft strukturell (`cross-ref`) und lässt sich bei inhaltlichen
Widersprüchen (`self-assertion`) von den Artefakten selbst Auskunft geben. Gefundene Widersprüche
werden **nicht** von ORCH aufgelöst, sondern an den zuständigen Agenten zurückgespielt (siehe
Rollback-Regeln).

### Gate 5.5 → Phase 6

| Kriterium | Prüfung | Schwere |
|---|---|---|
| Jede Sprint-US referenziert eine existierende REQ-ID | cross-ref: US ↔ REQ | BLOCKER |
| Jede Sprint-US im SP-NNNNNN hat eine UX-NNNNNN, sofern UI-relevant | cross-ref: SP ↔ UX | BLOCKER |
| Keine Sprint-Story widerspricht einer APPROVED ADR-Entscheidung | self-assertion: Tech-Annahmen in SP/US vs. ADR-000001ff. | BLOCKER |
| Keine Sprint-Story verletzt ein Prinzip oder einen Ausschluss aus `CON-000001` | self-assertion: SP/US vs. CON-000001 Abschnitt 2+4 | BLOCKER |
| Keine offene `BLOCKER`-Frage aus vorherigen Übergaben (PM→BA→AR→UX→Refine) unadressiert | Übergabe-Blöcke prüfen | BLOCKER |
| UX-Flows widersprechen keiner User-Story-Akzeptanzkriterien | self-assertion: UX ↔ US | MAJOR |
| Qualitäts-Mindeststandards aus `CON-000001` Abschnitt 3 sind in SP/TP-Planung berücksichtigt | self-assertion | MAJOR |

**Bei PASS:** eindeutige Refinement-Artefakte `REVIEW → APPROVED`, Freigabequelle in
`.phase` protokollieren, Sprint-Worktree anlegen beziehungsweise wiederbetreten und
`.phase` auf `IMPLEMENTATION` setzen.
**Bei FAIL:** Kein Rollback zu einer festen Phase — Zielagent hängt vom konkreten Fund ab
(REQ/US-Lücke → BA, ADR-Konflikt → AR, UX-Lücke → UX, Constitution-Konflikt → PM).
Nach Korrektur `/implement` erneut aufrufen; `/analyze` bleibt als optionaler vorgezogener
Diagnoselauf verfügbar.

---

## Phase 6: Implementierung

**Befehl:** `/implement`  
**Agenten:** BE (zuerst) → FE  
**Ergebnis:** Code + API-Kontrakt + Tests
**Voraussetzung:** Sprint-Worktree angelegt bzw. wiederbetreten (siehe Abschnitt
"Worktree-Isolation" oben) — FE/BE arbeiten ab hier bis Gate 9 auf `feature/sprint-<N>`,
nicht im Haupt-Checkout.

Vor jeder erstmaligen Implementierung führt `/implement` Gate 5.5 aus. Bei unveränderten
Eingabeartefakten darf ein bereits bestandener optionaler `/analyze`-Lauf wiederverwendet
werden; bei Änderungen wird der Preflight erneut ausgeführt.

### Gate 6 → Phase 7

| Kriterium | Prüfung | Schwere |
|---|---|---|
| API-Kontrakt existiert | OpenAPI/Schema-Datei vorhanden | BLOCKER |
| Keine Lint-Fehler | `lint`-Befehl aus `.toolchain.yml` | BLOCKER |
| Alle US-Akzeptanzkriterien umgesetzt | cross-ref: jede Sprint-US-NNNNNN hat ≥1 `// Implementiert: US-NNNNNN`-Kommentar im Code (Pflichtkommentar aus CLAUDE.md) | BLOCKER |
| Datei-Header in Code-Dateien | Stichprobe 3 Dateien | MAJOR |
| Funktions-Kommentare | Stichprobe 5 Funktionen | MAJOR |
| Unit-Tests vorhanden | Test-Dateien existieren | MAJOR |
| Keine `any`-Typen (bei TS) | Lint-Regel | MINOR |

**Bei PASS:** `.phase` auf `TESTING` setzen

---

## Phase 7: Test

**Befehle:** `/test-plan` → `/test-run`  
**Agent:** QA  
**Ergebnis:** `TP-NNNNNN`, `TR-NNNNNN`, ggf. `BUG-NNNNNN` — inklusive Browser-Clickpfade und Performanztests

### Gate 7 → Phase 8

| Kriterium | Prüfung | Schwere |
|---|---|---|
| `TP-NNNNNN` status `APPROVED` | Header prüfen | BLOCKER |
| Keine `BUG-NNNNNN` mit Schweregrad `BLOCKER` in einem Status außer `VERIFIZIERT` | BUG-Dateien: Status-Feld prüfen | BLOCKER |
| Jeder `BUG-NNNNNN` mit Schweregrad `BLOCKER`/`MAJOR` hat ausgefüllten Abschnitt "Root-Cause" (kein Platzhalter) | Abschnitt prüfen, `toolchain/templates/bug-report.md` | BLOCKER |
| Root-Cause-Abschnitt für behobene `MINOR`-Bugs ausgefüllt | Abschnitt prüfen | MAJOR |
| Automatisierte Tests: alle grün | `test`-Befehl aus `.toolchain.yml` | BLOCKER |
| `TR-NNNNNN` mit Freigabe `APPROVED` oder `CONDITIONAL` | Header prüfen | BLOCKER |
| Browser-Clickpfade im UI geprüft | TR-NNNNNN: Testmodus (headed/UI oder mit Begründung headless) dokumentiert | BLOCKER |
| Performanztests abgeschlossen | TP-NNNNNN: PERF-Zielwerte ausgefüllt (kein `[Ziel]`-Platzhalter) und TR-NNNNNN enthält gemessene Ist-Werte | BLOCKER |
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
| Sprint-Stand committed und gepusht | `git log`/`git status` im Projekt-Repository: kein offener Sprint-Diff, Remote auf aktuellem Stand | MAJOR |

**Bei PASS:** `.phase` auf `DONE` setzen, Sprint als abgeschlossen markieren. MW führt als
letzten Schritt von Phase 9 automatisch `git add`/`commit`/`push` für den Sprint-Stand im
Projekt-eigenen Repository aus (verbindlich seit `PC-000002`, campaignworld `RETRO-000002`) —
getrennt von Phase 10, die den strategischen Merge in den Ziel-Branch gemäß Branching-ADR
behandelt.

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
| GitHub-Board-Sync ausgeführt (falls `github.enabled: true`) | `github-board-sync -Mode push` lief nach dem Merge, betroffene Issues zeigen Board-Status `Done` | MAJOR |

### Release-Checkliste (ORCH führt aus)

```
0. github-board-sync -Mode reconcile         # nur falls github.enabled: true (.toolchain.yml) — Board-Stand vor dem Merge lesen, Abweichungen melden
1. git checkout <merge-target-branch>       # gemäß ADR, im Haupt-Checkout (nicht im Worktree)
2. git merge --no-ff feature/<sprint>       # kein Fast-Forward für History
3. git tag -a v<sprint> -m "Sprint N: <sprint-ziel>"
4. git push origin <merge-target-branch> --tags
5. git worktree remove projects/<projektname>/.worktrees/sprint-<N>
   git branch -d feature/sprint-<N>          # optional — nur wenn Branch-History nicht separat benötigt
6. .phase: worktree-path/worktree-branch entfernen, Phase auf RELEASED setzen
7. REGISTRY.md: Sprint-Status auf RELEASED + Datum
8. github-board-sync -Mode push              # nur falls github.enabled: true — erst NACH Schritt 6/7, damit der Sync den finalen RELEASED-Stand liest, nicht einen Zwischenstand; setzt Issues auf Board-Status `Done` (Status-Mapping, `github-board-sync.md`)
```

**Warum Schritt 0/8 hier und nicht nur in den einzelnen Phasen-Commands:** Die allgemeine
Board-Sync-Regel ("jeder Phasen-Agent synct an Anfang/Ende") deckt `/manual` (Gate 9) ab, aber
`Done` im Status-Mapping ist explizit an "nach Gate 9" geknüpft — der tatsächliche
RELEASED-Zustand (Merge+Tag+Push) entsteht erst in Phase 10 selbst, die keinen eigenen
Slash-Command hat und daher sonst übersprungen würde. Ohne Schritt 8 bleibt das Board auf dem
Zwischenstand von `/manual` stehen, auch wenn der Code längst gemergt ist — in der Praxis
beobachtet (campaignworld Sprint 17+18, Board zeigte nach `/manual` weiterhin `In Review`).

**Hinweis:** Cherry-Picking (selektive Commit-Übernahme) ist eine Ausnahme-Operation
und erfordert explizite Nutzeranweisung mit Begründung — kein automatischer Schritt.

**Hinweis (Bestätigungspflicht):** Schritt 4 (`git push`) sowie Schritt 5 (Worktree-/Branch-
Entfernung) sind schreibend gegen geteilten bzw. schwer reversiblen Zustand — ORCH führt diese
konkreten Schritte nicht ohne explizite Nutzerbestätigung im Sitzungsverlauf aus, auch wenn
Gate 10 vollständig PASS ist. Schritte 1–3 (lokaler Merge, Tag) sowie 6–7 (Metadaten) sind
unkritisch und erfordern keine gesonderte Bestätigung. Schritt 8 (`push`-Modus) schreibt gegen
GitHub (externer, geteilter Zustand) — dieselbe Bestätigungspflicht wie Schritt 4 gilt daher
auch hier, auch wenn es sich technisch nur um Issue-Metadaten statt Code handelt.

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
| Gate 5.5 | Phase 2 / 3 / 4 / 1 (je nach Fund) | BA (REQ/US-Lücke) / AR (ADR-Konflikt) / UX (UX-Lücke) / PM (Constitution-Konflikt) |
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
