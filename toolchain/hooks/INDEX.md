# Hooks-Verzeichnis

Git Hooks für automatisierte Qualitätssicherung in Projekten, die die Tool Chain verwenden.

Letzte Aktualisierung: 2026-06-18

## Inhalt

| Datei | Typ | Beschreibung |
|-------|-----|-------------|
| `setup-hooks.sh` | Bash-Script | Installationsscript — installiert Hooks ins Ziel-Repository |
| `pre-commit` | Git Hook | Lint, Datei-Header-Check, Secret-Scan, TODO-Format-Check |
| `post-commit` | Git Hook | INDEX.md-Aktualitätserinnerung |

## Installation

```bash
# Im Wurzelverzeichnis des Ziel-Projekts:
bash toolchain/hooks/setup-hooks.sh

# Für Projekte in einem anderen Verzeichnis:
bash toolchain/hooks/setup-hooks.sh --project-root /pfad/zum/projekt
```

## Konfiguration

Nach Installation eine `.toolchain-config` Datei im Projekt-Root befüllen:

```ini
lint=npm run lint
test=npm test
coverage=npm run coverage
```

## Hooks-Verhalten

### pre-commit

Prüft vor jedem Commit:
- Lint (falls in `.toolchain-config` konfiguriert) — **blockt bei Fehler**
- Datei-Header in Code-Dateien — **Warnung** (kein Block)
- Secrets/Credentials im Diff — **blockt bei Fund**
- TODO-Marker-Format — **Warnung** (kein Block)

### post-commit

Gibt nach jedem Commit Hinweis aus, wenn INDEX.md-Dateien in geänderten Verzeichnissen nicht aktualisiert wurden.
