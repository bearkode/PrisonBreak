/*
 *  PBRenderTestReport.h
 *  PBKit
 *
 *  Created by camelkode on 13. 5. 10..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */


#ifndef PBKit_PBRenderTestReport_h
#define PBKit_PBRenderTestReport_h


typedef struct {
    GLint testMeshesCount;
    GLint testDrawCallCount;
    GLint testDrawMeshCallCount;
    GLint testDrawMeshQueueCallCount;
    GLint testVertexCount;
} PBRenderTestReport;


extern GLboolean gRenderTesting;
extern PBRenderTestReport gRenderTestReport;


static inline void PBRenderResetReport()
{
    memset(&gRenderTestReport, 0, sizeof(PBRenderTestReport));
}


static inline void PBRenderTesting(GLboolean aTesting)
{
    gRenderTesting = aTesting;
}


static inline PBRenderTestReport PBRenderReport()
{
    return gRenderTestReport;
}



#endif
