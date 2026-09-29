#!/usr/bin/env bash
# Print a dependency report for the video-editing workspace.
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ok() { printf "  %-28s %s\n" "$1" "$2"; }
echo "System tools"
ok node "$(node --version 2>/dev/null || echo MISSING)"
ok npm "$(npm --version 2>/dev/null || echo MISSING)"
ok python3 "$(python3 --version 2>/dev/null || echo MISSING)"
ok ffmpeg "$(ffmpeg -version 2>/dev/null | head -1 | cut -d' ' -f3 || echo MISSING)"
ok "ffmpeg libx264/libx265" "$(ffmpeg -hide_banner -encoders 2>/dev/null | grep -oE 'libx26[45] ' | tr -d ' ' | sort -u | paste -sd, || echo -)"
ok "remotion browser" "${REMOTION_BROWSER_EXECUTABLE:-$(ls /opt/pw-browsers/chromium_headless_shell-*/chrome-linux/headless_shell 2>/dev/null | head -1 || echo 'auto-download')}"
echo "Python packages"
for m in torch silero_vad anthropic dotenv requests; do
  ok "$m" "$(python3 -c "import $m; print(getattr($m,'__version__','ok'))" 2>/dev/null || echo MISSING)"
done
echo "Remotion projects"
for d in studio .claude/skills/pan-3d-transition/scripts/video_effects .claude/skills/video-shotcraft/template; do
  v=$(node -p "require('$ROOT/$d/node_modules/remotion/package.json').version" 2>/dev/null || echo "not installed")
  ok "$d" "remotion $v"
done
