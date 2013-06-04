/*
 *  Shockwave.fsh
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

uniform vec2      uShockwavePoint;
uniform float     uShockwaveTime;
uniform vec3      uShockwaveParam;

void main()
{
    vec2  sShockwavePoint = vec2((uShockwavePoint.x / uResolution.x) + 0.5, 1.0 - ((uShockwavePoint.y / uResolution.y) + 0.5));
    vec2  sShockwaveCoord = vTexCoord;
    float sDistance       = distance(sShockwaveCoord, sShockwavePoint);
    
    if ((sDistance <= (uShockwaveTime + uShockwaveParam.z)) && (sDistance >= (uShockwaveTime - uShockwaveParam.z)))
    {
        float sDiff     = (sDistance - uShockwaveTime);
        float sPowDiff  = 1.0 - pow(abs(sDiff * uShockwaveParam.x), uShockwaveParam.y);
        float sDiffTime = sDiff  * sPowDiff;
        vec2  sDiffUV   = normalize(sShockwaveCoord - sShockwavePoint);
        sShockwaveCoord = sShockwaveCoord + (sDiffUV * sDiffTime);
    }
    
    vec2 sFlipCoord = vec2(sShockwaveCoord.s, 1.0 - sShockwaveCoord.t);
    gl_FragColor    = texture2D(uBaseTexture, sFlipCoord);
}
