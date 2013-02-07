/*
 *  IndexTexture.m
 *  PBKitTest
 *
 *  Created by bearkode on 13. 2. 5..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import "IndexTexture.h"
#import <CoreText/CoreText.h>


static inline void PBFrameRelease(CTFrameRef aFrame)
{
    if (aFrame)
    {
        CFRelease(aFrame);
    }
}


@implementation IndexTexture
{
    NSMutableDictionary       *mAttrs;
    NSMutableAttributedString *mAttrString;
    CTFrameRef                 mFrame;
}


- (id)initWithSize:(CGSize)aSize
{
    self = [super initWithSize:aSize];
    
    if (self)
    {
        UIFont   *sFont    = [UIFont boldSystemFontOfSize:14];
        CTFontRef sFontRef = CTFontCreateWithName((CFStringRef)[sFont fontName], [sFont pointSize], NULL);
        
        mAttrs = [[NSMutableDictionary alloc] initWithObjectsAndKeys:(id)[[UIColor whiteColor] CGColor], kCTForegroundColorAttributeName,
                                                                     (id)sFontRef, kCTFontAttributeName, nil];
        
        CFRelease(sFontRef);
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


- (void)setString:(NSString *)aString
{
    [mAttrString autorelease];
    mAttrString = [[NSMutableAttributedString alloc] initWithString:aString];
    
    [mAttrString setAttributes:mAttrs range:NSMakeRange(0, [aString length])];

    PBFrameRelease(mFrame);
    
    CTFramesetterRef sFramesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)mAttrString);
    CGSize           sConstraints = CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);
    CFRange          sFitRange;
    CGSize           sFrameSize   = CTFramesetterSuggestFrameSizeWithConstraints(sFramesetter, CFRangeMake(0, [aString length]), NULL, sConstraints, &sFitRange);
    CGMutablePathRef sPath        = CGPathCreateMutable();
    
    CGPathAddRect(sPath, NULL, CGRectMake(0, 0, sFrameSize.width, sFrameSize.height));

    sFrameSize.width  = ceilf(sFrameSize.width);
    sFrameSize.height = ceilf(sFrameSize.height);

    mFrame = CTFramesetterCreateFrame(sFramesetter, CFRangeMake(0, 0), sPath, NULL);
    
    CFRelease(sFramesetter);
    
    [self setSize:sFrameSize];
    [self update];
}


- (void)drawInContext:(CGContextRef)aContext bounds:(CGRect)aBounds
{
    CGContextClearRect(aContext, aBounds);

//    CGContextSetFillColorWithColor(aContext, [[UIColor grayColor] CGColor]);
//    CGContextFillRect(aContext, aBounds);
//    
//    CGContextSetLineWidth(aContext, 1);
//    CGContextSetStrokeColorWithColor(aContext, [[UIColor whiteColor] CGColor]);
//    CGContextStrokeRect(aContext, aBounds);

    CTFrameDraw(mFrame, aContext);
}


@end
