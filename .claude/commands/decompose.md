# /decompose — Kopplungs-/Grenzenanalyse für Service-Aufspaltung

Aktiviert den **Software Architect Agent (AR)** im Decompose-Modus für eine Kopplungs-
und Kohäsionsanalyse einer bereits existierenden Codebase, um belegte Kandidaten für eine
Aufspaltung in eigenständige Services zu identifizieren.

## Verwendung

```
/decompose [projektname] [pfad-optional]
/decompose mein-projekt "src/payments"
```

## Wann verwenden

- Verdacht, dass ein Modul/eine Komponente zu monolithisch gewachsen ist
- Vor einer größeren Architekturentscheidung, wenn unklar ist, ob eine Aufspaltung
  überhaupt technisch sinnvoll wäre (Kopplung könnte das verhindern)
- Nach mehreren Sprints, um zu prüfen, ob sich de-facto-Modulgrenzen im Code gebildet
  haben, die noch nicht als Services abgebildet sind

## Workflow

```
SCAN     → AR-Agent (Cluster/Cohesion via get_architecture erfassen)
     ↓
ANALYZE  → AR-Agent (Fan-in/Fan-out, Cross-Cluster-Kopplung, Zyklen; Kandidat/Noch-nicht-
           bereit einstufen)
     ↓
DRAFT    → AR-Agent (ADR-Entwurf pro Kandidat verfassen, Status DRAFT)
     ↓
REPORT   → AR-Agent (Decomposition-Analyse: DCP-NNNNNN)
```

## Artefakte

- `DCP-NNNNNN` — Decomposition-Analyse (Cluster-/Kopplungsdaten, Service-Kandidaten,
  eingebetteter ADR-Entwurf pro Kandidat)
- Optional: `DEBT-NNNNNN` für Entkopplungs-Vorarbeit bei Noch-nicht-bereit-Clustern

## Abgrenzung

`/decompose` ist **kein automatischer Refactor** — es ändert keinen Code und erzwingt
keine Aufspaltung. Es ist auch **kein `/converge`** — Converge prüft Spec-Abdeckung und
Architektur-Drift, `/decompose` prüft ausschließlich Kopplung/Kohäsion des Bestandscodes.
Der ADR-Entwurf in DCP-NNNNNN ist erst nach Ratifizierung via `/architect` bindend — bis
dahin bleibt er Status `DRAFT`.

## Nächster Schritt

Abhängig vom Ergebnis in DCP-NNNNNN:
- Mindestens ein Kandidat mit ADR-Entwurf → `/architect [projektname]` (ratifiziert den
  Entwurf als eigene `ADR-NNNNNN`)
- Kein Cluster bereit (zu stark gekoppelt) → keine Folgephase nötig, DCP-NNNNNN steht für
  sich; ggf. `DEBT-NNNNNN` für die identifizierte Entkopplungs-Vorarbeit

---

**Agent:** AR (Software Architect) — Decompose-Modus
**Workflow:** `toolchain/workflows/decompose.md`
