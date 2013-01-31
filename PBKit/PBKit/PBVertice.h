/*
 *  PBVertice.h
 *  PBKit
 *
 *  Created by camelkode on 13. 1. 14..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
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


static inline PBVertice4 multiplyScale(PBVertice4 aVertices,  CGFloat aScale)
{
    aVertices.x1 *= aScale;
    aVertices.x2 *= aScale;
    aVertices.y1 *= aScale;
    aVertices.y2 *= aScale;
    
    return aVertices;
}


static inline PBVertice4 addVertice4FromVertice3(PBVertice4 aVertices4, PBVertice3 aVertices3)
{
    aVertices4.x1 += aVertices3.x;
    aVertices4.x2 += aVertices3.x;
    aVertices4.y1 += aVertices3.y;
    aVertices4.y2 += aVertices3.y;
    
    return aVertices4;
}


//static inline CGSize convertSizeFromViewSize(CGSize aSize)
//{
//    CGSize sSize = CGSizeMake(0, 0);
//    GLint currentViewPort[4];
//    glGetIntegerv(GL_VIEWPORT, currentViewPort);
//    
//    sSize.width  = (aSize.width  / currentViewPort[2]) * 2.0;
//    sSize.height = (aSize.height  / currentViewPort[3]) * 2.0;
//    
//    return sSize;
//}
//
//
//static inline PBVertice2 convertVertice2FromViewPoint(CGPoint aPoint)
//{
//    PBVertice2 sVertice2;
//    GLint currentViewPort[4];
//    glGetIntegerv(GL_VIEWPORT, currentViewPort);
//    
//    sVertice2.x = (2.0 * (aPoint.x / currentViewPort[2] * 100) / 100) - 1;
//    sVertice2.y = ((2.0 * (aPoint.y / currentViewPort[3] * 100) / 100) - 1) * -1;
//    
//    return sVertice2;
//}


static inline PBVertice4 convertVertice4FromViewSize(CGSize aSize)
{
    PBVertice4 sVertice4;
    sVertice4.x1 = -(aSize.width / 2);
    sVertice4.y1 = (aSize.height / 2);
    sVertice4.x2 = (aSize.width / 2);
    sVertice4.y2 = -(aSize.height / 2);
    
    return sVertice4;
}


static inline PBVertice4 convertVertice4FromViewRect(CGRect aRect)
{
    PBVertice4 sVertice4;
    
    CGPoint sPoint = aRect.origin;
    CGSize  sSize  = aRect.size;
    
    sVertice4.x1   = sPoint.x - (sSize.width / 2);
    sVertice4.y1   = sPoint.y + (sSize.height / 2);
    sVertice4.x2   = sPoint.x + (sSize.width / 2);
    sVertice4.y2   = sPoint.y - (sSize.height / 2);
    
    return sVertice4;
}


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
