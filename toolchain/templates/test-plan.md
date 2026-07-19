---
id: TP-NNNNNN
title: Testplan [Projekttitel] Sprint NNNNNN
version: 1.0
status: DRAFT
author-agent: QA (QA Engineer)
date: YYYY-MM-DD
sprint: NNNNNN
based-on: US-NNNNNN (kommagetrennte Liste)
supersedes: —
superseded-by: —
ablage: projects/<name>/testing/
---

# Testplan: [Projekttitel] — Sprint NNNNNN

## 1. Testumfang

**Getestete Features (Sprint NNNNNN):**
- US-NNNNNN: [Titel]
- US-NNNNNN: [Titel]

**Explizit NICHT getestet (Begründung):**
- [Feature / Bereich] — [Grund: z. B. außerhalb Sprint-Scope, wird manuell getestet]

---

## 2. Testumgebung

| Eigenschaft | Wert |
|---|---|
| Umgebung | [local / staging / production] |
| URL/Endpoint | [URL oder localhost:PORT] |
| Testdaten-Setup | [Beschreibung — Seed-Script, Fixtures, ...] |
| Notwendige Umgebungsvariablen | [Liste] |
| Abhängige Services | [z. B. DB, externe APIs — gemockt oder live?] |

---

## 3. Automatisierte Tests

### 3.1 Test-Coverage-Ziel

| Ebene | Ziel | Aktueller Stand |
|---|---|---|
| Unit | ≥ 80% | [Stand vor Sprint] |
| Integration | ≥ 60% | [Stand vor Sprint] |
| E2E | Kritische Flows | [Stand vor Sprint] |

### 3.2 Ausführungsbefehl

```bash
# Unit Tests
[Befehl aus ADR-000001 / STRUCTURE.md]

# Integration Tests
[Befehl]

# E2E Tests (Playwright)
npx playwright test --reporter=html

# Coverage-Report
[Befehl]
```

### 3.3 Playwright E2E — Testinventar

**Konfigurationsdatei:** `playwright.config.ts` (Projektroot)

**Playwright Report-Ablage:** `projects/<name>/testing/playwright-report/`

**Browser-Ansicht und UI-Clickpfade:**
- Wichtige UI-Clickpfade werden in einem Testlauf bevorzugt im Playwright-UI-/headed-Modus geprüft (kein zusätzlicher zweiter headless-Durchlauf derselben Specs).
- Ist headed/UI-Modus technisch nicht möglich, ist dies mit Begründung in TR-NNNNNN zu dokumentieren — stillschweigendes Überspringen ist nicht zulässig.

**Zu erstellende / vorhandene Testdateien:**

| Testdatei | Feature-Bereich | US-Referenz | Status |
|---|---|---|---|
| `tests/e2e/[feature].spec.ts` | [Bereich] | US-NNNNNN | [ ] vorhanden / [ ] zu erstellen |

**Page Objects (POM):**

| Page-Object-Datei | Beschreibt | Benötigte `data-testid` Attribute |
|---|---|---|
| `tests/e2e/pages/[page].page.ts` | [Seite/View] | `[data-testid="..."]` (Liste) |

**Testfälle pro Spec-Datei:**

| TC-ID | Beschreibung | Typ | Priorität |
|---|---|---|---|
| E2E-000001 | [Happy Path] | Happy Path | P0 |
| E2E-000002 | [Fehlerfall] | Error Case | P1 |
| E2E-000003 | [Accessibility] | A11y | P1 |

**Voraussetzungen für E2E-Lauf:**
- [ ] App läuft auf `[baseURL aus playwright.config.ts]`
- [ ] Testdaten-Seed ausgeführt: `[Befehl]`
- [ ] Umgebungsvariablen gesetzt: `[Liste]`

### 3.4 Performanztests

Zielwerte stammen aus den Non-Functional Requirements (REQ-NNNNNN) oder aus `ADR-000001`
(Performance-Budget). Ist kein Budget definiert, ist dies statt eines leeren `[Ziel]`-Platzhalters
explizit zu vermerken: "kein Performance-Budget definiert — Ausgangsmessung dokumentiert".

