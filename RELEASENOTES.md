# Release Notes — AI Development Tool Chain

Änderungsprotokoll der Tool Chain selbst (nicht projektspezifischer Artefakte).  
Projektspezifische Release Notes werden als `RN-NNN` in `projects/<name>/docs/` abgelegt.

**Pflege-Regel:** Jede strukturelle Änderung an Commands, Agenten, Templates oder Protokollen
wird hier als neuer Eintrag dokumentiert — mit Datum, beteiligten Dateien und Auswirkung.
Diese Datei wird in CLAUDE.md referenziert und ist Pflicht-Output bei Tool-Chain-Änderungen.

---

## v1.1 — 2026-06-19

### Neu

**`/impediment` — Impediment-Interview-Command**
- Neuer Slash Command für den Agile Coach (AC)
- Unterschied zu `/coach`: Kein formuliertes Problem nötig — AC führt strukturiertes
  5–6-Fragen-Interview durch (Symptom → Frequenz → Auswirkung → Umgehungen → Ziel)
- Neues Artefakt `IMPD-NNN` mit eigenem Template (`toolchain/templates/impediment.md`)
- Betroffen: `.claude/commands/impediment.md` (neu), `toolchain/agents/agile-coach-agent.md`,
  `toolchain/templates/impediment.md` (neu), `CLAUDE.md`, `toolchain/templates/INDEX.md`,
  `toolchain/agents/_base-agent.md`

**Summary-Dateien für NotebookLM-Kompatibilität**
- `.claude/commands/commands_summary.md` — Alle Commands konsolidiert in einer Datei
- `toolchain/agents/agents_summary.md` — Alle Agenten konsolidiert in einer Datei
- `toolchain/templates/templates_summary.md` — Alle Templates konsolidiert in einer Datei
- `RELEASENOTES.md` — Diese Datei (Tool-Chain-Änderungsprotokoll)
- Pflege-Regeln in `CLAUDE.md` verankert (Abschnitt "Pflege-Pflichten")

### Geändert

**Nächste-Phase-Pflicht in allen Agenten**
- Neue Sektion `Abschluss-Pflicht: Nächste Phase explizit benennen` in `_base-agent.md`
- Jeder Agent muss vor Abschluss den Projektstatus prüfen und den nächsten Slash Command
  (inkl. Projektname) als letzten Block der Chat-Antwort ausgeben — Format: `▶ **Nächste Phase:** /[command] [projektname]`
- Konkrete ABSCHLUSS-PFLICHT-Blöcke in allen Agenten-System-Prompts ergänzt:
  PM, BA, AR, UX, FE, BE, QA (beide Phasen), RV, MW, AC
- `toolchain/protocols/handoff-protocol.md`: Feld `Nächster Befehl` mit Pflicht-Hinweis versehen

---

## v1.0 — 2026-06-18

### Initiale Tool Chain

**Basis-Architektur (drei Schichten)**
- Schicht 1 — Meta: `toolchain/agents/`, `toolchain/templates/`, `toolchain/protocols/`, `toolchain/hooks/`
- Schicht 2 — Orchestrierung: `.claude/commands/`, `toolchain/workflows/`
- Schicht 3 — Projekt: `projects/`, `projects/REGISTRY.md`

**Agenten (11 Rollen)**
- ORCH (Orchestrator), PM (Product Manager), BA (Business Analyst), AR (Software Architect),
  UX (UX Designer), FE (Frontend Developer), BE (Backend Developer), QA (QA Engineer),
  RV (Code Reviewer), MW (Manual Writer), AC (Agile Coach)
- Basisregeln in `toolchain/agents/_base-agent.md` — alle Agenten erben diese

**Commands (17 Slash Commands)**
- Orchestrierung: `/status`, `/sprint`, `/hotfix`, `/spike`
- Phasen (Full Sprint): `/kickoff`, `/ba`, `/architect`, `/ux`, `/refine`, `/implement`,
  `/test-plan`, `/test-run`, `/review`, `/manual`
- Post-Sprint (AC): `/retro`, `/health-check`, `/coach`

**Templates (13 Artefakt-Templates)**
- `SB`, `REQ`, `US`, `ADR`, `UX`, `SP`, `TP`, `RV`, `DEBT`, `DECISIONS`, `RETRO`, `PC`, Branching-ADR

**Protokolle**
- Handoff-Protokoll: Verbindlicher Übergabe-Block am Ende jedes Artefakts
- Artifact-Lifecycle: DRAFT → REVIEW → APPROVED → ACTIVE → SUPERSEDED | ARCHIVED
- Gate-Protokoll: BLOCKER / MAJOR / MINOR — Eskalationsregeln

**Globale Konventionen**
- Code-Kommentierungsstandard (Datei-Header, DocStrings, TODO-Format)
- Artefakt-Benennung mit dreistelligen sequenziellen Nummern
- Ordner-Indizierung (INDEX.md in jedem Verzeichnis)
- Technologie-Agnostizität (kein Template, kein Agent setzt Technologie voraus)
