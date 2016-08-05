//
//  LIConfiguration.h
//  LIGHTinvesting
//
//  Created by MacBookPro on 15/9/23.
//  Copyright © 2015年 Hundsun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LIConfiguration : NSObject


/*!
 *@brief 单例
 *
 */
+(LIConfiguration*)shareManager;

/*!
 *@brief 服务端配置固定请求地址
 *
 */
+(NSString *)serverURL;

/*!
 *@brief 发送请求地址获取
 *@pram 首先获取服务端固定请求地址，再从设置中获取请求地址（不需要设置地址时，将设置请求地址置空）
 *@pram 发布时，将settings.bundle删除即可
 */
-(NSString*)stationList;


/*!
 *@brief 注册settings.bundle
 *
 */
- (void)registerDefaultsFromSettingsBundle;

/*!
 *@brief 用于全局的图片和协议的统一入口
 *
 */
-(NSString *)baseURL;

@end
