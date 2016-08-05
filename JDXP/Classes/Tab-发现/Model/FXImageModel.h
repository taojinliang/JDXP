//
//  FXImageModel.h
//  JDXP
//
//  Created by MacBookPro on 16/1/28.
//  Copyright © 2016年 MacBookPro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FXImageModel : NSObject
/**
 *  图片id
 */
@property (nonatomic,copy) NSString  *image_id;
/**
 *  图片地址
 */
@property (nonatomic,copy) NSString  *cover_image_url;
/**
 *  内容标题
 */
@property (nonatomic,copy) NSString  *title;
/**
 *  简短内容标题
 */
@property (nonatomic,copy) NSString  *short_title;
/**
 *  内容地址
 */
@property (nonatomic,copy) NSString  *url;
/**
 *  喜欢人数
 */
@property (nonatomic,copy) NSString  *likes_count;
@end


//"content_type" = 1;
//"content_url" = "http://www.liwushuo.com/posts/1032817/content";
//"cover_image_url" = "http://img01.liwushuo.com/image/160125/sw3tltql1.jpg-w720";
//"created_at" = 1453953600;
//"editor_id" = 1023;
//"feature_list" =     (
//);
//id = 1032817;
//labels =     (
//);
//liked = 0;
//"likes_count" = 2589;
//"published_at" = 1453953600;
//"share_msg" = "\U968f\U7740\U6211\U4eec\U7684\U6210\U957f\Uff0c\U79d1\U6280\U7684\U6210\U957f\Uff0c\U793e\U4f1a\U7684\U6210\U957f\Uff0c\U6211\U4eec\U7684\U670b\U53cb\U5708\Uff0c\U793e\U4ea4\U5708\U4e5f\U53d8\U5f97\U8d8a\U6765\U8d8a\U5e7f\U3002\U6240\U4ee5\U6211\U4eec\U7684\U670b\U53cb\U5708\U4e2d\U5c31\U591a\U4e86\U5f88\U591a\U5916\U56fd\U4eba\U3002\U4e2d\U56fd\U53c8\U662f\U4e00\U4e2a\U6587\U660e\U53e4\U56fd\Uff0c\U662f\U4e00\U4e2a\U793c\U4eea\U4e4b\U90a6\Uff0c\U6240\U4ee5\U793c\U5c1a\U5f80\U6765\U662f\U96be\U514d\U7684\U3002\U6211\U4eec\U4e60\U60ef\U4e86\U7ed9\U81ea\U5df1\U4eba\U9001\U793c\Uff0c\U4e60\U60ef\U4e86\U7ed9\U4e2d\U56fd\U4eba\U9001\U793c\Uff0c\U5c31\U662f\U6ca1\U6709\U4e60\U60ef\U7ed9\U5916\U56fd\U4eba\U9001\U793c\U3002\U65b0\U5e74\U5c31\U8981\U5230\U4e86\Uff0c\U4f60\U7ed9\U8eab\U8fb9\U7684\U5916\U56fd\U670b\U53cb\U9001\U793c\U4e86\U5417\Uff0c\U8fd8\U6709\U4ec0\U4e48\U80fd\U6bd4\U9001\U4e00\U4e9b\U4e2d\U56fd\U98ce\U7684\U793c\U7269\U66f4\U5408\U9002\U5462\Uff0c\U4e0d\U8981\U72b9\U8c6b\U4e86\Uff0c\U501f\U7740\U5e74\U5473\U5feb\U70b9\U628a\U6211\U4eec\U6700\U5177\U7279\U8272\U7684\U4e2d\U56fd\U98ce\U793c\U7269\U9001\U7ed9\U4f60\U7684\U6d0b\U4eba\U670b\U53cb\U5427~";
//"short_title" = "\U4e2d\U56fd\U98ce";
//status = 0;
//template = "";
//title = "\U501f\U7740\U5e74\U5473\Uff0c\U4e2d\U56fd\U98ce\U7684\U65b0\U5e74\U793c\U7269\U9001\U7ed9\U6d0b\U4eba\U670b\U53cb";
//type = post;
//"updated_at" = 1453703396;
//url = "http://www.liwushuo.com/posts/1032817";