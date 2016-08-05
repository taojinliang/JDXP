//
//  NSStringAdditions.m
//  LIGHTinvesting
//
//  Created by MacBookPro on 15/8/24.
//  Copyright © 2015年 Hundsun. All rights reserved.
//

#import "NSStringAdditions.h"
#import "LIAttributeConfig.h"
#import <CommonCrypto/CommonDigest.h>
#import "UtilsMacro.h"

@implementation NSString (MD5)

- (NSString *) md5_16 {
    const char *cStr = [self UTF8String];
    unsigned char result[MD5_LENGTH_16];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result ); // This is the md5 call
    
    NSString* ret = @"";
    for (int i = 0; i < MD5_LENGTH_16; i++) {
        ret = [ret stringByAppendingFormat:@"%02x", result[i]];
    }
    
    return ret;
}

- (NSString *) md5_32 {
    const char *cStr = [self UTF8String];
    unsigned char result[MD5_LENGTH_32];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result ); // This is the md5 call
    
    NSString* ret = @"";
    for (int i = 0; i < MD5_LENGTH_32; i++) {
        ret = [ret stringByAppendingFormat:@"%02x", result[i]];
    }
    
    return ret;
}

- (NSString *) stringByPaddingTheLeftToLength:(NSUInteger) newLength withString:(NSString *) padString startingAtIndex:(NSUInteger) padIndex {
    if ([self length] <= newLength)
        return [[@"" stringByPaddingToLength:newLength - [self length] withString:padString startingAtIndex:padIndex] stringByAppendingString:self];
    else
        return [self copy];
}

@end

@implementation NSData (MD5)

- (NSString*)md5_16 {
    unsigned char result[MD5_LENGTH_16];
    CC_MD5( self.bytes, (CC_LONG)self.length, result ); // This is the md5 call
    
    NSString* ret = @"";
    for (int i = 0; i < MD5_LENGTH_16; i++) {
        ret = [ret stringByAppendingFormat:@"%02x", result[i]];
    }
    
    return ret;
}

- (NSString*)md5_32 {
    unsigned char result[MD5_LENGTH_32];
    CC_MD5( self.bytes, (CC_LONG)self.length, result ); // This is the md5 call
    
    NSString* ret = @"";
    for (int i = 0; i < MD5_LENGTH_32; i++) {
        ret = [ret stringByAppendingFormat:@"%02x", result[i]];
    }
    
    return ret;
}
@end

@implementation NSString (Convert)

-(int)convert2UINT
{
    NSString *regex = @"^[0-9]*[1-9][0-9]*$";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![test evaluateWithObject:self]) {
        return 0;
    }
    return self.intValue;
}

@end


@implementation NSString (PhoneNumber)

- (NSString *)phoneNumber
{
    NSScanner *scanner = [NSScanner scannerWithString:self];
    NSMutableString* result = [NSMutableString stringWithCapacity:11];
    NSString* temp = @"";
    NSString* str = @"";
    while (![scanner isAtEnd]) {
        [scanner scanUpToString:@"-" intoString:&temp];
        [scanner scanString:@"-" intoString:nil];
        [result appendString:temp];
    }
    
    if ([[result substringToIndex:3] isEqualToString:@"+86"]) {
        str = [result substringFromIndex:3];
    }
    else {
        str = (NSString *)result;
    }
    
    return [str stringByTrimHeadSpace];
}

+(NSString *)formatMobileTel:(NSString*)mobileTel{
    return [mobileTel stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
}
@end

@implementation NSString (Trim)
- (NSString*)stringByTrimHeadSpace
{
    NSScanner* scanner = [NSScanner scannerWithString:self];
    [scanner setCharactersToBeSkipped:nil];
    [scanner scanCharactersFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet] intoString:nil];
    //delete space at head
    return [self substringWithRange:NSMakeRange([scanner scanLocation], [self length] - [scanner scanLocation])];
}

