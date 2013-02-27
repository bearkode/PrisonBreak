/*
 *  Map.h
 *  PBKitTest
 *
 *  Created by bearkode on 13. 2. 19..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import <PBKit.h>


@interface Map : PBLayer


@property (nonatomic, readonly) CGSize mapSize;
@property (nonatomic, readonly) CGSize tileSize;


- (id)initWithMapSize:(CGSize)aMapSize tileImage:(UIImage *)aImage tileSize:(CGSize)aTileSize indexArray:(NSArray *)aIndexArray;

- (CGRect)bounds;
- (void)setVisibleRect:(CGRect)aRect;

@end
