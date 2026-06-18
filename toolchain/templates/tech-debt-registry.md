---
id: DEBT-REGISTRY
title: Technische Schulden Registry — [Projekttitel]
version: 1.0
status: ACTIVE
author-agent: RV (Code Reviewer)
date: YYYY-MM-DD
project: [projektname]
supersedes: —
superseded-by: —
---

# Technische Schulden Registry: [Projekttitel]

Persistentes Register aller bewusst eingegangenen technischen Schulden.
Einträge werden NIE gelöscht — nur auf `RESOLVED` gesetzt.

---

## Offene Schulden

| ID | Titel | Priorität | Kategorie | Sprint | Agent | Status |
|----|-------|----------|----------|--------|-------|--------|
| DEBT-001 | [Kurztitel] | Hoch | [Kategorie] | 1 | FE | OFFEN |

---

## Schulden-Detail

### DEBT-001: [Kurztitel]

**Priorität:** Hoch | Mittel | Gering  
**Kategorie:** Architektur | Performance | Sicherheit | Tests | Wartbarkeit | Dokumentation  
**Erkannt in:** Sprint NNN | Review RV-NNN  
**Agent:** [Kürzel]  
**Datum:** YYYY-MM-DD

**Beschreibung:**  
[Was ist das Problem? Warum ist es technische Schuld und kein Bug?]

**Ursache:**  
[Warum wurde die Schuld bewusst eingegangen?
z. B. "Zeitdruck Sprint 1", "PoC-Code, der produktiv gegangen ist", "TODO aus ADR-003"]

**Auswirkung:**  
[Was passiert, wenn die Schuld nicht behoben wird?
z. B. "Skaliert nicht über 1000 gleichzeitige Nutzer", "Erhöhte Fehlerrate bei..."]

**Mitigationsmaßnahme:**  
[Was tun wir bis zur Behebung, um Risiken zu begrenzen?]

**Behebungsansatz:**  
[Wie würde eine saubere Lösung aussehen?]

**Aufwandsschätzung:** [S / M / L / XL]

**Abhängigkeiten:**  
- Muss vor DEBT-NNN behoben werden
- Wird durch US-NNN automatisch adressiert

**Status:** OFFEN | IN BEARBEITUNG | RESOLVED  
**Resolved in:** Sprint NNN (wenn behoben)

---

## Schulden nach Kategorie

| Kategorie | Anzahl offen | Anzahl gelöst |
|-----------|-------------|--------------|
| Architektur | 0 | 0 |
| Performance | 0 | 0 |
| Sicherheit | 0 | 0 |
| Tests | 0 | 0 |
| Wartbarkeit | 0 | 0 |
| Dokumentation | 0 | 0 |

---

## Erledigte Schulden

| ID | Titel | Resolved in | Lösung |
|----|-------|------------|--------|
| _(leer)_ | | | |

---

## Schulden-Priorisierung (Empfehlung für nächsten Sprint)

Top-3 Schulden die als nächstes angegangen werden sollten:

1. **DEBT-NNN** — [Begründung: z. B. Sicherheitsrisiko, blockiert US-NNN]
2. **DEBT-NNN** — [Begründung]
3. **DEBT-NNN** — [Begründung]

---

*Erstellt von: RV-Agent | Datum: YYYY-MM-DD | Letzte Aktualisierung: YYYY-MM-DD*