- (NSString*)stringByTrimTailSpace
{
    NSMutableString* result = [NSMutableString stringWithCapacity:30];
    NSScanner* scanner = [NSScanner scannerWithString:self];
    [scanner setCharactersToBeSkipped:nil];
    
    NSString* temp = @"";
    //copy space at head
    [scanner scanCharactersFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet] intoString:&temp];
    [result appendString:temp];
    
    //delete space at tail & copy content
    while (![scanner isAtEnd]) {
        [scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet] intoString:&temp];
        [result appendString:temp];
        
        if (![scanner isAtEnd]) {//we should copy space in content
            [scanner scanCharactersFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet] intoString:&temp];
            if (![scanner isAtEnd]) {//space in content
                [result appendString:temp];
            }
            else {//space at tail
                break;
            }
        }
        else {//reach the end
            break;
        }
    }
    return result;
}

- (NSString*)stringByTrimHeadAndTailSpace
{
    NSMutableString* result = [NSMutableString stringWithCapacity:30];
    NSScanner* scanner = [NSScanner scannerWithString:self];
    [scanner setCharactersToBeSkipped:nil];
    
    //delete space at head
    [scanner scanCharactersFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet] intoString:nil];
    
    //delete space at tail & copy content
    NSString* temp = @"";
    while (![scanner isAtEnd]) {
        [scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet] intoString:&temp];
        [result appendString:temp];
        
        if (![scanner isAtEnd]) {//we should copy space in content
            [scanner scanCharactersFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet] intoString:&temp];
            if (![scanner isAtEnd]) {//space in content
                [result appendString:temp];
            }
            else {//space at tail
                break;
            }
        }
        else {//reach the end
            break;
        }
    }
    return result;
}
@end

#pragma mark -
#import "regex.h"
@implementation NSString (Regex)
- (BOOL)matchRegularExpression:(NSString*)exp
{
    
    OSErr error = noErr;
    //	char errBuf[256];
    regex_t regex;
    
    //create regex
    error = regcomp(&regex, [exp cStringUsingEncoding:NSASCIIStringEncoding], REG_EXTENDED);
    if (error == noErr) { //create success
        //regex match
        regmatch_t regmatch[256];
        error = regexec(&regex, [self cStringUsingEncoding:NSASCIIStringEncoding],
                        sizeof(regmatch_t), regmatch, REG_TRACE);
        //		if (error != noErr) { //match failed
        //			regerror(error, &regex, errBuf, 256);
        //			DLog(@"self match regex expression %@ failed .", self, exp);
        //			printf("%s",errBuf);
        //		}
    }
    //	else { //create failed
    //		regerror(error, &regex, errBuf, 256);
    //		DLog(@"self create regex expression %@ failed . ", self, exp);
    //		printf("%s",errBuf);
    //	}
    
    //clear up
    regfree(&regex);
    return error == noErr;
}
@end

#pragma mark -
@implementation NSString (Path)
+ (NSString*)homeDirectory
{
    return NSHomeDirectory();
}

+ (NSString*)bundleDirectory
{
    return [[NSBundle mainBundle] bundlePath];
}

+ (NSString*)documentDirectory
{
    NSArray* array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [array lastObject];
}

+ (NSString*)libraryDirectory
{
    NSArray* array = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return [array lastObject];
}

+(NSString *)imageFocusName:(NSString*)imageName
{
    NSRange range = [imageName rangeOfString:@".png"];
    if(range.location != NSNotFound) {
        NSString * name = [imageName substringToIndex:range.location];
        return [NSString stringWithFormat:@"%@_F.png", name];
    }
    return imageName;
}

/**
 * 系统文档目录
 */
+ (NSMutableDictionary*)escapeDictionary
{
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:@"<",@"&lt;",
            @">",@"&gt;",
            @"&",@"&amp;",
            @"\'",@"&apos;",
            @"\"",@"&quot;",
            @" ",@"&nbsp;",nil];
}

+ (NSString *)documentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if ([paths count] == 0) {
        DLog(@"Error: document dir access error!");
        return @"";
    }
    return [paths objectAtIndex:0];
}


//根据目录类型找全局的文件
+ (NSString *)dataFilePathWithFileName:(NSString *)fileName WithDirType:(NSSearchPathDirectory)dirType
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(dirType, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *absolutefileName = [fileName lastPathComponent];
    return [documentsDirectory stringByAppendingPathComponent:absolutefileName];
}

//根据目录类型找全局的目录
+ (NSString *)dataFilePathWithFilePath:(NSString *)fileName WithDirType:(NSSearchPathDirectory)dirType;
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(dirType, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:fileName];
}

