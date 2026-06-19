# Templates Summary — AI Development Tool Chain

Konsolidierte Übersicht aller Artefakt-Templates.  
Zweck: Einzelne Referenzdatei für NotebookLM-Analyse und schnelle Orientierung.

**Letzte Aktualisierung:** 2026-06-19  
**Pflege-Regel:** Diese Datei wird bei jedem Hinzufügen oder Ändern eines Templates aktualisiert.

---

## Architektur-Prinzip

Templates sind technologieunabhängig. Kein Template setzt eine Sprache, ein Framework oder
eine Plattform voraus. Technologieentscheidungen werden ausschließlich in `ADR-001-tech-stack.md`
festgehalten und sind ab Status APPROVED verbindlich.

Jedes Template enthält:
- **Frontmatter-Header:** id, title, version, status, author-agent, date, project, based-on
- **Inhaltliche Abschnitte** nach dem jeweiligen Artefakt-Zweck
- **Übergabe-Block** am Ende (nach `toolchain/protocols/handoff-protocol.md`)

Artefakt-Lebenszyklus: `DRAFT → REVIEW → APPROVED → ACTIVE → SUPERSEDED | ARCHIVED`  
Artefakte werden niemals gelöscht.

---

## SB — Stakeholder Brief (`stakeholder-brief.md`)

**Präfix:** `SB-NNN`  
**Erstellt von:** PM (Product Manager) via `/kickoff`  
**Basiert auf:** Stakeholder-Interview (5 Runden)

Der Stakeholder Brief ist das Fundament aller nachfolgenden Artefakte. Er fasst zusammen,
was das Projekt ist, warum es existiert, für wen es gebaut wird und was Erfolg bedeutet.

**Kernabschnitte:**
- Problemraum: Welches Problem wird gelöst? Wer leidet darunter? Was passiert, wenn nicht?
- Vision: "Wenn wir Erfolg haben, dann…" — ein Satz
- Stakeholder & Nutzergruppen: Primäre Nutzer, Entscheider, Betroffene
- Scope (In / Out): Was gehört explizit dazu, was explizit nicht
- MoSCoW-Priorisierung: Must Have / Should Have / Could Have / Won't Have
- Erfolgskriterien: Mindestens 2 messbare KPIs mit Zielwert
- MVP-Definition: Minimum Viable Product — was muss minimal geliefert werden
- Risiken: Top-3-Risiken mit Beschreibung
- Offene Fragen: Was ist nach dem Interview ungeklärt geblieben

---

## REQ — Requirements-Dokument (`requirements.md`)

**Präfix:** `REQ-NNN`  
**Erstellt von:** BA (Business Analyst) via `/ba`  
**Basiert auf:** `SB-NNN`

Das Requirements-Dokument strukturiert alle Anforderungen des Projekts in eine Form,
die der Architect und die Entwickler direkt verwenden können.

**Kernabschnitte:**
- Funktionale Anforderungen: Was muss das System tun? (aus MoSCoW abgeleitet)
- Nicht-funktionale Anforderungen: Performance, Sicherheit, Skalierung, Availability
- Constraints: Technisch, zeitlich, regulatorisch, budgetär
- Story-Map: Visuelle Übersicht der User Stories mit Abhängigkeiten
- Offene Fragen: Was muss noch mit Stakeholdern geklärt werden

---

## US — User Story (`user-story.md`)

**Präfix:** `US-NNN`  
**Erstellt von:** BA (Business Analyst) via `/ba`, verfeinert in `/refine`  
**Basiert auf:** `REQ-NNN`

Jede User Story beschreibt ein konkretes Nutzerziel aus Nutzerperspektive.
Pro Feature-Bereich werden mehrere User Stories erstellt.

**Pflicht-Format:** "Als [Rolle] möchte ich [Ziel], damit [Nutzen]."

**Kernabschnitte:**
- Story-Beschreibung im Pflicht-Format
- Akzeptanzkriterien: ≥ 3 im Given/When/Then-Format
  - Given: Vorbedingung / Ausgangszustand
  - When: Auslösende Aktion des Nutzers
  - Then: Erwartetes System-Verhalten
- Edge Cases: Ausnahmeflüsse, Fehlerszenarien, Grenzwerte
- Nicht-Ziele: Was diese Story explizit NICHT abdeckt
- Story-Punkte / T-Shirt-Größe (wird im Refinement ergänzt)
- Abhängigkeiten: Welche anderen Stories müssen vorher abgeschlossen sein

---

## ADR — Architecture Decision Record (`architecture-decision.md`)

**Präfix:** `ADR-NNN` (ADR-001 ist immer der Tech-Stack)  
**Erstellt von:** AR (Software Architect) via `/architect`  
**Basiert auf:** `REQ-NNN`, `US-NNN`, `SB-NNN`

ADRs dokumentieren technische Entscheidungen mit vollständiger Begründung — inklusive
verworfener Alternativen. Sie sind ab Status APPROVED verbindlich für alle Agenten.

