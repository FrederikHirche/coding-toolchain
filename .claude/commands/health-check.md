# /health-check — Übergreifende Prozessanalyse

Aktiviert den **Agile Coach Agent (AC)** für eine sprint-übergreifende Prozessanalyse.
Empfohlen ab Sprint 4 oder nach deutlich spürbarem Prozess-Widerstand.

## Verwendung

```
/health-check [projektname]
/health-check mein-projekt
```

## Was passiert

1. Liest ALLE verfügbaren Sprint-Daten des Projekts:
   - Alle `.phase`-Einträge (Phasendauern, Blockaden je Sprint)
   - Alle `RETRO-NNN` (falls vorhanden)
   - Alle `RV-NNN` (wiederkehrende Review-Finding-Kategorien)
   - Alle `BUG-NNN` (Fehlermuster über Sprints)
   - `DECISIONS.md` (bereute oder revidierte Entscheidungen)
2. Analysiert systemische Muster in 6 Schwerpunkten:
   - Wiederkehrende Probleme sprint-übergreifend
   - Gate-Statistik (welche Gates scheitern am häufigsten?)
   - Strukturell lückenhafte Artefakte
   - Übergabe-Schwachstellen zwischen Agenten
   - Velocity-Trend (schneller / langsamer / stabil)
   - Prozessreife je Phase
3. Erstellt PC-NNN mit 3–7 priorisierten Verbesserungsvorschlägen
   (je Vorschlag: Problem → Ursache → Empfehlung → betroffene Dateien → Aufwand S/M/L)

## Vorbedingungen

- Mindestens 3 abgeschlossene Sprints empfohlen
- Mindestens `RV-NNN` und `TR-NNN` aus vergangenen Sprints vorhanden

## Ergebnis

Ein `PC-NNN` mit priorisierten, konkreten Verbesserungsvorschlägen für die Tool Chain —
nach Impact/Aufwand-Verhältnis geordnet.

---

**Agent:** AC (Agile Coach)
**Input:** Alle Sprint-Artefakte des Projekts, `DECISIONS.md`, alle `RETRO-NNN`
**Output:** `PC-NNN`
**Template:** `toolchain/templates/process-change.md`
**Agent-Definition:** `toolchain/agents/agile-coach-agent.md`
