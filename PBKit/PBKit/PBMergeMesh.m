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
    
    NSUInteger mMeshCount;
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
    if (mVertices)
    {
        free(mVertices);
    }
    
    if (mCoordinates)
    {
        free(mCoordinates);
    }
 
    if (aCapacity > 0)
    {
        mVertices    = calloc(aCapacity * kMeshVertexSize, sizeof(GLfloat));
        mCoordinates = calloc(aCapacity * kMeshCoordinateSize, sizeof(GLfloat));
    }
}


- (void)attachMesh:(PBMesh *)aMesh
{
    if (!mVertices || !mCoordinates)
    {
        return;
    }

    GLfloat sVertices[kMeshVertexSize];
    memcpy(sVertices, [aMesh originVertices], kMeshVertexSize * sizeof(GLfloat));
    PBScaleMeshVertice(sVertices, [[aMesh transform] scale]);
    PBRotateMeshVertice(sVertices, [[aMesh transform] angle].z);
    PBMakeMeshVertice(sVertices, sVertices, [aMesh point].x, [aMesh point].y, [aMesh zPoint]);
    
    memcpy(&mVertices[mMeshCount * kMeshVertexSize], sVertices, kMeshVertexSize * sizeof(GLfloat));
    memcpy(&mCoordinates[mMeshCount * kMeshCoordinateSize], [aMesh coordinates], kMeshCoordinateSize * sizeof(GLfloat));
    mMeshCount++;
}


- (NSUInteger)meshCount
{
    return mMeshCount;
}


@end
