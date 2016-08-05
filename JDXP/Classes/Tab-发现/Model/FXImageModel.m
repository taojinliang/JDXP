//
//  FXImageModel.m
//  JDXP
//
//  Created by MacBookPro on 16/1/28.
//  Copyright © 2016年 MacBookPro. All rights reserved.
//

#import "FXImageModel.h"

@implementation FXImageModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        _image_id = value;
    }else if ([key isEqualToString:@"cover_image_url"]){
        _cover_image_url = value;
    }else if ([key isEqualToString:@"title"]){
        _title = value;
    }else if ([key isEqualToString:@"url"]){
        _url = value;
    }else if ([key isEqualToString:@"likes_count"]){
        _likes_count = value;
    }else if ([key isEqualToString:@"short_title"]){
        _short_title = value;
    }
}

@end
