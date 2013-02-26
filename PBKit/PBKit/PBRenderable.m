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
    PBMatrix        mProjection;
    PBTexture      *mTexture;
    PBTransform    *mTransform;
    PBBlendMode     mBlendMode;
    
    PBRenderable   *mSuperrenderable;
    NSMutableArray *mSubrenderables;
    
    NSString       *mName;
    CGPoint         mPosition;
    PBColor        *mSelectionColor;
    BOOL            mSelectable;
    BOOL            mHidden;
    
    GLuint          mVertexArrayIndex;
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
        mTransform         = [[PBTransform alloc] init];
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


- (void)applyTransform
{
    PBMatrix sMatrix = PBMatrixIdentity;
    sMatrix = [PBMatrixOperator translateMatrix:sMatrix translate:[mTransform translate]];
    sMatrix = [PBMatrixOperator scaleMatrix:sMatrix scale:[mTransform scale]];
    sMatrix = [PBMatrixOperator rotateMatrix:sMatrix angle:[mTransform angle]];
    sMatrix = [PBMatrixOperator multiplyMatrixA:sMatrix matrixB:mProjection];

    glUniformMatrix4fv([mProgram location].projectionLoc, 1, 0, &sMatrix.m[0][0]);
    [self setProjection:sMatrix];
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


- (void)render
{
    if (mTexture && !mHidden)
    {
        glBindTexture(GL_TEXTURE_2D, [mTexture handle]);
        glBindVertexArrayOES(mVertexArrayIndex);
        glDrawElements(GL_TRIANGLE_STRIP, sizeof(gIndices)/sizeof(gIndices[0]), GL_UNSIGNED_BYTE, 0);
    }
}


#pragma mark -


- (void)setTextureVertexBufferAndArray
{
    GLuint sVertexBuffer;
    GLuint sIndexBuffer;
    glGenVertexArraysOES(1, &mVertexArrayIndex);
    glBindVertexArrayOES(mVertexArrayIndex);
    
    glGenBuffers(1, &sVertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, sVertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(PBMesh) * sizeof([mTexture textureMesh]), [mTexture textureMesh], GL_STATIC_DRAW);
    
    glGenBuffers(1, &sIndexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, sIndexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(gIndices), gIndices, GL_STATIC_DRAW);
    
    glVertexAttribPointer([mProgram location].positionLoc, 2, GL_FLOAT, GL_FALSE, sizeof(PBMesh), 0);
    glVertexAttribPointer([mProgram location].texCoordLoc, 2, GL_FLOAT, GL_FALSE, sizeof(PBMesh), (GLvoid*) (sizeof(float) * 2));
    
    glEnableVertexAttribArray([mProgram location].positionLoc);
    glEnableVertexAttribArray([mProgram location].texCoordLoc);
    
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindVertexArrayOES(0);
}


- (void)setTexture:(PBTexture *)aTexture
{
    [mTexture removeObserver:self forKeyPath:@"size"];
    [mTexture autorelease];
    
    mTexture = [aTexture retain];
    [mTexture addObserver:self forKeyPath:@"size" options:NSKeyValueObservingOptionNew context:NULL];
    
    [self setTextureVertexBufferAndArray];
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

    [mProgram use];
}


- (void)setPosition:(CGPoint)aPosition textureSize:(CGSize)aTextureSize
{
    mPosition = aPosition;
    [[self transform] setTranslate:PBVertex3Make(mPosition.x, mPosition.y, 0)];

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


- (void)performRender
{
    if (mBlendMode.sfactor != GL_ONE || mBlendMode.dfactor != GL_ONE_MINUS_SRC_ALPHA)
    {
        glBlendFunc(mBlendMode.sfactor, mBlendMode.dfactor);
    }
    [self applyTransform];
    [self applyColorMode:kPBRenderDisplayMode];
    [self render];
    
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
        [aRenderer addRenderableForSelection:self];
        
        [self applyTransform];
        [self applySelectMode:kPBRenderSelectMode];
        [self applyColorMode:kPBRenderSelectMode];
        [self render];
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
    }
}


#pragma mark -


- (void)setSelectionColorWithRed:(CGFloat)aRed green:(CGFloat)aGreen blue:(CGFloat)aBlue
{
    [mSelectionColor autorelease];
    mSelectionColor = [[PBColor colorWithRed:aRed green:aGreen blue:aBlue alpha:1.0f] retain];
}


@end


