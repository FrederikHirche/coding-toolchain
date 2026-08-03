#!/usr/bin/env bash
# Synchronisiert Tool-Chain-Artefakte (US/BUG/DEBT/IMPD) mit einem GitHub Project (v2) Board.
# Implementiert toolchain/protocols/github-board-sync.md. Best-effort, nie blockierend:
# fehlt gh, Auth oder Board-Konfiguration, wird der Sync ohne Fehlercode übersprungen.
#
# Nutzung: github-board-sync.sh --project-path <pfad> --mode push|reconcile

set -uo pipefail

PROJECT_PATH=""
MODE=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --project-path) PROJECT_PATH="$2"; shift 2 ;;
    --mode) MODE="$2"; shift 2 ;;
    *) echo "Unbekannte Option: $1" >&2; exit 1 ;;
  esac
done

if [[ -z "$PROJECT_PATH" || -z "$MODE" ]]; then
  echo "Usage: github-board-sync.sh --project-path <pfad> --mode push|reconcile" >&2
  exit 1
fi

log_info() { echo "[github-board-sync] $1"; }
log_warn() { echo "[github-board-sync] WARN: $1" >&2; }

CONFIG_PATH="$PROJECT_PATH/.toolchain.yml"
if [[ ! -f "$CONFIG_PATH" ]]; then
  log_info ".toolchain.yml fehlt — Sync übersprungen."
  exit 0
fi

get_scalar() {
  # $1 = key innerhalb des github:-Blocks (2-Space-Einrückung)
  sed -n "s/^  $1: *\([^#]*\).*/\1/p" "$CONFIG_PATH" | head -n1 | sed 's/[[:space:]]*$//' | sed 's/^~$//'
}

GH_ENABLED="$(get_scalar enabled)"
if [[ "$GH_ENABLED" != "true" ]]; then
  log_info "github.enabled ist false — Sync übersprungen."
  exit 0
fi

GH_REPO="$(get_scalar repo)"
GH_PROJECT_NUMBER="$(get_scalar project-number)"
GH_AUTH_MODE="$(get_scalar auth-mode)"
GH_AUTH_ENV_VAR="$(get_scalar auth-env-var)"
GH_AUTH_MODE="${GH_AUTH_MODE:-gh-cli}"

if [[ -z "$GH_REPO" ]]; then
  log_warn "github.repo nicht gesetzt — Sync übersprungen."
  exit 0
fi

if ! command -v gh >/dev/null 2>&1; then
  log_warn "gh-CLI nicht installiert — Sync übersprungen. Siehe cli.github.com."
  exit 0
fi

if [[ "$GH_AUTH_MODE" == "env-var" ]]; then
  if [[ -z "$GH_AUTH_ENV_VAR" || -z "${!GH_AUTH_ENV_VAR:-}" ]]; then
    log_warn "Environment-Variable '$GH_AUTH_ENV_VAR' nicht gesetzt — Sync übersprungen."
    exit 0
  fi
  export GH_TOKEN="${!GH_AUTH_ENV_VAR}"
else
  if ! gh auth status --hostname github.com >/tmp/gh-auth-status.$$ 2>&1; then
    log_warn "gh nicht authentifiziert — bitte 'gh auth login --scopes project,repo' selbst ausführen. Sync übersprungen."
    rm -f /tmp/gh-auth-status.$$
    exit 0
  fi
  if ! grep -q 'project' /tmp/gh-auth-status.$$; then
    log_warn "gh-Token ohne 'project'-Scope — bitte 'gh auth refresh --scopes project,repo' ausführen. Sync übersprungen."
    rm -f /tmp/gh-auth-status.$$
    exit 0
  fi
  rm -f /tmp/gh-auth-status.$$
fi

CURRENT_PHASE="INIT"
if [[ -f "$PROJECT_PATH/.phase" ]]; then
  CURRENT_PHASE="$(sed -n 's/^current-phase:[[:space:]]*\([^[:space:]]*\).*/\1/p' "$PROJECT_PATH/.phase" | head -n1)"
  CURRENT_PHASE="${CURRENT_PHASE:-INIT}"
fi

board_status_for() {
  # $1 = ArtifactType (US|BUG|DEBT|IMPD), $2 = ArtifactStatus
  case "$1" in
    BUG)
      case "$2" in
        OFFEN) echo "Backlog" ;;
        IN_BEARBEITUNG) echo "In Progress" ;;
        BEHOBEN) echo "In Review" ;;
        VERIFIZIERT) echo "Done" ;;
        *) echo "Backlog" ;;
      esac ;;
    DEBT)
      case "$2" in
        OFFEN) echo "Backlog" ;;
        "IN BEARBEITUNG") echo "In Progress" ;;
        RESOLVED) echo "Done" ;;
        *) echo "Backlog" ;;
      esac ;;
    IMPD)
      case "$2" in
        DRAFT) echo "Backlog" ;;
        ACTIVE) echo "In Progress" ;;
        RESOLVED) echo "Done" ;;
        *) echo "Backlog" ;;
      esac ;;
    *)
      case "$CURRENT_PHASE" in
        REVIEW|DOCUMENTATION|DONE|RELEASED) echo "Done" ;;
        IMPLEMENTATION|TESTING) echo "In Progress" ;;
        *) echo "Backlog" ;;
      esac ;;
  esac
}

