/*
 *  PBSoundData.h
 *  PBKit
 *
 *  Created by bearkode on 12. 4. 9..
 *  Copyright (c) 2012 PrisonBreak. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>
#import <OpenAL/al.h>


@interface PBSoundData : NSObject
{
    ALenum  mFormat;
    void   *mData;    
    ALsizei mSize;
    ALsizei mFreq;
}


@property (nonatomic, readonly) ALenum  format;
@property (nonatomic, readonly) void   *data;
@property (nonatomic, readonly) ALsizei size;
@property (nonatomic, readonly) ALsizei freq;


- (id)initWithPath:(NSString *)aPath;


@end
