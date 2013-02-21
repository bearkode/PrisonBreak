/*
 *  ProfilingOverlay.m
 *  PBKitTest
 *
 *  Created by camelkode on 13. 2. 21..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */


#import "ProfilingOverlay.h"
#import <mach/mach.h>
#import <mach/mach_host.h>
#import "ProfilingOverlayView.h"
#import <../PBCommon/PBObjCUtil.h>


static BOOL  gOverlayHidden = YES;
static BOOL  gOverlayTop    = YES;
static float gOverlayAlpha  = 0.7f;

static NSInteger gCurrentFPS = 0;
static CFTimeInterval gCurrentTimeInterval = 0.0;


@implementation ProfilingOverlay


SYNTHESIZE_SINGLETON_CLASS(ProfilingOverlay, sharedManager);


#pragma mark - MTStatusBarOverlay


+ (NSString *)reportMemory 
{
    static unsigned int last_resident_size = 0;
    static unsigned int greatest           = 0;
    static unsigned int last_greatest      = 0;
    
    NSString *returnedString = @"";
    
    struct task_basic_info info;
    
    mach_msg_type_number_t size = sizeof(info);
    kern_return_t kerr = task_info(mach_task_self(),
                                   TASK_BASIC_INFO,
                                   (task_info_t)&info,
                                   &size);
    if (kerr == KERN_SUCCESS)
    {
        //int diff = (int)info.resident_size - (int)last_resident_size;
        unsigned int latest = info.resident_size;
        if (latest > greatest) 
            greatest = latest;  // track greatest mem usage
        
        //int greatest_diff        = greatest - last_greatest;
        //int latest_greatest_diff = latest - greatest;
        
        /*
         NSLog(@"Mem: %10u (%10d) : %10d : greatest: %10u (%d)", 
         info.resident_size, 
         diff,
         latest_greatest_diff,
         greatest, greatest_diff  );
         */
        
//        returnedString = [NSString stringWithFormat:@"%u MB(%u MB)", info.resident_size / (1024 * 1024), greatest / (1024 * 1024)];
        returnedString = [NSString stringWithFormat:@"%umb(%umb)", info.resident_size / (1024 * 1024), greatest / (1024 * 1024)];
    }
    else 
    {
        NSLog(@"Error with task_info(): %s", mach_error_string(kerr));
    }
    
    last_resident_size = info.resident_size;
    last_greatest = greatest;
    
    return returnedString;
}

+ (float)cpuUsage
{
    kern_return_t           kr;
    task_info_data_t        tinfo;
    mach_msg_type_number_t  task_info_count;
    
    task_info_count = TASK_INFO_MAX;
    kr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)tinfo, &task_info_count);
    if (kr != KERN_SUCCESS) 
    {
        return -1;
    }
    
    //task_basic_info_t      basic_info;
    thread_array_t         thread_list;
    mach_msg_type_number_t thread_count;
    
    thread_info_data_t     thinfo;
    mach_msg_type_number_t thread_info_count;
    
    thread_basic_info_t    basic_info_th;
    //uint32_t               stat_thread = 0; // Mach threads
    
    //basic_info = (task_basic_info_t)tinfo;
    
    // get threads in the task
    kr = task_threads(mach_task_self(), &thread_list, &thread_count);
    if (kr != KERN_SUCCESS) 
        return -1;
    
    //if (thread_count > 0)
    //    stat_thread += thread_count;
    
    long tot_sec = 0;
    long tot_usec = 0;
    float tot_cpu = 0;
    int j;
    
    for (j = 0; j < thread_count; j++)
    {
        thread_info_count = THREAD_INFO_MAX;
        kr = thread_info(thread_list[j], THREAD_BASIC_INFO,
                         (thread_info_t)thinfo, &thread_info_count);
        if (kr != KERN_SUCCESS) {
            return -1;
        }
        
        basic_info_th = (thread_basic_info_t)thinfo;
        
        if (!(basic_info_th->flags & TH_FLAGS_IDLE)) 
        {
            tot_sec = tot_sec + basic_info_th->user_time.seconds + basic_info_th->system_time.seconds;
            tot_usec = tot_usec + basic_info_th->system_time.microseconds + basic_info_th->system_time.microseconds;
            tot_cpu = tot_cpu + basic_info_th->cpu_usage / (float)TH_USAGE_SCALE * 100.0;
        }
        
    } // for each thread
    
    return tot_cpu;
}

