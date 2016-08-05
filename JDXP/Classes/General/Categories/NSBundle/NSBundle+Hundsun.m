//
//  NSBundle+Hundsun.m
//  HSBarcodeScanner
//
//  Created by LingBinXing on 15/5/25.
//  Copyright (c) 2015年 hundsun. All rights reserved.
//

#import "NSBundle+Hundsun.h"
#import "UtilsMacro.h"
#import <objc/runtime.h>

static void* kBundleKey = &kBundleKey;
static NSString* g_userSetLanguage = nil;


@interface BundleEx : NSBundle
// 由于要动态替换类，所以此类必须保证!没有!任何成员变量，否则可能崩溃
@end

@implementation BundleEx

- (NSString*)localizedStringForKey:(NSString *)key value:(NSString *)value table:(NSString *)tableName
{
    NSBundle* langBundle = objc_getAssociatedObject(self, &kBundleKey);
    // 如果有关联的语言bundle，则用语言bundle，否则直接调用默认的系统实现
    return langBundle ? [langBundle localizedStringForKey:key value:value table:tableName] : [super localizedStringForKey:key value:value table:tableName];
}

@end

@implementation NSBundle (Hundsun)

+ (void)load {
    @autoreleasepool {
        NSString* nativeDevelopmentRegion = [[[NSBundle mainBundle] infoDictionary] objectForKey:(id)kCFBundleDevelopmentRegionKey];
        if (nil == nativeDevelopmentRegion) {
            DLog(@"请在info.plist中设置默认开发语言(Native Development Region)");
            
            // 如果没有指定默认开发语言，则优先使用中文
            NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
            NSArray* languages = [defs objectForKey:@"NSLanguages"];
            NSString* nativeLang = nil;

            static NSString* const kChineseSimplified  = @"zh-Hans";
            static NSString* const kChineseTraditional = @"zh-Hant";
            static NSString* const kEnglish            = @"en";
            
            if ([languages containsObject:kChineseSimplified]) {
                nativeLang = kChineseSimplified;
            } else if ([languages containsObject:kChineseTraditional]) {
                nativeLang = kChineseTraditional;
            } else {
                nativeLang = kEnglish;
            }
            
            [self setLanguage:nativeLang];
        }
    }
}

/*
 example calls:
 [Language setLanguage:@"zh_CN"];
 [Language setLanguage:@"en"];
 [Language setLanguage:nil]; // 还原默认
 */
+ (void)setLanguage:(NSString*)language
{
    g_userSetLanguage = language;

    [self setLanguage:language forBundle:[NSBundle mainBundle]];
    [[self _cachedMap] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([obj isKindOfClass:[NSBundle class]]) {
            [self setLanguage:language forBundle:obj];
        }
    }];
}

+ (void)setLanguage:(NSString*)language forBundle:(NSBundle *)bundle
{
    if (![bundle isKindOfClass:[BundleEx class]]) {
        object_setClass(bundle, [BundleEx class]);
    }
    NSBundle* langBundle = nil;
    if (language) {
        langBundle = [NSBundle bundleWithPath:[bundle pathForResource:language ofType:@"lproj"]];
    }
    objc_setAssociatedObject(bundle, &kBundleKey, langBundle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
+ (NSString *)userSetLanguage
{
    return g_userSetLanguage;
}


+ (NSMutableDictionary *)_cachedMap
{
    static NSMutableDictionary* s_map = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_map = [[NSMutableDictionary alloc] init];
    });
    return s_map;
}
+ (instancetype)bundleNamed:(NSString *)name
{
    NSString* bundleName = name;
    NSRange suffixRange = [bundleName rangeOfString:@".bundle" options:NSAnchoredSearch | NSBackwardsSearch | NSCaseInsensitiveSearch];
    BOOL hasCaseInsensitiveSuffix = suffixRange.location != NSNotFound;
    if (!hasCaseInsensitiveSuffix) {
        bundleName = [bundleName stringByAppendingPathComponent:@".bundle"];
    }
    NSBundle* findCached = [self _cachedMap][bundleName];
    if (findCached == nil) {
        NSURL* URL = [[NSBundle mainBundle] URLForResource:bundleName withExtension:nil];
        NSAssert(URL, @"找不到Bundle: %@", bundleName);
        NSBundle* bundle = [NSBundle bundleWithURL:URL];
        [self setLanguage:[self userSetLanguage] forBundle:bundle];
        [self _cachedMap][bundleName] = bundle;
        findCached = bundle;
    }

    return findCached;
}
@end
