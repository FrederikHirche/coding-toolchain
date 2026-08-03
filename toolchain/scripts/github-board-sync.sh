#!/usr/bin/env bash
# Synchronisiert Tool-Chain-Artefakte (US/BUG/DEBT/IMPD/EPIC) mit einem GitHub Project (v2) Board.
# Implementiert toolchain/protocols/github-board-sync.md. Best-effort, nie blockierend:
# fehlt gh, Auth oder Board-Konfiguration, wird der Sync ohne Fehlercode übersprungen.
#
# Synchronisiert den GESAMTEN Backlog (nicht nur den laufenden Sprint): Status, Estimate,
# Size, Priority, Iteration, Start-/Zieldatum, Milestone (aus EPIC-NNNNNN) sowie eine
# vollständig aus dem Artefakt gerenderte Issue-Beschreibung inkl. Akzeptanzkriterien.
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

board_priority_for() {
  # $1 = ArtifactType, $2 = priority (US) oder severity (BUG)
  if [[ "$1" == "BUG" ]]; then
    case "$2" in
      BLOCKER) echo "P0" ;;
      MAJOR) echo "P1" ;;
      MINOR) echo "P2" ;;
      *) echo "" ;;
    esac
  else
    case "$2" in
      Must) echo "P0" ;;
      Should) echo "P1" ;;
      Could) echo "P2" ;;
      "Won't") echo "P3" ;;
      *) echo "" ;;
    esac
  fi
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

# ── Issue-Body-Rendering ─────────────────────────────────────────────────
# Sektionen der Templates sind durch Zeilen mit ausschließlich "---" getrennt (siehe
# toolchain/templates/*.md). Das erlaubt robustes Extrahieren ohne pro Typ hartkodierte
# Zeilennummern.

get_section_by_marker() {
  # $1 = Datei, $2 = Marker-Substring (z. B. "## Akzeptanzkriterien")
  awk -v marker="$2" '
    /^---[ \t]*$/ {
      fm++
      if (fm <= 2) { next }
      if (index(sec, marker) > 0) { print sec; exit }
      sec=""; next
    }
    fm>=2 { sec = sec $0 "\n" }
    END { if (index(sec, marker) > 0) print sec }
  ' "$1"
}

format_meta_footer() {
  # $1=type $2=priority $3=estimate $4=size $5=iteration $6=start $7=target $8=epic
  echo ""
  echo "---"
  echo ""
  echo "**Tool-Chain-Metadaten** _(automatisch synchronisiert — Änderungen bitte in der Quelldatei vornehmen)_"
  echo ""
  [[ -n "$2" && "$2" != "—" ]] && echo "- Priorität/Schweregrad: $2"
  [[ -n "$3" && "$3" != "—" ]] && echo "- Estimate: $3 Story Points"
  [[ -n "$4" && "$4" != "—" ]] && echo "- Size: $4"
  [[ -n "$5" && "$5" != "—" ]] && echo "- Geplante Iteration: Sprint $5"
  [[ -n "$6" && "$6" != "—" ]] && echo "- Start: $6"
  [[ -n "$7" && "$7" != "—" ]] && echo "- Ziel: $7"
  [[ -n "$8" && "$8" != "—" ]] && echo "- Epic: $8"
  return 0
}

