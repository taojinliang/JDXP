//
//  HSBarcodeScanner.m
//  HSBarcodeScanner
//
//  Created by LingBinXing on 15/5/21.
//  Copyright (c) 2015年 hundsun. All rights reserved.
//

#import "HSBarcodeScanner.h"
#import "NSBundle+Hundsun.h"
#import "MTBBarcodeScanner.h"
#import "ZXCapture.h"
#import "ZXCaptureDelegate.h"
#import "ZXResult.h"
#import "UIAlertView+Blocks.h"

#import "ZXCGImageLuminanceSource.h"
#import "ZXHybridBinarizer.h"
#import "ZXBinaryBitmap.h"
#import "ZXMultiFormatReader.h"
#import "ZXDecodeHints.h"

#define kBarcodeScanner_bundle   @"BarcodeScanner.bundle"

#ifndef kCFCoreFoundationVersionNumber_iOS_7_0
#define kCFCoreFoundationVersionNumber_iOS_7_0 847.20
#endif

#define _BS_iOS7 (NSFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_7_0)

// 测试ZXing用
//#define _BS_iOS7 0

@interface HSBarcodeScanner () <ZXCaptureDelegate>
{
    MTBBarcodeScanner* _avfInternal;
    ZXCapture* _zxingInternal;
    __weak UIView* _previewView;
}
@property (nonatomic, copy) BSScanResultBlock zxingBlockCopy;
@end

@implementation HSBarcodeScanner

- (instancetype)initWithPreviewView:(UIView *)previewView
{
    self = [super init];
    if (self) {
        _previewView = previewView;
        if (_BS_iOS7) {
            _avfInternal = [[MTBBarcodeScanner alloc] initWithPreviewView:previewView];
        } else {
            _zxingInternal = [[ZXCapture alloc] init];
            _zxingInternal.camera = _zxingInternal.back;
            _zxingInternal.focusMode = AVCaptureFocusModeContinuousAutoFocus;
            _zxingInternal.rotation = 90.0f;
        }
    }
    return self;
}

+ (BOOL)cameraIsPresent
{
    return [MTBBarcodeScanner cameraIsPresent];
}

+ (BOOL)scanningIsProhibited
{
    return [MTBBarcodeScanner scanningIsProhibited];
}

+ (void)requestCameraPermissionWithSuccess:(void (^)(BOOL success))successBlock
{
    return [MTBBarcodeScanner requestCameraPermissionWithSuccess:successBlock];
}

- (BOOL)hasTorch
{
    AVCaptureDevice* device = nil;
    if (_BS_iOS7) {
        device = _avfInternal.captureDevice;
    } else {
        device = _zxingInternal.captureDevice;
    }
    if (device) {
        return device.hasTorch;
    } else {
        return NO;
    }
}

- (BOOL)isTorchOpened
{
    AVCaptureDevice* device = nil;
    if (_BS_iOS7) {
        device = _avfInternal.captureDevice;
    } else {
        device = _zxingInternal.captureDevice;
    }
    
    if (device) {
        if ([device hasTorch]) {
            return device.torchMode == AVCaptureTorchModeOn;
        }
    }
    return NO;
}

- (void)setTorchOpened:(BOOL)open
{
    AVCaptureDevice* device = nil;
    if (_BS_iOS7) {
        device = _avfInternal.captureDevice;
    } else {
        device = _zxingInternal.captureDevice;
    }
    
    if (device) {
        BOOL lock = [device lockForConfiguration:nil];
        if ( [device hasTorch] ) {
            if ( open ) {
                [device setTorchMode:AVCaptureTorchModeOn];
            } else {
                [device setTorchMode:AVCaptureTorchModeOff];
            }
        }
        if (lock) {
            [device unlockForConfiguration];
        }
    }
}

