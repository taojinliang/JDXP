//
//  ActionButton.m
//  JDXP
//
//  Created by MacBookPro on 16/1/25.
//  Copyright © 2016年 MacBookPro. All rights reserved.
//

#import "ActionButton.h"
#import "LIAppUtils.h"
#import "Masonry.h"
#import "LISkinCss.h"
#import "UtilsMacro.h"

@interface ActionButton()
@property(nonatomic, strong) UIView *contentView;
@property(nonatomic, strong) UIImageView *tagImageView;
@property(nonatomic, strong) UILabel *tagLabel;
@end

@implementation ActionButton

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initViewData];
        [self initViewUI];
    }
    return self;
}

- (void)initViewData{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onAction)];
    [self addGestureRecognizer:tapGesture];
}

- (void)initViewUI{
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.tagImageView];
    [self.contentView addSubview:self.tagLabel];
    
    // 添加约束条件
    [self layoutPageSubviews];
}

/**
 *  点击事件
 */
-(void)onAction{
    if ([self.delegate respondsToSelector:@selector(onTapAction:)]) {
        [self.delegate onTapAction:self.tag];
    }
}

/**
 *  配置按钮图片标题
 *
 *  @param imageName 图片名字
 *  @param title     标题
 */
-(void)configureData:(NSString *)imageName Title:(NSString *)title{
    self.tagImageView.image = [UIImage imageNamed:imageName];
    self.tagLabel.text = title;
}

#pragma mark -layoutPageSubviews
-(void)layoutPageSubviews{
    @WeakObj(self);
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(selfWeak);
    }];
    
    [self.tagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(selfWeak.contentView);
        make.centerX.mas_equalTo(selfWeak.contentView);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(selfWeak.tagImageView.mas_bottom);
        make.centerX.mas_equalTo(selfWeak.tagImageView.mas_centerX);
        make.width.mas_equalTo(selfWeak.contentView.mas_width);
        make.bottom.mas_equalTo(selfWeak.contentView.mas_bottom);
    }];
    
}


-(UIView *)contentView{
    if (_contentView == nil) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor clearColor];
    }
    return _contentView;
}

-(UIImageView *)tagImageView{
    if (_tagImageView == nil) {
        _tagImageView = [[UIImageView alloc] init];
    }
    return _tagImageView;
}

-(UILabel *)tagLabel{
    if (_tagLabel == nil) {
        _tagLabel = [[UILabel alloc] init];
        _tagLabel.textAlignment = NSTextAlignmentCenter;
        _tagLabel.textColor = [UIColor whiteColor];
        _tagLabel.font = [LISkinCss fontSize11];
    }
    return _tagLabel;
}

@end

