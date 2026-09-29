# Video-editing workspace

AI video-editing workspace. Four project skills live in `.claude/skills/`
(see `.claude/skills/README.md` for sources, versions and local changes).

## Which skill to use

| Request | Skill |
|---|---|
| Remove silences / jump-cut a talking-head video | `video-edit` (`jump_cut_vad_singlepass.py`) |
| 3D swivel teaser or transition inserted into footage; drone montage | `pan-3d-transition` |
| Product promo / launch film from a website, frontend project or screenshots; Ink Press template; a named shot card | `video-shotcraft` |
| Any other motion graphics: logo sting, intro/outro, Reel/Short, captions, lower thirds, kinetic type | `remotion-motion-graphics` |

The skills can be combined: e.g. jump-cut with `video-edit`, then add captions
and a grade with `remotion-motion-graphics`. `remotion-motion-graphics`' motion
rules (no linear easing, stagger, verify rendered frames) apply to any Remotion
code written in this repo, including inside a `video-shotcraft` project.
Where the two conflict, shotcraft's shot-card demo source wins for that shot.

## Layout

- `.claude/skills/` — installed skills (vendored copies, not submodules)
- `studio/` — workspace Remotion project (Remotion 4.0.484, React 19) for
  `remotion-motion-graphics` work and adapting shotcraft demos. Put new
  compositions in `studio/src/`, assets in `studio/public/`.
- `scripts/setup-env.sh` — idempotent installer (FFmpeg, npm deps, optional VAD)
- `scripts/check-env.sh` — dependency report
- `.tmp/`, `out/` — scratch and renders (git-ignored)

## Environment rules (Claude Code on the web)

- The SessionStart hook runs `scripts/setup-env.sh` on every new cloud session,
  installing FFmpeg and npm deps and exporting `REMOTION_BROWSER_EXECUTABLE`.
- Remotion cannot download its own Chrome here (`remotion.media` is blocked).
  All three `remotion.config.ts` files read `REMOTION_BROWSER_EXECUTABLE`; if it
  is unset, pass `--browser-executable=/opt/pw-browsers/chromium_headless_shell-*/chrome-linux/headless_shell`.
- PyTorch + Silero VAD (~3 GB) are NOT installed by the hook. Before running
  `video-edit` silence removal, run `bash scripts/setup-env.sh --vad` (~3 min).
- No hardware encoder: video-edit / pan-3d fall back to `libx265` (CPU), which
  outputs H.265 `hvc1`. Expect roughly 40 fps at 720p.
- Nothing can be opened on `localhost` for the user: use rendered MP4s and
  `npx remotion still` frames instead of Remotion Studio or the shotcraft
  Motion Workbench, and send results to the user as files.
- Always verify renders by extracting and looking at frames before delivering.
