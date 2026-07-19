# Hooks-Verzeichnis

Git Hooks für automatisierte Qualitätssicherung in Projekten, die die Tool Chain verwenden.

Letzte Aktualisierung: 2026-07-20

## Inhalt

| Datei | Typ | Beschreibung |
|-------|-----|-------------|
| `setup-hooks.sh` | Bash-Script | Installationsscript (Linux/Mac/WSL/Git-Bash) — installiert Hooks ins Ziel-Repository |
| `setup-hooks.ps1` | PowerShell-Script | Installationsscript (Windows, nativ — kein Git-Bash/WSL nötig) |
| `pre-commit` | Git Hook | Lint, Datei-Header-Check, Secret-Scan, TODO-Format-Check |
| `post-commit` | Git Hook | INDEX.md-Aktualitätserinnerung |

Die Hook-Dateien selbst (`pre-commit`, `post-commit`) sind Bash-Skripte — das ist auf
Windows unproblematisch, da Git for Windows sie über sein gebündeltes `sh.exe` ausführt.
Nur das *Installationsscript* braucht eine plattformspezifische Variante, da PowerShell
kein `bash`-Kommando kennt.

## Installation

```bash
# Linux / Mac / WSL / Git-Bash — im Wurzelverzeichnis des Ziel-Projekts:
bash toolchain/hooks/setup-hooks.sh

# Für Projekte in einem anderen Verzeichnis:
bash toolchain/hooks/setup-hooks.sh --project-root /pfad/zum/projekt
```

```powershell
# Windows / PowerShell — im Wurzelverzeichnis des Ziel-Projekts:
pwsh toolchain/hooks/setup-hooks.ps1

# Für Projekte in einem anderen Verzeichnis:
pwsh toolchain/hooks/setup-hooks.ps1 -ProjectRoot C:\pfad\zum\projekt
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
