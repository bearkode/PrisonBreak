/*
 *  PBGrayscaleFragShader.h
 *  PBKit
 *
 *  Created by camelkode on 13. 2. 28..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


static const GLbyte gGrayscaleFragShaderSource[] =
"precision mediump   float;                                                     \n"
"uniform   sampler2D aTexture;                                                  \n"
"varying   vec2      vTexCoord;                                                 \n"
"varying   vec4      vColor;                                                    \n"

"vec4 grayscaleColor(in vec4 aColor)                                            \n"
"{                                                                              \n"
"	float sGrayscale = max(aColor.r, max(aColor.g,aColor.b));                   \n"
"	return vec4(vec3(sGrayscale), aColor.a);                                    \n"
"}                                                                              \n"

"void main()                                                                    \n"
"{                                                                              \n"
"   vec4 sDstColor = grayscaleColor(texture2D(aTexture, vTexCoord));            \n"
"   if (sDstColor.a < 0.05)                                                     \n"
"       discard;                                                                \n"
"   gl_FragColor   = sDstColor * vColor;                                        \n"
"}                                                                              \n";