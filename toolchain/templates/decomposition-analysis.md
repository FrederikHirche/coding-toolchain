---
id: DCP-NNNNNN
title: Decomposition-Analyse — [Bereich/Codebase-Ausschnitt]
version: 1.0
status: DRAFT
author-agent: AR (Software Architect)
date: YYYY-MM-DD
project: [projektname]
based-on: [ADR-NNNNNN — soweit bereits vorhanden]
code-pfad: [Pfad zur untersuchten Codebase innerhalb des Projektordners]
supersedes: —
superseded-by: —
---

# DCP-NNNNNN: Decomposition-Analyse — [Bereich/Codebase-Ausschnitt]

## 1. Erfassungsumfang

**Untersuchte Codebase:** [Pfad, Commit/Tag falls relevant]
**Anlass:** [z. B. Verdacht auf gewachsenen Monolithen / Vorbereitung einer Architekturentscheidung / periodische Prüfung]

---

## 2. Cluster-/Grenzenanalyse

*Aus `get_architecture(aspects: ["clusters","boundaries","layers"])` — Leiden-Clustering
über den Call-/Import-Graphen.*

| Cluster-Label | Mitgliederzahl | Cohesion-Score | Repräsentative Knoten | Bindende Edge-Types |
|---|---|---|---|---|
| [z. B. `payments`] | [N] | [0.0–1.0] | [Top-Knoten aus get_architecture] | [z. B. CALLS, IMPORTS] |

---

## 3. Kopplungs-Hotspots

**Fan-in/Fan-out (`search_graph` mit `min_degree`/`max_degree`):**

| Knoten | Grad (In/Out) | Cluster | Hinweis |
|---|---|---|---|
| `pfad/datei.ext:Symbol` | [In: N / Out: M] | [Cluster-Label] | [z. B. wird von 3 anderen Clustern direkt aufgerufen] |

**Zyklische Abhängigkeiten (`query_graph`):**

| Zyklus (Pfad) | Beteiligte Cluster | Beleg |
|---|---|---|
| [`a → b → a`] | [Cluster X, Cluster Y] | [Cypher-Ergebnis/Kantenliste] |

Legende: Ein Zyklus über eine geplante Servicegrenze hinweg verhindert die Aufspaltung an
dieser Stelle ohne vorherige Entkopplung.

---

## 4. Service-Kandidaten

| Cluster | Einstufung | Cross-Cluster-Kopplung (Kantenzahl) | Begründung | Entkopplungs-Vorarbeit (falls nötig) |
|---|---|---|---|---|
| [Cluster-Label] | Kandidat/Noch nicht bereit | [N Kanten zu Cluster Y] | [konkreter Beleg aus Abschnitt 2/3] | [z. B. Zyklus zwischen X und Y auflösen] |

**Legende Einstufung:** Kandidat = hohe interne Kohäsion, geringe Cross-Cluster-Kopplung,
keine Zyklen über die Grenze · Noch nicht bereit = Zyklus oder hohe Kopplung vorhanden,
mit konkreter Kante/Fundstelle belegt

---

## 5. ADR-Entwurf

*Ein vollständiger Entwurf pro als Kandidat eingestuftem Cluster, in der Struktur von
`toolchain/templates/architecture-decision.md`. Status bleibt `DRAFT`, bis `/architect`
den Entwurf ratifiziert und ihm eine eigene `ADR-NNNNNN` zuweist. Für Noch-nicht-bereit-
Cluster entfällt dieser Abschnitt.*

### Entwurf für Kandidat: [Cluster-Label]

**Status:** `DRAFT`

**Kontext:** [Warum ist eine Aufspaltung dieses Clusters technisch sinnvoll — Cohesion-
Score, Kopplungsdaten aus Abschnitt 2–4?]

**Entscheidung:** [Wir schlagen vor: Cluster X wird eigenständiger Service für ...]

**Begründung:** [Konkrete Argumente aus der Kopplungsanalyse, keine generischen Aussagen]

**Betrachtete Alternativen:**
- [Option A — Beibehaltung als Modul im Monolithen] — ✗ [Ablehnungsgrund]
- [Option B — Aufspaltung mit anderem Zuschnitt] — ✗ [Ablehnungsgrund]
- [Option C (vorgeschlagen)] — ✓ [Begründung]

**Konsequenzen:**
- Positiv: [z. B. unabhängige Deployability]
- Negativ/Trade-offs: [z. B. neue Betriebs-/Netzwerklatenz]
- Risiken: [Tabelle wie in architecture-decision.md]

**Reversibilität:** [Reversibel/Schwer reversibel/Irreversibel — Begründung]

---

## 6. Konsequenzen/Migrationsrisiko

[Betriebs-, Team- und Deployment-Auswirkungen einer Umsetzung — unabhängig vom einzelnen
ADR-Entwurf, z. B. Datenmigration, Team-Zuschnitt, CI/CD-Anpassung.]

---

## 7. Nicht geprüfte Bereiche

[Was wurde bewusst NICHT untersucht — Zeitgründe, Scope-Gründe, fehlender Zugriff?]

- [Bereich 1 — Begründung]

---

## Übergabe: AR → PM/BA

**Datum:** YYYY-MM-DD
**Von:** Software Architect (AR)
**An:** Product Manager (PM) / Business Analyst (BA)
**Nächster Befehl:** [abhängig vom Ergebnis — `/architect [projektname]` bei mindestens einem Kandidaten, sonst keiner]

### Übergebene Artefakte

| Artefakt-ID | Status | Pfad | Hinweise |
|-------------|--------|------|---------|
| DCP-NNNNNN | DRAFT | `projects/<projektname>/architecture/DCP-NNNNNN-<thema>.md` | Service-Kandidaten + ADR-Entwurf/-Entwürfe siehe Abschnitt 4/5 |

### Kritische Informationen für Empfänger

[Was muss der Empfänger wissen, bevor er auf Basis dieser Analyse weiterarbeitet — z. B.
welche Kandidaten Priorität haben, welche Entkopplungs-Vorarbeit zuerst nötig ist?]

### Offene Fragen (vererbt)

| # | Frage | Ursprung | Kritikalität | An wen |
|---|-------|---------|-------------|--------|
| 1 | [Offene Frage aus Abschnitt 6/7] | Decomposition-Analyse | BLOCKER/MAJOR/MINOR | [Wer muss antworten?] |

### Nicht-Ziele (explizit ausgeschlossen)

- Diese Analyse ändert keinen Code und legt keine ADR final an — der ADR-Entwurf wird
  erst durch `/architect` ratifiziert. Sie ersetzt weder `/converge` (Spec-Abdeckung/
  Drift) noch `/review` (Sprint-Diff).

### Empfehlungen

[Siehe Abschnitt 4/5 — hier ggf. mit zusätzlichem Kontext für den Empfänger.]

---

*Erstellt von: AR-Agent | Datum: YYYY-MM-DD | Version: 1.0 | Ablage: `projects/<projektname>/architecture/`*

---

## Änderungshistorie

| Version | Datum | Änderung | Agent |
|---|---|---|---|
| 1.0 | YYYY-MM-DD | Initiale Version | AR |