//根据Info.plist文件找到.app目录
+ (NSString *)appPathWithFileName:(NSString *)fileName
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
    filePath = [filePath stringByDeletingLastPathComponent];
    NSString *absolutefileName = [fileName lastPathComponent];
    //	TRACELOG([filePath stringByAppendingPathComponent:absolutefileName]);
    return [filePath stringByAppendingPathComponent:absolutefileName];
}

+ (NSString *)appPathWithFilePath:(NSString *)filePath
{
    if ([filePath hasPrefix:@"/"]) {//以/开头说明是绝对路径
        return filePath;
    }
    NSString *appPath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
    appPath = [appPath stringByDeletingLastPathComponent];
    //NSString *absolutefileName = [fileName lastPathComponent];
    //	TRACELOG([filePath stringByAppendingPathComponent:absolutefileName]);
    return [appPath stringByAppendingPathComponent:filePath];
}
@end

#pragma mark -
@implementation NSString (URL)


+ (NSString *)URLEncode:(NSString *)unencodedURL
{
    return [unencodedURL stringByURLEncode];
}

+ (NSString *)URLDecode:(NSString *)undecodedURL
{
    return [undecodedURL stringByURLDecode];
}

- (NSString*)stringByURLEncode
{
    NSMutableString *result = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[self UTF8String];
    NSInteger sourceLen = strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        //        if (thisChar == ' '){
        //            [result appendString:@"+"];
        //        } else
        if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
            (thisChar >= 'a' && thisChar <= 'z') ||
            (thisChar >= 'A' && thisChar <= 'Z') ||
            (thisChar >= '0' && thisChar <= '9')) {
            [result appendFormat:@"%c", thisChar];
        } else {
            [result appendFormat:@"%%%02X", thisChar];
        }
    }
    return result;
}

