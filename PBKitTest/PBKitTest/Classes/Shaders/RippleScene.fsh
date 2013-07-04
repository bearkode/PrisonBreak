/*
 *  RippleScene.fsh
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

uniform vec2      uRipplePoint;
uniform float     uRippleTime;
uniform float     uRippleDirection;
uniform float     uRipplePower;
uniform float     uRippleWidth;


void main()
{
    vec2 sRippleOffset = vec2(uRipplePoint.x / (uResolution.x / 2.0), uRipplePoint.y / (uResolution.y / 2.0));
    sRippleOffset.x    = (sRippleOffset.x * 0.5) * -1.0;
    sRippleOffset.y    = sRippleOffset.y * 0.5;
    
    vec2 sTexCoord     = sRippleOffset + vTexCoord;
    vec2 sPosition     = -1.0 + 2.0 * sTexCoord;
    float sLength      = length(sPosition);
    
    vec2 sRippleCoord  = vTexCoord + (sPosition / sLength) * cos(sLength * uRippleDirection -uRippleTime * uRipplePower) * uRippleWidth;
    
    // flip up-down
    vec2 sFlipCoord    = vec2(sRippleCoord.s, 1.0 - sRippleCoord.t);
    vec3 sColor        = texture2D(uBaseTexture, sFlipCoord).xyz;
    
    gl_FragColor       = vec4(sColor,1.0);
}