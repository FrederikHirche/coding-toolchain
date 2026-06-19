# /coach — Ad-hoc Prozessberatung

Aktiviert den **Agile Coach Agent (AC)** für sofortige, situative Prozessberatung.
Kein abgeschlossener Sprint nötig — jederzeit aufrufbar bei konkretem Prozess-Problem.

## Verwendung

```
/coach [projektname] [optionale Problembeschreibung]
/coach mein-projekt "Reviews dauern immer dreimal so lang wie geplant"
```

## Was passiert

1. Stellt 1–2 Klärungsfragen wenn das Problem noch unklar ist
2. Liest gezielt die relevanten Artefakte (je nach Problem):
   - `.phase` (wenn Prozess-Fluss betroffen)
   - `DECISIONS.md` (wenn Entscheidungs-Qualität betroffen)
   - `INDEX.md` (wenn Gate-Probleme betroffen)
   - Spezifische Agenten-Dateien (wenn Rollen-Problem)
3. Stellt Diagnose: Was ist die eigentliche Ursache?
4. Gibt konkrete, handlungsorientierte Empfehlung mit Dateireferenz
5. Erstellt PC-NNN wenn die Empfehlung eine Tool-Chain-Änderung bedeutet

## Typische Anwendungsfälle

- Ein Artefakt wird immer wieder lückenhaft geliefert
- Eine Übergabe zwischen zwei Agenten erzeugt regelmäßig Nacharbeit
- Ein Gate-Kriterium fühlt sich sinnlos oder zu streng an
- Die Phasendauer einer Phase ist systematisch zu hoch
- Ein Template deckt den tatsächlichen Bedarf nicht ab

## Haltung des AC

- Kein Dogmatismus: Prozesse dienen Menschen, nicht umgekehrt
- Lieber einen Schritt weglassen als ihn blind ausführen
- Die beste Verbesserung ist die, die tatsächlich umgesetzt wird

---

**Agent:** AC (Agile Coach)
**Input:** Nutzer-Beschreibung + situativ relevante Projektartefakte
**Output:** Handlungsempfehlung (Text), ggf. `PC-NNN`
**Template:** `toolchain/templates/process-change.md` (nur wenn PC nötig)
**Agent-Definition:** `toolchain/agents/agile-coach-agent.md`
