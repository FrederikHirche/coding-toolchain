---
id: PROTO-LIFECYCLE
title: Artefakt-Lebenszyklus-Protokoll
version: 1.0
status: ACTIVE
---

# Protokoll: Artefakt-Lebenszyklus

Alle Artefakte in der Tool Chain durchlaufen einen definierten Lebenszyklus.
Kein Artefakt wird gelöscht — der Zustand wird explizit verwaltet.

## Status-Übergänge

```
         ┌─────────┐
         │  DRAFT  │ ← Initiale Erstellung durch Autor-Agent
         └────┬────┘
              │ Fertiggestellt
              ▼
         ┌─────────┐
         │ REVIEW  │ ← Bereit zur Freigabe
         └────┬────┘
              │ Freigegeben (manuell oder durch Gate-PASS)
              ▼
         ┌──────────┐
         │ APPROVED │ ← Verbindlich für alle nachfolgenden Agenten
         └────┬─────┘
              │ In aktivem Einsatz
              ▼
         ┌────────┐
         │ ACTIVE │ ← Wird aktiv referenziert
         └────┬───┘
         ┌────┴────────────────────┐
         │                        │
         ▼                        ▼
   ┌───────────┐          ┌──────────┐
   │ SUPERSEDED│          │ ARCHIVED │
   └───────────┘          └──────────┘
   Ersetzt durch          Sprint/Phase
   neuere Version         abgeschlossen
```

## Versionierung

Format: `MAJOR.MINOR`

| Änderungstyp | Version | Beispiel |
|---|---|---|
| Struktur verändert (neues Kapitel, Umstrukturierung) | MAJOR +1 | 1.2 → 2.0 |
| Inhalt verändert (Korrekturen, Ergänzungen) | MINOR +1 | 1.0 → 1.1 |
| Minimale Korrekturen (Tippfehler) | MINOR +0.1 | 1.0 → 1.0.1 |

Jede Version-Erhöhung erhöht die Version im YAML-Header und fügt einen Eintrag in der Änderungshistorie am Ende des Dokuments hinzu.

## Artefakt ersetzen (Supersede)

Wenn ein Artefakt durch eine neue Version ersetzt wird:

```markdown
# Im ALTEN Artefakt (z. B. ADR-000001):
superseded-by: ADR-000001-v2

# Ganz oben im Dokument einfügen:
> ⚠️ SUPERSEDED by ADR-000001-v2 (2026-07-15) — Grund: Tech-Stack-Anpassung
```

Das alte Artefakt wird auf Status `SUPERSEDED` gesetzt und **nicht** gelöscht.

## Artefakt archivieren

Wenn eine Phase abgeschlossen ist und Artefakte nicht mehr aktiv referenziert werden:

```markdown
status: ARCHIVED
archived-date: 2026-07-31
archived-reason: Sprint 1 abgeschlossen
```

Archivierte Artefakte verbleiben im Projektordner, werden aber in `INDEX.md` in einen separaten Abschnitt "Archiv" verschoben.

## INDEX.md-Pflicht

Jeder Agent, der ein Artefakt erstellt oder ändert, aktualisiert sofort die `INDEX.md` des Projektordners.

### INDEX.md-Format

```markdown
# Projektname — Index

Letzte Aktualisierung: YYYY-MM-DD | Phase: [Aktuelle Phase]

## Aktive Artefakte

| Datei | ID | Version | Status | Agent | Beschreibung |
|-------|-----|---------|--------|-------|-------------|
| `SB-000001.md` | SB-000001 | 1.0 | APPROVED | PM | Stakeholder Brief |
| `REQ-000001.md` | REQ-000001 | 1.1 | APPROVED | BA | Requirements |
| `ADR-000001.md` | ADR-000001 | 1.0 | APPROVED | AR | Tech Stack |
| `US-000001.md` | US-000001 | 1.0 | APPROVED | BA | Login |

## Gate-History

| Datum | Gate | Ergebnis | Blocker | Major | Minor |
|-------|------|----------|---------|-------|-------|
| 2026-06-18 | G1→G2 | ✅ PASS | 0 | 0 | 1 |

## In Bearbeitung

| Datei | ID | Status | Warten auf |
|-------|-----|--------|-----------|
| `ADR-000002.md` | ADR-000002 | DRAFT | AR-Freigabe |

## Archiv

| Datei | ID | Status | Archiviert |
|-------|-----|--------|-----------|
| `SB-000001-v0.md` | SB-000001-v0 | ARCHIVED | 2026-06-17 |
```

## Referenz-Integrität

Bevor ein Artefakt auf `ARCHIVED` oder `SUPERSEDED` gesetzt wird:

1. Alle Referenzen darauf in anderen Artefakten finden
2. Jede Referenz auf das neue Artefakt aktualisieren oder als `[veraltet]` markieren
3. Im neuen Artefakt: `supersedes: [alte-ID]` im Header eintragen

## Verbotene Aktionen

| Aktion | Stattdessen |
|--------|-------------|
| Artefakt-Datei löschen | Status auf ARCHIVED setzen |
| Artefakt ohne Header-Update ändern | Version erhöhen, Änderungshistorie eintragen |
| Status zurücksetzen (z.B. APPROVED → DRAFT) | Neues Artefakt anlegen mit `supersedes:` |
| Artefakt-ID wiederverwenden | Neue fortlaufende Nummer vergeben |
