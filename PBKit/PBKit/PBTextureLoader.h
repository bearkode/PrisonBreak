/*
 *  PBTextureLoader.h
 *  PBKit
 *
 *  Created by bearkode on 13. 1. 25..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>


@class PBTexture;


@interface PBTextureLoader : NSObject


@property (nonatomic, assign) id delegate;


- (void)setMaxConcurrentOperationCount:(NSInteger)aCount;
- (void)addTexture:(PBTexture *)aTexture;
- (void)load;
- (void)cancel;

- (BOOL)isSuspended;
- (void)setSuspended:(BOOL)aSuspended;


@end


@protocol PBTextureLoaderDelegate <NSObject>


- (void)textureLoaderWillStartLoad:(PBTextureLoader *)aLoader;
- (void)textureLoaderDidFinishLoad:(PBTextureLoader *)aLoader;
- (void)textureLoaderDidCancelLoad:(PBTextureLoader *)aLoader;

- (void)textureLoader:(PBTextureLoader *)aLoader progress:(CGFloat)aProgress;
- (void)textureLoader:(PBTextureLoader *)aLoader didFinishLoadTexture:(PBTexture *)aTexture;
- (void)textureLoader:(PBTextureLoader *)aLoader didFailLoadTexture:(PBTexture *)aTexture;


@end
