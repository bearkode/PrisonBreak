/*
 *  NodeEffectViewController.m
 *  PBKitTest
 *
 *  Created by camelkode on 13. 7. 2..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


#import "NodeEffectViewController.h"
#import <PBKit.h>
#import "ProfilingOverlay.h"
#import "RippleProgram.h"
#import "BendingProgram.h"


typedef enum
{
    kFLEffectBasic = 0,
    kFLEffectGray,
    kFLEffectSepia,
    kFLEffectBlur,
    kFLEffectRipple,
    kFLEffectBending,
} FLEffectShaderType;


@implementation NodeEffectViewController
{
    PBCanvas          *mCanvas;
    PBEffectNode      *mEffectNode;

    RippleProgram     *mRippleProgram;
    BendingProgram    *mBendingProgram;
 
    FLEffectShaderType mSelectedShaderType;
    NSArray           *mShaderNames;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        mCanvas = [[[PBCanvas alloc] initWithFrame:CGRectMake(0, 0, 320, 200)] autorelease];
        [[self view] addSubview:mCanvas];
        
        PBScene *sScene = [[[PBScene alloc] initWithDelegate:self] autorelease];
        [mCanvas presentScene:sScene];
//        [mCanvas setBackgroundColor:[PBColor colorWithRed:1.0f green:0.3f blue:0.3f alpha:1.0f]];
        
        PBSpriteNode *sBackground = [[[PBSpriteNode alloc] initWithImageNamed:@"space_background"] autorelease];
        
        PBSpriteNode *sGrass = [[[PBSpriteNode alloc] initWithImageNamed:@"lawngarden"] autorelease];
        [sGrass setScale:PBVertex3Make(0.5, 0.5, 1.0)];
        [sGrass setPoint:CGPointMake(0, -30)];
        PBSpriteNode *sSprite1 = [[[PBSpriteNode alloc] initWithImageNamed:@"castle_n"] autorelease];
        [sSprite1 setPoint:CGPointMake(-70, 20)];
        PBSpriteNode *sSprite2 = [[[PBSpriteNode alloc] initWithImageNamed:@"farm_n"] autorelease];
        [sSprite2 setPoint:CGPointMake(0, 20)];
        PBSpriteNode *sSprite3 = [[[PBSpriteNode alloc] initWithImageNamed:@"castle_n"] autorelease];
        [sSprite3 setPoint:CGPointMake(70, 20)];
        
        mEffectNode = [[[PBEffectNode alloc] init] autorelease];
        [mEffectNode setProgram:[[PBProgramManager sharedManager] program]];
        [mEffectNode setSubNodes:[NSArray arrayWithObjects:sGrass, sSprite1, sSprite2, sSprite3, nil]];
        
        [sScene setSubNodes:[NSArray arrayWithObjects:sBackground, mEffectNode, nil]];
        
        mShaderNames = [[NSArray alloc] initWithObjects:@"Basic (Internal)", @"Gray (Internal)", @"Sepia (Internal)", @"Blur (Internal)", @"Ripple (Custom)", @"Bending (Custom)", nil];
        
        mRippleProgram  = [[RippleProgram alloc] init];
        mBendingProgram = [[BendingProgram alloc] init];
        
        mSelectedShaderType = kFLEffectBasic;
    }
    return self;
}


- (void)dealloc
{
    [mBendingProgram release];
    [mRippleProgram release];

    [super dealloc];
}


- (void)viewDidLoad
{
    [super viewDidLoad];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)aAnimated
{
    [super viewWillAppear:aAnimated];
    
    [mCanvas startDisplayLoop];
}


- (void)viewWillDisappear:(BOOL)aAnimated
{
    [super viewWillDisappear:aAnimated];
    
    [mCanvas stopDisplayLoop];
}


#pragma mark - UIPickerView delegate


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)aPickerView
{
	return 1;
}


- (NSInteger)pickerView:(UIPickerView *)aPickerView numberOfRowsInComponent:(NSInteger)aComponent
{
    return [mShaderNames count];
}


- (NSString *)pickerView:(UIPickerView *)aPickerView titleForRow:(NSInteger)aRow forComponent:(NSInteger)aComponent
{
    return [mShaderNames objectAtIndex:aRow];
}


- (void)pickerView:(UIPickerView *)aPickerView didSelectRow:(NSInteger)aRow inComponent:(NSInteger)aComponent
{
    mSelectedShaderType = (FLEffectShaderType)aRow;

    PBProgram *sProgram = nil;
    switch (mSelectedShaderType)
    {
        case kFLEffectBasic:
            sProgram = [[PBProgramManager sharedManager] program];
            break;
        case kFLEffectGray:
            sProgram = [[PBProgramManager sharedManager] grayscaleProgram];
            break;
        case kFLEffectSepia:
            sProgram = [[PBProgramManager sharedManager] sepiaProgram];
            break;
        case kFLEffectBlur:
            sProgram = [[PBProgramManager sharedManager] blurProgram];
            break;
        case kFLEffectRipple:
            sProgram = mRippleProgram;
            break;
        case kFLEffectBending:
            sProgram = mBendingProgram;
        default:
            break;
    }
    
    [mEffectNode setProgram:sProgram];
    
//    printf("GLSL Version = %s\n", glGetString(GL_SHADING_LANGUAGE_VERSION));
//    printf("GL Version = %s\n", glGetString(GL_VERSION));
}


#pragma mark -


- (void)pbSceneWillUpdate:(PBScene *)aScene
{
    [[ProfilingOverlay sharedManager] displayFPS:[mCanvas fps] timeInterval:[mCanvas timeInterval]];
    
    if (mSelectedShaderType == kFLEffectRipple)
    {
        [mRippleProgram updateRippleTime];
    }
    else if (mSelectedShaderType == kFLEffectBending)
    {
        [mBendingProgram updateBendingTime];
    }
}


@end
