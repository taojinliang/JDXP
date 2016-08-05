//
//  FLImageModel.h
//  JDXP
//
//  Created by MacBookPro on 16/1/29.
//  Copyright © 2016年 MacBookPro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLImageModel : NSObject
/**
 *  图片id
 */
@property (nonatomic,copy) NSString  *image_id;
/**
 *  图片地址
 */
@property (nonatomic,copy) NSString  *icon_url;
/**
 *  标题
 */
@property (nonatomic,copy) NSString  *name;
@end



//"icon_url" = "http://img02.liwushuo.com/image/150615/3nc5tejwl.png-pw144";
//id = 1;
//name = "\U70ed\U95e8\U5206\U7c7b";
//order = 11;
//status = 0;
//subcategories