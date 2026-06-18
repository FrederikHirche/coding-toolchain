# Protokoll-Verzeichnis

Formale Verträge und Standards, die alle Agenten verbindlich einhalten.

Letzte Aktualisierung: 2026-06-18

## Inhalt

| Datei | ID | Beschreibung |
|-------|-----|-------------|
| `handoff-protocol.md` | PROTO-HANDOFF | Standard-Format für Übergaben zwischen Agenten |
| `gate-protocol.md` | PROTO-GATE | Qualitäts-Gate-Schweregrade, -Ausgabe und -Entscheidungslogik |
| `artifact-lifecycle.md` | PROTO-LIFECYCLE | Artefakt-Statusübergänge, Versionierung, Archivierung |

## Hierarchie

```
_base-agent.md          ← Erbt automatisch alle Protokolle
     ↑
Alle Agent-Definitionen ← Referenzieren spezifische Protokolle
     ↑
Workflows               ← Nutzen gate-protocol.md für Gate-Entscheidungen
```

## Verbindlichkeit

Diese Protokolle sind für alle Agenten **verbindlich**. Agenten-spezifische Dateien dürfen
Protokolle nicht überschreiben — nur ergänzen.
