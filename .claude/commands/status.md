# /status — Projektzustand anzeigen

Aktiviert den **Orchestrator** im Read-only-Modus. Gibt einen vollständigen Lagebericht über ein Projekt aus.

## Verwendung

```
/status [projektname]
/status          # Listet alle Projekte aus REGISTRY.md
```

## Was passiert

1. Liest `projects/REGISTRY.md` (alle Projekte)
2. Für das angegebene Projekt:
   - Liest `.phase` (aktueller Phasenzustand)
   - Liest `INDEX.md` (alle Artefakte + Status)
   - Analysiert Gate-Kriterien der aktuellen Phase
   - Identifiziert alle Blocker
3. Gibt strukturierten Statusbericht aus
4. Empfiehlt den nächsten Slash Command

## Ausgabe-Beispiel

```
═══════════════════════════════════════
PROJEKT: mein-projekt    PHASE: ARCHITECTURE
═══════════════════════════════════════
ARTEFAKTE:
  ✅ SB-001 (APPROVED)
  ✅ REQ-001 (APPROVED), US-001..005 (APPROVED)
  ⚠️  ADR-001 (DRAFT) — GATE BLOCKIERT

BLOCKER: 1 — ADR-001 muss APPROVED sein
NÄCHSTE AKTION: /architect mein-projekt
```

## Keine Veränderungen

Dieser Command verändert keine Dateien. Rein lesend.

---

**Agent:** ORCH (Orchestrator) — Status-Modus
**Agent-Definition:** `toolchain/agents/orchestrator.md`
