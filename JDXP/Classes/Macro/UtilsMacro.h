//
//  UtilsMacro.h
//  LIGHTinvesting
//
//  Created by MacBookPro on 15/11/20.
//  Copyright © 2015年 Hundsun. All rights reserved.
//
//UtilsMacro.h 里放的是一些方便使用的宏定义

#ifndef UtilsMacro_h
#define UtilsMacro_h


//******************************************************************************//
//******************************MD5 长度相关**************************************//
#define MD5_LENGTH_16    16
#define MD5_LENGTH_32    32

//******************************************************************************//
//******************************数据存储相关**************************************//
// 缓存表
static NSString *const LI_CACHE_TABLE = @"li_cache_table";
// 获取用户信息
static NSString *const LI_USER_INFO = @"LI_USER_INFO";


//******************************************************************************//
//******************************block相关**************************************//
/**
 *  声明block内部循环引用，弱引用对象
 */
#define WeakObj(obj) autoreleasepool{} __weak typeof(obj) obj##Weak = obj;
/**
 *  声明block内部循环引用，强引用对象
 */
#define StrongObj(obj) autoreleasepool{} __strong typeof(obj) obj = obj##Weak;


//******************************************************************************//
//******************************DEBUG相关**************************************//

/*
 #ifdef DEBUG
 #define LINSLog(...) NSLog(__VA_ARGS__)
 #else
 #define LINSLog(...)
 #endif
 */


#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif

#if (!defined(DEBUG) && !defined (SD_VERBOSE)) || defined(SD_LOG_NONE)
#define NSLog(...)
#endif

/**
 *  屏蔽警告
 */
#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
    _Pragma("clang diagnostic push") \
    _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
    Stuff; \
    _Pragma("clang diagnostic pop") \
} while (0)

#endif /* UtilsMacro_h */
