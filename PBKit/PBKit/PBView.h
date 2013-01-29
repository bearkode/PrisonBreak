/*
 *  PBView.h
 *  PBKit
 *
 *  Created by sshanks on 12. 12. 27..
 *  Copyright (c) 2012년 sshanks. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>


@class PBRenderable;
@class PBColor;


@interface PBView : UIView <UIGestureRecognizerDelegate>
{
    id            mDisplayDelegate;
    PBRenderable *mSuperRenderable;
    PBColor      *mBackgroundColor;
}


#pragma mark -


@property (nonatomic, assign) id            displayDelegate;
@property (nonatomic, retain) PBColor      *backgroundColor;
@property (nonatomic, retain) PBRenderable *superRenderable;


#pragma mark -


- (void)startDisplayLoop;
- (void)stopDisplayLoop;


#pragma mark -


- (void)addSelectableRenderable:(PBRenderable *)aRenderable;
- (void)removeSelectableRenderable:(PBRenderable *)aRenderable;
//- (PBRenderObject *)selectedRenderable:(CGPoint)aPoint;


- (void)registGestureEvent;


@end


#pragma mark - PBDisplayDelegate;


@protocol PBDisplayDelegate <NSObject>


@required


- (void)rendering;


@end


#pragma mark - PBViewDelegate;


@protocol PBViewDelegate <NSObject>


- (void)rendering;


@end

#pragma mark - PBGestureEventDelegate;


@protocol PBGestureEventDelegate <NSObject>


- (void)pbView:(PBView *)aView didTapPoint:(CGPoint)aPoint;
- (void)pbView:(PBView *)aView didLongTapPoint:(CGPoint)aPoint;


@end