/*
 *  PBRenderable.m
 *  PBKit
 *
 *  Created by camelkode on 13. 1. 4..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
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
@synthesize blendModeSFactor = mBlendModeSFactor;
@synthesize blendModeDFactor = mBlendModeDFactor;
@synthesize transform        = mTransform;


#pragma mark -


+ (id)textureRenderableWithTexture:(PBTexture *)aTexture
{
    PBRenderable *sRenderable = [[self alloc] initWithTexture:aTexture];
    GLuint        sProgramID  = [[[PBShaderManager sharedManager] textureShader] programObject];
    
    [sRenderable setProgramObject:sProgramID];

    return sRenderable;
}


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
        mPosition         = CGPointMake(0, 0);
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
    [mTexture removeObserver:self forKeyPath:@"tileSize"];
    
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
    if (mTexture)
    {
        glUseProgram(mProgramObject);
        
        PBTextureVertices sTextureVertices = PBGeneratorTextureVertex4(mVertices);
        
        glVertexAttribPointer(mShaderLocPosition, 2, GL_FLOAT, GL_FALSE, 0, &sTextureVertices);
        glVertexAttribPointer(mShaderLocTexCoord, 2, GL_FLOAT, GL_FALSE, 0, [mTexture vertices]);
        glEnableVertexAttribArray(mShaderLocPosition);
        glEnableVertexAttribArray(mShaderLocTexCoord);
        
        glActiveTexture(GL_TEXTURE0);
        glBindTexture(GL_TEXTURE_2D, [mTexture textureID]);
        glUniform1i(mShaderLocSampler, 0);
        
        //    glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
        glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_SHORT, gIndices);
    }
}


- (void)applyTransform
{
    PBMatrix4 sResultMatrix;
    PBMatrix4 sTranslateMatrix;
    PBMatrix4 sRotateMatrix;
    PBMatrix4 sScaleMatrix;

    if ([self hasSuperRenderable])
    {
        mVertices = PBAddVertex4FromVertex3(mVertices, [mTransform translate]);
        [mTransform assignTransform:[mSuperrenderable transform]];
    }
    
    sTranslateMatrix = [PBTransform multiplyTranslateMatrix:PBMatrix4Identity translate:[mTransform translate]];
    sRotateMatrix    = [PBTransform multiplyRotateMatrix:sTranslateMatrix angle:[mTransform angle]];
    sScaleMatrix     = [PBTransform multiplyScaleMatrix:sRotateMatrix scale:[mTransform scale]];
    sResultMatrix    = [PBTransform multiplyWithMatrixA:sScaleMatrix matrixB:mProjection];
    glUniformMatrix4fv(mShaderLocProjection, 1, 0, &sResultMatrix.m[0][0]);
}


#pragma mark -


- (void)setTexture:(PBTexture *)aTexture
{
    [mTexture removeObserver:self forKeyPath:@"tileSize"];
    [mTexture autorelease];
    
    mTexture = [aTexture retain];
    [mTexture addObserver:self forKeyPath:@"tileSize" options:NSKeyValueObservingOptionNew context:NULL];

    mVertices = PBConvertVertex4FromViewSize([mTexture tileSize]);
}


- (PBTexture *)texture
{
    return mTexture;
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
    mVertices = PBConvertVertex4FromViewSize(aTextureSize);
    [mTransform setTranslate:PBVertex3Make(aPosition.x, aPosition.y, 0)];
}


- (void)setPosition:(CGPoint)aPosition
{
    [self setPosition:aPosition textureSize:[mTexture tileSize]];
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


- (void)addSubrenderable:(PBRenderable *)aRenderable
{
    NSAssert(aRenderable, @"aRenderable is nil");
    
    [aRenderable setSuperrenderable:self];
    [mSubrenderables addObject:aRenderable];
}


#pragma mark -


- (void)renderingWithProjection:(PBMatrix4)aProjection
{
    mProjection = aProjection;

    if (mBlendModeSFactor != GL_ONE || mBlendModeDFactor != GL_ONE_MINUS_SRC_ALPHA)
    {
        glBlendFunc(mBlendModeSFactor, mBlendModeDFactor);
    }
    
    [self applyTransform];
    [self rendering];
    
    for (PBRenderable *sRenderable in mSubrenderables)
    {
        [sRenderable renderingWithProjection:mProjection];
    }
}


- (void)performRenderingWithProjection:(PBMatrix4)aProjection
{
    for (PBRenderable *sRenderable in mSubrenderables)
    {
        [sRenderable renderingWithProjection:aProjection];
    }
}


#pragma mark -


- (void)observeValueForKeyPath:(NSString *)aKeyPath ofObject:(id)aObject change:(NSDictionary *)aChange context:(void *)aContext
{
    if ([aKeyPath isEqualToString:@"tileSize"] && aObject == mTexture)
    {
        mVertices = PBConvertVertex4FromViewSize([mTexture tileSize]);
    }
}


@end


