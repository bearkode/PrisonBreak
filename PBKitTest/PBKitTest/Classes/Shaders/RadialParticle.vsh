/*
 *  RadialParticle.vsh
 *  PBKitTest
 *
 *  Created by camelkode on 12. 12. 27..
 *  Copyright (c) 2012년 PrisonBreak. All rights reserved.
 *
 */


uniform   mat4  aProjection;
uniform   float aZoomScale;
uniform   float aDurationLifeSpan;
attribute float aLifeSpan;
attribute vec4  aStartPosition;
attribute vec4  aEndPosition;
varying   float vFinishColor;

void main()
{
    vec4  sStartPosition = aProjection * aStartPosition;
    vec4  sEndPosition   = aEndPosition * aDurationLifeSpan * aZoomScale;
    float sParticleSize  = 1.0 - (aDurationLifeSpan / aLifeSpan);
    sParticleSize        = clamp(sParticleSize, 0.0, 1.0);
    vFinishColor         = sEndPosition.y;
    
    gl_Position   = (sStartPosition + sEndPosition);
    gl_Position.w = 1.0;
    gl_PointSize  = (sParticleSize * sParticleSize) * 50.0 * aZoomScale;
}