# Templates Summary — AI Development Tool Chain

Konsolidierte Übersicht aller Artefakt-Templates.  
Zweck: Einzelne Referenzdatei für NotebookLM-Analyse und schnelle Orientierung.

**Letzte Aktualisierung:** 2026-07-24  
**Pflege-Regel:** Diese Datei wird bei jedem Hinzufügen oder Ändern eines Templates aktualisiert.

---

## Architektur-Prinzip

Templates sind technologieunabhängig. Kein Template setzt eine Sprache, ein Framework oder
eine Plattform voraus. Technologieentscheidungen werden ausschließlich in `ADR-000001-tech-stack.md`
festgehalten und sind ab Status APPROVED verbindlich.

Jedes Template enthält:
- **Frontmatter-Header:** id, title, version, status, author-agent, date, project, based-on
- **Inhaltliche Abschnitte** nach dem jeweiligen Artefakt-Zweck
- **Übergabe-Block** am Ende (nach `toolchain/protocols/handoff-protocol.md`)

Artefakt-Lebenszyklus: `DRAFT → REVIEW → APPROVED → ACTIVE → SUPERSEDED | ARCHIVED`  
Artefakte werden niemals gelöscht.

---

## SB — Stakeholder Brief (`stakeholder-brief.md`)

**Präfix:** `SB-NNNNNN`  
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

## CON — Projekt-Constitution (`constitution.md`)

**Präfix:** `CON-000001` (einmalig pro Projekt)
**Erstellt von:** PM (Product Manager) via `/kickoff`
**Basiert auf:** `SB-000001`, Stakeholder-Interview (Schwerpunkt Runde 4+5)

Die Projekt-Constitution legt fest, was über den gesamten Projektverlauf nicht zur Debatte
steht — unabhängig von Phase oder Agent. Sie ist bewusst kurz und stabil, im Unterschied zu
`SB-000001` (Priorisierung) und `ADR-NNNNNN` (Tech-Stack). Ab Status APPROVED bindend für
alle nachfolgenden Agenten.

**Kernabschnitte:**
- Nicht verhandelbare Prinzipien: 3–7 konkrete, prüfbare Prinzipien mit Begründung
- Qualitäts-Mindeststandards: Testabdeckung, Accessibility, Sicherheit, Performance als
  prüfbare Untergrenzen (Zahl/Kriterium, keine Adjektive)
- Harte Ausschlüsse: explizit negativ formulierte, unter keinen Umständen zulässige Praktiken
- Geltungsbereich: Vorrang vor Bequemlichkeit/Geschwindigkeit einzelner Agenten
- Änderungsverfahren: nur mit expliziter Nutzer-Freigabe, Version als MAJOR erhöht
- Konfliktregel: Widerspruch wird als BLOCKER-Frage an PM eskaliert, nicht stillschweigend aufgelöst

---

## REQ — Requirements-Dokument (`requirements.md`)

**Präfix:** `REQ-NNNNNN`  
**Erstellt von:** BA (Business Analyst) via `/ba`  
**Basiert auf:** `SB-NNNNNN`

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

**Präfix:** `US-NNNNNN`  
**Erstellt von:** BA (Business Analyst) via `/ba`, verfeinert in `/refine`  
**Basiert auf:** `REQ-NNNNNN`

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

**Präfix:** `ADR-NNNNNN` (ADR-000001 ist immer der Tech-Stack)  
**Erstellt von:** AR (Software Architect) via `/architect`  
**Basiert auf:** `REQ-NNNNNN`, `US-NNNNNN`, `SB-NNNNNN`

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

ADR-000001 (Tech-Stack) deckt ab: Programmiersprache(n), Frontend-Ansatz, Backend-Ansatz
und API-Stil, Datenhaltung, Hosting/Deployment, Auth, Observability.

---

## GAP — Gap-Analyse (`gap-analysis.md`)

**Präfix:** `GAP-NNNNNN`
**Erstellt von:** AR (Software Architect) via `/converge`
**Basiert auf:** vorhandene `SB-NNNNNN`/`REQ-NNNNNN`/`ADR-NNNNNN` (falls vorhanden), untersuchte Codebase

Bestandsaufnahme einer bereits existierenden Codebase gegenüber der (falls vorhandenen)
Spezifikation — für Brownfield-Übernahme in die Tool Chain oder bei Verdacht auf Spec-Drift.
Kein Ersatz für Code Review (`RV-NNNNNN`) und kein automatischer Fix.

