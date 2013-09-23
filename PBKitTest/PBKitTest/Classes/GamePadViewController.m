/*
 *  GamePadViewController.m
 *  PBKitTest
 *
 *  Created by cgkim on 13. 8. 30..
 *  Copyright (c) 2013 NHN. All rights reserved.
 *
 */

#import "GamePadViewController.h"
#import <GameController/GameController.h>


@implementation GamePadViewController
{
    GCGamepad       *mGamePad;
    
    PBTexture       *mCenterTexture;
    PBTexture       *mLeftTexture;
    PBTexture       *mRightTexture;
    
    PBScene         *mScene;
    PBSpriteNode    *mNode;
    
    NSMutableArray  *mBullets;
    NSMutableArray  *mAliens;
    
    BOOL             mAButtonPressed;
    
    CGPoint          mDPadPoint;
    
    NSInteger        mTime;
    
    /*  GameController  */
    CGPoint         mDpadPoint;
}


- (id)initWithNibName:(NSString *)aNibNameOrNil bundle:(NSBundle *)aNibBundleOrNil
{
    self = [super initWithNibName:aNibNameOrNil bundle:aNibBundleOrNil];

    if (self)
    {
        NSNotificationCenter *sNotiCenter = [NSNotificationCenter defaultCenter];
        [sNotiCenter addObserver:self selector:@selector(gamePadDidConnectNotification:) name:GCControllerDidConnectNotification object:nil];
        [sNotiCenter addObserver:self selector:@selector(gamePadDidDisconnectNotification:) name:GCControllerDidDisconnectNotification object:nil];
        
        mCenterTexture = [[PBTextureManager textureWithImageName:@"3fc"] retain];
        mLeftTexture   = [[PBTextureManager textureWithImageName:@"3fl"] retain];
        mRightTexture  = [[PBTextureManager textureWithImageName:@"3fr"] retain];
        
        mScene = [[PBScene alloc] initWithDelegate:self];
        mNode = [[PBSpriteNode alloc] initWithImageNamed:@"airship"];
        [mNode setScale:0.09];
        
        mBullets = [[NSMutableArray alloc] init];
        mAliens  = [[NSMutableArray alloc] init];
    }
    
    return self;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [mScene release];
    
    [mCenterTexture release];
    [mLeftTexture release];
    [mRightTexture release];
    
    [mNode release];
    [mBullets release];
    [mAliens release];

    [[mGamePad dpad] setValueChangedHandler:NULL];
    [[mGamePad leftShoulder] setValueChangedHandler:NULL];
    [[mGamePad rightShoulder] setValueChangedHandler:NULL];
    [[mGamePad buttonA] setValueChangedHandler:NULL];
    [[mGamePad buttonB] setValueChangedHandler:NULL];
    [[mGamePad buttonX] setValueChangedHandler:NULL];
    [[mGamePad buttonY] setValueChangedHandler:NULL];
    
    [mGamePad release];
    
    [super dealloc];
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    NSArray *sGameControllers = [GCController controllers];
    NSLog(@"%@", [NSString stringWithFormat:@"controllers = [%@]", sGameControllers]);
    
    if ([sGameControllers count])
    {
        [self setGamePad:[[sGameControllers objectAtIndex:0] gamepad]];
    }
    
    [[self canvas] presentScene:mScene];
    [mScene addSubNode:mNode];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)viewWillAppear:(BOOL)aAnimated
{
    [super viewWillAppear:aAnimated];
    
    mTime = 0;
    [[self navigationController] setNavigationBarHidden:YES];
}


- (void)viewWillDisappear:(BOOL)aAnimated
{
    [super viewWillDisappear:aAnimated];
    
    [[self navigationController] setNavigationBarHidden:NO];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)aToInterfaceOrientation
{
    if (aToInterfaceOrientation == UIInterfaceOrientationLandscapeLeft)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}



- (BOOL)shouldAutorotate
{
    return YES;
}


- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeLeft;
}


- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeLeft;
}


#pragma mark -


- (void)airshipPositionDidChange:(CGPoint)aPoint
{
    mDPadPoint.x = aPoint.x * 6;
    mDPadPoint.y = aPoint.y * 6;
}


