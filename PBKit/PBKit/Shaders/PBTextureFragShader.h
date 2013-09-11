/*
 *  PBTextureFragShader.h
 *  PBKit
 *
 *  Created by camelkode on 13. 2. 18..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


static const GLbyte gTextureFragShaderSource[] =
"precision mediump   float;                                                     \n"
"uniform   sampler2D aTexture;                                                  \n"
"varying   vec2      vTexCoord;                                                 \n"
"varying   vec4      vColor;                                                    \n"


"void main()                                                                    \n"
"{                                                                              \n"
"   vec4 sColor = texture2D(aTexture, vTexCoord);                               \n"
//"   if (sColor.a < 0.05)                                                         \n"
//"       discard;                                                                \n"
"   gl_FragColor = sColor * vColor;                                             \n"
"}                                                                              \n";