**Kernabschnitte:**
- Erfassungsumfang: untersuchter Code-Pfad, vorhandene Toolchain-Artefakte
- Abdeckungsmatrix: REQ/US ↔ Code, mit Fundstelle und Abweichung (falls Spec existiert)
- Architektur-Drift: ADR-Entscheidung ↔ tatsächlich verwendete Technologie (falls ADRs existieren)
- Ist-Architektur: vorgefundene technische Basis (falls noch keine ADRs existieren)
- Identifizierte technische Schulden mit vorgeschlagener DEBT-ID
- Empfehlung: retroaktive Artefakte / US als DONE markieren / neue Backlog-Items — explizit
- Nicht geprüfte Bereiche: explizite Abgrenzung

---

## UX — UX-Spec (`ux-spec.md`)

**Präfix:** `UX-NNNNNN`  
**Erstellt von:** UX (UX Designer) via `/ux`  
**Basiert auf:** `US-NNNNNN`, ADRs, `SB-NNNNNN`

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

**Präfix:** `SP-NNNNNN`  
**Erstellt von:** BA, FE, BE (gemeinsam) via `/refine`  
**Basiert auf:** `US-NNNNNN`, `UX-NNNNNN`, ADRs

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

**Präfix:** `TP-NNNNNN`  
**Erstellt von:** QA (QA Engineer) via `/test-plan`  
**Basiert auf:** `US-NNNNNN`, `UX-NNNNNN`, FE/BE-Übergabeprotokolle

Der Testplan definiert systematisch alle Testfälle eines Sprints, bevor die Tests
ausgeführt werden.

**Kernabschnitte:**
- Testumfang: Welche Stories und Features sind im Scope?
- Testumgebung: Anforderungen an Setup, Testdaten, Konfiguration
- Testfälle pro Story: Happy Path, negative Tests (Fehlerfälle), Boundary-Tests,
  Sicherheitstests (bei auth-relevanten Features), Browser-Clickpfade und Performanztests
- Priorisierung: P0 (Blocker — muss vor Release behoben), P1 (Kritisch), P2 (Normal)
- Testumgebungs-Anforderungen: Was muss konfiguriert sein?
- Automatisierungsgrad: Welche Tests werden automatisiert, welche manuell?

---

## BUG — Fehlerbericht (`bug-report.md`)

**Präfix:** `BUG-NNNNNN`
**Erstellt von:** QA via `/test-run` (Sprint-Workflow) — oder BA via `/hotfix` (Hotfix-Workflow)
**Basiert auf:** `TP-NNNNNN`, `US-NNNNNN` (Sprint) — oder Produktionsvorfall (Hotfix)

Domänenspezifischer Status-Verlauf (`OFFEN → IN_BEARBEITUNG → BEHOBEN → VERIFIZIERT`, siehe
`toolchain/protocols/artifact-lifecycle.md`) statt des generischen DRAFT/APPROVED-Zyklus.
Erzwingt Root-Cause-Analyse vor jedem Fix — verhindert Symptom-Patches, die im nächsten
Sprint wiederkehren. Wird von zwei Rollen nacheinander befüllt: QA/BA erfasst Symptom und
Reproduktionsschritte, FE/BE ergänzt Root-Cause und Fix-Ansatz vor der Code-Änderung.

**Kernabschnitte:**
- Symptom: erwartetes vs. tatsächliches Verhalten, Auswirkung
- Reproduktionsschritte: Schritt-für-Schritt, Umgebung, Reproduzierbarkeit
- Schweregrad (BLOCKER/MAJOR/MINOR) & Zuweisung (FE/BE/FE+BE)
- Evidenz: Screenshot-/Trace-Pfad, Log-Auszug
- Betroffene Komponenten
- Root-Cause: direkte Ursache, zugrundeliegende (systemische) Ursache, andere betroffene
  Stellen, ausgeschlossene Ursachen — Pflichtfeld vor Fix-Beginn
- Fix-Ansatz: Bezug zur Root-Cause, nicht nur zum Symptom
- Regressionsrisiko (Hoch/Mittel/Gering + Begründung)
- Verifikation: erneute Reproduktion durch QA, Regressionstest-Nachweis
- Zwei Übergabe-Blöcke (QA/BA → FE/BE, FE/BE → QA)

---

## RV — Review-Checkliste (`review-checklist.md`)

**Präfix:** `RV-NNNNNN`  
**Erstellt von:** RV (Code Reviewer) via `/review`  
**Basiert auf:** Code-Diff, `TR-NNNNNN`, `TP-NNNNNN`, ADRs, `US-NNNNNN`

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

**Eintrag-Format:** DEC-NNNNNN | Datum | Agent | Entscheidung | Begründung | Alternativen

---

## RETRO — Sprint-Retrospektive (`retrospective.md`)

**Präfix:** `RETRO-NNNNNN`  
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

**Präfix:** `IMPD-NNNNNN`  
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

**Präfix:** `PC-NNNNNN`  
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

