# AI Development Tool Chain — Bedienungsanleitung

> Praxisanleitung für den täglichen Einsatz der agentischen Entwicklungs-Tool-Chain mit Claude Code.

---

## Was ist diese Tool Chain?

Eine strukturierte Arbeitsumgebung, in der Claude Code verschiedene Rollen übernimmt — Product Manager, Architect, Entwickler, QA, Reviewer — und dabei vollständig dokumentierte, versionierte Artefakte produziert. Jede Phase hat einen definierten Ein- und Ausgang. Du weißt immer, was als nächstes kommt.

**Das Prinzip in einem Satz:** Du gibst die Idee ein — die Tool Chain führt dich strukturiert durch den gesamten Entwicklungsprozess bis zum Review-fertigen Code.

---

## Voraussetzungen

| Voraussetzung | Zweck |
|---|---|
| **Claude Code** | Führt alle Agenten aus. Slash Commands sind die Hauptschnittstelle. |
| **Git** | Hooks für automatisierte Qualitätsprüfung |
| **Dieses Repository** | Als gemeinsame Wissensbasis im Projektordner geöffnet |

Claude Code öffnest du im Wurzelverzeichnis dieses Repositories:
```bash
cd "Coding Tool Chain"
claude
```

---

## Schnellstart: Erstes Projekt in 5 Minuten

```bash
# 1. Hooks einmalig installieren (pro Repository)
bash toolchain/hooks/setup-hooks.sh

# 2. Erstes Projekt starten
/kickoff

# Claude fragt jetzt nach dem Projektnamen und führt ein
# strukturiertes Stakeholder-Interview durch.
```

Das war's. Claude übernimmt die Führung.

---

## Die zwei Betriebsmodi

### Modus A: Vollautomatisch (`/sprint`)

Claude orchestriert den gesamten Sprint von Anfang bis Ende. Du wirst nur gefragt, wenn ein Gate blockiert oder eine menschliche Entscheidung nötig ist.

```
/sprint mein-projekt 1
```

Empfohlen für: Neue Projekte, erfahrene Nutzer, wenn du den Prozess kennst.

### Modus B: Manuell (Phase für Phase)

Du rufst jeden Schritt einzeln auf. Mehr Kontrolle, mehr Überblick.

```
/kickoff     → dann lesen, prüfen, fortfahren mit:
/ba          → dann lesen, prüfen, fortfahren mit:
/architect   → usw.
```

Empfohlen für: Erste Projekte, wenn du jeden Schritt verstehen willst.

---

## Die Phasen im Überblick

```
Phase 1 → /kickoff     Product Manager    Stakeholder Brief
Phase 2 → /ba          Business Analyst   Requirements + User Stories
Phase 3 → /architect   Software Architect ADRs + Tech Stack
Phase 4 → /ux          UX Designer        UX-Specs + User Journeys
Phase 5 → /refine      BA + Dev-Team      Sprint Backlog
Phase 6 → /implement   Frontend + Backend Code + API-Kontrakt
Phase 7 → /test-plan   QA Engineer        Testplan
          /test-run                        Testergebnisse
Phase 8 → /review      Code Reviewer      Review-Bericht + Merge-Entscheidung
Phase 9 → /manual      Manual Writer      Feature-Guides + Release Notes
```

---

## Phase für Phase erklärt

### Phase 1 — Discovery (`/kickoff`)

**Was passiert:** Claude übernimmt die Rolle des Product Managers und führt ein strukturiertes Interview mit dir durch (3 Runden, max. 8 Fragen). Am Ende entsteht ein Stakeholder Brief.

**Was du tust:** Fragen beantworten. Ehrlich und konkret — vage Antworten führen zu vagen Anforderungen.

**Ergebnis:** `projects/<name>/SB-001-<name>.md`

**Typische Fragen in dieser Phase:**
- Was ist das Problem, das wir lösen?
- Für wen wird das gebaut?
- Was ist definitiv außerhalb des Scope?
- Wie messen wir Erfolg?

**Gate:** SB muss auf `APPROVED` gesetzt werden (durch dich oder auf dein Geheiß) bevor Phase 2 beginnt.

---

### Phase 2 — Requirements (`/ba`)

