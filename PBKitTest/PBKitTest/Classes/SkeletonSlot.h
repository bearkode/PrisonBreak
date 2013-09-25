/*
 *  SkeletonSlot.m
 *  PBKitTest
 *
 *  Created by camelkode on 13. 8. 29..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


#import <Foundation/Foundation.h>


@interface SkeletonSlot : NSObject


@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *boneName;
@property (nonatomic, readonly) NSString *attachment;


- (id)initWithSlotData:(NSDictionary *)aSlotData;


@end
