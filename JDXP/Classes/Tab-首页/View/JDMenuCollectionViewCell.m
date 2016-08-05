//
//  JDMenuCollectionViewCell.m
//  JDXP
//
//  Created by MacBookPro on 16/1/28.
//  Copyright © 2016年 MacBookPro. All rights reserved.
//

#import "JDMenuCollectionViewCell.h"
#import "LIAppUtils.h"
#import "LIAttributeConfig.h"
#import "Masonry.h"
#import "LISkinCss.h"
#import "LIAppMacro.h"
#import "UtilsMacro.h"
#import "UIImageView+WebCache.h"

@interface JDMenuCollectionViewCell()
@property(strong,nonatomic) UIView *contentMainView;
@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UILabel *titleLabel;
@end

@implementation JDMenuCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initViewData];
        [self initViewUI];
    }
    return self;
}

- (void)initViewData {
}

- (void)initViewUI {
    [self.contentView addSubview:self.contentMainView];
    [self.contentMainView addSubview:self.imageView];
    [self.contentMainView addSubview:self.titleLabel];

    // 添加约束条件
    [self layoutPageSubviews];
}

-(void)configureData:(NSURL *)imageurl Title:(NSString *)title{
    [self.imageView sd_setImageWithURL:imageurl];
    self.titleLabel.text = title;
}

-(void)layoutPageSubviews{
    @WeakObj(self);
    [self.contentMainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(selfWeak.contentView);
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(selfWeak.contentMainView);
        make.centerX.mas_equalTo(selfWeak.contentMainView);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(selfWeak.contentMainView);
        make.top.mas_equalTo(selfWeak.imageView.mas_bottom);
        make.height.mas_equalTo(20);
    }];
}

-(UIView *)contentMainView{
    if (_contentMainView == nil) {
        _contentMainView = [[UIView alloc] init];
        _contentMainView.backgroundColor = [UIColor whiteColor];
    }
    return _contentMainView;
}

-(UIImageView *)imageView{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        
    }
    return _imageView;
}

-(UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [LISkinCss colorRGB3b3f4a];
        _titleLabel.font = [LISkinCss fontSize11];
    }
    return _titleLabel;
}

@end