**Was passiert:** Claude liest den Stakeholder Brief und erstellt daraus strukturierte Anforderungen und User Stories im Format "Als [Nutzer] möchte ich [Ziel], damit [Nutzen]" mit testbaren Akzeptanzkriterien.

**Was du tust:** User Stories gegenlesen. Akzeptanzkriterien prüfen — sind sie wirklich testbar? Stimmt die Priorisierung?

**Ergebnis:** `REQ-001.md` + `US-001.md` bis `US-NNN.md`

**Tipp:** Je genauer die User Stories, desto besser der Code später. Hier lohnt sich Zeit.

---

### Phase 3 — Architektur (`/architect`)

**Was passiert:** Claude analysiert Requirements und trifft begründete Technologieentscheidungen. Jede Entscheidung wird als Architecture Decision Record (ADR) dokumentiert — mit Alternativen und Ablehnungsgründen.

**Was du tust:** ADR-001 (Tech-Stack) freigeben. Das ist die wichtigste Entscheidung des Projekts — sie ist bindend für alle nachfolgenden Phasen.

**Ergebnis:** `ADR-001-tech-stack.md` + weitere ADRs + `STRUCTURE.md`

**Achtung:** Erst nach ADR-001-Freigabe ist klar, welche Sprache, welches Framework, welche Datenbank genutzt wird. Frontend- und Backend-Agent halten sich strikt daran.

---

### Phase 4 — UX Design (`/ux`)

**Was passiert:** Claude spezifiziert die Benutzererfahrung als Text-Spec — Schritt-für-Schritt-User-Journeys, alle UI-Zustände (leer, laden, Fehler, Erfolg), Microcopy und Accessibility-Anforderungen.

**Was du tust:** UX-Specs auf Vollständigkeit prüfen. Stimmt die Journey? Sind Fehlerzustände beschrieben?

**Ergebnis:** `UX-001.md` bis `UX-NNN.md` (eine pro Feature-Bereich)

**Hinweis:** Die UX-Spec ersetzt keine echten Wireframes, ist aber eine vollständige Implementierungsgrundlage für den Frontend-Agenten.

---

### Phase 5 — Refinement (`/refine`)

**Was passiert:** User Stories werden für den Sprint vorbereitet: Subtasks definiert, Aufwände geschätzt, Abhängigkeiten geklärt, Sprint-Ziel formuliert.

**Was du tust:** Sprint-Scope festlegen. Was soll in diesem Sprint fertig werden? Welche Stories verschieben wir?

**Ergebnis:** `SP-001-sprint1.md` (Sprint Backlog)

---

### Phase 6 — Implementierung (`/implement`)

**Was passiert:** Code wird geschrieben — Backend-zuerst (API-Kontrakt vor Code), dann Frontend (basierend auf UX-Spec und API-Kontrakt). Jede Datei hat einen Header, jede Funktion einen Docstring.

**Was du tust:** Bei `/implement be` und `/implement fe` zusätzliche Informationen liefern falls Claude Rückfragen hat. Zwischenstände prüfen.

**Varianten:**
```
/implement be        # Nur Backend
/implement fe        # Nur Frontend
/implement all       # Beides (BE zuerst → API-Kontrakt → FE)
```

**Ergebnis:** Vollständig kommentierter Code + API-Kontrakt-Datei

---

### Phase 7 — Test (`/test-plan` + `/test-run`)

**Schritt 1 — Testplan:**
```
/test-plan mein-projekt 1
```
Claude erstellt einen manuellen Testplan aus den User Stories und Akzeptanzkriterien: Happy-Path-Tests, Fehlerfälle, Boundary-Tests, Sicherheitschecks.

**Schritt 2 — Testausführung:**
```
/test-run mein-projekt 1
```
Claude führt automatisierte Tests aus (Lint, Unit, Integration) und dokumentiert Ergebnisse. Gefundene Bugs werden als `BUG-NNN.md` erfasst.

**Ergebnis:** `TP-001.md` + `TR-001.md`

**Gate:** Keine BLOCKER-Bugs dürfen offen sein, bevor Phase 8 beginnt.

---

### Phase 8 — Review (`/review`)

**Was passiert:** Claude übernimmt die Rolle des Code Reviewers — unabhängig von den Entwicklungsagenten. Review in 6 Dimensionen: Korrektheit, Sicherheit, ADR-Konformität, Code-Qualität, Testabdeckung, Performance.

