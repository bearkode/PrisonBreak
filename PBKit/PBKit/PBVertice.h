/*
 *  PBVertice.h
 *  PBKit
 *
 *  Created by sshanks on 13. 1. 14..
 *  Copyright (c) 2013년 sshanks. All rights reserved.
 *
 */

#ifndef PBVertice_h
#define PBVertice_h


typedef struct {
    CGFloat x;
    CGFloat y;
} PBVertice2;


typedef struct {
    CGFloat x;
    CGFloat y;
    CGFloat z;
} PBVertice3;


typedef struct {
    CGFloat x1;
    CGFloat x2;
    CGFloat y1;
    CGFloat y2;
} PBVertice4;


typedef struct {
    CGFloat x1;
    CGFloat y1;
    CGFloat x2;
    CGFloat y2;
    CGFloat x3;
    CGFloat y3;
    CGFloat x4;
    CGFloat y4;
} PBTextureVertice;


static const GLfloat gTextureVertices[] =
{
    0.0f, 0.0f,
    0.0f, 1.0f,
    1.0f, 1.0f,
    1.0f, 0.0f,
};


static const GLushort gIndices[] = { 0, 1, 2, 0, 2, 3 };
//static const GLushort gIndices[] = { 3, 0, 1, 3, 1, 2 };
//static const GLushort gIndices[] = { 0, 1, 3, 2 };


static inline PBVertice2 PBVertice2Make(CGFloat x, CGFloat y)
{
    PBVertice2 p;
    
    p.x = x;
    p.y = y;
    
    return p;
}


static inline PBVertice3 PBVertice3Make(CGFloat x, CGFloat y, CGFloat z)
{
    PBVertice3 p;
    
    p.x = x;
    p.y = y;
    p.z = z;
    
    return p;
}


static inline PBVertice4 PBVertice4Make(CGFloat x1, CGFloat y1, CGFloat x2, CGFloat y2)
{
    PBVertice4 p;
    
    p.x1 = x1;
    p.x2 = x2;
    p.y1 = y1;
    p.y2 = y2;
    
    return p;
}


static inline PBVertice2 convertVertice2FromView(CGPoint aPoint)
{
    PBVertice2 sVertice2;
    GLint currentViewPort[4];
    glGetIntegerv(GL_VIEWPORT, currentViewPort);
    
    sVertice2.x = (2.0 * (aPoint.x / currentViewPort[2] * 100) / 100) - 1;
    sVertice2.y = ((2.0 * (aPoint.y / currentViewPort[3] * 100) / 100) - 1) * -1;
    
    //    sRect.size = CGSizeMake(aTexture.textureSize.width, aTexture.textureSize.height);
    //    CGPoint ssPoint;
    //    ssPoint.x = aPoint.x / 480 * (480 - 0) + 0;
    //    ssPoint.y = (1.0 - aPoint.y / 320) * (0 - 320) + 320;
    //    ssPoint.x = (aPoint.x - 0) / (480 - 0) * 480;
    //    ssPoint.y = (1.0 - (aPoint.y - 320) / (0 - 320)) * 320;
    
    //    NSLog(@"%f %f (%f, %f)", sRect.origin.x, sRect.origin.y, sRect.size.width, sRect.size.height);
    //    return sRect;
    
    //    240 / 480 * 100 = 50%
    //    2.0 * 50% / 100 = 1
    //    1 - 1 = 0;
    
    return sVertice2;
}

static inline PBVertice4 convertVertice4FromView(CGPoint aPoint, CGSize aSize)
{
    PBVertice2 sVertice2      = convertVertice2FromView(aPoint);
    PBVertice4 sVertice4;
    GLint currentViewPort[4];
    glGetIntegerv(GL_VIEWPORT, currentViewPort);
    
    CGFloat sWidthScaleRatio  = (aSize.width  / currentViewPort[2]) * 2.0;
    CGFloat sHeightScaleRatio = (aSize.height  / currentViewPort[3]) * 2.0;
    
    sVertice4.x1 = sVertice2.x;
    sVertice4.y1 = sVertice2.y;
    sVertice4.x2 = sVertice4.x1 + sWidthScaleRatio;
    sVertice4.y2 = sVertice4.y1 - sHeightScaleRatio;
    
    return sVertice4;
}


//GLfloat sTexVertices[] =
//{
//    0.0f,  0.0f,        // TexCoord 0
//    0.0f,  1.0f,        // TexCoord 1
//    1.0f,  1.0f,        // TexCoord 2
//    1.0f,  0.0f         // TexCoord 3
//};


//GLfloat sPosVertices[] =
//{
//    -1.0f,  1.0f, 0.0f, // Position 0
//    -1.0f, -1.0f, 0.0f, // Position 1
//    1.0f, -1.0f, 0.0f,  // Position 2
//    1.0f,  1.0f, 0.0f   // Position 3
//};


static inline PBTextureVertice generatorTextureVertice4(PBVertice4 aVertice4)
{
    PBTextureVertice sTextureVertice;
    sTextureVertice.x1 = aVertice4.x1;
    sTextureVertice.x2 = aVertice4.x1;
    sTextureVertice.x3 = aVertice4.x2;
    sTextureVertice.x4 = aVertice4.x2;
    sTextureVertice.y1 = aVertice4.y1;
    sTextureVertice.y2 = aVertice4.y2;
    sTextureVertice.y3 = aVertice4.y2;
    sTextureVertice.y4 = aVertice4.y1;
    
    return sTextureVertice;
}


static inline PBTextureVertice generatorTextureVertices(CGFloat x1, CGFloat x2, CGFloat x3, CGFloat x4, CGFloat y1, CGFloat y2, CGFloat y3, CGFloat y4)
{
    PBTextureVertice sTextureVertice;
    sTextureVertice.x1 = x1;
    sTextureVertice.x2 = x2;
    sTextureVertice.x3 = x3;
    sTextureVertice.x4 = x4;
    sTextureVertice.y1 = y1;
    sTextureVertice.y2 = y2;
    sTextureVertice.y3 = y3;
    sTextureVertice.y4 = y4;
    
    return sTextureVertice;
}

#endif
