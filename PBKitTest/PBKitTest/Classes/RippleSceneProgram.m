/*
 *  RippleSceneProgram.m
 *  PBKitTest
 *
 *  Created by camelkode on 13. 7. 12..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


#import <PBKit.h>
#import "RippleSceneProgram.h"


typedef struct {
    GLint projectionLoc;
    GLint positionLoc;
    GLint texCoordLoc;
    GLint resolutionLoc;
    GLint pointLoc;
    GLint timeLoc;
    GLint directionLoc;
    GLint powerLoc;
    GLint widthLoc;
} RippleSceneLocation;


typedef struct {
    CGPoint point;
    GLfloat time;
    GLfloat direction;
    GLfloat power;
    GLfloat width;
} RippleScene;


@implementation RippleSceneProgram
{
    RippleSceneLocation mLocation;
    RippleScene         mRippleScene;
    PBCamera           *mCamera;
}


#pragma mark -


- (void)bindLocation
{
    mLocation.positionLoc   = [self attributeLocation:@"aPosition"];
    mLocation.texCoordLoc   = [self attributeLocation:@"aTexCoord"];
    mLocation.projectionLoc = [self uniformLocation:@"aProjection"];
    mLocation.resolutionLoc = [self uniformLocation:@"uResolution"];
    mLocation.pointLoc      = [self uniformLocation:@"uRipplePoint"];
    mLocation.timeLoc       = [self uniformLocation:@"uRippleTime"];
    mLocation.directionLoc  = [self uniformLocation:@"uRippleDirection"];
    mLocation.powerLoc      = [self uniformLocation:@"uRipplePower"];
    mLocation.widthLoc      = [self uniformLocation:@"uRippleWidth"];
    
    mRippleScene.direction = 12.0f;
    mRippleScene.power     = 4.0f;
    mRippleScene.width     = 0.03f;
}


#pragma mark -


- (id)init
{
    self = [super init];
    if (self)
    {
        [self linkVertexShaderFilename:@"RippleScene" fragmentShaderFilename:@"RippleScene"];
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
    mRippleScene.point = aPoint;
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
    glUniform2f(mLocation.pointLoc, mRippleScene.point.x, mRippleScene.point.y);
    glUniform1f(mLocation.timeLoc, mRippleScene.time);
    glUniform1f(mLocation.directionLoc, mRippleScene.direction);
    glUniform1f(mLocation.powerLoc, mRippleScene.power);
    glUniform1f(mLocation.widthLoc, mRippleScene.width);
    
    glVertexAttribPointer(mLocation.texCoordLoc, 2, GL_FLOAT, GL_FALSE, 0, gTexCoordinates);
    glEnableVertexAttribArray(mLocation.texCoordLoc);
    
    GLfloat sVertices[12];
    PBMakeMeshVertiesMakeFromSize(sVertices, [mCamera viewSize].width / 2, [mCamera viewSize].height / 2, 2.0f);
    
    glVertexAttribPointer(mLocation.positionLoc, 3, GL_FLOAT, GL_FALSE, 0, sVertices);
    glEnableVertexAttribArray(mLocation.positionLoc);
    glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
    glDisableVertexAttribArray(mLocation.positionLoc);
    glDisableVertexAttribArray(mLocation.texCoordLoc);
    
    glBindTexture(GL_TEXTURE_2D, 0);
    mRippleScene.time += 0.1;
}




@end