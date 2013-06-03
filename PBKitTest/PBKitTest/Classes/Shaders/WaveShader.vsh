/*
 *  WaveShader.vsh
 *  PBKitTest
 *
 *  Created by camelkode on 13. 5. 28..
 *  Copyright (c) 2012년 PrisonBreak. All rights reserved.
 *
 */


uniform   mat4  aProjection;
attribute vec4  aPosition;
varying   vec2  vTexCoord;
attribute vec2  aTexCoord;

uniform   float aWaveTime;
uniform   float aWaveWidth;
uniform   float aWaveHeight;

void main(void)
{
    vTexCoord   = aTexCoord;
	gl_Position = aProjection * aPosition;
}