**Ergebnis:** `RV-001.md` mit einer von drei Entscheidungen:

| Entscheidung | Bedeutung | Nächster Schritt |
|---|---|---|
| `APPROVED` | Code kann gemergt werden | Weiter mit `/manual` |
| `REQUEST CHANGES` | Korrekturen nötig | Zurück zu `/implement` |
| `REJECTED` | Grundlegendes Problem | Zurück zu PM oder AR |

---

### Phase 9 — Dokumentation (`/manual`)

**Was passiert:** Claude übernimmt die Rolle des Manual Writers und erstellt nutzerorientierte Dokumentation aller implementierten Features — aus Endnutzer-Perspektive, nicht aus Entwicklersicht. Kein Fachjargon, klare Schritt-für-Schritt-Anleitungen.

**Was du tust:** Dokumentation gegenlesen. Ist sie verständlich für jemanden ohne technisches Wissen? Sind die richtigen Features abgedeckt?

**Ergebnis:**
- `DOC-NNN.md` — Feature-Guide pro Feature-Bereich
- `RN-NNN.md` — Release Notes für diesen Sprint
- `GS-001.md` — Getting-Started-Anleitung (nur beim ersten Sprint)

**Hinweis:** Screenshot-Platzhalter (`[SCREENSHOT: ...]`) werden gesetzt — du fügst später echte Screenshots ein.

**Gate:** Jede APPROVED User Story muss einen Dokumentationseintrag haben, bevor der Sprint als `DONE` gilt.

---

## Den Projektzustand prüfen: `/status`

Jederzeit den aktuellen Stand eines Projekts anzeigen:

```
/status mein-projekt
```

Ausgabe zeigt: Aktuelle Phase, vorhandene Artefakte mit Status, was fürs nächste Gate fehlt, welcher Command als nächstes aufgerufen werden soll.

```
/status          # Alle Projekte aus REGISTRY.md auflisten
```

---

## Sonderszenarien

### Kritischer Produktionsfehler: `/hotfix`

Wenn ein Bug im Live-System sofort gefixt werden muss — ohne den normalen Sprint-Zyklus:

```
/hotfix mein-projekt "Login funktioniert nach Passwort-Reset nicht"
```

Ablauf: Bug-Analyse → Implementierung (nur betroffene Dateien) → Smoke-Test → Review. Dauert typisch 2-4 Stunden statt 1-2 Wochen.

**Voraussetzungen:** Der Fix ändert keine Architektur, ADR-001 bleibt gültig.

### Technologiefrage klären: `/spike`

Wenn vor einer Architekturentscheidung erst etwas ausprobiert werden muss:

```
/spike mein-projekt "Welche Event-Streaming-Lösung passt zu unseren Anforderungen?"
```

Ablauf: Fragestellung schärfen → Recherche + ggf. PoC → Spike Report (`SRP-NNN`). Ergebnis fließt in den nächsten `/architect`-Aufruf ein.

---

## Artefakte verstehen

Alle erzeugten Dateien folgen einer einheitlichen Benennung:

| Was | Kürzel | Beispiel | Erstellt von |
|-----|--------|---------|-------------|
| Stakeholder Brief | `SB-NNN` | `SB-001-shop.md` | PM |
| Requirements | `REQ-NNN` | `REQ-001-auth.md` | BA |
| User Story | `US-NNN` | `US-042-login.md` | BA |
| Architekturentscheidung | `ADR-NNN` | `ADR-001-tech-stack.md` | AR |
| UX-Spec | `UX-NNN` | `UX-001-onboarding.md` | UX |
| Sprint Backlog | `SP-NNN` | `SP-001-sprint1.md` | BA+FE+BE |
| Testplan | `TP-NNN` | `TP-001-smoke.md` | QA |
| Testergebnis | `TR-NNN` | `TR-001-sprint1.md` | QA |
| Review-Bericht | `RV-NNN` | `RV-001-sprint1.md` | RV |
| Technische Schuld | `DEBT-NNN` | `DEBT-001-n+1.md` | RV |
| Feature-Guide | `DOC-NNN` | `DOC-001-login.md` | MW |
| Release Notes | `RN-NNN` | `RN-001-sprint1.md` | MW |
| Getting Started | `GS-NNN` | `GS-001.md` | MW |
| Entscheidungsprotokoll | `DECISIONS.md` | `DECISIONS.md` | Alle Agenten |

