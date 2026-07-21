# Hooks-Verzeichnis

Git Hooks für automatisierte Qualitätssicherung in Projekten, die die Tool Chain verwenden.

Letzte Aktualisierung: 2026-07-22

## Inhalt

| Datei | Typ | Beschreibung |
|-------|-----|-------------|
| `setup-hooks.sh` | Bash-Script | Installationsscript (Linux/Mac/WSL/Git-Bash) — installiert `pre-commit`/`post-commit` (Bash-Variante) ins Ziel-Repository |
| `setup-hooks.ps1` | PowerShell-Script | Installationsscript (Windows, nativ — kein Git-Bash/WSL nötig) — installiert `pre-commit.windows.ps1`/`post-commit.windows.ps1` als `pre-commit`/`post-commit` |
| `pre-commit` | Git Hook (Bash) | Lint, Datei-Header-Check, Secret-Scan, TODO-Format-Check — installiert von `setup-hooks.sh` |
| `post-commit` | Git Hook (Bash) | INDEX.md-Aktualitätserinnerung — installiert von `setup-hooks.sh` |
| `pre-commit.windows.ps1` | Git Hook (PowerShell) | Funktional identisch zu `pre-commit` — installiert von `setup-hooks.ps1` |
| `post-commit.windows.ps1` | Git Hook (PowerShell) | Funktional identisch zu `post-commit` — installiert von `setup-hooks.ps1` |

**Korrektur (2026-07-22):** Frühere Annahme in dieser Datei war, dass Git unter Windows
Bash-Hooks problemlos über ein gebündeltes `sh.exe` von Git for Windows ausführt. Das gilt
nicht für **MinGit**-Installationen (minimale Git-Distribution ohne Bash/MSYS-Userland) —
dort liegt oft nur Windows' eigener, nicht-funktionsfähiger WSL-`bash.exe`-Launcher-Stub in
PATH, was Bash-Hooks mit einem kryptischen Socket-/Puffer-Fehler fehlschlagen lässt
(entdeckt im Projekt `campaignworld`). `setup-hooks.ps1` installiert deshalb ab sofort die
PowerShell-nativen Varianten (`*.windows.ps1` → `pre-commit`/`post-commit`) statt die
Bash-Dateien zu kopieren. Diese nutzen bewusst **Windows PowerShell 5.1**
(`C:/Windows/System32/WindowsPowerShell/v1.0/powershell.exe`) als Shebang-Interpreter, nicht
`pwsh` (PowerShell 7) — Details dazu im Kopf-Kommentar von `pre-commit.windows.ps1`.
`setup-hooks.sh` (Linux/Mac/WSL/echtes Git-Bash) installiert weiterhin die Bash-Variante
unverändert.

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
