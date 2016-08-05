//
//  NSStringAdditions.h
//  LIGHTinvesting
//
//  Created by MacBookPro on 15/8/24.
//  Copyright © 2015年 Hundsun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (MD5)
- (NSString *) md5_16;
- (NSString *) md5_32;
- (NSString *) stringByPaddingTheLeftToLength:(NSUInteger) newLength withString:(NSString *) padString startingAtIndex:(NSUInteger) padIndex;
@end

@interface NSData (MD5)
- (NSString *) md5_16;
- (NSString *) md5_32;
@end

@interface NSString (Convert)
- (int)convert2UINT;

@end

@interface NSString (PhoneNumber)
- (NSString *)phoneNumber;
//格式化手机号，135****7890
+(NSString *)formatMobileTel:(NSString*)mobileTel;
@end

@interface NSString (Trim)
- (NSString *)stringByTrimHeadSpace;
- (NSString *)stringByTrimTailSpace;
- (NSString *)stringByTrimHeadAndTailSpace;
@end

@interface NSString (Regex)
- (BOOL)matchRegularExpression:(NSString *)exp;
@end

/**
 * 系统文档目录
 */
@interface NSString (Path)
+ (NSString *)homeDirectory;
+ (NSString *)bundleDirectory;
+ (NSString *)documentDirectory;
+ (NSString *)libraryDirectory;
+(NSString *)imageFocusName:(NSString*)imageName;
+ (NSString *)documentsDirectory;
//根据传入文件名，返回关键目录根目录加上文件的绝对路径
+ (NSString *)dataFilePathWithFileName:(NSString *)fileName WithDirType:(NSSearchPathDirectory)dirType;
//根据传入的相对路径，返回基于全局的关键目录的绝对路径
+ (NSString *)dataFilePathWithFilePath:(NSString *)fileName WithDirType:(NSSearchPathDirectory)dirType;
//根据传入文件名，返回安装目录加上文件名的绝对路径
+ (NSString *)appPathWithFileName:(NSString *)fileName;
//根据传入的相对路径，返回基于安装目录的绝对路径
+ (NSString *)appPathWithFilePath:(NSString *)filePath;
@end

@interface NSString (URL)
+ (NSString *)URLEncode:(NSString *)unencodedURL;
+ (NSString *)URLDecode:(NSString *)undecodedURL;
- (NSString *)stringByURLEncode;
- (NSString *)stringByURLDecode;
// 中文URL编码
+ (NSString *)encodeAsURLComponent:(NSString *)str;
// 中文URL解码
+ (NSString *)decodeFromURLComponent:(NSString *)str;
@end

@interface NSString (Amount)
- (NSString *)amountChange:(NSString *)input;
//求小数点后面的有效位数，去除多余的0，根据现价去处理，可能会存在现价刚好为整数，1位，2位有效小数的情况（目前只能这么处理）
+(NSInteger)stringDecimalDigitals:(NSString *)string;
//判断充值金额是否符合要求，只能是整数，或者两位小数
+(BOOL)isNeedOfRecharge:(NSString *)recharge;
@end

@interface NSString (ServiceConvert)
- (NSDictionary *)convertToDict;
@end

@interface NSString (Reversed)
+ (NSString *)reversedStringFromString:(NSString *)string;
@end

@interface NSString (Date)
+ (NSString *)currentWeek;
+ (NSString *)currentDay;
//日期 10位格式化  2015-07-30 -> 20150730
+(NSString *)setFormatter:(NSDate *)date;
//日期 10位格式化  2015-07-30 -> 20150730 ->1507
+(NSString *)set4Formatter:(NSDate *)date;
//日期 8位格式化  20150730 -> 15-07-30
+(NSString *)set8Formatter:(NSString *)date;
//传入一个日期，计算距离当前日期的天数
+(NSString *)dateToCurrentDate:(NSString *)date;
//求距离当前日期一个月的日期
+(NSString *)dateToComponentsMonth;
//求距离当前日期一周的日期
+(NSDate *)dateToComponentsWeek;
+ (NSString *)handleDateStr:(NSString *)date;
/*!
 *  @brief  格式化int格式的时间为hh:mm:ss格式的时间字符串
 *
 *  @param time 需要格式化的时间
 *
 *  @return hh:mm:ss格式的时间字符串
 */
+(NSString*)formatTime:(int)time;

/*!
 * 取当前系统时间，判断是否属于交易段时间，
 * 个股默认为9：30-11：30  13：00-15：00
 * 指数默认为9：15-11：30  13：00-15：15
 * 统一处理 9:15-11:30 13:00-15:15
 * @return 返回 是 or 否
 */
+(BOOL)isTradingTime;
@end

@interface NSString (RealTimeParse)

/**
 *  @brief  从"%"结尾的字符串中，解析整数、小数部分
 *  @param OUTIntPart              整数部分
 *  @param OUTFactorPart           小数部分
 *  @return 原始字符串是否是浮点数
 */
- (BOOL)parsePercentTerminatedStringToIntPart:(int *)OUTIntPart andFactorPart:(int *)OUTFactorPart;

/**
 *  @brief  尝试解析浮点数
 *  @param OUTFloat     输出的浮点数
 *  @param string       输入的字符串
 *  @param maxPrecision 最大精度，指小数点之后的位数
 *  @return YES: 解析通过
 */
+ (BOOL)tryParseToFloatNumber:(float *)OUTFloat fromString:(NSString*)string maxPrecision:(NSUInteger)maxPrecision;
+ (BOOL)checkStringInTextField:(UITextField *)textField;

@end

@interface NSString (FormatTo)
/*!
 * 将小数格式化成百分比(统一保留两位小数)，即将0.21733格式化成21.73%
 * @param value 要格式化的小数
 * @return 返回格式化以后的百分比
 */
+(NSString*)formatPercent:(double)value;

/*!
 * 将量转化为带单位（万、亿）的字符串，大于十万的数值将会转化成单位为万的字符串，大于一亿的数值将会转化成单位为亿的字符串
 * @param bs 放大（缩小）倍数
 * @param amount 需要格式化的数值
 * @return 返回格式化以后的字符串，amount为0则返回"--"
 */
+(NSString*)amountToString:(int64_t)amount withMutiple:(int64_t)bs;
+(NSString*)amountToString:(int64_t)amount;
/*!
 * 股数转化为手数，默认100股为1手，十万以上带有单位万，一亿以上带有单位亿
 * @param amount 需要格式化的股数
 * @return 返回转化为手后的带有单位（万，亿）的字符串，amount为0则返回"--"
 */
+(NSString*)amountToHand:(int64_t)amount;
@end