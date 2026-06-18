---
id: TP-NNN
title: Testplan [Projekttitel] Sprint NNN
version: 1.0
status: DRAFT
author-agent: QA (QA Engineer)
date: YYYY-MM-DD
sprint: NNN
based-on: US-NNN (kommagetrennte Liste)
supersedes: —
superseded-by: —
---

# Testplan: [Projekttitel] — Sprint NNN

## 1. Testumfang

**Getestete Features (Sprint NNN):**
- US-NNN: [Titel]
- US-NNN: [Titel]

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
[Befehl aus ADR-001 / STRUCTURE.md]

# Integration Tests
[Befehl]

# E2E Tests
[Befehl]

# Coverage-Report
[Befehl]
```

---

## 4. Manuelle Testfälle

### Feature: [US-NNN — Titel]

#### TC-001: [Testfall-Titel] — P0 (Blocker)

| Feld | Inhalt |
|---|---|
| **Vorbedingungen** | [Was muss vor dem Test zutreffen?] |
| **Testschritte** | 1. [Schritt] \| 2. [Schritt] \| 3. [Schritt] |
| **Erwartetes Ergebnis** | [Was soll passieren?] |
| **Tatsächliches Ergebnis** | *(wird bei Ausführung befüllt)* |
| **Status** | ⬜ Nicht getestet |
| **Anmerkungen** | — |

#### TC-002: [Fehlerfalltest] — P1 (Kritisch)

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
| SEC-001 | Unautorisierter Zugriff auf geschützte Route | Direktaufruf ohne Token | HTTP 401 / Redirect Login |
| SEC-002 | SQL-Injection im Suchfeld | Eingabe: `' OR '1'='1` | Kein Datenleck, saubere Fehlermeldung |
| SEC-003 | XSS im Textfeld | Eingabe: `<script>alert(1)</script>` | Kein Script-Execution |

---

## 6. Testergebnis-Zusammenfassung

*(Wird nach Testausführung befüllt)*

| Kategorie | Bestanden | Fehlgeschlagen | Nicht getestet |
|---|---|---|---|
| Automatisiert — Unit | — | — | — |
| Automatisiert — Integration | — | — | — |
| Manuell — P0 | — | — | — |
| Manuell — P1 | — | — | — |
| Manuell — P2 | — | — | — |

---

## 7. Gefundene Bugs

| ID | Schweregrad | Titel | US-Referenz | Status |
|---|---|---|---|---|
| BUG-NNN | BLOCKER | [Kurzbeschreibung] | US-NNN | OFFEN |

---

## 8. Freigabe-Empfehlung

*(Wird nach Testausführung befüllt)*

**Empfehlung:** [ ] APPROVED  [ ] CONDITIONAL  [ ] REJECTED

**Begründung:**
[Warum diese Empfehlung?]

**Regressionsrisiken:**
[Welche Bereiche wurden nicht getestet? Was könnte unbemerkt betroffen sein?]

---

*Erstellt von: QA-Agent | Datum: YYYY-MM-DD | Version: 1.0*
