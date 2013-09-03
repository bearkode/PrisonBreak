/*
 *  PBColorFragShader.h
 *  PBKit
 *
 *  Created by camelkode on 13. 8. 29..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


static const GLbyte gColorFragShaderSource[] =
"precision mediump   float;                                                     \n"
"varying   vec2      vTexCoord;                                                 \n"
"varying   vec4      vColor;                                                    \n"


"void main()                                                                    \n"
"{                                                                              \n"
"   gl_FragColor = vColor;                                                      \n"
"}                                                                              \n";