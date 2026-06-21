---
id: WF-SPIKE
title: Technischer Research-Spike
version: 1.0
status: ACTIVE
---

# Workflow: Spike

Strukturierter Erkundungs-Workflow für technische Fragestellungen ohne Implementierungsverpflichtung.

## Aktivierung

```
/spike [projektname] [fragestellung]
```

## Wann Spike verwenden

- Technologieentscheidung ist zu unsicher für direkten ADR
- Proof-of-Concept nötig um Machbarkeit zu validieren
- Neue externe Abhängigkeit evaluieren (Library, Service, API)
- Performance-Annahme verifizieren

## Spike ≠ Sprint-Phase

Ein Spike ist **kein Sprint** und **kein ADR**. Er ist eine zeitlich begrenzte Erkundung.
Ein Spike-Ergebnis (`SRP-NNNNNN`) fließt als Input in den nächsten `/architect`-Aufruf.

## Phasen-Sequenz

```
SPIKE-BRIEF
  [PM] — Fragestellung schärfen, Timebox festlegen, Erfolgskriterien definieren
  Output: Spike-Brief (Teil von SRP-NNNNNN, Abschnitt 1)
        ↓
SPIKE-RESEARCH
  [AR] — Analyse, Recherche, ggf. minimales PoC
  PoC-Code: temporär, wird nach Spike gelöscht oder migriert
        ↓
SPIKE-REPORT
  [AR] — Ergebnisse zusammenfassen, Empfehlung aussprechen
  Output: SRP-NNNNNN (Spike Report)
```

## Spike Report Format (`SRP-NNNNNN`)

```markdown
---
id: SRP-NNNNNN
title: Spike: [Fragestellung]
version: 1.0
status: DRAFT
author-agent: AR
date: YYYY-MM-DD
timebox: [H]h
actual-time: [H]h
---

## 1. Fragestellung
[Was sollte herausgefunden werden?]

## 2. Erfolgskriterien
[Wann ist der Spike erfolgreich?]

## 3. Ergebnis
[Was wurde herausgefunden?]

## 4. Empfehlung
[Was soll als nächstes passieren? Entscheidung klar benennen]

## 5. Verworfene Optionen
[Was wurde warum ausgeschlossen?]

## 6. Offene Fragen
[Was blieb ungeklärt?]

## 7. Nächster Schritt
[ ] Empfehlung → ADR-NNNNNN anlegen mit /architect
[ ] Weitere Erkundung nötig → Neuer Spike
[ ] Idee verwerfen → Begründung dokumentieren
```

## Timebox-Regeln

| Spike-Typ | Maximale Timebox |
|---|---|
| Bibliotheks-Evaluation | 2h |
| API-Integration prüfen | 4h |
| Architektur-PoC | 8h |
| Performance-Test | 4h |

Wenn Timebox erreicht: Spike-Report mit Zwischenergebnis abgeben. Kein unkontrolliertes Overspend.

## Gates

### Gate: Brief → Research

| Kriterium | Schwere |
|---|---|
| Fragestellung in einem Satz formulierbar | BLOCKER |
| Timebox definiert | BLOCKER |
| Erfolgskriterien messbar | MAJOR |

### Gate: Research → Report

| Kriterium | Schwere |
|---|---|
| Timebox eingehalten (oder Ausnahme begründet) | MAJOR |
| Empfehlung explizit (keine "es kommt drauf an"-Antworten) | BLOCKER |
| Verworfene Optionen dokumentiert | MAJOR |

## .phase Verhalten

```yaml
current-phase: SPIKE
spike-question: "Welche Event-Streaming-Lösung?"
spike-started: 2026-06-18
timebox: 4h
```

Nach Spike-Abschluss: `.phase` auf vorherigen Wert zurücksetzen.