- (NSString*)stringByURLDecode
{
    NSString* result = [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSParameterAssert(result);
    return result;
}

// 中文URL编码
+ (NSString*)encodeAsURLComponent:(NSString *)str {
    return [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

// 中文URL解码
+ (NSString *)decodeFromURLComponent:(NSString *)str {
    return [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
@end


#pragma mark -
@implementation NSString (Amount)
- (NSString*)amountChange:(NSString*)input
{
    NSArray *_numArray = [NSArray arrayWithObjects:@"零",@"壹",@"贰",@"叁",@"肆",@"伍",@"陆",@"柒",@"捌",@"玖",nil];
    NSArray *_unitArray = [NSArray arrayWithObjects:@"拾",@"佰",@"仟",@"万",nil];
    NSMutableString *output = [[NSMutableString alloc] initWithCapacity:8];//输出
    NSInteger lenbp = 0;//小数点前的长度
    NSInteger lenap = 0;//小数点后的长度
    
    //没有小写大写也要一并清空
    if (input.length == 0) {
        [output appendString: @"零圆整"];
        return (NSString*)output;
    }
    
    NSRange range = [input rangeOfString:@"."];//找小数点
    if (range.location != NSNotFound)//有小数点
    {
        //根据小数点的位置取得小数点后的长度，最大为2，超过截取
        lenap = input.length - NSMaxRange(range) < 2 ? input.length - NSMaxRange(range) : 2;
        if ([input substringFromIndex:NSMaxRange(range)].length > 2) {
            //小数点后长度超过两位要截断，最多只能有2位，截断后同样需要返回，理由同上
            input = [input substringToIndex:NSMaxRange(range)+2];
        }
        //小数点前的长度
        if (range.location == 0) {
            lenbp = 1;
        }
        else {
            lenbp = range.location;
        }
    }
    else {//没有小数点
        lenbp = input.length;
        lenap = 0;
    }
    
    
    
    //处理整数部分
    NSInteger i,lastn = -1;//lastn是上次读取的数字，用于去除多余的0
    for (i = lenbp; i > 0; i--)//从后往前一个一个字符读取
    {
        int n = [[input substringWithRange:NSMakeRange(i-1, 1)] intValue];//每次读一个
        if (n == 0&& n == lastn) {
            if ((lenbp-i) % 4 != 0) {
                lastn = n;
                continue;
            }
        }
        if ((lenbp - i > 0)) {
            if ((lenbp - i) % 8 == 0) {
                if ([@"万" isEqualToString:[output substringToIndex:1]]) {
                    [output deleteCharactersInRange:NSMakeRange(0, 1)];
                }
                [output insertString:@"亿" atIndex:0];
            }
            else {
                if ((n != 0) || (lenbp - i) % 4 == 0) {
                    [output insertString:[_unitArray objectAtIndex:(lenbp-i-1)%[_unitArray count]] atIndex:0];
                }
            }
        }
        if (n != 0) {
            [output insertString:[_numArray objectAtIndex:n] atIndex:0];
        }
        else if ((lenbp - i) % 4 != 0) {
            [output insertString:[_numArray objectAtIndex:n] atIndex:0];
        }
        if (n == 0 && lenbp == 1) {
            [output insertString:[_numArray objectAtIndex:n] atIndex:0];
        }
        lastn=n;
    }
    [output appendString:@"圆"];
    
    int m, n;
    switch (lenap) {
        case 0:
            [output appendString:@"整"];
            break;
        case 1:
            n = [[input substringWithRange:NSMakeRange(NSMaxRange(range), 1)] intValue];
            if (n != 0) {
                [output appendString:[_numArray objectAtIndex:n]];
                [output appendString:@"角整"];
            }
            else {
                [output appendString:@"整"];
            }
            break;
        case 2:
            m = [[input substringWithRange:NSMakeRange(NSMaxRange(range), 1)] intValue];
            n = [[input substringWithRange:NSMakeRange(NSMaxRange(range)+1, 1)] intValue];
            if (m != 0 && n != 0) {
                [output appendString:[_numArray objectAtIndex:m]];
                [output appendString:@"角"];
                [output appendString:[_numArray objectAtIndex:n]];
                [output appendString:@"分"];
            }
            else if (m != 0 && n == 0) {
                [output appendString:[_numArray objectAtIndex:m]];
                [output appendString:@"角整"];
            }
            else if (m == 0 && n != 0) {
                [output appendString:[_numArray objectAtIndex:m]];
                [output appendString:[_numArray objectAtIndex:n]];
                [output appendString:@"分"];
            }
            else if(m == 0 && n == 0) {
                [output appendString:@"整"];
            }
            break;
        default:
            break;
    }
    
    return (NSString*)output;
}


//求小数点后面的有效位数，去除多余的0，根据现价去处理，可能会存在现价刚好为整数，1位，2位有效小数的情况（目前只能这么处理）
+(NSInteger)stringDecimalDigitals:(NSString *)string{
    NSInteger length = [string length];
    NSInteger i;
    for (i = 0; i < length; i++) {
        if ([string characterAtIndex:(length - 1 - i)] != '0') {
            break;
        }
    }
    NSString *detalString = @"";
    if ([string characterAtIndex:(length - i - 1)] == '.') {
        detalString =  [string substringToIndex:(length - i - 1)] ;
    }else{
        detalString = [string substringToIndex:(length - i)];
    }
    
    NSInteger location = 0;
    if ([detalString hasSuffix:@"."]) {
        location = [detalString rangeOfString:@"."].location+1;
    }
    
    if ([detalString length] - location >= 3) {
        return 3;//有效位数大于等于3位时，取3位
    }
    return [detalString length] - location;
}
//判断充值金额是否符合要求，只能是整数或者两位小数，不能有多个小数点，空白，整数首位不能为0的，小数点前面只有一个0，
+(BOOL)isNeedOfRecharge:(NSString *)recharge{
    NSInteger count = 0;
    for (int i = 0; i < recharge.length; i++) {
        char point = [recharge characterAtIndex:i];
        if (point =='.') {
            count++;
        }else if (point == ' ') {
            return NO;
        }
    }
    if (count > 1) {
        return NO;
    }else if ([recharge floatValue] == 0.0){
        return NO;
    }else {
        NSRange range = [recharge rangeOfString:@"."];
        if ([recharge characterAtIndex:0] == 0 ) {
            if (range.location != 1) {
                return NO;
            }
        }
    }
    return YES;
}
@end

@implementation NSString(ServiceConvert)

- (NSDictionary *)convertToDict
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSScanner *scanner = [NSScanner scannerWithString:self];
    while (![scanner isAtEnd]) {
        NSString *param = nil;
        [scanner scanCharactersFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet] intoString:nil];
        [scanner scanUpToString:@"&" intoString:&param];
        [scanner scanString:@"&" intoString:nil];
        NSScanner *s = [NSScanner scannerWithString:param];
        while (![s isAtEnd]) {
            NSString *key = nil;
            NSString *value = nil;
            [s scanCharactersFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet] intoString:nil];
            [s scanUpToString:@"=" intoString:&key];
            [s scanString:@"=" intoString:nil];
            [s scanUpToCharactersFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet] intoString:&value];
            [s scanCharactersFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet] intoString:nil];
            
            [dict setObject:value forKey:key];
        }
    }
    return dict;
}

