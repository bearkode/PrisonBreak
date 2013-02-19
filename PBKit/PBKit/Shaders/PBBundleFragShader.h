/*
 *  PBBundleFragShader.h
 *  PBKit
 *
 *  Created by camelkode on 13. 2. 18..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


static const GLbyte gBundleFShaderSource[] =
"precision mediump   float;                                                     \n"
"uniform   sampler2D aTexture;                                                  \n"
"varying   vec2      vTexCoord;                                                 \n"
"varying   vec4      vColor;                                                    \n"
"varying   vec4      vSelectionColor;                                           \n"
"varying   float     vSelectMode;                                               \n"

"varying   float     vGrayScaleFilter;                                          \n"
"varying   float     vSepiaFilter;                                              \n"
"varying   float     vLuminanceFilter;                                          \n"
"varying   float     vFogFilter;                                                \n"
"varying   float     vBlurFilter;                                               \n"



"vec4 grayScaleColor(in vec4 aColor)                                            \n"
"{                                                                              \n"
"	float sGrayScale = max(aColor.r, max(aColor.g,aColor.b));                   \n"
"	return vec4(vec3(sGrayScale), aColor.a);                                    \n"
"}                                                                              \n"

"vec4 sepiaColor(in vec4 aColor)                                                                    \n"
"{                                                                                                  \n"
"	vec4 sSepia = vec4(	clamp(aColor.r * 0.393 + aColor.g * 0.769 + aColor.b * 0.189, 0.0, 1.0),    \n"
"                       clamp(aColor.r * 0.349 + aColor.g * 0.686 + aColor.b * 0.168, 0.0, 1.0),    \n"
"                       clamp(aColor.r * 0.272 + aColor.g * 0.534 + aColor.b * 0.131, 0.0, 1.0),    \n"
"                       aColor.a );                                                                 \n"
"    return sSepia;                                                                                 \n"
"}                                                                                                  \n"

"vec4 luminanceColor(in vec4 aColor)                                            \n"
"{                                                                              \n"
"	float sLuminance = (aColor.r + aColor.g + aColor.b ) / 3.0;                 \n"
"    return aColor * sLuminance;                                                \n"
"}                                                                              \n"

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

"vec4 fogEffect(in vec4 aColor, in float aDensity)                              \n"
"{                                                                              \n"
"	const vec4  sFogColor 	= vec4(0.5, 0.8, 0.5, 1.0);                         \n"
"	const float e    	   	= 2.71828;                                          \n"
"	float sFogFactor 		= (aDensity * gl_FragCoord.z);                      \n"
"	sFogFactor *= sFogFactor;                                                   \n"
"	sFogFactor  = clamp(pow(e, -sFogFactor), 0.0, 1.0);                         \n"

" 	return mix(sFogColor, aColor, sFogFactor);                                  \n"
"}                                                                              \n"

"vec4 multiplyColor(in sampler2D aTexture, in vec2 aTexCoord, in vec4 aColor)   \n"
"{                                                                              \n"
"	vec4 sDstColor = aColor;                                                    \n"
    
"   if (bool(vBlurFilter) == true)                                              \n"
"   {                                                                           \n"
"       sDstColor = blurEffect(aTexture, aTexCoord);                            \n"
"   }                                                                           \n"
    
"   if (bool(vGrayScaleFilter) == true)                                         \n"
"   {                                                                           \n"
"       sDstColor = grayScaleColor(sDstColor);                                  \n"
"   }                                                                           \n"
    
"   if (bool(vSepiaFilter) == true)                                             \n"
"   {                                                                           \n"
"       sDstColor = sepiaColor(sDstColor);                                      \n"
"   }                                                                           \n"
    
"   if (bool(vLuminanceFilter) == true)                                         \n"
"   {                                                                           \n"
"       sDstColor = luminanceColor(sDstColor);                                  \n"
"   }                                                                           \n"
    
"   if (bool(vFogFilter) == true)                                               \n"
"   {                                                                           \n"
"       sDstColor = fogEffect(sDstColor, 1.0);                                  \n"
"   }                                                                           \n"
    
"	return sDstColor;                                                           \n"
"}                                                                              \n"

"void main()                                                                    \n"
"{                                                                              \n"
"   vec4 sDstColor = texture2D(aTexture, vTexCoord);                            \n"
"   if (bool(vSelectMode) == true)                                              \n"
"   {                                                                           \n"
"       float sAlpha = sDstColor.a;                                             \n"
"       sDstColor    = vec4(vec3(vSelectionColor), sAlpha);                     \n"
"   }                                                                           \n"

"   gl_FragColor = multiplyColor(aTexture, vTexCoord, sDstColor * vColor);      \n"
"}                                                                              \n";