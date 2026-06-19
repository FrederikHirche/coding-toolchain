# /impediment — Impediment-Interview starten

Aktiviert den **Agile Coach Agent (AC)** für ein strukturiertes Interview zur Impediment-Erkennung.

Der Unterschied zu `/coach`: Hier bringt der Nutzer **kein formuliertes Problem** mit —
der AC führt ein Interview durch, um das Impediment gemeinsam zu benennen.

## Verwendung

```
/impediment [projektname]
```

Ohne Projektname: AC fragt zuerst nach dem Projekt, dann startet das Interview.

## Was passiert

1. AC stellt gezielt 4–6 Fragen, um das Impediment zu lokalisieren und zu benennen
2. Nach dem Interview: AC liest relevante Artefakte (`.phase`, `INDEX.md`, `DECISIONS.md`)
3. Erstellt Diagnose: Was ist das Impediment, wo sitzt es, wie schwer ist es?
4. Gibt eine Sofortmaßnahme und eine strukturelle Empfehlung aus
5. Erstellt `IMPD-NNN` Impediment-Dokument
6. Erstellt `PC-NNN` wenn eine Tool-Chain-Änderung empfohlen wird

## Unterschied zu anderen AC-Commands

| Command | Einstieg | Ziel |
|---------|----------|------|
| `/impediment` | Nutzer spürt Friction, kann sie nicht benennen | Interview → Impediment benennen → Lösung |
| `/coach` | Nutzer bringt konkretes Problem | Diagnose → Handlungsempfehlung |
| `/retro` | Sprint abgeschlossen | Strukturierte Retrospektive |
| `/health-check` | 3+ Sprints abgeschlossen | Systemische Muster über Sprints |

## Vorbedingungen

- Keine — jederzeit aufrufbar, auch mitten im Sprint

## Nächster Schritt

Nach Abschluss: Sofortmaßnahme aus `IMPD-NNN` umsetzen.
Falls strukturelle Tool-Chain-Änderung nötig: `/coach [projektname]` für PC-NNN.

---

**Agent:** AC (Agile Coach)
**Input:** Interview-Antworten des Nutzers + situativ relevante Projektartefakte
**Output:** `IMPD-NNN`, ggf. `PC-NNN`
**Template:** `toolchain/templates/impediment.md`, `toolchain/templates/process-change.md`
**Agent-Definition:** `toolchain/agents/agile-coach-agent.md`