- (void)fireBullet
{
    PBSpriteNode *sBullet = [[[PBSpriteNode alloc] initWithImageNamed:@"bullet"] autorelease];
    
    CGPoint sNodePoint = [mNode point];
    
    sNodePoint.y += 10;
    
    [sBullet setPoint:sNodePoint];
    [mScene addSubNode:sBullet];
    
    [mBullets addObject:sBullet];
}


- (void)setGamePad:(GCGamepad *)aGamePad
{
    [mGamePad autorelease];
    mGamePad = [aGamePad retain];

#if (0)
    __block typeof(self)  sSelf = self;
    __block typeof(mNode) sNode = mNode;

    [[mGamePad dpad] setValueChangedHandler:^(GCControllerDirectionPad *aDpad, float aXValue, float aYValue) {
        [sSelf airshipPositionDidChange:CGPointMake(aXValue, aYValue)];
    }];
    
    [[mGamePad buttonA] setValueChangedHandler:^(GCControllerButtonInput *aButton, float aValue, BOOL aPressed) {
        [sSelf log:[NSString stringWithFormat:@"buttonA : v = %f, pressed = %d", aValue, aPressed]];
        
        if (!mAButtonPressed && aPressed)
        {
            [sSelf fireBullet];
        }

        mAButtonPressed = aPressed;
    }];
    
    [[mGamePad buttonB] setValueChangedHandler:^(GCControllerButtonInput *aButton, float aValue, BOOL aPressed) {
        [sSelf log:[NSString stringWithFormat:@"buttonB : v = %f, pressed = %d", aValue, aPressed]];
    }];

    [[mGamePad buttonX] setValueChangedHandler:^(GCControllerButtonInput *aButton, float aValue, BOOL aPressed) {
        [sSelf log:[NSString stringWithFormat:@"buttonX : v = %f, pressed = %d", aValue, aPressed]];
    }];

    [[mGamePad buttonY] setValueChangedHandler:^(GCControllerButtonInput *aButton, float aValue, BOOL aPressed) {
        [sSelf log:[NSString stringWithFormat:@"buttonY : v = %f, pressed = %d", aValue, aPressed]];
        [[sSelf navigationController] popViewControllerAnimated:YES];
    }];

    [[mGamePad leftShoulder] setValueChangedHandler:^(GCControllerButtonInput *aButton, float aValue, BOOL aPressed) {
        [sSelf log:[NSString stringWithFormat:@"leftShoulder : v = %f, pressed = %d", aValue, aPressed]];
        
        CGFloat sAlpha = 1.0 - aValue;
        [sNode setAlpha:sAlpha];
    }];

    [[mGamePad rightShoulder] setValueChangedHandler:^(GCControllerButtonInput *aButton, float aValue, BOOL aPressed) {
        [sSelf log:[NSString stringWithFormat:@"rightShoulder : v = %f, pressed = %d", aValue, aPressed]];
    }];
#endif
}


#pragma mark -


- (void)addAliens
{
    CGRect sBounds = [[self view] bounds];
    
    for (NSInteger i = 0; i < 10; i++)
    {
        PBSpriteNode *sAlien = [[[PBSpriteNode alloc] initWithImageNamed:@"alien"] autorelease];
        [sAlien setPoint:CGPointMake(i * ([sAlien textureSize].width + 20) - 200, sBounds.size.height / 2 + [sAlien textureSize].height)];
        [mAliens addObject:sAlien];
        [mScene addSubNode:sAlien];
    }
}


- (void)updateGameControllerData
{
    GCControllerAxisInput   *sXAxisInput    = [[mGamePad dpad] xAxis];
    GCControllerAxisInput   *sYAxisInput    = [[mGamePad dpad] yAxis];
    GCControllerButtonInput *sAButtonInput  = [mGamePad buttonA];
    GCControllerButtonInput *sYButtonInput  = [mGamePad buttonY];
    GCControllerButtonInput *sLSButtonInput = [mGamePad leftShoulder];

    mDPadPoint = CGPointMake([sXAxisInput value], [sYAxisInput value]);
    
    if (mAButtonPressed)
    {
        if (![sAButtonInput isPressed])
        {
            mAButtonPressed = NO;
        }
    }
    else
    {
        if ([sAButtonInput isPressed])
        {
            mAButtonPressed = YES;
            [self fireBullet];
        }
    }
    
    CGFloat sAlpha = [sLSButtonInput value];
    [mNode setAlpha:(1.0 - sAlpha)];
    
    if ([sYButtonInput isPressed])
    {
        [[self navigationController] popViewControllerAnimated:YES];
    }
}


