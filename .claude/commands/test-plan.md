# /test-plan — Testplan erstellen

Aktiviert den **QA Engineer Agent (QA)** für die Testplanung.

## Verwendung

```
/test-plan [projektname] [sprint-nummer]
```

## Was passiert

1. Liest alle US-NNNNNN und UX-NNNNNN des Sprints
2. Liest Übergabeprotokolle von FE- und BE-Agenten
3. Erstellt manuellen Testplan (TP-NNNNNN) mit dem Template
4. Schreibt fehlende automatisierte Tests (ergänzt FE/BE-Tests)
5. Definiert Testumgebungs-Anforderungen
6. Priorisiert Testfälle: P0 / P1 / P2
7. Aktualisiert INDEX.md

## Vorbedingungen

- Implementierung des Sprints abgeschlossen (`/implement` done)
- Übergabeprotokolle von FE- und BE-Agenten vorhanden

## Nächster Schritt

Nach Abschluss: `/test-run`

---

**Agent:** QA (QA Engineer)
**Input:** US-NNNNNN, UX-NNNNNN, FE/BE-Übergabe
**Output:** `TP-NNNNNN`
**Template:** `toolchain/templates/test-plan.md`
**Agent-Definition:** `toolchain/agents/qa-agent.md`
