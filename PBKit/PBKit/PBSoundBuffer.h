/*
 *  PBSoundBuffer.h
 *  PBKit
 *
 *  Created by cgkim on 12. 4. 9..
 *  Copyright (c) 2012 PrisonBreak. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>
#import <OpenAL/al.h>


@class PBSoundData;


@interface PBSoundBuffer : NSObject
{
    NSString *mName;
    ALuint    mBuffer;
}

@property (nonatomic, readonly) ALuint buffer;

- (id)initWithName:(NSString *)aName;
- (id)initWithSoundData:(PBSoundData *)aSoundData;

@end
