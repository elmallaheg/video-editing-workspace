import {Config} from '@remotion/cli/config';

Config.setVideoImageFormat('jpeg');
Config.setOverwriteOutput(true);
// The Python script extracts frames into public/frames at render time.
Config.setPublicDir('public');
// Workspace addition: use a pre-installed Chromium when Remotion's own
// download host is unreachable (e.g. Claude Code on the web). No-op otherwise.
if (process.env.REMOTION_BROWSER_EXECUTABLE) {
  Config.setBrowserExecutable(process.env.REMOTION_BROWSER_EXECUTABLE);
}
