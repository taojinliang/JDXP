//
//  BarcodeScanView.h
//  HSBarcodeScanner
//
//  Created by LingBinXing on 15/5/22.
//  Copyright (c) 2015年 hundsun. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kBarcodeScanner_bundle   @"BarcodeScanner.bundle"

@class HSBarcodeScanView;

@protocol HSBarcodeScanViewDelegate <NSObject>

- (void)barcodeScanView:(HSBarcodeScanView *)barcodeScanView didScanWithResult:(NSString *)result;
- (void)barcodeScanView:(HSBarcodeScanView *)barcodeScanView didPressCancelButton:(UIButton *)cancelButton;
- (UIViewController *)targetViewControllerForImagePickerInBarcodeScanView:(HSBarcodeScanView *)barcodeScanView;

@end

@interface HSBarcodeScanView : UIView
@property (nonatomic, weak) id <HSBarcodeScanViewDelegate> delegate;
/**
 *  @brief  自动扫描: 将要显示View的时候，自动开启扫描
 *  @note   默认YES
 */
@property (nonatomic, assign) BOOL autoScan;

- (void)startScan;
- (void)stopScan;

@end
