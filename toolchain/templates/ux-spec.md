---
id: UX-NNN
title: UX-Spec [Feature-Bereich]
version: 1.0
status: DRAFT
author-agent: UX (UX Designer)
date: YYYY-MM-DD
based-on: US-NNN (kommagetrennte Liste)
supersedes: —
superseded-by: —
---

# UX-Spec: [Feature-Bereich]

## 1. Scope

**Abgedeckte User Stories:** US-NNN, US-NNN
**Primäre Nutzungsgruppe:** [Aus SB-NNN]
**Nutzungskontext:** [Desktop / Mobile / Both — primär / sekundär]

---

## 2. User Journeys

### Journey 1: [Journey-Name] (Primary Flow)

**Startpunkt:** [Wo beginnt der Nutzer?]
**Ziel:** [Was will der Nutzer erreichen?]

| Schritt | Nutzeraktion | Systemreaktion | UI-State danach |
|---|---|---|---|
| 1 | [Was tut der Nutzer?] | [Was zeigt/tut das System?] | [State] |
| 2 | [Aktion] | [Reaktion] | [State] |
| N | [Abschluss] | [Bestätigung] | [Endzustand] |

**Abbruchpunkte:** [Wo kann der Nutzer abbrechen? Was passiert dann?]

---

### Journey 2: [Journey-Name] (Fehlerfall / Alternative)

| Schritt | Nutzeraktion | Systemreaktion | UI-State danach |
|---|---|---|---|
| 1 | [Fehlerbehaftete Aktion] | [Fehlermeldung] | [Fehlerzustand] |
| 2 | [Recovery-Aktion] | [Recovery-Reaktion] | [State] |

---

## 3. Views / Seiten

### View: [Name] (z. B. Login-Seite)

**Zweck:** [Was soll der Nutzer hier tun?]
**Erreichbar von:** [Welche anderen Views führen hierher?]
**Führt zu:** [Welche Views folgen?]

#### Layout-Skizze (ASCII)

```
┌─────────────────────────────────┐
│           [Header]              │
├─────────────────────────────────┤
│   [Hauptinhalt]                 │
│                                 │
│   ┌──────────────────────┐      │
│   │ [Eingabefeld]        │      │
│   └──────────────────────┘      │
│   [Button]    [Link]            │
└─────────────────────────────────┘
```

*Nur Struktur, kein Styling — das entscheidet das Design-System.*

#### UI-Zustände

| State | Auslöser | Visueller Zustand | Nutzer-Aktion möglich? |
|---|---|---|---|
| Initial (leer) | Erste Anzeige | [Beschreibung] | Ja |
| Loading | [Aktion ausgelöst] | Spinner / Skeleton | Nein |
| Success | [Erfolg] | [Bestätigung] | Ja |
| Error | [Fehlerfall] | [Fehlermeldung] | Ja (Retry) |
| Empty State | Keine Daten | [Leer-Illustration + CTA] | Ja |

#### Microcopy

| Element | Text (DE) | Hinweise |
|---|---|---|
| Überschrift | [Text] | [Ton: sachlich / freundlich / ...] |
| Primärer Button | [Text] | [Aktion klar benennen] |
| Fehlermeldung: [Typ] | [Text] | [Muss lösungsorientiert sein] |
| Placeholder | [Text] | [Keine "Enter here"-Platitüden] |
| Leerer Zustand | [Text + CTA] | [Was soll der Nutzer als nächstes tun?] |

---

## 4. Accessibility-Anforderungen

**WCAG-Ziel:** [2.1 AA / 2.1 AAA]

| Anforderung | Gilt für | Umsetzungshinweis |
|---|---|---|
| Tastaturnavigation | Alle interaktiven Elemente | Tab-Reihenfolge = logische Lesereihenfolge |
| Focus-Indicator sichtbar | Alle interaktiven Elemente | Kein `outline: none` ohne Alternative |
| Farbkontrast Text | Alle Textelemente | Mindest-Ratio: 4.5:1 (AA) |
| Alt-Text für Bilder | Alle `<img>` | Dekorative Bilder: `alt=""` |
| ARIA-Labels | Icon-Buttons ohne Text | `aria-label` immer setzen |
| Fehlermeldungen | Formulare | `role="alert"` oder `aria-describedby` |
| Skip-Navigation | Hauptnavigation | "Skip to main content"-Link als erstes Element |

---

## 5. Responsive-Verhalten

| Breakpoint | Bezeichnung | Breite | Anpassungen |
|---|---|---|---|
| XS | Mobile | < 640px | [Beschreibung] |
| SM | Tablet | 640–1024px | [Beschreibung] |
| LG | Desktop | > 1024px | [Referenzlayout] |

---

## 6. Animationen & Übergänge

| Element | Übergang | Dauer | Easing | Accessibility-Note |
|---|---|---|---|---|
| Modaler Dialog | Fade-In | 200ms | ease-out | `prefers-reduced-motion` beachten |
| [Element] | [Typ] | [ms] | [Easing] | [a11y-Hinweis] |

---

## 7. Design-System-Referenzen

**Verwendetes Design-System:** [aus ADR]

| Komponente | Design-System-Referenz | Abweichungen |
|---|---|---|
| [Komponente] | [Referenz / Link] | [Falls Abweichung nötig: Begründung] |

---

## 8. Offene Fragen

| # | Frage | Verantwortlich | Status |
|---|---|---|---|
| 1 | [UX-Frage] | [FE / PM / Stakeholder] | OFFEN |

---

*Erstellt von: UX-Agent | Datum: YYYY-MM-DD | Version: 1.0*
