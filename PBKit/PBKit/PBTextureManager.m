/*
 *  PBTextureManager.m
 *  PBKit
 *
 *  Created by bearkode on 13. 2. 14..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import "PBTextureManager.h"
#import "PBObjCUtil.h"
#import "PBTexture.h"


@implementation PBTextureManager
{
    NSMutableDictionary *mTextureDict;
}


SYNTHESIZE_SHARED_INSTANCE(PBTextureManager, sharedManager)


- (id)init
{
    self = [super init];
    
    if (self)
    {
        mTextureDict = [[NSMutableDictionary alloc] initWithCapacity:10];
    }
    
    return self;
}


- (PBTexture *)textureForKey:(NSString *)aKey
{
    return [mTextureDict objectForKey:aKey];
}


- (void)setTexture:(PBTexture *)aTexture forKey:(NSString *)aKey
{
    NSAssert(aTexture, @"");
    NSAssert(aKey, @"");
    
    [mTextureDict setObject:aTexture forKey:aKey];
}


- (void)_drain
{
    [mTextureDict removeAllObjects];
}


#pragma mark -


+ (void)vacate
{
    [[PBTextureManager sharedManager] _drain];
}


+ (PBTexture *)textureWithImageName:(NSString *)aImageName
{
    NSAssert(aImageName, @"");
    
    PBTexture *sTexture = [[PBTextureManager sharedManager] textureForKey:aImageName];
    
    if (!sTexture)
    {
        sTexture = [[[PBTexture alloc] initWithImageName:aImageName] autorelease];
        [[PBTextureManager sharedManager] setTexture:sTexture forKey:aImageName];
    }
    
    return sTexture;
}


+ (PBTexture *)textureWithImage:(UIImage *)aImage key:(NSString *)aKey
{
    NSAssert(aImage, @"");
    
    PBTexture *sTexture = [[PBTextureManager sharedManager] textureForKey:aKey];
    
    if (!sTexture)
    {
        sTexture = [[[PBTexture alloc] initWithImage:aImage] autorelease];
        [[PBTextureManager sharedManager] setTexture:sTexture forKey:aKey];
    }
    
    return sTexture;
}


@end
