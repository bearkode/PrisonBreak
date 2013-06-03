/*
 *  WaveEffectViewController.h
 *  PBKitTest
 *
 *  Created by camelkode on 13. 5. 28..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


#import "WaveEffectViewController.h"
#import <PBKit.h>
#import "ProfilingOverlay.h"
//#import <PBTextureUtils.h>
//PBTextureCreate();
//CGSize sCopySize = [[[self canvas] renderer] renderBufferSize];
//glCopyTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, 0, 0, sCopySize.width, sCopySize.height, 0);
//PBTextureRelease(0);


typedef struct {
    GLint projectionLoc;
    GLint positionLoc;
    GLint resolutionLoc;
    GLint wavePointLoc;
    GLint waveTimeLoc;
    GLint waveDirectionLoc;
    GLint wavePowerLoc;
    GLint waveWidthLoc;
    GLint texCoordLoc;
    
} WaveProgramLocation;


@implementation WaveEffectViewController
{
    PBProgram          *mProgram;
    WaveProgramLocation mProgramLocation;
    NSMutableArray     *mLandscapeLayerArray;
    
    CGSize              mResolution;
    CGPoint             mWavePoint;
    GLfloat             mWaveTime;
    GLfloat             mWaveDirection;
    GLfloat             mWavePower;
    GLfloat             mWaveWidth;

    PBSprite           *mSampleSprite2;
}


#pragma mark -


- (void)updateLandscape
{
    CGPoint sPoint = CGPointZero;
    for (PBLayer *sLayer in mLandscapeLayerArray)
    {
        sPoint = [sLayer point];
        sPoint.x += 3.0;
        
        if (sPoint.x > 320)
        {
            sPoint.x = -320;
        }
        [sLayer setPoint:sPoint];
    }
    
    sPoint = [mSampleSprite2 point];
    sPoint.x += 5.0f;
    if (sPoint.x > 160)
        sPoint.x = -160;
    
    [mSampleSprite2 setPoint:sPoint];
}


- (void)updateWaveWithOffscreenTextureHandle:(GLuint)aTextureHandle
{
    [mProgram use];
    
    if (!aTextureHandle)
    {
        return;
    }
    glBindTexture(GL_TEXTURE_2D, aTextureHandle);

    PBMatrix sProjection = [[[self canvas] camera] projection];
    glUniformMatrix4fv(mProgramLocation.projectionLoc, 1, 0, &sProjection.m[0][0]);
    
    CGSize sCanvasSize = [[[self canvas] camera] viewSize];
    glUniform2f(mProgramLocation.resolutionLoc, sCanvasSize.width, sCanvasSize.height);
    glUniform2f(mProgramLocation.wavePointLoc, mWavePoint.x, mWavePoint.y);
    glUniform1f(mProgramLocation.waveTimeLoc, mWaveTime);
    glUniform1f(mProgramLocation.waveDirectionLoc, mWaveDirection);
    glUniform1f(mProgramLocation.wavePowerLoc, mWavePower);
    glUniform1f(mProgramLocation.waveWidthLoc, mWaveWidth);

    glVertexAttribPointer(mProgramLocation.texCoordLoc, 2, GL_FLOAT, GL_FALSE, 0, gTexCoordinates);
    glEnableVertexAttribArray(mProgramLocation.texCoordLoc);
    
    CGSize sVerticeSize = [[[self canvas] camera] viewSize];
    sVerticeSize.width *= 0.5;
    sVerticeSize.height *= 0.5;
    GLfloat sVertices[] =
    {
        -sVerticeSize.width, sVerticeSize.height, 2.0f,
        -sVerticeSize.width, -sVerticeSize.height, 2.0f,
        sVerticeSize.width, -sVerticeSize.height, 2.0f,
        sVerticeSize.width, sVerticeSize.height, 2.0f
    };
        
    glVertexAttribPointer(mProgramLocation.positionLoc, 3, GL_FLOAT, GL_FALSE, 0, sVertices);
    glEnableVertexAttribArray(mProgramLocation.positionLoc);
    glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
    glDisableVertexAttribArray(mProgramLocation.positionLoc);
    glDisableVertexAttribArray(mProgramLocation.texCoordLoc);

    glBindTexture(GL_TEXTURE_2D, 0);
    mWaveTime += 0.1;
}


#pragma mark -


- (void)setupLandscape
{
    mLandscapeLayerArray = [[NSMutableArray alloc] init];
    PBTexture *sLandscapeTexture  = [PBTextureManager textureWithImageName:@"space_background"];
    [sLandscapeTexture loadIfNeeded];
    for (NSInteger i = 0; i < 2; i++)
    {
        PBLayer *sLayer = [[[PBLayer alloc] init] autorelease];
        [sLayer setMeshRenderOption:kPBMeshRenderOptionUsingMeshQueue];
        [sLayer setTexture:sLandscapeTexture];
        
        CGPoint sPoint = (i == 0) ? CGPointMake(0, 0) : CGPointMake(-320, 0);
        [sLayer setPoint:sPoint];
        
        [mLandscapeLayerArray addObject:sLayer];
    }
    
    [[[self canvas] rootLayer] addSublayers:mLandscapeLayerArray];
    
    mSampleSprite2 = [[[PBSprite alloc] initWithImageName:@"poket0118"] autorelease];
    [mSampleSprite2 setPoint:CGPointMake(0, 100)];
    [[[self canvas] rootLayer] addSublayer:mSampleSprite2];
}


- (void)setupWaveProgram
{
    mProgram = [[PBProgram alloc] init];
    [mProgram linkVertexShaderFilename:@"WaveShader" fragmentShaderFilename:@"WaveShader"];
    
    mProgramLocation.positionLoc      = [mProgram attributeLocation:@"aPosition"];
    mProgramLocation.texCoordLoc      = [mProgram attributeLocation:@"aTexCoord"];
    mProgramLocation.projectionLoc    = [mProgram uniformLocation:@"aProjection"];
    mProgramLocation.resolutionLoc    = [mProgram uniformLocation:@"uResolution"];
    mProgramLocation.wavePointLoc     = [mProgram uniformLocation:@"uWavePoint"];
    mProgramLocation.waveTimeLoc      = [mProgram uniformLocation:@"uWaveTime"];
    mProgramLocation.waveDirectionLoc = [mProgram uniformLocation:@"uWaveDirection"];
    mProgramLocation.wavePowerLoc     = [mProgram uniformLocation:@"uWavePower"];
    mProgramLocation.waveWidthLoc     = [mProgram uniformLocation:@"uWaveWidth"];
}


- (void)setupControlUI
{
    mWaveDirection = 12.0f;
    mWavePower     = 4.0f;
    mWaveWidth     = 0.03f;

    UISlider *sDirectionSlider = [[[UISlider alloc] initWithFrame:CGRectMake(50, 300, 220, 20)] autorelease];
    [sDirectionSlider  addTarget:self action:@selector(didChangeDirectionSliderValue:) forControlEvents:UIControlEventValueChanged];
    [sDirectionSlider setMaximumValue:100.0f];
    [sDirectionSlider setMinimumValue:-100.0f];
    [sDirectionSlider setValue:mWaveDirection];
    [sDirectionSlider setAlpha:0.7];
    [[self canvas] addSubview:sDirectionSlider];
    
    UISlider *sPowerSlider = [[[UISlider alloc] initWithFrame:CGRectMake(50, 330, 220, 20)] autorelease];
    [sPowerSlider  addTarget:self action:@selector(didChangePowerSliderValue:) forControlEvents:UIControlEventValueChanged];
    [sPowerSlider setMaximumValue:10.0f];
    [sPowerSlider setMinimumValue:0.0f];
    [sPowerSlider setValue:mWavePower];
    [sPowerSlider setAlpha:0.7];
    [[self canvas] addSubview:sPowerSlider];
    
    UISlider *sWaveWidthSlider = [[[UISlider alloc] initWithFrame:CGRectMake(50, 360, 220, 20)] autorelease];
    [sWaveWidthSlider  addTarget:self action:@selector(didChangeWaveWidthSliderValue:) forControlEvents:UIControlEventValueChanged];
    [sWaveWidthSlider setMaximumValue:1.0f];
    [sWaveWidthSlider setMinimumValue:0.01f];
    [sWaveWidthSlider setValue:mWaveWidth];
    [sWaveWidthSlider setAlpha:0.7];
    [[self canvas] addSubview:sWaveWidthSlider];
    

    UISegmentedControl *sEffectOnSegment = [[[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"Off", @"On (RTT)", nil]] autorelease];
    [sEffectOnSegment setFrame:CGRectMake(5, 5, 310, 30)];
    [sEffectOnSegment addTarget:self action:@selector(renderSelected:)forControlEvents:UIControlEventValueChanged];
    [sEffectOnSegment setSelectedSegmentIndex:0];
    [sEffectOnSegment setSegmentedControlStyle:UISegmentedControlStyleBar];
    [sEffectOnSegment setAlpha:0.7];
    [[self view] addSubview:sEffectOnSegment];
}


#pragma mark -


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        [[self view] setBackgroundColor:[UIColor darkGrayColor]];
    
        [self setupLandscape];
        [self setupWaveProgram];
        [self setupControlUI];
    }
    return self;
}


- (void)dealloc
{
    [[ProfilingOverlay sharedManager] stopDisplayFPS];
 
    [[self canvas] setDelegate:nil];
    
    [mProgram release];
    [mLandscapeLayerArray release];
    
    [super dealloc];
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    [[self canvas] setDelegate:self];
    [[self canvas] registGestureEvent];
    
}


#pragma mark -


- (void)didChangeDirectionSliderValue:(id)aSender
{
    UISlider *sSlider = (UISlider *)aSender;
    NSLog(@"direction = %f", [sSlider value]);
    mWaveDirection = [sSlider value];
}


- (void)didChangePowerSliderValue:(id)aSender
{
    UISlider *sSlider = (UISlider *)aSender;
    NSLog(@"power = %f", [sSlider value]);
    mWavePower = [sSlider value];
}


- (void)didChangeWaveWidthSliderValue:(id)aSender
{
    UISlider *sSlider = (UISlider *)aSender;
    NSLog(@"waveWidth = %f", [sSlider value]);
    mWaveWidth = [sSlider value];
}


- (IBAction)renderSelected:(UISegmentedControl *)aSender
{
    ([aSender selectedSegmentIndex] == 0) ? [[self canvas] endRenderToTexture] : [[self canvas] beginRenderToTexture];
}


#pragma mark -


- (void)pbCanvasWillUpdate:(PBCanvas *)aView
{
    [[ProfilingOverlay sharedManager] displayFPS:[aView fps] timeInterval:[aView timeInterval]];

    [self updateLandscape];
}


- (void)pbCanvas:(PBCanvas *)aCanvas didFinishRenderToOffscreenWithTextureHandle:(GLuint)aHandle
{
    [self updateWaveWithOffscreenTextureHandle:aHandle];
}


- (void)pbCanvas:(PBCanvas *)aCanvas didTapPoint:(CGPoint)aPoint
{
    mWavePoint = [aCanvas canvasPointFromViewPoint:aPoint];
}


@end
