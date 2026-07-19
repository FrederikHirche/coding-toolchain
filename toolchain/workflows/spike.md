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

Vollständiges Template mit Header, allen Abschnitten und Übergabe-Block:
`toolchain/templates/spike-report.md`.

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

| Kriterium | Prüfung | Schwere |
|---|---|---|
| Fragestellung in einem Satz formulierbar | SRP-NNNNNN Abschnitt 1 — ein Satz, kein Absatz | BLOCKER |
| Timebox definiert | SRP-NNNNNN Header-Feld `timebox` ausgefüllt | BLOCKER |
| Erfolgskriterien messbar | SRP-NNNNNN Abschnitt 2 enthält konkrete, prüfbare Kriterien | MAJOR |

### Gate: Research → Report

| Kriterium | Prüfung | Schwere |
|---|---|---|
| Timebox eingehalten (oder Ausnahme begründet) | SRP-NNNNNN: `actual-time` ≤ `timebox`, oder Begründung in Abschnitt 3 | MAJOR |
| Empfehlung explizit (keine "es kommt drauf an"-Antworten) | SRP-NNNNNN Abschnitt 4 nennt konkrete Entscheidung | BLOCKER |
| Verworfene Optionen dokumentiert | SRP-NNNNNN Abschnitt 5 ausgefüllt | MAJOR |

## Rollback-Regeln

| Gate-Fehlschlag | Rollback-Ziel | Wer wird aktiviert |
|---|---|---|
| Gate Brief → Research | SPIKE-BRIEF | PM (Fragestellung/Timebox/Erfolgskriterien nachschärfen) |
| Gate Research → Report | SPIKE-RESEARCH | AR (weitere Recherche oder Empfehlung konkretisieren) |

## .phase Verhalten

```yaml
current-phase: SPIKE
spike-question: "Welche Event-Streaming-Lösung?"
spike-started: 2026-06-18
timebox: 4h
```

Nach Spike-Abschluss: `.phase` auf vorherigen Wert zurücksetzen.
