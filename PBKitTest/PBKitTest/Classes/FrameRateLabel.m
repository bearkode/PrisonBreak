/*
 *  FrameRateLabel.m
 *  PBKitTest
 *
 *  Created by bearkode on 13. 2. 5..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import "FrameRateLabel.h"
#import <CoreText/CoreText.h>


static inline void PBFrameRelease(CTFrameRef aFrame)
{
    if (aFrame)
    {
        CFRelease(aFrame);
    }
}


@implementation FrameRateLabel
{
    NSMutableDictionary       *mAttrs;
    NSMutableAttributedString *mAttrString;
    CTFrameRef                 mFrame;
    
    CGFloat                    mFrameRate;
}


#pragma mark -


- (void)setupAttrs
{
    [mAttrs autorelease];

    CGFloat   sScale    = [[UIScreen mainScreen] scale];
    CGFloat   sFontSize = 14 * sScale;
    UIFont   *sFont     = [UIFont fontWithName:@"MarkerFelt-Thin" size:sFontSize];
    CTFontRef sFontRef  = CTFontCreateWithName((CFStringRef)[sFont fontName], [sFont pointSize], NULL);
    
    mAttrs = [[NSMutableDictionary alloc] initWithObjectsAndKeys:(id)[[UIColor whiteColor] CGColor], kCTForegroundColorAttributeName,
                                                                 (id)sFontRef, kCTFontAttributeName, nil];
    
    CFRelease(sFontRef);
}


#pragma mark -


- (id)init
{
    self = [super initWithSize:CGSizeMake(1, 1)];
    
    if (self)
    {
        [self setupAttrs];
    }
    
    return self;
}


- (void)dealloc
{
    [mAttrs release];
    [mAttrString release];
    PBFrameRelease(mFrame);

    [super dealloc];
}


#pragma mark -


- (void)setFrameRate:(CGFloat)aFrameRate
{
    if (mFrameRate != aFrameRate)
    {
        mFrameRate = aFrameRate;
        
        NSString *sText = [NSString stringWithFormat:@"Frame Rate = %2.1f", aFrameRate];

        [mAttrString autorelease];
        mAttrString = [[NSMutableAttributedString alloc] initWithString:sText];
        
        [mAttrString setAttributes:mAttrs range:NSMakeRange(0, [sText length])];
        
        PBFrameRelease(mFrame);
        
        CTFramesetterRef sFramesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)mAttrString);
        CGSize           sConstraints = CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);
        CFRange          sFitRange;
        CGSize           sFrameSize   = CTFramesetterSuggestFrameSizeWithConstraints(sFramesetter, CFRangeMake(0, [sText length]), NULL, sConstraints, &sFitRange);
        CGMutablePathRef sPath        = CGPathCreateMutable();
        
        CGPathAddRect(sPath, NULL, CGRectMake(0, 0, sFrameSize.width, sFrameSize.height));
        
        mFrame = CTFramesetterCreateFrame(sFramesetter, CFRangeMake(0, 0), sPath, NULL);
        
        CFRelease(sPath);
        CFRelease(sFramesetter);
        
        sFrameSize.width  /= [[UIScreen mainScreen] scale];
        sFrameSize.height /= [[UIScreen mainScreen] scale];
        sFrameSize.width  = ceilf(sFrameSize.width);
        sFrameSize.height = ceilf(sFrameSize.height);
        
        [self setTextureSize:sFrameSize];
    }
}


- (void)drawInRect:(CGRect)aRect context:(CGContextRef)aContext
{
    CGContextClearRect(aContext, aRect);

#if (0)
    CGContextSetFillColorWithColor(aContext, [[UIColor grayColor] CGColor]);
    CGContextFillRect(aContext, aRect);

    CGContextSetLineWidth(aContext, 1);
    CGContextSetStrokeColorWithColor(aContext, [[UIColor whiteColor] CGColor]);
    CGContextStrokeRect(aContext, aRect);
#endif
    
    CTFrameDraw(mFrame, aContext);
}


@end