@end

@implementation NSString (Reversed)

+ (NSString *)reversedStringFromString:(NSString *)string
{
    NSUInteger count = [string length];
    
    if (count <= 1) { // Base Case
        return string;
    } else {
        NSString *lastLetter = [string substringWithRange:NSMakeRange(count - 1, 1)];
        NSString *butLastLetter = [string substringToIndex:count - 1];
        return [lastLetter stringByAppendingString:[self reversedStringFromString:butLastLetter]];
    }
}
@end


@implementation NSString (Date)
+ (NSString *)currentWeek
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unitFlags = NSCalendarUnitYear |
    NSCalendarUnitMonth |
    NSCalendarUnitDay |
    NSCalendarUnitWeekday |
    NSCalendarUnitHour |
    NSCalendarUnitMinute |
    NSCalendarUnitSecond;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:[NSDate date]];
    switch (comps.weekday) {
        case 1:
            return @"周日";
            break;
        case 2:
            return @"周一";
            break;
        case 3:
            return @"周二";
            break;
        case 4:
            return @"周三";
            break;
        case 5:
            return @"周四";
            break;
        case 6:
            return @"周五";
            break;
        case 7:
            return @"周六";
            break;
        default:
            break;
    }
    return @"";
}

+ (NSString *)currentDay
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unitFlags = NSCalendarUnitYear |
    NSCalendarUnitMonth |
    NSCalendarUnitDay |
    NSCalendarUnitWeekday |
    NSCalendarUnitHour |
    NSCalendarUnitMinute |
    NSCalendarUnitSecond;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:[NSDate date]];
    NSInteger day = comps.day;
    if(day < 10) {
        return [NSString stringWithFormat:@"0%ld", (long)day];
    } else {
        return [NSString stringWithFormat:@"%ld", (long)day];
    }
}

//日期 8位格式化
+(NSString *)setFormatter:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];// 初始化一个 NSDateFormatter
    [dateFormatter setDateFormat:@"yyyyMMdd"]; // 设置日期格式
    NSString *dateString = [dateFormatter stringFromDate:date];// 将datePicker的值转化为上面指定的日期格式
    return dateString;
}

+(NSString *)set4Formatter:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];// 初始化一个 NSDateFormatter
    [dateFormatter setDateFormat:@"yyyyMMdd"]; // 设置日期格式
    NSString *dateString = [dateFormatter stringFromDate:date];// 将datePicker的值转化为上面指定的日期格式
    dateString = [dateString substringWithRange:NSMakeRange(2, 4)];
    return dateString;
}
//日期 8位格式化  20150730 -> 15-07-30
+(NSString *)set8Formatter:(NSString *)date{
    NSInteger length = [date length];
    if (length == 8) {
        date = [date substringFromIndex:2];
        
        NSString *dateString= @"";
        for (NSInteger i = 0; i < [date length]; i++) {
            NSRange range;
            range.length = 1;
            range.location = i;
            if (i != 0 && i%2 == 0) {
                dateString = [NSString stringWithFormat:@"%@%@",dateString,@"-"];
            }
            dateString = [NSString stringWithFormat:@"%@%@",dateString,[date substringWithRange:range]];
            
        }
        return dateString;
    }else{
        return @"";
    }
    
}

//传入一个日期，计算距离当前日期的天数
+(NSString *)dateToCurrentDate:(NSString *)date{
    NSDateFormatter* dformate = [[NSDateFormatter alloc] init];
    [dformate setDateFormat:@"yyyyMMdd"];
    NSDate* Date1 = [dformate dateFromString:date];
    
    NSDate *Date2 = [NSDate date];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    unsigned int unitFlags = NSCalendarUnitDay;//年、月、日、时、分、秒、周等等都可以
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:Date1 toDate:Date2 options:0];
    NSInteger day = [comps day];//时间差
    return [NSString stringWithFormat:@"%ld",(long)day];
}

