# /spike — Technischer Research-Spike

Aktiviert den **Spike-Workflow** für technische Erkundung ohne Implementierungsverpflichtung.

## Verwendung

```
/spike [projektname] [fragestellung]
/spike mein-projekt "Welche Event-Streaming-Lösung passt zu unseren Anforderungen?"
```

## Wann verwenden

- Technische Frage zu unsicher für direkte ADR-Entscheidung
- Proof-of-Concept nötig vor Architekturentscheidung
- Neue Technologie evaluieren

## Workflow

```
SPIKE-BRIEF      → PM-Agent (Fragestellung, Erfolgskriterien, Timebox definieren)
     ↓
SPIKE-RESEARCH   → AR-Agent (Analyse, PoC wenn nötig, Empfehlung)
     ↓
SPIKE-REPORT     → AR-Agent (Spike-Report: SRP-NNNNNN)
```

## Artefakte

- `SRP-NNNNNN` — Spike Report (Ergebnis, Empfehlung, Verworfene Optionen)
- Optional: PoC-Code (wird nach Spike gelöscht oder in echtes Projekt überführt)

## Abgrenzung

Ein Spike produziert **keine** produktiven Artefakte (keine US, keine ADRs).
Der Spike-Report fließt als Input in das nächste `/architect` oder `/ba`.

## Timebox

Jeder Spike hat eine definierte maximale Dauer (aus Spike-Brief). Der AR-Agent
meldet bei Überschreitung sofort und liefert Zwischenergebnis.

---

**Agent:** PM → AR (Spike-Modus)
**Workflow:** `toolchain/workflows/spike.md`
