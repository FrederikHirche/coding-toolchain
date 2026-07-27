# Release Notes — AI Development Tool Chain

Änderungsprotokoll der Tool Chain selbst (nicht projektspezifischer Artefakte).  
Projektspezifische Release Notes werden als `RN-NNNNNN` in `projects/<name>/docs/` abgelegt.

**Pflege-Regel:** Jede strukturelle Änderung an Commands, Agenten, Templates oder Protokollen
wird hier als neuer Eintrag dokumentiert — mit Datum, beteiligten Dateien und Auswirkung.
Diese Datei wird in CLAUDE.md referenziert und ist Pflicht-Output bei Tool-Chain-Änderungen.

---

## v2.6 — 2026-07-27

### Geändert

**Automatische Codebase-Memory-Graph-Aktualisierung am Ende von `/implement`**
- `toolchain/agents/backend-agent.md` (v1.3): Neuer VORGEHEN-Schritt 8 — `index_repository`
  (`mode='fast'`) gegen den Projektpfad ausführen, aber nur wenn kein anschließender FE-Schritt
  folgt (BE-Solo-Modus bzw. FE bereits fertig), um einen doppelten Lauf zu vermeiden.
- `toolchain/agents/frontend-agent.md` (v1.1): Neuer VORGEHEN-Schritt 7 — dieselbe
  Graph-Aktualisierung, da FE üblicherweise der letzte Schritt vor `/test-plan`/`/review` ist.
- `.claude/commands/implement.md`: Beide Modi ("Was passiert (BE-Modus)"/"(FE-Modus)") um den
  neuen Schritt ergänzt.
- `toolchain/agents/agents_summary.md`, `.claude/commands/commands_summary.md`: FE-/BE-
  Abschnitte nachgezogen.