**Kernabschnitte:**
- Entscheidung (in einem Satz)
- Kontext: Warum musste diese Entscheidung getroffen werden?
- Betrachtete Optionen: Alle ernsthaft diskutierten Alternativen
- Begründung: Warum wurde diese Option gewählt?
- Ablehnungsbegründungen: Warum wurden die Alternativen verworfen?
- Konsequenzen: Positiv / Negativ / Neutral
- Reversibilität: Kann die Entscheidung später rückgängig gemacht werden?

ADR-001 (Tech-Stack) deckt ab: Programmiersprache(n), Frontend-Ansatz, Backend-Ansatz
und API-Stil, Datenhaltung, Hosting/Deployment, Auth, Observability.

---

## UX — UX-Spec (`ux-spec.md`)

**Präfix:** `UX-NNN`  
**Erstellt von:** UX (UX Designer) via `/ux`  
**Basiert auf:** `US-NNN`, ADRs, `SB-NNN`

Die UX-Spec ist die verbindliche Grundlage für den Frontend-Agenten. Sie beschreibt
das Nutzererlebnis vollständig — ohne Design-Tools zu benötigen.

**Kernabschnitte:**
- User Journey: Nummerierte Schritt-Liste (Schritt → Aktion → Systemreaktion → Nächster State)
- UI-Zustände: Leer-Zustand, Loading, Erfolg, Fehler — alle explizit beschrieben
- Edge Cases: Timeout, Netzwerkfehler, ungültige Eingaben
- Microcopy: Alle nutzer-sichtigen Texte, Fehlermeldungen, Bestätigungstexte
- ASCII-Layout: Strukturskizzen für komplexe Layouts (kein Styling, nur Struktur)
- Accessibility: WCAG-Level, kritische a11y-Anforderungen
- Responsive: Breakpoints und Verhaltensänderungen (falls Web)

---

## SP — Sprint Backlog (`sprint-backlog.md`)

**Präfix:** `SP-NNN`  
**Erstellt von:** BA, FE, BE (gemeinsam) via `/refine`  
**Basiert auf:** `US-NNN`, `UX-NNN`, ADRs

Der Sprint Backlog definiert, was in einem Sprint umgesetzt wird — verfeinert,
geschätzt und mit klarem Sprint-Ziel.

**Kernabschnitte:**
- Sprint-Ziel: Ein Satz — was liefert dieser Sprint?
- Stories im Sprint: Jede Story mit Subtasks, Schätzung (SP oder T-Shirt), Abhängigkeiten
- Technische Voraussetzungen: Was muss vor dem Sprint fertig sein?
- Definition of Done: Wann gilt der Sprint als abgeschlossen?
- Risiken & Unsicherheiten: Was könnte den Sprint verlangsamen?
- Ausgeschlossene Stories: Was wurde bewusst für diesen Sprint nicht aufgenommen

---

## TP — Testplan (`test-plan.md`)

**Präfix:** `TP-NNN`  
**Erstellt von:** QA (QA Engineer) via `/test-plan`  
**Basiert auf:** `US-NNN`, `UX-NNN`, FE/BE-Übergabeprotokolle

Der Testplan definiert systematisch alle Testfälle eines Sprints, bevor die Tests
ausgeführt werden.

**Kernabschnitte:**
- Testumfang: Welche Stories und Features sind im Scope?
- Testumgebung: Anforderungen an Setup, Testdaten, Konfiguration
- Testfälle pro Story: Happy Path, negative Tests (Fehlerfälle), Boundary-Tests,
  Sicherheitstests (bei auth-relevanten Features)
- Priorisierung: P0 (Blocker — muss vor Release behoben), P1 (Kritisch), P2 (Normal)
- Testumgebungs-Anforderungen: Was muss konfiguriert sein?
- Automatisierungsgrad: Welche Tests werden automatisiert, welche manuell?

---

## RV — Review-Checkliste (`review-checklist.md`)

**Präfix:** `RV-NNN`  
**Erstellt von:** RV (Code Reviewer) via `/review`  
**Basiert auf:** Code-Diff, `TR-NNN`, `TP-NNN`, ADRs, `US-NNN`

Der Review-Bericht dokumentiert das Code Review in 6 Dimensionen und enthält die
finale Merge-Entscheidung.

**Kernabschnitte:**
- Korrektheit: Implementierung vs. Akzeptanzkriterien, API-Kontrakt-Konformität
- Sicherheit: Input-Validierung, Secrets, Auth, Injection-Schutz
- ADR-Konformität: Tech-Stack und Architekturentscheidungen eingehalten?
- Code-Qualität: Kommentierungsstandard, Datei-Header, keine Magic Numbers
- Testabdeckung: Unit-Tests, Happy Path + Error Case abgedeckt?
- Performance & Wartbarkeit: N+1 Queries, Lesbarkeit, Komplexität
- Merge-Entscheidung: APPROVED / REQUEST CHANGES / REJECTED mit Begründung
- Technische Schulden: Alle gefundenen DEBT-Einträge

---

## DEBT — Tech-Debt-Registry (`tech-debt-registry.md`)

**Präfix:** `DEBT-REGISTRY` (einmalig pro Projekt)  
**Erstellt von:** RV (Code Reviewer) via `/review`

