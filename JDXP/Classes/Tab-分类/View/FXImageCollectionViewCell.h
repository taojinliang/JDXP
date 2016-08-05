//
//  FXImageCollectionViewCell.h
//  JDXP
//
//  Created by MacBookPro on 16/1/29.
//  Copyright © 2016年 MacBookPro. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FLImageModel;
@interface FXImageCollectionViewCell : UICollectionViewCell
-(void)configureData:(FLImageModel *)model;
@end
