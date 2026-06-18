# /review — Code Review

Aktiviert den **Code Reviewer Agent (RV)** für das finale Code Review.

## Verwendung

```
/review [projektname] [sprint-nummer]
```

## Was passiert

1. Liest Code-Diff des Sprints (oder spezifizierten Branch)
2. Liest TR-NNN (Testergebnisse) und TP-NNN (Testplan)
3. Liest alle ADRs als Referenz für Konformitätsprüfung
4. Führt Review in 6 Dimensionen durch:
   - Korrektheit → Sicherheit → ADR-Konformität →
     Code-Qualität → Testabdeckung → Performance
5. Erstellt Review-Bericht (RV-NNN) mit allen Anmerkungen
6. Gibt Merge-Entscheidung: APPROVED / REQUEST CHANGES / REJECTED
7. Erfasst technische Schulden (falls vorhanden)
8. Aktualisiert INDEX.md

## Vorbedingungen

- `TR-NNN` vorhanden (Testergebnisse)
- Keine BLOCKER-Bugs offen (aus `/test-run`)
- QA-Freigabe-Empfehlung nicht REJECTED

## Nächster Schritt

- Bei APPROVED: Merge durchführen
- Bei REQUEST CHANGES: Zu `/implement` zurückkehren
- Bei REJECTED: PM-Agenten informieren (Scope-Problem)

---

**Agent:** RV (Code Reviewer)
**Input:** Code-Diff, `TR-NNN`, `TP-NNN`, ADRs, `US-NNN`
**Output:** `RV-NNN`
**Template:** `toolchain/templates/review-checklist.md`
**Agent-Definition:** `toolchain/agents/reviewer-agent.md`