### Artefakt-Status

Ein Artefakt ist immer in genau einem Status:

```
DRAFT     → Claude ist dabei, es zu erstellen
REVIEW    → Fertig, wartet auf deine Freigabe
APPROVED  → Freigegeben, bindend für alle folgenden Phasen
ACTIVE    → In aktivem Einsatz
SUPERSEDED → Ersetzt durch neuere Version
ARCHIVED  → Sprint/Phase abgeschlossen
```

**Wichtig:** Artefakte werden niemals gelöscht. Veraltete Versionen erhalten den Status `SUPERSEDED` und bleiben als Entscheidungshistorie erhalten.

---

## Qualitäts-Gates

Zwischen jeder Phase prüft der Orchestrator automatisch, ob die Grundvoraussetzungen für die nächste Phase erfüllt sind. Gates haben drei Schweregrade:

| Schwere | Wirkung |
|---------|---------|
| 🔴 BLOCKER | Hartes Stopp — muss behoben werden bevor es weitergeht |
| 🟡 MAJOR | Warnung — kann mit deiner Bestätigung übersprungen werden |
| 🟢 MINOR | Hinweis — wird als TODO in die nächste Phase vererbt |

**Beispiel:** Gate 2 → 3 (Requirements → Architecture) blockiert, wenn `REQ-001` noch im Status `DRAFT` ist. Claude zeigt dann genau, was fehlt und welcher Command aufgerufen werden soll.

---

## Git Hooks

Nach `bash toolchain/hooks/setup-hooks.sh` laufen bei jedem Commit automatisch:

| Hook | Prüft | Schwere |
|------|-------|---------|
| `pre-commit` | Lint (falls konfiguriert) | Blockt bei Fehler |
| `pre-commit` | Secrets/Credentials im Code | Blockt bei Fund |
| `pre-commit` | Datei-Header in Code-Dateien | Warnung |
| `pre-commit` | TODO-Marker-Format korrekt | Warnung |
| `post-commit` | INDEX.md in geänderten Ordnern aktuell | Hinweis |

Befehle für Lint und Tests werden in `.toolchain.yml` im Projektordner hinterlegt:

```yaml
commands:
  lint: npm run lint
  test: npm test
```

---

## Projektstruktur

```
Coding Tool Chain/
├── CLAUDE.md                    ← Einstiegspunkt (automatisch von Claude Code geladen)
├── .toolchain.yml               ← Config-Template
├── .claude/commands/            ← 13 Slash Commands
├── architecture.html            ← Architektur-Übersicht mit Mermaid-Diagrammen
├── api_documentation.html       ← Protokoll- & Schnittstellen-Dokumentation
├── toolchain/
│   ├── agents/                  ← 10 Agenten-Definitionen (incl. MW)
│   ├── workflows/               ← Full Sprint (9 Phasen), Hotfix, Spike
│   ├── protocols/               ← Handoff, Gate, Lifecycle
│   ├── templates/               ← 10 Artefakt-Templates (incl. DECISIONS.md)
│   └── hooks/                   ← Git Automation
└── projects/
    ├── REGISTRY.md              ← Alle Projekte auf einen Blick
    ├── _template/               ← Vorlage für neue Projekte
    └── <projektname>/           ← Dein Projekt
        ├── INDEX.md
        ├── DECISIONS.md         ← Entscheidungsprotokoll (von allen Agenten gepflegt)
        ├── .phase               ← Aktueller Phasenzustand (vom Orchestrator gepflegt)
        ├── docs/                ← Feature-Guides, Release Notes (vom MW erstellt)
        └── [Artefakte]
```

---

## Häufige Fragen

**Kann ich eine Phase überspringen?**

Ja — mit Bedacht. Beim manuellen Modus kannst du direkt zu einer späteren Phase springen. Der Orchestrator (`/status`) wird dich auf fehlende Artefakte hinweisen. Phasen überspringen ist nur sinnvoll, wenn du die fehlenden Artefakte aus anderen Quellen (z. B. existierende Spezifikation) einbringst.

**Was passiert wenn ein Gate fehlschlägt?**

