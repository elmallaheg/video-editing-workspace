import React from 'react';
import {Composition} from 'remotion';
import {SmokeTest} from './SmokeTest';

export const RemotionRoot: React.FC = () => (
  <>
    {/* Environment check only — not a production video. */}
    <Composition id="SmokeTest" component={SmokeTest} durationInFrames={60} fps={30} width={1280} height={720} />
  </>
);
