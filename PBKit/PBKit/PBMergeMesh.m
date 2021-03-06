/*
 *  PBMergeMesh.m
 *  PBKit
 *
 *  Created by camelkode on 13. 9. 26..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */


#import "PBMergeMesh.h"
#import "PBTransform.h"


@implementation PBMergeMesh
{
    GLfloat   *mVertices;
    GLfloat   *mCoordinates;
    
    NSUInteger mCapacity;
    uint32_t   mMeshCount;
}


- (void)dealloc
{
    if (mVertices)
    {
        free(mVertices);
    }
    
    if (mCoordinates)
    {
        free(mCoordinates);
    }
    
    [super dealloc];
}


#pragma mark -


- (GLfloat *)vertices
{
    return mVertices;
}


- (GLfloat *)coordinates
{
    return mCoordinates;
}


#pragma mark -


- (void)setCapacity:(NSUInteger)aCapacity
{
    if (mCapacity < aCapacity)
    {
        mCapacity = aCapacity;
        
        if (mVertices)
        {
            free(mVertices);
            mVertices = NULL;
        }
        
        if (mCoordinates)
        {
            free(mCoordinates);
            mCoordinates = NULL;
        }
        
        if (aCapacity > 0)
        {
            mVertices    = malloc(aCapacity * kMeshVertexSize * sizeof(GLfloat));
            mCoordinates = malloc(aCapacity * kMeshCoordinateSize * sizeof(GLfloat));
        }
    }
    
    mMeshCount = 0;
}


- (void)attachMesh:(PBMesh *)aMesh
{

    if (mVertices && mCoordinates)
    {
        GLfloat sVertices[kMeshVertexSize];
        
        memcpy(sVertices, [aMesh originVertices], kMeshVertexSize * sizeof(GLfloat));
        
        PBScaleMeshVertice(sVertices, [[aMesh transform] scale]);
        PBRotateMeshVertice(sVertices, [[aMesh transform] angle].z);
        PBMakeMeshVertice(sVertices, sVertices, [aMesh point].x, [aMesh point].y, [aMesh zPoint]);
        
        memcpy(&mVertices[mMeshCount * kMeshVertexSize], sVertices, kMeshVertexSize * sizeof(GLfloat));
        memcpy(&mCoordinates[mMeshCount * kMeshCoordinateSize], [aMesh coordinates], kMeshCoordinateSize * sizeof(GLfloat));        
    }
    
    mMeshCount++;
}


- (uint32_t)meshCount
{
    return mMeshCount;
}


@end
