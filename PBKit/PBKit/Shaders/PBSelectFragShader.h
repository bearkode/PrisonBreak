/*
 *  PBSelectFragShader.h
 *  PBKit
 *
 *  Created by camelkode on 13. 2. 18..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


static const GLbyte gSelectFragShaderSource[] =
"precision mediump   float;                                                     \n"
"uniform   sampler2D aTexture;                                                  \n"
"varying   vec2      vTexCoord;                                                 \n"
"varying   vec4      vColor;                                                    \n"


"void main()                                                                    \n"
"{                                                                              \n"
"   vec4 sDstColor = texture2D(aTexture, vTexCoord);                            \n"
"   float sAlpha   = sDstColor.a;                                               \n"
"   gl_FragColor   = vec4(vec3(vColor), sAlpha);                                \n"
"}                                                                              \n";