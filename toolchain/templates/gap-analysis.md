---
id: GAP-NNNNNN
title: Gap-Analyse — [Bereich/Codebase-Ausschnitt]
version: 1.0
status: DRAFT
author-agent: AR (Software Architect)
date: YYYY-MM-DD
project: [projektname]
based-on: [SB-NNNNNN, REQ-NNNNNN, ADR-NNNNNN — soweit bereits vorhanden]
code-pfad: [Pfad zur untersuchten Codebase innerhalb des Projektordners]
supersedes: —
superseded-by: —
---

# GAP-NNNNNN: Gap-Analyse — [Bereich/Codebase-Ausschnitt]

## 1. Erfassungsumfang

**Untersuchte Codebase:** [Pfad, Commit/Tag falls relevant]
**Anlass:** [Altprojekt-Übernahme in die Tool Chain / Verdacht auf Spec-Drift / Sprint-Vorbereitung]
**Vorhandene Toolchain-Artefakte zum Zeitpunkt der Analyse:**

| Artefakt-Typ | Vorhanden? | Status |
|---|---|---|
| SB-NNNNNN | Ja/Nein | [Status] |
| REQ-NNNNNN | Ja/Nein | [Status] |
| ADR-NNNNNN | Ja/Nein | [Status] |
| US-NNNNNN | Ja/Nein | [Status] |

Falls **keine** dieser Artefakte existieren: Diese Gap-Analyse beschreibt die Codebase
so, dass BA/AR retroaktiv REQ/ADR daraus ableiten können (siehe Abschnitt 5).

---

## 2. Abdeckungsmatrix (Spezifikation ↔ Code)

*Nur befüllen, wenn REQ/US bereits existieren. Sonst mit Abschnitt 4 (Ist-Architektur) fortfahren.*

| REQ/US-ID | Spezifiziert | Im Code gefunden? | Status | Fundstelle(n) | Abweichung |
|---|---|---|---|---|---|
| US-NNNNNN | [Kurzbeschreibung] | Ja/Teilweise/Nein | Vollständig/Teilweise/Fehlend | `pfad/datei.ext:Zeile` | [Was weicht ab?] |

**Legende Status:** Vollständig = Akzeptanzkriterien vollständig erfüllt · Teilweise = Kernfunktion
vorhanden, Akzeptanzkriterien nicht vollständig geprüft · Fehlend = kein Code gefunden

---

## 3. Architektur-Drift (ADR ↔ Ist-Zustand)

*Nur befüllen, wenn ADRs bereits existieren.*

| ADR-ID | Entschieden | Im Code tatsächlich verwendet | Drift? | Empfehlung |
|---|---|---|---|---|
| ADR-000001 | [z. B. PostgreSQL] | [z. B. tatsächlich MongoDB] | Ja/Nein | [ADR aktualisieren / Code migrieren / Ausnahme dokumentieren] |

---

## 4. Ist-Architektur (falls keine ADRs vorhanden)

[Nur befüllen, wenn Abschnitt 3 leer bleibt, weil noch keine ADRs existieren. Beschreibt die
tatsächlich vorgefundene technische Basis — Sprache/Runtime, Frontend/Backend-Ansatz,
Datenhaltung, Hosting, Auth — als Grundlage für einen retroaktiven ADR-000001.]

| Dimension | Vorgefundener Ist-Zustand | Quelle im Code |
|---|---|---|
| Sprache/Runtime | [z. B. TypeScript / Node 20] | `package.json` |
| Datenhaltung | [z. B. PostgreSQL via Prisma] | `prisma/schema.prisma` |
| [Weitere Dimension] | | |

---

## 5. Identifizierte technische Schulden

| Fund | Beschreibung | Vorgeschlagene DEBT-ID | Priorität |
|---|---|---|---|
| [Kurzbezeichnung] | [Was genau ist die Schuld?] | `DEBT-NNNNNN` (im nächsten `/review` anzulegen) | Hoch/Mittel/Gering |

---

## 6. Empfehlung

**Für die Tool-Chain-Übernahme dieses Codes:**

- [ ] Retroaktiven `SB-000001` erstellen (falls keine Discovery-Artefakte existieren) — `/kickoff [projektname]`
- [ ] Retroaktive `REQ-NNNNNN`/`US-NNNNNN` aus Abschnitt 2/4 ableiten — `/ba [projektname]`
- [ ] Retroaktiven `ADR-000001` aus Abschnitt 4 ableiten — `/architect [projektname]`
- [ ] Folgende US als bereits `DONE` markieren (vollständig im Code gefunden): [Liste]
- [ ] Folgende US als neue Backlog-Items für den nächsten Sprint aufnehmen (fehlend/teilweise): [Liste]
- [ ] Architektur-Drift auflösen (siehe Abschnitt 3): [konkrete Maßnahme]

**Explizite Entscheidung, keine offene Abwägung:** [Was ist der nächste konkrete Schritt?]

---

## 7. Nicht geprüfte Bereiche

[Was wurde bewusst NICHT untersucht — Zeitgründen, Scope-Gründen, fehlendem Zugriff? Verhindert,
dass diese Gap-Analyse als vollständige Codebase-Prüfung missverstanden wird.]

- [Bereich 1 — Begründung]

---

## Übergabe: AR → PM/BA

**Datum:** YYYY-MM-DD
**Von:** Software Architect (AR)
**An:** Product Manager (PM) / Business Analyst (BA)
**Nächster Befehl:** [abhängig von Empfehlung — siehe Abschnitt 6, z. B. `/ba [projektname]` oder `/architect [projektname]`]

### Übergebene Artefakte

| Artefakt-ID | Status | Pfad | Hinweise |
|-------------|--------|------|---------|
| GAP-NNNNNN | DRAFT | `projects/<projektname>/architecture/GAP-NNNNNN-<thema>.md` | Empfehlung siehe Abschnitt 6 |

### Kritische Informationen für Empfänger

[Was muss der Empfänger wissen, bevor er auf Basis dieser Gap-Analyse weiterarbeitet?]

### Offene Fragen (vererbt)

| # | Frage | Ursprung | Kritikalität | An wen |
|---|-------|---------|-------------|--------|
| 1 | [Offene Frage aus Abschnitt 7] | Gap-Analyse | BLOCKER/MAJOR/MINOR | [Wer muss antworten?] |

### Nicht-Ziele (explizit ausgeschlossen)

- Diese Gap-Analyse ändert keinen Code und legt keine ADRs oder US final an — sie liefert nur
  die Grundlage dafür.

### Empfehlungen

[Siehe Abschnitt 6 — hier ggf. mit zusätzlichem Kontext für den Empfänger.]

---

*Erstellt von: AR-Agent | Datum: YYYY-MM-DD | Version: 1.0 | Ablage: `projects/<projektname>/architecture/`*

---

## Änderungshistorie

| Version | Datum | Änderung | Agent |
|---|---|---|---|
| 1.0 | YYYY-MM-DD | Initiale Version | AR |
