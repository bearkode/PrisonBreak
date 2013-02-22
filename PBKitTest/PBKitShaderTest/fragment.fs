uniform sampler2D uTexture1;
uniform sampler2D uTexture2;
uniform vec3  uSelectionColor;
uniform float uSelectMode;

vec4 grayScaleColor(in vec4 aColor)
{
	float sGrayScale = max(aColor.r, max(aColor.g,aColor.b));
	return vec4(vec3(sGrayScale), aColor.a);
}

vec4 sepiaColor(in vec4 aColor)
{
	vec4 sSepia = vec4(	clamp(aColor.r * 0.393 + aColor.g * 0.769 + aColor.b * 0.189, 0.0, 1.0), 
			  			clamp(aColor.r * 0.349 + aColor.g * 0.686 + aColor.b * 0.168, 0.0, 1.0), 
		       			clamp(aColor.r * 0.272 + aColor.g * 0.534 + aColor.b * 0.131, 0.0, 1.0),
			   			aColor.a );
    return sSepia;
}

vec4 luminanceColor(in vec4 aColor)
{
	float sLuminance = (aColor.r + aColor.g + aColor.b ) / 3.0;
    return aColor * sLuminance;
}

vec4 blurEffect(in sampler2D aTexture,  in vec2 aTexCoord)
{
	vec4  sBlur[9];
	float sOffset = 0.020;
	for (int i = 0; i < 9; i++) 
	{
		sBlur[i] = texture2D(aTexture, aTexCoord + sOffset);
		sOffset -= 0.004;
	}

	vec4 sBlurColor = 	(sBlur[0] + (2.0 * sBlur[1]) + sBlur[2] +  
					(2.0 * sBlur[3]) + sBlur[4] + (2.0 * sBlur[5]) + 
					sBlur[6] + (2.0 * sBlur[7]) + sBlur[8]) / 13.0;

	return sBlurColor;
}

vec4 fogEffect(in vec4 aColor, in float aDensity)
{
	const vec4  sFogColor 	= vec4(0.5, 0.8, 0.5, 1.0);
	const float e    	   	= 2.71828;
	float sFogFactor 		= (aDensity * gl_FragCoord.z); 
	sFogFactor *= sFogFactor;
	sFogFactor  = clamp(pow(e, -sFogFactor), 0.0, 1.0);

 	return mix(sFogColor, aColor, sFogFactor);
}

vec4 multiplyColor(in sampler2D aTexture,  in vec2 aTexCoord, in vec4 aColor)
{
	vec4 sDstColor 		= aColor;

	float vBlurFilter 		= 0.0;
	float vGrayScaleFilter 	= 0.0;
	float vSepiaFilter 	= 0.0;
	float vLuminanceFilter 	= 0.0;
	float vFogFilter 		= 0.0;

   if (bool(vBlurFilter) == true)                                         
   {                                                                           
       sDstColor = blurEffect(aTexture, aTexCoord);                           
   }                                                                           

   if (bool(vGrayScaleFilter) == true)                                         
   {                                                                           
       sDstColor = grayScaleColor(sDstColor);                                
   }                                                                           

   if (bool(vSepiaFilter) == true)                                             
   {                                                                           
       sDstColor = sepiaColor(sDstColor);                                    
   }                                                                           

   if (bool(vLuminanceFilter) == true)                                         
   {                                                                           
       sDstColor = luminanceColor(sDstColor);                                
   }                                                                           

   if (bool(vFogFilter) == true)                                               
   {                                                                           
       sDstColor = fogEffect(sDstColor, 1.0);                                
   }             

	return sDstColor;                                                              
}

void main()
{
	vec4 dstColor1 = texture2D(uTexture1, gl_TexCoord[0].xy);
	vec4 dstColor2 = texture2D(uTexture2, gl_TexCoord[1].xy);

int a = (int)uSelectMode;
int b = 1;
int cmp = a < b;
int c = (a&cmp) | (b&~cmp);


	if (bool(uSelectMode) == true)
   	{
    	   float alpha = dstColor1.a;
    	   dstColor1    = vec4(vec3(uSelectionColor), alpha);
	}

	gl_FragColor = multiplyColor(uTexture1, gl_TexCoord[0].xy, dstColor1);
}
