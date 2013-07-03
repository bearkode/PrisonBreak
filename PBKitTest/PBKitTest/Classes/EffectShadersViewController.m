/*
 *  EffectShadersViewController.m
 *  PBKitTest
 *
 *  Created by camelkode on 13. 7. 2..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


#import "EffectShadersViewController.h"
#import <PBKit.h>
#import "ProfilingOverlay.h"
#import "RippleProgram.h"


@implementation EffectShadersViewController
{
    PBCanvas      *mCanvas;
    PBEffectNode  *mEffectNode;
    RippleProgram *mRippleProgram;
    
    NSArray       *mShaderNames;
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

        PBSpriteNode *sSprite1 = [[[PBSpriteNode alloc] initWithImageNamed:@"castle_n"] autorelease];
        [sSprite1 setPoint:CGPointMake(-70, 0)];
        PBSpriteNode *sSprite2 = [[[PBSpriteNode alloc] initWithImageNamed:@"farm_n"] autorelease];
        [sSprite2 setPoint:CGPointMake(0, 0)];
        PBSpriteNode *sSprite3 = [[[PBSpriteNode alloc] initWithImageNamed:@"castle_n"] autorelease];
        [sSprite3 setPoint:CGPointMake(70, 0)];
        
        mEffectNode = [[[PBEffectNode alloc] init] autorelease];
        [mEffectNode setProgram:[[PBProgramManager sharedManager] program]];
        [mEffectNode setSubNodes:[NSArray arrayWithObjects:sSprite1, sSprite2, sSprite3, nil]];
        
        [sScene setSubNodes:[NSArray arrayWithObjects:sBackground, mEffectNode, nil]];
        
        mShaderNames = [[NSArray alloc] initWithObjects:@"Basic (Internal)", @"Gray (Internal)", @"Sepia (Internal)", @"Blur (Internal)", @"Luminance (Internal)", @"Ripple (Custom)", nil];
        
        mRippleProgram = [[RippleProgram alloc] init];
    }
    return self;
}


- (void)dealloc
{
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
    PBProgram *sProgram = nil;
    switch (aRow)
    {
        case 0:
            sProgram = [[PBProgramManager sharedManager] program];
            break;
        case 1:
            sProgram = [[PBProgramManager sharedManager] grayscaleProgram];
            break;
        case 2:
            sProgram = [[PBProgramManager sharedManager] sepiaProgram];
            break;
        case 3:
            sProgram = [[PBProgramManager sharedManager] blurProgram];
            break;
        case 4:
            sProgram = [[PBProgramManager sharedManager] luminanceProgram];
            break;
        case 5:
            sProgram = mRippleProgram;
            break;
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
    [mRippleProgram updateRippleTime];
}


@end
