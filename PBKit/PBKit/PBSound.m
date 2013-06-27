/*
 *  PBSound.m
 *  PBKit
 *
 *  Created by bearkode on 10. 2. 16..
 *  Copyright 2010 PrisonBreak. All rights reserved.
 *
 */

#import "PBSound.h"
#import "PBSoundSource.h"
#import "PBSoundBuffer.h"


@implementation PBSound


@synthesize name      = mName;
@synthesize buffer    = mBuffer;


#pragma mark -


+ (id)soundNamed:(NSString *)aName
{
    PBSound *sSound = [[[PBSound alloc] initWithName:aName] autorelease];
    
    return sSound;
}


#pragma mark -


- (id)initWithName:(NSString *)aName
{
    self = [super init];
    
    if (self)
    {
        mName   = [aName copy];
        mBuffer = [[PBSoundBuffer alloc] initWithName:mName];
    }
    
    return self;
}


- (id)initWithName:(NSString *)aName isLooping:(BOOL)aIsLooping
{
    self = [super init];
    if (self)
    {
        mName   = [aName copy];
        mBuffer = [[PBSoundBuffer alloc] initWithName:mName];
    }
    
    return self;
}


- (void)dealloc
{
    [mName release];
    [mBuffer release];
    
    [super dealloc];
}


@end