- (void)pbSceneWillUpdate:(PBScene *)aScene
{
    [self updateGameControllerData];
    
    CGRect  sBounds   = [[self view] bounds];
    CGPoint sMinPoint = CGPointMake(-sBounds.size.width / 2, -sBounds.size.height / 2);
    CGPoint sMaxPoint = CGPointMake(sBounds.size.width / 2, sBounds.size.height / 2);
    
    {
        CGPoint sPoint = [mNode point];
        
        sPoint.x += (mDPadPoint.x * 8);
        sPoint.y += (mDPadPoint.y * 8);
        
        sPoint.x = (sPoint.x < sMinPoint.x) ? sMinPoint.x : sPoint.x;
        sPoint.y = (sPoint.y < sMinPoint.y) ? sMinPoint.y : sPoint.y;
        sPoint.x = (sPoint.x > sMaxPoint.x) ? sMaxPoint.x : sPoint.x;
        sPoint.y = (sPoint.y > sMaxPoint.y) ? sMaxPoint.y : sPoint.y;
        
        [mNode setPoint:sPoint];
        
        if (mDPadPoint.x < 0)
        {
            [mNode setTexture:mLeftTexture];
        }
        else if (mDPadPoint.x > 0)
        {
            [mNode setTexture:mRightTexture];
        }
        else
        {
            [mNode setTexture:mCenterTexture];
        }
    }
    
    NSMutableArray *sArray = [NSMutableArray array];
    for (PBSpriteNode *sBullet in mBullets)
    {
        CGPoint sPoint = [sBullet point];
        sPoint.y += 10;
        
        if (sPoint.y > sMaxPoint.y)
        {
            [sArray addObject:sBullet];
        }
        
        [sBullet setPoint:sPoint];
    }
    [mScene removeSubNodes:sArray];
    [mBullets removeObjectsInArray:sArray];

    for (PBSpriteNode *sAlien in mAliens)
    {
        CGPoint sPoint = [sAlien point];
        sPoint.y -= 0.5;
        [sAlien setPoint:sPoint];
    }
    
    {
        NSMutableArray *sBullets = [NSMutableArray array];
        NSMutableArray *sAliens  = [NSMutableArray array];
        
        for (PBSpriteNode *sBullet in mBullets)
        {
            CGPoint sBulletPoint = [sBullet point];
            CGSize  sBulletSize  = [sBullet textureSize];
            CGRect  sBulletRect  = CGRectMake(sBulletPoint.x - (sBulletSize.width / 2), sBulletPoint.y - (sBulletSize.height / 2), sBulletSize.width, sBulletSize.height);
            
            for (PBSpriteNode *sAlien in mAliens)
            {
                CGPoint sAlienPoint = [sAlien point];
                CGSize  sAlienSize  = [sAlien textureSize];
                CGRect  sAlienRect  = CGRectMake(sAlienPoint.x - (sAlienSize.width / 2), sAlienPoint.y - (sAlienSize.height / 2), sAlienSize.width, sAlienSize.height);
                
                if (CGRectIntersectsRect(sBulletRect, sAlienRect))
                {
                    [sBullets addObject:sBullet];
                    [sAliens addObject:sAlien];
                    break;
                }
            }
        }
        [mBullets removeObjectsInArray:sBullets];
        [mAliens removeObjectsInArray:sAliens];
        [mScene removeSubNodes:sBullets];
        [mScene removeSubNodes:sAliens];
    }
    
    if (mTime > 30 * 2.5)
    {
        [self addAliens];
        mTime = 0;
    }
    mTime++;
}


#pragma mark -


- (void)gamePadDidConnectNotification:(NSNotification *)aNotification
{
    NSDictionary *sUserInfo = [aNotification userInfo];
    
    NSLog(@"%@", [NSString stringWithFormat:@"connect = %@", sUserInfo]);
    
    [self setGamePad:[[[GCController controllers] objectAtIndex:0] gamepad]];
}


- (void)gamePadDidDisconnectNotification:(NSNotification *)aNotification
{
    NSDictionary *sUserInfo = [aNotification userInfo];
    
    NSLog(@"%@", [NSString stringWithFormat:@"disconnect = %@", sUserInfo]);
    
    [self setGamePad:nil];
}


@end
