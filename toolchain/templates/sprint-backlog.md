---
id: SP-NNNNNN
title: Sprint NNNNNN Backlog — [Projekttitel]
version: 1.0
status: DRAFT
author-agent: BA (Business Analyst) + FE + BE
date: YYYY-MM-DD
project: [projektname]
sprint: NNNNNN
based-on: REQ-NNNNNN, UX-NNNNNN
supersedes: —
superseded-by: —
---

# Sprint NNNNNN Backlog: [Projekttitel]

## Sprint-Ziel

**In einem Satz:** [Was soll am Ende dieses Sprints lieferbar sein?]

**Erfolgskriterium:** [Wie messen wir, ob das Ziel erreicht wurde?]

---

## Sprint-Rahmen

| Eigenschaft | Wert |
|---|---|
| Sprint-Start | YYYY-MM-DD |
| Sprint-Ende | YYYY-MM-DD |
| Dauer | [N] Tage |
| Kapazität FE | [N] Story Points |
| Kapazität BE | [N] Story Points |
| Velocity (Referenz) | [Vorheriger Sprint: N SP] |

---

## Stories im Sprint

### Commit-Stories (Must Deliver)

| US | Titel | Schätzung | Verantwortlich | Abhängigkeiten |
|-----|-------|----------|---------------|----------------|
| US-NNNNNN | [Titel] | [SP / XS-XL] | FE/BE | — |
| US-NNNNNN | [Titel] | [SP / XS-XL] | BE | US-NNNNNN |

**Gesamt Commit:** [N] Story Points

### Stretch-Stories (If Time Permits)

| US | Titel | Schätzung | Verantwortlich |
|-----|-------|----------|---------------|
| US-NNNNNN | [Titel] | [SP] | FE |

---

## Subtasks

### US-NNNNNN: [Titel]

| # | Subtask | Verantwortlich | Schätzung | Status |
|---|---------|---------------|----------|--------|
| 1 | API-Endpoint: `POST /ressource` | BE | 2h | ⬜ |
| 2 | Datenbankmigrierung | BE | 1h | ⬜ |
| 3 | UI-Komponente: Formular | FE | 3h | ⬜ |
| 4 | Unit-Tests | FE+BE | 2h | ⬜ |

*Status: ⬜ Offen | 🔄 In Bearbeitung | ✅ Fertig | ❌ Blockiert*

---

## Technische Voraussetzungen

Was muss vor Sprint-Start fertig sein (außerhalb des Teams)?

| # | Voraussetzung | Verantwortlich | Status |
|---|--------------|---------------|--------|
| 1 | Testdatenbank aufgesetzt | Infra | ✅ |
| 2 | API-Keys für [Service] | PM | ⬜ |

---

## Technische Schulden aus letztem Sprint

| DEBT-ID | Beschreibung | Priorität | Adressiert in diesem Sprint? |
|---------|-------------|----------|------------------------------|
| DEBT-NNNNNN | [Beschreibung] | [Hoch/Mittel] | Ja / Nein |

---

## Definition of Ready (Story-Checkliste)

Jede Commit-Story muss vor Sprint-Start erfüllt haben:

- [ ] User Story im Status APPROVED
- [ ] Mindestens 3 Akzeptanzkriterien
- [ ] UX-Spec referenziert (falls UI-Änderung)
- [ ] Keine ungeklärten Abhängigkeiten
- [ ] Schätzung vorhanden

---

## Risiken

| Risiko | Wahrscheinlichkeit | Impact | Mitigationsstrategie |
|--------|-------------------|--------|---------------------|
| [Risiko 1] | Mittel | Hoch | [Was tun wir?] |

---

## Sprint-Retrospektive Vorbereitung

*(Wird am Sprint-Ende befüllt)*

**Was lief gut?**

**Was verbessern wir?**

**Action Items:**

| # | Aktion | Verantwortlich | Fällig |
|---|--------|---------------|--------|
| 1 | [Aktion] | [Kürzel] | Sprint NNNNNN+1 |

---

*Erstellt von: BA + FE + BE (Refinement) | Datum: YYYY-MM-DD | Version: 1.0*
