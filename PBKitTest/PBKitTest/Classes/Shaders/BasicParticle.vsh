/*
 *  BasicParticle.vsh
 *  PBKitTest
 *
 *  Created by camelkode on 12. 12. 27..
 *  Copyright (c) 2012년 PrisonBreak. All rights reserved.
 *
 */


uniform   float aTotalTime;
attribute float aParticleTime;
attribute vec3  aStartPosition;
attribute vec3  aEndPosition;
varying   float vParticleSize;

float minmax(in float aValue, in float aMin, in float aMax)
{
    return clamp(aValue, aMin, aMax);
}

void main()
{
    gl_Position.xyz = aStartPosition + (aTotalTime * aEndPosition);
    gl_Position.w   = 1.0;
    vParticleSize   = 1.0 - (aTotalTime / aParticleTime);
    vParticleSize   = minmax(vParticleSize, 0.0, 1.0);
    gl_PointSize    = (vParticleSize * vParticleSize) * 100.0;
}
