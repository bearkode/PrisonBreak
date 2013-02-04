/*
 *  PBVertices.h
 *  PBKit
 *
 *  Created by camelkode on 13. 1. 14..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */

#ifndef PBVertices_h
#define PBVertices_h


typedef struct {
    CGFloat x;
    CGFloat y;
} PBVertex2;


typedef struct {
    CGFloat x;
    CGFloat y;
    CGFloat z;
} PBVertex3;


typedef struct {
    CGFloat x1;
    CGFloat x2;
    CGFloat y1;
    CGFloat y2;
} PBVertex4;


typedef struct {
    CGFloat x1;
    CGFloat y1;
    CGFloat x2;
    CGFloat y2;
    CGFloat x3;
    CGFloat y3;
    CGFloat x4;
    CGFloat y4;
} PBTextureVertices;


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


static inline PBVertex2 PBVertex2Make(CGFloat x, CGFloat y)
{
    PBVertex2 p;
    
    p.x = x;
    p.y = y;
    
    return p;
}


static inline PBVertex3 PBVertex3Make(CGFloat x, CGFloat y, CGFloat z)
{
    PBVertex3 p;
    
    p.x = x;
    p.y = y;
    p.z = z;
    
    return p;
}


static inline PBVertex4 PBVertex4Make(CGFloat x1, CGFloat y1, CGFloat x2, CGFloat y2)
{
    PBVertex4 p;
    
    p.x1 = x1;
    p.x2 = x2;
    p.y1 = y1;
    p.y2 = y2;
    
    return p;
}


static inline PBVertex4 PBMultiplyScale(PBVertex4 aVertex4,  CGFloat aScale)
{
    aVertex4.x1 *= aScale;
    aVertex4.x2 *= aScale;
    aVertex4.y1 *= aScale;
    aVertex4.y2 *= aScale;
    
    return aVertex4;
}


static inline PBVertex4 PBAddVertex4FromVertex3(PBVertex4 aVertex4, PBVertex3 aVertex3)
{
    aVertex4.x1 += aVertex3.x;
    aVertex4.x2 += aVertex3.x;
    aVertex4.y1 += aVertex3.y;
    aVertex4.y2 += aVertex3.y;
    
    return aVertex4;
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


static inline PBVertex4 PBConvertVertex4FromViewSize(CGSize aSize)
{
    PBVertex4 sVertex4;
    sVertex4.x1 = -(aSize.width / 2);
    sVertex4.y1 = (aSize.height / 2);
    sVertex4.x2 = (aSize.width / 2);
    sVertex4.y2 = -(aSize.height / 2);
    
    return sVertex4;
}


static inline PBVertex4 PBConvertVertex4FromViewRect(CGRect aRect)
{
    PBVertex4 sVertex4;
    
    CGPoint sPoint = aRect.origin;
    CGSize  sSize  = aRect.size;
    
    sVertex4.x1   = sPoint.x - (sSize.width / 2);
    sVertex4.y1   = sPoint.y + (sSize.height / 2);
    sVertex4.x2   = sPoint.x + (sSize.width / 2);
    sVertex4.y2   = sPoint.y - (sSize.height / 2);
    
    return sVertex4;
}


static inline PBTextureVertices PBGeneratorTextureVertex4(PBVertex4 aVertex4)
{
    PBTextureVertices sTextureVertice;
    
    sTextureVertice.x1 = aVertex4.x1;
    sTextureVertice.x2 = aVertex4.x1;
    sTextureVertice.x3 = aVertex4.x2;
    sTextureVertice.x4 = aVertex4.x2;
    sTextureVertice.y1 = aVertex4.y1;
    sTextureVertice.y2 = aVertex4.y2;
    sTextureVertice.y3 = aVertex4.y2;
    sTextureVertice.y4 = aVertex4.y1;
    
    return sTextureVertice;
}


static inline PBTextureVertices PBGeneratorTextureVertices(CGFloat x1, CGFloat x2, CGFloat x3, CGFloat x4, CGFloat y1, CGFloat y2, CGFloat y3, CGFloat y4)
{
    PBTextureVertices sTextureVertice;

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
