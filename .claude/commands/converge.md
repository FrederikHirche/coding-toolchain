# /converge — Brownfield-Gap-Analyse

Aktiviert den **Software Architect Agent (AR)** im Converge-Modus für die Bestandsaufnahme
einer bereits existierenden Codebase.

## Verwendung

```
/converge [projektname] [pfad-zu-code]
/converge mein-projekt "src/"
```

## Wann verwenden

- Ein Projekt mit bereits existierendem Code wird in die Tool Chain aufgenommen (Brownfield)
- Verdacht auf Drift zwischen Spezifikation (REQ/ADR) und tatsächlichem Code
- Vor Sprint-Planung bei Übernahme eines Altprojekts — um zu wissen, was schon fertig ist

## Workflow

```
SCAN     → AR-Agent (Codebase-Struktur, Frameworks, Datenmodelle, Tests erfassen)
     ↓
MATCH    → AR-Agent (Abgleich mit REQ/US/ADR — oder Ist-Architektur, falls keine Spec existiert)
     ↓
REPORT   → AR-Agent (Gap-Analyse: GAP-NNNNNN)
```

## Artefakte

- `GAP-NNNNNN` — Gap-Analyse (Abdeckungsmatrix, Architektur-Drift, Empfehlung)
- Optional: Vorschläge für retroaktive `SB-NNNNNN`/`REQ-NNNNNN`/`ADR-NNNNNN` (werden NICHT
  automatisch angelegt — nur empfohlen)

## Abgrenzung

Converge ist **kein Code Review** (das leistet `/review`) und **kein automatischer Fix** —
es ändert keinen Code. Es liefert nur die Grundlage für die nächste Entscheidung.

## Nächster Schritt

Abhängig von der Empfehlung in GAP-NNNNNN Abschnitt 6:
- Retroaktive Discovery/Requirements/Architektur nötig → `/kickoff`, `/ba` oder `/architect`
- Spezifikation vollständig, nur Drift-Korrektur nötig → `/architect [projektname]`
- Codebase deckt Anforderungen bereits vollständig ab → `/refine [projektname] [sprint-nr]`

---

**Agent:** AR (Software Architect) — Converge-Modus
**Workflow:** `toolchain/workflows/converge.md`
