/*
 *  PBObjCUtil.h
 *  PBKit
 *
 *  Created by han9kin on 09. 02. 19.
 *  Copyright 2008 PrisonBreak Corp. All rights reserved.
 *
 */


#pragma mark - API Availability


#define PB_DEPRECATED __attribute__((deprecated))


#pragma mark - Assertions


#define SubclassResponsibility()                                        \
    do                                                                  \
    {                                                                   \
        NSLog(@"SubclassResponsibility %@[%@ %@] not implemented.",     \
              (([self class] == self) ? @"+" : @"-"),                   \
              NSStringFromClass([self class]),                          \
              NSStringFromSelector(_cmd));                              \
        abort();                                                        \
    } while (0)


#pragma mark - Shared Instance Synthesizers


#define SYNTHESIZE_SHARED_INSTANCE(aClassName, aAccessor) SYNTHESIZE_SHARED_INSTANCE_WITH_RETURNTYPE(aClassName, aClassName *, aAccessor)

#define SYNTHESIZE_SHARED_INSTANCE_WITH_RETURNTYPE(aClassName, aReturnType, aAccessor)  \
                                                                                        \
+ (aReturnType)aAccessor                                                                \
{                                                                                       \
    static dispatch_once_t sOnce;                                                       \
    static aReturnType sInstance;                                                       \
                                                                                        \
    dispatch_once(&sOnce, ^{                                                            \
            sInstance = [[self alloc] init];                                            \
        });                                                                             \
                                                                                        \
    return sInstance;                                                                   \
}


#pragma mark - Singleton Object Synthesizers


#define SYNTHESIZE_SINGLETON_CLASS(aClassName, aAccessor) SYNTHESIZE_SINGLETON_CLASS_WITH_RETURNTYPE(aClassName, aClassName *, aAccessor)

#define SYNTHESIZE_SINGLETON_CLASS_WITH_RETURNTYPE(aClassName, aReturnType, aAccessor)  \
                                                                                        \
static aClassName *aAccessor = nil;                                                     \
                                                                                        \
+ (aReturnType)aAccessor                                                                \
{                                                                                       \
    static dispatch_once_t sOnce;                                                       \
                                                                                        \
    dispatch_once(&sOnce, ^{                                                            \
            aAccessor = [[self alloc] init];                                            \
        });                                                                             \
                                                                                        \
    return aAccessor;                                                                   \
}                                                                                       \
                                                                                        \
+ (id)allocWithZone:(NSZone *)aZone                                                     \
{                                                                                       \
    static dispatch_once_t sOnce;                                                       \
                                                                                        \
    dispatch_once(&sOnce, ^{                                                            \
            aAccessor = [super allocWithZone:aZone];                                    \
        });                                                                             \
                                                                                        \
    return aAccessor;                                                                   \
}                                                                                       \
                                                                                        \
- (id)copyWithZone:(NSZone *)aZone                                                      \
{                                                                                       \
    return self;                                                                        \
}                                                                                       \
                                                                                        \
- (id)retain                                                                            \
{                                                                                       \
    return self;                                                                        \
}                                                                                       \
                                                                                        \
- (NSUInteger)retainCount                                                               \
{                                                                                       \
    return NSUIntegerMax;                                                               \
}                                                                                       \
                                                                                        \
- (oneway void)release                                                                  \
{                                                                                       \
}                                                                                       \
                                                                                        \
- (id)autorelease                                                                       \
{                                                                                       \
    return self;                                                                        \
}
