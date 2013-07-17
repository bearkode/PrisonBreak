/*
 *  Glowline.fsh
 *  PBKitTest
 *
 *  Created by camelkode on 13. 7. 4..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


precision highp float;


varying vec2  vCoordinate;
uniform float uAlpha;
uniform vec3  uColor;

void main(void)
{
    vec2 uv = -1.0 + 2.0 * vCoordinate;
    
    vec3  sBaseColor = uColor;
    float sIntensity = abs(0.1 / uv.y) * clamp(0.0, 0.35, 1.0);
    vec3  sGlowColor = vec3(sIntensity * sBaseColor.r, sIntensity * sBaseColor.g, sIntensity * sBaseColor.b) * 3.0;
//    vec4  sColor     = vec4(sGlowColor, 1.0) * uAlpha;
    vec4  sColor     = vec4(sGlowColor, sIntensity) * uAlpha;

    gl_FragColor = sColor;
}


