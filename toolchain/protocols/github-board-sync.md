---
id: PROTO-GITHUB-BOARD
title: GitHub-Projectboard-Sync-Protokoll
version: 2.0
status: ACTIVE
---

# Protokoll: GitHub-Projectboard-Sync

Optionales, additives Feature: Ein Projekt kann sein **gesamtes** Backlog — nicht nur den
laufenden Sprint — inklusive Vorausplanung (Epics, Schätzung, Iteration, Zeitrahmen) und
Story-Status in einem echten GitHub Project (v2) Board spiegeln. Die Tool-Chain-Dateien
(`.phase`, `INDEX.md`, `US-NNNNNN`, `BUG-NNNNNN`, `DEBT-REGISTRY`, `IMPD-NNNNNN`,
`EPIC-NNNNNN`, `RM-NNNNNN`) bleiben die alleinige fachliche Quelle der Wahrheit — das Board
ist eine Ansicht darauf, kein zweiter Entscheider. Ohne `github.enabled: true` in
`.toolchain.yml` passiert nichts; kein Agent greift ungefragt auf GitHub zu.

## Geltungsbereich

Synchronisiert werden ausschließlich die Artefakttypen aus `github.synced-artifacts` in
`.toolchain.yml` (Default: `US`, `BUG`, `DEBT`, `IMPD`, `EPIC`):

| Artefakttyp | Wird als … synchronisiert | Issue/Milestone wird angelegt, wenn … |
|---|---|---|
| `US-NNNNNN` | Issue | immer (Story existiert) |
| `BUG-NNNNNN` | Issue | immer; Schweregrad (`BLOCKER`/`MAJOR`/`MINOR`) wird als Label geführt |
| `DEBT-NNNNNN` (Eintrag in `DEBT-REGISTRY`) | Issue | immer |
| `IMPD-NNNNNN` | Issue | **nur wenn** der Status nach der Erfassung nicht sofort `RESOLVED` ist |
| `EPIC-NNNNNN` | **Milestone** (kein Issue) | immer (Epic existiert) |

`SP-NNNNNN` (Sprint Backlog) wird nicht selbst zum Issue, sondern über das Iteration-Feld
auf den zugehörigen Issues geführt. `RM-NNNNNN` (Roadmap) wird nicht selbst synchronisiert —
es ist die Tool-Chain-interne Quelle, aus der Estimate/Size/Iteration/Start/Ziel für jedes
Issue stammen (siehe "Vorausplanung des Gesamtscopes" unten).

## Vorausplanung des Gesamtscopes (nicht nur der nächste Sprint)

Anders als ein klassisches "nur den nächsten Sprint pflegen"-Board wird beim Sync der
**gesamte** Backlog übertragen, sobald er existiert:

1. BA erstellt während `/ba` — nachdem alle Must/Should/Could-Stories geschrieben sind —
   `EPIC-NNNNNN` (Gruppierung) und `RM-NNNNNN` (Roadmap/Release-Plan), die JEDE Story/jeden
   Bug/jede Tech-Schuld/jedes Impediment im Gesamtscope mit Priorität, Schätzung, Size,
   geplanter Iteration und Start-/Zieldatum versieht (siehe `toolchain/templates/roadmap.md`).
2. Diese Werte werden in die Frontmatter-Felder (`epic`, `estimate`, `size`, `iteration`,
   `start-date`, `target-date`) der einzelnen Artefakte übernommen.
3. Der erste `push`-Lauf nach Gate-PASS von `/ba` synchronisiert dadurch automatisch **alle**
   Epics und Stories des Gesamtscopes — nicht nur die des ersten Sprints — inklusive Board-
   Feldern und Milestones. Es ist kein separater Command nötig; `Sync-Artifact`/
   `sync_artifact` iteriert ohnehin über alle vorhandenen Dateien je Artefaktordner,
   unabhängig davon, welchem Sprint sie zugeordnet sind.
4. `/refine` (pro Sprint) verfeinert danach nur die Stories der anstehenden Iteration
   (Subtasks, Ist-Aufwand) und schreibt Abweichungen in `RM-NNNNNN` zurück — die
   Grobplanung wird dadurch präzisiert, nicht ersetzt. Ein Sync-Lauf nach `/refine`
   überträgt die aktualisierten Werte wie jede andere Änderung.

## ID-Zuordnung

