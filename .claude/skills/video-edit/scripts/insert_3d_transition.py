#!/usr/bin/env python3
"""
Workspace shim: delegates to the pan-3d-transition skill's script.

Upstream shipped a stale duplicate of insert_3d_transition.py here. It looked for
a `video_effects/` Remotion project next to itself (which only exists under
pan-3d-transition/scripts/) and omitted the width/height props the Pan3D
composition needs. Keeping a single source of truth avoids that drift.
"""
import runpy
import sys
from pathlib import Path

TARGET = (Path(__file__).resolve().parents[2]
          / "pan-3d-transition" / "scripts" / "insert_3d_transition.py")

if not TARGET.exists():
    sys.exit(f"pan-3d-transition skill not found at {TARGET}")

sys.argv[0] = str(TARGET)
runpy.run_path(str(TARGET), run_name="__main__")
