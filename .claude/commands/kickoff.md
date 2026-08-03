# /kickoff — Discovery Phase starten

Aktiviert den **Product Manager Agent (PM)** für eine neue Projektsitzung.

## Verwendung

```
/kickoff [projektname]
```

Ohne Argument wird nach dem Projektnamen gefragt.

## Was passiert

1. Legt `projects/<projektname>/` an — als Kopie von `projects/_template/`
   (falls der Ordner nicht bereits existiert)
2. Initialisiert dort ein **eigenes Git-Repository** (`git init`) — das Projekt ist NICHT
   Teil des Toolchain-Repositorys; Root-`.gitignore` schließt `projects/*` entsprechend aus
3. Aktiviert den PM-Agenten mit seinem System-Prompt (aus `toolchain/agents/pm-agent.md`)
4. Führt ein strukturiertes Stakeholder-Interview durch (5 Runden, je 3–5 Fragen)
5. Erstellt `projects/<projektname>/discovery/SB-000001-<projektname>.md`
6. Erstellt `projects/<projektname>/discovery/CON-000001-<projektname>.md` (Projekt-Constitution
   — nicht verhandelbare Prinzipien und Qualitäts-Mindeststandards, bindend für alle Folgephasen)
7. Fragt, ob das Projekt zusätzlich in einem GitHub Project Board geführt werden soll
   (Backlog/Status automatisch aus den Tool-Chain-Artefakten befüllt) — bei Zustimmung wird
   das Board samt Custom Fields (Estimate/Size/Priority/Iteration/Start-/Zieldatum)
   provisioniert und der `github:`-Block in `.toolchain.yml` befüllt (siehe
   `toolchain/protocols/github-board-sync.md`); jederzeit auch später nachholbar
8. Aktualisiert `projects/<projektname>/INDEX.md`
9. Falls `github.enabled: true` (Board bereits vorhanden, z. B. bei erneutem `/kickoff` auf
   einem laufenden Projekt): `github-board-sync` im Modus `push` ausführen — bei einem
   frischen Projekt ohne vorausgeplanten Backlog ist dieser Lauf ein No-Op
10. Gibt Übergabe-Zusammenfassung für `/ba` aus

## Vorbedingungen

- Keine — das ist der Einstiegspunkt der Tool Chain

## Nächster Schritt

Nach Abschluss: `/ba` aufrufen

---

**Agent:** PM (Product Manager)
**Output:** `SB-NNNNNN` Stakeholder Brief, `CON-000001` Projekt-Constitution
**Template:** `toolchain/templates/stakeholder-brief.md`, `toolchain/templates/constitution.md`
**Agent-Definition:** `toolchain/agents/pm-agent.md`
