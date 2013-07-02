/*
 *  WaveEffectViewController.h
 *  PBKitTest
 *
 *  Created by camelkode on 13. 5. 28..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import "SceneEffectViewController.h"
#import <PBKit.h>
#import "ProfilingOverlay.h"
//#import <PBTextureUtils.h>
//PBTextureCreate();
//CGSize sCopySize = [[[self canvas] renderer] renderBufferSize];
//glCopyTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, 0, 0, sCopySize.width, sCopySize.height, 0);
//PBTextureRelease(0);


typedef enum
{
    kWaveEffectTypeOff = 0,
    kWaveEffectTypeRipple,
    kWaveEffectTypeShockwave
} WaveEffectType;


typedef struct {
    GLint projectionLoc;
    GLint positionLoc;
    GLint texCoordLoc;
    GLint resolutionLoc;
    GLint pointLoc;
    GLint timeLoc;
    GLint directionLoc;
    GLint powerLoc;
    GLint widthLoc;
} RippleLocation;


typedef struct {
    CGPoint point;
    GLfloat time;
    GLfloat direction;
    GLfloat power;
    GLfloat width;
} Ripple;


typedef struct {
    GLint projectionLoc;
    GLint positionLoc;
    GLint texCoordLoc;
    GLint resolutionLoc;
    GLint pointLoc;
    GLint timeLoc;
    GLint paramLoc;
} ShockwaveLocation;


typedef struct {
    CGPoint   point;
    GLfloat   time;
    GLfloat   power;
    PBVertex3 param;
} Shockwave;



@implementation SceneEffectViewController
{
    NSMutableArray   *mLandscapeNodeArray;

    PBScene          *mScene;
    PBProgram        *mRippleProgram;
    RippleLocation    mRippleLocation;
    Ripple            mRipple;
    
    PBProgram        *mShockwaveProgram;
    ShockwaveLocation mShockwaveLocation;
    Shockwave         mShockwave;
    
    UIView           *mControlPannel;
    UISlider         *mValue1Slider;
    UISlider         *mValue2Slider;
    UISlider         *mValue3Slider;
    PBSpriteNode     *mSampleSprite2;
    NSInteger         mSelectedEffectType;
}


#pragma mark -


- (void)updateLandscape
{
    CGPoint sPoint = CGPointZero;
    for (PBSpriteNode *sNode in mLandscapeNodeArray)
    {
        sPoint = [sNode point];
        sPoint.x += 3.0;
        
        if (sPoint.x > 320)
        {
            sPoint.x = -320;
        }
        [sNode setPoint:sPoint];
    }
    
    sPoint = [mSampleSprite2 point];
    sPoint.x += 5.0f;
    if (sPoint.x > 160)
        sPoint.x = -160;
    
    [mSampleSprite2 setPoint:sPoint];
}


- (void)updateRipple:(GLuint)aTextureHandle
{
    [mRippleProgram use];
    
    if (!aTextureHandle)
    {
        return;
    }
    glBindTexture(GL_TEXTURE_2D, aTextureHandle);

    PBMatrix sProjection = [[[self canvas] camera] projection];
    glUniformMatrix4fv(mRippleLocation.projectionLoc, 1, 0, &sProjection.m[0]);
    
    CGSize sCanvasSize = [[[self canvas] camera] viewSize];
    glUniform2f(mRippleLocation.resolutionLoc, sCanvasSize.width, sCanvasSize.height);
    glUniform2f(mRippleLocation.pointLoc, mRipple.point.x, mRipple.point.y);
    glUniform1f(mRippleLocation.timeLoc, mRipple.time);
    glUniform1f(mRippleLocation.directionLoc, mRipple.direction);
    glUniform1f(mRippleLocation.powerLoc, mRipple.power);
    glUniform1f(mRippleLocation.widthLoc, mRipple.width);

    glVertexAttribPointer(mRippleLocation.texCoordLoc, 2, GL_FLOAT, GL_FALSE, 0, gTexCoordinates);
    glEnableVertexAttribArray(mRippleLocation.texCoordLoc);
    
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
        
    glVertexAttribPointer(mRippleLocation.positionLoc, 3, GL_FLOAT, GL_FALSE, 0, sVertices);
    glEnableVertexAttribArray(mRippleLocation.positionLoc);
    glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
    glDisableVertexAttribArray(mRippleLocation.positionLoc);
    glDisableVertexAttribArray(mRippleLocation.texCoordLoc);

    glBindTexture(GL_TEXTURE_2D, 0);
    mRipple.time += 0.1;
}


- (void)updateShockwave:(GLuint)aTextureHandle
{
    [mShockwaveProgram use];
    
    if (!aTextureHandle)
    {
        return;
    }
    glBindTexture(GL_TEXTURE_2D, aTextureHandle);
    
    PBMatrix sProjection = [[[self canvas] camera] projection];
    glUniformMatrix4fv(mShockwaveLocation.projectionLoc, 1, 0, &sProjection.m[0]);
    
    CGSize sCanvasSize = [[[self canvas] camera] viewSize];
    glUniform2f(mShockwaveLocation.resolutionLoc, sCanvasSize.width, sCanvasSize.height);
    glUniform2f(mShockwaveLocation.pointLoc, mShockwave.point.x, mShockwave.point.y);
    glUniform1f(mShockwaveLocation.timeLoc, mShockwave.time);
    glUniform3f(mShockwaveLocation.paramLoc, mShockwave.param.x, mShockwave.param.y, mShockwave.param.z);
    
    glVertexAttribPointer(mShockwaveLocation.texCoordLoc, 2, GL_FLOAT, GL_FALSE, 0, gTexCoordinates);
    glEnableVertexAttribArray(mShockwaveLocation.texCoordLoc);
    
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
    
    glVertexAttribPointer(mShockwaveLocation.positionLoc, 3, GL_FLOAT, GL_FALSE, 0, sVertices);
    glEnableVertexAttribArray(mShockwaveLocation.positionLoc);
    glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
    glDisableVertexAttribArray(mShockwaveLocation.positionLoc);
    glDisableVertexAttribArray(mShockwaveLocation.texCoordLoc);
    
    glBindTexture(GL_TEXTURE_2D, 0);
    mShockwave.time += mShockwave.power;
}


#pragma mark -


- (void)setupRipple
{
    mRippleProgram = [[PBProgram alloc] init];
    [mRippleProgram linkVertexShaderFilename:@"Ripple" fragmentShaderFilename:@"Ripple"];
    
    mRippleLocation.positionLoc   = [mRippleProgram attributeLocation:@"aPosition"];
    mRippleLocation.texCoordLoc   = [mRippleProgram attributeLocation:@"aTexCoord"];
    mRippleLocation.projectionLoc = [mRippleProgram uniformLocation:@"aProjection"];
    mRippleLocation.resolutionLoc = [mRippleProgram uniformLocation:@"uResolution"];
    mRippleLocation.pointLoc      = [mRippleProgram uniformLocation:@"uRipplePoint"];
    mRippleLocation.timeLoc       = [mRippleProgram uniformLocation:@"uRippleTime"];
    mRippleLocation.directionLoc  = [mRippleProgram uniformLocation:@"uRippleDirection"];
    mRippleLocation.powerLoc      = [mRippleProgram uniformLocation:@"uRipplePower"];
    mRippleLocation.widthLoc      = [mRippleProgram uniformLocation:@"uRippleWidth"];
    
    mRipple.direction = 12.0f;
    mRipple.power     = 4.0f;
    mRipple.width     = 0.03f;
}


- (void)setupShockwave
{
    mShockwaveProgram = [[PBProgram alloc] init];
    [mShockwaveProgram linkVertexShaderFilename:@"Shockwave" fragmentShaderFilename:@"Shockwave"];
    
    mShockwaveLocation.positionLoc   = [mShockwaveProgram attributeLocation:@"aPosition"];
    mShockwaveLocation.texCoordLoc   = [mShockwaveProgram attributeLocation:@"aTexCoord"];
    mShockwaveLocation.projectionLoc = [mShockwaveProgram uniformLocation:@"aProjection"];
    mShockwaveLocation.resolutionLoc = [mShockwaveProgram uniformLocation:@"uResolution"];
    mShockwaveLocation.pointLoc      = [mShockwaveProgram uniformLocation:@"uShockwavePoint"];
    mShockwaveLocation.timeLoc       = [mShockwaveProgram uniformLocation:@"uShockwaveTime"];
    mShockwaveLocation.paramLoc      = [mShockwaveProgram uniformLocation:@"uShockwaveParam"];
    
    mShockwave.power = 0.06;
    mShockwave.param = PBVertex3Make(10.0, 0.8, 0.1);
}


- (void)setupLandscape
{
    mLandscapeNodeArray = [[NSMutableArray alloc] init];
    PBTexture *sLandscapeTexture  = [PBTextureManager textureWithImageName:@"space_background"];
    [sLandscapeTexture loadIfNeeded];
    for (NSInteger i = 0; i < 2; i++)
    {
        PBSpriteNode *sNode = [[[PBSpriteNode alloc] initWithTexture:sLandscapeTexture] autorelease];
        
        CGPoint sPoint = (i == 0) ? CGPointMake(0, 0) : CGPointMake(-320, 0);
        [sNode setPoint:sPoint];
        
        [mLandscapeNodeArray addObject:sNode];
    }
    
    [mScene addSubNodes:mLandscapeNodeArray];
    
    mSampleSprite2 = [[[PBSpriteNode alloc] initWithImageNamed:@"poket0118"] autorelease];
    [mSampleSprite2 setPoint:CGPointMake(0, 100)];
    
    [mScene addSubNode:mSampleSprite2];
}


- (void)setupControlUI
{
    UISegmentedControl *sEffectOnSegment = [[[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"Off", @"Ripple", @"Shockwave", nil]] autorelease];
    [sEffectOnSegment setFrame:CGRectMake(5, 5, 310, 30)];
    [sEffectOnSegment addTarget:self action:@selector(renderSelected:)forControlEvents:UIControlEventValueChanged];
    [sEffectOnSegment setSelectedSegmentIndex:0];
    [sEffectOnSegment setSegmentedControlStyle:UISegmentedControlStyleBar];
    [sEffectOnSegment setAlpha:0.7];
    [[self view] addSubview:sEffectOnSegment];


    mControlPannel = [[[UIView alloc] initWithFrame:CGRectMake(0, 320, 320, 200)] autorelease];
    [[self canvas] addSubview:mControlPannel];

    mValue1Slider = [[[UISlider alloc] initWithFrame:CGRectMake(50, 0, 220, 20)] autorelease];
    [mValue1Slider  addTarget:self action:@selector(didChangeValue1SliderValue:) forControlEvents:UIControlEventValueChanged];
    [mValue1Slider setAlpha:0.7];
    [mControlPannel addSubview:mValue1Slider];
    
    mValue2Slider = [[[UISlider alloc] initWithFrame:CGRectMake(50, 30, 220, 20)] autorelease];
    [mValue2Slider  addTarget:self action:@selector(didChangeValue2SliderValue:) forControlEvents:UIControlEventValueChanged];
    [mValue2Slider setAlpha:0.7];
    [mControlPannel addSubview:mValue2Slider];
    
    mValue3Slider = [[[UISlider alloc] initWithFrame:CGRectMake(50, 60, 220, 20)] autorelease];
    [mValue3Slider  addTarget:self action:@selector(didChangeValue3SliderValue:) forControlEvents:UIControlEventValueChanged];
    [mValue3Slider setAlpha:0.7];
    [mControlPannel addSubview:mValue3Slider];
}


#pragma mark -


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        [[self view] setBackgroundColor:[UIColor darkGrayColor]];
    }
    return self;
}


- (void)dealloc
{
    [[ProfilingOverlay sharedManager] stopDisplayFPS];
 
    [mScene release];
    [mShockwaveProgram release];
    [mRippleProgram release];
    [mLandscapeNodeArray release];
    
    [super dealloc];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    mScene = [[PBScene alloc] initWithDelegate:self];
    [[self canvas] presentScene:mScene];
    
    [self setupRipple];
    [self setupShockwave];
    [self setupLandscape];
    [self setupControlUI];

}


#pragma mark -


- (void)didChangeValue1SliderValue:(id)aSender
{
    UISlider *sSlider = (UISlider *)aSender;

    if (mSelectedEffectType == kWaveEffectTypeRipple)
    {
        mRipple.direction = [sSlider value];
    }
    else if (mSelectedEffectType == kWaveEffectTypeShockwave)
    {
        mShockwave.param.x = [sSlider value];
    }
    
    NSLog(@"value1 = %f", [sSlider value]);
}


- (void)didChangeValue2SliderValue:(id)aSender
{
    UISlider *sSlider = (UISlider *)aSender;

    if (mSelectedEffectType == kWaveEffectTypeRipple)
    {
        mRipple.power = [sSlider value];
    }
    else if (mSelectedEffectType == kWaveEffectTypeShockwave)
    {
        mShockwave.param.y = [sSlider value];
    }
    
    NSLog(@"value2 = %f", [sSlider value]);
}


- (void)didChangeValue3SliderValue:(id)aSender
{
    UISlider *sSlider = (UISlider *)aSender;
    
    if (mSelectedEffectType == kWaveEffectTypeRipple)
    {
        mRipple.width = [sSlider value];
    }
    else if (mSelectedEffectType == kWaveEffectTypeShockwave)
    {
        mShockwave.param.z = [sSlider value];
    }
    
    NSLog(@"value3 = %f", [sSlider value]);
}


- (IBAction)renderSelected:(UISegmentedControl *)aSender
{
    mSelectedEffectType = [aSender selectedSegmentIndex];
    
    switch (mSelectedEffectType)
    {
        case kWaveEffectTypeOff:
            [mControlPannel setHidden:YES];
            break;
        case kWaveEffectTypeRipple:
            [mControlPannel setHidden:NO];

            [mValue1Slider setMaximumValue:100.0f];
            [mValue1Slider setMinimumValue:-100.0f];
            [mValue1Slider setValue:mRipple.direction];
            
            [mValue2Slider setMaximumValue:10.0f];
            [mValue2Slider setMinimumValue:0.0f];
            [mValue2Slider setValue:mRipple.power];
            
            [mValue3Slider setMaximumValue:1.0f];
            [mValue3Slider setMinimumValue:0.01f];
            [mValue3Slider setValue:mRipple.width];
            break;
        case kWaveEffectTypeShockwave:
            [mControlPannel setHidden:NO];
            
            [mValue1Slider setMaximumValue:30.0f];
            [mValue1Slider setMinimumValue:0.0f];
            [mValue1Slider setValue:mShockwave.param.x];
            
            [mValue2Slider setMaximumValue:10.0f];
            [mValue2Slider setMinimumValue:0.0f];
            [mValue2Slider setValue:mShockwave.param.y];
            
            [mValue3Slider setMaximumValue:1.0f];
            [mValue3Slider setMinimumValue:0.01f];
            [mValue3Slider setValue:mShockwave.param.z];
            break;
        default:
            break;
    }
}


#pragma mark -


- (void)pbSceneWillUpdate:(PBScene *)aScene
{
    [[ProfilingOverlay sharedManager] displayFPS:[[self canvas] fps] timeInterval:[[self canvas] timeInterval]];

    [self updateLandscape];
}


- (void)pbScene:(PBScene *)aScene didTapCanvasPoint:(CGPoint)aCanvasPoint
{
    switch (mSelectedEffectType)
    {
        case kWaveEffectTypeOff:
            break;
        case kWaveEffectTypeRipple:
            mRipple.point = aCanvasPoint;
            break;
        case kWaveEffectTypeShockwave:
            mShockwave.point = aCanvasPoint;
            mShockwave.time  = 0.0;
            break;
        default:
            break;
    }
}


- (void)pbSceneWillRender:(PBScene *)aScene
{
    if (mSelectedEffectType == kWaveEffectTypeRipple)
    {
        [self updateRipple:[aScene textureHandle]];
    }
    else
    {
        [self updateShockwave:[aScene textureHandle]];
    }
}


@end
