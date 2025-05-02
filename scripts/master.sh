#!/usr/bin/env bash
# master.sh — The ultimate Swiss-Army Knife script

set -euo pipefail
IFS=$'\n\t'

# ─────── Globals ─────────────────────────────────────────────────────
readonly REPO="https://github.com/canstralian/nl2bash-purple.git"
readonly SCRIPT_NAME="$(basename "$0")"
LOGFILE="/var/log/${SCRIPT_NAME%.sh}.log"
TMPDIR="$(mktemp -d /tmp/${SCRIPT_NAME%.sh}.XXXXXX)"
DRY_RUN=false
VERBOSE=false

# ─────── Source Helpers ───────────────────────────────────────────────
source "$(dirname "$0")/lib/distro-utils.sh"

# ─────── Usage & Arg Parsing ─────────────────────────────────────────
usage() {
  cat <<-EOF
Usage: $SCRIPT_NAME [options] -- [script args]
Options:
  -v, --verbose      Print each command (set -x)
  -d, --dry-run      Show what would run, but don’t execute
  -u, --self-update  Pull & restart latest version
  -h, --help         Show this help
EOF
  exit ${1:-0}
}

parse_args() {
  while [[ $# -gt 0 ]]; do
    case $1 in
      -v|--verbose) VERBOSE=true; shift ;;
      -d|--dry-run) DRY_RUN=true; shift ;;
      -u|--self-update)
        log_info "Self-updating…"
        git -C "$(dirname "$0")" pull --ff-only || log_fatal "Update failed"
        exec "$0" "$@"
        ;;
      -h|--help) usage ;;
      --) shift; break ;;
      *) log_error "Unknown option: $1"; usage 1 ;;
    esac
  done
}

# ─────── Logging Setup ────────────────────────────────────────────────
log() { echo "[$(date +'%F %T')] $*"; }
log_info()  { log "[INFO] $*";  }
log_warn()  { log "[WARN] $*";  }
log_error() { log "[ERROR] $*"; }
log_fatal() { log_error "$*"; cleanup; exit 1; }
[[ "$VERBOSE" == true ]] && set -x

# ─────── Cleanup & Traps ─────────────────────────────────────────────
cleanup() {
  log_info "Cleaning up…"
  rm -rf "$TMPDIR"
}
trap cleanup EXIT
trap 'log_error "Interrupted"; exit 1' INT

# ─────── Main ────────────────────────────────────────────────────────
main() {
  parse_args "$@"
  check_and_install_deps curl jq python3 git
  log_info "Launching translation…"
  if [[ "$DRY_RUN" == true ]]; then
    log_info "[DRY RUN] python3 -m encoder_decoder.translate \"\$@\""
  else
    python3 -m encoder_decoder.translate "$@"
  fi
  log_info "Completed successfully."
}

main "$@"