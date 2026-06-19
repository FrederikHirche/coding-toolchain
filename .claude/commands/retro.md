# /retro — Sprint-Retrospektive

Aktiviert den **Agile Coach Agent (AC)** für eine strukturierte Sprint-Retrospektive.

## Verwendung

```
/retro [projektname] [sprint-nummer]
/retro mein-projekt 1
```

## Was passiert

1. Stellt dem Nutzer 2–3 gezielte Einstiegsfragen zum Sprint-Erleben
2. Liest nach Antwort alle relevanten Sprint-Artefakte:
   - `.phase` (Phasendauern, Blockaden)
   - `DECISIONS.md` (Entscheidungshistorie)
   - `INDEX.md` (Gate-Ergebnisse)
   - Alle `RV-NNN`, `TR-NNN`, `BUG-NNN`, `SP-NNN` des Sprints
3. Analysiert den Sprint in 5 Dimensionen:
   - Prozess-Fluss (Phasen, Gates)
   - Artefakt-Qualität
   - Agenten-Performance & Übergaben
   - Entscheidungsqualität
   - Nutzer-Perspektive
4. Erstellt RETRO-NNN mit Keep / Stop / Start
5. Erstellt PC-NNN wenn strukturelle Tool-Chain-Änderung empfohlen wird
6. Aktualisiert INDEX.md

## Vorbedingungen

- Sprint abgeschlossen (`.phase` auf `DONE`)
- Mindestens `RV-NNN` und `TR-NNN` vorhanden

## Ergebnis

- **Quick Wins** — sofort umsetzbare Verbesserungen
- **Mittelfristige Maßnahmen** — strukturelle Änderungen
- **Watchlist** — Muster zur Beobachtung

---

**Agent:** AC (Agile Coach)
**Input:** `.phase`, `DECISIONS.md`, `RV-NNN`, `TR-NNN`, `BUG-NNN`, `SP-NNN`
**Output:** `RETRO-NNN`, ggf. `PC-NNN`
**Template:** `toolchain/templates/retrospective.md`
**Agent-Definition:** `toolchain/agents/agile-coach-agent.md`
