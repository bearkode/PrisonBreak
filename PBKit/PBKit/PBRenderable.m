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
    GLuint mShaderLocPosition;
    GLuint mShaderLocTexCoord;
    GLint  mShaderLocSampler;
    GLint  mShaderLocTransformUniform;
    
}

@synthesize scale             = mScale;
@synthesize programObject     = mProgramObject;
@synthesize texture           = mTexture;
@synthesize blendModeSFactor  = mBlendModeSFactor;
@synthesize blendModeDFactor  = mBlendModeDFactor;
@synthesize transform         = mTransform;


#pragma mark -


- (id)init
{
    self = [super init];
    if (self)
    {
        mBlendModeSFactor = GL_ONE;
        mBlendModeDFactor = GL_ONE_MINUS_SRC_ALPHA;
        mTransform        = [[PBTransform alloc] init];;

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
    [mTexture release];
    
    [super dealloc];
}


#pragma mark - Private


- (void)drawTexture
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
    PBMatrix4 sProjection      = PBMatrix4Identity;
    PBMatrix4 sTranslateMatrix = [mTransform applyTranslate:PBMatrix4Identity];
    PBMatrix4 sRotateMatrix    = [mTransform applyRotation:sTranslateMatrix];
    [mTransform setMatrix:[mTransform multiplyWithSrcA:sRotateMatrix srcB:sProjection]];
    
    glUniformMatrix4fv(mShaderLocTransformUniform, 1, 0, &mTransform.matrix.m[0][0]);
}


#pragma mark -


- (void)setProgramObject:(GLuint)programObject
{
    mProgramObject             = programObject;
    mShaderLocPosition         = glGetAttribLocation(mProgramObject, "aPosition");
    mShaderLocTexCoord         = glGetAttribLocation(mProgramObject, "aTexCoord");
    mShaderLocSampler          = glGetUniformLocation(mProgramObject, "aTexture");
    mShaderLocTransformUniform = glGetUniformLocation(mProgramObject, "aTransform");
}


- (void)setVertices:(PBVertice4)aVertices
{
    mVertices = multiplyScale(aVertices, mScale);
    [mTransform setTranslate:PBVertice3Make(0, 0, 0)];
}


- (void)setPosition:(CGPoint)aPosition textureSize:(CGSize)aTextureSize
{
    mVertices = convertVertice4FromViewSize(aTextureSize);
    PBVertice2 sVertice2 = convertVertice2FromViewPoint(aPosition);
    CGSize     sSize     = sizeViewPortRatio(aTextureSize);
    sVertice2.x         += (sSize.width / 2);
    sVertice2.y         -= (sSize.height / 2);
    [mTransform setTranslate:PBVertice3Make(sVertice2.x, sVertice2.y, 0)];
}


- (void)setPosition:(CGPoint)aPosition
{
    CGSize sTextureSize = (CGSizeMake([mTexture size].width * mScale, [mTexture size].height * mScale));
    [self setPosition:aPosition textureSize:sTextureSize];
}


#pragma mark -

    
- (void)rendering
{
    if (mBlendModeSFactor != GL_ONE || mBlendModeDFactor != GL_ONE_MINUS_SRC_ALPHA)
    {
        glBlendFunc(mBlendModeSFactor, mBlendModeDFactor);
    }
    
//  [mSubrenderables makeObjectsPerformSelector:aSelector withObject:aSender];
    
    [self applyTransform];
    [self drawTexture];
}


@end


