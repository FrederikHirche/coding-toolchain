---
id: CON-000001
title: Projekt-Constitution — [Projekttitel]
version: 1.0
status: DRAFT
author-agent: PM (Product Manager)
date: YYYY-MM-DD
project: [projektname]
based-on: SB-000001
supersedes: —
superseded-by: —
---

# Projekt-Constitution: [Projekttitel]

> **Ablage:** `projects/[projektname]/discovery/CON-000001-[projektname].md`
> Dieses Dokument darf NUR innerhalb des zugehörigen Projektordners gespeichert werden.

---

## 1. Zweck dieses Dokuments

Diese Constitution legt fest, was in diesem Projekt **nicht zur Debatte steht** — unabhängig
davon, welcher Agent gerade aktiv ist oder welche Phase läuft. Sie ist bewusst kurz und stabil
gehalten: keine Tech-Stack-Details (→ `ADR-000001-tech-stack.md`), keine Feature-Priorisierung
(→ `SB-000001`), sondern die Leitplanken, an denen sich jede spätere Entscheidung messen muss.

**Verbindlichkeit:** Ab Status `APPROVED` ist diese Constitution für **alle** nachfolgenden
Agenten bindend — BA, AR, UX, FE, BE, QA, RV, MW, AC gleichermaßen. Ein Konflikt zwischen einem
späteren Artefakt und dieser Constitution wird nicht stillschweigend zugunsten des späteren
Artefakts aufgelöst (siehe Abschnitt 7).

---

## 2. Nicht verhandelbare Prinzipien

[3–7 Prinzipien. Jedes muss so konkret sein, dass ein Agent daran eine Entscheidung prüfen kann
— keine Allgemeinplätze wie "hohe Qualität". Aus dem Stakeholder-Interview abgeleitet, mit
Schwerpunkt auf Runde 5 (Constraints & Risiken).]

| # | Prinzip | Begründung |
|---|---------|-----------|
| 1 | [z. B. "Nutzerdaten verlassen niemals die EU-Region"] | [Warum ist das nicht verhandelbar?] |
| 2 | [z. B. "Jedes Feature muss ohne JavaScript zumindest lesbar sein"] | [Begründung] |
| 3 | [Prinzip] | [Begründung] |

---

## 3. Qualitäts-Mindeststandards

[Konkrete, prüfbare Untergrenzen — kein Ziel, sondern ein Boden, unter den nie gegangen wird.
Werte wo möglich als Zahl, nicht als Adjektiv.]

| Dimension | Mindeststandard | Prüfmethode |
|---|---|---|
| Testabdeckung | [z. B. ≥ 70 % Line Coverage auf Business-Logik] | Coverage-Report (`command-exit-0`) |
| Accessibility | [z. B. WCAG 2.1 AA für alle Nutzer-Flows] | UX-Spec + manuelle Prüfung |
| Sicherheit | [z. B. keine Secrets im Code, Input-Validierung an jeder externen Schnittstelle] | Code Review (RV) |
| Performance | [z. B. p95 API-Antwortzeit < 500 ms] | Performanztests (QA) |
| [Weitere Dimension] | [Wert] | [Wie wird geprüft?] |

---

## 4. Harte Ausschlüsse / Verbotene Praktiken

[Was darf unter keinen Umständen passieren — auch nicht "nur kurzfristig" oder "nur im PoC"?
Explizit negativ formuliert, damit kein Agent es aus Versehen tut.]

- [z. B. Keine Auth-Umgehung, auch nicht für interne Test-Endpoints]
- [z. B. Keine Abhängigkeit von Closed-Source-Diensten ohne SLA]
- [z. B. Keine Speicherung von Klartext-Passwörtern, auch nicht temporär]
- [Weiterer Ausschluss]

---

## 5. Geltungsbereich

Diese Constitution gilt für das gesamte Projekt `[projektname]`, über alle Sprints hinweg —
nicht nur für den aktuellen Sprint. Sie hat Vorrang vor:
- Bequemlichkeits- oder Geschwindigkeitsargumenten einzelner Agenten
- Abweichungen, die nur in einem ADR, einer US oder einer UX-Spec begründet werden, ohne dass
  diese Constitution selbst geändert wird (siehe Abschnitt 6)

Sie hat **keinen** Vorrang vor explizitem, direktem Userbefehl — der Nutzer kann jederzeit eine
Ausnahme anordnen; diese wird dann in `DECISIONS.md` mit Begründung protokolliert.

---

## 6. Änderungsverfahren

Diese Constitution ist bewusst stabil — sie wird **nicht** bei jedem Sprint neu geschrieben.
Eine Änderung ist zulässig, wenn sich die Rahmenbedingungen des Projekts grundlegend ändern
(z. B. neue regulatorische Vorgabe, Pivot der Zielgruppe).

1. Änderungsvorschlag mit Begründung (wer schlägt vor, warum, was ändert sich konkret)
2. Explizite Nutzer-Freigabe einholen — keine Constitution-Änderung ohne direkten Userbefehl
3. Version erhöhen (MAJOR, da strukturelle/inhaltliche Änderung an einem bindenden Dokument)
4. Änderung in `DECISIONS.md` protokollieren
5. Alle Agenten, deren aktive Artefakte von der Änderung betroffen sein könnten, in der
   nächsten Session auf die Änderung hinweisen (Übergabe-Block, Abschnitt "Kritische Informationen")

---

## 7. Konfliktregel

Stellt ein Agent fest, dass eine Anforderung, ein ADR, eine UX-Spec oder eine Implementierung
im Widerspruch zu dieser Constitution steht:

1. **Nicht stillschweigend nach Constitution richten und nicht stillschweigend ignorieren.**
2. Konflikt explizit als offene Frage dokumentieren (Rückfragen-Protokoll, Kritikalität `BLOCKER`)
3. An PM eskalieren — nur PM (mit Nutzer-Freigabe) kann die Constitution ändern oder eine
   dokumentierte Ausnahme genehmigen
4. Arbeit an anderen, nicht betroffenen Teilen fortsetzen; betroffene Stelle markieren

---

## Übergabe: PM → BA

**Datum:** YYYY-MM-DD
**Von:** Product Manager (PM)
**An:** Business Analyst (BA)
**Nächster Befehl:** `/ba [projektname]`

### Übergebene Artefakte

| Artefakt-ID | Status | Pfad | Hinweise |
|-------------|--------|------|---------|
| CON-000001 | APPROVED | `projects/<projektname>/discovery/CON-000001-<projektname>.md` | Bindend für alle nachfolgenden Phasen |

### Kritische Informationen für Empfänger

- Jede Anforderung, die einem Prinzip aus Abschnitt 2 oder einem Ausschluss aus Abschnitt 4
  widerspricht, darf nicht unkommentiert in REQ-NNNNNN übernommen werden — siehe Abschnitt 7.

### Nicht-Ziele (explizit ausgeschlossen)

- Diese Constitution trifft keine Tech-Stack-Entscheidungen — Aufgabe des Architect-Agenten.
- Diese Constitution priorisiert keine Features — das leistet `SB-000001`.

---

*Erstellt von: PM-Agent | Datum: YYYY-MM-DD | Version: 1.0*
*Ablage: projects/[projektname]/discovery/CON-000001-[projektname].md*

---

## Änderungshistorie

| Version | Datum | Änderung | Agent |
|---|---|---|---|
| 1.0 | YYYY-MM-DD | Initiale Version | PM |
