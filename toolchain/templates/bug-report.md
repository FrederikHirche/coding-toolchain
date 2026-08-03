---
id: BUG-NNNNNN
title: Bug — [Kurzbeschreibung des Fehlers]
version: 1.0
status: OFFEN
author-agent: [QA (QA Engineer) im Sprint-Workflow | BA (Business Analyst) im Hotfix-Workflow]
date: YYYY-MM-DD
project: [projektname]
based-on: [TP-NNNNNN, US-NNNNNN — oder Produktionsvorfall bei Hotfix]
severity: BLOCKER | MAJOR | MINOR
assigned-to: FE | BE | FE+BE
supersedes: —
superseded-by: —
github-issue: —                   # Nummer des verlinkten GitHub Issues, nur gesetzt wenn github.enabled in .toolchain.yml
epic: —                           # EPIC-NNNNNN, sofern der Bug auf ein laufendes Epic einzahlt
github-milestone: —                # Aus dem Epic gespiegelt, nur informativ, nur gesetzt wenn github.enabled
estimate: —                       # Story Points, sofern der Fix aufwändig genug für eine Schätzung ist
size: —                           # XS | S | M | L | XL
iteration: —                      # Geplante Sprint-Nr. für den Fix
start-date: —                     # YYYY-MM-DD
target-date: —                    # YYYY-MM-DD
---

# Bug: [Kurzbeschreibung des Fehlers]

> **Ablage:** `projects/[projektname]/testing/BUG-NNNNNN-[kurztitel].md`
> Status-Verlauf ist domänenspezifisch (nicht der generische DRAFT/APPROVED-Lebenszyklus) —
> siehe Abschnitt "Status-Verlauf" und `toolchain/protocols/artifact-lifecycle.md`.

---

## 1. Symptom

**Erwartetes Verhalten:** [Was sollte passieren?]

**Tatsächliches Verhalten:** [Was passiert stattdessen?]

**Auswirkung:** [Wer/was ist betroffen — Nutzer, Datenintegrität, andere Features?]

---

## 2. Reproduktionsschritte

1. [Schritt 1]
2. [Schritt 2]
3. [Schritt 3 — führt zum Fehler]

**Umgebung:** [Browser/OS/Gerät, Testdaten, Umgebungsvariablen]
**Reproduzierbarkeit:** Immer | Manchmal ([Bedingung]) | Einmalig beobachtet

---

## 3. Schweregrad & Zuweisung

**Schweregrad:** `BLOCKER` | `MAJOR` | `MINOR`
**Begründung:** [Warum dieser Schweregrad? Blockiert er Release/Sprint-Abschluss?]
**Zugewiesen an:** FE | BE | FE+BE

---

## 4. Evidenz

**Screenshot-Pfad:** [Falls vorhanden — Playwright speichert automatisch]
**Trace-Pfad:** [Für `npx playwright show-trace`, falls E2E-Fund]
**Log-Auszug / Stack Trace:**
```
[Relevanter Ausschnitt]
```

---

## Betroffene Komponenten

[Dateien/Module, in denen sich der Fehler zeigt oder vermutlich verursacht wird — Stichprobe
reicht bei Erfassung, wird von FE/BE in Abschnitt "Root-Cause" präzisiert.]

- `pfad/datei.ext`

---

## Root-Cause

> **Pflichtabschnitt vor jedem Fix — von FE/BE (bzw. BA im Hotfix-Workflow) auszufüllen,
> BEVOR Code geändert wird.** Ein Fix ohne ausgefüllte Root-Cause gilt als unvollständig
> (siehe Gate-Kriterien in `toolchain/workflows/full-sprint.md` und `toolchain/workflows/hotfix.md`).

**Direkte Ursache:**
[Der unmittelbare Codedefekt — z. B. "Fehlende Null-Prüfung in `parseResponse()`, Zeile 42."]

