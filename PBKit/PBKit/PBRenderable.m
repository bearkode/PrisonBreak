/*
 *  PBRenderable.m
 *  PBKit
 *
 *  Created by sshanks on 13. 1. 4..
 *  Copyright (c) 2013년 sshanks. All rights reserved.
 *
 */


#import "PBKit.h"


@implementation PBRenderable
{
    GLuint          mProgramObject;
    
    PBVertice4      mVertices;
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
        [mTransform setScale:1.0f];
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


- (void)rendering
{
    glUseProgram(mProgramObject);
    
    PBTextureVertice sTextureVertices = generatorTextureVertice4(mVertices);
    
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
    PBMatrix4 sTranslateMatrix = [PBTransform multiplyTranslateMatrix:PBMatrix4Identity translate:[mTransform translate]];
    PBMatrix4 sRotateMatrix    = [PBTransform multiplyRotationMatrix:sTranslateMatrix angle:[mTransform angle]];
    PBMatrix4 sResultMatrix    = [PBTransform multiplyWithMatrixA:sRotateMatrix matrixB:mProjection];
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


//- (void)setVertices:(PBVertice4)aVertices
//{
//    mVertices  = multiplyScale(aVertices, [mTransform scale]);
//    [mTransform setTranslate:PBVertice3Make(0, 0, 0)];
//}


- (void)setPosition:(CGPoint)aPosition textureSize:(CGSize)aTextureSize
{
    mVertices  = convertVertice4FromViewSize(aTextureSize);
    [mTransform setTranslate:PBVertice3Make(aPosition.x, aPosition.y, 0)];
}


- (void)setPosition:(CGPoint)aPosition
{
    CGSize sTextureSize = (CGSizeMake([mTexture size].width * [mTransform scale], [mTexture size].height * [mTransform scale]));
    [self setPosition:aPosition textureSize:sTextureSize];
}


#pragma mark -


- (void)setSuperrenderable:(PBRenderable *)aRenderable
{
    mSuperrenderable = aRenderable;
    if ([mSuperrenderable texture])
    {
        [mTransform multiplyTransform:[mSuperrenderable transform]];
    }
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


