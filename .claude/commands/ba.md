# /ba — Requirements Phase

Aktiviert den **Business Analyst Agent (BA)** für die Requirements-Erstellung.

## Verwendung

```
/ba [projektname]
```

## Was passiert

1. Liest den Stakeholder Brief (`SB-NNN`) aus dem Projektordner
2. Aktiviert den BA-Agenten mit seinem System-Prompt
3. Analysiert Stakeholder Brief und leitet Requirements ab
4. Erstellt `REQ-NNN-requirements.md`
5. Erstellt User Stories (`US-NNN`) für alle Must-Have und Should-Have Features
6. Erstellt Story-Map als Teil des REQ-Dokuments
7. Aktualisiert `projects/<projektname>/INDEX.md`
8. Gibt Übergabe-Zusammenfassung für `/architect` aus

## Vorbedingungen

- `SB-NNN` muss im Status `APPROVED` vorliegen

## Nächster Schritt

Nach Abschluss: `/architect` aufrufen

---

**Agent:** BA (Business Analyst)
**Input:** `SB-NNN`
**Output:** `REQ-NNN`, `US-NNN`
**Templates:** `toolchain/templates/requirements.md`, `toolchain/templates/user-story.md`
**Agent-Definition:** `toolchain/agents/ba-agent.md`