get_frontmatter_field() {
  # $1 = Datei, $2 = Feldname
  awk -v key="$2" '
    /^---$/ { c++; next }
    c==1 {
      n = index($0, ":")
      if (n > 0) {
        k = substr($0, 1, n-1)
        v = substr($0, n+1)
        gsub(/^[ \t]+|[ \t]+$/, "", k)
        gsub(/^[ \t]+/, "", v)
        sub(/[ \t]*#.*$/, "", v)
        gsub(/[ \t]+$/, "", v)
        if (k == key) { print v; exit }
      }
    }
  ' "$1"
}

set_frontmatter_field() {
  # $1 = Datei, $2 = Feldname, $3 = Wert
  awk -v key="$2" -v val="$3" '
    BEGIN { c=0; done=0 }
    /^---$/ {
      c++
      if (c==2 && done==0) { print key ": " val; done=1 }
      print; next
    }
    c==1 {
      n = index($0, ":")
      if (n > 0) {
        k = substr($0, 1, n-1)
        gsub(/^[ \t]+|[ \t]+$/, "", k)
        if (k == key) { print key ": " val; done=1; next }
      }
    }
    { print }
  ' "$1" > "$1.tmp" && mv "$1.tmp" "$1"
}

# ── Board-Feld-Auflösung ─────────────────────────────────────────────────
# gh project item-edit verlangt GraphQL-Node-IDs für --id/--field-id/--single-select-option-id,
# keine Klartext-Namen und keine Issue-Nummer. Diese IDs werden einmal pro Lauf über --jq
# (in gh CLI eingebaut, kein externes jq nötig) aufgelöst; die Issue→Item-ID-Zuordnung wird in
# einer temporären Cache-Datei gehalten (Bash 3.2 auf macOS kennt keine assoziativen Arrays).

GH_OWNER="${GH_REPO%%/*}"
GH_PROJECT_ID=""
STATUS_FIELD_ID=""
ITEM_CACHE_FILE=""

if [[ -n "$GH_PROJECT_NUMBER" ]]; then
  GH_PROJECT_ID="$(gh project view "$GH_PROJECT_NUMBER" --owner "$GH_OWNER" --format json --jq '.id' 2>/dev/null)"
  STATUS_FIELD_ID="$(gh project field-list "$GH_PROJECT_NUMBER" --owner "$GH_OWNER" --format json --jq '.fields[] | select(.name=="Status") | .id' 2>/dev/null)"
  if [[ -z "$STATUS_FIELD_ID" ]]; then
    log_warn "Kein Status-Feld im Board gefunden — Status-Updates werden für diesen Lauf übersprungen."
  else
    ITEM_CACHE_FILE="$(mktemp)"
    gh project item-list "$GH_PROJECT_NUMBER" --owner "$GH_OWNER" --format json --limit 500 \
      --jq '.items[] | select(.content.number != null) | "\(.content.number) \(.id)"' \
      >"$ITEM_CACHE_FILE" 2>/dev/null
    trap 'rm -f "$ITEM_CACHE_FILE"' EXIT
  fi
fi

resolve_option_id() {
  # $1 = boardStatus name
  [[ -z "$STATUS_FIELD_ID" ]] && return 0
  gh project field-list "$GH_PROJECT_NUMBER" --owner "$GH_OWNER" --format json \
    --jq ".fields[] | select(.name==\"Status\") | .options[] | select(.name==\"$1\") | .id" 2>/dev/null
}

get_item_id_for_issue() {
  # $1 = issue number
  [[ -z "$ITEM_CACHE_FILE" ]] && return 0
  awk -v n="$1" '$1 == n { print $2; exit }' "$ITEM_CACHE_FILE"
}

set_board_item_status() {
  # $1 = issue_url (leer, falls Issue bereits existierte), $2 = issue_number, $3 = board_status
  local issue_url="$1" issue_number="$2" board_status="$3"
  [[ -z "$GH_PROJECT_NUMBER" || -z "$STATUS_FIELD_ID" ]] && return 0

  local item_id
  if [[ -n "$issue_url" ]]; then
    item_id="$(gh project item-add "$GH_PROJECT_NUMBER" --owner "$GH_OWNER" --url "$issue_url" --format json --jq '.id' 2>/dev/null)"
    [[ -n "$item_id" && -n "$ITEM_CACHE_FILE" ]] && echo "$issue_number $item_id" >>"$ITEM_CACHE_FILE"
  else
    item_id="$(get_item_id_for_issue "$issue_number")"
  fi
  [[ -z "$item_id" ]] && return 0

  local option_id
  option_id="$(resolve_option_id "$board_status")"
  if [[ -z "$option_id" ]]; then
    log_warn "Keine passende Status-Option für '$board_status' im Board gefunden — Update übersprungen."
    return 0
  fi
  gh project item-edit --id "$item_id" --field-id "$STATUS_FIELD_ID" --project-id "$GH_PROJECT_ID" --single-select-option-id "$option_id" >/dev/null 2>&1
}

sync_artifact() {
  local file="$1" type="$2" mode="$3"
  local issue_number title status board_status

  issue_number="$(get_frontmatter_field "$file" github-issue)"
  title="$(get_frontmatter_field "$file" title)"
  status="$(get_frontmatter_field "$file" status)"
  board_status="$(board_status_for "$type" "$status")"

  if [[ "$type" == "IMPD" && "$status" == "RESOLVED" && ( -z "$issue_number" || "$issue_number" == "—" ) ]]; then
    return 0
  fi

  if [[ "$mode" == "reconcile" ]]; then
    [[ -z "$issue_number" || "$issue_number" == "—" ]] && return 0
    local state
    state="$(gh issue view "$issue_number" --repo "$GH_REPO" --json state --jq .state 2>/dev/null)"
    [[ -z "$state" ]] && return 0
    local expected_open="true"
    [[ "$board_status" == "Done" ]] && expected_open="false"
    local is_open="true"
    [[ "$state" != "OPEN" ]] && is_open="false"
    if [[ "$expected_open" != "$is_open" ]]; then
      log_warn "Konflikt: $file erwartet Board-Status '$board_status', Issue #$issue_number steht auf '$state'. Tool-Chain-Gates gewinnen."
    fi
    return 0
  fi

  # Mode: push
  local issue_url=""
  if [[ -z "$issue_number" || "$issue_number" == "—" ]]; then
    issue_url="$(gh issue create --repo "$GH_REPO" --title "$type: $title" --body "Synchronisiert aus $file" 2>/dev/null | tail -n1)"
    if [[ -z "$issue_url" ]]; then
      log_warn "Issue-Erstellung fehlgeschlagen für $file"
      return 0
    fi
    issue_number="${issue_url##*/}"
    set_frontmatter_field "$file" github-issue "$issue_number"
    log_info "Issue #$issue_number angelegt für $file"
  fi

  set_board_item_status "$issue_url" "$issue_number" "$board_status"
  log_info "$file → Issue #$issue_number, Board-Status: $board_status"
}

for glob_type in "requirements/US-*.md:US" "testing/BUG-*.md:BUG" "retros/IMPD-*.md:IMPD"; do
  pattern="${glob_type%%:*}"
  type="${glob_type##*:}"
  for file in "$PROJECT_PATH"/$pattern; do
    [[ -f "$file" ]] || continue
    sync_artifact "$file" "$type" "$MODE"
  done
done

# DEBT-REGISTRY: Tabellen-basierte Zeilen statt Frontmatter-pro-Datei — siehe Protokoll.
for debt_file in "$PROJECT_PATH"/retros/DEBT-REGISTRY*.md; do
  [[ -f "$debt_file" ]] || continue
  while IFS='|' read -r _ id titletext prio kat sprint agent status issue _; do
    id="$(echo "$id" | xargs)"
    [[ "$id" =~ ^DEBT-[0-9]+$ ]] || continue
    titletext="$(echo "$titletext" | xargs)"
    status="$(echo "$status" | xargs)"
    issue="$(echo "$issue" | xargs)"
    board_status="$(board_status_for DEBT "$status")"

    if [[ "$MODE" == "reconcile" ]]; then
      [[ -z "$issue" || "$issue" == "—" ]] && continue
      state="$(gh issue view "$issue" --repo "$GH_REPO" --json state --jq .state 2>/dev/null)"
      [[ -z "$state" ]] && continue
      expected_open="true"; [[ "$board_status" == "Done" ]] && expected_open="false"
      is_open="true"; [[ "$state" != "OPEN" ]] && is_open="false"
      if [[ "$expected_open" != "$is_open" ]]; then
        log_warn "Konflikt: $id erwartet Board-Status '$board_status', Issue #$issue steht auf '$state'. Tool-Chain-Gates gewinnen."
      fi
      continue
    fi

    issue_url=""
    if [[ -z "$issue" || "$issue" == "—" ]]; then
      issue_url="$(gh issue create --repo "$GH_REPO" --title "DEBT: $titletext" --body "Synchronisiert aus $debt_file ($id)" 2>/dev/null | tail -n1)"
      if [[ -z "$issue_url" ]]; then
        log_warn "Issue-Erstellung fehlgeschlagen für $id"
        continue
      fi
      issue="${issue_url##*/}"
      sed -i "s/| $id \(.*\)| *— *|$/| $id \1| $issue |/" "$debt_file"
      log_info "Issue #$issue angelegt für $id"
    fi
    set_board_item_status "$issue_url" "$issue" "$board_status"
    log_info "$id → Issue #$issue, Board-Status: $board_status"
  done < <(grep -E '^\| DEBT-[0-9]+ ' "$debt_file")
done

log_info "Sync-Modus '$MODE' abgeschlossen."
exit 0
