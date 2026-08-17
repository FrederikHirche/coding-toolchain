---
id: CNS-NNNNNN
title: Konsolidierungsbericht — [Bereich/Codebase-Ausschnitt]
version: 1.0
status: DRAFT
author-agent: CN (Consolidator)
date: YYYY-MM-DD
project: [projektname]
based-on: [CON-000001, ADR-NNNNNN — soweit relevant]
code-pfad: [Pfad zur untersuchten Codebase innerhalb des Projektordners]
supersedes: —
superseded-by: —
---

# CNS-NNNNNN: Konsolidierungsbericht — [Bereich/Codebase-Ausschnitt]

## 1. Umfang

**Untersuchte Codebase:** [Pfad, Commit-Basis vor Start]
**Git-Status vor Start:** [„clean" — Pflichtbedingung, sonst wäre der Lauf abgebrochen]
**Anlass:** [z. B. vor Release / nach Sprint N / DEBT-Anhäufung]

---

## 2. Gefundene Kandidaten

| Fund | Beweis/Fundstelle | Risikoeinstufung | Entscheidung |
|---|---|---|---|
| [z. B. unbenutzte Funktion `foo()`] | `pfad/datei.ext:Zeile` — 0 Aufrufer projektweit (`search_graph`) | SICHER/UNSICHER | Angewendet / Zurückgestellt als DEBT-NNNNNN |

**Legende Risikoeinstufung:** SICHER = 0 Aufrufer belegt, keine Public-API-Signatur, kein
Bezug zu einem geschützten Bereich aus CON-000001 · UNSICHER = mögliche Public API,
Feature-Flag-Pfad, TODO-markierter Code, Zweck aus Graph allein nicht eindeutig

---

## 3. Angewendete Fixes

*Nur SICHER eingestufte Kandidaten. Ein einziger Commit für alle Fixes dieses Laufs.*

| Datei:Zeile | Vorher (Kurzbeschreibung) | Nachher (Kurzbeschreibung) |
|---|---|---|
| `pfad/datei.ext:Zeile` | [z. B. unbenutzte Funktion vorhanden] | [z. B. entfernt] |

**Commit-Hash:** [Hash] — `chore(consolidate): <Kurzbeschreibung>`
**Push:** Nicht durchgeführt (Konsolidierung committet, pusht aber nicht automatisch)

---

## 4. Zurückgestellt als technische Schuld

| Fund | Grund für Zurückstellung | DEBT-ID |
|---|---|---|
| [Kurzbezeichnung] | [z. B. UNSICHER eingestuft / Testfehlschlag nach Anwendung] | `DEBT-NNNNNN` |

---

## 5. Test-Verifikation

**Testsuite konfiguriert (`commands.test` in `.toolchain.yml`):** Ja/Nein

*Falls Ja:*

| Zeitpunkt | Ergebnis | Hinweise |
|---|---|---|
| Vor Änderungen | [grün/rot] | |
| Nach Änderungen | [grün/rot] | Bei rot: betroffene Änderung wurde revertiert (siehe Abschnitt 4) |

*Falls Nein:* [Begründung, warum keine Testsuite existiert — erhöhtes Risiko, manuelle
Prüfung vor Merge empfohlen]

---

## 6. Nicht geprüfte Bereiche

[Was wurde bewusst NICHT untersucht — Zeitgründe, Scope-Gründe, fehlender Zugriff?]

- [Bereich 1 — Begründung]

---

## Übergabe: CN → RV/Nutzer

**Datum:** YYYY-MM-DD
**Von:** Consolidator (CN)
**An:** Code Reviewer (RV) / Nutzer
**Nächster Befehl:** [abhängig vom Kontext — siehe `consolidator-agent.md` Abschluss-Pflicht]

### Übergebene Artefakte

| Artefakt-ID | Status | Pfad | Hinweise |
|-------------|--------|------|---------|
| CNS-NNNNNN | DRAFT | `projects/<projektname>/consolidation/CNS-NNNNNN-<thema>.md` | Angewendete Fixes + Commit-Hash |
| DEBT-NNNNNN | [erfasst/keine] | `projects/<projektname>/retros/DEBT-NNNNNN-beschreibung.md` | Nur zurückgestellte Funde |

### Kritische Informationen für Empfänger

[Was muss der Empfänger wissen, bevor er auf Basis dieses Berichts weiterarbeitet — z. B.
Commit-Hash, ungetestete Risikobereiche?]

### Offene Fragen (vererbt)

| # | Frage | Ursprung | Kritikalität | An wen |
|---|-------|---------|-------------|--------|
| 1 | [Offener UNSICHER-Fund, der fachliche Klärung braucht] | Konsolidierung | BLOCKER/MAJOR/MINOR | [Wer muss antworten?] |

### Nicht-Ziele (explizit ausgeschlossen)

- Dieser Bericht ist kein Code Review und ersetzt `/review` nicht — er prüft keine
  Akzeptanzkriterien eines Sprints, sondern härtet Bestandscode.

### Empfehlungen

- [Welche DEBT-Einträge sollten im nächsten Sprint priorisiert werden?]

---

*Erstellt von: CN-Agent | Datum: YYYY-MM-DD | Version: 1.0 | Ablage: `projects/<projektname>/consolidation/`*

---

## Änderungshistorie

| Version | Datum | Änderung | Agent |
|---|---|---|---|
| 1.0 | YYYY-MM-DD | Initiale Version | CN |
