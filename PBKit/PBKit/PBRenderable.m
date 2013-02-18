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
    
    PBRenderable   *mSuperrenderable;
    NSMutableArray *mSubrenderables;
    
    NSString       *mName;
    PBColor        *mSelectionColor;
    BOOL            mSelectable;
    BOOL            mHidden;
    
    GLint           mProgramLocPosition;
    GLint           mProgramLocTexCoord;
    GLint           mProgramLocProjection;
    GLint           mProgramLocSelectionColor;
    GLint           mProgramLocSelectMode;
    GLint           mProgramLocScale;
    GLint           mProgramLocAngle;
    GLint           mProgramLocTranslate;
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
    PBProgram    *sProgram    = [[PBProgramManager sharedManager] bundleProgram];
    
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
    [PBContext performBlockOnMainThread:^{
        CGFloat sScale        = [aTransform scale];
        CGFloat sAngle[3]     = {[aTransform angle].x, [aTransform angle].y, [aTransform angle].z};
        CGFloat sTranslate[3] = {[aTransform translate].x, [aTransform translate].y, [aTransform translate].z};
        
        glUniformMatrix4fv(mProgramLocProjection, 1, 0, &aProjection.m[0][0]);
        glVertexAttrib1f(mProgramLocScale, sScale);
        glVertexAttrib3fv(mProgramLocAngle, &sAngle[0]);
        glVertexAttrib3fv(mProgramLocTranslate, &sTranslate[0]);
    }];
}


- (void)applySelectMode:(PBRenderingMode)aRenderMode
{
    [PBContext performBlockOnMainThread:^{
        
        CGFloat sSelectMode = 0.0;
        if (aRenderMode == kPBRenderingSelectMode)
        {
            GLfloat sSelectionColor[3] = {[mSelectionColor red], [mSelectionColor green], [mSelectionColor blue]};
            glVertexAttrib4fv(mProgramLocSelectionColor, sSelectionColor);
            
            sSelectMode = 1.0;
        }
        
        glVertexAttrib1f(mProgramLocSelectMode, sSelectMode);
    }];
}

- (void)renderingVertices:(PBVertex4)aVertices
{
    PBTextureVertices sTextureVertices = PBGeneratorTextureVertex4(aVertices);
    
    glVertexAttribPointer(mProgramLocPosition, 2, GL_FLOAT, GL_FALSE, 0, &sTextureVertices);
    glVertexAttribPointer(mProgramLocTexCoord, 2, GL_FLOAT, GL_FALSE, 0, [mTexture vertices]);
    glEnableVertexAttribArray(mProgramLocPosition);
    glEnableVertexAttribArray(mProgramLocTexCoord);
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, [mTexture handle]);
    
    glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_SHORT, gIndices);
    
    glDisableVertexAttribArray(mProgramLocPosition);
    glDisableVertexAttribArray(mProgramLocTexCoord);
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
    mProgram = [aProgram retain];
    
    [PBContext performBlockOnMainThread:^{
        mProgramLocProjection     = [mProgram uniformLocation:@"aProjection"];
        mProgramLocPosition       = [mProgram attributeLocation:@"aPosition"];
        mProgramLocTexCoord       = [mProgram attributeLocation:@"aTexCoord"];
        mProgramLocSelectionColor = [mProgram attributeLocation:@"aSelectionColor"];
        mProgramLocSelectMode     = [mProgram attributeLocation:@"aSelectMode"];
        mProgramLocScale          = [mProgram attributeLocation:@"aScale"];
        mProgramLocAngle          = [mProgram attributeLocation:@"aAngle"];
        mProgramLocTranslate      = [mProgram attributeLocation:@"aTranslate"];

    }];
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
        [PBContext performBlockOnMainThread:^{
            glBlendFunc(mBlendMode.sfactor, mBlendMode.dfactor);
        }];
    }

    if (mTexture && !mHidden)
    {
        [mProgram use];
        PBVertex4 sVertices     = [self verticesForRendering];
        PBTransform *sTransform = [self transformForRendering];
        [self applyTransform:sTransform projection:aProjection];
        [self applySelectMode:kPBRenderingDisplayMode];
        [self renderingVertices:sVertices];        
    }
    
    for (PBRenderable *sRenderable in mSubrenderables)
    {
        [sRenderable performRenderingWithProjection:aProjection];
    }
}


- (void)performSelectionWithProjection:(PBMatrix4)aProjection renderer:(PBRenderer *)aRenderer
{
    if (mSelectable)
    {
        if (mTexture && !mHidden)
        {
            [aRenderer addRenderableForSelection:self];
            
            [mProgram use];
            PBVertex4 sVertices     = [self verticesForRendering];
            PBTransform *sTransform = [self transformForRendering];
            [self applyTransform:sTransform projection:aProjection];
            [self applySelectMode:kPBRenderingSelectMode];
            [self renderingVertices:sVertices];            
        }
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