+(NSString *)dateToComponentsMonth{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[[NSDate alloc] init]];
    [components setMonth:([components month] - 1)];
    NSDate *lastMonth = [cal dateFromComponents:components];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];// 初始化一个 NSDateFormatter
    [dateFormatter setDateFormat:@"yyyyMMdd"]; // 设置日期格式
    NSString *dateString = [dateFormatter stringFromDate:lastMonth];// 将datePicker的值转化为上面指定的日期格式
    return dateString;
}

+(NSDate *)dateToComponentsWeek{
    NSTimeInterval secondsPerDay = 6 * 24 * 60 * 60;
    NSDate *lastWeek = [[NSDate alloc] initWithTimeIntervalSinceNow:-secondsPerDay];
    return lastWeek;
}

+ (NSString *)handleDateStr:(NSString *)date {
    NSString *temp = @"--";
    
    if (date.length == 8) {
        NSString *year = [date substringWithRange:NSMakeRange(0, 4)];
        NSString *month = [date substringWithRange:NSMakeRange(year.length, 2)];
        NSString *day = [date substringWithRange:NSMakeRange(year.length + month.length, 2)];
        
        temp = [NSString stringWithFormat:@"%@-%@-%@", year, month, day];
    }
    
    return temp;
}

+(NSString*)formatTime:(int)time
{
    int hh = time / 10000;
    int mm = (time % 10000) / 100;
    int ss = (time % 10000) % 100;
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hh,mm,ss];
}

