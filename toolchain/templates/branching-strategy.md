---
id: ADR-NNN
title: Branching-Strategie — [Projektname]
version: 1.0
status: DRAFT
author-agent: AR (Software Architect)
date: YYYY-MM-DD
based-on: ADR-001
supersedes: —
superseded-by: —
---

# ADR-NNN: Branching-Strategie

> **Ablage:** `projects/[projektname]/ADR-NNN-branching-strategy.md`
>
> Dieses ADR wird einmalig zu Projektbeginn erstellt und legt die Git-Branching-Strategie
> für alle Sprints verbindlich fest. Es wird vom ORCH-Agenten in Phase 10 (Release) referenziert.

## Status

`DRAFT` | `REVIEW` | `APPROVED` | `SUPERSEDED`

---

## Kontext

[Beschreibe das Projekt und seine Anforderungen an Branching:
- Wie viele Entwickler / Agenten arbeiten gleichzeitig?
- Gibt es parallele Feature-Entwicklung?
- Gibt es Long-Running-Releases oder Hotfix-Anforderungen?
- Wie oft wird deployed? (Continuous Delivery vs. Release-Zyklen)]

---

## Entscheidung

**Gewählte Strategie:** [Trunk-Based / GitFlow / GitHub Flow / andere]

**Hauptbranch:** `main` | `master` | `trunk`

**Feature-Branch-Namenskonvention:** `feature/<sprint-nr>-<kurzbeschreibung>`

**Release-Tag-Format:** `v<sprint-nr>` | `v<major>.<minor>.<patch>`

---

## Optionen im Vergleich

### Option A: Trunk-Based Development

**Kurzbeschreibung:** Alle Entwickler arbeiten direkt auf `main` oder integrieren
mehrmals täglich in `main`. Feature Flags steuern Sichtbarkeit.

**Geeignet wenn:**
- Kontinuierliche Auslieferung (CI/CD)
- Kleines Team, hohe Kommunikationsdichte
- Feature Flags vorhanden

**Nicht geeignet wenn:**
- Parallele Long-Running-Features
- Mehrere Release-Versionen gleichzeitig im Feld

---

### Option B: GitHub Flow

**Kurzbeschreibung:** Ein stabiler `main`-Branch. Jedes Feature in einem kurzlebigen
Branch. Merge via Pull Request direkt in `main`. Kein separater `develop`-Branch.

**Geeignet wenn:**
- Einzel-Produktlinie, immer aktuelle Version im Einsatz
- Sprints enden direkt in Production-Releases
- Tool-Chain-Standard für neue Projekte ohne komplexe Release-Anforderungen

**Nicht geeignet wenn:**
- Mehrere parallele Versionen müssen gepflegt werden (z. B. v1 + v2 gleichzeitig)

---

### Option C: GitFlow

**Kurzbeschreibung:** Zwei stabile Branches (`main` = Production, `develop` = Integration).
Feature-Branches von `develop`. Release-Branches für Release-Vorbereitung.
Hotfix-Branches direkt von `main`.

**Geeignet wenn:**
- Geplante, termingebundene Releases
- Parallele Entwicklung mehrerer Features mit unterschiedlichen Release-Terminen
- Hotfix-Notwendigkeit ohne Einfluss auf laufende Feature-Entwicklung

**Nicht geeignet wenn:**
- Kleine Projekte (Overhead zu hoch)
- Continuous Delivery (zu viele Branch-Übergänge)

---

## Gewählte Option: [Name eintragen]

### Begründung

[Warum passt diese Strategie zum Projekt?]

### Branch-Struktur für dieses Projekt

```
main (oder trunk)
 ├── feature/1-auth
 ├── feature/1-dashboard
 └── hotfix/login-fix          ← nur bei GitFlow / GitHub Flow
```

*(Grafik anpassen je nach gewählter Strategie)*

### Merge-Protokoll für Phase 10

```bash
# Sprint abgeschlossen — Release-Vorgang:
git checkout main                          # Ziel-Branch (anpassen je Strategie)
git merge --no-ff feature/<sprint>-<name>  # Merge mit History-Knoten
git tag -a v<sprint> -m "Sprint N: <sprint-ziel>"
git push origin main --tags
```

---

## Konsequenzen

### Positiv
- [Klare Struktur für den ORCH-Agenten in Phase 10]
- [Kein Entscheidungsspielraum bei jedem Release — Strategie ist einmalig festgelegt]

### Negativ / Trade-offs
- [Ggf. mehr Branching-Overhead vs. einfacheres Direkt-auf-main]

### Risiken

| Risiko | Wahrscheinlichkeit | Impact | Mitigation |
|---|---|---|---|
| Branch-Konflikt bei paralleler Entwicklung | Mittel | Mittel | Feature-Branch-Namenskonvention einhalten |
| Vergessener Tag bei Release | Gering | Gering | Phase-10-Checkliste in ORCH |

---

## Reversibilität

[ ] **Reversibel** — Strategiewechsel möglich, erfordert Migration bestehender Branches (~M Aufwand)

---

## Implementierungshinweise für ORCH (Phase 10)

- **Merge-Ziel:** `[Ziel-Branch aus obiger Entscheidung]`
- **Tag-Format:** `[Tag-Format aus obiger Entscheidung]`
- **Cherry-Picking:** Nur auf explizite Nutzeranweisung mit Begründung; kein automatischer Schritt

---

*Erstellt von: AR-Agent | Datum: YYYY-MM-DD | Version: 1.0*
