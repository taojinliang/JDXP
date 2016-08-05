//
//  NSBundle+Hundsun.h
//  HSBarcodeScanner
//
//  Created by LingBinXing on 15/5/25.
//  Copyright (c) 2015年 hundsun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSBundle (Hundsun)
/**
 *  @brief  根据bundle名字，创建bundle对象
 *  @param  name bundle名字（有无扩展名都支持，例如: @"x1" / @"x1.bundle"）
 *  @return bundle对象
 *  @note   本函数会缓存bundle对象
 */
+ (instancetype)bundleNamed:(NSString *)name;

/**
 *  @brief  设置全局本地化的语言
 *  @param language 指定的本地化的语言
 */
+ (void)setLanguage:(NSString*)language;

/**
 *  @brief  用户设置的本地化的语言
 *  @return 用户设置的本地化的语言
 */
+ (NSString *)userSetLanguage;
@end

/**
 *  @brief  本地化字符串
 *  @param  key 关键字
 *  @param  bundleName bundle名字（有无扩展名都支持，例如: @"x1" / @"x1.bundle"）
 *  @param  comment 注释
 */
#define HSLocalizedStringInBundle(key, bundleName, comment) \
[[NSBundle bundleNamed:(bundleName)] localizedStringForKey:(key) value:@"" table:nil]
