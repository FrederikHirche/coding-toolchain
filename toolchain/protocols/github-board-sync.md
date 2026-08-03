---
id: PROTO-GITHUB-BOARD
title: GitHub-Projectboard-Sync-Protokoll
version: 1.0
status: ACTIVE
---

# Protokoll: GitHub-Projectboard-Sync

Optionales, additives Feature: Ein Projekt kann sein Backlog und den Story-Status in einem
echten GitHub Project (v2) Board spiegeln. Die Tool-Chain-Dateien (`.phase`, `INDEX.md`,
`US-NNNNNN`, `BUG-NNNNNN`, `DEBT-REGISTRY`, `IMPD-NNNNNN`) bleiben die alleinige fachliche
Quelle der Wahrheit — das Board ist eine Ansicht darauf, kein zweiter Entscheider. Ohne
`github.enabled: true` in `.toolchain.yml` passiert nichts; kein Agent greift ungefragt auf
GitHub zu.

## Geltungsbereich

Synchronisiert werden ausschließlich die Artefakttypen aus `github.synced-artifacts` in
`.toolchain.yml` (Default: `US`, `BUG`, `DEBT`, `IMPD`):

| Artefakttyp | Issue wird angelegt, wenn ... |
|---|---|
| `US-NNNNNN` | immer (Story existiert) |
| `BUG-NNNNNN` | immer; Schweregrad (`BLOCKER`/`MAJOR`/`MINOR`) wird als Label geführt |
| `DEBT-NNNNNN` (Eintrag in `DEBT-REGISTRY`) | immer |
| `IMPD-NNNNNN` | **nur wenn** der Status nach der Erfassung nicht sofort `RESOLVED` ist — ein im selben Zug gelöstes Impediment erzeugt kein Issue |

`SP-NNNNNN` (Sprint Backlog) wird nicht selbst zum Issue, sondern als Sprint/Iteration-Feld
auf den zugehörigen Issues geführt.

## Ein Board pro Projekt

Genau ein GitHub Project (v2) Board pro `projects/<name>/`, angelegt beim ersten Opt-in und
über alle Sprints hinweg wiederverwendet (siehe "Provisionierung" unten). Kein Board pro
Sprint.

## ID-Zuordnung

Jedes synchronisierte Artefakt trägt die Issue-Nummer im Feld `github-issue` (Frontmatter
bei `US`/`BUG`/`IMPD`, eigene Spalte/Zeile bei `DEBT-REGISTRY`). Ein Sync-Lauf legt ein
Issue **nur an, wenn `github-issue` leer (`—`) ist** — sonst wird das bestehende Issue über
seine Nummer editiert. Diese Regel verhindert Duplikate bei wiederholtem Sync.

## Zwei Sync-Modi

### `push` (Tool Chain → GitHub)

Ausgeführt am Ende jedes Phasen-Commands, nach einem Gate-PASS:

1. Für jedes neue oder geänderte Artefakt im Geltungsbereich ohne `github-issue`: Issue
   anlegen (`gh issue create`), Nummer zurück ins Artefakt schreiben.
2. Für jedes Artefakt mit vorhandenem `github-issue`: Titel/Labels/Status-Feld aktualisieren
   (`gh issue edit`, `gh project item-edit --field Status`), passend zur aktuellen
   `.phase`/Artefakt-Status-Zuordnung (siehe "Status-Mapping" unten).
3. Fehlt `gh`, ist keine Auth vorhanden, oder ist kein Board konfiguriert: Schritt wird
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
   Freigabe).
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
Status-Feldes über `gh project field-list` und wählt die beste Übereinstimmung.

## Provisionierung (Board anlegen)

Ausgelöst bei `/kickoff` (PM fragt explizit) oder später auf Zuruf. Voraussetzung: Der
Git-Remote des Projekts zeigt auf `github.com` (`git remote -v`) — sonst Hinweis statt
Fehler, Feature bleibt deaktiviert.

Bei Zustimmung:

1. `gh project create --owner <owner> --title "<projektname>"` (falls kein
   `project-number` in `.toolchain.yml` gesetzt ist).
2. `.toolchain.yml`: `github.enabled: true`, `github.repo`, `github.project-number` setzen.
3. Erster `push`-Lauf für alle bereits vorhandenen Artefakte im Geltungsbereich.

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
- Betrifft keine Phase inhaltlich — reine Meta-Automatisierung, analog zu den Git-Hooks in
  `toolchain/hooks/`.
