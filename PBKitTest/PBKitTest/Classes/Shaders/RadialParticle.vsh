/*
 *  RadialParticle.vsh
 *  PBKitTest
 *
 *  Created by camelkode on 12. 12. 27..
 *  Copyright (c) 2012년 PrisonBreak. All rights reserved.
 *
 */


uniform   mat4  aProjection;
uniform   float aDurationTime;
uniform   float aZoomScale;
attribute float aPlayTime;
attribute vec4  aStartPosition;
attribute vec4  aEndPosition;
varying   float vParticleSize;

float minmax(in float aValue, in float aMin, in float aMax)
{
    return clamp(aValue, aMin, aMax);
}

void main()
{
    vec4 sStartPosition = aProjection * aStartPosition;
    vec4 sEndPosition   = aEndPosition * aDurationTime * aZoomScale;
    gl_Position         = sStartPosition + sEndPosition;
    gl_Position.w       = 1.0;
    vParticleSize       = 1.0 - (aDurationTime / aPlayTime);
    vParticleSize       = minmax(vParticleSize, 0.0, 1.0);
    gl_PointSize        = (vParticleSize * vParticleSize) * 100.0 * aZoomScale;
}