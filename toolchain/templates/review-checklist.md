---
id: RV-NNN
title: Review [Projekttitel] Sprint NNN
version: 1.0
status: DRAFT
author-agent: RV (Code Reviewer)
date: YYYY-MM-DD
sprint: NNN
reviewed-stories: US-NNN (kommagetrennte Liste)
qa-report: TR-NNN
supersedes: —
superseded-by: —
---

# Review: [Projekttitel] — Sprint NNN

## Review-Übersicht

| Eigenschaft | Wert |
|---|---|
| Branch | [feature-branch-name] |
| Reviewed Commit | [SHA] |
| Reviewer-Agent | RV |
| QA-Freigabe | [APPROVED / CONDITIONAL / REJECTED] |
| Nutzerabnahme | **[ACCEPTED / CONDITIONAL / REJECTED]** |
| Technischer Review | **[APPROVED / REQUEST CHANGES / REJECTED]** |
| Gesamtentscheidung | **[APPROVED / REQUEST CHANGES / REJECTED]** |

---

## Teil 1: Nutzerabnahme (User Acceptance Review)

### Test-Guide

*(Hier den präsentierten Test-Guide einfügen — dient als Nachweis was getestet wurde)*

**Feature: [US-NNN — Titel]**
1. [Schritt] → Erwartet: [Ergebnis]
2. [Schritt] → Erwartet: [Ergebnis]
3. ...

### Interview-Ergebnisse

| Feature (US-NNN) | Funktioniert? | Nutzer-Befund | Anmerkungen aus Interview |
|---|---|---|---|
| US-NNN: [Titel] | Ja / Nein / Teilweise | ACCEPTED / CONDITIONAL / REJECTED | [Zitat oder Beschreibung] |

### Nutzerabnahme-Entscheidung

**[ ] ACCEPTED** — Alle Features funktionieren wie erwartet.

**[ ] CONDITIONAL** — Kleinere Abweichungen oder UX-Anmerkungen:
- [Feature]: [Anmerkung]

**[ ] REJECTED** — Feature erfüllt fachliche Erwartung nicht:
- [Feature]: [Was genau hat nicht gestimmt?]

---

## Teil 2: Technisches Code Review

## Dimension 1: Korrektheit

| Kriterium | Status | Anmerkungen |
|---|---|---|
| Alle US-Akzeptanzkriterien implementiert | ✅ / ❌ | [Datei/Funktion wenn ❌] |
| Implementierung stimmt mit API-Kontrakt überein | ✅ / ❌ | |
| Edge Cases behandelt | ✅ / ❌ | |
| Fehlerbehandlung vollständig | ✅ / ❌ | |

**Anmerkungen Korrektheit:**

| # | Kategorie | Datei:Zeile | Problem | Empfehlung |
|---|---|---|---|---|
| K-001 | [BLOCKER/MAJOR/MINOR/SUGGESTION] | `datei.ts:42` | [Beschreibung] | [Empfehlung] |

---

## Dimension 2: Sicherheit

| Kriterium | Status | Anmerkungen |
|---|---|---|
| Input-Validierung für alle Endpoints | ✅ / ❌ | |
| Keine hardcodierten Secrets/Credentials | ✅ / ❌ | |
| Auth/Authz korrekt implementiert | ✅ / ❌ | |
| SQL/NoSQL-Injection-Schutz | ✅ / ❌ | |
| Sensible Daten nicht geloggt | ✅ / ❌ | |
| OWASP Top 10 berücksichtigt | ✅ / ❌ / N/A | |

**Anmerkungen Sicherheit:**

| # | Kategorie | Datei:Zeile | Problem | Empfehlung |
|---|---|---|---|---|
| S-001 | [BLOCKER/MAJOR/MINOR] | `auth.ts:15` | [Beschreibung] | [Empfehlung] |

---

## Dimension 3: ADR-Konformität

| ADR | Eingehalten? | Anmerkungen |
|---|---|---|
| ADR-001 (Tech-Stack) | ✅ / ❌ | |
| ADR-002 ([Titel]) | ✅ / ❌ | |
| [Weitere ADRs] | | |

