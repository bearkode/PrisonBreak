/*
 *  PBVertices.h
 *  PBKit
 *
 *  Created by camelkode on 13. 1. 14..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


#ifndef PBVertices_h
#define PBVertices_h


#import <QuartzCore/QuartzCore.h>
#import "PBMacro.h"


#define kMeshVertexCount        4
#define kMeshVertexSize         12
#define kMeshCoordinateSize     8
#define kMeshPositionAttrSize   3
#define kMeshTexCoordAttrSize   2


typedef struct {
    GLfloat x;
    GLfloat y;
    GLfloat z;
} PBVertex3;


static inline PBVertex3 PBVertex3Make(GLfloat x, GLfloat y, GLfloat z)
{
    PBVertex3 p;
    
    p.x = x;
    p.y = y;
    p.z = z;
    
    return p;
}


static const PBVertex3 PBVertex3Zero = { 0, 0, 0 };


static const GLfloat gCoordinateNormal[] =
{
    0.0f, 0.0f,
    0.0f, 1.0f,
    1.0f, 1.0f,
    1.0f, 0.0f,
};


static const GLfloat gCoordinateFlipVertical[] =
{
    0.0f, 1.0f,
    0.0f, 0.0f,
    1.0f, 0.0f,
    1.0f, 1.0f,
};


static const GLfloat gCoordinateFliphorizontal[] =
{
    1.0f, 0.0f,
    1.0f, 1.0f,
    0.0f, 1.0f,
    0.0f, 0.0f,
};


static const GLushort gIndices[6] = { 0, 1, 2, 2, 3, 0 };


static inline void PBMakeMeshVertiesMakeFromSize(GLfloat *dst, GLfloat width, GLfloat height, GLfloat zPoint)
{
    dst[0]  = -width;
    dst[1]  = height;
    dst[2]  = zPoint;
    dst[3]  = -width;
    dst[4]  = -height;
    dst[5]  = zPoint;
    dst[6]  = width;
    dst[7]  = -height;
    dst[8]  = zPoint;
    dst[9]  = width;
    dst[10] = height;
    dst[11] = zPoint;
}


static inline void PBMakeMeshVertice(GLfloat *aDst, GLfloat *aSrc, GLfloat aOffsetX, GLfloat aOffsetY, GLfloat aPointZ)
{
    aDst[0]  = aSrc[0] + aOffsetX;
    aDst[1]  = aSrc[1] + aOffsetY;
    aDst[2]  = aSrc[2] + aPointZ;
    aDst[3]  = aSrc[3] + aOffsetX;
    aDst[4]  = aSrc[4] + aOffsetY;
    aDst[5]  = aSrc[5] + aPointZ;
    aDst[6]  = aSrc[6] + aOffsetX;
    aDst[7]  = aSrc[7] + aOffsetY;
    aDst[8]  = aSrc[8] + aPointZ;
    aDst[9]  = aSrc[9] + aOffsetX;
    aDst[10] = aSrc[10] + aOffsetY;
    aDst[11] = aSrc[11] + aPointZ;
}


static inline void PBScaleMeshVertice(GLfloat *aDst, GLfloat aScale)
{
    aDst[0]  *= aScale;
    aDst[1]  *= aScale;
    aDst[3]  *= aScale;
    aDst[4]  *= aScale;
    aDst[6]  *= aScale;
    aDst[7]  *= aScale;
    aDst[9]  *= aScale;
    aDst[10] *= aScale;
}


static inline void PBRotateMeshVertice(GLfloat *aDst, GLfloat aAngle)
{
    CGPoint sPoint;
    CGFloat sRadian = PBDegreesToRadians(aAngle);
    
    for (int i = 0; i < kMeshVertexSize; i++)
    {
        sPoint.x    = cosf(sRadian) * aDst[i] + sinf(sRadian) * aDst[i + 1];
        sPoint.y    = -sinf(sRadian) * aDst[i] + cosf(sRadian) * aDst[i + 1];
        aDst[i]     = sPoint.x;
        aDst[i + 1] = sPoint.y;
        i += 2;
    }
}


static inline void PBInitIndicesQueue(GLushort *aIndices, GLint aDrawIndicesSize, GLint aIndicesSize)
{
    NSInteger sVertexOffset  = 0;
    NSInteger sIndicesOffset = 0;
    for (int i = 0; i < aDrawIndicesSize; i++)
    {
        if ((i % aIndicesSize) == 0 && i != 0)
        {
            sIndicesOffset = 0;
            sVertexOffset += kMeshVertexCount;
        }
        
        aIndices[i] = gIndices[sIndicesOffset] + sVertexOffset;
        sIndicesOffset++;
    }
}


#endif
