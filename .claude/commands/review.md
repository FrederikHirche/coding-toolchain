# /review — User Review + Code Review mit User-Story-Abnahme

Aktiviert den **Code Reviewer Agent (RV)** für eine zweistufige Abnahme:
erst **Nutzerabnahme** der implementierten Features, dann **technisches Code Review**.

## Verwendung

```
/review [projektname] [sprint-nummer]
```

## Was passiert

### Phase 0: Container-Refresh (falls vorhanden)

Bevor der Test-Guide erstellt wird: Falls `projects/<name>/docker-compose.yml` existiert,
wird der `app`-Service (bzw. die dort definierten Anwendungs-Services) **neu gebaut und
neu gestartet** (`docker compose build app && docker compose up -d app`), damit der Nutzer
garantiert gegen den aktuellen Sprint-Stand testet — nicht gegen ein veraltetes Image von
einem früheren Sprint. Gesundheitscheck abwarten, bevor Phase 1 beginnt. Kein
Docker-Compose-Setup im Projekt → Phase 0 entfällt ersatzlos (z. B. reiner lokaler
Dev-Server-Workflow).

### Phase 1: Test-Guide für den Nutzer

1. Liest `SP-NNNNNN`, alle US-NNNNNN des Sprints, TP-NNNNNN (manuelle Testfälle),
   TR-NNNNNN, alle dem Sprint zugeordneten BUG-NNNNNN und bei einem Re-Review frühere
   RV-NNNNNN desselben Sprints
2. Erstellt einen **nutzerfreundlichen Test-Guide** pro Feature:
   - Klare, nummerierte Schritte ohne Tech-Jargon
   - Genaue Startbedingung ("Starte die App, navigiere zu ...")
   - Erwartetes Ergebnis nach jedem Schritt
   - Max. 5–7 Schritte pro Feature, max. 3 Features pro Guide-Abschnitt
3. Präsentiert **unmittelbar vor dem Test-Guide** eine kurze inhaltliche
   **Sprint-Übersicht** mit drei Gruppen:
   - **User Stories:** ID, Titel und Nutzen in einem kurzen Satz
   - **Defects:** ID, Symptom und aktueller Status — einschließlich bereits behobener
     Defects, sofern sie Teil des Sprints waren
   - **MINORs:** ID bzw. Fundstelle, kurze inhaltliche Benennung und Status aller
     MINOR-Bugs/-Befunde des Sprints
   Quellen sind `SP-NNNNNN` (geplanter Scope), `TR-NNNNNN` und sprintzugeordnete
   `BUG-NNNNNN` (im Sprint entstandene Befunde) sowie bei einem Re-Review frühere
   `RV-NNNNNN` desselben Sprints (bereits dokumentierte MINOR-Anmerkungen). Einträge werden
   dedupliziert; eine leere Gruppe wird ausdrücklich als **„Keine“** ausgewiesen. Keine
   Befunde erfinden.
4. Präsentiert direkt danach den Test-Guide und weist den Nutzer an, die App zu öffnen und
   die Features durchzutesten

**⏸ Pausiert hier — Nutzer führt die Tests eigenständig durch**

### Phase 2: Nutzer-Interview

Wenn der Nutzer zurückkommt, führt der RV-Agent ein strukturiertes Interview durch:

- Hat jedes Feature wie beschrieben funktioniert? (Ja / Nein / Teilweise)
- Gab es unerwartetes Verhalten? → Detailfragen wenn Ja
- Wie fühlt sich der Flow aus Nutzerperspektive an? (Natürlich / Umständlich / Unklar)
- Gibt es etwas, das der Nutzer gerne anders hätte?

Ergibt Befund pro Feature: **ACCEPTED** / **CONDITIONAL** / **REJECTED**

### Phase 3: Technisches Code Review

4. Liest Code-Diff des Sprints und alle ADRs
5. Review in 6 Dimensionen:
   Korrektheit → Sicherheit → ADR-Konformität →
   Code-Qualität → Testabdeckung → Performance/Wartbarkeit
6. Kombiniert Nutzer-Befund + technischen Review zur Gesamtentscheidung
7. Erstellt Review-Bericht (RV-NNNNNN) in `projects/<name>/reviews/`
8. Erfasst technische Schulden (falls vorhanden) in `projects/<name>/retros/`
9. Aktualisiert INDEX.md

## Gesamtentscheidung

| Nutzer-Befund | Technischer Review | Entscheidung |
|---|---|---|
| ACCEPTED | APPROVED | ✅ APPROVED |
| ACCEPTED | REQUEST CHANGES | 🔄 REQUEST CHANGES |
| CONDITIONAL | APPROVED | 🔄 REQUEST CHANGES |
| REJECTED | (beliebig) | ❌ REJECTED |
| (beliebig) | REJECTED | ❌ REJECTED |

Ein REJECTED durch den Nutzer bedeutet, dass die fachliche Erwartung nicht erfüllt wurde —
unabhängig davon, ob der Code technisch korrekt ist.

## Vorbedingungen

- `TR-NNNNNN` vorhanden (aus `/test-run`)
- Keine BLOCKER-Bugs offen
- QA-Freigabe-Empfehlung nicht REJECTED
- App läuft und ist für den Nutzer zugänglich (lokal oder Staging) — bei Docker-Compose-Setups
  stellt Phase 0 dies automatisch sicher

## Nächster Schritt

- Bei APPROVED → `/manual [projektname] [sprint-nr]`
- Bei REQUEST CHANGES → `/implement [fe|be|all] [projektname]`
- Bei REJECTED → `/ba [projektname]` (Scope-Problem — PM/BA einschalten)

---

**Agent:** RV (Code Reviewer)
**Input:** Code-Diff, `SP-NNNNNN`, `TR-NNNNNN`, `TP-NNNNNN`, `BUG-NNNNNN`, frühere `RV-NNNNNN` desselben Sprints, ADRs, `US-NNNNNN`
**Output:** `RV-NNNNNN` (in `projects/<name>/reviews/`)
**Template:** `toolchain/templates/review-checklist.md`
**Agent-Definition:** `toolchain/agents/reviewer-agent.md`
