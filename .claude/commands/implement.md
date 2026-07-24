# /implement — Implementierungsphase

Aktiviert **Frontend Developer Agent (FE)** und/oder **Backend Developer Agent (BE)**.

## Verwendung

```
/implement fe [projektname]   # Nur Frontend
/implement be [projektname]   # Nur Backend
/implement all [projektname]  # Beide (sequenziell: BE → API-Kontrakt → FE)
```

## Was passiert (BE-Modus)

1. Liest ADR-000001, STRUCTURE.md, REQ-NNNNNN, US-NNNNNN des Sprints
2. Erstellt API-Kontrakt (OpenAPI / GraphQL Schema) — vor Code
3. Implementiert: Datenschicht → Business Logic → API-Layer
4. Schreibt Integration-Tests
5. Gibt Übergabe an FE-Agenten aus

## Was passiert (FE-Modus)

1. Liest UX-NNNNNN, ADR-000001, API-Kontrakt
2. Implementiert Komponenten: Bottom-Up (Atome → Moleküle → Seiten)
3. Schreibt Unit-Tests
4. Setzt Accessibility-Attribute

## Vorbedingung

Gate 5.5 (`/analyze [projektname]`) bestanden — keine offene BLOCKER-Inkonsistenz zwischen
REQ/US, ADR, UX und SP.

Sprint-Worktree angelegt bzw. (nach Unterbrechung) wiederbetreten — FE/BE arbeiten bis Gate 9
auf `feature/sprint-N`, nicht im Haupt-Checkout (siehe `toolchain/workflows/full-sprint.md`
Abschnitt "Worktree-Isolation"). Bei Wiederaufnahme: Statusprojektion aus INDEX.md vor
Fortsetzung gegenprüfen.

## Bugfix-Rückläufer (Gate 7 Rollback)

Wird `/implement` mit einem offenen `BUG-NNNNNN` (Status `OFFEN`) statt mit neuen Sprint-Stories
aufgerufen, gilt der Bugfix-Modus aus `frontend-agent.md`/`backend-agent.md`: Root-Cause-Analyse
in `BUG-NNNNNN` ist vor jeder Code-Änderung Pflicht (siehe `toolchain/templates/bug-report.md`).

## Konventionen (zwingend)

Alle Code-Dateien müssen enthalten:
- Datei-Header (Modul, zugehörige Artefakte, Agent, Datum)
- DocString für alle öffentlichen Funktionen
- TODO-Marker nach Standard: `// TODO(FE|BE): Beschreibung — YYYY-MM-DD`

## Nächster Schritt

Nach Abschluss: `/test-plan`

---

**Agenten:** FE (Frontend Developer), BE (Backend Developer)
**Input:** UX-NNNNNN, ADR-NNNNNN, STRUCTURE.md, US-NNNNNN
**Agent-Definitionen:** `toolchain/agents/frontend-agent.md`, `toolchain/agents/backend-agent.md`
