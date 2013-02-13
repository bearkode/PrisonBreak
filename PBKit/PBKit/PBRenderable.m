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
    
    GLint           mShaderLocPosition;
    GLint           mShaderLocTexCoord;
    GLint           mShaderLocSampler;
    GLint           mShaderLocProjection;
    GLint           mShaderLocSelectionColor;
    GLint           mShaderLocSelectMode;
    
    PBRenderable   *mSuperRenderable;
    NSMutableArray *mSubrenderables;
    
    NSString       *mName;
    PBColor        *mSelectionColor;
    BOOL            mSelectable;
    
    BOOL            mHidden;
}


@synthesize programObject    = mProgramObject;
@synthesize blendModeSFactor = mBlendModeSFactor;
@synthesize blendModeDFactor = mBlendModeDFactor;
@synthesize transform        = mTransform;
@synthesize name             = mName;
@synthesize selectionColor   = mSelectionColor;
@synthesize selectable       = mSelectable;
@synthesize hidden           = mHidden;


#pragma mark -


+ (id)textureRenderableWithTexture:(PBTexture *)aTexture
{
    PBRenderable *sRenderable = [[[self alloc] initWithTexture:aTexture] autorelease];
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
    [mTexture removeObserver:self forKeyPath:@"size"];
    [mSelectionColor release];
    [mName release];
    [mTransform release];
    [mSubrenderables release];
    [mTexture release];
    
    [super dealloc];
}


#pragma mark - Private


- (BOOL)hasSuperRenderable
{
    return ([mSuperRenderable texture]) ? YES : NO;
}


- (PBVertex4)verticesForRendering
{
    return ([self hasSuperRenderable]) ? PBAddVertex4FromVertex3(mVertices, [mTransform translate]) : mVertices;
}


- (PBTransform *)transformForRendering
{
    return ([self hasSuperRenderable]) ? [mSuperRenderable transform] : mTransform;
}


- (void)applyTransform:(PBTransform *)aTransform projection:(PBMatrix4)aProjection
{
    PBMatrix4 sMatrix = PBMatrix4Identity;
    sMatrix = [PBTransform multiplyTranslateMatrix:sMatrix translate:[aTransform translate]];
    sMatrix = [PBTransform multiplyScaleMatrix:sMatrix scale:[aTransform scale]];
    sMatrix = [PBTransform multiplyRotateMatrix:sMatrix angle:[aTransform angle]];
    sMatrix = [PBTransform multiplyWithMatrixA:sMatrix matrixB:aProjection];
    glUniformMatrix4fv(mShaderLocProjection, 1, 0, &sMatrix.m[0][0]);
}


- (void)rendering:(PBRenderingMode)aRenderMode vertices:(PBVertex4)aVertices
{
    if (mTexture && !mHidden)
    {
        PBTextureVertices sTextureVertices = PBGeneratorTextureVertex4(aVertices);
        
        glVertexAttribPointer(mShaderLocPosition, 2, GL_FLOAT, GL_FALSE, 0, &sTextureVertices);
        glVertexAttribPointer(mShaderLocTexCoord, 2, GL_FLOAT, GL_FALSE, 0, [mTexture vertices]);
        
        if (aRenderMode == kPBRenderingSelectMode)
        {
            GLfloat sSelectionColor[3] = {[mSelectionColor red], [mSelectionColor green], [mSelectionColor blue]};
            glVertexAttrib4fv(mShaderLocSelectionColor, sSelectionColor);
            
            CGFloat sSelectMode = 1.0;
            glVertexAttribPointer(mShaderLocSelectMode, 1, GL_FLOAT, GL_FALSE, 0, &sSelectMode);
            glEnableVertexAttribArray(mShaderLocSelectMode);
        }

        glEnableVertexAttribArray(mShaderLocPosition);
        glEnableVertexAttribArray(mShaderLocTexCoord);

        glActiveTexture(GL_TEXTURE0);
        glBindTexture(GL_TEXTURE_2D, [mTexture handle]);
        glUniform1i(mShaderLocSampler, 0);

        glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_SHORT, gIndices);

        glDisableVertexAttribArray(mShaderLocPosition);
        glDisableVertexAttribArray(mShaderLocTexCoord);
        glDisableVertexAttribArray(mShaderLocSelectionColor);
        glDisableVertexAttribArray(mShaderLocSelectMode);
    }
}