**Präfix:** `ADR-NNNNNN` (eingebettet als ADR)  
**Erstellt von:** AR (Software Architect) via `/architect`

Spezialisiertes ADR-Template für die Git-Branching-Strategie des Projekts.
Dokumentiert Branching-Modell, Branch-Namenskonventionen, Merge-Strategie und
Release-Prozess.

**Kernabschnitte:**
- Gewähltes Modell: Git Flow / GitHub Flow / Trunk-Based / Feature Branch
- Branch-Typen: main, develop, feature/, hotfix/, release/
- Namenskonventionen: `feature/US-000042-login`, `hotfix/BUG-000007-auth`
- Merge-Strategie: Merge Commit / Squash / Rebase
- Release-Prozess: Wann wird ein Release-Branch erstellt?
- Schutzregeln: Wer darf in main/develop mergen?

---

## DOC — Feature-Guide (`feature-guide.md`)

**Präfix:** `DOC-NNNNNN`  
**Erstellt von:** MW (Manual Writer) via `/manual`  
**Basiert auf:** `US-NNNNNN`, `UX-NNNNNN`, `RV-NNNNNN`

Nutzerorientierte Schritt-für-Schritt-Anleitung pro Feature-Gruppe — aus Nutzersicht,
ohne Entwickler-Jargon.

**Kernabschnitte:**
- Was das Feature tut (1 Satz) und Voraussetzungen
- Schritt für Schritt: Aktion + was der Nutzer danach sieht
- Tipps und Hinweise, häufige Fragen zu diesem Feature
- Fehlerbehebung
- Screenshot-Platzhalter (`[SCREENSHOT: ...]`)

---

## RN — Release Notes (`release-notes.md`)

**Präfix:** `RN-NNNNNN`  
**Erstellt von:** MW (Manual Writer) via `/manual`  
**Basiert auf:** `RV-NNNNNN`, `US-NNNNNN`

Nutzerorientierte Zusammenfassung der Sprint-Änderungen — nicht zu verwechseln mit dem
Tool-Chain-eigenen `RELEASENOTES.md` im Repo-Root.

**Kernabschnitte:**
- Neu / Geändert / Behoben — je aus Nutzersicht formuliert
- Bekannte Einschränkungen
- Verweise auf zugehörige `DOC-NNNNNN`-Guides

---

## GS — Getting Started (`getting-started.md`)

**Präfix:** `GS-000001` (einmalig pro Projekt, Sprint 1)  
**Erstellt von:** MW (Manual Writer) via `/manual`  
**Basiert auf:** `SB-NNNNNN`, `US-NNNNNN` (Sprint 1)

Einstiegsanleitung für neue Nutzer — was ist das Produkt, erste Schritte, wichtigste
Funktionen im Überblick.

**Kernabschnitte:**
- Was ist [Produkt]? Bevor du anfängst. Erste Schritte.
- Die wichtigsten Funktionen im Überblick (mit Verweis auf `DOC-NNNNNN`)
- Wenn etwas nicht funktioniert (Verweis auf `FAQ-NNNNNN`)

---

## FAQ — Häufige Fragen (`faq.md`)

**Präfix:** `FAQ-NNNNNN`  
**Erstellt von:** MW (Manual Writer) via `/manual`  
**Basiert auf:** `DOC-NNNNNN`, `RV-NNNNNN`

Häufig gestellte Nutzerfragen zu implementierten Features — aus Nutzersicht, ohne
Fachbegriffe. Wird ab Sprint 2 oder bei erkennbarem FAQ-Bedarf erstellt/aktualisiert,
nicht in jedem Sprint neu angelegt.

**Kernabschnitte:**
- Fragen gruppiert nach Feature-Bereich (nicht chronologisch)
- Kurze, direkte Antworten mit Verweis auf den zugehörigen `DOC-NNNNNN`-Guide
- Abschnitt "Allgemeine Fragen" für Themen ohne Feature-Bezug (Konto, Datenschutz, ...)

---

## SRP — Spike Report (`spike-report.md`)

**Präfix:** `SRP-NNNNNN`  
**Erstellt von:** AR (Software Architect) via `/spike`  
**Basiert auf:** Spike-Brief (PM), `SB-NNNNNN` (falls vorhanden)

Ergebnis einer zeitlich begrenzten technischen Erkundung (kein Sprint, kein ADR).
Fließt als Input in den nächsten `/architect`-Aufruf.

**Kernabschnitte:**
- Fragestellung, Erfolgskriterien, Ergebnis, Empfehlung (explizit, keine offene Abwägung)
- Verworfene Optionen, offene Fragen, nächster Schritt (ADR anlegen / neuer Spike / verwerfen)
- Enthält einen vollständigen Übergabe-Block (AR → PM/Nutzer) nach `handoff-protocol.md`
