#!/usr/bin/env bash
#
# antislop installer
# Copies antislop.md + selected skills into a target location and writes the
# antislop pointer block into the agent's entry file (idempotent via markers).
# No dependencies beyond coreutils. POSIX-ish bash.
#
set -euo pipefail

# --- marker pair that makes the pointer block idempotent --------------------
POINTER_START='<!-- antislop:start -->'
POINTER_END='<!-- antislop:end -->'

# --- the pointer block written into entry files -----------------------------
POINTER_BLOCK="$(cat <<'BLOCK'
<!-- antislop:start -->
## antislop

For UI, copy, human-centered details, responsive layout, or code comments work, read `antislop.md` (core) and then the skill for the task:
- UI / visual: `skills/ui.md`
- Copy & text: `skills/copywriting.md`
- Human-centered / a11y: `skills/human.md`
- Responsive / mobile: `skills/responsive.md`
- Code comments: `skills/code-comments.md`

Before starting, ask the user when antislop applies: during the work, or after it is done.
<!-- antislop:end -->
BLOCK
)"

usage() {
  cat <<'USAGE'
antislop installer

Usage: install.sh [options]

Options:
  --help            Show this help
  --local           Install into the current directory (default)
  --global          Copy files into ~/.antislop and write the user-level entry file
  --agent <name>    claude-code|cursor|cline|windsurf|aider|codex|
                    opencode|continue|auto (default: auto if interactive, else error)
  --skills <list>   all | comma list of ui,copywriting,human,responsive,code-comments
                    (default: all)
  --dry-run         Print the actions without writing anything
  --yes             Skip interactive prompts and use defaults
USAGE
}

# --- argument parsing -------------------------------------------------------
MODE="local"
AGENT=""
SKILLS_ARG=""
DRY_RUN=0
YES=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --help|-h)  usage; exit 0 ;;
    --local)    MODE="local"; shift ;;
    --global)   MODE="global"; shift ;;
    --agent)    AGENT="${2:-}"; shift 2 ;;
    --skills)   SKILLS_ARG="${2:-}"; shift 2 ;;
    --dry-run)  DRY_RUN=1; shift ;;
    --yes|-y)   YES=1; shift ;;
    *)          echo "Unknown option: $1" >&2; usage >&2; exit 1 ;;
  esac
done

# --- locate the antislop source tree ---------------------------------------
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CORE_MD="$SOURCE_DIR/antislop.md"
SKILLS_DIR="$SOURCE_DIR/skills"

# --- skill helpers ----------------------------------------------------------
ALL_SKILLS=(ui copywriting human responsive code-comments)
skill_file() {  # map a skill name to its file name
  case "$1" in
    ui)            echo "ui.md" ;;
    copywriting)   echo "copywriting.md" ;;
    human)         echo "human.md" ;;
    responsive)    echo "responsive.md" ;;
    code-comments) echo "code-comments.md" ;;
    *)             echo "" ;;
  esac
}

