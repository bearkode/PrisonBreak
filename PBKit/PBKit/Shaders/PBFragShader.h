/*
 *  PBFragShader.h
 *  PBKit
 *
 *  Created by camelkode on 13. 2. 18..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


static const GLbyte gFragShaderSource[] =
"precision mediump   float;                                                     \n"
"uniform   sampler2D aTexture;                                                  \n"
"varying   vec2      vTexCoord;                                                 \n"
"varying   vec4      vColor;                                                    \n"


"void main()                                                                    \n"
"{                                                                              \n"
"   gl_FragColor = texture2D(aTexture, vTexCoord) * vColor;                     \n"

"}                                                                              \n";