---
id: PROTO-HANDOFF
title: Übergabe-Protokoll zwischen Agenten
version: 1.0
status: ACTIVE
---

# Protokoll: Agent-zu-Agent-Übergabe

Dieses Protokoll definiert den verbindlichen Standard für Übergaben zwischen Agenten.
Jedes Artefakt, das ein Agent produziert, endet mit einem Übergabe-Block nach diesem Format.

## Warum dieses Protokoll

Ohne formalen Übergabe-Standard verliert jede Agenten-Session Kontext, der für den nächsten Agenten kritisch sein könnte. Der nächste Agent soll **ohne Rückfragen** starten können.

## Pflicht-Übergabe-Block

Jeder Agent fügt am Ende seines primären Ausgabe-Artefakts folgenden Block ein:

```markdown
---

## Übergabe: [KÜRZEL-Quell] → [KÜRZEL-Ziel]

**Datum:** YYYY-MM-DD  
**Von:** [Vollname Agent] ([Kürzel])  
**An:** [Vollname Agent] ([Kürzel])  
**Nächster Befehl:** `/[command] [projektname]`  
*(Nicht statisch eintragen — vor dem Ausfüllen Projektstatus prüfen: Welche Artefakte existieren? Welche Phase fehlt noch? Dann den exakten Befehl inkl. Projektname nennen.)*

### Übergebene Artefakte

| Artefakt-ID | Status | Pfad | Hinweise |
|-------------|--------|------|---------|
| [ID] | [Status] | `[Pfad]` | [Wichtige Info für Empfänger] |

### Kritische Informationen für Empfänger

[Was MUSS der nächste Agent wissen, was nicht in den Artefakten steht?
Entscheidungen, Annahmen, Kompromisse, Stakeholder-Präferenzen, ...]

### Offene Fragen (vererbt)

| # | Frage | Ursprung | Kritikalität | An wen |
|---|-------|---------|-------------|--------|
| 1 | [Frage] | [Woher kommt sie?] | BLOCKER/MAJOR/MINOR | [Wer muss antworten?] |

### Nicht-Ziele (explizit ausgeschlossen)

[Was wurde bewusst NICHT erledigt? Warum?
Verhindert, dass der Empfänger Arbeit erwartet, die nicht existiert.]

### Empfehlungen

[Was würde der übergebende Agent dem Empfänger empfehlen?
Optional, aber wertvoll bei Entscheidungsspielräumen.]

---
```

## Übergabe-Kette im Full-Sprint-Workflow

```
PM ──[SB-NNNNNN]──▶ BA ──[REQ+US]──▶ AR ──[ADR+STRUCT]──▶ UX ──[UX-NNNNNN]──▶
FE+BE ──[Code+Kontrakt]──▶ QA ──[TP+TR]──▶ RV ──[RV-NNNNNN]──▶ [MERGE]
```

## Übergabe-Validierung durch Empfänger

Bevor ein empfangender Agent mit der Arbeit beginnt, prüft er:

```markdown
EMPFANGS-CHECKLISTE:
[ ] Alle übergebenen Artefakte vorhanden (Pfade existieren)?
[ ] Status-Werte korrekt (mind. APPROVED wo BLOCKER)?
[ ] Offene BLOCKER-Fragen aus Übergabe beantwortet?
[ ] Kein widersprüchlicher Inhalt zwischen Artefakten?

Falls NEIN: Session pausieren, Konflikt an Orchestrator melden.
```

## Minimale Übergabe (Hotfix-Workflow)

Im Hotfix-Workflow gilt eine vereinfachte Übergabe:

```markdown
## Übergabe (Hotfix): [VON] → [AN]

**BUG-Referenz:** BUG-NNNNNN  
**Betroffene Dateien:** [Liste]  
**Fix-Strategie:** [1-2 Sätze]  
**Regressionsrisiko:** [Hoch/Mittel/Gering] — [Begründung]
```
