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
    PBMatrix4       mProjection;
    
    CGPoint         mPosition;
    PBVertex4       mVertices;
    PBTexture      *mTexture;
    
    PBTransform    *mTransform;
    PBVertex3       mTranslate;
    PBBlendMode     mBlendMode;
    CGPoint         mPivotPosition;
    
    PBRenderable   *mSuperrenderable;
    NSMutableArray *mSubrenderables;
    
    NSString       *mName;
    PBColor        *mSelectionColor;
    BOOL            mSelectable;
    BOOL            mHidden;
}


@synthesize program    = mProgram;
@synthesize projection = mProjection;
@synthesize transform  = mTransform;
@synthesize blendMode  = mBlendMode;
@synthesize name       = mName;
@synthesize selectable = mSelectable;
@synthesize hidden     = mHidden;


#pragma mark -


+ (id)textureRenderableWithTexture:(PBTexture *)aTexture
{
    PBRenderable *sRenderable = [[[self alloc] initWithTexture:aTexture] autorelease];
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
    
    [super dealloc];
}


#pragma mark - Private


- (PBVertex4)applyTransform
{
    PBVertex4    sVertices       = mVertices;
    PBTransform *sTransform      = mTransform;
    PBTransform *sSuperTransform = [mSuperrenderable transform];
    PBVertex3    sTranslate      = PBVertex3Make([mSuperrenderable translate].x + mPosition.x,
                                                 [mSuperrenderable translate].y + mPosition.y,
                                                 0);
    CGFloat      sScale          = [PBTransform defaultScale];
    PBVertex3    sAngle          = PBVertex3Make(0, 0, 0);
    mPivotPosition               = CGPointMake(0, 0);

    if (sSuperTransform)
    {
        sTransform     = sSuperTransform;
        mPivotPosition = mPosition;
        sTranslate     = [mSuperrenderable translate];
        sVertices      = PBTranslateVertex(mVertices, PBVertex3Make([mSuperrenderable pivotPosition].x + mPosition.x,
                                                                        [mSuperrenderable pivotPosition].y + mPosition.y,
                                                                        0));
    }
    
    if (sTransform)
    {
        sScale = [sTransform scale];
        sAngle = [sTransform angle];
        [self setTransform:sTransform];
    }
    
    mTranslate = sTranslate;

    CGFloat vTranslate[3] = {sTranslate.x, sTranslate.y, sTranslate.z};
    CGFloat vAngle[3]     = {sAngle.x, sAngle.y, sAngle.z};
    
    glVertexAttrib3fv([mProgram location].translateLoc, &vTranslate[0]);
    glUniformMatrix4fv([mProgram location].projectionLoc, 1, 0, &mProjection.m[0][0]);
    glVertexAttrib1f([mProgram location].scaleLoc, sScale);
    glVertexAttrib3fv([mProgram location].angleLoc, &vAngle[0]);
    //    glVertexAttrib1f([mProgram location].blurFilterLoc, [mTransform blurEffect]);
    //    glVertexAttrib1f([mProgram location].grayFilterLoc, [mTransform grayScaleEffect]);
    //    glVertexAttrib1f([mProgram location].sepiaFilterLoc, [mTransform sepiaEffect]);
    //    glVertexAttrib1f([mProgram location].lumiFilterLoc, [mTransform luminanceEffect]);
    
    
    return sVertices;
}


- (void)applySelectMode:(PBRenderMode)aRenderMode
{
    CGFloat sSelectMode = 0.0;
    if (aRenderMode == kPBRenderSelectMode)
    {
        GLfloat sSelectionColor[4] = {[mSelectionColor red], [mSelectionColor green], [mSelectionColor blue], [mSelectionColor alpha]};
        glVertexAttrib4fv([mProgram location].selectionColorLoc, sSelectionColor);
        
        sSelectMode = 1.0;
    }
    
    glVertexAttrib1f([mProgram location].selectModeLoc, sSelectMode);
}


- (void)applyColorMode:(PBRenderMode)aRenderMode
{
    if (aRenderMode == kPBRenderSelectMode)
    {
        GLfloat sColors[4] = {1.0, 1.0, 1.0, 1.0};
        glVertexAttrib4fv([mProgram location].colorLoc, sColors);
    }
    else
    {
        PBColor *sColor = [[mSuperrenderable transform] color];
        if (!sColor && [mTransform color])
        {
            sColor = [mTransform color];
        }
        
        if (sColor)
        {
            GLfloat sColors[4] = {[sColor red], [sColor green], [sColor blue], [sColor alpha]};
            glVertexAttrib4fv([mProgram location].colorLoc, sColors);
        }
        else
        {
            GLfloat sColors[4] = {1.0, 1.0, 1.0, 1.0};
            glVertexAttrib4fv([mProgram location].colorLoc, sColors);
        }        
    }
}


- (void)renderWithVertices:(PBVertex4)aVertices
{
    if (mTexture && !mHidden)
    {
        PBTextureVertices sTextureVertices = PBGeneratorTextureVertex4(aVertices);
        glVertexAttribPointer([mProgram location].positionLoc, 2, GL_FLOAT, GL_FALSE, 0, &sTextureVertices);
        glVertexAttribPointer([mProgram location].texCoordLoc, 2, GL_FLOAT, GL_FALSE, 0, [mTexture vertices]);
        glEnableVertexAttribArray([mProgram location].positionLoc);
        glEnableVertexAttribArray([mProgram location].texCoordLoc);

        glActiveTexture(GL_TEXTURE0);
        glBindTexture(GL_TEXTURE_2D, [mTexture handle]);
        glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_SHORT, gIndices);
    
        glDisableVertexAttribArray([mProgram location].positionLoc);
        glDisableVertexAttribArray([mProgram location].texCoordLoc);
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


- (void)setPosition:(CGPoint)aPosition textureSize:(CGSize)aTextureSize
{
    mPosition  = aPosition;
    mVertices  = PBConvertVertex4FromViewSize(aTextureSize);
}


- (void)setPosition:(CGPoint)aPosition
{
    [self setPosition:aPosition textureSize:[mTexture size]];
}


- (CGPoint)position
{
    return mPosition;
}


- (PBVertex3)translate
{
    return mTranslate;
}


- (CGPoint)pivotPosition
{
    return mPivotPosition;
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


- (void)performRender
{
    if (mBlendMode.sfactor != GL_ONE || mBlendMode.dfactor != GL_ONE_MINUS_SRC_ALPHA)
    {
        glBlendFunc(mBlendMode.sfactor, mBlendMode.dfactor);
    }

    [self applyColorMode:kPBRenderDisplayMode];
    [self renderWithVertices:[self applyTransform]];
    
    for (PBRenderable *sRenderable in mSubrenderables)
    {
        [sRenderable setProjection:mProjection];
        [sRenderable setProgram:mProgram];
        [sRenderable performRender];
    }
}


- (void)performSelectionWithRenderer:(PBRenderer *)aRenderer
{
    if (mSelectable)
    {
        [aRenderer addRenderableForSelection:self];
        
        PBVertex4 sVertices = [self applyTransform];
        [self applySelectMode:kPBRenderSelectMode];
        [self applyColorMode:kPBRenderSelectMode];
        [self renderWithVertices:sVertices];
    }
    
    for (PBRenderable *sRenderable in mSubrenderables)
    {
        [sRenderable setProjection:mProjection];
        [sRenderable performSelectionWithRenderer:aRenderer];
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


