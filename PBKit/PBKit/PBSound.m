/*
 *  PBSound.m
 *  PBKit
 *
 *  Created by cgkim on 10. 2. 16..
 *  Copyright 2010 PrisonBreak. All rights reserved.
 *
 */

#import "PBSound.h"
#import "PBSoundSource.h"
#import "PBSoundBuffer.h"


@implementation PBSound


@synthesize name      = mName;
//@synthesize source    = mSource;
@synthesize buffer    = mBuffer;
//@synthesize position  = mPosition;
//@synthesize isPlaying = mIsPlaying;
//@synthesize isLooping = mIsLooping;


#pragma mark -


+ (id)soundNamed:(NSString *)aName
{
    PBSound *sSound = [[[PBSound alloc] initWithName:aName] autorelease];
    
    return sSound;
}


#pragma mark -


//- (void)setupSource
//{
//	float sSourcePos[] = { mPosition.x, mDistance, mPosition.y };
//    
//    [mSource setLooping:mIsLooping];
//    [mSource setPositionfv:sSourcePos];
//    [mSource setDistance:50.0f];
//    [mSource setBuffer:mBuffer];
//}


#pragma mark -


- (id)initWithName:(NSString *)aName
{
    self = [super init];
    
    if (self)
    {
        mName = [aName copy];
        
//        mDistance  = 25.0;
//        mPosition  = CGPointMake(0, 0);
//        mIsPlaying = NO;
//        mIsLooping = NO;
        
//        mSource = [[PBSoundSource alloc] init];
        mBuffer = [[PBSoundBuffer alloc] initWithName:mName];
        
//        [self setupSource];
    }
    
    return self;
}


- (id)initWithName:(NSString *)aName isLooping:(BOOL)aIsLooping
{
    self = [super init];
    if (self)
    {
        mName = [aName copy];
        
//        mDistance  = 25.0;
//        mPosition  = CGPointMake(0, 0);
//        mIsPlaying = NO;
//        mIsLooping = aIsLooping;
//        
//        mSource = [[PBSoundSource alloc] init];
        mBuffer = [[PBSoundBuffer alloc] initWithName:mName];
        
//        [self setupSource];
    }
    
    return self;
}


- (void)dealloc
{
    [mName release];

//    [mSource release];
    [mBuffer release];
    
    [super dealloc];
}


#pragma mark -


//- (void)setLooping:(BOOL)aLooping
//{
//    mIsLooping = aLooping;
//    [mSource setLooping:mIsLooping];
//}
//
//
//- (void)play
//{
//    [mSource play];
//    mIsPlaying = YES;
//}
//
//
//- (void)stop
//{
//    [mSource stop];
//    mIsPlaying = NO;
//}


@end