Jedes synchronisierte Artefakt trägt die Issue- bzw. Milestone-Nummer im Feld
`github-issue` bzw. `github-milestone` (Frontmatter bei `US`/`BUG`/`IMPD`/`EPIC`, eigene
Spalte bei `DEBT-REGISTRY`). Ein Sync-Lauf legt ein Issue/Milestone **nur an, wenn das Feld
leer (`—`) ist** — sonst wird das bestehende Issue/Milestone über seine Nummer editiert.
Diese Regel verhindert Duplikate bei wiederholtem Sync. Stories/Bugs/Schulden/Impediments,
die auf ein Epic einzahlen, tragen dessen `github-milestone`-Nummer gespiegelt in ihrem
eigenen `github-milestone`-Feld (rein informativ — `gh issue edit --milestone` setzt die
tatsächliche Zuordnung serverseitig).

## Board-Felder

Neben `Status` (siehe bestehendes Status-Mapping unten) verwaltet der Sync folgende
GitHub-Projects-(v2)-Felder, sofern sie im Frontmatter des Artefakts gesetzt sind:

| Frontmatter-Feld | GitHub-Projects-Feld | Typ | Werte |
|---|---|---|---|
| `estimate` | `Estimate` | Number | Story Points (Fibonacci: 1/2/3/5/8/13) |
| `size` | `Size` | Single select | `XS`/`S`/`M`/`L`/`XL` |
| `priority` (US) / `severity` (BUG) | `Priority` | Single select | `P0`–`P3`, siehe Mapping unten |
| `iteration` | `Iteration` | Iteration | Geplante Sprint-Nr. → nächstliegender Iterationszyklus |
| `start-date` | `Start date` | Date | `YYYY-MM-DD` |
| `target-date` | `Target date` | Date | `YYYY-MM-DD` |
| `epic` / `github-milestone` | `Milestone` | nativ (Issue-Ebene, kein Projekt-Custom-Field) | Repo-Milestone-Titel |

**Priority-Mapping (MoSCoW → P0–P3):**

| Tool-Chain-Wert | Board-Wert |
|---|---|
| `Must` (US) / `BLOCKER` (BUG) | `P0` |
| `Should` (US) / `MAJOR` (BUG) | `P1` |
| `Could` (US) / `MINOR` (BUG) | `P2` |
| `Won't` | `P3` |

Fehlt ein Feld im Frontmatter (`—` oder leer), wird das entsprechende Board-Feld beim Sync
übersprungen — kein Fehler, kein leerer Overwrite.

## Relationships

- **Epic ↔ Story/Bug/Schuld/Impediment:** wird best-effort als GitHub-**Sub-Issue**
  (`gh api repos/<repo>/issues/<epic-issue>/sub_issues`) angelegt, sofern das Epic
  ausnahmsweise zusätzlich als Issue geführt wird; da Epics primär als Milestone
  abgebildet werden, ist die verlässliche Verknüpfung die Milestone-Zuordnung
  (`gh issue edit --milestone`). Sub-Issues sind ein optionales Extra, kein Ersatz.
- **Blocks / Blocked by** (aus der `Abhängigkeiten`-Tabelle in `US-NNNNNN`, analog bei
  `BUG`/`IMPD`): wird best-effort über die GitHub-Issue-Dependencies-API verknüpft. Diese
  API ist nicht auf jedem Plan/Repo verfügbar — schlägt der Aufruf fehl, wird er
  stillschweigend übersprungen (kein Fehler, kein Gate-Einfluss).
- **Garantierter Fallback:** unabhängig vom API-Erfolg wird jede bekannte Relationship
  (Epic, Blocks, Blocked by) IMMER als lesbarer Abschnitt in den Issue-Body geschrieben
  (siehe "Issue-Body" unten) — die Sichtbarkeit der Beziehung hängt damit nie von der
  Verfügbarkeit einer Preview-/Beta-API ab.

## Issue-Body

Der Issue-Body wird bei **jedem** `push`-Lauf vollständig aus dem Artefakt neu gerendert —
kein Platzhaltertext mehr. Inhalt je Artefakttyp:

- **US-NNNNNN:** User-Story-Satz (Als/möchte ich/damit), alle Akzeptanzkriterien-Szenarien
  (Given/When/Then), Nicht-Ziele, Abhängigkeiten (Blocks/Blocked-by/Epic-Referenz),
  Metadaten-Footer (Priorität, Estimate, Size, Iteration, Start-/Zieldatum).
- **BUG-NNNNNN:** Erwartetes/tatsächliches Verhalten, Reproduktionsschritte, Schweregrad,
  Metadaten-Footer wie oben.
- **DEBT-NNNNNN:** Beschreibung, Ursache, Auswirkung, Metadaten-Footer.
- **IMPD-NNNNNN:** Symptom, Diagnose (direkte/systemische Ursache), Metadaten-Footer.

Der Body wird bei jedem Lauf überschrieben — die Tool-Chain-Datei bleibt alleinige Quelle;
manuelle Bearbeitungen des Issue-Bodys direkt auf GitHub werden beim nächsten `push`
zurückgesetzt (konsistent mit der bestehenden Status-Philosophie: das Board ist eine
Ansicht, kein zweiter Entscheider).

