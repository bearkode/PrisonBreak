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


@synthesize scale             = mScale;
@synthesize vertices          = mVertices;
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
    
    GLuint           sPosition        = glGetAttribLocation(mProgramObject, "aPosition");
    GLuint           sTexCoord        = glGetAttribLocation(mProgramObject, "aTexCoord");
    GLint            sSampler         = glGetUniformLocation(mProgramObject, "aTexture");
    
    glVertexAttribPointer(sPosition, 2, GL_FLOAT, GL_FALSE, 0, &sTextureVertices);
    glVertexAttribPointer(sTexCoord, 2, GL_FLOAT, GL_FALSE, 0, gTextureVertices);
    glEnableVertexAttribArray(sPosition);
    glEnableVertexAttribArray(sTexCoord);
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, [mTexture textureID]);
    glUniform1i(sSampler, 0);
    
//    glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
    glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_SHORT, gIndices);
}


- (void)applyTransform
{
    if (mTransform)
    {
        GLint sTransformUniform = glGetUniformLocation(mProgramObject, "aTransform");
        glUniformMatrix4fv(sTransformUniform, 1, 0, mTransform.matrix.m);
    }
}


#pragma mark -


- (void)setTextureVertices:(PBVertice4)aVertices program:(GLuint)aProgramObject
{
    aVertices.x1  *= mScale;
    aVertices.x2  *= mScale;
    aVertices.y1  *= mScale;
    aVertices.y2  *= mScale;
    
    mVertices      = aVertices;
    mProgramObject = aProgramObject;
}


- (void)setTextureViewPoint:(CGPoint)aViewPoint program:(GLuint)aProgramObject
{
    CGSize sTextureSize = (CGSizeMake([mTexture size].width * mScale, [mTexture size].height * mScale));
    mVertices           = convertVertice4FromView(aViewPoint, sTextureSize);
    mProgramObject      = aProgramObject;
}


#pragma mark -


- (void)rendering
{
    if (mBlendModeSFactor != GL_ONE || mBlendModeDFactor != GL_ONE_MINUS_SRC_ALPHA)
    {
        glBlendFunc(mBlendModeSFactor, mBlendModeDFactor);
    }

//    [mSubrenderables makeObjectsPerformSelector:aSelector withObject:aSender];

    [self applyTransform];
    [self drawTexture];
}


@end


