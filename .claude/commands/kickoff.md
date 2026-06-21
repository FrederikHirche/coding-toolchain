# /kickoff — Discovery Phase starten

Aktiviert den **Product Manager Agent (PM)** für eine neue Projektsitzung.

## Verwendung

```
/kickoff [projektname]
```

Ohne Argument wird nach dem Projektnamen gefragt.

## Was passiert

1. Legt `projects/<projektname>/` an (falls nicht vorhanden)
2. Legt `projects/<projektname>/INDEX.md` an
3. Aktiviert den PM-Agenten mit seinem System-Prompt (aus `toolchain/agents/pm-agent.md`)
4. Führt ein strukturiertes Stakeholder-Interview durch (max. 3 Runden à max. 3 Fragen)
5. Erstellt `projects/<projektname>/SB-000001-<projektname>.md`
6. Aktualisiert `projects/<projektname>/INDEX.md`
7. Gibt Übergabe-Zusammenfassung für `/ba` aus

## Vorbedingungen

- Keine — das ist der Einstiegspunkt der Tool Chain

## Nächster Schritt

Nach Abschluss: `/ba` aufrufen

---

**Agent:** PM (Product Manager)
**Output:** `SB-NNNNNN` Stakeholder Brief
**Template:** `toolchain/templates/stakeholder-brief.md`
**Agent-Definition:** `toolchain/agents/pm-agent.md`
