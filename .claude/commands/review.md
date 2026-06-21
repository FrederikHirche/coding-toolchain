# /review — User Review + Code Review mit User-Story-Abnahme

Aktiviert den **Code Reviewer Agent (RV)** für eine zweistufige Abnahme:
erst **Nutzerabnahme** der implementierten Features, dann **technisches Code Review**.

## Verwendung

```
/review [projektname] [sprint-nummer]
```

## Was passiert

### Phase 1: Test-Guide für den Nutzer

1. Liest alle US-NNN des Sprints und TP-NNN (manuelle Testfälle)
2. Erstellt einen **nutzerfreundlichen Test-Guide** pro Feature:
   - Klare, nummerierte Schritte ohne Tech-Jargon
   - Genaue Startbedingung ("Starte die App, navigiere zu ...")
   - Erwartetes Ergebnis nach jedem Schritt
   - Max. 5–7 Schritte pro Feature, max. 3 Features pro Guide-Abschnitt
3. Präsentiert den Test-Guide und weist den Nutzer an, die App zu öffnen und die Features durchzutesten

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
7. Erstellt Review-Bericht (RV-NNN) in `projects/<name>/reviews/`
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

- `TR-NNN` vorhanden (aus `/test-run`)
- Keine BLOCKER-Bugs offen
- QA-Freigabe-Empfehlung nicht REJECTED
- App läuft und ist für den Nutzer zugänglich (lokal oder Staging)

## Nächster Schritt

- Bei APPROVED → `/manual [projektname] [sprint-nr]`
- Bei REQUEST CHANGES → `/implement [fe|be|all] [projektname]`
- Bei REJECTED → `/ba [projektname]` (Scope-Problem — PM/BA einschalten)

---

**Agent:** RV (Code Reviewer)
**Input:** Code-Diff, `TR-NNN`, `TP-NNN`, ADRs, `US-NNN`
**Output:** `RV-NNN` (in `projects/<name>/reviews/`)
**Template:** `toolchain/templates/review-checklist.md`
**Agent-Definition:** `toolchain/agents/reviewer-agent.md`
