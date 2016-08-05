//
//  DataToolManager.m
//  JDXP
//
//  Created by MacBookPro on 16/1/28.
//  Copyright © 2016年 MacBookPro. All rights reserved.
//

#import "DataToolManager.h"

@implementation DataToolManager

+(DataToolManager *)shareManager{
    static DataToolManager *getInstance = nil;
    static dispatch_once_t once_token;
    dispatch_once(&once_token, ^{
        getInstance = [[DataToolManager alloc] init];
    });
    return getInstance;
}


#define IMAGE_URL0 @"http://m.360buyimg.com/mobilecms/s720x350_jfs/t2017/206/2133293844/72627/2acb5c4e/56a747abNafa89003.jpg"
#define IMAGE_URL1 @"http://m.360buyimg.com/mobilecms/s720x350_jfs/t2320/97/2065965263/101538/f7c25b9b/56a59abdN35d0e27a.jpg"
#define IMAGE_URL2 @"http://m.360buyimg.com/mobilecms/s720x350_jfs/t2224/87/2075634935/133720/9e6d5024/56a6dbbdNc76a14b5.jpg"
#define IMAGE_URL3 @"http://m.360buyimg.com/mobilecms/s720x350_jfs/t2578/254/1339960615/112379/bb53e4d8/56a5d9a1N6b28cfef.jpg"
#define IMAGE_URL4 @"http://m.360buyimg.com/mobilecms/s720x350_jfs/t2152/277/1419694932/74271/c53d7085/56a73df2N2fe85403.jpg"

-(NSArray *)JDSYCarouselImages{
    return @[
             [NSURL URLWithString:IMAGE_URL0],
             [NSURL URLWithString:IMAGE_URL1],
             [NSURL URLWithString:IMAGE_URL2],
             [NSURL URLWithString:IMAGE_URL3],
             [NSURL URLWithString:IMAGE_URL4]
             ];
}


#define MENU_IMAGE_URL0 @"http://m.360buyimg.com/mobilecms/s80x80_jfs/t2335/258/864347417/3395/15f0fba6/56333ebbN0c7fc23b.png"
#define MENU_IMAGE_URL1 @"http://m.360buyimg.com/mobilecms/s80x80_jfs/t2401/304/893337264/4249/3d40e699/56333ef6Nba360270.png"
#define MENU_IMAGE_URL2 @"http://m.360buyimg.com/mobilecms/s80x80_jfs/t2206/359/867813729/4030/19cc626b/56333f3fN8f4bbe95.png"
#define MENU_IMAGE_URL3 @"http://m.360buyimg.com/mobilecms/s80x80_jfs/t2065/314/910054908/3814/237dc6be/56333ed2N78cd03c9.png"
#define MENU_IMAGE_URL4 @"http://m.360buyimg.com/mobilecms/s80x80_jfs/t2449/288/2141058489/2304/ec6fe2b3/569a4428N4ae01181.png"
#define MENU_IMAGE_URL5 @"http://m.360buyimg.com/mobilecms/s80x80_jfs/t2419/308/1268109428/3246/7ece7402/5653fe08N5eaac9aa.png"
#define MENU_IMAGE_URL6 @"http://m.360buyimg.com/mobilecms/s80x80_jfs/t2473/272/1984837807/9529/4422a535/5693061dN2bae599e.png"
#define MENU_IMAGE_URL7 @"http://m.360buyimg.com/mobilecms/s80x80_jfs/t2533/192/30863933/4038/8fcaa385/56333ee5Nf9600169.png"
-(NSArray *)JDSYMenuImages{
    return @[
             [NSURL URLWithString:MENU_IMAGE_URL0],
             [NSURL URLWithString:MENU_IMAGE_URL1],
             [NSURL URLWithString:MENU_IMAGE_URL2],
             [NSURL URLWithString:MENU_IMAGE_URL3],
             [NSURL URLWithString:MENU_IMAGE_URL4],
             [NSURL URLWithString:MENU_IMAGE_URL5],
             [NSURL URLWithString:MENU_IMAGE_URL6],
             [NSURL URLWithString:MENU_IMAGE_URL7]
             ];
}

-(NSArray *)JDSYMenuTitles{
    return @[
             @"分类查询",
             @"物流查询",
             @"购物车",
             @"我的京东",
             @"充值中心",
             @"领券中心",
             @"京东超市",
             @"我的关注"
             ];
}


-(NSURL *)JDSYMenuNextImage{
    return [NSURL URLWithString:@"http://m.360buyimg.com/mobilecms/jfs/t2467/299/2078881628/54190/5d99c8f6/56a96adeN3bbf9cfe.jpg!q70.jpg"];
}


-(NSString *)LWS_JP_URL{
    return @"http://api.liwushuo.com/v2/channels/100/items?limit=20&ad=2&gender=1&offset=0&generation=1";
}

-(NSString *)FL_IMAGES_URL{
    return @"http://api.liwushuo.com/v2/collections?limit=10&offset=0";
}


-(NSString *)FL_IMAGES_TITLES_URL{
    return @"http://api.liwushuo.com/v2/item_categories/tree";
}
@end
