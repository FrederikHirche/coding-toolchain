---
id: PC-NNN
title: Process Change Proposal — [Kurztitel]
version: 1.0
status: DRAFT
author-agent: AC (Agile Coach)
date: YYYY-MM-DD
project: [projektname]
sprint: N
based-on: [RETRO-NNN]
supersedes: —
superseded-by: —
---

# Process Change Proposal: [Kurztitel]

> **Ablage:** `projects/[projektname]/PC-NNN-[thema].md`
> Ein PC-Dokument beschreibt eine empfohlene Änderung an der Tool Chain selbst —
> nicht am Projekt-Inhalt. Änderungen werden erst nach Nutzer-Freigabe umgesetzt.

---

## Zusammenfassung

**Problem:** [Was läuft nicht gut? Konkretes Symptom.]

**Ursache:** [Warum passiert das? Wurzelursache, nicht Symptom.]

**Empfehlung:** [Was soll geändert werden? Ein Satz.]

**Priorität:** Hoch / Mittel / Gering

**Aufwand:** S (< 30 Min) / M (< 2h) / L (> 2h)

---

## Problem-Beschreibung

[Ausführliche Beschreibung des Problems. Konkrete Beispiele aus dem Sprint, wo es aufgetreten ist. Verlinkung auf RETRO-NNN, RV-NNN oder andere Belege.]

**Beobachtet in:** Sprint N, [Datei/Phase]

**Häufigkeit:** Einmalig / Wiederkehrend / Jedes Mal

**Impact:** [Was kostet dieses Problem? Zeit, Qualität, Frustration?]

---

## Ursachen-Analyse

**Direkte Ursache:**
[Das unmittelbare Problem — z. B. "Das REQ-Template hat kein Feld für NFR-Prioritäten"]

**Systemische Ursache:**
[Die tiefere Ursache — z. B. "NFRs werden in der Tool Chain als nachrangig behandelt"]

**Ausgeschlossene Ursachen:**
- [Was es NICHT ist — verhindert Fehldiagnosen]

---

## Empfohlene Änderung

### Betroffene Datei(en)

| Datei | Art der Änderung | Abschnitt |
|---|---|---|
| `toolchain/agents/xxx-agent.md` | Ergänzung / Überarbeitung / Entfernung | [Abschnitt] |
| `toolchain/templates/xxx.md` | Ergänzung / Überarbeitung / Entfernung | [Abschnitt] |

### Konkrete Änderung

**Vorher:**
```
[Aktueller Text / Struktur]
```

**Nachher:**
```
[Vorgeschlagener Text / Struktur]
```

### Begründung der Änderung

[Warum ist diese spezifische Änderung die richtige? Welche Alternativen wurden verworfen?]

---

## Alternativen (verworfen)

| Alternative | Warum verworfen |
|---|---|
| [Alternative A] | [Grund] |
| [Alternative B] | [Grund] |

---

## Konsequenzen

**Positiv:**
- [Was verbessert sich konkret?]

**Risiken / Nebenwirkungen:**
- [Was könnte sich negativ auswirken?]

**Auswirkung auf andere Agenten/Templates:**
- [Müssen andere Dateien angepasst werden?]

---

## Umsetzungs-Checkliste

- [ ] Nutzer hat Änderung freigegeben
- [ ] Betroffene Datei(en) aktualisiert
- [ ] INDEX.md aktualisiert
- [ ] Änderung in DECISIONS.md dokumentiert (DEC-NNN)
- [ ] Änderung in nächstem Sprint erprobt
- [ ] Status dieses PC-Dokuments auf ACTIVE gesetzt

---

## Status-Verlauf

| Datum | Status | Kommentar |
|---|---|---|
| YYYY-MM-DD | DRAFT | Erstellt nach RETRO-NNN |
| YYYY-MM-DD | APPROVED | Freigegeben durch Nutzer |
| YYYY-MM-DD | ACTIVE | Umgesetzt in `toolchain/agents/xxx.md` |

---

*Erstellt von: AC-Agent | Datum: YYYY-MM-DD*
*Ablage: projects/[projektname]/PC-NNN-[thema].md*
