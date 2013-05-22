/*
 *  PBSepiaFragShader.h
 *  PBKit
 *
 *  Created by camelkode on 13. 2. 28..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


static const GLbyte gSepiaFragShaderSource[] =
"precision mediump   float;                                                     \n"
"uniform   sampler2D aTexture;                                                  \n"
"varying   vec2      vTexCoord;                                                 \n"
"varying   vec4      vColor;                                                    \n"

"vec4 sepiaColor(in vec4 aColor)                                                                    \n"
"{                                                                                                  \n"
"	vec4 sSepia = vec4(clamp(aColor.r * 0.393 + aColor.g * 0.769 + aColor.b * 0.189, 0.0, 1.0),     \n"
"                      clamp(aColor.r * 0.349 + aColor.g * 0.686 + aColor.b * 0.168, 0.0, 1.0),     \n"
"                      clamp(aColor.r * 0.272 + aColor.g * 0.534 + aColor.b * 0.131, 0.0, 1.0),     \n"
"                      aColor.a );                                                                  \n"
"    return sSepia;                                                                                 \n"
"}                                                                                                  \n"

"void main()                                                                    \n"
"{                                                                              \n"
"   vec4 sDstColor = sepiaColor(texture2D(aTexture, vTexCoord));                \n"
"   if (sDstColor.a < 0.5)                                                      \n"
"       discard;                                                                \n"
"   gl_FragColor   = sDstColor * vColor;                                        \n"
"}                                                                              \n";