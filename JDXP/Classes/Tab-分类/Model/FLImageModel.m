//
//  FLImageModel.m
//  JDXP
//
//  Created by MacBookPro on 16/1/29.
//  Copyright © 2016年 MacBookPro. All rights reserved.
//

#import "FLImageModel.h"

@implementation FLImageModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        _image_id = value;
    }else if ([key isEqualToString:@"icon_url"]){
        _icon_url = value;
    }else if ([key isEqualToString:@"name"]){
        _name = value;
    }
}
@end