Claude zeigt genau was fehlt und empfiehlt den korrekten nächsten Command. Kein Datenverlust — alle Artefakte bleiben erhalten. Zurück zur betroffenen Phase, Artefakt korrigieren, Gate erneut prüfen.

**Kann ich mehrere Projekte gleichzeitig führen?**

Ja. Jedes Projekt hat einen eigenen Unterordner in `projects/` und eine eigene `.phase`-Datei. `/status` ohne Argument zeigt alle Projekte aus `REGISTRY.md`.

**Was ist mit dem Tech-Stack? Kann ich den selbst vorgeben?**

Ja. Du kannst dem Architect-Agenten beim `/architect`-Aufruf sagen welche Technologien du bevorzugst. Claude dokumentiert die Entscheidung dann in ADR-001 — mit Begründung. Oder du lässt Claude auf Basis der Requirements eine Empfehlung machen und entscheidest dann.

**Muss ich alle Artefakte lesen und freigeben?**

Beim manuellen Modus: Ja, empfohlen. Beim `/sprint`-Modus kannst du auf automatisches Gate-Passing vertrauen — Claude gibt nur bei echten Blockaden zurück. Kritische Dokumente (SB, ADR-001) solltest du immer kurz gegenlesen, da sie alle nachfolgenden Phasen prägen.

**Was passiert mit dem Code nach dem Review?**

Der Reviewer-Agent gibt eine explizite `APPROVED`/`REQUEST CHANGES`/`REJECTED`-Entscheidung aus. Bei `APPROVED` folgt Phase 9 (`/manual`) — der Manual Writer erstellt die Nutzer-Dokumentation. Erst nach Gate 9 gilt der Sprint als `DONE` und kann gemergt werden. Für den nächsten Sprint: `/refine` aufrufen.

**Was ist DECISIONS.md?**

Ein leichtgewichtiges Entscheidungsprotokoll, das in jedem Projekt automatisch angelegt wird. Alle Agenten tragen hier wesentliche Entscheidungen ein — Scope-Änderungen, Priorisierungsentscheidungen, Library-Wahlen, UX-Richtungsentscheidungen. Weniger formal als ADRs, aber vollständiger — ein chronologisches Gedächtnis des Projekts. Du kannst `DECISIONS.md` jederzeit lesen, um nachzuvollziehen warum etwas so entschieden wurde.

**Kann ich die Tool Chain für jede Technologie nutzen?**

Ja — sie ist bewusst technologieneutral. Der Architect-Agent entscheidet beim ersten Projekt, welcher Tech-Stack verwendet wird (`ADR-001`). Erst danach wird Technologie-spezifisch entwickelt.

---

## Referenz: Alle Commands

| Command | Beschreibung |
|---------|-------------|
| `/status [projekt]` | Projektzustand + nächster Schritt |
| `/sprint [projekt] [nr]` | Vollständiger Sprint (automatisch) |
| `/hotfix [projekt] [bug]` | Notfall-Fix (4 Phasen) |
| `/spike [projekt] [frage]` | Technischer Research ohne Implementierung |
| `/kickoff` | Phase 1: Discovery |
| `/ba` | Phase 2: Requirements |
| `/architect` | Phase 3: Architektur |
| `/ux` | Phase 4: UX Design |
| `/refine` | Phase 5: Sprint-Planung |
| `/implement [fe\|be\|all]` | Phase 6: Implementierung |
| `/test-plan` | Phase 7a: Testplan erstellen |
| `/test-run` | Phase 7b: Tests ausführen |
| `/review` | Phase 8: Code Review |
| `/manual` | Phase 9: Nutzer-Dokumentation |

---

## Weiterführende Dokumentation

| Dokument | Beschreibung |
|----------|-------------|
| `architecture.html` | Interaktive Architektur-Übersicht mit Mermaid-Diagrammen (im Browser öffnen) |
| `api_documentation.html` | Protokoll- & Schnittstellen-Dokumentation (im Browser öffnen) |
| `CLAUDE.md` | Technische Referenz für Claude Code |
| `toolchain/agents/` | Vollständige Agenten-Definitionen mit System-Prompts |
| `toolchain/workflows/` | Detaillierte Workflow-Beschreibungen mit Gate-Kriterien |

---

*Letzte Aktualisierung: 2026-06-18 — Tool Chain v1.1 (+ MW, DECISIONS.md, Phase 9)*