+(BOOL)isTradingTime{
    NSDate * currentdate = [NSDate date];
    
    NSDateFormatter* dformate = [[NSDateFormatter alloc] init];
    [dformate setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //包括空格
    NSString *currentDateString = [[dformate stringFromDate:currentdate] substringToIndex:11];
    
    NSString *openTime1 = [currentDateString stringByAppendingString:@"09:15:00"];
    NSString *closeTime1 = [currentDateString stringByAppendingString:@"11:30:00"];
    NSString *openTime2 = [currentDateString stringByAppendingString:@"13:00:00"];
    NSString *closeTime2 = [currentDateString stringByAppendingString:@"15:15:00"];
    
    NSDate* opendate1 = [dformate dateFromString:openTime1];
    NSDate* closedate1 = [dformate dateFromString:closeTime1];
    NSDate* opendate2 = [dformate dateFromString:openTime2];
    NSDate* closedate2 = [dformate dateFromString:closeTime2];
    
    NSComparisonResult compare1 = [opendate1 compare:currentdate];
    NSComparisonResult compare2 = [currentdate compare:closedate1];
    NSComparisonResult compare3 = [opendate2 compare:currentdate];
    NSComparisonResult compare4 = [currentdate compare:closedate2];
    if ( ((compare1 == NSOrderedAscending || compare1 == NSOrderedSame) && (compare2 == NSOrderedAscending || compare2 == NSOrderedSame)) ||
        ((compare3 == NSOrderedAscending || compare3 == NSOrderedSame) && (compare4 == NSOrderedAscending || compare4 == NSOrderedSame))){
        return YES;
    }else{
        return NO;
    }
}
@end

@implementation NSString (RealTimeParse)

- (BOOL)parsePercentTerminatedStringToIntPart:(int *)OUTIntPart andFactorPart:(int *)OUTFactorPart
{
    BOOL isGood = NO;
    
    static NSString* const kPercentSign = @"%";
    NSString* percentTerminatedString = self;
    
    if ([percentTerminatedString hasSuffix:kPercentSign]) {
        percentTerminatedString = [percentTerminatedString substringToIndex:percentTerminatedString.length - kPercentSign.length];
    }
    
    int intPart = 0;
    int factorPart = 0;
    {
        NSScanner* scanner = [[NSScanner alloc] initWithString:percentTerminatedString];
        NSString* intPartString = nil;
        NSString* factorPartString = nil;
        
        static NSString* const kDotSign = @".";
        isGood = [scanner scanUpToString:kDotSign intoString:&intPartString];
        
        if (isGood) {
            [scanner scanString:kDotSign intoString:nil];
            factorPartString = [[scanner string] substringFromIndex:[scanner scanLocation]];
            intPart = [intPartString intValue];
            factorPart = [factorPartString intValue];
        } else {
            intPart = [percentTerminatedString intValue];
            factorPart = 0;
        }
    }
    
    if (OUTIntPart) {
        *OUTIntPart = intPart;
    }
    
    if (OUTFactorPart) {
        *OUTFactorPart = factorPart;
    }
    
    return isGood;
}

/**
 *  @brief  尝试解析浮点数
 *  @param OUTFloat     输出的浮点数
 *  @param string       输入的字符串
 *  @param maxPrecision 最大精度，指小数点之后的位数
 *  @return YES: 解析通过
 */
+ (BOOL)tryParseToFloatNumber:(float *)OUTFloat fromString:(NSString*)string maxPrecision:(NSUInteger)maxPrecision
{
    if (OUTFloat) {
        *OUTFloat = [string floatValue];
    }
    
    CFStringInlineBuffer buffer;
    CFStringInitInlineBuffer((CFStringRef)string, &buffer, CFRangeMake(0, string.length));
    
    static const UniChar kDotUch = '.';
    
    CFIndex dotCount = 0;
    
    UniChar uchAt0 = CFStringGetCharacterFromInlineBuffer(&buffer, 0);
    
    for (CFIndex i = 0; i < string.length; ++i) {
        UniChar uch = CFStringGetCharacterFromInlineBuffer(&buffer, i);
        if (!isdigit(uch) && !(kDotUch == uch)) {
            return NO;
        }
        if (uch == kDotUch) {
            dotCount += 1;
            if (dotCount > 1) {
                return NO;
            }
            
            // 如果小数点后的位数 > maxPrecision
            if (string.length - 1 - i > maxPrecision) {
                return NO;
            }
        }
        // 不允许 "000" 这种情况
        if (i != 0 && uchAt0 == '0' && dotCount == 0 && uch == '0') {
            return NO;
        }
    }
    
    return YES;
}

+ (BOOL)checkStringInTextField:(UITextField *)textField
{
    BOOL good = NO;
    float amount = 0;
    BOOL parse = [self tryParseToFloatNumber:&amount fromString:textField.text maxPrecision:2];
    if (parse) {
        if (amount != 0) {
            good = YES;
        }
    }
    
    if (!good) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"输入错误或值不能为空"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
    return good;
}


@end

@implementation NSString (FormatTo)

+(NSString*)formatPercent:(double)value
{
    //百分数默认两位小数
    return [NSString stringWithFormat:@"%.2f%%", value * 100.0f];
}


+(NSString*)amountToString:(int64_t)amount withMutiple:(int64_t)bs
{
    if (bs > 0) {
        amount *= bs;
    }
    if (amount == 0) {
        return @"0";
    }
    NSString *str = nil;
    NSString *str1= @"";
    if (amount < 0) {
        amount = -amount;
        str1 = @"-";
    }
    //亿以上
    if (amount >= 100000000) {
        str = [NSString stringWithFormat:@"%.2lf亿", (double)amount/(double)100000000];
    }
    //十万以上
    else if (amount >= 100000)
    {
        str = [NSString stringWithFormat:@"%.2lf万", (double)amount/(double)10000];
    }
    //十万以下
    else{
        str = [NSString stringWithFormat:@"%lld", amount];
    }
    
    return [NSString stringWithFormat:@"%@%@",str1,str];
}

+(NSString*)amountToString:(int64_t)amount{
    if (amount == 0) {
        return @"0";
    }
    NSString *str = nil;
    NSString *str1= @"";
    if (amount < 0) {
        amount = -amount;
        str1 = @"-";
    }
    //亿以上
    if (amount >= 100000000) {
        str = [NSString stringWithFormat:@"%.2lf亿", (double)amount/(double)100000000];
    }
    //十万以上
    else if (amount >= 100000)
    {
        str = [NSString stringWithFormat:@"%.2lf万", (double)amount/(double)10000];
    }
    //十万以下
    else{
        str = [NSString stringWithFormat:@"%lld.00", amount];
    }
    
    return [NSString stringWithFormat:@"%@%@",str1,str];
}

+(NSString*)amountToHand:(int64_t)amount
{
    NSString *str = [NSString stringWithFormat:@"%lld股",amount];
    return str;
}

@end
