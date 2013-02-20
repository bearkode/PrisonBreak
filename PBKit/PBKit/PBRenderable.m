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
    PBBundleLoc     mBundleProgramLoc;

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


- (void)bindingProgramLocation
{
    mBundleProgramLoc.projectionLoc     = [mProgram uniformLocation:@"aProjection"];
    mBundleProgramLoc.positionLoc       = [mProgram attributeLocation:@"aPosition"];
    mBundleProgramLoc.texCoordLoc       = [mProgram attributeLocation:@"aTexCoord"];
    mBundleProgramLoc.colorLoc          = [mProgram attributeLocation:@"aColor"];
    mBundleProgramLoc.selectionColorLoc = [mProgram attributeLocation:@"aSelectionColor"];
    mBundleProgramLoc.selectModeLoc     = [mProgram attributeLocation:@"aSelectMode"];
    mBundleProgramLoc.scaleLoc          = [mProgram attributeLocation:@"aScale"];
    mBundleProgramLoc.angleLoc          = [mProgram attributeLocation:@"aAngle"];
    mBundleProgramLoc.translateLoc      = [mProgram attributeLocation:@"aTranslate"];
    
    mBundleProgramLoc.grayFilterLoc     = [mProgram attributeLocation:@"aGrayScaleFilter"];
    mBundleProgramLoc.sepiaFilterLoc    = [mProgram attributeLocation:@"aSepiaFilter"];
    mBundleProgramLoc.lumiFilterLoc     = [mProgram attributeLocation:@"aLuminanceFilter"];
    mBundleProgramLoc.blurFilterLoc     = [mProgram attributeLocation:@"aBlurFilter"];
}


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
        sTransform         = sSuperTransform;
        mPivotPosition     = mPosition;
        sTranslate         = [mSuperrenderable translate];
        sVertices          = PBTranslateVertex(mVertices, PBVertex3Make([mSuperrenderable pivotPosition].x + mPosition.x,
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
    glVertexAttrib3fv(mBundleProgramLoc.translateLoc, &vTranslate[0]);
    glUniformMatrix4fv(mBundleProgramLoc.projectionLoc, 1, 0, &mProjection.m[0][0]);
    glVertexAttrib1f(mBundleProgramLoc.scaleLoc, sScale);
    glVertexAttrib3fv(mBundleProgramLoc.angleLoc, &vAngle[0]);
    glVertexAttrib1f(mBundleProgramLoc.blurFilterLoc, [mTransform blurEffect]);
    glVertexAttrib1f(mBundleProgramLoc.grayFilterLoc, [mTransform grayScaleEffect]);
    glVertexAttrib1f(mBundleProgramLoc.sepiaFilterLoc, [mTransform sepiaEffect]);
    glVertexAttrib1f(mBundleProgramLoc.lumiFilterLoc, [mTransform luminanceEffect]);
    
    return sVertices;
}


- (void)applySelectMode:(PBRenderMode)aRenderMode
{
    CGFloat sSelectMode = 0.0;
    if (aRenderMode == kPBRenderSelectMode)
    {
        GLfloat sSelectionColor[4] = {[mSelectionColor red], [mSelectionColor green], [mSelectionColor blue], [mSelectionColor alpha]};
        glVertexAttrib4fv(mBundleProgramLoc.selectionColorLoc, sSelectionColor);
        
        sSelectMode = 1.0;
    }
    
    glVertexAttrib1f(mBundleProgramLoc.selectModeLoc, sSelectMode);
}


- (void)applyColorMode:(PBRenderMode)aRenderMode
{
    if (aRenderMode == kPBRenderSelectMode)
    {
        GLfloat sColors[4] = {1.0, 1.0, 1.0, 1.0};
        glVertexAttrib4fv(mBundleProgramLoc.colorLoc, sColors);
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
            glVertexAttrib4fv(mBundleProgramLoc.colorLoc, sColors);
        }
        else
        {
            GLfloat sColors[4] = {1.0, 1.0, 1.0, 1.0};
            glVertexAttrib4fv(mBundleProgramLoc.colorLoc, sColors);
        }        
    }
}


- (void)renderWithVertices:(PBVertex4)aVertices
{
    if (mTexture && !mHidden)
    {
        PBTextureVertices sTextureVertices = PBGeneratorTextureVertex4(aVertices);
        glVertexAttribPointer(mBundleProgramLoc.positionLoc, 2, GL_FLOAT, GL_FALSE, 0, &sTextureVertices);
        glVertexAttribPointer(mBundleProgramLoc.texCoordLoc, 2, GL_FLOAT, GL_FALSE, 0, [mTexture vertices]);
        glEnableVertexAttribArray(mBundleProgramLoc.positionLoc);
        glEnableVertexAttribArray(mBundleProgramLoc.texCoordLoc);
    
        glActiveTexture(GL_TEXTURE0);
        glBindTexture(GL_TEXTURE_2D, [mTexture handle]);
    
        glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_SHORT, gIndices);
    
        glDisableVertexAttribArray(mBundleProgramLoc.positionLoc);
        glDisableVertexAttribArray(mBundleProgramLoc.texCoordLoc);
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
    mProgram = [aProgram retain];
    
    [PBContext performBlockOnMainThread:^{
        [self bindingProgramLocation];
    }];
}


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
        [PBContext performBlockOnMainThread:^{
            glBlendFunc(mBlendMode.sfactor, mBlendMode.dfactor);
        }];
    }

    [PBContext performBlockOnMainThread:^{
        [mProgram use];
        PBVertex4 sVertices = [self applyTransform];
        [self applySelectMode:kPBRenderDisplayMode];
        [self applyColorMode:kPBRenderDisplayMode];
        
        [self renderWithVertices:sVertices];
    }];
    
    for (PBRenderable *sRenderable in mSubrenderables)
    {
        [sRenderable setProjection:mProjection];
        [sRenderable performRender];
    }
}


- (void)performSelectionWithRenderer:(PBRenderer *)aRenderer
{
    if (mSelectable)
    {
        [PBContext performBlockOnMainThread:^{
            [aRenderer addRenderableForSelection:self];
            
            [mProgram use];

            PBVertex4 sVertices = [self applyTransform];
            [self applySelectMode:kPBRenderSelectMode];
            [self applyColorMode:kPBRenderSelectMode];
            [self renderWithVertices:sVertices];
        }];
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


