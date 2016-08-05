//
//  LIConfiguration.m
//  LIGHTinvesting
//
//  Created by MacBookPro on 15/9/23.
//  Copyright © 2015年 Hundsun. All rights reserved.
//

#import "LIConfiguration.h"
#import "UtilsMacro.h"


//生产环境，用于代码写死最终的生产地址
static NSString *serverURL=@"";

/*!
 *@brief 用于在设置中启用的配置地址
 *
 */
//UAT环境
static NSString *serverURL_UAT=@"http://120.55.176.224:8320/REST/";
//SIT环境
static NSString *serverURL_SIT=@"http://192.168.46.106:28320/REST/";


@implementation LIConfiguration

/*!
 *@brief 单例
 *
 */
+(LIConfiguration *)shareManager{
    static LIConfiguration* shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[LIConfiguration alloc] init];
    });
    return shareInstance;
}

/*!
 *@brief 服务端配置固定请求地址
 *
 */
+(NSString *)serverURL
{
    return serverURL;
}


/*!
 *@brief 发送请求地址获取
 *@pram 首先获取服务端固定请求地址，再从设置中获取请求地址（不需要设置地址时，将设置请求地址置空）,请求地址为空的条件下，开关打开为UAT地址，关闭为SIT地址
 *@pram 发布时，将settings.bundle删除即可
 */
-(NSString*)stationList{
    if ([[LIConfiguration serverURL] length]>0) {
        return [LIConfiguration serverURL];
    }
//#ifdef DEBUG
    NSUserDefaults* tdefaults = [NSUserDefaults standardUserDefaults];
    NSString* result = [tdefaults objectForKey:@"name_preference"];
    if([result length] != 0)
    {
        return result;
    }else{
        NSString* resultBool = [tdefaults objectForKey:@"enabled_preference"];
        if ([resultBool boolValue]) {
            return serverURL_UAT;
        }else{
            return serverURL_SIT;
        }
    }
//#endif
}


/*!
 *@brief 注册settings.bundle
 *
 */
- (void)registerDefaultsFromSettingsBundle {
//#ifdef DEBUG
    NSString *settingsBundle = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"bundle"];
    if(!settingsBundle) {
        DLog(@"Could not find Settings.bundle");
        return;
    }
    
    NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:[settingsBundle stringByAppendingPathComponent:@"Root.plist"]];
    NSArray *preferences = [settings objectForKey:@"PreferenceSpecifiers"];
    
    NSMutableDictionary *defaultsToRegister = [[NSMutableDictionary alloc] initWithCapacity:[preferences count]];
    for(NSDictionary *prefSpecification in preferences) {
        
        NSString *key = [prefSpecification objectForKey:@"Key"];
        if(key) {
            id value=[prefSpecification objectForKey:@"DefaultValue"];
            
            [defaultsToRegister setObject:value forKey:key];
        }
    }
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultsToRegister];
    [[NSUserDefaults standardUserDefaults] synchronize];
//#endif
}

//加载图片与跳转协议URL
- (NSString *)baseURL{
    NSString *baseUrl = [[self stationList] substringToIndex:[[self stationList] length]-5];
    return baseUrl;
}

@end
