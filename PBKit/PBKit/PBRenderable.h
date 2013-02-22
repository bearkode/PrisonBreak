/*
 *  PBRenderable.h
 *  PBKit
 *
 *  Created by camelkode on 13. 1. 4..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import "PBTransform.h"
#import "PBProgramManager.h"


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


@interface PBRenderable : NSObject


@property (nonatomic, assign)                PBProgram   *program;
@property (nonatomic, assign)                PBMatrix4    projection;
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


- (PBVertex3)translate;


#pragma mark -


- (void)setSuperrenderable:(PBRenderable *)aRenderable;
- (PBRenderable *)superrenderable;

- (NSArray *)subrenderables;
- (void)setSubrenderables:(NSArray *)aSubrenderables;

- (void)addSubrenderable:(PBRenderable *)aRenderable;
- (void)removeSubrenderable:(PBRenderable *)aRenderable;

- (void)removeFromSuperrenderable;


#pragma mark -


- (void)performRender;
- (void)performSelectionWithRenderer:(PBRenderer *)aRenderer;


#pragma mark -


- (void)setSelectionColorWithRed:(CGFloat)aRed green:(CGFloat)aGreen blue:(CGFloat)aBlue;


@end
