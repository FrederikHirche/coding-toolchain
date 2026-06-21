---
id: DECISIONS
title: Entscheidungsprotokoll — [Projekttitel]
version: 1.0
status: ACTIVE
author-agent: ORCH (Orchestrator)
date: YYYY-MM-DD
project: [projektname]
---

# Entscheidungsprotokoll: [Projekttitel]

Leichtgewichtiges, chronologisches Protokoll aller wesentlichen Entscheidungen im Projektverlauf.

**Abgrenzung zu ADRs:** ADRs dokumentieren tiefe, technische Architekturentscheidungen vollständig mit Alternativen und Konsequenzen. Dieses Protokoll erfasst *alle* Entscheidungen — fachliche, prozessuale und kleinere technische — in kompakter Form. Neue Einträge werden *oben* eingefügt (neueste zuerst).

---

## Aktive Entscheidungen

### DEC-NNNNNN — [Kurztitel der Entscheidung]

| Feld | Wert |
|---|---|
| **Datum** | YYYY-MM-DD |
| **Phase** | DISCOVERY \| REQUIREMENTS \| ARCHITECTURE \| UX \| REFINEMENT \| IMPLEMENTATION \| TESTING \| REVIEW \| DOCUMENTATION |
| **Autor-Agent** | [KÜRZEL] ([Vollname]) |
| **Kategorie** | Produkt \| Architektur \| Prozess \| Scope \| Technologie \| UX |
| **Status** | ACTIVE \| SUPERSEDED \| OVERTURNED |

**Entscheidung:**
[Was wurde beschlossen? Klarer, aktiver Satz — keine Passivkonstruktionen.]

**Begründung:**
[Warum diese Entscheidung? Was hat den Ausschlag gegeben?]

**Verworfene Alternativen:**
- [Alternative A]: [Warum verworfen?]
- [Alternative B]: [Warum verworfen?]

**Konsequenzen:**
- [Was ändert sich durch diese Entscheidung?]
- [Was wird dadurch leichter / schwerer?]

**Abhängige Artefakte:** [ADR-NNNNNN, US-NNNNNN, ...]

---

## Übersichtstabelle

| ID | Datum | Kategorie | Kurztitel | Agent | Status |
|----|-------|---------|---------|-------|--------|
| DEC-001 | YYYY-MM-DD | Produkt | [Kurztitel] | PM | ACTIVE |

---

## Superseded / Overturned

Entscheidungen, die revidiert oder überschrieben wurden, bleiben hier sichtbar.

| ID | Datum | Kurztitel | Ersetzt durch | Grund |
|----|-------|---------|--------------|-------|
| DEC-NNNNNN | YYYY-MM-DD | [Titel] | DEC-NNNNNN | [Grund] |

---

## Pflege-Hinweis für Agenten

Jeder Agent, der eine wesentliche Entscheidung trifft, trägt diese hier ein. Kriterien:

- Scope-Änderungen (In/Out of Scope)
- Priorisierungsänderungen (Story rauf/runter/raus)
- Technologieentscheidungen unterhalb ADR-Niveau (Library-Wahl, Pattern-Entscheidung)
- UX-Richtungsentscheidungen
- Prozessabweichungen (warum eine Phase verkürzt oder übersprungen wurde)
- Stakeholder-Wünsche, die das Design prägen

Nicht eintragen: Routine-Implementierungsdetails, die bereits in ADRs oder US abgedeckt sind.

---

*Erstellt von: ORCH-Agent | Datum: YYYY-MM-DD | Letzte Aktualisierung: YYYY-MM-DD*