format_issue_body() {
  # $1 = Datei, $2 = Typ (US|BUG|IMPD), $3 = Ausgabedatei
  local file="$1" type="$2" out="$3"
  {
    echo "_Synchronisiert aus \`$file\` — wird bei jedem Sync-Lauf überschrieben._"
    echo ""
    case "$type" in
      US)
        get_section_by_marker "$file" "## User Story"; echo ""
        get_section_by_marker "$file" "## Akzeptanzkriterien"; echo ""
        get_section_by_marker "$file" "## Nicht-Ziele dieser Story"; echo ""
        get_section_by_marker "$file" "## Abhängigkeiten"; echo ""
        ;;
      BUG)
        get_section_by_marker "$file" "## 1. Symptom"; echo ""
        get_section_by_marker "$file" "## 2. Reproduktionsschritte"; echo ""
        get_section_by_marker "$file" "## 3. Schweregrad"; echo ""
        ;;
      IMPD)
        get_section_by_marker "$file" "## Zusammenfassung"; echo ""
        get_section_by_marker "$file" "## Diagnose"; echo ""
        ;;
    esac
    local priority estimate size iteration start target epic
    if [[ "$type" == "BUG" ]]; then priority="$(get_frontmatter_field "$file" severity)"; else priority="$(get_frontmatter_field "$file" priority)"; fi
    estimate="$(get_frontmatter_field "$file" estimate)"
    size="$(get_frontmatter_field "$file" size)"
    iteration="$(get_frontmatter_field "$file" iteration)"
    start="$(get_frontmatter_field "$file" start-date)"
    target="$(get_frontmatter_field "$file" target-date)"
    epic="$(get_frontmatter_field "$file" epic)"
    format_meta_footer "$type" "$priority" "$estimate" "$size" "$iteration" "$start" "$target" "$epic"
  } > "$out"
}

# ── Board-Feld-Auflösung ─────────────────────────────────────────────────
# gh project item-edit verlangt GraphQL-Node-IDs für --id/--field-id/--single-select-option-id/
# --iteration-id, keine Klartext-Namen und keine Issue-Nummer. Feld-IDs werden einmal pro
# Lauf aufgelöst; Options-/Iteration-IDs werden je Wert über --jq nachgeschlagen (kein
# externes jq nötig — gh bringt seine eigene --jq-Auswertung mit).

GH_OWNER="${GH_REPO%%/*}"
GH_PROJECT_ID=""
FIELD_ID_STATUS=""
FIELD_ID_ESTIMATE=""
FIELD_ID_SIZE=""
FIELD_ID_PRIORITY=""
FIELD_ID_ITERATION=""
FIELD_ID_STARTDATE=""
FIELD_ID_TARGETDATE=""
ITEM_CACHE_FILE=""

field_id_for() {
  gh project field-list "$GH_PROJECT_NUMBER" --owner "$GH_OWNER" --format json --jq ".fields[] | select(.name==\"$1\") | .id" 2>/dev/null
}

if [[ -n "$GH_PROJECT_NUMBER" ]]; then
  GH_PROJECT_ID="$(gh project view "$GH_PROJECT_NUMBER" --owner "$GH_OWNER" --format json --jq '.id' 2>/dev/null)"
  FIELD_ID_STATUS="$(field_id_for Status)"
  FIELD_ID_ESTIMATE="$(field_id_for Estimate)"
  FIELD_ID_SIZE="$(field_id_for Size)"
  FIELD_ID_PRIORITY="$(field_id_for Priority)"
  FIELD_ID_ITERATION="$(field_id_for Iteration)"
  FIELD_ID_STARTDATE="$(field_id_for "Start date")"
  FIELD_ID_TARGETDATE="$(field_id_for "Target date")"
  for pair in "Status:$FIELD_ID_STATUS" "Estimate:$FIELD_ID_ESTIMATE" "Size:$FIELD_ID_SIZE" \
              "Priority:$FIELD_ID_PRIORITY" "Iteration:$FIELD_ID_ITERATION" \
              "Start date:$FIELD_ID_STARTDATE" "Target date:$FIELD_ID_TARGETDATE"; do
    name="${pair%%:*}"; id="${pair##*:}"
    [[ -z "$id" ]] && log_warn "Board-Feld '$name' nicht gefunden — zugehörige Updates werden für diesen Lauf übersprungen."
  done

  if [[ -n "$FIELD_ID_STATUS" ]]; then
    ITEM_CACHE_FILE="$(mktemp)"
    gh project item-list "$GH_PROJECT_NUMBER" --owner "$GH_OWNER" --format json --limit 500 \
      --jq '.items[] | select(.content.number != null) | "\(.content.number) \(.id)"' \
      >"$ITEM_CACHE_FILE" 2>/dev/null
    trap 'rm -f "$ITEM_CACHE_FILE"' EXIT
  fi
fi

