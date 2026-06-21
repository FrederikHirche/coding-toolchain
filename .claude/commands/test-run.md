# /test-run — Automatisierte Tests ausführen

Aktiviert den **QA Engineer Agent (QA)** für die Testausführung und Ergebnisdokumentation.

## Verwendung

```
/test-run [projektname] [sprint-nummer]
```

## Was passiert

1. Liest `TP-NNN` aus `projects/<name>/testing/` und ermittelt Test-Befehle aus `STRUCTURE.md` / `ADR-001`
2. Führt automatisierte Tests stufenweise aus:
   - **Unit-Tests** — ermittelter Befehl aus ADR-001/STRUCTURE.md
   - **Integration-Tests** — ermittelter Befehl
   - **E2E-Tests (Playwright):**
     - Prüft ob `playwright.config.ts` im Projektroot vorhanden
     - Führt `npx playwright test` aus
     - Liest HTML-Report aus (Standard: `playwright-report/index.html`)
     - Kopiert/verlinkt Report nach `projects/<name>/testing/playwright-report/`
3. Erfasst alle Fehler strukturiert als BUG-NNN (in `projects/<name>/testing/`)
   - Testname + Fehlermeldung
   - Stack Trace
   - Screenshot-Pfad (Playwright speichert automatisch)
   - Reproduktionsschritte
   - Schweregrad: BLOCKER / CRITICAL / MAJOR / MINOR
4. Erstellt Testergebnis-Bericht (TR-NNN) in `projects/<name>/testing/`
5. Erstellt Test-Coverage-Report und notiert Prozentwerte
6. Gibt Freigabe-Empfehlung: APPROVED / CONDITIONAL / REJECTED

## Playwright-Spezifika

```bash
# Vollständiger Testlauf
npx playwright test

# Mit HTML-Reporter (erzeugt playwright-report/)
npx playwright test --reporter=html

# Einzelne Spec-Datei
npx playwright test tests/e2e/[feature].spec.ts

# HTML-Report öffnen
npx playwright show-report

# Bei CI-Fehler: Trace-Viewer
npx playwright show-trace playwright-report/trace.zip
```

**Report-Ablage:** `projects/<name>/testing/playwright-report/`

## Vorbedingungen

- `TP-NNN` im Status `APPROVED` (in `projects/<name>/testing/`)
- Testumgebung gemäß TP-Anforderungen konfiguriert
- Für Playwright: `playwright.config.ts` vorhanden, App läuft (Baseurl erreichbar)

## Nächster Schritt

Nach Abschluss: `/review [projektname] [sprint-nr]`

---

**Agent:** QA (QA Engineer)
**Input:** `TP-NNN`, Code-Repository, `playwright.config.ts`
**Output:** `TR-NNN`, `BUG-NNN` (bei Fehlern) — alle in `projects/<name>/testing/`
**Agent-Definition:** `toolchain/agents/qa-agent.md`