**Abweichungen von ADRs:**

| # | ADR | Abweichung | Begründung vorhanden? | Empfehlung |
|---|---|---|---|---|
| A-001 | ADR-NNN | [Beschreibung] | Ja / Nein | [Empfehlung] |

---

## Dimension 4: Code-Qualität

| Kriterium | Status | Anmerkungen |
|---|---|---|
| Datei-Header vorhanden (alle Dateien) | ✅ / ❌ | |
| Alle öffentlichen Funktionen kommentiert | ✅ / ❌ | |
| Kein toter Code ohne TODO-Marker | ✅ / ❌ | |
| Keine Magic Numbers ohne Konstante | ✅ / ❌ | |
| Keine `any`-Typen (bei typisierten Sprachen) | ✅ / ❌ | |
| Namensgebung konsistent | ✅ / ❌ | |
| TODO-Marker nach Standard | ✅ / ❌ | |
| Keine Lint-Fehler | ✅ / ❌ | |

**Anmerkungen Code-Qualität:**

| # | Kategorie | Datei:Zeile | Problem | Empfehlung |
|---|---|---|---|---|
| Q-001 | [BLOCKER/MAJOR/MINOR/SUGGESTION] | `component.tsx:88` | [Beschreibung] | [Empfehlung] |

---

## Dimension 5: Testabdeckung

| Kriterium | Status | Anmerkungen |
|---|---|---|
| Unit-Tests für alle Kernfunktionen | ✅ / ❌ | |
| Happy Path + Fehlerfall pro Kernfunktion | ✅ / ❌ | |
| QA-Testergebnisse (TR-NNN) sauber | ✅ / ❌ | |
| Coverage-Ziel erreicht | ✅ / ❌ | [Actual %] |

**Anmerkungen Testabdeckung:**

| # | Kategorie | Bereich | Problem | Empfehlung |
|---|---|---|---|---|
| T-001 | [MAJOR/MINOR] | [Modul] | [Fehlende Tests] | [Was fehlt?] |

---

## Dimension 6: Performance & Wartbarkeit

| Kriterium | Status | Anmerkungen |
|---|---|---|
| Keine N+1-Query-Probleme | ✅ / ❌ | |
| Keine unnötigen Re-Renders (FE) | ✅ / ❌ / N/A | |
| Code lesbar ohne detaillierte Erklärung | ✅ / ❌ | |
| Komplexität angemessen | ✅ / ❌ | |

**Anmerkungen Performance/Wartbarkeit:**

| # | Kategorie | Datei:Zeile | Problem | Empfehlung |
|---|---|---|---|---|
| P-001 | [MAJOR/MINOR/SUGGESTION] | `query.ts:30` | [Beschreibung] | [Empfehlung] |

---

## Zusammenfassung

### Anmerkungen nach Schweregrad

| Schweregrad | Anzahl |
|---|---|
| BLOCKER | [N] |
| MAJOR | [N] |
| MINOR | [N] |
| SUGGESTION | [N] |

### Gesamtentscheidung (Nutzer + Technik)

**[ ] APPROVED** — Nutzer hat abgenommen (ACCEPTED), alle technischen Blocker-Checks bestanden.

**[ ] REQUEST CHANGES** — Folgende Punkte müssen vor Merge behoben werden:
- [Nutzer-Anmerkung / Anmerkung-ID]: [Kurzbeschreibung]

**[ ] REJECTED** — Kritische Probleme (Nutzer-REJECTED, Security, ADR-Verletzung, fehlende Kernfunktionalität):
- [Begründung]

### Technische Schulden (für nächsten Sprint)

| ID | Beschreibung | Priorität |
|---|---|---|
| DEBT-NNN | [Beschreibung — was wurde bewusst vereinfacht?] | [Hoch/Mittel/Gering] |

---

*Erstellt von: RV-Agent | Datum: YYYY-MM-DD | Version: 1.0 | Ablage: `projects/<name>/reviews/`*
