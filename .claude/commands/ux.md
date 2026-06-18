# /ux — UX Design Phase

Aktiviert den **UX Designer Agent (UX)** für Interaction Design und User Journeys.

## Verwendung

```
/ux [projektname]
```

## Was passiert

1. Liest alle US-NNN und relevante ADRs
2. Aktiviert den UX-Agenten mit seinem System-Prompt
3. Identifiziert primäre User Journeys
4. Erstellt UX-Spec (UX-NNN) pro Feature-Bereich
5. Dokumentiert alle UI-Zustände und Fehlerflüsse
6. Definiert Accessibility-Anforderungen
7. Aktualisiert `projects/<projektname>/INDEX.md`
8. Gibt Übergabe-Zusammenfassung für `/implement` (FE) aus

## Vorbedingungen

- `ADR-001` (Tech-Stack) im Status `APPROVED`
- Alle Must-Have US im Status `APPROVED`

## Nächster Schritt

Nach Abschluss: `/refine` und dann `/implement`

---

**Agent:** UX (UX Designer)
**Input:** `US-NNN`, ADRs, `SB-NNN`
**Output:** `UX-NNN`
**Template:** `toolchain/templates/ux-spec.md`
**Agent-Definition:** `toolchain/agents/ux-agent.md`