# Resolve the list of selected skills.
declare -a SELECTED=()
if [[ -z "$SKILLS_ARG" ]]; then
  if [[ $YES -eq 0 && -t 0 ]]; then
    echo "Select skills to install (comma-separated numbers/names, or 'a' for all):"
    for i in "${!ALL_SKILLS[@]}"; do printf "  %d) %s\n" "$((i+1))" "${ALL_SKILLS[$i]}"; done
    printf "> "; read -r choice || choice=""
    if [[ "$choice" == "a" || -z "$choice" ]]; then
      SELECTED=("${ALL_SKILLS[@]}")
    else
      IFS=',' read -ra picks <<< "$choice"
      for p in "${picks[@]}"; do
        p="${p// /}"
        if [[ "$p" =~ ^[0-9]+$ ]] && (( p>=1 && p<=${#ALL_SKILLS[@]} )); then
          SELECTED+=("${ALL_SKILLS[$((p-1))]}")
        elif [[ -n "$(skill_file "$p")" ]]; then
          SELECTED+=("$p")
        else
          echo "Ignoring unknown skill: $p" >&2
        fi
      done
    fi
    [[ ${#SELECTED[@]} -eq 0 ]] && SELECTED=("${ALL_SKILLS[@]}")
  else
    SELECTED=("${ALL_SKILLS[@]}")
  fi
else
  if [[ "$SKILLS_ARG" == "all" ]]; then
    SELECTED=("${ALL_SKILLS[@]}")
  else
    IFS=',' read -ra picks <<< "$SKILLS_ARG"
    for p in "${picks[@]}"; do
      p="${p// /}"
      if [[ -n "$(skill_file "$p")" ]]; then SELECTED+=("$p"); else echo "Unknown skill: $p" >&2; fi
    done
  fi
fi
[[ ${#SELECTED[@]} -eq 0 ]] && { echo "No valid skills selected." >&2; exit 1; }

# --- agent selection --------------------------------------------------------
KNOWN=(claude-code cursor cline windsurf aider codex opencode continue)

detect_agents() {  # echo detected config names found in CWD
  local found=()
  [[ -d .claude ]]         && found+=(claude-code)
  [[ -d .cursor ]]         && found+=(cursor)
  [[ -f .clinerules ]]     && found+=(cline)
  [[ -f .windsurfrules ]]  && found+=(windsurf)
  [[ -f .aider.conf.yml ]] && found+=(aider)
  [[ -f AGENTS.md ]]       && found+=(codex)
  [[ -f opencode.json ]]   && found+=(opencode)
  [[ -f config.yaml ]]    && found+=(continue)
  echo "${found[@]:-}"
}

if [[ -z "$AGENT" || "$AGENT" == "auto" ]]; then
  detected="$(detect_agents)"
  if [[ -t 0 ]]; then
    if [[ -z "$detected" ]]; then
      echo "No agent config detected in $(pwd)."
      printf "Install a generic AGENTS.md pointer at the repo root? [Y/n] "; read -r ans || ans=""
      case "$ans" in n|N) echo "Aborted."; exit 0 ;; *) AGENT="codex" ;; esac
    else
      echo "Detected agent config(s): $detected"
      echo "Pick one to install for (number, or 'g' for generic AGENTS.md):"
      n=1; for a in $detected; do echo "  $n) $a"; n=$((n+1)); done
      echo "  g) generic AGENTS.md at repo root"
      printf "> "; read -r pick || pick=""
      if [[ "$pick" == "g" ]]; then AGENT="codex"
      elif [[ "$pick" =~ ^[0-9]+$ ]]; then AGENT="$(echo "$detected" | awk -v n="$pick" '{print $n}')"
      else AGENT="codex"; fi
    fi
  else
    echo "Error: --agent is required when running non-interactively." >&2
    echo "Pass --agent <claude-code|cursor|cline|windsurf|aider|codex|opencode|continue>." >&2
    exit 1
  fi
fi

# Validate the chosen agent.
valid=0
for k in "${KNOWN[@]}"; do [[ "$AGENT" == "$k" ]] && valid=1; done
[[ $valid -eq 1 ]] || { echo "Unknown agent: $AGENT" >&2; exit 1; }

# --- path helpers -----------------------------------------------------------
entry_for() {  # local entry file name for an agent
  case "$1" in
    claude-code) echo "CLAUDE.md" ;;
    cursor)      echo ".cursor/rules/antislop.mdc" ;;
    cline)       echo ".clinerules" ;;
    windsurf)    echo ".windsurfrules" ;;
    aider)       echo "CONVENTIONS.md" ;;
    codex)       echo "AGENTS.md" ;;
    opencode)    echo "opencode.json" ;;
    continue)    echo "config.yaml" ;;
    *)           echo "AGENTS.md" ;;
  esac
}
user_entry_for() {  # user-level entry file path for global installs
  case "$1" in
    claude-code) echo "$HOME/.claude/CLAUDE.md" ;;
    cursor)      echo "$HOME/.cursor/rules/antislop.mdc" ;;
    cline)       echo "$HOME/.clinerules" ;;
    windsurf)    echo "$HOME/.windsurfrules" ;;
    aider)       echo "$HOME/.aider.conf.yml" ;;
    codex)       echo "$HOME/AGENTS.md" ;;
    opencode)    echo "$HOME/.config/opencode/opencode.json" ;;
    continue)    echo "$HOME/.continue/config.yaml" ;;
    *)           echo "$HOME/AGENTS.md" ;;
  esac
}

# --- file writers -----------------------------------------------------------
write_pointer_md() {  # idempotently replace the antislop block in a md file
  local file="$1" tmp
  tmp="$(mktemp)"
  if [[ -f "$file" ]]; then
    awk -v s="$POINTER_START" -v e="$POINTER_END" '
      $0==s { skip=1; next }
      $0==e { skip=0; next }
      !skip { print }
    ' "$file" > "$tmp"
  fi
  { cat "$tmp"; echo ""; echo "$POINTER_BLOCK"; } > "$file"
  rm -f "$tmp"
}
write_continue() {  # (re)write a Continue config.yaml rules list
  local file="$1"
  { echo "# antislop: load the anti-slop filter every session"; echo "rules:"; echo "  - ./antislop.md"
    for s in "${SELECTED[@]}"; do echo "  - ./skills/$(skill_file "$s")"; done; } > "$file"
}
write_opencode() {  # (re)write an OpenCode opencode.json prompt
  local file="$1"
  { echo "{"; echo "  \"agents\": {"; echo "    \"default\": {"
    echo "      \"prompt\": \"Read antislop.md and the matching skills/ file before UI, copy, human, responsive, or code-comment work. Run the Delivery Gate before shipping.\""
    echo "    }"; echo "  }"; echo "}"; } > "$file"
}

# --- install for one agent --------------------------------------------------
install_agent() {
  local agent="$1" target entry conf
  if [[ "$MODE" == "global" ]]; then
    target="$HOME/.antislop"
    entry="$(user_entry_for "$agent")"
  else
    target="$(pwd)"
    entry="$target/$(entry_for "$agent")"
  fi

  echo "==> Installing antislop for '$agent' ($MODE)"
  echo "    files -> $target"
  echo "    entry -> $entry"
  [[ $DRY_RUN -eq 1 ]] && return 0

  mkdir -p "$target" "$target/skills"
  cp "$CORE_MD" "$target/antislop.md"
  for s in "${SELECTED[@]}"; do cp "$SKILLS_DIR/$(skill_file "$s")" "$target/skills/"; done
  mkdir -p "$(dirname "$entry")"

  case "$agent" in
    opencode) write_opencode "$entry" ;;
    continue) write_continue "$entry" ;;
    aider)
      write_pointer_md "$entry"
      if [[ "$MODE" == "global" ]]; then conf="$HOME/.aider.conf.yml"; else conf="$target/.aider.conf.yml"; fi
      { echo "read:"; echo "  - CONVENTIONS.md"; echo "  - antislop.md"; } > "$conf"
      echo "    aider conf -> $conf"
      ;;
    *) write_pointer_md "$entry" ;;
  esac
  echo "    done."
}

install_agent "$AGENT"
echo
echo "antislop is installed. Restart / refresh your agent session to load it."
