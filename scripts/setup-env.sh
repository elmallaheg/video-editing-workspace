#!/usr/bin/env bash
# Idempotent environment setup for the video-editing workspace.
# Runs automatically on session start in Claude Code on the web (see
# .claude/settings.json), and can be run by hand on a local machine.
#
#   bash scripts/setup-env.sh          # system tools + npm deps (fast path)
#   bash scripts/setup-env.sh --vad    # also install PyTorch + Silero VAD (~1-3 GB)
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SKILLS="$ROOT/.claude/skills"
WANT_VAD=0
[[ "${1:-}" == "--vad" || "${VIDEO_WORKSPACE_VAD:-0}" == "1" ]] && WANT_VAD=1

log() { echo "[setup-env] $*" >&2; }

# 1. FFmpeg (system package; needs libx264 + libx265)
if ! command -v ffmpeg >/dev/null 2>&1; then
  if command -v apt-get >/dev/null 2>&1; then
    log "installing ffmpeg via apt"
    SUDO=""; [[ $EUID -ne 0 ]] && SUDO="sudo"
    $SUDO apt-get install -y -qq ffmpeg >/dev/null 2>&1 \
      || { $SUDO apt-get update -qq >/dev/null 2>&1; $SUDO apt-get install -y -qq ffmpeg >/dev/null; }
  elif command -v brew >/dev/null 2>&1; then
    brew install ffmpeg
  else
    log "WARNING: ffmpeg missing and no apt/brew; install it manually"
  fi
fi

# 2. npm dependencies for each Remotion project (skip when already installed)
npm_install() {
  local dir="$1"
  [[ -f "$dir/package.json" ]] || return 0
  if [[ ! -d "$dir/node_modules" ]]; then
    log "npm install in ${dir#$ROOT/}"
    if [[ -f "$dir/package-lock.json" ]]; then
      (cd "$dir" && npm ci --no-audit --no-fund --loglevel=error)
    else
      (cd "$dir" && npm install --no-audit --no-fund --loglevel=error)
    fi
  fi
}
npm_install "$ROOT/studio"
npm_install "$SKILLS/pan-3d-transition/scripts/video_effects"
npm_install "$SKILLS/video-shotcraft/template"
npm_install "$SKILLS/video-shotcraft"          # vitest for shotcraft helper tests

# 3. Python: light deps always, PyTorch/Silero only on request (large download)
python3 -m pip install -q --disable-pip-version-check requests python-dotenv anthropic >/dev/null 2>&1 || true
if [[ $WANT_VAD == 1 ]] && ! python3 -c "import silero_vad" >/dev/null 2>&1; then
  log "installing torch + silero-vad (large download)"
  python3 -m pip install -q --disable-pip-version-check -r "$SKILLS/video-edit/scripts/requirements.txt"
fi

# 4. Chromium for Remotion: its own download host (remotion.media) is blocked in
#    Claude Code on the web, so point it at the pre-installed Playwright shell.
HS="$(ls /opt/pw-browsers/chromium_headless_shell-*/chrome-linux/headless_shell 2>/dev/null | head -1 || true)"
if [[ -n "$HS" ]]; then
  if [[ -n "${CLAUDE_ENV_FILE:-}" ]]; then
    echo "export REMOTION_BROWSER_EXECUTABLE=$HS" >> "$CLAUDE_ENV_FILE"
  fi
  log "REMOTION_BROWSER_EXECUTABLE=$HS"
fi
log "done"
