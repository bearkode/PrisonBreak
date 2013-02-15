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
    PBProgram      *mProgram;
    
    CGPoint         mPosition;
    PBVertex4       mVertices;

    PBTexture      *mTexture;
    PBTransform    *mTransform;
    
    PBBlendMode     mBlendMode;
    
    GLint           mProgramLocPosition;
    GLint           mProgramLocTexCoord;
    GLint           mProgramLocSampler;
    GLint           mProgramLocProjection;
    GLint           mProgramLocSelectionColor;
    GLint           mProgramLocSelectMode;
    
    PBRenderable   *mSuperrenderable;
    NSMutableArray *mSubrenderables;
    
    NSString       *mName;
    PBColor        *mSelectionColor;
    BOOL            mSelectable;
    
    BOOL            mHidden;
}


@synthesize program    = mProgram;
@synthesize blendMode  = mBlendMode;
@synthesize transform  = mTransform;
@synthesize name       = mName;
@synthesize selectable = mSelectable;
@synthesize hidden     = mHidden;


#pragma mark -


+ (id)textureRenderableWithTexture:(PBTexture *)aTexture
{
    PBRenderable *sRenderable = [[[self alloc] initWithTexture:aTexture] autorelease];
    PBProgram    *sProgram    = [[PBProgramManager sharedManager] textureProgram];
    
    [sRenderable setProgram:sProgram];

    return sRenderable;
}


#pragma mark -


- (id)init
{
    self = [super init];
    if (self)
    {
        mBlendMode.sfactor = GL_ONE;
        mBlendMode.dfactor = GL_ONE_MINUS_SRC_ALPHA;
        mSubrenderables    = [[NSMutableArray alloc] init];
        mTransform         = [[PBTransform alloc] init];
        mPosition          = CGPointMake(0, 0);
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
    [mProgram release];
    
    [super dealloc];
}


#pragma mark - Private


- (BOOL)hasSuperRenderable
{
    return ([mSuperrenderable texture]) ? YES : NO;
}


- (PBVertex4)verticesForRendering
{
    return ([self hasSuperRenderable]) ? PBAddVertex4FromVertex3(mVertices, [mTransform translate]) : mVertices;
}


- (PBTransform *)transformForRendering
{
    return ([self hasSuperRenderable]) ? [mSuperrenderable transform] : mTransform;
}


- (void)applyTransform:(PBTransform *)aTransform projection:(PBMatrix4)aProjection
{
    PBMatrix4 sMatrix = PBMatrix4Identity;
    sMatrix = [PBTransform multiplyTranslateMatrix:sMatrix translate:[aTransform translate]];
    sMatrix = [PBTransform multiplyScaleMatrix:sMatrix scale:[aTransform scale]];
    sMatrix = [PBTransform multiplyRotateMatrix:sMatrix angle:[aTransform angle]];
    sMatrix = [PBTransform multiplyWithMatrixA:sMatrix matrixB:aProjection];
    glUniformMatrix4fv(mProgramLocProjection, 1, 0, &sMatrix.m[0][0]);
}


- (void)rendering:(PBRenderingMode)aRenderMode vertices:(PBVertex4)aVertices
{
    if (mTexture && !mHidden)
    {
        PBTextureVertices sTextureVertices = PBGeneratorTextureVertex4(aVertices);
        
        glVertexAttribPointer(mProgramLocPosition, 2, GL_FLOAT, GL_FALSE, 0, &sTextureVertices);
        glVertexAttribPointer(mProgramLocTexCoord, 2, GL_FLOAT, GL_FALSE, 0, [mTexture vertices]);
        
        if (aRenderMode == kPBRenderingSelectMode)
        {
            GLfloat sSelectionColor[3] = {[mSelectionColor red], [mSelectionColor green], [mSelectionColor blue]};
            glVertexAttrib4fv(mProgramLocSelectionColor, sSelectionColor);
            
            CGFloat sSelectMode = 1.0;
            glVertexAttribPointer(mProgramLocSelectMode, 1, GL_FLOAT, GL_FALSE, 0, &sSelectMode);
            glEnableVertexAttribArray(mProgramLocSelectMode);
        }

        glEnableVertexAttribArray(mProgramLocPosition);
        glEnableVertexAttribArray(mProgramLocTexCoord);

        glActiveTexture(GL_TEXTURE0);
        glBindTexture(GL_TEXTURE_2D, [mTexture handle]);
        glUniform1i(mProgramLocSampler, 0);

        glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_SHORT, gIndices);

        glDisableVertexAttribArray(mProgramLocPosition);
        glDisableVertexAttribArray(mProgramLocTexCoord);
        glDisableVertexAttribArray(mProgramLocSelectionColor);
        glDisableVertexAttribArray(mProgramLocSelectMode);
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


- (void)setProgram:(PBProgram *)aProgram
{
    [mProgram autorelease];
    mProgram                 = [aProgram retain];
    mProgramLocPosition       = [mProgram attributeLocation:@"aPosition"];
    mProgramLocTexCoord       = [mProgram attributeLocation:@"aTexCoord"];
    mProgramLocSelectionColor = [mProgram attributeLocation:@"aSelectionColor"];
    mProgramLocSelectMode     = [mProgram attributeLocation:@"aSelectMode"];
    mProgramLocProjection     = [mProgram uniformLocation:@"aProjection"];
    mProgramLocSampler        = [mProgram uniformLocation:@"aTexture"];
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


- (void)setSuperrenderable:(PBRenderable *)aRenderable
{
    mSuperrenderable = aRenderable;
}


- (PBRenderable *)superrenderable
{
    return mSuperrenderable;
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


- (void)removeSubrenderable:(PBRenderable *)aRenderable
{
    NSAssert(aRenderable, @"");
    
    [mSubrenderables removeObjectIdenticalTo:aRenderable];
}


- (void)removeFromSuperrenderable
{
    [mSuperrenderable removeSubrenderable:self];
    mSuperrenderable = nil;
}


#pragma mark -


- (void)performRenderingWithProjection:(PBMatrix4)aProjection
{
    if (mBlendMode.sfactor != GL_ONE || mBlendMode.dfactor != GL_ONE_MINUS_SRC_ALPHA)
    {
        glBlendFunc(mBlendMode.sfactor, mBlendMode.dfactor);
    }

    [mProgram use];
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
        
        [mProgram use];
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


#pragma mark -


- (void)setSelectionColorWithRed:(CGFloat)aRed green:(CGFloat)aGreen blue:(CGFloat)aBlue
{
    [mSelectionColor autorelease];
    mSelectionColor = [[PBColor colorWithRed:aRed green:aGreen blue:aBlue alpha:1.0f] retain];
}


@end