## Zwei Sync-Modi

### `push` (Tool Chain → GitHub)

Ausgeführt am Ende jedes Phasen-Commands, nach einem Gate-PASS:

1. Für jedes neue oder geänderte Artefakt im Geltungsbereich ohne `github-issue`
   (bzw. `github-milestone` bei `EPIC`): Issue/Milestone anlegen, Nummer zurück ins
   Artefakt schreiben.
2. Für jedes Artefakt mit vorhandener Nummer: Issue-Body, Titel, Labels, Status-Feld sowie
   alle gesetzten Board-Felder (Estimate/Size/Priority/Iteration/Start-/Zieldatum/
   Milestone) aktualisieren, passend zum aktuellen Artefaktstand.
3. Relationships (Blocks/Blocked-by/Epic) best-effort über die jeweilige API verknüpfen,
   IMMER zusätzlich im Issue-Body referenzieren.
4. Fehlt `gh`, ist keine Auth vorhanden, oder ist kein Board konfiguriert: Schritt wird
   **übersprungen**, nicht als Fehler behandelt — Sync ist additiv und blockiert nie ein
   Gate.

### `reconcile` (GitHub → Tool Chain)

Ausgeführt **zu Beginn** jedes Phasen-Commands, vor der eigentlichen fachlichen Arbeit:

1. Board-Stand lesen (`gh issue list --json number,state,labels,projectItems`).
2. Für jedes Issue mit `github-issue`-Referenz: Board-Status mit dem Status ableiten aus
   `.phase`/Gate-Historie vergleichen.
3. Bei Abweichung gilt die **Konfliktregel**: Tool-Chain-Gates gewinnen immer. Der
   Board-Status wird auf den aus den Gates abgeleiteten Wert zurückgesetzt, und der
   Widerspruch wird dem Nutzer als Hinweis gemeldet (nicht automatisch als Statusänderung
   in die Tool-Chain-Dateien übernommen — ein handverschobenes Issue ist ein Signal, keine
   Freigabe). Dieselbe Konfliktregel gilt sinngemäß für Iteration/Datum: weichen sie vom
   in `RM-NNNNNN` geplanten Wert ab, wird dies gemeldet, nicht automatisch übernommen.
4. Es gibt **kein** echtes Echtzeit-Feedback (Webhook/Server) — Board-Änderungen wirken
   erst beim nächsten Phasen-Command, nicht sofort.

## Status-Mapping

| Tool-Chain-Zustand | Board-Status-Feld |
|---|---|
| Artefakt `DRAFT`/`REVIEW`, Phase vor Implementierung | `Backlog` |
| Phase `IMPLEMENTATION`/`TESTING` | `In Progress` |
| Phase `REVIEW` | `In Review` |
| Artefakt `APPROVED`/`ACTIVE` nach Gate 9, `BUG` Status `VERIFIZIERT`, `IMPD`/`DEBT` Status `RESOLVED` | `Done` |

Projektspezifisch abweichende Spaltennamen sind zulässig — das Mapping ist ein Vorschlag,
kein starres Feld-ID-Schema; das Sync-Skript liest die tatsächlichen Optionen des
Status-Feldes über `gh project field-list` und wählt die beste Übereinstimmung. Dasselbe
Prinzip gilt für alle anderen Single-Select-/Iteration-Felder (Priority, Size, Iteration).

## Provisionierung (Board anlegen)

Ausgelöst bei `/kickoff` (PM fragt explizit) oder später auf Zuruf. Voraussetzung: Der
Git-Remote des Projekts zeigt auf `github.com` (`git remote -v`) — sonst Hinweis statt
Fehler, Feature bleibt deaktiviert.

Bei Zustimmung:

1. `gh project create --owner <owner> --title "<projektname>"` (falls kein
   `project-number` in `.toolchain.yml` gesetzt ist).
2. Custom Fields anlegen (best-effort — existiert ein Feld mit demselben Namen bereits,
   z. B. weil ein bestehendes Board wiederverwendet wird, wird die Anlage übersprungen
   statt dupliziert):
   - `gh project field-create <nr> --owner <owner> --name "Estimate" --data-type NUMBER`
   - `gh project field-create <nr> --owner <owner> --name "Size" --data-type SINGLE_SELECT --single-select-options "XS,S,M,L,XL"`
   - `gh project field-create <nr> --owner <owner> --name "Priority" --data-type SINGLE_SELECT --single-select-options "P0,P1,P2,P3"`
   - `gh project field-create <nr> --owner <owner> --name "Iteration" --data-type ITERATION`
     (Kadenz: `github.iteration-length-days` Tage, Start: `github.iteration-start-date`
     bzw. Kickoff-Datum — exakte Steuerung hängt von der installierten `gh`-Version ab;
     schlägt die Konfiguration der Kadenz fehl, wird das Feld mit GitHub-Standardwerten
     angelegt und im Statusbericht vermerkt statt als Fehler behandelt)
   - `gh project field-create <nr> --owner <owner> --name "Start date" --data-type DATE`
   - `gh project field-create <nr> --owner <owner> --name "Target date" --data-type DATE`
