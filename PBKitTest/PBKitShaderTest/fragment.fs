uniform sampler2D uTexture1;
uniform sampler2D uTexture2;
uniform vec3  uSelectionColor;
uniform float uSelectMode;

void main()
{
	vec4 dstColor1 = texture2D(uTexture1, gl_TexCoord[0].xy);
	vec4 dstColor2 = texture2D(uTexture2, gl_TexCoord[1].xy);

   	if (uSelectMode > 0.0)
   	{
    	   float alpha = dstColor1.a;
    	   dstColor1    = vec4(vec3(uSelectionColor), alpha);
	}

	gl_FragColor = dstColor1;// + dstColor2;
}
