---
id: RETRO-NNN
title: Sprint-Retrospektive — Sprint N — [Projekttitel]
version: 1.0
status: DRAFT
author-agent: AC (Agile Coach)
date: YYYY-MM-DD
project: [projektname]
sprint: N
based-on: [.phase, RV-NNN, TR-NNN, SP-NNN]
supersedes: —
superseded-by: —
---

# Sprint-Retrospektive: Sprint N — [Projekttitel]

> **Ablage:** `projects/[projektname]/RETRO-NNN-sprint-N.md`

---

## Sprint-Überblick

| Feld | Wert |
|---|---|
| **Sprint** | N |
| **Zeitraum** | YYYY-MM-DD bis YYYY-MM-DD |
| **Geplante Stories** | N |
| **Abgeschlossene Stories** | N |
| **Liefergrad** | N% |
| **Gates bestanden** | N/9 |
| **Offene BLOCKER am Ende** | N |

---

## 1. Prozess-Fluss

### Phasendauern (aus .phase)

| Phase | Geplant | Tatsächlich | Abweichung | Auffälligkeit |
|---|---|---|---|---|
| Discovery | — | — | — | — |
| Requirements | — | — | — | — |
| Architecture | — | — | — | — |
| UX | — | — | — | — |
| Refinement | — | — | — | — |
| Implementation | — | — | — | — |
| Testing | — | — | — | — |
| Review | — | — | — | — |
| Documentation | — | — | — | — |

### Gate-Ergebnisse

| Gate | Ergebnis | BLOCKERs | Rückschritte |
|---|---|---|---|
| Gate 1 (Discovery → Req.) | ✅ / ❌ | N | — |
| Gate 2 (Req. → Arch.) | ✅ / ❌ | N | — |
| Gate 3 (Arch. → UX) | ✅ / ❌ | N | — |
| Gate 4 (UX → Ref.) | ✅ / ❌ | N | — |
| Gate 5 (Ref. → Impl.) | ✅ / ❌ | N | — |
| Gate 6 (Impl. → Test) | ✅ / ❌ | N | — |
| Gate 7 (Test → Review) | ✅ / ❌ | N | — |
| Gate 8 (Review → Docs) | ✅ / ❌ | N | — |
| Gate 9 (Docs → Done) | ✅ / ❌ | N | — |

---

## 2. Artefakt-Qualität

| Artefakt | Qualitätsbewertung | Überarbeitungen | Auffälligkeit |
|---|---|---|---|
| SB-NNN | Gut / Mittel / Lückenhaft | N | [Was fehlte?] |
| REQ-NNN | | | |
| US-NNN | | | |
| ADR-NNN | | | |
| UX-NNN | | | |
| SP-NNN | | | |
| TP-NNN | | | |
| TR-NNN | | | |
| RV-NNN | | | |
| DOC-NNN | | | |

**Wiederholt lückenhafte Artefaktbereiche:**
- [Bereich 1: Was fehlt strukturell?]

---

## 3. Agenten-Performance

### Übergabe-Qualität

| Übergabe | Qualität | Nacharbeit nötig? | Ursache wenn ja |
|---|---|---|---|
| PM → BA | Gut / Mittel / Lückenhaft | Ja / Nein | |
| BA → AR | | | |
| AR → UX | | | |
| AR → FE/BE | | | |
| UX → FE | | | |
| FE/BE → QA | | | |
| QA → RV | | | |
| RV → MW | | | |

**Auffälligste Schwachstelle in Übergaben:**
[Welche Übergabe hat am meisten Friction erzeugt?]

---

## 4. Entscheidungsqualität

**Entscheidungen die sich als richtig erwiesen haben:**
- [DEC-NNN: Begründung warum gut]

**Entscheidungen die überarbeitet oder bereut wurden:**
- [DEC-NNN: Was war das Problem? Was hätten wir anders entschieden?]

**Entscheidungen die zu spät getroffen wurden:**
- [Was hat geblockt, weil eine Entscheidung fehlte?]

---

## 5. Nutzer-Perspektive

*(Antworten auf die Einstiegsfragen des AC-Interviews)*

**Wo hat sich der Prozess am stärksten wie Widerstand angefühlt?**
> [Antwort des Nutzers]

**Was hat dich in diesem Sprint am meisten überrascht?**
> [Antwort des Nutzers]

**Gibt es ein Artefakt, das du als überflüssig empfunden hast?**
> [Antwort des Nutzers]

---

## 6. Keep / Stop / Start

### 🟢 KEEP — Das beibehalten

| # | Was | Warum beibehalten? |
|---|---|---|
| K1 | [Praxis / Artefakt / Regel] | [Konkreter Wert] |
| K2 | | |

### 🔴 STOP — Das aufhören

| # | Was | Warum aufhören? | Ersatz? |
|---|---|---|---|
| S1 | [Praxis / Artefakt / Schritt] | [Was kostet es ohne Nutzen?] | [Womit ersetzen?] |
| S2 | | | |

### 🔵 START — Das einführen

| # | Was | Warum einführen? | Aufwand |
|---|---|---|---|
| ST1 | [Neue Praxis / Artefakt / Schritt] | [Welches Problem löst es?] | S / M / L |
| ST2 | | | |

---

## 7. Verbesserungsvorschläge

### Sofortige Quick Wins (nächster Sprint)

| # | Vorschlag | Betroffene Datei | Aufwand |
|---|---|---|---|
| QW1 | [Konkrete Änderung] | `toolchain/agents/xxx.md` | S |

### Mittelfristige Verbesserungen (nächste 2–3 Sprints)

| # | Vorschlag | Betroffene Datei | Aufwand |
|---|---|---|---|
| M1 | [Strukturelle Änderung] | `toolchain/workflows/xxx.md` | M |

### Watchlist (beobachten, noch nicht handeln)

- [Muster das beobachtet werden sollte bevor Schlüsse gezogen werden]

---

## 8. Process Change Proposals

*Verbesserungsvorschläge die eine formale Tool-Chain-Änderung erfordern:*

| PC-ID | Titel | Priorität | Status |
|---|---|---|---|
| PC-NNN | [Titel] | Hoch / Mittel / Gering | EMPFOHLEN |

*(Vollständige PC-NNN Dokumente liegen unter `projects/<projektname>/PC-NNN-*.md`)*

---

*Erstellt von: AC-Agent | Datum: YYYY-MM-DD | Sprint: N*
*Ablage: projects/[projektname]/RETRO-NNN-sprint-N.md*