- Auswirkung: Der Codebase-Memory-Graph (siehe CLAUDE.md „Codebase-Intelligenz") bleibt
  innerhalb desselben Sprints aktuell für `/test-plan`, `/review` und `/converge`, statt erst
  bei der nächsten manuellen Indizierung nachzuziehen. Ausgelöst durch eine Beobachtung im
  campaignworld-Projekt: der Graph war nach einem umfangreichen `/implement`-Lauf gegenüber dem
  Arbeitsstand veraltet (zeigte noch den letzten Commit, nicht die neuen unkommittierten
  Dateien). Kein neuer Command — bewusst als Hook in den bestehenden Agenten-Ablauf integriert,
  nicht als separates `/reindex`-Kommando.

---

## v2.5 — 2026-07-25

### Neu

**CI-Build-Empfehlung für Container-Projekte — `docker/github-builder`**
- `toolchain/agents/architect-agent.md`: Container-Prinzip um eine CI-Build-Empfehlung
  ergänzt — bei Containerisierung + GitHub Actions als CI-Plattform soll der AR-Agent die
  wiederverwendbaren Workflows aus [docker/github-builder](https://github.com/docker/github-builder)
  (`build.yml`/`bake.yml`) als Standardoption im ADR erwägen, statt Build-/Cache-/Multi-
  Platform-Logik pro Repository selbst zu bauen. Begründung: signierte/verifizierte
  GitHub-Actions-Cache-Einträge, native Multi-Platform-Parallelisierung, SLSA-Provenance
  via GitHub-OIDC, Keyless-Registry-Auth (Docker Hub/ECR/GAR) ohne gespeicherte Credentials.
  Abweichung (eigener buildx-Workflow) bleibt zulässig, ist aber im ADR zu begründen.
- `toolchain/agents/backend-agent.md`: Container-Checkliste um einen Punkt ergänzt — falls
  ADR-000001 `docker/github-builder` vorsieht, lokal gegen dieselbe Bake-/Dockerfile-
  Definition testen, die der CI-Workflow verwendet (keine abweichende lokale Build-Logik).
- `CLAUDE.md`: Referenzen-Tabelle um `docker/github-builder` ergänzt.
- `toolchain/agents/agents_summary.md`: AR- und BE-Abschnitte nachgezogen.
- Auswirkung: Rein empfehlender Charakter, kein neuer Agent, kein neuer Command. Nur
  relevant, wenn ein Projekt-ADR Containerisierung + GitHub Actions vorsieht; andernfalls
  keine Auswirkung auf bestehende Projekte.

---

## v2.4 — 2026-07-24

### Neu

**Statusprojektion-Gegenprüfung — "In Bearbeitung"-Prosa ist keine Quelle der Wahrheit**
- `toolchain/agents/_base-agent.md`: neue Pflichtregel "Statusnarrative sind Projektionen,
  keine Quelle der Wahrheit" — Freitext-Statusabschnitte in INDEX.md (z. B. "In Bearbeitung")
  gelten als ungeprüfte Behauptung, nicht als Fakt. Bevor ein Agent auf einer solchen
  Behauptung aufbaut, muss er die konkret prüfbaren Teile (Commit-Status, Datei-Existenz,
  DoD-Checkbox-Zustand) gegen Primärevidenz (`git log`/`git status`, Dateien, US-Checkboxen)
  gegenprüfen und Abweichungen korrigieren statt stillschweigend zu übernehmen. Explizite
  Ausnahme für read-only-deklarierte Modi (`/status`): dort wird die Abweichung nur gemeldet,
  nicht selbst korrigiert.
- Auslöser: `GAP-000001` (Converge-Lauf gegen `projects/campaignworld/`) fand INDEX.md mit
  einer faktisch falschen Behauptung zum Commit-Status vor, die unwidersprochen über mehrere
  Tage stehen geblieben war — bis dahin gab es keine Regel, die eine Gegenprüfung verlangte.
- `toolchain/agents/orchestrator.md`: Status-Modus prüft die Statusprojektion jetzt aktiv
  gegen, meldet Abweichungen im Statusbericht (Beispielausgabe ergänzt), schreibt aber nicht
  selbst zurück (read-only-Vertrag von `/status` bleibt unverändert). Sprint-Modus verifiziert
  beim Wiederbetreten einer Phase ≥ 6 zusätzlich die Statusprojektion vor Fortsetzung.
- `.claude/commands/status.md`: Ablaufbeschreibung um den Gegenprüfungsschritt ergänzt, "Keine
  Veränderungen"-Vertrag bleibt bestehen (Befund wird nur gemeldet).
- `.claude/commands/commands_summary.md`, `toolchain/agents/agents_summary.md`: nachgezogen.
- Auswirkung: Rein deklaratives Verhalten — keine neue Infrastruktur, keine Datenbank (bewusst
  kein 1:1-Import des GSD-Pi-Vorbilds "DB-authoritative state"). Der Rechercheaufwand ist
  bewusst günstig gehalten (Stichprobe, kein vollständiger `/converge`-Scan) und ersetzt
  `/converge` nicht.

**Sprint-Worktree-Isolation (Phase 6–9) — inspiriert von GSD Pi's Milestone-Worktrees**
- `toolchain/workflows/full-sprint.md`: neuer Abschnitt "Worktree-Isolation" — ab Betreten von
  Phase 6 (Implementierung) arbeiten FE/BE/QA/RV/MW auf einem eigenen Git-Worktree
  (`.worktrees/sprint-N` auf Branch `feature/sprint-N`) statt im Haupt-Checkout. Geltungsbereich
  bewusst auf den regulären Sprint-Workflow beschränkt — **nicht** für `/hotfix` (Geschwindigkeit
  vor Isolation), `/spike` (unverbindliche Erkundung) oder `/converge` (liest nur). Phase 10
  (Release) übernimmt Merge (weiterhin `--no-ff`, **kein** Squash — bestehende
  History-Erhaltungs-Konvention bleibt unangetastet, abweichend vom GSD-Pi-Vorbild), Tag und
  Worktree-Cleanup gebündelt; `git push` sowie Worktree-/Branch-Entfernung erfordern explizite
  Nutzerbestätigung, auch bei vollständigem Gate-10-PASS.
- Bei Gate 8 REJECTED (Rollback zu PM): Worktree bleibt bestehen, wird nicht automatisch
  verworfen — Weiterverwendung ist eine PM/Nutzer-Entscheidung nach Scope-Klärung.
- `toolchain/agents/orchestrator.md`: `.phase`-Dateiformat um `worktree-path`/`worktree-branch`
  ergänzt; Sprint-Modus legt den Worktree beim erstmaligen Betreten von Phase 6 an bzw.
  betritt ihn bei Wiederaufnahme erneut (nie neu anlegen).
- `toolchain/agents/backend-agent.md`, `toolchain/agents/frontend-agent.md`: neuer VORGEHEN-
  Schritt 0 — Arbeit findet im Sprint-Worktree statt, sofern `.phase` einen `worktree-path`
  gesetzt hat.
- `projects/_template/.gitignore`: `.worktrees/` ergänzt.
- `.claude/commands/implement.md`, `.claude/commands/sprint.md`: Vorbedingung bzw.
  Phasen-Übersicht um Worktree-Schritte ergänzt.
- `toolchain/agents/agents_summary.md`, `.claude/commands/commands_summary.md`: nachgezogen.
- Auswirkung: Ein unterbrochener Sprint (z. B. Token-Limit-Pause, wie bei `projects/campaignworld`
  Sprint 1 tatsächlich passiert) hinterlässt ab jetzt einen eindeutig lokalisierbaren,
  isolierten Arbeitsstand statt eines mehrdeutigen Haupt-Checkout-Zustands. Bestehende Projekte
  sind nicht rückwirkend betroffen — die Konvention gilt ab dem nächsten `/implement`-Einstieg
  in Phase 6; kein automatisches Umschreiben laufender Sprints.

---

## v2.3 — 2026-07-24

### Neu

**Codebase-Intelligenz (MCP `codebase-memory`) — toolchain-weit registriert**
- `.mcp.json`: neuer Server-Eintrag `codebase-memory` (Referenzimplementierung
  [DeusData/codebase-memory-mcp](https://github.com/DeusData/codebase-memory-mcp)), analog
  zum bestehenden `fetch`-Eintrag — gilt für alle Projekte, kein Per-Projekt-Opt-in.
- `CLAUDE.md`: neuer Abschnitt "Codebase-Intelligenz (MCP `codebase-memory`)" nach dem
  bestehenden "Externe Recherche"-Abschnitt, plus zwei neue Zeilen in der Referenztabelle.
  Der Server baut einen strukturellen Code-Graphen (Tree-sitter + SQLite, pro Projekt
  indiziert) und beantwortet Struktur-/Aufruf-/Änderungsfragen per Tool-Call
  (`search_graph`, `trace_path`, `query_graph`, `detect_changes`, `get_architecture`,
  `search_code`, `semantic_query`, `manage_adr`) statt per Datei-für-Datei-Grep.
- `toolchain/agents/architect-agent.md`: neuer Input "Bestandscode (Converge-Modus)" und
  Nutzungshinweis; Converge-Modus-SCAN-Schritt und ADR-Drift-Prüfung (MATCH-Schritt)
  verweisen jetzt auf `index_repository`/`get_architecture`/`search_graph`/`trace_path`
  statt auf manuelles Datei-Lesen.
- `toolchain/agents/backend-agent.md`, `toolchain/agents/frontend-agent.md`: neuer Input
  "Bestandscode" und Nutzungshinweis für `trace_path`/`search_code`/`query_graph` bei
  Änderungen an bestehendem Code, insbesondere zur Root-Cause-Suche im Bugfix-Modus.
- `toolchain/agents/reviewer-agent.md`: neuer Input "Bestandscode (Change-Impact)"; Review-
  Dimension 1 (Korrektheit) prüft jetzt zusätzlich `detect_changes`-Ergebnisse.
- `toolchain/agents/qa-agent.md`: neuer Input "Bestandscode (Dead-Code-Analyse)" —
  ergänzt, ersetzt aber nicht den bestehenden Test-Coverage-Report.
- `toolchain/agents/agents_summary.md`: entsprechende "Codebase-Intelligenz"-Zeilen bei
  AR, FE, BE, QA, RV nachgezogen.
- Auswirkung: Alle code-nahen Phasen (`/architect`, `/converge`, `/implement`, `/review`,
  `/test-plan`, `/test-run`) können strukturelle Code-Fragen per Graph-Query statt per
  Volltext-Grep beantworten — bei größeren Projekt-Codebases ein spürbarer Token- und
  Konsistenzvorteil. Rein additiv: kein bestehendes Verhalten, Gate oder Artefakt-Format
  wurde verändert; Nutzung ist optional (keine Prüfschritte hängen an `codebase-memory`).

---

## v2.2 — 2026-07-24

### Neu

**Root-Cause-Disziplin bei Bugfixes (`bug-report.md`)**
- `toolchain/templates/bug-report.md` (neu): erste formale Definition von `BUG-NNNNNN`.
  Bislang existierte kein Template — `toolchain/workflows/hotfix.md`s Gates prüften bereits
  Abschnitte namens "Root-Cause", "Betroffene Komponenten" und "Fix-Ansatz", ohne dass diese
  irgendwo definiert waren. Das neue Template definiert genau diese Abschnitte (plus Symptom,
  Reproduktionsschritte, Evidenz, Regressionsrisiko, Verifikation) und macht die
  Root-Cause-Analyse für FE/BE vor jedem Fix verpflichtend — direkte Ursache, systemische
  Ursache, betroffene weitere Stellen, ausgeschlossene Ursachen.
- `toolchain/agents/qa-agent.md`: BUG-Erfassung nutzt jetzt das Template; neuer Schritt zur
  Re-Verifikation zurückgemeldeter Bugs (`BEHOBEN` → `VERIFIZIERT`, oder zurück auf `OFFEN`
  bei fehlender Root-Cause/Regressionstest). Schweregrad-Vokabular von vierstufig
  (BLOCKER/CRITICAL/MAJOR/MINOR) auf das toolchain-weite dreistufige Schema
  (BLOCKER/MAJOR/MINOR) korrigiert — CRITICAL existierte in keinem anderen Gate.
- `toolchain/agents/frontend-agent.md`, `toolchain/agents/backend-agent.md`: neuer
  "Bugfix-Modus" — Root-Cause-Analyse ist vor jeder Code-Änderung Pflicht, Regressionstest ist
  Teil des Fixes.
- `toolchain/workflows/full-sprint.md`: Gate 7 verlangt jetzt ausgefüllte Root-Cause für
  BLOCKER/MAJOR-Bugs (BLOCKER) und für behobene MINOR-Bugs (MAJOR), sowie Status
  `VERIFIZIERT` statt nur "nicht offen".
- `toolchain/workflows/hotfix.md`: verweist jetzt auf das Template statt auf undefinierte
  Abschnittsnamen; Gate 3 verlangt zusätzlich den Status `VERIFIZIERT`.
- `toolchain/protocols/artifact-lifecycle.md`: neuer Abschnitt "Ausnahmen: domänenspezifische
  Status-Verläufe" — dokumentiert, dass `BUG-NNNNNN` (wie bereits `IMPD-NNNNNN`) einen eigenen
  Status-Verlauf statt des generischen DRAFT/APPROVED-Zyklus nutzt.
- `.claude/commands/test-run.md`, `.claude/commands/implement.md`,
  `.claude/commands/commands_summary.md`, `toolchain/agents/agents_summary.md`,
  `toolchain/templates/templates_summary.md`, `toolchain/templates/INDEX.md`: nachgezogen.
- Auswirkung: Bug-Fixes patchen nicht mehr nur das Symptom — Root-Cause-Dokumentation ist vor
  Code-Änderung erzwungen, und ein Bug gilt erst nach erneuter QA-Reproduktion als erledigt,
  nicht schon nach der Implementierung.

---

## v2.1 — 2026-07-24

### Neu

**Projekt-Constitution (`CON-000001`) — bindende Prinzipien ab Discovery**
- `toolchain/templates/constitution.md` (neu): Template für nicht verhandelbare Prinzipien,
  Qualitäts-Mindeststandards, harte Ausschlüsse, Änderungsverfahren und Konfliktregel.
- `toolchain/agents/pm-agent.md`: PM erstellt CON-000001 während `/kickoff` zusätzlich zum
  Stakeholder Brief — synthetisiert aus dem Interview, Schwerpunkt Runde 4+5.
- `toolchain/agents/_base-agent.md`: neue Pflichtregel "Verbindlichkeit der Projekt-Constitution"
  — jeder Agent eskaliert Konflikte mit CON-000001 als BLOCKER an PM, statt sie stillschweigend
  aufzulösen. Neue Artefakt-Präfixe `CON` und `GAP` in der Referenztabelle.
- `toolchain/workflows/full-sprint.md`: Gate 1 → 2 verlangt `CON-000001` im Status APPROVED.
- `.claude/commands/kickoff.md`, `projects/_template/.toolchain.yml`: CON-Ablage und
  `next-ids`-Zähler ergänzt.
- Auswirkung: Jedes neue Projekt erhält ab Discovery einen einzigen, stabilen Satz an
  Leitplanken, der über den gesamten Projektverlauf bindend ist — unabhängig von Tech-Stack
  (ADR) und Feature-Priorisierung (SB).

**Cross-Artefakt-Konsistenzgate `/analyze` (Gate 5.5, vor `/implement`)**
- `.claude/commands/analyze.md` (neu), `toolchain/agents/orchestrator.md`: neuer
  Analyze-Modus des Orchestrators — prüft REQ/US, ADR, UX, SP und CON-000001 strukturell
  (`cross-ref`) und inhaltlich (`self-assertion`) auf Widersprüche, bevor Implementierungsaufwand
  investiert wird. Löst Widersprüche nicht selbst, sondern ordnet sie BA/AR/UX/PM zu.
  Neue `.phase`-Zwischenstufe `ANALYSIS` zwischen `REFINEMENT` und `IMPLEMENTATION`.
- `toolchain/workflows/full-sprint.md`: neue Phase 5.5 mit eigenem Gate und Rollback-Regeln;
  Full-Sprint-Workflow zählt jetzt 11 statt 10 Phasen.
- `toolchain/PROCESS.md`, `toolchain/protocols/handoff-protocol.md`,
  `.claude/commands/refine.md`, `.claude/commands/implement.md`,
  `toolchain/agents/_base-agent.md`: Analyze-Schritt in Prozessdiagramm, Übergabe-Kette und
  Standard-Phasenkette nachgezogen.
- Auswirkung: Spec-Drift zwischen Requirements, Architektur, UX und Sprint-Planung wird vor
  der Implementierung erkannt statt erst im Code Review.

**Brownfield-Gap-Analyse `/converge`**
- `toolchain/templates/gap-analysis.md` (neu), `toolchain/workflows/converge.md` (neu),
  `.claude/commands/converge.md` (neu): neuer Converge-Modus des Architect-Agenten — scannt
  eine bestehende Codebase, gleicht sie mit vorhandenen REQ/US/ADR ab (oder dokumentiert die
  Ist-Architektur, falls noch keine Spezifikation existiert) und liefert `GAP-NNNNNN` mit
  expliziter Empfehlung. Kein Code Review, kein automatischer Fix, kein Phasenwechsel.
- `toolchain/agents/architect-agent.md`: dritter Modus neben Architektur- und Spike-Modus.
- `toolchain/workflows/INDEX.md`, `projects/_template/.toolchain.yml`: Workflow registriert,
  `GAP`-Zähler ergänzt.
- Auswirkung: Altprojekte mit bestehendem Code lassen sich in die Tool Chain übernehmen, ohne
  blind eine neue Spezifikation zu schreiben oder bereits vorhandene Arbeit zu wiederholen.

**Sonstiges**
- `CLAUDE.md`: Artefakt-Benennung, Projektordner-Struktur, Slash-Commands- und
  Workflows-Tabellen um CON/GAP/`/analyze`/`/converge` ergänzt; veraltete Phasenzahl
  ("9 Phasen") korrigiert.
- `.agents/skills/coding-toolchain/SKILL.md`, `toolchain/scripts/validate-codex-compat.ps1`:
  additive Codex-Schicht um `/analyze`, `/converge` und die neuen Artefakt-Präfixe ergänzt.
- `toolchain/agents/agents_summary.md`, `toolchain/templates/templates_summary.md`,
  `.claude/commands/commands_summary.md`, `toolchain/agents/INDEX.md`,
  `toolchain/templates/INDEX.md`: konsolidierte Übersichten nachgezogen.

---

## v2.0 — 2026-07-23

### Neu

**Additive Codex-Kompatibilität bei unverändertem Claude-Code-Vorrang**
- `AGENTS.md`: als kompakter Codex-Adapter neu ausgerichtet; erklärt `CLAUDE.md`
  ausdrücklich zur kanonischen fachlichen und funktionalen Quelle und übersetzt die
  bestehenden Slash Commands semantisch für Codex.
- `.agents/skills/coding-toolchain/SKILL.md` und `agents/openai.yaml`: nativer
  Repository-Skill, der Toolchain-Commands, Rollen, Gates und Artefakte erkennt und immer
  auf die bestehenden Claude-Spezifikationen routet.
- `.codex/config.toml`, `.codex/agents/*.toml`: elf native Codex-Rollenadapter für ORCH,
  PM, BA, AR, UX, FE, BE, QA, RV, MW und AC. Die Adapter duplizieren keine Rollen-Prompts,
  sondern laden die kanonischen Definitionen unter `toolchain/agents/`.
- `projects/_template/AGENTS.md`: stellt die Anweisungen auch in den eigenständigen
  Projekt-Git-Repositories bereit und ermittelt die Tool Chain über `toolchain-path`.
- `toolchain/scripts/validate-codex-compat.ps1`, `toolchain/scripts/INDEX.md`: read-only
  Konsistenzprüfung für Commands, Rollenadapter, Skill und Prioritätsregeln.
- `CLAUDE.md`, `BEDIENUNGSANLEITUNG.md`, `toolchain/INDEX.md`: additive Codex-Schicht
  dokumentiert und veraltete Agenten-/Phasenanzahlen korrigiert.
- Auswirkung: Claude Code arbeitet unverändert mit den bisherigen Commands und Prompts;
  Codex kann dieselben Rollen und Workflows zusätzlich nativ entdecken und ausführen.

---

## v1.11 — 2026-07-22

### Behoben

**Git Hooks unter Windows: Bash-Annahme durch PowerShell-native Hooks ersetzt**
- Ursache: `toolchain/hooks/pre-commit`/`post-commit` sind Bash-Skripte; `toolchain/hooks/INDEX.md`
  ging bisher davon aus, dass Git for Windows sie problemlos über ein gebündeltes `sh.exe`
  ausführt. Das gilt nicht für **MinGit**-Installationen (minimale Git-Distribution ohne
  Bash/MSYS-Userland) — dort liegt oft nur Windows' eigener, nicht-funktionsfähiger
  WSL-`bash.exe`-Launcher-Stub in PATH, was jeden Commit mit einem kryptischen
  Socket-/Puffer-Fehler blockierte (entdeckt im Projekt `campaignworld`).
- `toolchain/hooks/pre-commit.windows.ps1`, `toolchain/hooks/post-commit.windows.ps1`
  (neu): PowerShell-native 1:1-Portierungen der beiden Bash-Hooks (gleiche 4 Checks:
  Lint, Datei-Header, Secret-Scan, TODO-Format). Nutzen bewusst **Windows PowerShell 5.1**
  (`C:/Windows/System32/WindowsPowerShell/v1.0/powershell.exe`) als Shebang-Interpreter,
  nicht `pwsh` (PowerShell 7) — git leitet keine Shebang-Argumente weiter und ruft immer
  nur `<interpreter> <hook-pfad>` ohne Flags auf; `pwsh`s striktes `-File`-Binding
  verlangt dafür eine `.ps1`-Endung, die eine erweiterungslose Hook-Datei nie hat,
  während PowerShell 5.1s Argument-Bindung den erweiterungslosen Pfad direkt akzeptiert.
- `toolchain/hooks/setup-hooks.ps1`: installiert jetzt die neuen `*.windows.ps1`-Dateien
  (umbenannt zu `pre-commit`/`post-commit`) statt die Bash-Dateien unverändert zu kopieren.
  `setup-hooks.sh` (Linux/Mac/WSL/echtes Git-Bash) bleibt unverändert und installiert
  weiterhin die Bash-Variante.
- `toolchain/hooks/INDEX.md`: Dateitabelle und Erklärung entsprechend aktualisiert,
  falsche sh.exe-Annahme korrigiert.
- Auswirkung: Neue Projekte unter Windows-Umgebungen ohne funktionierende Bash (z. B.
  MinGit-only-Setups) können jetzt über `pwsh toolchain/hooks/setup-hooks.ps1` funktionierende
  Git Hooks erhalten, ohne dieses Problem erneut entdecken zu müssen. Bereits bestehende
  Projekte mit fehlschlagenden Bash-Hooks können die Hooks durch erneuten Aufruf von
  `setup-hooks.ps1` auf die PowerShell-Variante umstellen (bestehender Hook wird automatisch
  gesichert, siehe Backup-Logik in `setup-hooks.ps1`).

---

## v1.10 — 2026-07-20

### Neu

**MCP-Server `fetch` integriert (externe Recherche)**
- `.mcp.json` im Repo-Root angelegt: registriert den Referenz-MCP-Server `fetch`
  ([modelcontextprotocol/servers](https://github.com/modelcontextprotocol/servers/tree/main/src/fetch)),
  gestartet via `python -m mcp_server_fetch` (Paket `mcp-server-fetch` per `pip install
  mcp-server-fetch` installiert — kein `uv`/`uvx` auf diesem System nötig).
- `CLAUDE.md`: neuer Abschnitt "Externe Recherche (MCP `fetch`)" — beschreibt Zweck,
  Parameter, nutzende Agenten (PM, BA, AR) und Grenzen (nur öffentliche Inhalte,
  robots.txt-Konformität, Quellenpflicht). Neue Zeile in der Referenzen-Tabelle.
- `pm-agent.md`, `ba-agent.md`, `architect-agent.md`: Inputs-Tabellen und je ein
  "Externe Recherche"-Hinweis ergänzt — PM für Markt-/Wettbewerbsanalyse, BA für
  fachliche Standards/Domänen-Referenzen, AR für Tech-/API-Dokumentation (Architektur-
  und Spike-Modus).
- `spike.md`: SPIKE-RESEARCH-Phasenbeschreibung verweist jetzt auf `fetch` als
  Recherchequelle.
- `agents_summary.md`: PM-, BA- und AR-Abschnitte (inkl. Spike-Modus) um
  "Externe Recherche"-Zeile ergänzt.

---

## v1.9 — 2026-07-20

### Neu

**Vier fehlende Artefakt-Templates ergänzt: SRP, DOC, RN, GS**
- `toolchain/templates/spike-report.md` (`SRP-NNNNNN`) — inkl. vollständigem Übergabe-Block
  (AR → PM/Nutzer) nach `handoff-protocol.md`. `spike.md`s bisherige Inline-Kopie des Formats
  entfernt und durch Verweis auf das Template ersetzt (Duplikat-/Drift-Risiko beseitigt).
- `toolchain/templates/feature-guide.md` (`DOC-NNNNNN`), `toolchain/templates/release-notes.md`
  (`RN-NNNNNN`, projektspezifisch — nicht zu verwechseln mit dieser Datei), `toolchain/templates/
  getting-started.md` (`GS-000001`).
- `manual-writer-agent.md`: VORGEHEN referenziert jetzt alle vier Templates statt (bei DOC) einer
  Inline-Kopie der Struktur.
- Alle vier in `toolchain/templates/INDEX.md` und `templates_summary.md` aufgenommen.

**Architect-Agent: `/spike`-Modus nachgerüstet**
- `architect-agent.md` behauptete (über `agents_summary.md`) durch `/spike` aktivierbar zu sein,
  enthielt aber keinerlei Spike-Logik. Neuer Abschnitt "Spike-Modus (`/spike`)" mit eigenem
  System-Prompt (SPIKE-RESEARCH/SPIKE-REPORT, Timebox-Disziplin, `SRP-NNNNNN` via Template),
  eigener Definition-of-Done und Verweis auf den im Template enthaltenen Übergabe-Block.
- Inputs/Outputs-Tabellen um Spike-Brief (Input) und `SRP-NNNNNN` (Output) ergänzt.

### Geändert

**CLAUDE.md's Artefakt-Namenstabelle vervollständigt**
- `TR-NNNNNN` (Testergebnis-Bericht) und `BUG-NNNNNN` (Fehlerbericht) fehlten, obwohl beide
  toolchain-weit aktiv verwendet werden (u. a. in `_base-agent.md`s eigener Referenztabelle,
  die beide bereits korrekt listete) — ergänzt.

**Gate 5 und Gate 6 in `full-sprint.md`: unverifizierbare Prüfmethoden ersetzt**
- Gate 5 ("Keine ungelösten Tech-Blocker") hatte als Prüfung wörtlich "Prüfen" — eine
  Tautologie ohne Methode. Ersetzt durch einen konkreten Verweis auf SP-NNNNNN Abschnitt
  "Risiken & Unsicherheiten".
- Gate 6 ("Alle US-Akzeptanzkriterien umgesetzt") war ein BLOCKER-Kriterium, das per
  Selbstauskunft von FE+BE abgenommen wurde — dieselbe Rolle, die es umsetzt, zertifiziert
  sich selbst. Ersetzt durch eine objektive `cross-ref`-Prüfung: jede Sprint-US-NNNNNN
  braucht mindestens einen `// Implementiert: US-NNNNNN`-Pflichtkommentar im Code
  (Konvention bereits in CLAUDE.md vorhanden, jetzt auch als Gate-Prüfmethode genutzt).

**`hotfix.md` und `spike.md`: fehlende Prüfung-Spalte und Rollback-Regeln ergänzt**
- Beide Workflows hatten Gate-Tabellen ohne Prüfung-Spalte (nur Kriterium + Schwere) — jedes
  Kriterium bekam jetzt eine konkrete, dateibezogene Prüfmethode.
- Beide Workflows hatten keine Rollback-Regeln (im Gegensatz zu `full-sprint.md`) — ergänzt.
- `hotfix.md` referenzierte zudem nicht-existente Befehlssyntax (`/test-run [smoke]`,
  `/review [hotfix-branch]`) — auf die tatsächliche Signatur `[projektname] [sprint-nr]`
  korrigiert, mit Klarstellung im Fließtext (Smoke-Test-Umfang, Hotfix-Branch-Kontext).

**`reviewer-agent.md`: `DEBT-NNNNNN` fehlte in der Outputs-Tabelle**
- War nur im Fließtext (ARTEFAKT-ABLAGE, Definition of Done) erwähnt, nicht in der Tabelle,
  die typischerweise als Kurzreferenz genutzt wird — ergänzt.

**`setup-hooks.ps1` — native Windows-Installationsvariante**
- Neues `toolchain/hooks/setup-hooks.ps1`, funktional äquivalent zu `setup-hooks.sh`, ohne
  Abhängigkeit von Git-Bash/WSL (nur das *Installationsscript* brauchte eine Windows-Variante —
  die Git Hooks selbst sind weiterhin Bash-Skripte, die Git for Windows über sein gebündeltes
  `sh.exe` transparent ausführt).
- `toolchain/hooks/INDEX.md` und CLAUDE.md's "Neues Projekt starten" zeigen jetzt beide Varianten.

- Betroffen: `toolchain/templates/{spike-report,feature-guide,release-notes,getting-started}.md`
  (neu), `toolchain/templates/INDEX.md`, `toolchain/templates/templates_summary.md`,
  `toolchain/agents/architect-agent.md`, `toolchain/agents/manual-writer-agent.md`,
  `toolchain/agents/reviewer-agent.md`, `toolchain/agents/agents_summary.md`,
  `toolchain/workflows/full-sprint.md`, `toolchain/workflows/hotfix.md`,
  `toolchain/workflows/spike.md`, `toolchain/hooks/setup-hooks.ps1` (neu),
  `toolchain/hooks/INDEX.md`, `CLAUDE.md`

---

## v1.8 — 2026-07-20

### Neu

**FAQ-NNNNNN als vollwertiger Artefakttyp eingeführt**
- Neues Template `toolchain/templates/faq.md`.
- `manual-writer-agent.md`: FAQ wird jetzt tatsächlich erzeugt (VORGEHEN-Schritt, Ablage-Pfad,
  Definition-of-Done-Eintrag) statt nur in Kernverantwortlichkeiten/Outputs erwähnt zu werden,
  ohne je erzeugt zu werden.
- `FAQ-NNNNNN` in CLAUDE.md's Artefakt-Benennungstabelle, `_base-agent.md`s Referenztabelle
  (dort auch `GS` und `SRP` ergänzt, die bereits in CLAUDE.md standen aber in der
  Agenten-Referenztabelle fehlten), `templates_summary.md` und `agents_summary.md` ergänzt.
- ID-Zähler `FAQ` in `projects/_template/.toolchain.yml` ergänzt.

### Geändert

**Projekt-Unterordner-Pflicht durchgesetzt (PM, BA, AR, UX, AC)**
- Fünf Agenten schrieben ihr primäres Artefakt entgegen CLAUDE.md's expliziter Regel
  ("schreibt ausschließlich in den zugehörigen Unterordner") ins Projekt-Root:
  `pm-agent.md` (SB → jetzt `discovery/`), `ba-agent.md` (REQ/US → jetzt `requirements/`),
  `architect-agent.md` (ADR/STRUCTURE.md → jetzt `architecture/`), `ux-agent.md`
  (UX → jetzt `ux/`), `agile-coach-agent.md` (RETRO/IMPD/PC → jetzt `retros/`).
  Reviewer- und Manual-Writer-Agent waren bereits korrekt.
- Jede korrigierte Datei bekam zusätzlich eine explizite "NIEMALS im Projekt-Root ablegen"-Zeile.

**DONE als regulärer Zwischenzustand vor RELEASED etabliert**
- `orchestrator.md`s "Gültige Phasenwerte" enthielt eine widersprüchliche Mischung: die
  Hauptkette ließ DONE ganz weg (`... DOCUMENTATION → RELEASE → RELEASED`), während eine
  separate Zeile DONE nachträglich als "Legacy" für vor Phase-10-Einführung abgeschlossene
  Sprints erklärte. Jetzt einheitlich: `... DOCUMENTATION → DONE → RELEASED`, DONE ist ein
  regulärer, aktueller Zwischenzustand (Sprint inhaltlich fertig, noch nicht gemerged),
  RELEASED der Zustand nach Phase 10 (Merge + Tag). Hotfix-Phasennamen im selben Abschnitt
  ebenfalls auf die kanonischen deutschen Namen korrigiert (waren `HOTFIX-ANALYSIS`/
  `HOTFIX-IMPLEMENTATION`, jetzt `HOTFIX-ANALYSE`/`HOTFIX-IMPLEMENT`, wie in `hotfix.md`).
- `projects/REGISTRY.md`s Phasen-Referenz war unvollständig (endete bei REVIEW → DONE, ohne
  DOCUMENTATION/RELEASED) — ergänzt und mit Kurzerklärung versehen.

**Handoff-Protokoll vereinheitlicht**
- Kein Agent produzierte bisher das in `handoff-protocol.md` vorgeschriebene Format
  (Überschrift `## Übergabe: [Quelle] → [Ziel]`, Felder Datum/Von/An/Nächster-Befehl,
  Artefakte-Tabelle, Offene-Fragen-Tabelle mit Kritikalität, Nicht-Ziele, Empfehlungen) —
  jeder Agent nutzte ein eigenes, einfacheres Ad-hoc-Bullet-Format.
- Alle Handoff-Blöcke vereinheitlicht: `pm-agent.md` (→BA), `ba-agent.md` (→AR),
  `architect-agent.md` (→UX und →FE/BE, zwei Blöcke), `ux-agent.md` (→FE),
  `frontend-agent.md` (→QA), `backend-agent.md` (→FE und →QA, zwei Blöcke),
  `qa-agent.md` (→RV), `reviewer-agent.md` (→MW), `manual-writer-agent.md` (→ORCH).
  Bestehende agentenspezifische Inhalte (z. B. Browser-Clickpfad/Performanz-Felder bei QA)
  wurden in die neuen Abschnitte übernommen, nicht verworfen.
- `agile-coach-agent.md` bewusst ausgenommen: AC übergibt an den Nutzer, nicht an einen
  Agenten — das Protokoll gilt explizit nur für Agent-zu-Agent-Übergaben. Dies jetzt im
  Text vermerkt, statt als stille Abweichung stehen zu lassen.
- `handoff-protocol.md`s eigene "Übergabe-Kette im Full-Sprint-Workflow"-Grafik endete bei
  `RV ──▶ [MERGE]` ohne MW — ergänzt zu `RV ──▶ MW ──[DOC+RN]──▶ [RELEASE]`.

**Weitere stale `SPRINT-NNNNNN`-Referenz gefunden**
- `toolchain/PROCESS.md` verwendete an zwei Stellen noch `SPRINT-NNNNNN` statt `SP-NNNNNN`
  (derselbe Fehler wie in `.claude/commands/refine.md`, dort bereits in v1.7 korrigiert) —
  ebenfalls auf `SP-NNNNNN` korrigiert.

- Betroffen: `toolchain/agents/{pm,ba,architect,ux,frontend,backend,qa,reviewer,
  manual-writer,agile-coach,orchestrator,_base}-agent.md`, `toolchain/protocols/handoff-protocol.md`,
  `toolchain/templates/faq.md` (neu), `toolchain/templates/templates_summary.md`,
  `toolchain/agents/agents_summary.md`, `CLAUDE.md`, `projects/REGISTRY.md`,
  `projects/_template/.toolchain.yml`, `toolchain/PROCESS.md`

---

## v1.7 — 2026-07-20

### Geändert

**Review-Nachbesserung zu v1.6 (Browser-Clickpfade/Performanztests): Lücken geschlossen**
- Gate 7 (`full-sprint.md`): Browser-Clickpfade und Performanztests von MAJOR auf BLOCKER
  angehoben, mit objektiv prüfbaren Kriterien (dokumentierter Testmodus bzw. ausgefüllte
  Zielwerte) statt vagem "Report prüfen".
- QA-Agent (`qa-agent.md`): Doppelte Testausführung (headed + headless) zu einem Durchlauf
  zusammengeführt; stillschweigendes Überspringen von Browser-Clickpfad-Tests ohne
  Dokumentation ist nicht mehr zulässig; doppelte Schrittnummerierung ("6." zweimal) in
  Phase B korrigiert; Performanz-Zielwerte müssen aus REQ/ADR stammen oder explizit als
  "kein Budget definiert" vermerkt werden statt Platzhalter offen zu lassen.
- Übergabeprotokoll QA → Reviewer (`qa-agent.md`) um Felder für Browser-Clickpfad- und
  Performanz-Ergebnisse ergänzt.
- Testplan-Template (`test-plan.md`): Performanztest-Sektion 3.4 um Zielwert-Quelle und
  konkrete Messmethoden ergänzt.
- Agents-Summary (`agents_summary.md`): fehlerhafte Zuordnung der Performanztestfälle zu
  Sektion 3.3 korrigiert (tatsächlich Sektion 3.4); Übergabe-Beschreibung ergänzt.
- CLAUDE.md und `artifact-lifecycle.md`: Artefakt-Lebenszyklus-Regel präzisiert —
  Artefakte werden nie *von der KI eigenständig* gelöscht; eine Löschung auf direkten,
  expliziten Userbefehl (z. B. vollständiger Projektabbruch) ist die einzige Ausnahme und
  wird in `REGISTRY.md` dokumentiert.
- `projects/REGISTRY.md`: campaignworld-Eintrag präzisiert, sodass TESTING (Sprint 3) und
  der gescheiterte `/review`-Aufruf als eindeutig unterschiedene, sequenzielle Ereignisse
  beschrieben sind (statt einer scheinbar widersprüchlichen Phasenangabe).
- Betroffen: `CLAUDE.md`, `toolchain/protocols/artifact-lifecycle.md`, `projects/REGISTRY.md`,
  `toolchain/agents/qa-agent.md`, `toolchain/workflows/full-sprint.md`,
  `toolchain/templates/test-plan.md`, `toolchain/agents/agents_summary.md`

### Behoben

**Toolchain-weiter Konsistenz-Audit: ID-Formate, fehlende Phasen, Lifecycle-Status, Dokumentation**
- `/refine` erzeugte Sprint-Backlogs als `SPRINT-NNNNNN.md` statt `SP-NNNNNN` — dadurch waren
  sie für `/retro` und Gate-Checks unauffindbar. Korrigiert auf `SP-NNNNNN`.
- `/sprint` listete nur 8 statt der tatsächlichen 10 Phasen (Dokumentation und Release fehlten
  komplett) und widersprach damit `commands_summary.md`s eigener Phasenzahl-Angabe. Beide
  Phasen ergänzt, `commands_summary.md` auf "10 Phasen (Discovery bis Release)" korrigiert.
- `/kickoff` behauptete "max. 3 Runden à max. 3 Fragen", während `pm-agent.md` und
  `commands_summary.md` übereinstimmend 5 Runden mit je 3–5 Fragen definieren. Auf 5 Runden
  vereinheitlicht.
- ADR- und Branching-Strategy-Template zeigten nur 4 der 6 Lifecycle-Status-Werte (fehlten:
  `ACTIVE`, `ARCHIVED`) — ein Architect konnte ein ADR damit nie als `ACTIVE` markieren.
  Beide Templates auf die vollständige Statuskette korrigiert.
- `hotfix.md`s Phasendiagramm nutzte englische Phasennamen (`HOTFIX-ANALYSIS`,
  `HOTFIX-IMPLEMENTATION`), die vom kanonischen `.phase`-Enum (`HOTFIX-ANALYSE`,
  `HOTFIX-IMPLEMENT`) abwichen. Diagramm auf die kanonischen deutschen Namen korrigiert.
- `architecture.html` und `api_documentation.html` waren seit 2026-06-18 nicht aktualisiert
  und erwähnten weder den Agile-Coach (AC) noch `/retro`, `/health-check`, `/coach`,
  `/impediment`. Agenten-/Phasen-/Command-Zähler korrigiert (11 Rollen, 18 Commands,
  10 Phasen), AC als bedarfsweise aktivierte Rolle ergänzt, Zustandsdiagramm um
  DONE → RELEASED ergänzt, fehlende Post-Sprint-Commands in der API-Tabelle nachgetragen.
- `projects/_template/.toolchain.yml` fehlten ID-Zähler für `DOC, RN, GS, RETRO, IMPD, PC` —
  ergänzt.
- `toolchain/workflows/INDEX.md` behauptete ebenfalls "8 Phasen" für `full-sprint.md` —
  auf 10 Phasen korrigiert, konsistent mit obiger Korrektur.
- Betroffen: `.claude/commands/refine.md`, `.claude/commands/sprint.md`,
  `.claude/commands/kickoff.md`, `.claude/commands/commands_summary.md`,
  `toolchain/templates/architecture-decision.md`, `toolchain/templates/branching-strategy.md`,
  `toolchain/workflows/hotfix.md`, `toolchain/workflows/INDEX.md`, `architecture.html`,
  `api_documentation.html`, `projects/_template/.toolchain.yml`

---

## v1.6 — 2026-07-19

### Neu

**QA- und Testprozess um Browser-UI-Clickpfade und Performanztests erweitert**
- QA-Agent, Testplan-Template und Full-Sprint-Workflow wurden um verbindliche Prüfungen für
  Browser-basierte UI-Clickpfade erweitert, soweit die Umgebung das zulässt.
- Performanztests sind nun explizit Teil des Testings und werden im Testplan, im QA-Workflow
  und in den Qualitätskriterien dokumentiert.
- Betroffen: `toolchain/agents/qa-agent.md`, `toolchain/templates/test-plan.md`,
  `toolchain/workflows/full-sprint.md`, `toolchain/agents/agents_summary.md`,
  `toolchain/templates/templates_summary.md`

---

## v1.5 — 2026-07-17

### Neu

**Root-`.gitignore` + vollständiges `projects/_template/`-Skelett**
- Jedes `projects/<name>/` ist als eigenes Git-Repository vorgesehen (nicht Teil des
  Toolchain-Repos). Neues Root-`.gitignore` schließt `projects/*` aus — Ausnahmen:
  `REGISTRY.md` und `_template/` bleiben getrackt. Zusätzlich generelle Ignores für
  OS-Dateien, Editor-Ordner, Logs/Temp, `.env*`, `node_modules/` etc.
- `projects/_template/` von zwei Dateien (`.phase`, `INDEX.md`) auf vollständiges
  Projekt-Skelett erweitert: `.toolchain.yml`, `.toolchain-config`, `README.md`,
  `.gitignore` (Vorlage für das jeweilige Projekt-Repo) sowie alle Artefakt-Unterordner
  (`discovery/` inkl. `DECISIONS.md`, `requirements/`, `architecture/`, `ux/`, `sprints/`,
  `testing/`, `reviews/`, `docs/`, `retros/`) mit `.gitkeep`.
- Bewusst NICHT im Template enthalten: `src/`, `tests/`, `infra/`, `scripts/` — diese
  sind technologieabhängig und werden erst nach ADR-000001 vom Architect-Agenten angelegt
  (Prinzip "Keine Technologie-Annahmen", `_base-agent.md`).
- `CLAUDE.md` ("Neues Projekt starten") und `.claude/commands/kickoff.md` aktualisiert:
  neuer Ablauf ist Kopie aus `_template/` + `git init` im Projektordner statt leerem `mkdir`.
- Betroffen: `.gitignore` (neu), `projects/_template/**` (neu), `CLAUDE.md`,
  `.claude/commands/kickoff.md`, `.claude/commands/commands_summary.md`

### Bekannte Inkonsistenz (nicht in diesem Release behoben)

- `toolchain/agents/pm-agent.md` legt `SB-000001` noch direkt unter `projects/<name>/` ab,
  nicht unter `projects/<name>/discovery/` wie in CLAUDE.md ("Projektordner-Struktur", seit
  v1.2) vorgesehen. Betrifft nur Artefakt-Pfade innerhalb eines Projekt-Repos, nicht die
  Git-Struktur dieses Releases — separat zu beheben.

---

## v1.4 — 2026-07-17

### Geändert

**Architect-Agent: Standardpräferenz Microservices vor Monolith**
- Neue verbindliche Default-Regel im Architekturschema-Entscheid: Microservices sind das
  bevorzugte Schema. Ein Monolith (oder Modularer Monolith) ist nur mit expliziter,
  im ADR dokumentierter Begründung zulässig (z. B. kleines Team, fehlende Ops-Kapazität,
  kleiner Scope, harte Time-to-Market-Vorgabe).
- System-Prompt-Schritt "Identifiziere technische Kernentscheidungen" um den Punkt
  "Architekturschema: Microservices vs. Monolith" ergänzt, inkl. Hinweis auf
  Data-per-Service vs. geteilte DB bei Microservices.
- Definition-of-Done um Prüfpunkt "Architekturschema entschieden (Microservices-Default
  oder begründeter Monolith)" ergänzt.
- Betroffen: `toolchain/agents/architect-agent.md` (v1.1), `toolchain/agents/agents_summary.md`

### Neu

**Container-Image-Größenoptimierung: kein neuer Agent, verteilt auf AR + BE**
- Geprüft, ob ein eigener Agent für Container-Größenoptimierung sinnvoll ist — verworfen,
  da es sich um eine schmale technische Praxis (kein eigenständiger SDLC-Phasen-Schritt)
  handelt. Stattdessen in bestehende Rollen integriert:
- **AR-Agent:** Legt bei Containerisierung Base-Image-Strategie und Größenbudget im ADR
  fest (Distroless/Alpine/Slim bevorzugt, Multi-Stage-Build als Standard). Neues
  "Container-Prinzip" + DoD-Punkt.
- **BE-Agent:** Neue "Container-Checkliste" (parallel zur Sicherheits-Checkliste) — minimales
  Base-Image, Multi-Stage-Build, nur Produktions-Dependencies, cache-effiziente Layer,
  Image-Größe gegen ADR-Budget geprüft. Handoff an QA um Container-Image-Größe ergänzt.
  DoD-Punkt ergänzt.
- Betroffen: `toolchain/agents/architect-agent.md` (v1.1), `toolchain/agents/backend-agent.md`
  (v1.1), `toolchain/agents/agents_summary.md`

---

## v1.3 — 2026-06-21

### Geändert

**Artefakt-Nomenklatur: NNN → NNNNNN (drei → sechs Stellen)**
- Alle Artefakt-IDs und Dateinamen-Platzhalter verwenden ab sofort sechs Stellen: `NNNNNN`
- Beispiele: `SB-000001-projektname.md`, `US-000042-login.md`, `ADR-000001-tech-stack.md`
- `NNN = sechsstellig, sequenziell pro Projekt` (war: dreistellig)
- 58 Dateien aktualisiert: alle Agenten, Templates, Commands, Protokolle, Summary-Dateien
- Betroffen: gesamte `toolchain/`, `.claude/commands/`, `CLAUDE.md`

---

## v1.2 — 2026-06-21

### Neu

**Projektordner-Struktur — definierte Unterordner pro Artefakttyp**
- Neue Konvention in `CLAUDE.md` (Abschnitt "Projektordner-Struktur"):
  alle Artefakte liegen in typspezifischen Unterordnern von `projects/<name>/` —
  niemals im Projekt-Root: `discovery/`, `requirements/`, `architecture/`, `ux/`,
  `sprints/`, `testing/`, `reviews/`, `docs/`, `retros/`
- Alle betroffenen Agenten und Templates wurden mit Ordnerangaben aktualisiert

**`/review` — User Acceptance Review + Nutzer-Interview (2-stufige Abnahme)**
- Drei Phasen statt einer: (1) Test-Guide erstellen & präsentieren, (2) Nutzer-Interview,
  (3) technisches Code Review
- Phase 1: RV-Agent erstellt nutzerfreundlichen Test-Guide (klare Schritte, kein Jargon)
  aus US-NNNNNN und TP-NNNNNN — pausiert danach und wartet auf Nutzer
- Phase 2: Strukturiertes Interview zu jedem Feature — Befund: ACCEPTED / CONDITIONAL / REJECTED
- Phase 3: Technisches Review unverändert (6 Dimensionen)
- Gesamtentscheidung kombiniert Nutzer-Befund und technischen Review —
  REJECTED durch Nutzer überstimmt technisch APPROVED
- Betroffen: `.claude/commands/review.md`, `toolchain/agents/reviewer-agent.md` (v2.0),
  `toolchain/templates/review-checklist.md` (neuer Abschnitt "Teil 1: Nutzerabnahme"),
  `.claude/commands/commands_summary.md`, `toolchain/agents/agents_summary.md`

**Playwright E2E — explizite Integration in QA-Workflow**
- `test-plan.md` Template: neue Sektion 3.3 "Playwright E2E Testinventar"
  (Testdateien, Page Objects, benötigte `data-testid` Attribute, Voraussetzungen)
- `qa-agent.md`: Phase B System-Prompt mit Playwright-spezifischen Schritten erweitert
  (Config prüfen, `--reporter=html`, Report-Ablage, Screenshot/Trace-Pfade erfassen)
- `test-run.md`: Playwright-Befehle und Report-Ablage explizit dokumentiert
- Betroffen: `toolchain/templates/test-plan.md`, `toolchain/agents/qa-agent.md`,
  `.claude/commands/test-run.md`, `.claude/commands/commands_summary.md`,
  `toolchain/agents/agents_summary.md`

---

## v1.1 — 2026-06-19

### Neu

**`/impediment` — Impediment-Interview-Command**
- Neuer Slash Command für den Agile Coach (AC)
- Unterschied zu `/coach`: Kein formuliertes Problem nötig — AC führt strukturiertes
  5–6-Fragen-Interview durch (Symptom → Frequenz → Auswirkung → Umgehungen → Ziel)
- Neues Artefakt `IMPD-NNNNNN` mit eigenem Template (`toolchain/templates/impediment.md`)
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
