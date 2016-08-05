//
//  UIImage+HSBundle.m
//  HSBarcodeScanner
//
//  Created by LingBinXing on 15/5/22.
//  Copyright (c) 2015年 hundsun. All rights reserved.
//

#import "UIImage+HSBundle.h"

@implementation UIImage (HSBundle)
+ (UIImage *)imageNamed:(NSString *)imageName inBundleNamed:(NSString *)bundleName
{
    NSString* imagePath = [bundleName stringByAppendingPathComponent:imageName];
    UIImage* img = [UIImage imageNamed:imagePath];
    return img;
}
@end
