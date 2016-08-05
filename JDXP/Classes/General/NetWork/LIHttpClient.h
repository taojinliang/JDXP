//
//  LIHttpClient.h
//  LIGHTinvesting
//
//  Created by MacBookPro on 15/7/25.
//  Copyright (c) 2015年 Hundsun. All rights reserved.
//

#import <Foundation/Foundation.h>

/*请求状态 0: 成功, 其他失败*/
static const NSInteger LI_TRADE_FIELD_ERROR_NO_SUCCESS = 0;

/// 特定格式中出错时，/*请求状态 0: 成功, 其他失败*/
static NSString* const kLIErrorKey_No    = @"error_no";
/// 网络请求失败时，，服务器返回的`info`节点信息
static NSString* const kLIErrorKey_ErrorInfo   = @"error_info";



@interface LIHttpClient : NSObject


+(LIHttpClient*)shareManager;


/*!
 *@brief 发送统一封装请求  post方式
 *@param requestUrl:请求地址   reqdict:请求字典  block:回调函数
 */
-(void)sendRequest:(NSString *)requestUrl  withDictionary:(NSDictionary *)reqdict completionHandler:(void (^)(NSInteger errorNo,NSDictionary *dict)) block;


/*!
 *@brief 发送统一封装请求  get方式
 *@param requestUrl:请求地址   block:回调函数
 */
-(void)sendRequest:(NSString *)requestUrl  completionHandler:(void (^)(NSInteger errorNo,NSDictionary *dict)) block;


@end
