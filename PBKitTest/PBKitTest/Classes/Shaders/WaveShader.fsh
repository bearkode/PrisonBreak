/*
 *  WaveShader.fsh
 *  PBKitTest
 *
 *  Created by camelkode on 13. 5. 28..
 *  Copyright (c) 2012년 PrisonBreak. All rights reserved.
 *
 */


precision mediump float;
uniform sampler2D uBaseTexture;
varying vec2      vTexCoord;

uniform vec2      uResolution;
uniform vec2      uWavePoint;
uniform float     uWaveTime;
uniform float     uWaveDirection;
uniform float     uWavePower;
uniform float     uWaveWidth;


void main()
{
    vec2 sWaveOffset = vec2(uWavePoint.x / (uResolution.x / 2.0), uWavePoint.y / (uResolution.y / 2.0));
    sWaveOffset.x    = (sWaveOffset.x * 0.5) * -1.0;
    sWaveOffset.y    = sWaveOffset.y * 0.5;
    
    vec2 sTexCoord   = sWaveOffset + vTexCoord;
    vec2 sPosition   = -1.0 + 2.0 * sTexCoord;
    float sLength    = length(sPosition);
    
    vec2 sWaveCoord  = vTexCoord + (sPosition / sLength) * cos(sLength * uWaveDirection -uWaveTime * uWavePower) * uWaveWidth;
    
    // flip up-down
    vec2 sFlipCoord  = vec2(sWaveCoord.s, 1.0 - sWaveCoord.t);
    vec3 sColor      = texture2D(uBaseTexture, sFlipCoord).xyz;
    
    gl_FragColor     = vec4(sColor,1.0);
}