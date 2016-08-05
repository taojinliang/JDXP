//
//  LIAttributeConfig.h
//  LIGHTinvesting
//
//  Created by Deng on 15/6/30.
//  Copyright (c) 2015年 Hundsun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>





@interface LIAttributeConfig : NSObject

// 默认头像图片
+ (UIImage *)defaultAvaters;
// 默认银行
+ (UIImage *)defaultBackImage;
// 图片拼接处理
+ (NSURL *)imagePath:(NSString *)path;

// 获取设备和系统信息
+ (NSString *)deviceName;
+ (NSString *)machineName;
+ (NSString *)iosVersion;
+ (NSString *)appVersion;
+ (NSString *)appBuild;

// 获取设备的高度
+ (NSInteger)deviceSizeHeight;
// 获取设备的宽度
+ (NSInteger)deviceSizeWidth;
// 设备自适应尺寸
+(CGSize)deviceAutoSize;

/**
 *  获取启动图片
 */
+(UIImage *)launchImage;
@end
