# Release Notes — AI Development Tool Chain

Änderungsprotokoll der Tool Chain selbst (nicht projektspezifischer Artefakte).  
Projektspezifische Release Notes werden als `RN-NNNNNN` in `projects/<name>/docs/` abgelegt.

**Pflege-Regel:** Jede strukturelle Änderung an Commands, Agenten, Templates oder Protokollen
wird hier als neuer Eintrag dokumentiert — mit Datum, beteiligten Dateien und Auswirkung.
Diese Datei wird in CLAUDE.md referenziert und ist Pflicht-Output bei Tool-Chain-Änderungen.

---

## v4.11 — 2026-08-18

### Neu

**Alle Agenten — Fortschrittsmeldung bei lange laufenden Prozessen (PC-000011)**

- Auslöser: `/impediment campaignworld` — während eines vollen Playwright-Laufs (aktuell
  117 Testfälle, historisch 90–120+ Minuten) meldete der ausführende Agent nichts, bis der
  Lauf vollständig abgeschlossen war; der Nutzer musste explizit nachfragen, ob überhaupt
  Fortschritt gemacht wird.
- `toolchain/agents/_base-agent.md` (v1.1): neuer Abschnitt „Fortschrittsmeldung bei lange
  laufenden Prozessen" unter „Pflicht-Verhalten aller Agenten" — jeder Agent, der einen
  erfahrungsgemäß mehrminütigen (insbesondere im Hintergrund weiterlaufenden) Prozess startet,
  meldet periodisch Zwischenfortschritt statt nur das Endergebnis. Für Playwright-Läufe konkret:
  alle ~20 abgeschlossene Testfälle eine kurze Chat-Meldung ("X von Y Playwright-Tests
  gelaufen"). Gilt damit für jeden Agenten, der Playwright ausführt — nicht nur QA, auch FE/BE
  während `/implement`s eigener E2E-Verifikation (Präzedenz `IMPD-000003`).
- `toolchain/agents/qa-agent.md` (v1.3): neuer Schritt 4b in Phase B (`/test-run`) konkretisiert
  die allgemeine Regel für den Playwright-Ausführungsschritt; neuer DoD-Punkt entsprechend
  ergänzt.
- `toolchain/agents/agents_summary.md`: Architektur-Prinzip- und QA-Abschnitt entsprechend
  aktualisiert.
- Auswirkung: Nutzer erhält während jedes langen Playwright-Laufs laufende
  Fortschrittsmeldungen, ohne selbst nachfragen zu müssen — gilt toolchain-weit, nicht nur für
  `/test-run`.

---

## v4.10 — 2026-08-18

### Behoben

**QA/BE/FE — Doppellauf-Vermeidung für Unit-/Integrationstests zwischen /implement und /test-run (PC-000010)**

- Auslöser: `/impediment campaignworld` — der vollständige Unit-/Integrationstest-Lauf wird
  während `/implement` (BE/FE-eigene Verifikation) UND unbedingt erneut während `/test-run`
  (`qa-agent.md` Phase B, Schritt 2/3) ausgeführt, obwohl sich der Code-Stand dazwischen nicht
  ändert — reine Wiederholung ohne neuen Erkenntnisgewinn, generalisiert das bereits für E2E
  gelöste Muster aus `IMPD-000003` (Sprint 20) auf Unit-/Integrationstests.
- `toolchain/agents/backend-agent.md` (v1.4), `toolchain/agents/frontend-agent.md` (v1.2):
  BE→QA-/FE→QA-Übergabeprotokoll erhält ein neues Pflichtfeld „Bereits ausgeführte
  Verifikation" — exakter Befehl, Zeitpunkt, Passed/Failed-Zahlen jedes während `/implement`
  bereits gelaufenen Unit-/Integrationstest/Typecheck/Lint-Laufs.
- `toolchain/agents/qa-agent.md` (v1.2): neuer Schritt 1b in Phase B (`/test-run`) — prüft das
  Übergabeprotokoll auf bereits dokumentierte, unveränderte grüne Ergebnisse; nur bei fehlender
  Dokumentation, Abweichung oder Unklarheit bleibt der volle Neu-Lauf Pflicht (sicherer
  Normalfall). Neuer DoD-Punkt entsprechend ergänzt.
- `.claude/commands/test-run.md` (und `~/.claude/commands/test-run.md`-Mirror): Schritt 1b
  gespiegelt.
- `.claude/commands/commands_summary.md`, `toolchain/agents/agents_summary.md`: entsprechend
  aktualisiert.
- Auswirkung: Ein unveränderter, bereits grüner Unit-/Integrationstest-Lauf wird nicht mehr
  blind ein zweites Mal ausgeführt — unabhängige QA-Verifikation bleibt der sichere Normalfall
  bei jeder Abweichung/Unklarheit, nur der reine Wiederholungsfall entfällt.

**CLAUDE.md — user-level Command-Mirror aus Wartungspflichten ergänzt**

- Auslöser: Im Projekt campaignworld fehlten die Commands `/converge`, `/decompose` und
  `/harden` sowie `/analyze`, weil das Projekt als eigener Workspace-Root ohne eigenes
  `.claude/commands/` geöffnet wurde und Claude Code auf den user-level Mirror
  `~/.claude/commands/` zurückfiel — dieser war seit dem 2025-07-10-Sync nicht mehr
  aktualisiert worden (fehlende neue Commands, veraltete Inhalte u. a. in `sprint.md`,
  verwaistes `agile-coach.md`).
- Sofortmaßnahme: `~/.claude/commands/` einmalig aus `.claude/commands/` neu synchronisiert
  und verwaiste Dateien (`agile-coach.md`, `RELEASENOTES.md`) entfernt.
- `CLAUDE.md`: neuer Abschnitt „User-Level Command-Mirror synchron halten" unter
  Pflege-Pflichten — verpflichtet künftige Änderungen an `.claude/commands/` zu einem
  begleitenden Sync von `~/.claude/commands/`, damit eigenständige Projekt-Repositories nicht
  erneut hinter dem Toolchain-Root zurückfallen.

---

## v4.9 — 2026-08-17

### Geändert

**RV/AR/QA — fünf Health-Check-Prozessverbesserungen aus campaignworld (PC-000005 – PC-000009)**

- Auslöser: `/health-check campaignworld` (Sprints 1–20) identifizierte fünf strukturelle
  Prozesslücken mit belegter, mehrfacher Wiederholung. Alle fünf Vorschläge vom Nutzer
  freigegeben und umgesetzt, zusammen mit dem seit Sprint 9 offenen `PC-000001`.
- `toolchain/agents/reviewer-agent.md` (v2.0 → v2.1):
  - `PC-000001`: neuer "Vorab-Selbstcheck" vor Phase 0 — prüft, ob die geladene
    Command-Vorlage alle erwarteten Phasen vollständig enthält.
  - `PC-000005`: Dimension "Sicherheit" (Phase B) um einen verpflichtenden Coverage-Check
    ergänzt — listet über `codebase-memory` alle Aufrufstellen eines Guard-Musters, nicht nur
    die im Diff geänderte Stelle. Adressiert die häufigste BLOCKER-Kategorie des gesamten
    Projekts (u. a. RV-000010, RV-000016, RV-000017, RV-000019).
  - `PC-000007`: Nutzer-Interview (Phase A) um einen Wiederholungs-Check gegen
    `DECISIONS.md`/frühere RV-Dokumente ergänzt — bei zweiter thematischer Wiederholung
    verpflichtend eine BA-Story vorschlagen (macht eine bereits in `RETRO-000002` benannte,
    unimplementierte Beobachtung wirksam).
- `toolchain/agents/architect-agent.md` (v1.2 → v1.3): `PC-000006` — neuer
  Zweitflächen-Check vor ADR-Erstellung bei UI-/Navigations-Stories (`codebase-memory`
  `search_graph`/`get_architecture`), verhindert die zweimal aufgetretene "übersehene zweite
  Oberfläche" (Sprint 14 `ADR-000011`, Sprint 20 `RV-000020`).
- `toolchain/agents/qa-agent.md` (v1.0 → v1.1):
  - `PC-000008`: neue Entscheidungsregel für scope-fremde BLOCKER in `/test-run` — QA legt die
    Scope-Frage explizit dem Nutzer vor, statt sie selbst zu entscheiden oder CONDITIONAL
    unentschieden stehen zu lassen.
  - `PC-000009`: verpflichtende isolierte Re-Verifikation, bevor ein E2E-Fehlschlag als
    "Ressourcenkontention" abgewertet wird, statt als BUG-NNNNNN erfasst zu werden — diese
    Erklärung tauchte in 10 von 21 campaignworld-Testberichten auf.
- `toolchain/agents/agents_summary.md` entsprechend nachgezogen (AR/QA/RV-Abschnitte).
- Auswirkung: Alle fünf Änderungen sind rein additiv zu bestehenden Phasen-Workflows — kein
  neuer Command, kein neuer Agent, keine Breaking Changes an Artefaktformaten.

---

## v4.8 — 2026-08-17

### Neu

**Decompose-Modus (AR) + `/decompose` — Kopplungs-/Grenzenanalyse für Service-Aufspaltung**

- Lücke: Kein bestehender Agent prüfte, wo Bestandscode zu monolithisch gewachsen ist und
  sich sinnvoll in eigenständige Services aufspalten ließe — `/converge` prüft nur
  Spec-Abdeckung/Drift, `/architect` trifft die Microservices-vs-Monolith-Entscheidung nur
  für neue Projekte auf Basis von Requirements, nicht rückwirkend anhand tatsächlicher
  Kopplungsdaten.
- Neuer dritter Modus im bestehenden Architect-Agent (AR) — kein neuer Agent, kein neues
  Projekt-Unterverzeichnis, `architecture/` wird mitgenutzt (analog Converge/Spike):
  `toolchain/agents/architect-agent.md` um `### Decompose-Modus (\`/decompose\`)` ergänzt
  (SCAN → ANALYZE → DRAFT → REPORT), inkl. Inputs-/Outputs-Zeile, Übergabeprotokoll-Verweis
  und eigener Definition-of-Done-Checkliste.
- Der Decompose-Modus führt eine reine Kopplungs-/Kohäsionsanalyse durch — kein Abgleich
  gegen Spezifikation. Methodik neu eingeführt (bislang kein Kopplungs-Vokabular in der Tool
  Chain): `get_architecture` mit `aspects: clusters,boundaries,layers` (Leiden-Clustering,
  Cohesion-Score) für de-facto-Module, `search_graph` mit `min_degree`/`max_degree` für
  Fan-in/Fan-out-Hotspots, `query_graph` (Cypher) für Cross-Cluster-Kopplung und zyklische
  Abhängigkeiten. Jeder Cluster wird explizit als **Kandidat** oder **Noch nicht bereit**
  eingestuft — nie "es kommt darauf an".
- Abweichend vom Converge-Muster (nur Empfehlung, ADR separat) liefert der Bericht pro
  Kandidat direkt einen vollständigen ADR-Entwurf (Status `DRAFT`, Struktur wie
  `architecture-decision.md`) — bindend wird er erst durch Ratifizierung via `/architect`.
- Neuer Ad-hoc-Command `/decompose [projektname] [pfad-optional]`
  (`.claude/commands/decompose.md`), neuer Workflow `toolchain/workflows/decompose.md`
  (SCAN → ANALYZE → DRAFT → REPORT, kein Phasenwechsel), neues Template
  `toolchain/templates/decomposition-analysis.md`, neuer Artefakt-Präfix `DCP-NNNNNN`
  (kein neuer Projekt-Unterordner nötig).
- `CLAUDE.md` (Agenten-Rollen, Orchestrierungs-Commands, Workflows-Tabelle,
  Artefakt-Benennung, Projektordner-Struktur, Codebase-Intelligenz „Genutzt von"),
  `toolchain/agents/INDEX.md`, `toolchain/agents/_base-agent.md`,
  `toolchain/workflows/INDEX.md`, `toolchain/templates/INDEX.md`,
  `projects/_template/.toolchain.yml` sowie alle drei `*_summary.md`-Dateien entsprechend
  ergänzt.
- Codex-Kompatibilitätsschicht additiv erweitert: `.codex/agents/architect.toml`
  (`developer_instructions` nennt jetzt explizit alle vier Command-Dateien — schließt
  dabei nebenbei eine bereits bestehende Lücke, `converge.md` war dort nie genannt),
  `.agents/skills/coding-toolchain/SKILL.md`, `projects/_template/.agents/skills/
  coding-toolchain/SKILL.md` und `toolchain/scripts/validate-codex-compat.ps1`
  (Command `decompose` ergänzt — kein neues Agent-Mapping nötig, AR ist bereits
  registriert).
- Auswirkung: Projekte können jetzt gezielt prüfen, ob und wo sich ein gewachsener
  Monolith mit belegter Kopplungs-/Kohäsionsanalyse in Services aufspalten lässt, und
  erhalten dafür direkt einen ratifizierbaren ADR-Entwurf statt nur einer vagen
  Empfehlung — ohne die Trennung zwischen Befund und bindender Entscheidung aufzugeben.

## v4.7 — 2026-08-16

### Neu

**Konsolidierungs-Agent (CN) + `/harden` — Hardening/Dead-Code-Removal für Bestandscode**

- Lücke: Kein bestehender Agent führte eine repo-weite Härtungsrunde durch — RV
  (`/review`) prüft nur den Sprint-Diff, AR (`/converge`) liefert nur einen Report ohne
  Fix, DEBT-Einträge akkumulieren ohne erzwungenes Payback-Gate.
- Neuer Agent `toolchain/agents/consolidator-agent.md` (CN — Consolidator): scannt
  Bestandscode über `codebase-memory` auf toten Code, Duplikate und unnötige Komplexität,
  wendet nur beweisbasiert (0 Aufrufer projektweit) und risikoarm eingestufte Fixes direkt
  an, mit Git-Sicherheitsnetz (nur auf sauberem Tree, ein einzelner ungepushter Commit)
  und Test-Gate vor/nach den Änderungen. Mehrdeutige Funde werden nicht angefasst, sondern
  als `DEBT-NNNNNN` vorgeschlagen.
- Neuer Ad-hoc-Command `/harden [projektname] [pfad-optional]` (`.claude/commands/harden.md`),
  neuer Workflow `toolchain/workflows/harden.md` (SCAN → PLAN → HARDEN → VERIFY → REPORT,
  kein Phasenwechsel — analog `/converge`/`/spike`), neues Template
  `toolchain/templates/consolidation-report.md`, neuer Artefakt-Präfix `CNS-NNNNNN` und
  neuer Projekt-Unterordner `consolidation/`.
- `CLAUDE.md` (Agenten-Rollen, Orchestrierungs-Commands, Artefakt-Benennung,
  Projektordner-Struktur, Workflows-Tabelle), `toolchain/agents/INDEX.md`,
  `toolchain/agents/_base-agent.md`, `toolchain/workflows/INDEX.md`,
  `toolchain/templates/INDEX.md`, `projects/_template/.toolchain.yml` sowie alle drei
  `*_summary.md`-Dateien entsprechend ergänzt.
- Codex-Kompatibilitätsschicht additiv erweitert: `.codex/agents/consolidator.toml`,
  `.codex/config.toml` (`[agents.consolidator]`), `AGENTS.md`, `.agents/skills/coding-toolchain/SKILL.md`
  und `toolchain/scripts/validate-codex-compat.ps1` (Command `harden` und Agent-Mapping
  `consolidator` ergänzt).
- Projektvorlage nachgezogen: `projects/_template/consolidation/.gitkeep` ergänzt, analog zu
  den bestehenden Platzhaltern für `architecture/`, `discovery/`, `retros/` etc. — jedes neue
  Projekt hat den Unterordner ab Anlage bereit, statt dass ihn CN erst bei erstem `/harden`
  selbst anlegen muss.
- `AUDIOSCRIPT.md` (NotebookLM-Quelldokument) nachgezogen: Abschnitt 4 zählt jetzt zwölf statt
  elf Rollen und beschreibt den Consolidator; neuer Abschnitt 5.5 „Wenn Bestandscode aufräumen
  soll — Harden" zwischen Converge und Hotfix (Folgeabschnitte umnummeriert auf 5.6–5.8);
  Abschnitt 10 (Vorteile) erwähnt Harden neben Hotfix/Spike/Converge als weiteren
  abgekürzten, aber strukturierten Weg.
- Auswirkung: Projekte können jetzt jederzeit — insbesondere vor einem Release — eine
  kontrollierte Hardening-Runde anstoßen, die tote Code-Pfade tatsächlich entfernt statt
  sie nur als technische Schuld zu protokollieren, ohne den bestehenden Diff-Review- oder
  Gap-Analyse-Scope zu verwässern. Die Doku-Basis (Codex-Adapter, NotebookLM-Skript,
  Projektvorlage) zieht vollständig mit, statt nachträglich inkonsistent zu bleiben.

## v4.6 — 2026-08-12

### Behoben

**3D-Graph-Visualisierung (`codebase-memory`-MCP) unter `http://localhost:9749` nicht erreichbar**

- Ursache: Windows reserviert TCP-Port 9749 dynamisch für Hyper-V/WSL-NAT (Bereich
  `9712–9811`, sichtbar über `netsh int ipv4 show excludedportrange protocol=tcp`). Der
  UI-Server der gepinnten Binary konnte den Port dadurch nie binden
  (`ui.unavailable port=9749 reason=in_use`), ohne dass dies in `netstat`/
  `Get-NetTCPConnection` sichtbar wurde — der Port erschien frei, war es aber nicht.
- `.mcp.json`: `codebase-memory`-Server-Argument `--port=9749` auf `--port=8749` geändert.
- `CLAUDE.md` (Abschnitt „Codebase-Intelligenz (MCP `codebase-memory`)"): URL-Referenzen auf
  `8749` aktualisiert, neuer Absatz „Portwahl 8749 statt 9749" mit Erklärung und optionalem
  `netsh`-Reservierungsbefehl für dauerhaften Schutz vor künftigen Hyper-V-Portkonflikten.
- Auswirkung: 3D-Graph-UI ist nach Neustart der Claude-Code-Session (MCP-Server-Neustart)
  unter `http://localhost:8749` erreichbar. Betroffene Nutzer sollten laufende
  `codebase-memory-mcp*`-Prozesse beenden, damit sie mit dem neuen Port neu starten.

## v4.5 — 2026-08-08

### Behoben

**Phase 10 (Release) führte keinen GitHub-Board-Sync aus — Board blieb nach `/manual` auf einem Zwischenstand stehen**

- `toolchain/workflows/full-sprint.md`: Die allgemeine Board-Sync-Regel ("jeder Phasen-Agent
  synct an Anfang/Ende") deckt `/manual` (Gate 9) ab, aber das Status-Mapping setzt `Done`
  explizit erst "nach Gate 9" — der tatsächliche `RELEASED`-Zustand (Merge+Tag+Push) entsteht
  erst in Phase 10, die keinen eigenen Slash-Command hat und dadurch in der Praxis vom
  Board-Sync übersprungen wurde. In `campaignworld` Sprint 17+18 dadurch beobachtet: Board
  zeigte nach abgeschlossenem `/manual` weiterhin `In Review`, obwohl die Dokumentation
  bereits fertig war.
- Release-Checkliste um Schritt 0 (`github-board-sync -Mode reconcile`, vor dem Merge) und
  Schritt 8 (`github-board-sync -Mode push`, NACH `.phase`/`REGISTRY.md`-Aktualisierung —
  bewusst so spät, damit der Sync den finalen `RELEASED`-Stand liest, nicht einen
  Zwischenstand) ergänzt. Beide Schritte nur, wenn `github.enabled: true` in
  `.toolchain.yml`. Gate 10 um ein entsprechendes MAJOR-Kriterium ergänzt.
- Schritt 8 unterliegt derselben Bestätigungspflicht wie Schritt 4 (`git push`) — schreibt
  gegen geteilten, externen Zustand (GitHub), auch wenn es sich nur um Issue-Metadaten statt
  Code handelt.

**Betroffene Dateien:** `toolchain/workflows/full-sprint.md`

**Auswirkung:** Projekte mit aktiviertem GitHub-Board-Sync (`github.enabled: true`) sehen den
Board-Stand künftig auch nach einem tatsächlichen Release (Phase 10) korrekt auf `Done`
aktualisiert, statt auf dem `/manual`-Zwischenstand hängen zu bleiben.

---

## v4.4 — 2026-08-04

### Behoben

**GitHub-Board `Iteration`-Feld wurde nie befüllt — zwei unabhängige Bugs (`IMPD-000001`, `campaignworld`)**

- `toolchain/scripts/github-board-sync.ps1`/`.sh`: `gh project field-list` liefert für ein
  `ProjectV2IterationField` — anders als für Single-Select-Felder mit `.options` — keine
  `configuration.iterations`/`completedIterations`. Die bisherige Iteration-Auflösung griff
  auf dieses (nie vorhandene) Datenfeld zu und lieferte seit Einführung in `v4.0` immer
  `null`, ohne Warnung. Behoben durch einen zusätzlichen `gh api graphql`-Aufruf direkt gegen
  die Feld-ID.
- Zusätzlich gefunden während des Fixes: eine PowerShell-Variable `$config` überschrieb
  case-insensitiv den Funktionsparameter `$Config` in `Get-BoardContext`, wodurch
  `item-list`/Milestone-Auflösung ab dem Iteration-Block still fehlschlugen. Behoben durch
  Umbenennung (`$iterConfiguration`).
- Die Sprint-Nr.-zu-Zyklus-Zuordnung war zusätzlich strukturell falsch: sie behandelte
  `iteration: N` als 1-basierten Array-Index über alle materialisierten Board-Zyklen
  („Sprint N → N-ter Zyklus"), was voraussetzt, dass Board-Zyklen exakt ab Sprint 1
  durchnummeriert sind. Boards werden aber oft später oder wiederverwendet provisioniert
  (siehe `github-board-sync.md` „Ein Board pro Projekt") — die Zuordnung ist jetzt
  datumsbasiert: `iteration-start-date`/`iteration-start-sprint`/`iteration-length-days`
  übersetzen die Sprint-Nr. in ein Zieldatum, das gegen die tatsächlichen
  `[startDate, startDate+duration)`-Fenster der Zyklen gematcht wird (best-effort
  nächstliegender Zyklus außerhalb des materialisierten Bereichs, mit Warnung).
- `projects/_template/.toolchain.yml`: neuer Config-Key `github.iteration-start-sprint`
  (Default `1`) neben den bestehenden `iteration-length-days`/`iteration-start-date`.
- `toolchain/protocols/github-board-sync.md`: neuer Abschnitt „Iteration-Feld" dokumentiert
  die GraphQL-Notwendigkeit und die datumsbasierte Zuordnung inkl. Anker-Konfiguration.
- Auswirkung: Das Iteration-Feld auf einem GitHub-Project-Board kann jetzt tatsächlich
  befüllt werden — vorher war es unabhängig vom Frontmatter-Wert immer leer, unabhängig
  davon, welches Projekt/Board betroffen war (kein campaignworld-spezifischer Bug, sondern
  ein Tool-Chain-weiter). Projekte mit bereits laufendem Sync müssen `github.iteration-
  start-sprint` einmalig auf den Sprint setzen, ab dem ihr Board-Iteration-Feld tatsächlich
  zu laufen begann (siehe `IMPD-000001`/`PC-000003` in `projects/campaignworld/retros/` als
  Referenzbeispiel für die Diagnose und das konkrete Vorgehen).

---

## v4.3 — 2026-08-03

### Behoben

**`Get-BoardStatus`/`board_status_for` setzte bei JEDEM Phasenwechsel den Board-Status ALLER `US-NNNNNN` zurück, nicht nur der Story des laufenden Sprints**

- Ursache: Der Status einer `US-NNNNNN` wird nicht aus einem eigenen Story-Feld abgeleitet,
  sondern aus der globalen `.phase`-Datei (`current-phase`). Diese Datei beschreibt aber den
  Projektzustand insgesamt, nicht den Zustand jeder einzelnen Story — beim ersten
  produktiven `/refine`-Lauf (Sprint 16) wurden dadurch alle 37 bereits abgeschlossenen
  Stories aus den Sprints 1–14 fälschlich von `Done` auf `Backlog` zurückgesetzt, weil
  `current-phase` global auf `REFINEMENT` stand.
- `toolchain/scripts/github-board-sync.ps1`/`.sh`: `Get-BoardStatus`/`board_status_for`
  (US-Fall) leitet den Status jetzt nur noch dann aus `current-phase` ab, wenn das
  Story-eigene `sprint`-Feld mit dem aktuell laufenden Sprint (`.phase` Feld `sprint`)
  übereinstimmt — sonst wird das Status-Feld für diesen Lauf unangetastet gelassen
  (`$null`/leerer String, `Set-BoardFieldValue`/`set_board_field_value` überspringen das
  Update wie bei jedem anderen leeren Wert). `reconcile` überspringt den Konfliktabgleich
  ebenfalls, wenn kein Zielstatus abgeleitet werden konnte.
- **Schaden auf dem produktiv genutzten `campaignworld`-Board manuell korrigiert:** Alle 36
  betroffenen Issues (#1–16, #18–37) per `gh project item-edit` zurück auf `Done` gesetzt;
  `US-000017` (tatsächlich Sprint-16-Story) korrekt bei `Backlog`/`Todo` belassen.
- Auswirkung: `/refine`, `/implement`, `/test-plan` etc. können künftig beliebig oft
  Phasenwechsel durchlaufen, ohne den Board-Status bereits abgeschlossener Stories aus
  früheren Sprints zu verfälschen — nur die Story(s), deren `sprint`-Feld tatsächlich dem
  aktuell laufenden Sprint entspricht, folgt der phasenabgeleiteten Status-Logik.

---

## v4.2 — 2026-08-03

### Neu

**Status-Feld-Alias-Fallback + campaignworld-Board-Konsolidierung**

- `toolchain/scripts/github-board-sync.ps1`/`.sh`: Neue Alias-Auflösung für das `Status`-
  Feld (`Resolve-StatusOptionId`/`resolve_status_option_id`). Boards mit nur den
  GitHub-Standardoptionen (`Todo`/`In Progress`/`Done`, ohne `Backlog`/`In Review`) erhalten
  jetzt trotzdem ein sinnvolles Status-Update statt eines stumm übersprungenen (`Backlog`→
  `Todo`, `In Review`→`In Progress`, jeweils mit weiteren Alias-Stufen). `resolve_option_id`
  (Bash) vergleicht Optionsnamen jetzt zusätzlich case-insensitiv (`ascii_downcase`), da
  manche Boards Standardoptionen mit abweichender Schreibweise mitbringen (z. B.
  "In progress" statt "In Progress").
- `projects/campaignworld/.toolchain.yml`: `github.project-number` von `3` auf `2`
  geändert. Ursache: Beim ersten `/kickoff`-Nachtrag war unbekannt, dass GitHub für dieses
  Repo bereits automatisch ein repo-verlinktes Standard-Board ("@campaignworld Kanban",
  Projekt #2, mit Auto-Add-Workflow für neue Issues) angelegt hatte. Der Sync verwaltete
  bis hierhin ein zweites, separat erstelltes Board (#3), während #2 durch den GitHub-
  eigenen Auto-Add-Mechanismus parallel und unkontrolliert befüllt wurde — jedes Issue
  landete dadurch auf zwei Boards, aber nur eines (#3) hatte je gepflegte Custom-Field-
  Werte, was in der GitHub-UI wie ein komplett ungepflegtes Board aussah, je nachdem
  welche der beiden Projekt-Karten man aufklappte.
- Projekt #3 ("campaignworld", separat erstelltes Board) gelöscht — Board #2 ist jetzt das
  einzige und alleinig gepflegte Board für `campaignworld`. #2 bringt bereits ein
  vollständiges Custom-Field-Set aus dem GitHub-Kanban-Template mit, inklusive eines
  funktionierenden `Iteration`-Feldes (das auf #3 mangels `gh`-CLI-Unterstützung für
  `--data-type ITERATION` nicht anlegbar war) — die in v4.1 dokumentierte Einschränkung
  entfällt dadurch für `campaignworld`.
- Auswirkung: Ein produktiv genutztes Repo kann bereits ein repo-verlinktes Standard-Board
  mit Auto-Add-Workflow haben, bevor `/kickoff` ein eigenes Board provisioniert — die
  Provisionierung sollte künftig zuerst `gh api graphql` gegen
  `repository.projectsV2` prüfen, ob bereits ein repo-verlinktes Board existiert, und
  dieses vorschlagen statt blind ein neues über `gh project create` anzulegen (noch nicht
  in `pm-agent.md`/`github-board-sync.md` nachgezogen — vorerst nur für `campaignworld`
  manuell korrigiert, siehe TODO unten).

### TODO (nicht in diesem Release)

- `toolchain/agents/pm-agent.md` Board-Provisionierung sollte vor `gh project create`
  prüfen, ob das Ziel-Repo bereits ein repo-verlinktes GitHub-Project (v2) Board hat
  (`gh api graphql` gegen `repository.projectsV2`), und dieses zur Wiederverwendung
  vorschlagen, statt automatisch ein zweites, unverlinktes Board anzulegen.

---

## v4.1 — 2026-08-03

### Neu

**Nachziehen des v4.0-Gesamtscopes: Blocks/Blocked-by-Relationships implementiert, campaignworld nachprovisioniert**

- `toolchain/scripts/github-board-sync.ps1`/`.sh`: v4.0 hatte die "Blocks/Blocked-by"-
  Relationship in Protokoll und Doku angekündigt, aber in den Skripten noch nicht
  implementiert. Neue Funktionen `Sync-IssueDependencies`/`sync_issue_dependencies` parsen
  die `## Abhängigkeiten`-Tabelle einer `US-NNNNNN` ("Blockiert durch"/"Blockiert" +
  Referenz), lösen die referenzierte Artefakt-ID auf ihre `github-issue`-Nummer auf und
  verknüpfen best-effort über `gh api .../issues/<n>/dependencies/blocked_by`. Schlägt der
  API-Aufruf fehl (Beta-Feature, nicht auf jedem Plan/Repo verfügbar): stiller Abbruch, der
  bereits bestehende Text-Fallback im Issue-Body bleibt in jedem Fall bestehen.
- `projects/campaignworld/.toolchain.yml`: `github`-Block nachgezogen auf das aktuelle
  Schema — `synced-artifacts` um `EPIC` ergänzt, `iteration-length-days`/
  `iteration-start-date` ergänzt (fehlten, weil das Board vor der v4.0-Erweiterung
  provisioniert wurde).
- GitHub-Project-Board von `campaignworld` (Board #3) nachträglich um die in v4.0
  spezifizierten Custom Fields ergänzt: `Estimate` (Number), `Size`, `Priority` (Single
  Select), `Start date`, `Target date` (Date) erfolgreich angelegt. `Iteration` (Iteration-
  Typ) ließ sich über `gh project field-create` NICHT anlegen — die installierte
  `gh`-CLI-Version (2.94.0) unterstützt `ITERATION` nicht als `--data-type`-Wert für diesen
  Befehl. Genau der in `github-board-sync.md` Abschnitt "Fehlertoleranz" vorgesehene Fall:
  Iteration-Feld-Updates werden vom Sync-Skript übersprungen und als Warnung vermerkt,
  nichts blockiert.
- Auswirkung: Der in v4.0 dokumentierte Gesamtscope ist jetzt tatsächlich lückenlos
  implementiert (bis auf die extern limitierte Iteration-Feld-Anlage), und das erste real
  genutzte Projekt (`campaignworld`) ist auf den aktuellen Konfigurations-/Board-Stand
  gebracht statt auf dem Stand vor v4.0 zu verharren.

### Behoben

**Zwei Regressionen, durch die v4.0-Skript-Neufassung (unabhängig von der vorherigen
v3.1-Bugfix-Version) erneut eingeführt:**

- `Test-GhReady` (`github-board-sync.ps1`): Die v3.1-Korrektur (`-join "`n"` vor dem
  Scope-Test, siehe dortiger Eintrag) war in der v4.0-Neufassung des Skripts nicht mehr
  enthalten — vermutlich weil die Neufassung auf einer älteren Zwischenversion aufsetzte.
  `$status -notmatch 'project'` prüfte dadurch wieder elementweise über ein Zeilen-Array
  statt über den Gesamttext und meldete fälschlich fehlenden `project`-Scope, obwohl
  vorhanden — Sync brach bei jedem Lauf sofort ab. Erneut auf `-join "`n"` vor dem Test
  umgestellt.
- `Sync-DebtRegistry`/`sync_debt_registry`: Die Header-Erkennung (`^\|\s*ID\s*\|`) traf auf
  JEDE Tabelle mit einer "ID"-Spalte — in `DEBT-REGISTRY-campaignworld.md` existieren zwei
  solche Tabellen: die aktiv getrackte Registry (mit `Status`-Spalte) und eine separate
  "## Erledigte Schulden"-Verlaufstabelle (nur `ID`/`Titel`/`Resolved in`/`Lösung`, ohne
  `Status`). Da die Registry-Tabelle aktuell keine offenen Einträge hat, traf die Erkennung
  stattdessen die Verlaufstabelle und legte für 12 längst `RESOLVED`e historische Schulden
  (`DEBT-000001`–`DEBT-000012`) neue GitHub-Issues an — bei jedem weiteren `push`-Lauf
  erneut, da die Verlaufstabelle keine `GitHub Issue`-Spalte zum Zwischenspeichern hat
  (Issue-Spam ohne Idempotenz). Fix: Header-Erkennung verlangt jetzt zusätzlich eine
  `Status`-Spalte in derselben Zeile. Die 12 fälschlich angelegten Issues (`campaignworld`
  #47–#58) wurden mit Erklärung geschlossen; `DEBT-REGISTRY-campaignworld.md` selbst blieb
  inhaltlich unverändert (Zeilen wurden zwar neu geschrieben, aber mit identischen Werten).
- Auswirkung: Beide Regressionen betrafen ausschließlich den Sync-Pfad (nie ein Gate) und
  sind vor jedem produktiven Nachfolgelauf entdeckt und behoben worden — kein Datenverlust,
  aber ein Hinweis, künftige Full-Rewrites von `github-board-sync.*` auf Basis des
  jeweils aktuellsten Diffs statt einer möglicherweise älteren Zwischenkopie vorzunehmen.

---

## v4.0 — 2026-08-03

### Neu

**Full-Scope-Backlog-Vorausplanung (Epics, Roadmap) + vollständige GitHub-Projects-Feldnutzung**

- Neue Artefakttypen `EPIC-NNNNNN` (`toolchain/templates/epic.md`) und `RM-NNNNNN`
  (`toolchain/templates/roadmap.md`, Roadmap/Release-Plan): BA plant während `/ba` — nach
  Abschluss aller Stories — den **gesamten** Projekt-Scope vor (nicht nur den nächsten
  Sprint): Epics als Gruppierung, Priorität/Schätzung/Size/Iteration/Zeitrahmen für JEDE
  Story im Backlog. `/refine` verfeinert danach nur noch die anstehende Iteration und
  schreibt Ist-Abweichungen zurück in `RM-NNNNNN`, statt die Grobplanung zu ersetzen.
- `toolchain/templates/user-story.md`, `bug-report.md`, `impediment.md`,
  `tech-debt-registry.md`: einheitliche neue Felder `epic`, `estimate`, `size`,
  `iteration`, `start-date`, `target-date`, `github-milestone` — für ALLE synchronisierten
  Issue-Typen, nicht nur User Stories.
- `toolchain/protocols/github-board-sync.md` (v2.0, grundlegend erweitert): Epics werden
  als GitHub-**Milestones** geführt; Board-Felder Estimate/Size/Priority (MoSCoW→P0–P3)/
  Iteration/Start-/Zieldatum werden synchronisiert; Relationships (Epic-Zuordnung,
  Blocks/Blocked-by) best-effort über GitHub-APIs plus garantiertem Text-Fallback im
  Issue-Body; Issue-Body wird bei jedem `push` vollständig aus dem Artefakt gerendert
  (User-Story-Satz, alle Akzeptanzkriterien, Nicht-Ziele, Abhängigkeiten, Metadaten) statt
  des bisherigen Platzhaltertexts.
- `toolchain/scripts/github-board-sync.ps1`/`.sh`: Board-Kontext löst nun alle Custom-Field-
  IDs (Estimate/Size/Priority/Iteration/Start-/Zieldatum) und Milestone-Zuordnungen auf;
  neue Milestone-Sync-Funktion für Epics; vollständiges Issue-Body-Rendering aus den
  "---"-getrennten Template-Abschnitten; DEBT-REGISTRY-Parsing auf spaltennamen-basiert
  (statt positionsfest) umgestellt, damit die zusätzlichen Spalten robust erkannt werden.
  Nebenbei behoben: ein Parser-Bug in `Get-Scalar`/`Set-FrontmatterField` (`$Key:` wurde
  von PowerShell als ungültige Laufwerksreferenz interpretiert — betraf bereits das
  v3.0-Skript, ist jetzt über `${Key}:` korrigiert).
- **GitHub-Board-Sync jetzt in JEDEM Phasen-Command, nicht nur im Sprint-Modus:**
  `/kickoff`, `/ba`, `/ux`, `/refine`, `/implement` (FE+BE, inkl. Bugfix-Modus),
  `/test-plan`, `/test-run`, `/review`, `/manual` führen `reconcile` zu Beginn und `push`
  am Ende jetzt selbstständig aus (`toolchain/agents/*.md`) — unabhängig davon, ob die
  Phase über `/sprint` oder direkt aufgerufen wird. Bisher war dieser Schritt nur in
  `orchestrator.md` (Sprint-Modus) verankert und griff daher nicht bei direktem
  Einzel-Command-Aufruf.
- **Bugs/Tech-Schulden aus der Umsetzung jetzt Epic-verknüpft:** QA (`/test-run`, neue
  `BUG-NNNNNN`) und RV (`/review`, neue `DEBT-NNNNNN`) übernehmen das `epic`-Feld der
  auslösenden Story, damit sie beim Sync demselben GitHub-Milestone zugeordnet werden statt
  unverknüpft im Board zu landen.
- `pm-agent.md`: Board-Provisionierung legt jetzt zusätzlich die Custom Fields
  (Estimate/Size/Priority/Iteration/Start-/Zieldatum) auf dem Board an.
- `CLAUDE.md` (Artefakt-Tabelle, Ordnerstruktur), `projects/_template/.toolchain.yml`
  (`github.synced-artifacts` um `EPIC` erweitert, neue Keys `iteration-length-days`/
  `iteration-start-date`), `commands_summary.md`, `agents_summary.md`,
  `templates_summary.md`, `templates/INDEX.md`, `protocols/INDEX.md`, `scripts/INDEX.md`:
  konsistent aktualisiert.
- Auswirkung: Projekte planen ihren Backlog beim Setup vollständig voraus statt nur
  sprintweise, und dieser Plan landet — sofern das Board aktiviert ist — vollständig samt
  Meilensteinen, Schätzungen, Iterationen und lesbaren Issue-Beschreibungen auf GitHub,
  unabhängig davon, welcher einzelne Phasen-Command gerade läuft. Ohne Opt-in
  (`github.enabled: true`) ändert sich am bestehenden Verhalten nichts.
- Versioniert als v4.0 (Major) — grundlegende Erweiterung, die praktisch jeden
  Phasen-Agenten und mehrere Templates gleichzeitig betrifft.

---

## v3.0 — 2026-08-03

### Neu

**Optionaler GitHub-Project-Board-Sync (`US`/`BUG`/`DEBT`/`IMPD` ↔ GitHub Issues)**

- `toolchain/protocols/github-board-sync.md` (neu, `PROTO-GITHUB-BOARD`): Vollständiges
  Protokoll für additiven, opt-in Sync zwischen Tool-Chain-Artefakten und einem GitHub
  Project (v2) Board — Geltungsbereich, ID-Zuordnung (`github-issue`-Feld), zwei Sync-Modi
  (`push`/`reconcile`), Status-Mapping, Provisionierung, Auth-Modi (`gh-cli`/`env-var`),
  Fehlertoleranz (best-effort, blockiert nie ein Gate). Tool-Chain-Gates bleiben immer die
  alleinige fachliche Quelle der Wahrheit — das Board ist reine Ansicht.
- `toolchain/scripts/github-board-sync.ps1` / `.sh` (neu): Ausführbare Implementierung für
  Windows/PowerShell und Bash. Löst die für `gh project item-edit` nötigen GraphQL-Node-IDs
  (Projekt-ID, Status-Feld-ID, Status-Options-ID, Board-Item-ID) zur Laufzeit über
  `gh project view/field-list/item-list` auf, statt Klartextnamen oder die Issue-Nummer
  direkt zu übergeben — reine Namens-/Nummernübergabe an diese `gh`-Flags schlägt fehl, da
  sie Node-IDs erwarten.
- `toolchain/agents/orchestrator.md`: Ruft `reconcile` vor und `push` nach jeder Phase auf
  (Schritt 0 und 3e), sofern `github.enabled`; übersprungene Läufe werden im Statusbericht
  vermerkt, nie gate-blockierend.
- `toolchain/agents/pm-agent.md`, `.claude/commands/kickoff.md`: `/kickoff` fragt nach
  Runde 5 explizit, ob ein Board gewünscht ist, und provisioniert es bei Zustimmung
  (`gh project create`, `.toolchain.yml` befüllen).
- `toolchain/workflows/full-sprint.md`: Abschnitt „GitHub-Board-Sync" mit Geltungsbereich
  und Aktivierungshinweis ergänzt.
- `toolchain/templates/user-story.md`, `bug-report.md`, `impediment.md`,
  `tech-debt-registry.md`: `github-issue`-Feld (Frontmatter bzw. Tabellenspalte) ergänzt.
- `projects/_template/.toolchain.yml`: Neuer `github:`-Block (`enabled`, `repo`,
  `project-number`, `auth-mode`, `auth-env-var`, `synced-artifacts`), Default
  `enabled: false` — bestehende Projekte sind unberührt, bis explizit aktiviert.
- `.claude/commands/commands_summary.md`, `toolchain/agents/agents_summary.md`,
  `toolchain/protocols/INDEX.md`, `toolchain/scripts/INDEX.md`: konsistent aktualisiert.
- Auswirkung: Projekte können ihr Backlog optional in einem echten GitHub Project Board
  sichtbar machen, ohne dass GitHub zur zweiten Quelle der Wahrheit wird. Ohne Opt-in
  (`github.enabled: true`) ändert sich am bestehenden Verhalten nichts.

---

## v3.1 — 2026-08-03

### Behoben

**`toolchain/scripts/github-board-sync.ps1` scheiterte bei jedem Aufruf (PowerShell-Parserfehler + falsch-positive Scope-Prüfung)**

- Zwei Vorkommen von `$Key:` in doppelt gequoteten Regex-Strings (`Get-ToolchainConfig` Zeile
  37, `Set-FrontmatterField` Zeile 129) wurden von PowerShell als laufwerksqualifizierte
  Variablenreferenz (`$var:...`) fehlinterpretiert und brachen mit `ParserError` ab, bevor
  überhaupt ein Sync-Schritt lief — auf `${Key}:` umgestellt.
- `Test-GhReady` prüfte den `project`-Scope mit `$status -notmatch 'project'` auf dem
  mehrzeiligen Array-Output von `gh auth status`; `-notmatch` filtert Array-Elemente statt den
  Gesamttext zu testen, wodurch das nicht-leere Ergebnis-Array selbst bei vorhandenem Scope
  immer als "wahr" galt und der Sync fälschlich übersprungen wurde. Fix: Zeilen vor der Prüfung
  mit `-join "`n"` zusammenführen.
- Erkannt beim nachträglichen Provisionieren des Boards für `projects/campaignworld` (erster
  produktiver `push`-Lauf über den Sync-Pfad seit Einführung in v3.0).
- Auswirkung: `-Mode push`/`-Mode reconcile` sind jetzt tatsächlich lauffähig unter Windows/
  PowerShell; zuvor brach jeder Aufruf ab, unabhängig vom Projekt oder Auth-Zustand.

---

## v2.12 — 2026-08-02

### Neu

**`/manual` schließt Sprint verbindlich mit Git-Commit + Push ab**

- `.claude/commands/manual.md`: Neuer Schritt 10 „Git-Abschluss" — nach REGISTRY.md/`.phase`-
  Aktualisierung staged, committed (`feat(sprint-N): ...`) und pusht MW den vollständigen
  Sprint-Stand zum Remote des Projekt-eigenen Repositories. Ausnahme bei erkennbaren
  Fremdständen oder explizitem Nutzerwiderspruch: MW pausiert vor dem Push und fragt nach.
- `toolchain/agents/manual-writer-agent.md`: Vorgehen (Schritt 10–11), Abschluss-Pflicht-Block
  und Übergabeprotokoll um den Git-Abschluss ergänzt.
- `toolchain/workflows/full-sprint.md`: Gate 9 um das Kriterium „Sprint-Stand committed und
  gepusht" (MAJOR) ergänzt; ausdrücklich von Phase 10 (strategischer Merge/Tag gemäß
  Branching-ADR) abgegrenzt — Phase 9 committet/pusht den Sprint-Stand auf dem
  Arbeits-Branch, Phase 10 entscheidet separat über Merge in den Ziel-Branch.
- `.claude/commands/commands_summary.md`, `toolchain/agents/agents_summary.md`: Konsistent
  aktualisiert.
- Auswirkung: Sprint-Arbeit landet ab sofort ohne manuellen Zusatzschritt nach jedem
  `/manual`-Lauf auf GitHub — verhindert das bisherige Muster mehrsprintig uncommitteten
  Stands. Umgesetzt aus campaignworld `RETRO-000002` / `PC-000002` (direkte Nutzeranweisung
  in der Sprint-13-Retrospektive).

---

## v2.11 — 2026-07-31

### Geändert

**Folge-Command bestätigt Vorphasen-Artefakte; Gate 5.5 läuft im Implementierungs-Preflight**

- `toolchain/agents/_base-agent.md`, `toolchain/protocols/artifact-lifecycle.md`,
  `toolchain/protocols/gate-protocol.md`: Ein expliziter, logisch nächster Phasen-Command
  gibt eindeutig zugeordnete `REVIEW`-Artefakte nach bestandenem Gate frei. Offene
  `BLOCKER` oder `MAJOR` stoppen ohne Statusänderung; `.phase` protokolliert Command,
  Freigabequelle sowie Artefakt-IDs.
- `.claude/commands/implement.md`, `.claude/commands/analyze.md`,
  `toolchain/workflows/full-sprint.md`, `toolchain/agents/orchestrator.md`: Gate 5.5 ist
  verpflichtender `/implement`-Preflight. `/analyze` bleibt als optionaler, vorgezogener
  Diagnosebefehl erhalten.
- `toolchain/protocols/gate-protocol.md`: Rückläufe werden anhand konkreter Fund-IDs und
  notwendiger Regressionen geprüft; unbetroffene Phasenteile müssen nicht pauschal
  wiederholt werden.
- `CLAUDE.md`, `toolchain/PROCESS.md`, `toolchain/workflows/INDEX.md`,
  `.claude/commands/commands_summary.md`, `toolchain/agents/agents_summary.md`: Ablauf und
  Zusammenfassungen konsistent aktualisiert.
- Auswirkung: Der Nutzer bestätigt Artefakte und startet die nächste Phase in einer
  Handlung, ohne die Schutzwirkung der Gates zu verlieren. Umgesetzt aus
  `second-brain/PC-000001`.

---

## v2.10 — 2026-07-30

### Geändert

**`/review` benennt den vollständigen Sprint-Inhalt vor dem manuellen Test**
- `.claude/commands/review.md`, `toolchain/agents/reviewer-agent.md`: Der RV-Agent
  präsentiert unmittelbar vor dem Test-Guide eine kompakte, deduplizierte Übersicht aller
  Sprint-User-Stories, Defects und MINOR-Befunde mit kurzer Inhaltsangabe und Status.
  Geplanter Scope stammt aus `SP-NNNNNN`; `TR-NNNNNN` und sprintzugeordnete
  `BUG-NNNNNN` ergänzen im Sprint entstandene Befunde; bei Re-Reviews liefern frühere
  `RV-NNNNNN` desselben Sprints bereits dokumentierte MINOR-Anmerkungen. Leere Gruppen
  werden ausdrücklich als „Keine“ ausgewiesen; auch bereits behobene Sprint-Defects
  bleiben sichtbar.
- `.claude/commands/commands_summary.md`, `toolchain/agents/agents_summary.md`: Ablauf und
  Inputs konsistent nachgezogen.
- Auswirkung: Der Nutzer kennt vor Beginn der manuellen Abnahme den vollständigen
  fachlichen Sprint-Umfang und die relevanten Qualitätsbefunde, ohne die Artefakte selbst
  durchsuchen zu müssen.

---

## v2.9 — 2026-07-30

### Behoben

**Toolchain-Commands sind in eigenständigen Codex-Projektsitzungen auffindbar**
- `projects/_template/.agents/skills/coding-toolchain/SKILL.md` (neu): projektlokaler
  Codex-Skill routet alle 20 kanonischen Commands und löst den Toolchain-Root über
  `.toolchain.yml` auf.
- `projects/_template/AGENTS.md`: dokumentiert die Codex-native Syntax
  `$coding-toolchain /<command>` und die Plattformgrenze für repository-definierte
  Slash-Commands.
- `CLAUDE.md`: additive Codex-Kompatibilitätsübersicht um den projektlokalen Skill und
  dessen Aufrufsyntax ergänzt.
- `toolchain/scripts/validate-codex-compat.ps1`, `toolchain/scripts/INDEX.md`: Validator
  prüft nun den projektlokalen Skill, `toolchain-path` und jede einzelne Command-Route.
- `projects/second-brain/.agents/skills/coding-toolchain/SKILL.md`,
  `projects/second-brain/AGENTS.md`: bestehendes Projekt rückwirkend korrigiert.
- Auswirkung: Eine direkt in einem Projekt-Repository gestartete Codex-Sitzung entdeckt
  die Toolchain jetzt selbst. `/ba` wird in Codex portabel als
  `$coding-toolchain /ba` aufgerufen; natürliche Anfragen können den Skill implizit
  aktivieren.

---

## v2.8 — 2026-07-28

### Neu

**Thinking-Zusammenfassungen standardmäßig sichtbar in allen Projekten**
- `projects/_template/.claude/settings.json` (neu): `alwaysThinkingEnabled`,
  `showThinkingSummaries`, `verbose` auf `true` — wird bei jedem neuen Projekt aus der
  Vorlage übernommen.
- `projects/campaignworld/.claude/settings.json`, `projects/stellaris-mcp/.claude/
  settings.json`: rückwirkend mit denselben drei Keys ergänzt (Bestandsprojekte).
- `CLAUDE.md`: neuer Abschnitt „Thinking-Transparenz" in „Globale Konventionen" —
  dokumentiert die Settings-Keys, ihren Zweck und die Tastenkombinationen zum
  Ausklappen/Lesen der Zusammenfassung in laufenden Sessions (`Ctrl+O`/`Ctrl+E`, `Alt+T`).
- Auswirkung: Nutzerwunsch, dass alle Projekte (nicht nur der Toolchain-Root, wo diese
  Keys bereits gesetzt waren) die Möglichkeit haben, Claude Codes Thinking-Prozess
  einzusehen. Da jedes `projects/<name>/` ein eigenes Git-Repository ist, wirkte die
  bisherige Root-`.claude/settings.json` nicht auf Projekt-Sessions — dieser Fix schließt
  die Lücke strukturell über die Vorlage statt nur punktuell.

---

## v2.7 — 2026-07-28

### Geändert

**Review-Checkliste um worldId-Scoping-Prüfpunkt ergänzt (campaignworld DEBT-000013)**
- `toolchain/templates/review-checklist.md`: Dimension 2 (Sicherheit) um den Prüfpunkt
  „worldId-Scoping pro betroffener Beziehungskette, nicht nur pro Funktion" ergänzt — jede
  Query, die zwei oder mehr per-id referenzierte Entitäten verknüpft, muss beide Seiten gegen
  dasselbe `worldId` prüfen, nicht nur die zuerst genannte.
- `toolchain/templates/templates_summary.md`: RV-Abschnitt entsprechend ergänzt.
- Auswirkung: Das automatisierte `require-server-action-guard`-ESLint-Gate (v2.x, aus
  campaignworld DEBT-000002) prüft nur, ob ein Autorisierungs-Guard überhaupt aufgerufen wird —
  nicht, ob er die fachlich richtige Dimension abdeckt. Ein realer Cross-Tenant-Fund
  (campaignworld K-001/S-001, `RV-000004`) blieb trotz aktivem Gate unentdeckt, weil die
  aufgerufene Prüfung die falsche Scope-Dimension traf. Die Checkliste schließt diese Lücke für
  jedes künftige `/review`, bis eine strukturelle Lösung (z. B. via `codebase-memory`-Traversal)
  entschieden wird.

---

## v2.6 — 2026-07-27

### Neu

**`/review` baut Docker-Container jetzt automatisch neu (Phase 0)**
- `.claude/commands/review.md`: Neue „Phase 0: Container-Refresh" vor dem Test-Guide — falls
  `projects/<name>/docker-compose.yml` existiert, wird `docker compose build app && docker
  compose up -d app` ausgeführt und der Healthcheck abgewartet, bevor der Nutzer zum Testen
  aufgefordert wird. Kein Compose-Setup im Projekt → Phase entfällt ersatzlos.
- `toolchain/agents/reviewer-agent.md` (v2.0 → Phase-0-Ergänzung): Neuer System-Prompt-Block
  „Phase 0: Container-Refresh" mit Vorgehen und Begründung.
- `toolchain/agents/agents_summary.md`, `.claude/commands/commands_summary.md`: RV-Abschnitte
  um Phase 0 ergänzt.
- Auswirkung: Verhindert falsche „Feature fehlt"-Befunde im Nutzer-Interview, wenn der
  Anwendungscontainer seit einem früheren Sprint nicht neu gebaut wurde. Ausgelöst durch einen
  konkreten Vorfall bei campaignworld Sprint 4: Container-Image war vom 2026-07-26, die
  Adventure-UI aus Sprint 4 wurde erst am 2026-07-27 implementiert — der Nutzer fand beim
  manuellen Test kein Adventure-Dropdown, weil er gegen den alten Image-Stand testete.

**3D-Graph-Visualisierung des `codebase-memory`-MCP-Servers aktiviert**
- `.mcp.json`: `codebase-memory`-Server um `"args": ["--ui=true", "--port=9749"]` ergänzt.
- `CLAUDE.md` (Abschnitt „Codebase-Intelligenz (MCP `codebase-memory`)"): neuer Absatz
  „3D-Graph-Visualisierung (optional)" — Zugriff über `http://localhost:9749`, verwaltet vom
  gemeinsamen Coordination-Daemon (keine doppelten HTTP-Server bei parallelen Sessions).
- Auswirkung: Kein separater Build/Download nötig — die installierte npm-Distribution von
  `codebase-memory-mcp` (Version 0.9.0) enthält die Browser-3D-Ansicht bereits als
  Konfigurationsoption; sie war nur nicht aktiviert. Rein explorativ, kein neues Tool und
  keine Änderung an den bestehenden MCP-Tool-Calls.

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
