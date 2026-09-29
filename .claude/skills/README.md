# Installed skills

Vendored from upstream at the commits below (copied, not submodules, so they
work in fresh Claude Code on the web containers). Local changes are listed so
they can be re-applied when updating.

| Skill | Upstream | Commit | License |
|---|---|---|---|
| `remotion-motion-graphics` | [haidrrrry/claude-remotion-skill](https://github.com/haidrrrry/claude-remotion-skill) (`remotion-motion-graphics/`) | `1dcbe5e` | MIT |
| `video-shotcraft` | [Vincentwei1021/video-shotcraft](https://github.com/Vincentwei1021/video-shotcraft) (whole repo) | `5ddbf52` | see `video-shotcraft/LICENSE` |
| `video-edit` | [jordantobyll/video-editing-skills](https://github.com/jordantobyll/video-editing-skills) (`.claude/skills/video-edit`) | `4556bdf` | none stated |
| `pan-3d-transition` | same repo (`.claude/skills/pan-3d-transition`) | `4556bdf` | none stated |

## Local changes

**remotion-motion-graphics**
- Added `scripts/gen-sfx.mjs`, `scripts/gen-track.mjs` from upstream `examples/scripts/`
  (SKILL.md referenced them but they were outside the skill folder); they now write
  to `./public/sfx` of the current directory instead of next to the script.
- Description: appended routing hints so it doesn't swallow requests meant for the
  other three skills (it says "use EVERY time the user wants to … edit a video").
- Not copied: `examples/` (30 MB of demo MP4/GIF) and the `.skill` bundle.

**video-shotcraft**
- `template/remotion.config.ts`: honours `REMOTION_BROWSER_EXECUTABLE`.
- Not installed: `workbench/` npm deps (it is a localhost:5198 web app that can't be
  opened from Claude Code on the web). Gallery MP4s aren't in git upstream; use the
  online gallery instead.

**pan-3d-transition**
- `scripts/video_effects/remotion.config.ts`: honours `REMOTION_BROWSER_EXECUTABLE`.

**video-edit**
- `scripts/insert_3d_transition.py`: replaced upstream's stale duplicate with a shim
  that runs `pan-3d-transition/scripts/insert_3d_transition.py`. The duplicate looked
  for a `video_effects/` folder that doesn't exist under video-edit, and it omitted the
  width/height props.
- `scripts/jump_cut_vad_singlepass.py`: loads Silero from the `silero-vad` PyPI package
  (bundled weights) instead of `torch.hub` (GitHub archive downloads are blocked here),
  and reads the extracted WAV with the stdlib `wave` module, because torchaudio ≥ 2.9
  needs `torchcodec`. Falls back to `torch.hub` if `silero-vad` isn't installed.
- `scripts/requirements.txt`: added `silero-vad`, `numpy`, `anthropic` (imported by
  `simple_video_edit.py` but missing upstream).

## Conflicts resolved

- **Duplicate script** — `insert_3d_transition.py` existed in both video-edit and
  pan-3d-transition with diverging code; the pan-3d copy is canonical.
- **Remotion / React versions** — shotcraft pins Remotion 4.0.484 + React 19;
  pan-3d-transition uses 4.0.481 + React 18. Each keeps its own `node_modules`
  (Remotion requires all `@remotion/*` packages in one project to match), and the
  workspace `studio/` project follows shotcraft's pins.
- **Trigger overlap** — routing table in the root `CLAUDE.md` + description hint.
- **macOS assumptions** — `hevc_videotoolbox` is auto-detected; on Linux the scripts
  use `libx265`, which the apt FFmpeg build includes.
