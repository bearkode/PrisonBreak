/*
 *  PBLayer.h
 *  PBKit
 *
 *  Created by camelkode on 13. 1. 4..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import "PBTransform.h"
#import "PBProgramManager.h"
#import "PBMatrix.h"


typedef enum
{
    kPBRenderDisplayMode = 1,
    kPBRenderSelectMode  = 2,
} PBRenderMode;


typedef struct {
    GLenum sfactor;
    GLenum dfactor;
} PBBlendMode;


@class PBTexture;
@class PBTransform;
@class PBRenderer;


@interface PBLayer : NSObject


@property (nonatomic, assign)                PBProgram   *program;
@property (nonatomic, assign)                PBMatrix     projection;
@property (nonatomic, assign)                PBBlendMode  blendMode;
@property (nonatomic, retain)                PBTransform *transform;
@property (nonatomic, retain)                NSString    *name;
@property (nonatomic, getter = isSelectable) BOOL         selectable;
@property (nonatomic, assign)                BOOL         hidden;


#pragma mark -


+ (id)textureRenderableWithTexture:(PBTexture *)aTexture;


#pragma mark -


- (id)initWithTexture:(PBTexture *)aTexture;


#pragma mark -


- (void)setTexture:(PBTexture *)aTexture;
- (PBTexture *)texture;


#pragma mark -


- (void)setPosition:(CGPoint)aPosition textureSize:(CGSize)aTextureSize;
- (void)setPosition:(CGPoint)aPosition;
- (CGPoint)position;


#pragma mark -


- (void)setSuperrenderable:(PBLayer *)aRenderable;
- (PBLayer *)superrenderable;

- (NSArray *)subrenderables;
- (void)setSubrenderables:(NSArray *)aSubrenderables;

- (void)addSubrenderable:(PBLayer *)aRenderable;
- (void)removeSubrenderable:(PBLayer *)aRenderable;

- (void)removeFromSuperrenderable;


#pragma mark -


- (void)performRender;
- (void)performSelectionWithRenderer:(PBRenderer *)aRenderer;


#pragma mark -


- (void)setSelectionColorWithRed:(CGFloat)aRed green:(CGFloat)aGreen blue:(CGFloat)aBlue;


@end