| ID | Bereich | Methode | Erwartetes Ergebnis |
|---|---|---|---|
| PERF-000001 | Seitenladezeit | Browser-Performance-Messung (z. B. `performance.timing`, Lighthouse-CI) | Ladezeit unter [Ziel] s |
| PERF-000002 | Interaktionslatenz | Klick-/Eingabe-Flow in Browser (Playwright-Tracing) | Reaktion innerhalb [Ziel] ms |
| PERF-000003 | API-Antwortzeit | Netzwerk-/Backend-Messung (z. B. Playwright Network-Events) | Antwortzeit unter [Ziel] ms |
| PERF-000004 | Ressourcenverbrauch | Browser- und Server-Metriken (z. B. Playwright Tracing, Server-Monitoring) | Keine auffälligen Peaks / Budget eingehalten |

---

## 4. Manuelle Testfälle

### Feature: [US-NNNNNN — Titel]

#### TC-000001: [Testfall-Titel] — P0 (Blocker)

| Feld | Inhalt |
|---|---|
| **Vorbedingungen** | [Was muss vor dem Test zutreffen?] |
| **Testschritte** | 1. [Schritt] \| 2. [Schritt] \| 3. [Schritt] |
| **Erwartetes Ergebnis** | [Was soll passieren?] |
| **Tatsächliches Ergebnis** | *(wird bei Ausführung befüllt)* |
| **Status** | ⬜ Nicht getestet |
| **Anmerkungen** | — |

#### TC-000002: [Fehlerfalltest] — P1 (Kritisch)

| Feld | Inhalt |
|---|---|
| **Vorbedingungen** | [Fehlerzustand herbeiführen] |
| **Testschritte** | 1. [Schritt] |
| **Erwartetes Ergebnis** | [Fehlermeldung / Fallback] |
| **Tatsächliches Ergebnis** | *(wird bei Ausführung befüllt)* |
| **Status** | ⬜ Nicht getestet |
| **Anmerkungen** | — |

*Status-Werte: ⬜ Nicht getestet | ✅ Bestanden | ❌ Fehlgeschlagen | ⚠️ Blockiert*

---

## 5. Sicherheits-Smoke-Tests

| ID | Test | Methode | Erwartetes Ergebnis |
|---|---|---|---|
| SEC-000001 | Unautorisierter Zugriff auf geschützte Route | Direktaufruf ohne Token | HTTP 401 / Redirect Login |
| SEC-000002 | SQL-Injection im Suchfeld | Eingabe: `' OR '1'='1` | Kein Datenleck, saubere Fehlermeldung |
| SEC-000003 | XSS im Textfeld | Eingabe: `<script>alert(1)</script>` | Kein Script-Execution |

---

## 6. Testergebnis-Zusammenfassung

*(Wird nach Testausführung befüllt)*

| Kategorie | Bestanden | Fehlgeschlagen | Nicht getestet |
|---|---|---|---|
| Automatisiert — Unit | — | — | — |
| Automatisiert — Integration | — | — | — |
| Automatisiert — Performance | — | — | — |
| Manuell — P0 | — | — | — |
| Manuell — P1 | — | — | — |
| Manuell — P2 | — | — | — |

---

## 7. Gefundene Bugs

| ID | Schweregrad | Titel | US-Referenz | Status |
|---|---|---|---|---|
| BUG-NNNNNN | BLOCKER | [Kurzbeschreibung] | US-NNNNNN | OFFEN |

---

## 8. Freigabe-Empfehlung

*(Wird nach Testausführung befüllt)*

**Empfehlung:** [ ] APPROVED  [ ] CONDITIONAL  [ ] REJECTED

**Begründung:**
[Warum diese Empfehlung?]

**Regressionsrisiken:**
[Welche Bereiche wurden nicht getestet? Was könnte unbemerkt betroffen sein?]

---

*Erstellt von: QA-Agent | Datum: YYYY-MM-DD | Version: 1.0 | Ablage: `projects/<name>/testing/`*
