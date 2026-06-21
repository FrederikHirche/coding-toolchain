---
id: REQ-NNNNNN
title: [Projekttitel] Requirements
version: 1.0
status: DRAFT
author-agent: BA (Business Analyst)
date: YYYY-MM-DD
based-on: SB-NNNNNN
supersedes: —
superseded-by: —
---

# Requirements: [Projekttitel]

## 1. Funktionale Anforderungen

### 1.1 [Feature-Bereich 1]

| ID | Anforderung | Priorität | US-Referenz |
|---|---|---|---|
| F-001 | [Das System muss / soll ...] | Must | US-NNNNNN |
| F-002 | [Das System muss / soll ...] | Should | US-NNNNNN |

### 1.2 [Feature-Bereich 2]

| ID | Anforderung | Priorität | US-Referenz |
|---|---|---|---|
| F-010 | [Das System muss / soll ...] | Must | US-NNNNNN |

---

## 2. Nicht-Funktionale Anforderungen

### 2.1 Performance

| ID | Anforderung | Messgröße | Zielwert |
|---|---|---|---|
| NF-001 | Ladezeit Hauptseite | Time to Interactive | < 2s (p95) |
| NF-002 | API-Response-Zeit | Median Latenz | < 200ms |

### 2.2 Sicherheit

| ID | Anforderung | Standard / Norm |
|---|---|---|
| NF-010 | Authentifizierung | OWASP Top 10 |
| NF-011 | Datenverschlüsselung | AES-256 at rest, TLS 1.3 in transit |
| NF-012 | [Weitere Anforderung] | [Referenz] |

### 2.3 Skalierung & Verfügbarkeit

| ID | Anforderung | Zielwert |
|---|---|---|
| NF-020 | Verfügbarkeit | 99.9% (SLA) |
| NF-021 | Gleichzeitige Nutzer | [Zahl] |

### 2.4 Accessibility

| ID | Anforderung | Standard |
|---|---|---|
| NF-030 | WCAG-Konformität | [2.1 AA / 2.1 AAA] |

### 2.5 Weitere NFRs

| ID | Kategorie | Anforderung |
|---|---|---|
| NF-040 | Logging | Strukturiertes JSON-Logging an allen kritischen Pfaden |
| NF-041 | Monitoring | Health-Check-Endpunkt vorhanden |

---

## 3. Story Map

Übersicht aller User Stories nach Epics und Abhängigkeiten:

```
Epic 1: [Name]
  └─ US-000001: [Kurztitel] (Must)
  └─ US-000002: [Kurztitel] (Must) → abhängig von US-000001
  └─ US-000003: [Kurztitel] (Should)

Epic 2: [Name]
  └─ US-000010: [Kurztitel] (Must)
  └─ US-000011: [Kurztitel] (Could) → abhängig von US-000010
```

---

## 4. Edge Cases & Ausnahmeflüsse

| ID | Beschreibung | Auslöser | Erwartetes Verhalten |
|---|---|---|---|
| EC-001 | Netzwerkfehler während Formular-Submit | Timeout > 30s | Fehlermeldung + Daten lokal gespeichert |
| EC-002 | Session abgelaufen | Token expired | Redirect zur Login-Seite + Hinweis |

---

## 5. Abhängigkeiten & externe Systeme

| System | Typ | Beschreibung | Verantwortlich |
|---|---|---|---|
| [System 1] | Integration | [Wozu wird es genutzt?] | [Team/Person] |

---

## 6. Glossar

| Begriff | Definition |
|---|---|
| [Begriff] | [Definition im Projektkontext] |

---

## 7. Offene Fragen

| # | Frage | Verantwortlich | Fällig bis | Status |
|---|---|---|---|---|
| 1 | [Frage] | [Stakeholder] | YYYY-MM-DD | OFFEN |

---

## 8. Übergabe an Architect-Agent

**Kritische nicht-funktionale Anforderungen:**
- [NF-NNNNNN: Besonders wichtig für Architekturentscheidungen]

**Technische Fragen für Architect:**
- [Was muss der Architect klären?]

**Sprint-1-Kandidaten:**
- US-000001: [Titel]
- US-000002: [Titel]
- US-000010: [Titel]

---

*Erstellt von: BA-Agent | Datum: YYYY-MM-DD | Version: 1.0*
