//
//  LINotificationUtils.m
//  LIGHTinvesting
//
//  Created by shj on 15/9/18.
//  Copyright (c) 2015年 Hundsun. All rights reserved.
//

#import "LINotificationUtils.h"
#import "UtilsMacro.h"

@interface LINotificationUtils () 

@end

@implementation LINotificationUtils

+ (instancetype)getInstance {
    static LINotificationUtils *obj = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        obj = [[LINotificationUtils alloc] init];
    });
    return obj;
}

#pragma mark - Notification

- (void)registerRemoteNotification {
    UIApplication *application = [UIApplication sharedApplication];
    if([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound) categories:nil];
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    } else {
        [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge];
    }
}

#pragma mark - public

- (void)registerRemoteNotificationWithDeviceToken:(NSString *)deviceToken {
    DLog(@"deviceToken: %@", deviceToken);
    [self requestSendRemoteNotificationAccessToken:deviceToken];
}

- (void)failedRegisterRemoteNotificationWithError:(NSError *)error {
    DLog(@"Register Remote Notification Failed: %@", error);
}

#pragma mark - Net

- (void)requestSendRemoteNotificationAccessToken:(NSString *)token {
//    NSDictionary *parameters = @{@"access_token":[[LIUserManager getInstance] getAccessToken], @"device_token":token, @"app_type":@2};
//    [[LIHttpClient shareManager] sendRequest:LI_MESSAGE_PUSHED withDictionary:parameters completionHandler:^(NSInteger errorNo, NSDictionary *dict) {
//        
//    }];
}

#pragma mark - LINetworkCenterDelegate

- (void)requestDataSuccess:(NSDictionary *)dic protocolDefine:(NSString *)functionID {
    DLog(@"%@", dic);
}

- (void)requestDataFailure:(NSString *)functionID {
    DLog(@"failed");
}

- (void)requestDataTimeOut:(NSString *)functionID {
    DLog(@"timeout");
}




@end