resolve_option_id() {
  # $1 = Feldname (z. B. "Size"), $2 = Wert
  [[ -z "$GH_PROJECT_NUMBER" ]] && return 0
  gh project field-list "$GH_PROJECT_NUMBER" --owner "$GH_OWNER" --format json \
    --jq ".fields[] | select(.name==\"$1\") | .options[] | select(.name==\"$2\") | .id" 2>/dev/null
}

resolve_iteration_id() {
  # $1 = geplante Sprint-Nr. (1-basiert) — Zyklen chronologisch sortiert, N-ter Zyklus = Sprint N
  [[ -z "$GH_PROJECT_NUMBER" || -z "$FIELD_ID_ITERATION" ]] && return 0
  local ids idx count
  ids="$(gh project field-list "$GH_PROJECT_NUMBER" --owner "$GH_OWNER" --format json \
    --jq '.fields[] | select(.name=="Iteration") | (.configuration.iterations + .configuration.completedIterations) | sort_by(.startDate)[].id' 2>/dev/null)"
  [[ -z "$ids" ]] && return 0
  local arr=()
  while IFS= read -r line; do arr+=("$line"); done <<< "$ids"
  idx=$(( $1 - 1 ))
  (( idx < 0 )) && idx=0
  count=${#arr[@]}
  if (( idx >= count )); then
    log_warn "Iteration $1 liegt außerhalb der auf dem Board materialisierten Zyklen — letzte verfügbare Iteration wird verwendet."
    idx=$((count - 1))
  fi
  echo "${arr[$idx]}"
}

set_board_field_value() {
  # $1 = item_id, $2 = field_id, $3 = value_type (Number|Date|SingleSelect|Iteration),
  # $4 = value, $5 = Feldname (für SingleSelect-Lookup)
  local item_id="$1" field_id="$2" value_type="$3" value="$4" field_name="$5"
  [[ -z "$item_id" || -z "$field_id" || -z "$value" || "$value" == "—" ]] && return 0
  case "$value_type" in
    Number)
      gh project item-edit --id "$item_id" --field-id "$field_id" --project-id "$GH_PROJECT_ID" --number "$value" >/dev/null 2>&1 ;;
    Date)
      gh project item-edit --id "$item_id" --field-id "$field_id" --project-id "$GH_PROJECT_ID" --date "$value" >/dev/null 2>&1 ;;
    SingleSelect)
      local option_id
      option_id="$(resolve_option_id "$field_name" "$value")"
      if [[ -z "$option_id" ]]; then
        log_warn "Keine passende Option '$value' für Feld '$field_name' gefunden — Update übersprungen."
        return 0
      fi
      gh project item-edit --id "$item_id" --field-id "$field_id" --project-id "$GH_PROJECT_ID" --single-select-option-id "$option_id" >/dev/null 2>&1 ;;
    Iteration)
      local iteration_id
      iteration_id="$(resolve_iteration_id "$value")"
      [[ -z "$iteration_id" ]] && return 0
      gh project item-edit --id "$item_id" --field-id "$field_id" --project-id "$GH_PROJECT_ID" --iteration-id "$iteration_id" >/dev/null 2>&1 ;;
  esac
}

get_item_id_for_issue() {
  # $1 = issue number
  [[ -z "$ITEM_CACHE_FILE" ]] && return 0
  awk -v n="$1" '$1 == n { print $2; exit }' "$ITEM_CACHE_FILE"
}

get_board_item_id() {
  # $1 = issue_url (leer, falls Issue bereits existierte), $2 = issue_number
  [[ -z "$GH_PROJECT_NUMBER" ]] && return 0
  local item_id
  if [[ -n "$1" ]]; then
    item_id="$(gh project item-add "$GH_PROJECT_NUMBER" --owner "$GH_OWNER" --url "$1" --format json --jq '.id' 2>/dev/null)"
    [[ -n "$item_id" && -n "$ITEM_CACHE_FILE" ]] && echo "$2 $item_id" >>"$ITEM_CACHE_FILE"
  else
    item_id="$(get_item_id_for_issue "$2")"
  fi
  echo "$item_id"
}

