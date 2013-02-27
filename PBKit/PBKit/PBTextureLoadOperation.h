/*
 *  PBTextureLoadOperation.h
 *  PBKit
 *
 *  Created by bearkode on 13. 1. 28..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>


@class PBTexture;


@interface PBTextureLoadOperation : NSOperation

@property (nonatomic, readonly) PBTexture *texture;

+ (id)operationWithTexture:(PBTexture *)aTexture;

- (id)initWithTexture:(PBTexture *)aTexture;

@end
