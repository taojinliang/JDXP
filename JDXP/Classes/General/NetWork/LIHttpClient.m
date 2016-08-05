//
//  LIHttpClient.m
//  LIGHTinvesting
//
//  Created by MacBookPro on 15/7/25.
//  Copyright (c) 2015年 Hundsun. All rights reserved.
//

#import "LIHttpClient.h"
#import "AFNetworking.h"
#import "AppDelegate.h"
#import "LIAppUtils.h"
#import "LIConfiguration.h"
#import "LIAppMacro.h"
#import "NotificationMacro.h"


@implementation LIHttpClient


+(LIHttpClient *)shareManager{
    //使用单一线程，解决网络同步请求的问题
    static LIHttpClient* shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[LIHttpClient alloc] init];
    });
    return shareInstance;
}

-(instancetype)init{
    self = [super init];
    if (self) {
    }
    return self;
}

#pragma mark -

-(void)sendRequest:(NSString *)requestUrl  withDictionary:(NSDictionary *)reqdict completionHandler:(void (^)(NSInteger errorNo,NSDictionary *dict)) block
{
    if (![NSJSONSerialization isValidJSONObject:reqdict]) {
        NSMutableDictionary *resp = [NSMutableDictionary dictionaryWithCapacity:2];
        [resp setObject:[NSNumber numberWithInteger:9999] forKey:kLIErrorKey_No];
        [resp setObject:@"reqdict is not a valid json object" forKey:kLIErrorKey_ErrorInfo];
        block(9999,resp);
    }

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFCompoundResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    // 请求超时时间
    manager.requestSerializer.timeoutInterval = 30;
    if (IsAnalogData) {
        [manager.requestSerializer setValue:@"1" forHTTPHeaderField:@"MockRequest"];
    }

    [manager POST:requestUrl parameters:reqdict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *jsonData = [operation.responseString JSONObject];
        NSString *errorNo = [NSString stringWithFormat:@"%@",[jsonData objectForKey:kLIErrorKey_No]];
        if ( [@"0" isEqualToString:errorNo] && ![LIAppUtils isContainEnglishLetters:errorNo]) {
            block(0,jsonData);
        }else{
            if (![LIAppUtils isContainEnglishLetters:errorNo]) {
                block([errorNo integerValue],jsonData);
            }else{
                //如果含有字母，将错误码设为-1
                block(-1,jsonData);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [LIAppUtils showLoadInfo:[[operation.responseString JSONObject] objectForKey:kLIErrorKey_ErrorInfo]];
        block(error.code,[operation.responseString JSONObject]);
    }];
 
}



-(void)sendRequest:(NSString *)requestUrl  completionHandler:(void (^)(NSInteger errorNo,NSDictionary *dict)) block{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFCompoundResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 30;
    [manager GET:requestUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *jsonData = [operation.responseString JSONObject];
        NSString *errorNo = [NSString stringWithFormat:@"%@",[jsonData objectForKey:kLIErrorKey_No]];
        if ( [@"0" isEqualToString:errorNo]) {
            block(0,jsonData);
        }else{
            block([errorNo integerValue],jsonData);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(error.code,[operation.responseString JSONObject]);
    }];
}



@end