**Zugrundeliegende (systemische) Ursache:**
[Warum wurde der Defekt eingeführt bzw. nicht früher erkannt? — z. B. "Kein Testfall für
leere API-Antwort; UX-Spec hat diesen Zustand nicht als eigenen State definiert."]

**Andere Stellen mit demselben Muster:**
[Gibt es weitere Codepfade, die denselben Fehler tragen könnten? Ja/Nein — falls ja, Liste.]

**Ausgeschlossene Ursachen:**
- [Was es NICHT ist — verhindert, dass ein falscher Fix versucht wird]

---

## Fix-Ansatz

[Was wird geändert, und warum behebt das die Root-Cause — nicht nur das Symptom aus
Abschnitt 1? Ein Fix, der nur den beobachteten Fall abfängt, ohne die zugrundeliegende
Ursache zu adressieren, erfüllt dieses Feld nicht.]

---

## Regressionsrisiko

**Einschätzung:** Hoch | Mittel | Gering
**Begründung:** [Welche anderen Bereiche könnten durch den Fix betroffen sein?]

---

## Verifikation

*(Wird von QA nach Fix-Implementierung befüllt — vor Status `VERIFIZIERT`.)*

**Ursprüngliche Reproduktionsschritte erneut ausgeführt:** [Datum] — Ergebnis: [Fehler tritt
nicht mehr auf / Fehler besteht weiterhin]

**Regressionstest ergänzt:** Ja ([Pfad zur Testdatei]) | Nein ([Begründung])

**Regressionstest schlägt ohne Fix fehl und besteht mit Fix:** Verifiziert / Nicht verifiziert

---

## Status-Verlauf

| Datum | Status | Kommentar |
|-------|--------|-----------|
| YYYY-MM-DD | OFFEN | Erfasst durch QA/BA, Symptom + Reproduktionsschritte dokumentiert |
| | IN_BEARBEITUNG | Root-Cause-Analyse durch FE/BE begonnen |
| | BEHOBEN | Fix implementiert, Root-Cause dokumentiert, Regressionstest ergänzt |
| | VERIFIZIERT | QA hat Reproduktionsschritte erneut ausgeführt — Fehler behoben |

*Solange Status ≠ `VERIFIZIERT` gilt der Bug als offen (siehe Gate-Kriterien "Keine offenen
BLOCKER-Bugs").*

---

## Übergabe: QA/BA → FE/BE (Bug zur Behebung)

**Datum:** YYYY-MM-DD
**Von:** QA Engineer (QA) / Business Analyst (BA, im Hotfix-Workflow)
**An:** Frontend- und/oder Backend-Agent (FE/BE)
**Nächster Befehl:** `/implement [fe|be|all] [projektname]`

### Übergebene Artefakte

| Artefakt-ID | Status | Pfad | Hinweise |
|-------------|--------|------|---------|
| BUG-NNNNNN | OFFEN | `projects/<projektname>/testing/BUG-NNNNNN-<kurztitel>.md` | Symptom + Reproduktionsschritte vollständig, Root-Cause noch offen |

### Kritische Informationen für Empfänger

- Root-Cause-Abschnitt ist zwingend vor der Fix-Implementierung zu befüllen.

### Offene Fragen (vererbt)

| # | Frage | Ursprung | Kritikalität | An wen |
|---|-------|---------|-------------|--------|
| 1 | [Unklarheit zur Reproduktion, falls vorhanden] | Testausführung | BLOCKER/MAJOR/MINOR | FE/BE |

### Nicht-Ziele (explizit ausgeschlossen)

- Diese Erfassung enthält keine Root-Cause-Analyse — das ist Aufgabe von FE/BE (bzw. war
  bereits Teil der BA-Erfassung im Hotfix-Workflow).

---

## Übergabe: FE/BE → QA (Fix bereit zur Verifikation)

**Datum:** YYYY-MM-DD
**Von:** Frontend- / Backend-Agent (FE/BE)
**An:** QA Engineer (QA)
**Nächster Befehl:** `/test-run [projektname] [sprint-nr]`

### Übergebene Artefakte

| Artefakt-ID | Status | Pfad | Hinweise |
|-------------|--------|------|---------|
| BUG-NNNNNN | BEHOBEN | `projects/<projektname>/testing/BUG-NNNNNN-<kurztitel>.md` | Root-Cause, Fix-Ansatz, Regressionsrisiko vollständig |

### Kritische Informationen für Empfänger

- Regressionstest-Pfad: [wo liegt der neue/erweiterte Test, der diesen Bug abdeckt?]

### Offene Fragen (vererbt)

| # | Frage | Ursprung | Kritikalität | An wen |
|---|-------|---------|-------------|--------|
| 1 | [Falls Regressionsrisiko Hoch/Mittel: worauf soll QA besonders achten?] | Fix-Implementierung | MAJOR | QA |

### Nicht-Ziele (explizit ausgeschlossen)

- Verifikation (erneute Reproduktion) wurde nicht durch FE/BE selbst durchgeführt — das ist
  Aufgabe von QA (Abschnitt "Verifikation").

---

*Erstellt von: QA-Agent (bzw. BA-Agent im Hotfix-Workflow) | Datum: YYYY-MM-DD | Version: 1.0*
*Ablage: projects/[projektname]/testing/BUG-NNNNNN-[kurztitel].md*
