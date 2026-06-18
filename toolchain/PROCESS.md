# End-to-End Prozess

Detaillierter Ablauf der AI Development Tool Chain — von der Idee bis zum Merge.

---

## Phasenübersicht

```
┌──────────────────────────────────────────────────────────────┐
│  PHASE 1          PHASE 2          PHASE 3          PHASE 4  │
│  Discovery        Requirements     Architektur      UX        │
│                                                              │
│  /kickoff    ──▶  /ba         ──▶  /architect  ──▶  /ux      │
│  [PM]             [BA]             [AR]             [UX]     │
│                                                              │
│  SB-NNN           REQ-NNN          ADR-NNN          UX-NNN   │
│                   US-NNN           STRUCTURE.md              │
└──────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────┐
│  PHASE 5          PHASE 6          PHASE 7          PHASE 8  │
│  Refinement       Implementierung  Test             Review   │
│                                                              │
│  /refine     ──▶  /implement  ──▶  /test-plan  ──▶  /review  │
│  [BA+FE+BE]       [FE ∥ BE]        [QA]             [RV]    │
│                                                              │
│  SPRINT-NNN       Code + Tests     TP-NNN           RV-NNN   │
│                   API-Kontrakt     TR-NNN                    │
└──────────────────────────────────────────────────────────────┘
```

---

## Phase 1: Discovery (`/kickoff`)

**Agent:** Product Manager (PM)
**Ziel:** Gemeinsames Verständnis des Problems und der Projektvision schaffen.

### Ablauf

1. Stakeholder-Interview strukturiert durchführen (3 Runden, max. 8 Fragen)
2. Stakeholder Brief (`SB-001`) erstellen
3. MoSCoW-Priorisierung der Features
4. Übergabe an BA vorbereiten

### Gate-Kriterien (weiter zu Phase 2)

- [ ] `SB-NNN` im Status `APPROVED`
- [ ] Mindestens 3 Must-Have-Features definiert
- [ ] Scope klar abgegrenzt (In/Out-of-Scope)
- [ ] Erfolgskriterien messbar formuliert

### Rollback

Falls Stakeholder-Aussagen unklar oder widersprüchlich: Neues `/kickoff`-Meeting ansetzen, offene Fragen aus Sektion 8 des SB klären.

---

## Phase 2: Requirements (`/ba`)

**Agent:** Business Analyst (BA)
**Ziel:** Fachliche Anforderungen präzise und entwickelbar formulieren.

### Ablauf

1. SB-NNN vollständig lesen
2. Funktionale und nicht-funktionale Anforderungen ableiten
3. REQ-Dokument erstellen
4. User Stories mit Given/When/Then schreiben
5. Story-Map aufbauen (Abhängigkeiten sichtbar machen)
6. Offene Fragen eskalieren

### Gate-Kriterien (weiter zu Phase 3)

- [ ] `REQ-NNN` im Status `APPROVED`
- [ ] Alle Must-Have-Features haben min. 1 User Story
- [ ] Jede US hat min. 3 Akzeptanzkriterien
- [ ] Nicht-funktionale Anforderungen dokumentiert
- [ ] Story-Abhängigkeiten visualisiert

### Rollback

Fehlende Klarheit → Zurück zu PM für SB-Update (SB-NNN Version erhöhen).

---

## Phase 3: Architektur (`/architect`)

**Agent:** Software Architect (AR)
**Ziel:** Technische Grundlage definitiv festlegen — alle nachfolgenden Agenten nutzen ADRs als verbindliche Basis.

### Ablauf

1. REQ-NNN und alle US-NNN lesen
2. Tech-Stack entscheiden → ADR-001 erstellen
3. Weitere ADRs für wesentliche Einzelentscheidungen
4. System-Design-Diagramm erstellen
5. Projektstruktur in STRUCTURE.md definieren

### Gate-Kriterien (weiter zu Phase 4+5)

- [ ] `ADR-001` im Status `APPROVED`
- [ ] Alle nicht-funktionalen Anforderungen in ADRs adressiert
- [ ] `STRUCTURE.md` vorhanden
- [ ] System-Design-Diagramm vorhanden

### Rollback

Konflikt zwischen Anforderungen und technischer Machbarkeit → Zurück zu BA/PM für Requirements-Anpassung.

---

## Phase 4: UX Design (`/ux`)

**Agent:** UX Designer (UX)
**Ziel:** Verbindliche Interaktionsgrundlage für Frontend-Implementierung schaffen.

### Ablauf

1. Alle US-NNN und ADRs lesen
2. Primäre User Journeys identifizieren
3. UX-Spec (UX-NNN) pro Feature-Bereich erstellen
4. UI-Zustände, Microcopy, Accessibility-Anforderungen dokumentieren

### Gate-Kriterien (weiter zu Phase 5)

- [ ] `UX-NNN` für alle Sprint-1-Stories vorhanden
- [ ] Alle UI-Zustände dokumentiert
- [ ] Accessibility-Level festgelegt
- [ ] Kein FE-Agent-blockierender offener Punkt

### Parallelisierung

Phase 4 (UX) und Phase 5/6 (Refinement/BE) können parallelisiert werden. BE kann mit API-Design beginnen ohne UX-Spec. FE wartet auf UX-Spec.

---

## Phase 5: Refinement (`/refine`)

**Agenten:** BA, FE, BE (gemeinsam)
**Ziel:** Sprint-Backlog mit klaren, schätzbaren Stories aufbauen.

