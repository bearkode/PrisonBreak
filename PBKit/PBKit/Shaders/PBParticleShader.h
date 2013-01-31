/*
 *  PBParticleShader.h
 *
 *  Created by camelkode on 12. 12. 27..
 *  Copyright (c) 2012년 PrisonBreak. All rights reserved.
 *
 */


static const GLbyte gParticleVShaderSource[] =
"uniform   float aTotalTime;                                            \n"
"attribute float aParticleTime;                                         \n"
"attribute vec3  aStartPosition;                                        \n"
"attribute vec3  aEndPosition;                                          \n"
"varying   float vParticleSize;                                         \n"
"float minmax(in float aValue, in float aMin, in float aMax)            \n"
"{                                                                      \n"
"    return clamp(aValue, aMin, aMax);                                  \n"
"}                                                                      \n"
"void main()                                                            \n"
"{                                                                      \n"
"    gl_Position.xyz = aStartPosition + (aTotalTime * aEndPosition);    \n"
"    gl_Position.w   = 1.0;                                             \n"
"    vParticleSize   = 1.0 - (aTotalTime / aParticleTime);              \n"
"    vParticleSize   = minmax(vParticleSize, 0.0, 1.0);                 \n"
"    gl_PointSize    = (vParticleSize * vParticleSize) * 100.0;         \n"
"}                                                                      \n";

static const GLbyte gParticleFShaderSource[] =
"precision mediump float;           \n"
"uniform sampler2D aTexture;        \n"
"varying float     vParticleSize;   \n"
"void main()                        \n"
"{                                  \n"
"   gl_FragColor         = vec4(1.0, 1.0, 1.0, 1.0) * texture2D(aTexture, gl_PointCoord);   \n"
"   float sParticleAlpha = vParticleSize;                                                   \n"
"   gl_FragColor.a      *= sParticleAlpha;                                                  \n"
"}                                                                                          \n";
