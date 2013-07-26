/*
 *  ShockwaveSceneProgram.m
 *  PBKitTest
 *
 *  Created by camelkode on 13. 7. 12..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


#import <PBKit.h>
#import "ShockwaveSceneProgram.h"


typedef struct {
    GLint projectionLoc;
    GLint positionLoc;
    GLint texCoordLoc;
    GLint resolutionLoc;
    GLint pointLoc;
    GLint timeLoc;
    GLint paramLoc;
} ShockwaveLocation;


typedef struct {
    CGPoint   point;
    GLfloat   time;
    GLfloat   power;
    PBVertex3 param;
} ShockwaveScene;


@implementation ShockwaveSceneProgram
{
    ShockwaveLocation   mLocation;
    ShockwaveScene      mShockwaveScene;

    PBCamera           *mCamera;
}


#pragma mark -


- (void)bindLocation
{
    mLocation.positionLoc   = [self attributeLocation:@"aPosition"];
    mLocation.texCoordLoc   = [self attributeLocation:@"aTexCoord"];
    mLocation.projectionLoc = [self uniformLocation:@"aProjection"];
    mLocation.resolutionLoc = [self uniformLocation:@"uResolution"];
    mLocation.pointLoc      = [self uniformLocation:@"uShockwavePoint"];
    mLocation.timeLoc       = [self uniformLocation:@"uShockwaveTime"];
    mLocation.paramLoc      = [self uniformLocation:@"uShockwaveParam"];
    
    mShockwaveScene.power = 0.06;
    mShockwaveScene.param = PBVertex3Make(10.0, 0.8, 0.1);
}


#pragma mark -


- (id)init
{
    self = [super init];
    if (self)
    {
        [self linkVertexShaderFilename:@"Shockwave" fragmentShaderFilename:@"Shockwave"];
        [self bindLocation];
    }
    
    return self;
}


- (void)dealloc
{
    [mCamera release];
    [super dealloc];
}


#pragma mark -


- (void)setCamera:(PBCamera *)aCamera
{
    [mCamera autorelease];
    mCamera = [aCamera retain];
}


- (void)setPoint:(CGPoint)aPoint
{
    mShockwaveScene.point = aPoint;
}


- (void)setTime:(CGFloat)aTime
{
    mShockwaveScene.time = aTime;
}


- (void)update:(GLuint)aTextureHandle
{
    [self use];
    
    if (!aTextureHandle)
    {
        return;
    }
    glBindTexture(GL_TEXTURE_2D, aTextureHandle);
    
    PBMatrix sProjection = [mCamera projection];
    glUniformMatrix4fv(mLocation.projectionLoc, 1, 0, &sProjection.m[0]);
    
    CGSize sCanvasSize = [mCamera viewSize];
    glUniform2f(mLocation.resolutionLoc, sCanvasSize.width, sCanvasSize.height);
    glUniform2f(mLocation.pointLoc, mShockwaveScene.point.x, mShockwaveScene.point.y);
    glUniform1f(mLocation.timeLoc, mShockwaveScene.time);
    glUniform3f(mLocation.paramLoc, mShockwaveScene.param.x, mShockwaveScene.param.y, mShockwaveScene.param.z);
    
    glVertexAttribPointer(mLocation.texCoordLoc, 2, GL_FLOAT, GL_FALSE, 0, gCoordinateNormal);
    glEnableVertexAttribArray(mLocation.texCoordLoc);
    
    GLfloat sVertices[12];
    PBMakeMeshVertiesMakeFromSize(sVertices, [mCamera viewSize].width / 2, [mCamera viewSize].height / 2, 2.0f);
    
    glVertexAttribPointer(mLocation.positionLoc, 3, GL_FLOAT, GL_FALSE, 0, sVertices);
    glEnableVertexAttribArray(mLocation.positionLoc);
    glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
    glDisableVertexAttribArray(mLocation.positionLoc);
    glDisableVertexAttribArray(mLocation.texCoordLoc);
    
    glBindTexture(GL_TEXTURE_2D, 0);
    mShockwaveScene.time += mShockwaveScene.power;
}


@end