/*
 *  PBTextureShader.h
 *
 *  Created by camelkode on 12. 12. 27..
 *  Copyright (c) 2012년 PrisonBreak. All rights reserved.
 *
 */


static const GLbyte gTextureVShaderSource[] =
"uniform   mat4  aProjection;                                        \n"
"attribute vec4  aPosition;                                          \n"
"attribute vec2  aTexCoord;                                          \n"
"attribute vec3  aSelectionColor;                                    \n"
"attribute float aSelectMode;                                       \n"
// varying
"varying   vec2 vTexCoord;                                          \n"
"varying   vec3 vSelectionColor;                                    \n"
"varying   float vSelectMode;                                       \n"
"void main()                                                        \n"
"{                                                                  \n"
"    gl_Position     = aProjection * aPosition;                     \n"
"    vTexCoord       = aTexCoord;                                   \n"
"    vSelectionColor = aSelectionColor;                             \n"
"    vSelectMode     = aSelectMode;                                 \n"
"}                                                                  \n";

static const GLbyte gTextureFShaderSource[] =
"precision mediump   float;                                         \n"
"uniform   sampler2D aTexture;                                      \n"
"varying   vec2      vTexCoord;                                     \n"
"varying   vec3      vSelectionColor;                               \n"
"varying   float     vSelectMode;                                   \n"
"void main()                                                        \n"
"{                                                                  \n"
"   vec4 sDstColor = texture2D(aTexture, vTexCoord);                \n"
"   if (vSelectMode > 0.0)                                          \n"
"   {                                                               \n"
"       float sAlpha = sDstColor.a;                                 \n"
"       sDstColor    = vec4(vec3(vSelectionColor), sAlpha);         \n"
"   }                                                               \n"
"   gl_FragColor = sDstColor;                                       \n"
"}                                                                  \n";