- (void)startScanningWithResultBlock:(BSScanResultBlock)resultBlock
{
    if (_BS_iOS7) {
        _avfInternal.scanRect = self.scanRect;
        
        if ([[self class] cameraIsPresent]) {
            [[self class] requestCameraPermissionWithSuccess:^(BOOL success) {
                if (success) {
                    [_avfInternal startScanningWithResultBlock:^(NSArray *codes) {
                        if (codes.count && resultBlock) {
                            AVMetadataMachineReadableCodeObject* codeObject = [codes firstObject];
                            resultBlock(codeObject.stringValue);
                        }
                    }];
                } else {
                    // 提示用户打开权限
                    if ([UIDevice currentDevice].systemVersion.floatValue < 8.0) {
                        [UIAlertView showWithTitle:nil message:HSLocalizedStringInBundle(@"camera_no_permission_msg_old", kBarcodeScanner_bundle, nil)
                            cancelButtonTitle:HSLocalizedStringInBundle(@"camera_no_permission_ok", kBarcodeScanner_bundle, nil)
                                 otherButtonTitles:nil tapBlock:nil];
                    } else {
                        // iOS8 上直接提供系统“设置”入口
                        [UIAlertView showWithTitle:nil    message:HSLocalizedStringInBundle(@"camera_no_permission_msg_new", kBarcodeScanner_bundle, nil)
                        cancelButtonTitle:HSLocalizedStringInBundle(@"camera_no_permission_cancel", kBarcodeScanner_bundle, nil)
                    otherButtonTitles:@[HSLocalizedStringInBundle(@"camera_no_permission_setting", kBarcodeScanner_bundle, nil)]
                                          tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                            if (buttonIndex != alertView.cancelButtonIndex) {
                                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                            }
                        }];
                    }
                }
            }];
        }
    } else {
        _zxingInternal.layer.frame = _previewView.bounds;
        [_previewView.layer addSublayer:_zxingInternal.layer];
        
        self.zxingBlockCopy = resultBlock;
        _zxingInternal.delegate = self;
        [_zxingInternal start];
        
        if (self.scanRect) {
            _zxingInternal.scanRect = self.scanRect.CGRectValue;
        } else {
            _zxingInternal.scanRect = _previewView.bounds;
        }
    }
}

- (void)stopScanning
{
    if (_BS_iOS7) {
        [_avfInternal stopScanning];
    } else {
        [_zxingInternal.layer removeFromSuperlayer];
        _zxingInternal.delegate = nil;
        [_zxingInternal stop];
    }
}

+ (void)scanFromImage:(CGImageRef)image resultBlock:(BSScanResultBlock)resultBlock
{
    CGImageRetain(image); // 1
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        ZXCGImageLuminanceSource *source = [[ZXCGImageLuminanceSource alloc] initWithCGImage:image];
        
        CGImageRelease(image); // 2
        
        BOOL invert = NO;
        ZXHybridBinarizer *binarizer = [[ZXHybridBinarizer alloc] initWithSource:invert ? [source invert] : source];
        
        ZXBinaryBitmap *bitmap = [[ZXBinaryBitmap alloc] initWithBinarizer:binarizer];
        
        NSError *error;
        ZXMultiFormatReader* reader = [ZXMultiFormatReader reader];
        ZXDecodeHints* hints = [ZXDecodeHints hints];
        [hints addPossibleFormat:kBarcodeFormatQRCode];
        
        ZXResult *result = [reader decode:bitmap hints:hints error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (resultBlock) {
                resultBlock(result.text);
            }
        });
    });
}

- (BOOL)isScanning
{
    if (_BS_iOS7) {
        return [_avfInternal isScanning];
    } else {
        return _zxingInternal.running;
    }
}

- (void)flipCamera
{
    if (_BS_iOS7) {
        [_avfInternal flipCamera];
    } else {
        if (_zxingInternal.camera == _zxingInternal.back) {
            if ([_zxingInternal hasFront]) {
                _zxingInternal.camera = _zxingInternal.front;
            }
        } else {
            if ([_zxingInternal hasBack]) {
                _zxingInternal.camera = _zxingInternal.back;
            }
        }
    }
}

#pragma mark - ZXCaptureDelegate
- (void)captureResult:(ZXCapture *)capture result:(ZXResult *)result
{
    if (!result) return;

    if (self.zxingBlockCopy) {
        self.zxingBlockCopy(result.text);
    }
}

@end