# ── Milestones (Epics) ───────────────────────────────────────────────────

get_milestone_number_by_title() {
  gh api "repos/$GH_REPO/milestones" --paginate --jq ".[] | select(.title==\"$1\") | .number" 2>/dev/null | head -n1
}

get_milestone_title_by_number() {
  gh api "repos/$GH_REPO/milestones/$1" --jq '.title' 2>/dev/null
}

sync_epic_milestone() {
  # $1 = EPIC-*.md Datei
  local file="$1" title milestone_number created
  title="$(get_frontmatter_field "$file" title)"
  milestone_number="$(get_frontmatter_field "$file" github-milestone)"
  if [[ -z "$milestone_number" || "$milestone_number" == "—" ]]; then
    milestone_number="$(get_milestone_number_by_title "$title")"
    if [[ -z "$milestone_number" ]]; then
      created="$(gh api "repos/$GH_REPO/milestones" -f "title=$title" -f "description=Synchronisiert aus $file" --jq '.number' 2>/dev/null)"
      if [[ -n "$created" ]]; then
        milestone_number="$created"
        log_info "Milestone '$title' angelegt (#$milestone_number) für $file"
      fi
    fi
    [[ -n "$milestone_number" ]] && set_frontmatter_field "$file" github-milestone "$milestone_number"
  fi
}

# Ergebnisvariablen von get_epic_milestone: EPIC_MILESTONE_TITLE / EPIC_MILESTONE_NUMBER
get_epic_milestone() {
  # $1 = EPIC-NNNNNN-Referenz aus einem Artefakt
  EPIC_MILESTONE_TITLE=""
  EPIC_MILESTONE_NUMBER=""
  local epic_id="$1" epic_file number title
  [[ -z "$epic_id" || "$epic_id" == "—" ]] && return 0
  epic_file="$(ls "$PROJECT_PATH"/requirements/${epic_id}*.md 2>/dev/null | head -n1)"
  [[ -z "$epic_file" ]] && return 0
  number="$(get_frontmatter_field "$epic_file" github-milestone)"
  [[ -z "$number" || "$number" == "—" ]] && return 0
  title="$(get_milestone_title_by_number "$number")"
  [[ -z "$title" ]] && return 0
  EPIC_MILESTONE_TITLE="$title"
  EPIC_MILESTONE_NUMBER="$number"
}

sync_artifact() {
  local file="$1" type="$2" mode="$3"
  local issue_number title status board_status board_priority

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
  local issue_url="" body_file
  body_file="$(mktemp)"
  format_issue_body "$file" "$type" "$body_file"

  if [[ -z "$issue_number" || "$issue_number" == "—" ]]; then
    issue_url="$(gh issue create --repo "$GH_REPO" --title "$type: $title" --body-file "$body_file" 2>/dev/null | tail -n1)"
    if [[ -z "$issue_url" ]]; then
      log_warn "Issue-Erstellung fehlgeschlagen für $file"
      rm -f "$body_file"
      return 0
    fi
    issue_number="${issue_url##*/}"
    set_frontmatter_field "$file" github-issue "$issue_number"
    log_info "Issue #$issue_number angelegt für $file"
  else
    gh issue edit "$issue_number" --repo "$GH_REPO" --body-file "$body_file" >/dev/null 2>&1
  fi
  rm -f "$body_file"

  local epic_id
  epic_id="$(get_frontmatter_field "$file" epic)"
  get_epic_milestone "$epic_id"
  if [[ -n "$EPIC_MILESTONE_TITLE" ]]; then
    gh issue edit "$issue_number" --repo "$GH_REPO" --milestone "$EPIC_MILESTONE_TITLE" >/dev/null 2>&1
    set_frontmatter_field "$file" github-milestone "$EPIC_MILESTONE_NUMBER"
  fi

  local item_id
  item_id="$(get_board_item_id "$issue_url" "$issue_number")"
  if [[ -n "$item_id" ]]; then
    if [[ "$type" == "BUG" ]]; then board_priority="$(board_priority_for BUG "$(get_frontmatter_field "$file" severity)")"
    else board_priority="$(board_priority_for "$type" "$(get_frontmatter_field "$file" priority)")"; fi
    set_board_field_value "$item_id" "$FIELD_ID_STATUS" SingleSelect "$board_status" Status
    set_board_field_value "$item_id" "$FIELD_ID_ESTIMATE" Number "$(get_frontmatter_field "$file" estimate)" Estimate
    set_board_field_value "$item_id" "$FIELD_ID_SIZE" SingleSelect "$(get_frontmatter_field "$file" size)" Size
    set_board_field_value "$item_id" "$FIELD_ID_PRIORITY" SingleSelect "$board_priority" Priority
    set_board_field_value "$item_id" "$FIELD_ID_ITERATION" Iteration "$(get_frontmatter_field "$file" iteration)" Iteration
    set_board_field_value "$item_id" "$FIELD_ID_STARTDATE" Date "$(get_frontmatter_field "$file" start-date)" "Start date"
    set_board_field_value "$item_id" "$FIELD_ID_TARGETDATE" Date "$(get_frontmatter_field "$file" target-date)" "Target date"
  fi
  log_info "$file → Issue #$issue_number, Board-Status: $board_status"
}

