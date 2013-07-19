/*
 *  PBBlurFragShader.h
 *  PBKit
 *
 *  Created by camelkode on 13. 2. 28..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


static const GLbyte gBlurFragShaderSource[] =
"precision mediump   float;                                                     \n"
"uniform   sampler2D aTexture;                                                  \n"
"varying   vec2      vTexCoord;                                                 \n"
"varying   vec4      vColor;                                                    \n"

"vec4 blurEffect(in sampler2D aTexture,  in vec2 aTexCoord)                     \n"
"{                                                                              \n"
"	vec4  sBlur[9];                                                             \n"
"	float sOffset = 0.012;                                                      \n"
"	for (int i = 0; i < 9; i++)                                                 \n"
"	{                                                                           \n"
"		sBlur[i] = texture2D(aTexture, aTexCoord + sOffset);                    \n"
"		sOffset -= 0.003;                                                       \n"
"	}                                                                           \n"

"	vec4 sBlurColor =   (sBlur[0] + (2.0 * sBlur[1]) + sBlur[2] +               \n"
"                       (2.0 * sBlur[3]) + sBlur[4] + (2.0 * sBlur[5]) +        \n"
"                       sBlur[6] + (2.0 * sBlur[7]) + sBlur[8]) / 13.0;         \n"

"	return sBlurColor;                                                          \n"
"}                                                                              \n"

"void main()                                                                    \n"
"{                                                                              \n"
"   vec4 sDstColor = blurEffect(aTexture, vTexCoord);                           \n"
"   if (sDstColor.a < 0.05)                                                      \n"
"       discard;                                                                \n"
"   gl_FragColor   = sDstColor * vColor;                                        \n"
"}                                                                              \n";