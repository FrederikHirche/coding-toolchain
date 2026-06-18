#!/usr/bin/env bash
# setup-hooks.sh — AI Development Tool Chain
# Installiert Git Hooks für das aktuelle Repository.
#
# Verwendung:
#   bash toolchain/hooks/setup-hooks.sh [--project-root PATH]
#
# Optionen:
#   --project-root PATH   Pfad zum Projekt-Repository (Standard: aktuelles Verzeichnis)
#
# Was installiert wird:
#   - pre-commit:  Lint, Header-Check, Secret-Scan, TODO-Format-Check
#   - post-commit: INDEX.md-Erinnerung, Artefakt-Pflege-Hinweis

set -e

# ─────────────────────────────────────
# Konfiguration
# ─────────────────────────────────────
TOOLCHAIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROJECT_ROOT="$(pwd)"

# Optionaler --project-root Parameter
while [[ "$#" -gt 0 ]]; do
  case $1 in
    --project-root) PROJECT_ROOT="$2"; shift ;;
    *) echo "Unbekannter Parameter: $1"; exit 1 ;;
  esac
  shift
done

GIT_HOOKS_DIR="$PROJECT_ROOT/.git/hooks"

# ─────────────────────────────────────
# Validierung
# ─────────────────────────────────────
if [ ! -d "$PROJECT_ROOT/.git" ]; then
  echo "❌ Fehler: $PROJECT_ROOT ist kein Git-Repository."
  echo "   Erst 'git init' ausführen."
  exit 1
fi

echo "🔧 Tool Chain Hooks installieren..."
echo "   Toolchain: $TOOLCHAIN_DIR"
echo "   Projekt:   $PROJECT_ROOT"
echo ""

# ─────────────────────────────────────
# Hooks installieren
# ─────────────────────────────────────
HOOKS=("pre-commit" "post-commit")

for HOOK in "${HOOKS[@]}"; do
  SRC="$TOOLCHAIN_DIR/hooks/$HOOK"
  DST="$GIT_HOOKS_DIR/$HOOK"

  if [ ! -f "$SRC" ]; then
    echo "  ⚠️  Hook-Quelle nicht gefunden: $SRC — übersprungen."
    continue
  fi

  # Backup falls bereits ein Hook existiert
  if [ -f "$DST" ]; then
    BACKUP="$DST.backup-$(date +%Y%m%d%H%M%S)"
    cp "$DST" "$BACKUP"
    echo "  📦 Bestehender $HOOK gesichert: $BACKUP"
  fi

  cp "$SRC" "$DST"
  chmod +x "$DST"
  echo "  ✅ $HOOK installiert"
done

# ─────────────────────────────────────
# .toolchain-config erstellen (falls nicht vorhanden)
# ─────────────────────────────────────
CONFIG_FILE="$PROJECT_ROOT/.toolchain-config"

if [ ! -f "$CONFIG_FILE" ]; then
  cat > "$CONFIG_FILE" << 'CONFIGEOF'
# .toolchain-config — AI Development Tool Chain
# Projektspezifische Konfiguration für die Tool Chain Hooks.
# Diese Datei ins Repository einchecken.

# Lint-Befehl (wird im pre-commit ausgeführt)
# Beispiele:
#   npm run lint
#   ruff check .
#   golangci-lint run
lint=

# Test-Befehl (für /test-run)
# Beispiele:
#   npm test
#   pytest
#   go test ./...
test=

# Coverage-Befehl
coverage=
CONFIGEOF
  echo "  ✅ .toolchain-config erstellt (bitte befüllen)"
fi

echo ""
echo "🎉 Installation abgeschlossen!"
echo ""
echo "Nächste Schritte:"
echo "  1. .toolchain-config befüllen (Lint- und Test-Befehle)"
echo "  2. Tool Chain starten: /kickoff in Claude Code"
