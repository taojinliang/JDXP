//
//  UIImage+HSBundle.h
//  HSBarcodeScanner
//
//  Created by LingBinXing on 15/5/22.
//  Copyright (c) 2015年 hundsun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (HSBundle)
+ (UIImage *)imageNamed:(NSString *)imageName inBundleNamed:(NSString *)bundleName;
@end
