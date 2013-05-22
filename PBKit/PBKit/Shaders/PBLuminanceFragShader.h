/*
 *  PBLuminanceFragShader.h
 *  PBKit
 *
 *  Created by camelkode on 13. 2. 28..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


static const GLbyte gLuminanceFragShaderSource[] =
"precision mediump   float;                                                     \n"
"uniform   sampler2D aTexture;                                                  \n"
"varying   vec2      vTexCoord;                                                 \n"
"varying   vec4      vColor;                                                    \n"

"vec4 luminanceColor(in vec4 aColor)                                            \n"
"{                                                                              \n"
"	float sLuminance = (aColor.r + aColor.g + aColor.b ) / 3.0;                 \n"
"    return aColor * sLuminance;                                                \n"
"}                                                                              \n"

"void main()                                                                    \n"
"{                                                                              \n"
"   vec4 sDstColor = luminanceColor(texture2D(aTexture, vTexCoord));            \n"
"   if (sDstColor.a < 0.5)                                                      \n"
"       discard;                                                                \n"
"   gl_FragColor   = sDstColor * vColor;                                        \n"
"}                                                                              \n";