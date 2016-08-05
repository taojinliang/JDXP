//
//  HSBarcodeScanner.h
//  HSBarcodeScanner
//
//  Created by LingBinXing on 15/5/21.
//  Copyright (c) 2015年 hundsun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, BSCamera) {
    BSCameraBack,
    BSCameraFront
};

typedef void(^BSScanResultBlock)(NSString *code);

@interface HSBarcodeScanner : NSObject

/**
 *  @brief  摄像头种类（默认后置摄像头）
 */
@property (nonatomic, assign) BSCamera camera;

@property (nonatomic, strong) NSValue* scanRect; // CGRect


/**
 *  @brief  给定一个现有的预览视图，初始化扫描器
 *  @param previewView 预览视图
 *  @return 扫描器实例
 */
- (instancetype)initWithPreviewView:(UIView *)previewView;

/**
 *  @brief  返回设备是否有摄像头
 *  @return YES如果有
 */
+ (BOOL)cameraIsPresent;

/**
 *  @brief  返回摄像头是否被设备持有者禁用
 *  @return YES如果禁用
 */
+ (BOOL)scanningIsProhibited;

/**
 *  @brief  请求访问摄像头
 *  @param successBlock successBlock返回YES如果用户同意授权，否则NO如果用户禁用/没有摄像头
 */
+ (void)requestCameraPermissionWithSuccess:(void (^)(BOOL success))successBlock;

/**
 *  @brief  当前摄像头是否有补光灯
 *  @return YES如果有
 */
- (BOOL)hasTorch;
- (BOOL)isTorchOpened;
- (void)setTorchOpened:(BOOL)open;

/**
 *  @brief  开始扫描机器码。摄像头输入层将作为sublayer加到给定的previewView中。
 *  @param resultBlock 扫描解码后的回调
 */
- (void)startScanningWithResultBlock:(BSScanResultBlock)resultBlock;

/**
 *  @brief  停止扫描机器码。摄像头输入层sublayer会从给定的previewView中移除。
 */
- (void)stopScanning;

/**
 *  @brief  从图片扫描
 *  @param image       扫描的图片
 *  @param resultBlock 扫描解码后的回调
 */
+ (void)scanFromImage:(CGImageRef)image resultBlock:(BSScanResultBlock)resultBlock;

/**
 *  @brief  是否正在扫描中
 *  @return YES如果正在扫描中
 */
- (BOOL)isScanning;

/**
 *  @brief  反转前后摄像头。如果当前是前置，切换到后置；反之同理。
 */
- (void)flipCamera;

@end
