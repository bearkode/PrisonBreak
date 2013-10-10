/*
 *  SkeletonAnimationSlot.h
 *  PBKitTest
 *
 *  Created by camelkode on 13. 10. 10..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


#import <Foundation/Foundation.h>


@interface SkeletonAnimationSlot : NSObject


@property (nonatomic, readonly) NSString  *boneName;
@property (nonatomic, readonly) NSString  *attachmentName;
@property (nonatomic, readonly) NSString  *time;
@property (nonatomic, readonly) NSUInteger keyFrame;


- (id)initWithBoneName:(NSString *)aBoneName timelineData:(NSDictionary *)aTimelineData;


@end
