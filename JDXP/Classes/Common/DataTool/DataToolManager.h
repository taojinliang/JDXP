//
//  DataToolManager.h
//  JDXP
//
//  Created by MacBookPro on 16/1/28.
//  Copyright © 2016年 MacBookPro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataToolManager : NSObject
/**
 *  数据工具单例
 *
 *  @return
 */
+(DataToolManager *)shareManager;

/**
 *  首页广告滚动栏图片
 *
 *  @return 图片数组
 */
-(NSArray *)JDSYCarouselImages;

/**
 *  首页菜单栏图片
 *
 *  @return 图片数组
 */
-(NSArray *)JDSYMenuImages;

/**
 *  首页菜单栏标题
 *
 *  @return 标题数组
 */
-(NSArray *)JDSYMenuTitles;

/**
 *  菜单栏下方图片
 *
 *  @return
 */
-(NSURL *)JDSYMenuNextImage;

/**
 *  发现-礼物说，精品url地址
 *
 *  @return
 */
-(NSString *)LWS_JP_URL;

/**
 *  分类-滚动栏图片
 *
 *  @return
 */
-(NSString *)FL_IMAGES_URL;

/**
 *  分类- 标题_图片数据
 *
 *  @return
 */
-(NSString *)FL_IMAGES_TITLES_URL;

@end
