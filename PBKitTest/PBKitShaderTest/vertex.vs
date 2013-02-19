uniform vec3  uSelectionColor;
uniform float uSelectMode;

#define M_PI 3.14
#define PBDegreesToRadians(aDegrees) ((aDegrees) * M_PI / 180.0)

//uniform mat4  uIdentityProjection;
const mat4 uIdentityProjection = mat4(1.0, 0.0, 0.0, 0.0,
								 0.0, 1.0, 0.0, 0.0,
								 0.0, 0.0, 1.0, 0.0,
								 0.0, 0.0, 0.0, 1.0);

mat4 multiplyMatrix(in mat4 aSrc1, in mat4 aSrc2)
{
	return aSrc1 * aSrc2;
}

mat4 translateMatrix(in mat4 aSrc, in vec3 aTranslate)
{
	mat4 sDst = aSrc;
	sDst[3][0] += (sDst[0][0] * aTranslate.x + sDst[1][0] * aTranslate.y + sDst[2][0] * aTranslate.z);
	sDst[3][1] += (sDst[0][1] * aTranslate.x + sDst[1][1] * aTranslate.y + sDst[2][1] * aTranslate.z);
	sDst[3][2] += (sDst[0][2] * aTranslate.x + sDst[1][2] * aTranslate.y + sDst[2][2] * aTranslate.z);
	sDst[3][3] += (sDst[0][3] * aTranslate.x + sDst[1][3] * aTranslate.y + sDst[2][3] * aTranslate.z);

	return sDst;
}

mat4 rotationMatrix(inout mat4 aSrc, in vec3 aAngle)
{
	mat4  sDst    = uIdentityProjection;
	float sRadian = 0.0;
    	float sSin	= 0.0;
    	float sCos    = 0.0;
	bool  sDirty 	= false;

	if (bool(aAngle.x) == true)
	{
		sRadian = PBDegreesToRadians(aAngle.x);
	    	sSin = sin(sRadian);
	    	sCos = cos(sRadian);

        	sDst[1][1] = sCos;
        	sDst[1][2] = -sSin;
        	sDst[2][1] = sSin;
        	sDst[2][2] = sCos;
		sDst = multiplyMatrix(aSrc, sDst);
		aSrc = sDst;
		sDirty = true;
	}

	if (bool(aAngle.y) == true)
	{
		sRadian = PBDegreesToRadians(aAngle.y);
	    	sSin = sin(sRadian);
	    	sCos = cos(sRadian);

		sDst[0][0] = sCos;
        	sDst[0][2] = sSin;
        	sDst[2][0] = -sSin;
        	sDst[2][2] = sCos;

		sDst = multiplyMatrix(aSrc, sDst);
		aSrc = sDst;
		sDirty = true;
	}

	if (bool(aAngle.z) == true)
	{
		sRadian = PBDegreesToRadians(aAngle.z);
	    	sSin = sin(sRadian);
	    	sCos = cos(sRadian);

        	sDst[0][0] = sCos;
        	sDst[0][1] = -sSin;
        	sDst[1][0] = sSin;
        	sDst[1][1] = sCos;
		sDst = multiplyMatrix(aSrc, sDst);
		aSrc = sDst;
		sDirty = true;
	}


	if (!sDirty)
    {
        sDst = aSrc;
    }

	return sDst;
}

mat4 scaleMatrix(in mat4 aSrc, in float aScale)
{
	mat4 sDst = aSrc;

	sDst[0][0] *= aScale;
    	sDst[0][1] *= aScale;
   	sDst[0][2] *= aScale;
   	sDst[0][3] *= aScale;

   	sDst[1][0] *= aScale;
   	sDst[1][1] *= aScale;
   	sDst[1][2] *= aScale;
   	sDst[1][3] *= aScale;
    
   	sDst[2][0] *= aScale;
   	sDst[2][1] *= aScale;
   	sDst[2][2] *= aScale;
   	sDst[2][3] *= aScale;

	return sDst;
}

void main()
{
	// varying variables
	float vScale 	   = 0.6;
	vec3  vAngle 	   = vec3(0.0, 0.0, 10.0);
	vec3  vTranslate = vec3(0.0, 0.0, 0.0);
	mat4  vProjection = uIdentityProjection;

	// for shader builder
	gl_TexCoord[0]  = gl_MultiTexCoord0;
	gl_TexCoord[1]  = gl_MultiTexCoord0;

	mat4 modelProjection 	= uIdentityProjection;
	modelProjection 		= scaleMatrix(modelProjection, vScale);
	modelProjection 		= rotationMatrix(modelProjection, vAngle);
	modelProjection 		= translateMatrix(modelProjection, vTranslate);
	modelProjection 		= multiplyMatrix(modelProjection, vProjection);

	gl_Position     		= ftransform() * modelProjection;
}


/*
mat4 orthoMatrix(in float aLeft, in float aRight, in float aBottom, in float aTop, in float aNear, in float aFar)
{
	mat4  sDst 	= uIdentityProjection;

	float sDeltaX = aRight - aLeft;
    	float sDeltaY = aTop   - aBottom;
    	float sDeltaZ = aFar   - aNear;

	if ((sDeltaX == 0.0) || (sDeltaY == 0.0) || (sDeltaZ == 0.0))
    	{
       	return uIdentityProjection;
    	}

	sDst[0][0] =  2.0 / sDeltaX;
    	sDst[1][1] =  2.0 / sDeltaY;
    	sDst[2][2] = -2.0 / sDeltaZ;
    	sDst[3][0] = -(aRight + aLeft) / sDeltaX;
    	sDst[3][1] = -(aTop + aBottom) / sDeltaY;
    	sDst[3][2] = -(aNear + aFar) / sDeltaZ;

	return sDst;
}
*/