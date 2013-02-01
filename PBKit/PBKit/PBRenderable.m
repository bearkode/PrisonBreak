/*
 *  PBRenderable.m
 *  PBKit
 *
 *  Created by camelkode on 13. 1. 4..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


#import "PBKit.h"


@implementation PBRenderable
{
    GLuint          mProgramObject;
    
    CGPoint         mPosition;
    PBVertex4       mVertices;

    PBTexture      *mTexture;
    PBTransform    *mTransform;
    
    GLenum          mBlendModeSFactor;
    GLenum          mBlendModeDFactor;
    
    GLuint          mShaderLocPosition;
    GLuint          mShaderLocTexCoord;
    GLint           mShaderLocSampler;
    GLint           mShaderLocProjection;
    
    PBMatrix4       mProjection;
    PBRenderable   *mSuperrenderable;
    NSMutableArray *mSubrenderables;
}


@synthesize programObject    = mProgramObject;
@synthesize texture          = mTexture;
@synthesize blendModeSFactor = mBlendModeSFactor;
@synthesize blendModeDFactor = mBlendModeDFactor;
@synthesize subrenderables   = mSubrenderables;
@synthesize transform        = mTransform;


#pragma mark -


- (id)init
{
    self = [super init];
    if (self)
    {
        mBlendModeSFactor = GL_ONE;
        mBlendModeDFactor = GL_ONE_MINUS_SRC_ALPHA;
        mSubrenderables   = [[NSMutableArray alloc] init];
        mTransform        = [[PBTransform alloc] init];
    }
    
    return self;
}


- (id)initWithTexture:(PBTexture *)aTexture
{
    self = [self init];
    if (self)
    {
        [self setTexture:aTexture];
    }
    
    return self;
}


- (void)dealloc
{
    [mTransform release];
    [mSubrenderables release];
    [mTexture release];
    
    [super dealloc];
}


#pragma mark - Private


- (BOOL)hasSuperRenderable
{
    return ([mSuperrenderable texture]) ? YES : NO;
}


- (void)rendering
{
    glUseProgram(mProgramObject);
    
    PBTextureVertices sTextureVertices = generatorTextureVertex4(mVertices);
    
    glVertexAttribPointer(mShaderLocPosition, 2, GL_FLOAT, GL_FALSE, 0, &sTextureVertices);
    glVertexAttribPointer(mShaderLocTexCoord, 2, GL_FLOAT, GL_FALSE, 0, gTextureVertices);
    glEnableVertexAttribArray(mShaderLocPosition);
    glEnableVertexAttribArray(mShaderLocTexCoord);
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, [mTexture textureID]);
    glUniform1i(mShaderLocSampler, 0);
    
//    glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
    glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_SHORT, gIndices);
}


- (void)applyTransform
{
    PBMatrix4 sResultMatrix;
    PBMatrix4 sTranslateMatrix;
    PBMatrix4 sRotateMatrix;
    PBMatrix4 sScaleMatrix;

    if ([self hasSuperRenderable])
    {
        mVertices = addVertex4FromVertex3(mVertices, [mTransform translate]);
        [mTransform assignTransform:[mSuperrenderable transform]];
    }
    
    sTranslateMatrix = [PBTransform multiplyTranslateMatrix:PBMatrix4Identity translate:[mTransform translate]];
    sRotateMatrix    = [PBTransform multiplyRotateMatrix:sTranslateMatrix angle:[mTransform angle]];
    sScaleMatrix     = [PBTransform multiplyScaleMatrix:sRotateMatrix scale:[mTransform scale]];
    sResultMatrix    = [PBTransform multiplyWithMatrixA:sScaleMatrix matrixB:mProjection];
    glUniformMatrix4fv(mShaderLocProjection, 1, 0, &sResultMatrix.m[0][0]);
}


#pragma mark -


- (void)setProgramObject:(GLuint)programObject
{
    mProgramObject       = programObject;
    mShaderLocPosition   = glGetAttribLocation(mProgramObject, "aPosition");
    mShaderLocTexCoord   = glGetAttribLocation(mProgramObject, "aTexCoord");
    mShaderLocSampler    = glGetUniformLocation(mProgramObject, "aTexture");
    mShaderLocProjection = glGetUniformLocation(mProgramObject, "aProjection");
}


- (void)setPosition:(CGPoint)aPosition textureSize:(CGSize)aTextureSize
{
    mPosition = aPosition;
    mVertices   = convertVertex4FromViewSize(aTextureSize);
    [mTransform setTranslate:PBVertex3Make(aPosition.x, aPosition.y, 0)];
}


- (void)setPosition:(CGPoint)aPosition
{
    [self setPosition:aPosition textureSize:[mTexture size]];
}


- (CGPoint)position
{
    return mPosition;
}


#pragma mark -


- (void)setSuperrenderable:(PBRenderable *)aRenderable
{
    mSuperrenderable = aRenderable;
}


- (NSArray *)subrenderables
{
    return [[mSubrenderables copy] autorelease];
}


- (void)setSubrenderables:(NSArray *)aSubrenderables
{
    NSArray *sOldSubrenderables = [mSubrenderables copy];

    [mSubrenderables makeObjectsPerformSelector:@selector(setSuperrenderable:) withObject:nil];
    [mSubrenderables setArray:aSubrenderables];
    [mSubrenderables makeObjectsPerformSelector:@selector(setSuperrenderable:) withObject:self];

    [sOldSubrenderables release];
}


#pragma mark -


- (void)renderingWithProjection:(PBMatrix4)aProjection
{
    mProjection = aProjection;

    [self applyTransform];
    [self rendering];
    
    for (PBRenderable *sRenderable in mSubrenderables)
    {
        [sRenderable renderingWithProjection:mProjection];
    }
}


- (void)performRenderingWithProjection:(PBMatrix4)aProjection
{
    if (mBlendModeSFactor != GL_ONE || mBlendModeDFactor != GL_ONE_MINUS_SRC_ALPHA)
    {
        glBlendFunc(mBlendModeSFactor, mBlendModeDFactor);
    }

    for (PBRenderable *sRenderable in mSubrenderables)
    {
        [sRenderable renderingWithProjection:aProjection];
    }
}


@end


