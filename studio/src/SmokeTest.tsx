import React from 'react';
import {AbsoluteFill, spring, useCurrentFrame, useVideoConfig} from 'remotion';
import {theme} from './theme';

// Minimal composition that proves bundling, Chromium and the encoder work.
export const SmokeTest: React.FC = () => {
  const frame = useCurrentFrame();
  const {fps} = useVideoConfig();
  const s = spring({frame, fps, config: theme.spring.snappy});
  return (
    <AbsoluteFill style={{background: theme.colors.bg, alignItems: 'center', justifyContent: 'center'}}>
      <div
        style={{
          color: theme.colors.text,
          fontSize: 72,
          fontFamily: 'sans-serif',
          opacity: s,
          transform: `translateY(${(1 - s) * 40}px) scale(${0.9 + 0.1 * s})`,
        }}
      >
        Remotion OK
      </div>
    </AbsoluteFill>
  );
};
