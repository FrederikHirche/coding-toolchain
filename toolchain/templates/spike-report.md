---
id: SRP-NNNNNN
title: Spike: [Fragestellung]
version: 1.0
status: DRAFT
author-agent: AR (Software Architect)
date: YYYY-MM-DD
based-on: SB-NNNNNN (falls vorhanden)
timebox: [H]h
actual-time: [H]h
supersedes: —
superseded-by: —
ablage: projects/<name>/architecture/
---

# Spike: [Fragestellung]

## 1. Fragestellung

[Was sollte herausgefunden werden? Ein Satz.]

## 2. Erfolgskriterien

[Wann ist der Spike erfolgreich? Konkret und messbar.]

## 3. Ergebnis

[Was wurde herausgefunden? Fakten, Messwerte, PoC-Beobachtungen.]

## 4. Empfehlung

[Was soll als nächstes passieren? Entscheidung klar benennen — keine "es kommt drauf an"-Antworten.]

## 5. Verworfene Optionen

[Was wurde warum ausgeschlossen?]

## 6. Offene Fragen

[Was blieb ungeklärt?]

## 7. Nächster Schritt

- [ ] Empfehlung → `ADR-NNNNNN` anlegen mit `/architect [projektname]`
- [ ] Weitere Erkundung nötig → neuer Spike mit `/spike [projektname] [neue Frage]`
- [ ] Idee verwerfen → Begründung oben in Abschnitt 5 dokumentiert

---

## Übergabe: AR → PM/Nutzer (Spike abgeschlossen)

**Datum:** YYYY-MM-DD
**Von:** Software Architect (AR)
**An:** Product Manager (PM) / Nutzer
**Nächster Befehl:** `/architect [projektname]` (bei ADR-Empfehlung) oder `/spike [projektname] [neue Frage]`

### Übergebene Artefakte

| Artefakt-ID | Status | Pfad | Hinweise |
|-------------|--------|------|---------|
| SRP-NNNNNN | DRAFT | `projects/<name>/architecture/SRP-NNNNNN-<thema>.md` | Empfehlung siehe Abschnitt 4 |

### Kritische Informationen für Empfänger

[Was muss der Empfänger wissen, das nicht direkt aus dem Report hervorgeht?]

### Offene Fragen (vererbt)

| # | Frage | Ursprung | Kritikalität | An wen |
|---|-------|---------|-------------|--------|
| 1 | [Offene Frage aus Abschnitt 6] | Spike-Research | BLOCKER/MAJOR/MINOR | [Wer muss antworten?] |

### Nicht-Ziele (explizit ausgeschlossen)

- Kein produktiver Code, keine User Stories, keine ADRs wurden im Rahmen des Spikes erstellt.
- PoC-Code (falls vorhanden) ist temporär und wird nach dem Spike gelöscht oder migriert.

### Empfehlungen

[Siehe Abschnitt 4 — hier ggf. mit zusätzlichem Kontext für den Empfänger.]

---

*Erstellt von: AR-Agent | Datum: YYYY-MM-DD | Version: 1.0 | Ablage: `projects/<name>/architecture/`*

---

## Änderungshistorie

| Version | Datum | Änderung | Agent |
|---|---|---|---|
| 1.0 | YYYY-MM-DD | Initiale Version | AR |
