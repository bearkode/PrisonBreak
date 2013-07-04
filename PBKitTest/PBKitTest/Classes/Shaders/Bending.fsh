/*
 *  Bending.fsh
 *  PBKitTest
 *
 *  Created by camelkode on 13. 7. 4..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


precision mediump   float;
uniform   sampler2D uBaseTexture;
varying   vec2      vTexCoord;
uniform   float     uBendingTime;


const float kSpeed = 3.0;
const float kBendFactor = 0.2;


void main()
{
    float sHeight = 1.0 - vTexCoord.y;
    float sOffset = pow(sHeight, 2.5);
 
    sOffset *= (sin(uBendingTime * kSpeed) * kBendFactor);
 
    vec4 sColor = texture2D(uBaseTexture, fract(vec2(vTexCoord.x + sOffset, vTexCoord.y)));
    if (sColor.a < 0.5)
        discard;

    gl_FragColor = sColor;
}