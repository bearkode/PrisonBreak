/*
 *  PBTextureShader.h
 *  PBKit
 *
 *  Created by camelkode on 12. 12. 27..
 *  Copyright (c) 2012년 PrisonBreak. All rights reserved.
 *
 */


static const GLbyte gTextureVShaderSource[] =
"uniform   mat4  aProjection;                                       \n"
"attribute vec4  aPosition;                                         \n"
"attribute vec2  aTexCoord;                                         \n"
"varying   vec2 vTexCoord;                                          \n"
"void main()                                                        \n"
"{                                                                  \n"
"    gl_Position     = aProjection * aPosition;                     \n"
"    vTexCoord       = aTexCoord;                                   \n"
"}                                                                  \n";

static const GLbyte gTextureFShaderSource[] =
"precision mediump   float;                                         \n"
"uniform   sampler2D aTexture;                                      \n"
"varying   vec2      vTexCoord;                                     \n"
"void main()                                                        \n"
"{                                                                  \n"
"   vec4 sDstColor = texture2D(aTexture, vTexCoord);                \n"
"   gl_FragColor = sDstColor;                                       \n"
"}                                                                  \n";