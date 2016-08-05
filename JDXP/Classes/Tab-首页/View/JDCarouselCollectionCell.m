//
//  JDCarouselCollectionCell.m
//  JDXP
//
//  Created by MacBookPro on 16/1/26.
//  Copyright © 2016年 MacBookPro. All rights reserved.
//

#import "JDCarouselCollectionCell.h"

@implementation JDCarouselCollectionCell
-(void)layoutSubviews{
    [super layoutSubviews];
    if (_imageView) {
        self.imageView.frame = self.contentView.bounds;
    }
}

-(UIImageView *)imageView{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_imageView];
    }
    return _imageView;
}
@end
