//
//  FXImageTableViewCell.h
//  JDXP
//
//  Created by MacBookPro on 16/1/28.
//  Copyright © 2016年 MacBookPro. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FXImageModel;
@interface FXImageTableViewCell : UITableViewCell
-(void)loadData:(FXImageModel *)model;
@end