# Epics zuerst — Milestones müssen existieren, bevor Stories/Bugs/Schulden darauf verweisen.
if [[ "$MODE" == "push" ]]; then
  for epic_file in "$PROJECT_PATH"/requirements/EPIC-*.md; do
    [[ -f "$epic_file" ]] || continue
    sync_epic_milestone "$epic_file"
  done
fi

for glob_type in "requirements/US-*.md:US" "testing/BUG-*.md:BUG" "retros/IMPD-*.md:IMPD"; do
  pattern="${glob_type%%:*}"
  type="${glob_type##*:}"
  for file in "$PROJECT_PATH"/$pattern; do
    [[ -f "$file" ]] || continue
    sync_artifact "$file" "$type" "$MODE"
  done
done

# DEBT-REGISTRY: Tabellen-basierte Zeilen statt Frontmatter-pro-Datei — siehe Protokoll.
# Spaltenreihenfolge wird aus der Kopfzeile gelesen (nicht positionsfest), damit zusätzliche
# Spalten (Epic/Estimate/Size/Iteration/Start/Ziel/GitHub Milestone) robust erkannt werden.
for debt_file in "$PROJECT_PATH"/retros/DEBT-REGISTRY*.md; do
  [[ -f "$debt_file" ]] || continue
  header_line="$(grep -n -m1 '^| *ID *|' "$debt_file" | cut -d: -f1)"
  [[ -z "$header_line" ]] && continue
  IFS='|' read -r -a col_cells < <(sed -n "${header_line}p" "$debt_file")
  columns=()
  for cell in "${col_cells[@]}"; do
    trimmed="$(echo "$cell" | xargs)"
    [[ -n "$trimmed" ]] && columns+=("$trimmed")
  done

  data_start=$((header_line + 2))
  row_num=0
  changed=0
  tmp_file="$(mktemp)"
  cp "$debt_file" "$tmp_file"

  total_lines=$(wc -l < "$debt_file")
  for (( ln = data_start; ln <= total_lines; ln++ )); do
    line="$(sed -n "${ln}p" "$debt_file")"
    [[ "$line" =~ ^\|[[:space:]]*DEBT-[0-9]+[[:space:]]*\| ]] || break

    IFS='|' read -r -a raw_cells <<< "$line"
    cells=()
    for cell in "${raw_cells[@]:1}"; do
      cells+=("$(echo "$cell" | xargs)")
    done
    # letzte Zelle ist leer (trailing pipe) — entfernen
    if [[ -n "${cells[-1]:-x}" && "${cells[-1]}" == "" ]]; then unset 'cells[-1]'; fi

    declare -A row=()
    for (( c = 0; c < ${#columns[@]} && c < ${#cells[@]}; c++ )); do
      row["${columns[$c]}"]="${cells[$c]}"
    done

    id="${row[ID]:-}"
    status="${row[Status]:-}"
    issue_number="${row[GitHub Issue]:-}"
    board_status="$(board_status_for DEBT "$status")"

    if [[ "$MODE" == "reconcile" ]]; then
      if [[ -n "$issue_number" && "$issue_number" != "—" ]]; then
        state="$(gh issue view "$issue_number" --repo "$GH_REPO" --json state --jq .state 2>/dev/null)"
        if [[ -n "$state" ]]; then
          expected_open="true"; [[ "$board_status" == "Done" ]] && expected_open="false"
          is_open="true"; [[ "$state" != "OPEN" ]] && is_open="false"
          if [[ "$expected_open" != "$is_open" ]]; then
            log_warn "Konflikt: $id erwartet Board-Status '$board_status', Issue #$issue_number steht auf '$state'. Tool-Chain-Gates gewinnen."
          fi
        fi
      fi
      unset row
      continue
    fi

    # Mode: push
    issue_url=""
    body_file="$(mktemp)"
    {
      echo "_Synchronisiert aus \`$debt_file\` ($id) — wird bei jedem Sync-Lauf überschrieben._"
      format_meta_footer DEBT "" "${row[Estimate]:-}" "${row[Size]:-}" "${row[Iteration]:-}" "${row[Start]:-}" "${row[Ziel]:-}" "${row[Epic]:-}"
    } > "$body_file"

    if [[ -z "$issue_number" || "$issue_number" == "—" ]]; then
      issue_url="$(gh issue create --repo "$GH_REPO" --title "DEBT: ${row[Titel]:-}" --body-file "$body_file" 2>/dev/null | tail -n1)"
      if [[ -z "$issue_url" ]]; then
        log_warn "Issue-Erstellung fehlgeschlagen für $id"
        rm -f "$body_file"; unset row
        continue
      fi
      issue_number="${issue_url##*/}"
      row["GitHub Issue"]="$issue_number"
      changed=1
      log_info "Issue #$issue_number angelegt für $id"
    fi
    rm -f "$body_file"

    get_epic_milestone "${row[Epic]:-}"
    if [[ -n "$EPIC_MILESTONE_TITLE" ]]; then
      gh issue edit "$issue_number" --repo "$GH_REPO" --milestone "$EPIC_MILESTONE_TITLE" >/dev/null 2>&1
      if [[ -n "${row[GitHub Milestone]+x}" ]]; then row["GitHub Milestone"]="$EPIC_MILESTONE_NUMBER"; changed=1; fi
    fi

    item_id="$(get_board_item_id "$issue_url" "$issue_number")"
    if [[ -n "$item_id" ]]; then
      set_board_field_value "$item_id" "$FIELD_ID_STATUS" SingleSelect "$board_status" Status
      set_board_field_value "$item_id" "$FIELD_ID_ESTIMATE" Number "${row[Estimate]:-}" Estimate
      set_board_field_value "$item_id" "$FIELD_ID_SIZE" SingleSelect "${row[Size]:-}" Size
      set_board_field_value "$item_id" "$FIELD_ID_ITERATION" Iteration "${row[Iteration]:-}" Iteration
      set_board_field_value "$item_id" "$FIELD_ID_STARTDATE" Date "${row[Start]:-}" "Start date"
      set_board_field_value "$item_id" "$FIELD_ID_TARGETDATE" Date "${row[Ziel]:-}" "Target date"
    fi

    if [[ "$changed" == "1" ]]; then
      new_line="|"
      for col in "${columns[@]}"; do new_line+=" ${row[$col]:-—} |"; done
      awk -v ln="$ln" -v repl="$new_line" 'NR==ln { print repl; next } { print }' "$tmp_file" > "$tmp_file.next" && mv "$tmp_file.next" "$tmp_file"
    fi
    log_info "$id → Issue #$issue_number, Board-Status: $board_status"
    unset row
  done

  if [[ "$changed" == "1" ]]; then
    mv "$tmp_file" "$debt_file"
  else
    rm -f "$tmp_file"
  fi
done

log_info "Sync-Modus '$MODE' abgeschlossen."
exit 0
