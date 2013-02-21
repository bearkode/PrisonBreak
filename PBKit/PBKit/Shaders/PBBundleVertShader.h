/*
 *  PBBundleVertShader.h
 *  PBKit
 *
 *  Created by camelkode on 13. 2. 18..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


static const GLbyte gBundleVShaderSource[] =

"#define M_PI 3.14159                                                           \n"
"#define PBDegreesToRadians(aDegrees) ((aDegrees) * M_PI / 180.0)               \n"

"uniform   mat4  aProjection;                                                   \n"
"attribute vec4  aPosition;                                                     \n"
"attribute vec2  aTexCoord;                                                     \n"
"varying   vec2  vTexCoord;                                                     \n"

"attribute vec4  aColor;                                                        \n"
"varying   vec4  vColor;                                                        \n"

"attribute float aSelectMode;                                                   \n"
"varying   float vSelectMode;                                                   \n"

"attribute vec4  aSelectionColor;                                               \n"
"varying   vec4  vSelectionColor;                                               \n"

"attribute float aGrayScaleFilter;                                              \n"
"varying   float vGrayScaleFilter;                                              \n"

"attribute float aSepiaFilter;                                                  \n"
"varying   float vSepiaFilter;                                                  \n"

"attribute float aBlurFilter;                                                   \n"
"varying   float vBlurFilter;                                                   \n"

"attribute float aLuminanceFilter;                                              \n"
"varying   float vLuminanceFilter;                                              \n"

"attribute float aFogFilter;                                                    \n"
"varying   float vFogFilter;                                                    \n"

"attribute float aScale;                                                        \n"
"attribute vec3  aAngle;                                                        \n"
"attribute vec3  aTranslate;                                                    \n"

"const mat4 uIdentityProjection = mat4(1.0, 0.0, 0.0, 0.0,                      \n"
"                                      0.0, 1.0, 0.0, 0.0,                      \n"
"                                      0.0, 0.0, 1.0, 0.0,                      \n"
"                                      0.0, 0.0, 0.0, 1.0);                     \n"

"mat4 multiplyMatrix(in mat4 aSrc1, in mat4 aSrc2)                              \n"
"{                                                                              \n"
"	return aSrc1 * aSrc2;                                                       \n"
"}                                                                              \n"


"mat4 translateMatrix(in mat4 aSrc, in vec3 aTranslate)                                                 \n"
"{                                                                                                      \n"
"	mat4 sDst = aSrc;                                                                                   \n"
"	sDst[3][0] += (sDst[0][0] * aTranslate.x + sDst[1][0] * aTranslate.y + sDst[2][0] * aTranslate.z);  \n"
"	sDst[3][1] += (sDst[0][1] * aTranslate.x + sDst[1][1] * aTranslate.y + sDst[2][1] * aTranslate.z);  \n"
"	sDst[3][2] += (sDst[0][2] * aTranslate.x + sDst[1][2] * aTranslate.y + sDst[2][2] * aTranslate.z);  \n"
"	sDst[3][3] += (sDst[0][3] * aTranslate.x + sDst[1][3] * aTranslate.y + sDst[2][3] * aTranslate.z);  \n"
"	return sDst;                                                                                        \n"
"}                                                                                                      \n"

"mat4 rotationMatrix(inout mat4 aSrc, in vec3 aAngle)                           \n"
"{                                                                              \n"
"	mat4  sDst    = uIdentityProjection;                                        \n"
"	float sRadian = 0.0;                                                        \n"
"   float sSin    = 0.0;                                                        \n"
"   float sCos    = 0.0;                                                        \n"
"	bool  sDirty  = false;                                                      \n"

"	if (bool(aAngle.x) == true)                                                 \n"
"	{                                                                           \n"
"		sRadian = PBDegreesToRadians(aAngle.x);                                 \n"
"       sSin = sin(sRadian);                                                    \n"
"       sCos = cos(sRadian);                                                    \n"
"       sDst[1][1] = sCos;                                                      \n"
"       sDst[1][2] = -sSin;                                                     \n"
"       sDst[2][1] = sSin;                                                      \n"
"       sDst[2][2] = sCos;                                                      \n"
"		sDst = multiplyMatrix(aSrc, sDst);                                      \n"
"		aSrc = sDst;                                                            \n"
"		sDirty = true;                                                          \n"
"	}                                                                           \n"

"	if (bool(aAngle.y) == true)                                                 \n"
"	{                                                                           \n"
"		sRadian = PBDegreesToRadians(aAngle.y);                                 \n"
"       sSin = sin(sRadian);                                                    \n"
"       sCos = cos(sRadian);                                                    \n"
"		sDst[0][0] = sCos;                                                      \n"
"       sDst[0][2] = sSin;                                                      \n"
"       sDst[2][0] = -sSin;                                                     \n"
"       sDst[2][2] = sCos;                                                      \n"
"		sDst = multiplyMatrix(aSrc, sDst);                                      \n"
"		aSrc = sDst;                                                            \n"
"		sDirty = true;                                                          \n"
"	}                                                                           \n"

"	if (bool(aAngle.z) == true)                                                 \n"
"	{                                                                           \n"
"		sRadian = PBDegreesToRadians(aAngle.z);                                 \n"
"       sSin = sin(sRadian);                                                    \n"
"       sCos = cos(sRadian);                                                    \n"
"       sDst[0][0] = sCos;                                                      \n"
"       sDst[0][1] = -sSin;                                                     \n"
"       sDst[1][0] = sSin;                                                      \n"
"       sDst[1][1] = sCos;                                                      \n"
"		sDst = multiplyMatrix(aSrc, sDst);                                      \n"
"		aSrc = sDst;                                                            \n"
"		sDirty = true;                                                          \n"
"	}                                                                           \n"

"	if (!sDirty)                                                                \n"
"    {                                                                          \n"
"        sDst = aSrc;                                                           \n"
"    }                                                                          \n"

"	return sDst;                                                                \n"
"}                                                                              \n"

"mat4 scaleMatrix(in mat4 aSrc, in float aScale)                                \n"
"{                                                                              \n"
"	mat4 sDst   = aSrc;                                                         \n"
"	sDst[0][0] *= aScale;                                                       \n"
"   sDst[0][1] *= aScale;                                                       \n"
"   sDst[0][2] *= aScale;                                                       \n"
"  	sDst[0][3] *= aScale;                                                       \n"

"  	sDst[1][0] *= aScale;                                                       \n"
"  	sDst[1][1] *= aScale;                                                       \n"
"   sDst[1][2] *= aScale;                                                       \n"
"  	sDst[1][3] *= aScale;                                                       \n"

"   sDst[2][0] *= aScale;                                                       \n"
"  	sDst[2][1] *= aScale;                                                       \n"
"  	sDst[2][2] *= aScale;                                                       \n"
"   sDst[2][3] *= aScale;                                                       \n"

"	return sDst;                                                                \n"
"}                                                                              \n"


"void main()                                                                    \n"
"{                                                                              \n"
"	mat4 sModelProjection 	= uIdentityProjection;                              \n"
"   sModelProjection 		= multiplyMatrix(sModelProjection, aProjection);    \n"
"	sModelProjection 		= translateMatrix(sModelProjection, aTranslate);    \n"
"	sModelProjection 		= scaleMatrix(sModelProjection, aScale);            \n"
"	sModelProjection 		= rotationMatrix(sModelProjection, aAngle);         \n"

"   gl_Position      = sModelProjection * aPosition;                            \n"

"   vTexCoord        = aTexCoord;                                               \n"
"   vColor           = aColor;                                                  \n"
"   vSelectionColor  = aSelectionColor;                                         \n"
"   vSelectMode      = aSelectMode;                                             \n"
"   vGrayScaleFilter = aGrayScaleFilter;                                        \n"
"   vSepiaFilter     = aSepiaFilter;                                            \n"
"   vBlurFilter      = aBlurFilter;                                             \n"
"   vLuminanceFilter = aLuminanceFilter;                                        \n"
"   vFogFilter       = aFogFilter;                                              \n"
"}                                                                              \n";