Zentrale Sammelstelle für alle technischen Schulden eines Projekts. Wird nicht gelöscht,
sondern fortlaufend ergänzt.

**Kernabschnitte pro Eintrag:**
- ID und Kurztitel
- Beschreibung der Schuld
- Ursache (warum ist sie entstanden?)
- Impact (welche Konsequenzen hat sie?)
- Aufwand zur Behebung (S/M/L)
- Priorität und vorgeschlagenes Sprint-Ziel zur Behebung

---

## DECISIONS — Entscheidungsprotokoll (`decisions.md`)

**Dateiname:** `DECISIONS.md` (einmalig pro Projekt, fortlaufend gepflegt)  
**Erstellt von:** Allen Agenten — jeder trägt relevante Entscheidungen ein  
**Ablage:** `projects/<projektname>/DECISIONS.md`

Laufendes Protokoll aller projektbezogenen Entscheidungen — wer hat wann was entschieden
und warum. Verhindert, dass Entscheidungen vergessen werden oder neu diskutiert werden müssen.

**Eintrag-Format:** DEC-NNN | Datum | Agent | Entscheidung | Begründung | Alternativen

---

## RETRO — Sprint-Retrospektive (`retrospective.md`)

**Präfix:** `RETRO-NNN`  
**Erstellt von:** AC (Agile Coach) via `/retro`  
**Basiert auf:** Sprint-Artefakte, Nutzer-Interview

Strukturierte Reflexion nach einem abgeschlossenen Sprint — analysiert den Prozess,
nicht die Inhalte.

**Kernabschnitte:**
- Sprint-Metadaten (Dauer, Stories, Velocity)
- Prozess-Fluss: Wo lief es reibungslos, wo gab es Friction?
- Artefakt-Qualität: Welche Templates haben gut funktioniert, welche nicht?
- Agenten-Performance: Wo gab es Übergabe-Probleme?
- Entscheidungsqualität: Welche Entscheidungen wurden bereut?
- Keep / Stop / Start: Je ≥ 2 Punkte
- Konkrete Maßnahmen mit Verantwortlichkeit

---

## IMPD — Impediment-Dokument (`impediment.md`)

**Präfix:** `IMPD-NNN`  
**Erstellt von:** AC (Agile Coach) via `/impediment`  
**Basiert auf:** Nutzer-Interview

Erfasst ein konkretes Hindernis im Entwicklungsprozess — identifiziert durch gezieltes
Interview, wenn der Nutzer Friction spürt, das Problem aber noch nicht benennen kann.

**Kernabschnitte:**
- Zusammenfassung: Symptom, Bereich, Schwere (BLOCKER / MAJOR / MINOR)
- Interview-Protokoll: Alle Fragen und Antworten des /impediment-Interviews
- Diagnose: Direkte Ursache, systemische Ursache, ausgeschlossene Ursachen
- Handlungsempfehlung: Sofortmaßnahme (ohne Dateiänderung) und strukturelle Lösung
- Status-Verlauf: DRAFT → ACTIVE → RESOLVED

---

## PC — Process Change Proposal (`process-change.md`)

**Präfix:** `PC-NNN`  
**Erstellt von:** AC (Agile Coach) via `/retro`, `/health-check`, `/coach`, `/impediment`

Formaler Vorschlag zur Änderung der Tool Chain selbst — nicht des Projekt-Inhalts.
Wird erst nach Nutzer-Freigabe umgesetzt.

**Kernabschnitte:**
- Zusammenfassung: Problem, Ursache, Empfehlung, Priorität, Aufwand (S/M/L)
- Problem-Beschreibung: Konkretes Symptom mit Belegen (RETRO-/RV-Referenz)
- Ursachen-Analyse: Direkte + systemische Ursache, ausgeschlossene Ursachen
- Empfohlene Änderung: Betroffene Datei(en), Vorher/Nachher-Vergleich
- Alternativen (verworfen): Mit Ablehnungsbegründung
- Konsequenzen: Positiv / Risiken / Auswirkung auf andere Agenten
- Umsetzungs-Checkliste: Nutzer-Freigabe → Implementierung → Erprobung im Sprint

---

## ADR-Branching — Branching Strategy (`branching-strategy.md`)

**Präfix:** `ADR-NNN` (eingebettet als ADR)  
**Erstellt von:** AR (Software Architect) via `/architect`

Spezialisiertes ADR-Template für die Git-Branching-Strategie des Projekts.
Dokumentiert Branching-Modell, Branch-Namenskonventionen, Merge-Strategie und
Release-Prozess.

**Kernabschnitte:**
- Gewähltes Modell: Git Flow / GitHub Flow / Trunk-Based / Feature Branch
- Branch-Typen: main, develop, feature/, hotfix/, release/
- Namenskonventionen: `feature/US-042-login`, `hotfix/BUG-007-auth`
- Merge-Strategie: Merge Commit / Squash / Rebase
- Release-Prozess: Wann wird ein Release-Branch erstellt?
- Schutzregeln: Wer darf in main/develop mergen?
