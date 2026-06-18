---
id: PROTO-GATE
title: Qualitäts-Gate-Protokoll
version: 1.0
status: ACTIVE
---

# Protokoll: Qualitäts-Gates

Gates sind Übergangspunkte zwischen Phasen. Sie sichern, dass kein Artefakt-Mangel unkontrolliert in die nächste Phase übertragen wird.

## Gate-Schweregrade

| Schwere | Symbol | Bedeutung | Workflow-Auswirkung |
|---------|--------|----------|-------------------|
| BLOCKER | 🔴 | Muss behoben sein — verhindert den Phasenwechsel | Hard-Stop |
| MAJOR | 🟡 | Sollte behoben sein — Phasenwechsel mit expliziter Bestätigung | Warnung + Nutzer-OK |
| MINOR | 🟢 | Kann behoben werden — wird als TODO in nächste Phase vererbt | Automatisch weiter |

## Gate-Ausführung durch den Orchestrator

```
1. Gate-Kriterien aus workflows/full-sprint.md (oder hotfix.md) laden
2. Für jedes Kriterium:
   a. Prüfung durchführen (Datei lesen, Feld prüfen, zählen)
   b. Ergebnis: PASS | FAIL | NOT-APPLICABLE
3. Ergebnis-Zusammenfassung ausgeben
4. Entscheidung nach Schwere-Logik
```

## Gate-Ausgabe-Format

```
════════════════════════════════════════
GATE: Phase 2 → Phase 3 (Requirements → Architecture)
════════════════════════════════════════

🔴 BLOCKER [FAIL]  REQ-001 status muss APPROVED sein
              → Aktuell: DRAFT
              → Aktion: BA-Agent um Freigabe bitten

🔴 BLOCKER [PASS]  Alle Must-Have-US vorhanden (5/5)

🟡 MAJOR   [FAIL]  Story-Map in REQ-001 fehlt
              → Abschnitt 3 nicht ausgefüllt
              → Aktion: BA ergänzen, dann Gate neu prüfen

🟢 MINOR   [FAIL]  Edge Cases spärlich dokumentiert (nur 1)
              → TODO(BA): Edge Cases ergänzen — 2026-06-18
              → Wird in Architecture-Phase übernommen

════════════════════════════════════════
ERGEBNIS: ❌ GATE BLOCKIERT

BLOCKER: 1 offen
MAJOR:   1 offen
MINOR:   1 → als TODO übernommen

NÄCHSTE AKTION: BA-Session öffnen, REQ-001 finalisieren
BEFEHL:         /ba [projektname]
════════════════════════════════════════
```

## Gate-Entscheidungsmatrix

```
                    Blocker     Major       Minor
                    offen?      offen?      offen?
                    ────────────────────────────────
                    Ja          —           —      → STOP. Zurück zum Agent.
                    Nein        Ja          —      → Warnung ausgeben + Nutzer-OK einholen
                    Nein        Nein        Ja     → TODO vererben, weiter
                    Nein        Nein        Nein   → PASS. Nächste Phase.
```

## Gate-Prüfmethoden

| Methode | Beschreibung |
|---------|-------------|
| `file-exists` | Datei/Ordner muss existieren |
| `status-field` | YAML-Header-Feld muss bestimmten Wert haben |
| `count-min` | Mindestanzahl an Elementen (Zeilen, Abschnitte, Dateien) |
| `cross-ref` | Jedes Element A muss in Menge B referenziert sein |
| `command-exit-0` | Shell-Befehl (Lint, Tests) muss Exit-Code 0 liefern |
| `self-assertion` | Agent gibt Selbst-Auskunft (nicht automatisch verifizierbar) |

## Wiederholt fehlgeschlagene Gates

Wenn dasselbe Gate nach Reparatur-Versuch zweimal fehlschlägt:

1. Orchestrator eskaliert an PM-Agenten
2. PM bewertet: Ist das ein Scope-Problem, ein Qualitätsproblem, oder ein Ressourcenproblem?
3. Entscheidung: Phase neu starten, Scope reduzieren, oder Projekt pausieren

## Gate-Protokoll im Artefakt

Jeder Gate-Lauf wird im Projektordner dokumentiert:

```markdown
<!-- In projects/<name>/INDEX.md, Abschnitt "Gate-History" -->
| Datum      | Gate    | Ergebnis | Blocker | Major | Minor |
|------------|---------|----------|---------|-------|-------|
| 2026-06-18 | G2 → G3 | ❌ FAIL  | 1       | 1     | 1     |
| 2026-06-19 | G2 → G3 | ✅ PASS  | 0       | 0     | 1     |
```
