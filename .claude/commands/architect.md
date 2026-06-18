# /architect — Architektur-Phase

Aktiviert den **Software Architect Agent (AR)** für Technologieentscheidungen und Systemdesign.

## Verwendung

```
/architect [projektname]
```

## Was passiert

1. Liest REQ-NNN und alle US-NNN aus dem Projektordner
2. Aktiviert den Architect-Agenten mit seinem System-Prompt
3. Erstellt ADR-001 (Tech-Stack-Entscheidung)
4. Erstellt weitere ADRs für wesentliche Einzelentscheidungen
5. Erstellt System-Design-Dokumentation
6. Erstellt STRUCTURE.md (Projektverzeichnisstruktur)
7. Aktualisiert `projects/<projektname>/INDEX.md`
8. Gibt Übergabe-Zusammenfassung für `/ux` und Dev-Agenten aus

## Vorbedingungen

- `REQ-NNN` im Status `APPROVED`
- Mind. eine `US-NNN` vorhanden

## Nächster Schritt

Nach Abschluss: `/ux` (parallel möglich mit Implementierungsvorbereitung)

---

**Agent:** AR (Software Architect)
**Input:** `SB-NNN`, `REQ-NNN`, `US-NNN`
**Output:** `ADR-NNN`, `STRUCTURE.md`
**Template:** `toolchain/templates/architecture-decision.md`
**Agent-Definition:** `toolchain/agents/architect-agent.md`