#pragma mark -


- (void)setTexture:(PBTexture *)aTexture
{
    [mTexture removeObserver:self forKeyPath:@"size"];
    [mTexture autorelease];
    
    mTexture = [aTexture retain];
    [mTexture addObserver:self forKeyPath:@"size" options:NSKeyValueObservingOptionNew context:NULL];

    mVertices = PBConvertVertex4FromViewSize([aTexture size]);
}


- (PBTexture *)texture
{
    return mTexture;
}


#pragma mark -


- (void)setProgramObject:(GLuint)programObject
{
    mProgramObject           = programObject;
    mShaderLocProjection     = glGetUniformLocation(mProgramObject, "aProjection");
    mShaderLocPosition       = glGetAttribLocation(mProgramObject, "aPosition");
    mShaderLocTexCoord       = glGetAttribLocation(mProgramObject, "aTexCoord");
    mShaderLocSelectionColor = glGetAttribLocation(mProgramObject, "aSelectionColor");
    mShaderLocSelectMode     = glGetAttribLocation(mProgramObject, "aSelectMode");
    mShaderLocSampler        = glGetUniformLocation(mProgramObject, "aTexture");
}


- (void)setPosition:(CGPoint)aPosition textureSize:(CGSize)aTextureSize
{
    mPosition = aPosition;
    mVertices = PBConvertVertex4FromViewSize(aTextureSize);
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


- (void)setSuperRenderable:(PBRenderable *)aRenderable
{
    mSuperRenderable = aRenderable;
}


- (PBRenderable *)superRenderable
{
    return mSuperRenderable;
}


- (NSArray *)subrenderables
{
    return [[mSubrenderables copy] autorelease];
}


- (void)setSubrenderables:(NSArray *)aSubrenderables
{
    NSArray *sOldSubrenderables = [mSubrenderables copy];

    [mSubrenderables makeObjectsPerformSelector:@selector(setSuperRenderable:) withObject:nil];
    [mSubrenderables setArray:aSubrenderables];
    [mSubrenderables makeObjectsPerformSelector:@selector(setSuperRenderable:) withObject:self];

    [sOldSubrenderables release];
}


- (void)addSubrenderable:(PBRenderable *)aRenderable
{
    NSAssert(aRenderable, @"aRenderable is nil");
    
    [aRenderable setSuperRenderable:self];
    [mSubrenderables addObject:aRenderable];
}


#pragma mark -


- (void)performRenderingWithProjection:(PBMatrix4)aProjection
{
    if (mBlendModeSFactor != GL_ONE || mBlendModeDFactor != GL_ONE_MINUS_SRC_ALPHA)
    {
        glBlendFunc(mBlendModeSFactor, mBlendModeDFactor);
    }

    glUseProgram(mProgramObject);
    PBVertex4 sVertices     = [self verticesForRendering];
    PBTransform *sTransform = [self transformForRendering];
    [self applyTransform:sTransform projection:aProjection];
    [self rendering:kPBRenderingDisplayMode vertices:sVertices];
    
    for (PBRenderable *sRenderable in mSubrenderables)
    {
        [sRenderable performRenderingWithProjection:aProjection];
    }
}


- (void)performSelectionWithProjection:(PBMatrix4)aProjection renderer:(PBRenderer *)aRenderer
{
    if (mSelectable)
    {
        [aRenderer addRenderableForSelection:self];
        
        glUseProgram(mProgramObject);
        PBVertex4 sVertices     = [self verticesForRendering];
        PBTransform *sTransform = [self transformForRendering];
        [self applyTransform:sTransform projection:aProjection];
        [self rendering:kPBRenderingSelectMode vertices:sVertices];
    }
    
    for (PBRenderable *sRenderable in mSubrenderables)
    {
        [sRenderable performSelectionWithProjection:aProjection renderer:aRenderer];
    }
}


#pragma mark -


- (void)observeValueForKeyPath:(NSString *)aKeyPath ofObject:(id)aObject change:(NSDictionary *)aChange context:(void *)aContext
{
    if ([aKeyPath isEqualToString:@"size"] && aObject == mTexture)
    {
        mVertices = PBConvertVertex4FromViewSize([mTexture size]);
    }
}


@end


