/*
 *  IsoMap.h
 *  PBKitTest
 *
 *  Created by bearkode on 13. 2. 21..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import <PBKit.h>


@interface IsoMap : PBNode


@property (nonatomic, readonly) CGRect bounds;


- (id)initWithContentsOfFile:(NSString *)aPath;


@end
