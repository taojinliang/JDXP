//
//  UIImageAdditions.h
//  LIGHTinvesting
//
//  Created by MacBookPro on 15/9/24.
//  Copyright © 2015年 Hundsun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImage (method)
// 图片旋转
+ (UIImage *)rotateImage:(UIImageOrientation )orient oldImage:(UIImage *)image;
// 图片尺寸转换
+ (UIImage *)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;
// 处理图片适合上传
+ (UIImage *)handlePictureForUpload:(UIImage *)oldImage;
// 图片文件保存
+ (NSString *)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName;
//获取图片主色调
+(UIColor*)mostColor:(UIImage *)image;
//img本地文件读取函数
+ (UIImage *)getImgFile:(NSString *)fileName;
//画虚线
+ (UIImage *)DrawDottedLine:(CGSize)size;
@end