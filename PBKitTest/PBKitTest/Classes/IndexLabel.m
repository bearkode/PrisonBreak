/*
 *  IndexLabel.m
 *  PBKitTest
 *
 *  Created by bearkode on 13. 6. 26..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import "IndexLabel.h"


@implementation IndexLabel
{
    NSInteger mTextureIndex;
}


- (void)setTextureIndex:(NSInteger)aTextureIndex
{
    mTextureIndex = aTextureIndex;
    [self updateDynamicTexture];
}


- (void)drawInRect:(CGRect)aRect context:(CGContextRef)aContext
{
    NSString *sText  = [NSString stringWithFormat:@"INDEX = %d", mTextureIndex];
    CGFloat   sScale = [[self texture] imageScale];
    
    CGContextClearRect(aContext, aRect);
    
#if (0)
    CGContextSetFillColorWithColor(aContext, [[UIColor redColor] CGColor]);
    CGContextFillRect(aContext, aRect);
#endif
    
    CGContextSelectFont(aContext, "MarkerFelt-Thin", 16 * sScale, kCGEncodingMacRoman);
    CGContextSetTextDrawingMode(aContext, kCGTextFill);
    
    CGContextSetFillColorWithColor(aContext, [[UIColor lightGrayColor] CGColor]);
    CGContextShowTextAtPoint(aContext, 1 * sScale, 5 * sScale, [sText UTF8String], strlen([sText UTF8String]));
    
    CGContextSetFillColorWithColor(aContext, [[UIColor whiteColor] CGColor]);
    CGContextShowTextAtPoint(aContext, 0 * sScale, 6 * sScale, [sText UTF8String], strlen([sText UTF8String]));
}


@end
