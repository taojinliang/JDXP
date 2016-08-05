//
//  CMMotionManager+Hundsun.h
//  BreezeLib
//
//  Created by LingBinXing on 15/5/27.
//  Copyright (c) 2015年 hundsun. All rights reserved.
//

@import CoreMotion;

@interface CMMotionManager (Hundsun)
@property (nonatomic, strong, readonly) NSOperationQueue* processQueue;

+ (instancetype)sharedManager;

/**
 *  @brief  入栈一个开始监听加速器请求
 *  @param handler 回调。!注意不在主线程上
 */
- (void)stack_startAccelerometerUpdatesWithHandler:(CMAccelerometerHandler)handler;

/**
 *  @brief  出栈一个停止监听加速器请求
 */
- (void)stack_stopAccelerometerUpdates;

@end
