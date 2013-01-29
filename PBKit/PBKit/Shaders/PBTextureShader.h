/*
 *  PBTextureShader.h
 *
 *  Created by sshanks on 12. 12. 27..
 *  Copyright (c) 2012년 sshanks. All rights reserved.
 *
 */


static const GLbyte gTextureVShaderSource[] =
"attribute   vec4 aPosition;                            \n"
"attribute   vec2 aTexCoord;                            \n"
"uniform     mat4 aTransform;                           \n"
"varying     vec2 v_texCoord;                           \n"
"void main()                                            \n"
"{                                                      \n"
"    gl_Position = aTransform * aPosition;              \n"
"    v_texCoord  = aTexCoord;                           \n"
"}                                                      \n";

static const GLbyte gTextureFShaderSource[] =
"precision mediump float;                               \n"
"uniform sampler2D aTexture;                            \n"
"varying vec2      v_texCoord;                          \n"
"void main()                                            \n"
"{                                                      \n"
"    gl_FragColor    = texture2D(aTexture, v_texCoord); \n"
"    gl_FragColor.a *= 1.0;                             \n"
"}                                                      \n";