+ (void)setHidden:(BOOL)aHidden
{
    gOverlayHidden = aHidden;
    ProfilingOverlayView *sOverlayView = [ProfilingOverlayView sharedManager];
    [sOverlayView setHidden:gOverlayHidden];
}

+ (BOOL)isHidden
{
    return gOverlayHidden;
}

+ (BOOL)isTop
{
    return gOverlayTop;
}

+ (void)setTop:(BOOL)aTop
{
    gOverlayTop = aTop;
    
    ProfilingOverlayView *sOverlayView = [ProfilingOverlayView sharedManager];
     CGRect sBounds = [[UIScreen mainScreen] bounds];
    if (aTop) 
    {
        [sOverlayView setFrame:CGRectMake(0, 0, sBounds.size.width, 20)];
    }
    else
    {
        [sOverlayView setFrame:CGRectMake(0, sBounds.size.height - 20, sBounds.size.width, 20)];
    }
}

+ (void)setAlpha:(float)aAlpha
{
    gOverlayAlpha = aAlpha;
    ProfilingOverlayView *sOverlayView = [ProfilingOverlayView sharedManager];
    [sOverlayView setAlpha:gOverlayAlpha];
}


+ (void)setFPS:(NSInteger)aFPS
{
    gCurrentFPS = aFPS;
}

+ (void)setTimeInterval:(CFTimeInterval)aTimeInterval
{
    gCurrentTimeInterval = aTimeInterval;
}

#pragma mark -


- (void)startCPUMemoryUsages
{
    ProfilingOverlayView *sOverlayView = [ProfilingOverlayView sharedManager];
    [sOverlayView setAlpha:gOverlayAlpha];
    
    //dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    if (mTimer)
    {
        dispatch_source_cancel(mTimer);
        dispatch_release(mTimer);
        
        mTimer = nil;
    }
    
    mTimer                 = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    int timeout  = 0.5f;
    int interval = 1.0f;
    
    dispatch_source_set_timer(mTimer, dispatch_time(DISPATCH_TIME_NOW, timeout * NSEC_PER_SEC), interval * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(mTimer, ^{
        __block NSString *aMessage = [[NSString stringWithFormat:@"M=%@, C=%.1f %%",
                                       [ProfilingOverlay reportMemory],
                                       [ProfilingOverlay cpuUsage]] retain];
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            ProfilingOverlayView *sOverlayView = [ProfilingOverlayView sharedManager];
            [sOverlayView setDisplayMessage:aMessage];
            [aMessage release];
        });
    });
    
    // now that our timer is all set to go, start it
    dispatch_resume(mTimer);
}


- (void)stopCPUMemoryUsages
{
    if (mTimer)
    {
        dispatch_source_cancel(mTimer);
        dispatch_release(mTimer);

        mTimer = nil;
    }
}

- (void)startDisplayFPS
{
    [self stopCPUMemoryUsages];    
    
    ProfilingOverlayView *sOverlayView = [ProfilingOverlayView sharedManager];
    [sOverlayView setAlpha:gOverlayAlpha];
    
    NSString *aMessage = [NSString stringWithFormat:@"FPS=%d, T=%.4f, M=%@, C=%.1f %%",
                          gCurrentFPS,
                          gCurrentTimeInterval,
                          [ProfilingOverlay reportMemory],
                          [ProfilingOverlay cpuUsage]];
    [sOverlayView setDisplayMessage:aMessage];
}


- (void)displayFPS:(NSInteger)aFPS timeInterval:(CFTimeInterval)aTimeInterval
{
    [ProfilingOverlay setFPS:aFPS];
    [ProfilingOverlay setTimeInterval:aTimeInterval];
    [self startDisplayFPS];
}


- (void)stopDisplayFPS
{
    [self startCPUMemoryUsages];
}


@end
