# /analyze — Cross-Artefakt-Konsistenzprüfung

Aktiviert den **Orchestrator (ORCH)** im Analyze-Modus. Prüft, ob Requirements, Architektur,
UX-Spec und Sprint Backlog widerspruchsfrei zueinander stehen — bevor Implementierungsaufwand
in eine möglicherweise inkonsistente Spezifikation investiert wird.

## Verwendung

```
/analyze [projektname]
```

## Wann verwenden

- Optional jederzeit, wenn Verdacht auf Spec-Drift besteht (z. B. UX-Spec wurde nach
  ADR-Erstellung geändert oder eine User Story wurde nachträglich angepasst)
- Vorgezogen, wenn die Konsistenzprüfung bewusst vor dem Implementierungsstart gewünscht ist

Im Standardworkflow ist kein eigener `/analyze`-Aufruf nötig: `/implement` führt Gate 5.5
als verpflichtenden Preflight aus.

## Was passiert

1. Liest alle APPROVED `REQ-NNNNNN`, `US-NNNNNN`, `ADR-NNNNNN`, `UX-NNNNNN`, `SP-NNNNNN` und,
   falls vorhanden, `CON-000001`
2. Prüft die Kriterien aus Gate 5.5 (`toolchain/workflows/full-sprint.md`):
   - Referenz-Vollständigkeit (jede Sprint-Story hat REQ- und ggf. UX-Referenz)
   - Keine Sprint-Story widerspricht einer APPROVED ADR-Entscheidung
   - Keine Sprint-Story verletzt ein Prinzip oder einen Ausschluss aus `CON-000001`
   - Keine offene BLOCKER-Frage aus vorherigen Übergaben unadressiert
3. Gibt Gate-Bericht im Standardformat aus (`toolchain/protocols/gate-protocol.md`)
4. Bei FAIL: ordnet den Fund dem zuständigen Agenten zu (BA/AR/UX/PM) — löst ihn **nicht** selbst
5. Trägt das Ergebnis in `INDEX.md` Abschnitt "Gate-History" ein

## Vorbedingungen

- `SP-NNNNNN` vorhanden (Refinement abgeschlossen)

## Abgrenzung

`/analyze` produziert kein eigenständiges Artefakt — nur einen Gate-Bericht und einen
Gate-History-Eintrag. Es trifft keine fachliche Entscheidung und ändert keine Artefakte.

## Nächster Schritt

Bei PASS: `/implement` (führt den Preflight erneut nur aus, wenn sich Eingabeartefakte seit
dem Analyze-Lauf geändert haben)
Bei FAIL: zurück zum fundverursachenden Agenten; danach optional `/analyze` oder direkt
`/implement` mit integriertem Preflight

---

**Agent:** ORCH (Orchestrator) — Analyze-Modus
**Output:** Gate-Bericht + `INDEX.md` Gate-History-Eintrag (kein neues Artefakt)
**Agent-Definition:** `toolchain/agents/orchestrator.md`
