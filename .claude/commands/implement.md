# /implement — Implementierungsphase

Aktiviert **Frontend Developer Agent (FE)** und/oder **Backend Developer Agent (BE)**.

## Verwendung

```
/implement fe [projektname]   # Nur Frontend
/implement be [projektname]   # Nur Backend
/implement all [projektname]  # Beide (sequenziell: BE → API-Kontrakt → FE)
```

## Was passiert (BE-Modus)

1. Liest ADR-001, STRUCTURE.md, REQ-NNN, US-NNN des Sprints
2. Erstellt API-Kontrakt (OpenAPI / GraphQL Schema) — vor Code
3. Implementiert: Datenschicht → Business Logic → API-Layer
4. Schreibt Integration-Tests
5. Gibt Übergabe an FE-Agenten aus

## Was passiert (FE-Modus)

1. Liest UX-NNN, ADR-001, API-Kontrakt
2. Implementiert Komponenten: Bottom-Up (Atome → Moleküle → Seiten)
3. Schreibt Unit-Tests
4. Setzt Accessibility-Attribute

## Konventionen (zwingend)

Alle Code-Dateien müssen enthalten:
- Datei-Header (Modul, zugehörige Artefakte, Agent, Datum)
- DocString für alle öffentlichen Funktionen
- TODO-Marker nach Standard: `// TODO(FE|BE): Beschreibung — YYYY-MM-DD`

## Nächster Schritt

Nach Abschluss: `/test-plan`

---

**Agenten:** FE (Frontend Developer), BE (Backend Developer)
**Input:** UX-NNN, ADR-NNN, STRUCTURE.md, US-NNN
**Agent-Definitionen:** `toolchain/agents/frontend-agent.md`, `toolchain/agents/backend-agent.md`
