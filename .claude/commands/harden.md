# /harden — Konsolidierung / Hardening

Aktiviert den **Consolidator Agent (CN)** für eine ad-hoc Härtungsrunde über die
bestehende Codebase.

## Verwendung

```
/harden [projektname] [pfad-optional]
/harden mein-projekt "src/"
```

## Wann verwenden

- Vor einem Release, wenn sich technische Schulden angesammelt haben
- Nach mehreren Sprints, wenn tote Pfade/Duplikate vermutet werden
- Bei explizitem Wunsch nach einer Cleanup-Runde außerhalb des normalen Sprint-Rhythmus

## Workflow

```
SCAN     → CN-Agent (Git-Tree-Sauberkeit prüfen, Codebase über codebase-memory scannen)
     ↓
PLAN     → CN-Agent (Kandidaten mit Beweis belegen, SICHER/UNSICHER einstufen)
     ↓
HARDEN   → CN-Agent (nur SICHER-Fixes anwenden, ein benannter Commit)
     ↓
VERIFY   → CN-Agent (Testsuite vor/nach, bei Fehlschlag: Änderung revertieren)
     ↓
REPORT   → CN-Agent (Konsolidierungsbericht: CNS-NNNNNN)
```

## Artefakte

- `CNS-NNNNNN` — Konsolidierungsbericht (Kandidaten, angewendete Fixes, Commit-Hash,
  Test-Verifikation)
- Optional: `DEBT-NNNNNN` für zurückgestellte, unsichere Funde
- Ein Git-Commit im Projekt-Repository (ungepusht)

## Sicherheitsleitplanken

- Startet nur auf sauberem Git-Tree — sonst BLOCKER-Abbruch vor jeder Code-Änderung.
- Jede Löschung ist durch `search_graph`/`trace_path`/`detect_changes` belegt (0 Aufrufer
  projektweit) — keine Löschung auf Verdacht.
- Nur risikoarme Funde werden direkt angewendet; alles Mehrdeutige wird als `DEBT-NNNNNN`
  vorgeschlagen statt angefasst.
- Testsuite (falls konfiguriert) muss vor und nach den Änderungen grün sein.
- Alle Fixes landen in einem einzigen, benannten Commit — kein Push, kein Force, kein
  Amend.

## Abgrenzung

`/harden` ist **kein Ersatz für `/review`** — es reviewt keinen neuen Sprint-Diff, sondern
härtet Bestandscode unabhängig vom Sprint-Zyklus. Es ist auch **kein `/converge`** —
Converge liefert nur einen Report und ändert keinen Code; `/harden` ändert Code direkt,
aber nur innerhalb der oben genannten Sicherheitsleitplanken.

## Nächster Schritt

Abhängig vom Ergebnis in CNS-NNNNNN:
- Fixes angewendet, Sprint läuft noch → `/review [projektname] [sprint-nr]`
- Fixes angewendet, kein aktiver Sprint → keine Folgephase nötig
- BLOCKER (unsauberer Git-Tree oder Constitution-Konflikt) → Nutzer muss reagieren, dann
  `/harden [projektname]` erneut

---

**Agent:** CN (Consolidator)
**Workflow:** `toolchain/workflows/harden.md`