3. `.toolchain.yml`: `github.enabled: true`, `github.repo`, `github.project-number` setzen.
4. Erster `push`-Lauf für alle bereits vorhandenen Artefakte im Geltungsbereich — sobald
   `/ba` abgeschlossen ist, überträgt dieser Lauf automatisch den **gesamten** Scope
   (siehe "Vorausplanung des Gesamtscopes" oben), nicht nur den ersten Sprint.

## Auth

`github.auth-mode` in `.toolchain.yml` ist ein **Projekt-Setting**, keine feste Methode:

- **`gh-cli`** (Default): Der Agent prüft `gh auth status --scopes`. Fehlt der `project`-
  oder `repo`-Scope, weist er den Nutzer an, `gh auth login --scopes project,repo`
  **selbst interaktiv** auszuführen. Der Agent sieht das Token zu keinem Zeitpunkt.
- **`env-var`**: Der Agent erwartet ein außerhalb der Session vom Nutzer gesetztes
  Environment-Var (Name in `github.auth-env-var`), liest es nur zur Laufzeit des
  Sync-Skripts und schreibt es nirgends fest.

**Verbindlich ausgeschlossen:** Ein PAT wird niemals als Klartext im Chat-Verlauf
entgegengenommen oder von der Tool Chain in eine Datei geschrieben. Das würde das Token
dauerhaft im Session-Verlauf/Log sichtbar machen und widerspricht dem Secret-Scan im
bestehenden `pre-commit`-Hook (`toolchain/hooks/pre-commit`).

## Fehlertoleranz

Der Sync ist in jedem Modus **best-effort und nie blockierend**:

| Fehlerfall | Verhalten |
|---|---|
| `gh` nicht installiert | Sync-Schritt überspringen, einmaliger Hinweis im Statusbericht |
| `gh auth status` ohne ausreichenden Scope | Sync-Schritt überspringen, Anleitung zu `gh auth login` ausgeben |
| Board/Repo nicht erreichbar (Netzwerk, gelöscht, Rechte) | Sync-Schritt überspringen, Warnung ausgeben |
| Custom Field (Estimate/Size/Priority/Iteration/Datum) existiert nicht auf dem Board | Feldupdate für dieses Feld überspringen, im Statusbericht vermerken — restliche Felder werden trotzdem synchronisiert |
| Iteration-Zyklus für Ziel-Sprint noch nicht materialisiert (GitHub generiert Iterationen rollierend) | Best-effort nächstliegende Iteration wählen, Abweichung im Statusbericht vermerken |
| Sub-Issues-/Issue-Dependencies-API nicht verfügbar (Plan/Repo-Limitierung) | Relationship-Sync über die API überspringen — Textfallback im Issue-Body bleibt bestehen |
| Bekannter GitHub-Darstellungsbug (Status-Update im Datenmodell korrekt, Spalte visuell verzögert) | Kein Retry nötig, im Statusbericht als bekanntes Verhalten vermerken statt als Fehler zu werten |

Kein Gate wird durch einen fehlgeschlagenen Sync blockiert oder verzögert.

## Werkzeug

Implementiert in `toolchain/scripts/github-board-sync.ps1` (Windows/PowerShell) und
`toolchain/scripts/github-board-sync.sh` (Bash), aufgerufen mit `-Mode push|reconcile`
bzw. `--mode push|reconcile` und dem Projektpfad. Nutzt ausschließlich die `gh`-CLI, kein
eigener GraphQL-Client.

## Einordnung in die Tool Chain

- Aufrufer: `orchestrator.md` (Sprint-Modus, siehe dort Abschnitt "GitHub-Board-Sync").
- Provisionierung: `pm-agent.md` (`/kickoff`-Interview).
- Vorausplanung des Gesamtscopes: `ba-agent.md` (`/ba`, Outputs `EPIC-NNNNNN`/`RM-NNNNNN`).
- Sprintweise Verfeinerung: `refine.md`/`ba-agent.md` (`/refine`, schreibt Ist-Abweichungen
  in `RM-NNNNNN` zurück).
- Betrifft keine Phase inhaltlich — reine Meta-Automatisierung, analog zu den Git-Hooks in
  `toolchain/hooks/`.
