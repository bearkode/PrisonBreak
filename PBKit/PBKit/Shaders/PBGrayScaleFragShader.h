/*
 *  PBGrayScaleFragShader.h
 *  PBKit
 *
 *  Created by camelkode on 13. 2. 28..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


static const GLbyte gGrayScaleFragShaderSource[] =
"precision mediump   float;                                                     \n"
"uniform   sampler2D aTexture;                                                  \n"
"varying   vec2      vTexCoord;                                                 \n"
"varying   vec4      vColor;                                                    \n"

"vec4 grayScaleColor(in vec4 aColor)                                            \n"
"{                                                                              \n"
"	float sGrayScale = max(aColor.r, max(aColor.g,aColor.b));                   \n"
"	return vec4(vec3(sGrayScale), aColor.a);                                    \n"
"}                                                                              \n"

"void main()                                                                    \n"
"{                                                                              \n"
"   vec4 sDstColor = grayScaleColor(texture2D(aTexture, vTexCoord));            \n"
"   gl_FragColor   = multiplyColor(aTexture, vTexCoord, sDstColor) * vColor;    \n"

"}                                                                              \n";