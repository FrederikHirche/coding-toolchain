# /test-run — Automatisierte Tests ausführen

Aktiviert den **QA Engineer Agent (QA)** für die Testausführung und Ergebnisdokumentation.

## Verwendung

```
/test-run [projektname] [sprint-nummer]
```

## Was passiert

1. Liest TP-NNN und ermittelt Test-Befehle aus STRUCTURE.md / ADR-001
2. Führt automatisierte Tests aus (Unit → Integration → E2E)
3. Erfasst alle Fehler strukturiert (BUG-NNN)
4. Erstellt Testergebnis-Bericht (TR-NNN)
5. Erstellt Test-Coverage-Report
6. Gibt Freigabe-Empfehlung: APPROVED / CONDITIONAL / REJECTED
7. Aktualisiert INDEX.md

## Vorbedingungen

- `TP-NNN` im Status `APPROVED`
- Testumgebung gemäß TP-Anforderungen konfiguriert

## Nächster Schritt

Nach Abschluss: `/review`

---

**Agent:** QA (QA Engineer)
**Input:** `TP-NNN`, Code-Repository
**Output:** `TR-NNN`, `BUG-NNN` (bei Fehlern)
**Agent-Definition:** `toolchain/agents/qa-agent.md`