### Ablauf

1. Alle APPROVED US und UX-NNN lesen
2. Stories verfeinern: Subtasks, Schätzungen, Abhängigkeiten klären
3. Sprint-Ziel definieren
4. Sprint-Backlog-Dokument (`SPRINT-NNN.md`) erstellen
5. Technische Voraussetzungen identifizieren

### Gate-Kriterien (weiter zu Phase 6)

- [ ] Sprint-Ziel klar formuliert
- [ ] Alle Sprint-Stories geschätzt
- [ ] Keine ungelösten technischen Blocker
- [ ] FE- und BE-Stories identifiziert und abgegrenzt

---

## Phase 6: Implementierung (`/implement`)

**Agenten:** Frontend Developer (FE), Backend Developer (BE)
**Ziel:** Funktionierenden, vollständig kommentierten Code liefern.

### Ablauf (BE-First)

1. BE: API-Kontrakt erstellen (vor Code-Implementierung!)
2. BE: Datenschicht → Business Logic → API-Layer implementieren
3. BE: Integration-Tests schreiben
4. FE: UX-Spec lesen, API-Kontrakt übernehmen
5. FE: Komponenten Bottom-Up implementieren
6. FE: Unit-Tests schreiben

### Code-Qualitäts-Pflicht

- Datei-Header in jeder Code-Datei
- DocString/JSDoc für alle öffentlichen Funktionen
- INDEX.md-Update nach jeder neuen Datei

### Gate-Kriterien (weiter zu Phase 7)

- [ ] Alle Sprint-Stories implementiert (nach US-Akzeptanzkriterien)
- [ ] API-Kontrakt vorhanden
- [ ] Keine offenen BLOCKER in bekannten Bugs
- [ ] Erste automatisierte Tests vorhanden
- [ ] Keine Lint-Fehler

---

## Phase 7: Test (`/test-plan` + `/test-run`)

**Agent:** QA Engineer (QA)
**Ziel:** Vollständige Qualitätssicherung und Freigabe-Entscheidung.

### Ablauf

1. Testplan (`TP-NNN`) aus US und UX-Specs erstellen
2. Fehlende automatisierte Tests ergänzen
3. Automatisierte Tests ausführen
4. Manuelle Tests nach Testplan
5. Bugs erfassen (`BUG-NNN`)
6. Testergebnis-Bericht (`TR-NNN`) erstellen
7. Freigabe-Empfehlung aussprechen

### Gate-Kriterien (weiter zu Phase 8)

- [ ] Alle US haben min. 2 Testfälle (positiv + negativ)
- [ ] Keine BLOCKER-Bugs offen
- [ ] Automatisierte Tests laufen ohne Fehler
- [ ] Freigabe-Empfehlung: `APPROVED` oder `CONDITIONAL`

### Rollback

BLOCKER-Bug gefunden → Zurück zu Phase 6 (`/implement`). Bug in `BUG-NNN` dokumentieren und an verantwortlichen FE/BE-Agenten übergeben.

---

## Phase 8: Review (`/review`)

**Agent:** Code Reviewer (RV)
**Ziel:** Unabhängige finale Qualitätsprüfung und Merge-Entscheidung.

### Ablauf

1. Code-Diff lesen
2. TR-NNN und TP-NNN lesen
3. Review in 6 Dimensionen durchführen
4. RV-NNN erstellen
5. Merge-Entscheidung: APPROVED / REQUEST CHANGES / REJECTED

### Gate-Kriterien (Merge)

- [ ] Review-Entscheidung: `APPROVED`
- [ ] Kein BLOCKER in Review-Bericht
- [ ] Technische Schulden in Registry erfasst

### Rollback

- `REQUEST CHANGES` → Phase 6 für spezifische Korrekturen
- `REJECTED` → Eskalation an PM (Scope-Problem) oder AR (Architektur-Problem)

---

## Sprint-Wiederholung

Nach erfolgreichem Merge:

1. Retrospektive: Was lief gut? Was verbessern?
2. `/refine` für nächsten Sprint aufrufen
3. Artefakte aus vorherigem Sprint auf `ARCHIVED` setzen (falls abgelöst)
4. Technische Schulden aus RV-NNN priorisieren

---

## Rollback-Regeln (Übersicht)

| Von Phase | Rollback zu | Auslöser |
|---|---|---|
| 2 (BA) | 1 (PM) | Unklare Stakeholder-Anforderungen |
| 3 (AR) | 2 (BA) | Technisch unmachbare Requirements |
| 5 (Refinement) | 3 (AR) | Technischer Blocker ohne ADR-Abdeckung |
| 6 (Implementierung) | 3 (AR) | ADR-Konflikt bei Implementierung |
| 7 (QA) | 6 (Implementierung) | BLOCKER-Bug gefunden |
| 8 (Review) | 6 (Implementierung) | REQUEST CHANGES |
| 8 (Review) | 1 (PM) | REJECTED wegen Scope-Problem |

---

## Artefakt-Fluss

```
SB-001 (PM)
  └─▶ REQ-001 + US-001..N (BA)
        └─▶ ADR-001..N + STRUCTURE.md (AR)
              ├─▶ UX-001..N (UX)
              └─▶ API-Kontrakt (BE)
                    ├─▶ Code (FE + BE)
                    └─▶ TP-001 + TR-001 (QA)
                          └─▶ RV-001 (RV)
```
