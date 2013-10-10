/*
 *  SkeletonDefine.h
 *  PBKitTest
 *
 *  Created by camelkode on 13. 9. 3..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


#ifndef PBKitTest_SkeletonDefine_h
#define PBKitTest_SkeletonDefine_h


#define kSkeletonFramelate      30


#define kSkeletonKeyBones           @"bones"
#define kSkeletonKeySlots           @"slots"
#define kSkeletonKeySkins           @"skins"
#define kSkeletonKeyAnimations      @"animations"
#define kSkeletonKeyBone            @"bone"
#define kBoneKeyRoot                @"root"

#define kSkeletonName               @"name"
#define kSkeletonAttachment         @"attachment"
#define kSkeletonParent             @"parent"
#define kSkeletonLength             @"length"
#define kSkeletonRotation           @"rotation"
#define kSkeletonX                  @"x"
#define kSkeletonY                  @"y"
#define kSkeletonWidth              @"width"
#define kSkeletonHeight             @"height"
#define kSkeletonScaleX             @"scaleX"
#define kSkeletonScaleY             @"scaleY"
#define kSkeletonRotate             @"rotate"
#define kSkeletonTranslate          @"translate"
#define kSkeletonScale              @"scale"
#define kSkeletonTime               @"time"
#define kSkeletonCurve              @"curve"
#define kSkeletonAngle              @"angle"


#define kSkeletonTimelineRotate     @"rotate"
#define kSkeletonTimelineTranslate  @"translate"
#define kSkeletonTimelineScale      @"scale"
#define kSkeletonTimelineLinearVariation   @"linearVariation"
#define kSkeletonTimelineIntervalVariation @"intervalVariation"
#define kSkeletonTimelineIntervalCount     @"intervalCount"
#define kSkeletonTimelineBezierVariations  @"bezierVariations"



/* For debugging */
typedef enum
{
    kAnimationTestTypeAll       = 0,
    kAnimationTestTypeRotate    = 1,
    kAnimationTestTypeTranslate = 2,
    kAnimationTestTypeScale     = 3
} SkeletonAnimationTestType;


#endif
