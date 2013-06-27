/*
 *  PBMacro.h
 *
 *  Created by camelkode on 13. 6. 27..
 *  Copyright (c) 2012 PrisonBreak. All rights reserved.
 *
 */


#ifndef PBKit_PBMacro_h
#define PBKit_PBMacro_h


#define PBDegreesToRadians(aDegrees) ((aDegrees) * M_PI / 180.0)
#define PBRadiansToDegrees(aRadians) ((aRadians) * 180.0 / M_PI)


#define PBBeginTimeCheck()           double __sCurrentTime = CACurrentMediaTime()
#define PBEndTimeCheck()             NSLog(@"time = %f", CACurrentMediaTime() - __sCurrentTime)


#endif
