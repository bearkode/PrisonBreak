/*
 *  PBVertShader.h
 *  PBKit
 *
 *  Created by camelkode on 13. 2. 18..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


static const GLbyte gVertShaderSource[] =

"uniform   mat4  aProjection;                                                   \n"
"attribute vec4  aPosition;                                                     \n"
"attribute vec2  aTexCoord;                                                     \n"
"varying   vec2  vTexCoord;                                                     \n"

"attribute vec4  aColor;                                                        \n"
"varying   vec4  vColor;                                                        \n"

"void main()                                                                    \n"
"{                                                                              \n"
"   gl_Position      = aProjection * aPosition;                                 \n"

"   vTexCoord        = aTexCoord;                                               \n"
"   vColor           = aColor;                                                  \n"
"}                                                                              \n";