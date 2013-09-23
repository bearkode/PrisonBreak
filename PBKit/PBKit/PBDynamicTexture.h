/*
 *  PBDynamicTexture.h
 *  PBKit
 *
 *  Created by bearkode on 13. 2. 5..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import "PBTexture.h"


@interface PBDynamicTexture : PBTexture


@property (nonatomic, assign)   id           dynamicDelegate;
@property (nonatomic, readonly) CGContextRef context;


- (id)initWithSize:(CGSize)aSize scale:(CGFloat)aScale;

- (void)update;
- (void)setSize:(CGSize)aSize;

- (void)drawInRect:(CGRect)aRect context:(CGContextRef)aContext;

@end


@protocol PBDynamicTextureDelegate <NSObject>

- (void)texture:(PBDynamicTexture *)aTexture didChangeContext:(CGContextRef)aContext;
- (void)texture:(PBDynamicTexture *)aTexture drawInRect:(CGRect)aRect context:(CGContextRef)aContext;

@end