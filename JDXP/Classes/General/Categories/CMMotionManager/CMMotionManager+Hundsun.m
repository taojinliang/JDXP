//
//  CMMotionManager+Hundsun.m
//  BreezeLib
//
//  Created by LingBinXing on 15/5/27.
//  Copyright (c) 2015年 hundsun. All rights reserved.
//

#import "CMMotionManager+Hundsun.h"
#import <objc/runtime.h>

#define kAccelerometerFrequency			25 //Hz

@interface StackCounter : NSObject {
    NSInteger _count;
}
@property (nonatomic, assign, readonly) NSInteger count;
- (void)push;
- (void)pop;
@end

@implementation CMMotionManager (Hundsun)
@dynamic processQueue;

static StackCounter* s_AccelerometerUpdatesRequestCounter = nil;

+ (instancetype)sharedManager
{
    static CMMotionManager* s_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_manager = [[CMMotionManager alloc] init];
        s_manager.accelerometerUpdateInterval = 1.0 / kAccelerometerFrequency;
        s_AccelerometerUpdatesRequestCounter = [[StackCounter alloc] init];
    });
    return s_manager;
}

- (NSOperationQueue *)processQueue
{
    NSOperationQueue* queue = objc_getAssociatedObject(self, @selector(processQueue));
    if (queue == nil) {
        queue = [[NSOperationQueue alloc] init];
        objc_setAssociatedObject(self, @selector(processQueue), queue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return queue;
}

- (void)stack_startAccelerometerUpdatesWithHandler:(CMAccelerometerHandler)handler
{
    @synchronized(s_AccelerometerUpdatesRequestCounter) {
        [s_AccelerometerUpdatesRequestCounter push];
        [self startAccelerometerUpdatesToQueue:self.processQueue withHandler:handler];
    }
}

- (void)stack_stopAccelerometerUpdates
{
    @synchronized(s_AccelerometerUpdatesRequestCounter) {
        [s_AccelerometerUpdatesRequestCounter pop];
        if (s_AccelerometerUpdatesRequestCounter.count <= 0) {
            [self stopAccelerometerUpdates];
        }
    }
}

@end

@implementation StackCounter
@synthesize count = _count;
- (void)push
{
    _count++;
}
- (void)pop
{
    _count--;
}
@end
