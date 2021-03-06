//
//  LIAppMacro.h
//  LIGHTinvesting
//
//  Created by MacBookPro on 15/11/20.
//  Copyright © 2015年 Hundsun. All rights reserved.
//
//LIAppMacro.h 里放app相关的宏定义

#ifndef LIAppMacro_h
#define LIAppMacro_h


//******************************************************************************//
//******************************网络请求相关**************************************//
#define IsAnalogData 0   // 是否用模拟数据


//******************************************************************************//
//******************************App版本相关**************************************//
#define IOSVersion [UIDevice currentDevice].systemVersion.floatValue
#define IsIOSVersion7 IOSVersion >= 7.0 && IOSVersion < 8.0
#define IsIOSVersion8Earlier IOSVersion < 8.0
#define IsIOSVersion8Later IOSVersion >= 8.0
#define IsIOSVersion8 IOSVersion >= 8.0 && IOSVersion < 9.0
#define IsIOSVersion9 IOSVersion >= 9.0 && IOSVersion < 10.0

#define SDKVersion __IPHONE_OS_VERSION_MAX_ALLOWED
#ifndef __IPHONE_9_0
#   define __IPHONE_9_0     90000
#endif

//******************************************************************************//
//******************************App设备相关**************************************//
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height


#endif /* LIAppMacro_h */
