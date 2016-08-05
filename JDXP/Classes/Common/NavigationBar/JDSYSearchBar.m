//
//  JDSYSearchBar.m
//  JDXP
//
//  Created by MacBookPro on 16/1/25.
//  Copyright © 2016年 MacBookPro. All rights reserved.
//

#import "JDSYSearchBar.h"
#import "LIAppUtils.h"
#import "Masonry.h"
#import "LISkinCss.h"
#import "UtilsMacro.h"

@interface JDSYSearchBar()<UITextFieldDelegate>
@property(nonatomic, strong) UIView *contentView;
@property(nonatomic, strong) UIButton *searchImageView;
@property(nonatomic, strong) UITextField *searchTextField;
@property(nonatomic, strong) UIButton *avidoImageView;
@end

@implementation JDSYSearchBar

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
    
}

- (void)initViewUI{
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.searchImageView];
    [self.contentView addSubview:self.searchTextField];
    [self.contentView addSubview:self.avidoImageView];
    
    // 添加约束条件
    [self layoutPageSubviews];
}

-(void)search{
    if ([self.delegate respondsToSelector:@selector(gotoSearchPage)]) {
        [self.delegate gotoSearchPage];
    }
}

-(void)audio{
    if ([self.delegate respondsToSelector:@selector(gotoVoicePage)]) {
        [self.delegate gotoVoicePage];
    }
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if ([self.delegate respondsToSelector:@selector(gotoSearchPage)]) {
        [self.delegate gotoSearchPage];
    }
    return NO;
}

#pragma mark -layoutPageSubviews
-(void)layoutPageSubviews{
    @WeakObj(self);
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(selfWeak);
    }];
    
    [self.searchImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(selfWeak.contentView).offset(10);
        make.centerY.mas_equalTo(selfWeak.contentView);
        make.size.mas_equalTo(CGSizeMake(30, 24));
    }];
    
    [self.searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(selfWeak.searchImageView.mas_right).offset(10);
        make.right.mas_equalTo(selfWeak.avidoImageView.mas_left).offset(-10);
        make.top.mas_equalTo(selfWeak.contentView).offset(0);
        make.bottom.mas_equalTo(selfWeak.contentView).offset(0);
    }];
    
    [self.avidoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(selfWeak.contentView).offset(-10);
        make.centerY.mas_equalTo(selfWeak.contentView);
        make.size.mas_equalTo(CGSizeMake(14, 18));
    }];
    
    
}

-(UIView *)contentView{
    if (_contentView == nil) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor clearColor];
    }
    return _contentView;
}

-(UIButton *)searchImageView{
    if (_searchImageView == nil) {
        _searchImageView = [[UIButton alloc] init];
        [_searchImageView setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
        [_searchImageView setImage:[UIImage imageNamed:@"search"] forState:UIControlStateHighlighted];
        [_searchImageView addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchImageView;
}

-(UITextField *)searchTextField{
    if (_searchTextField == nil) {
        _searchTextField = [[UITextField alloc] init];
        _searchTextField.delegate = self;
        _searchTextField.textAlignment = NSTextAlignmentLeft;
        _searchTextField.backgroundColor = [UIColor clearColor];
        _searchTextField.placeholder = @"春运启程 把爱装回家";
    }
    return _searchTextField;
}

-(UIButton *)avidoImageView{
    if (_avidoImageView == nil) {
        _avidoImageView = [[UIButton alloc] init];
        [_avidoImageView setImage:[UIImage imageNamed:@"audio"] forState:UIControlStateNormal];
        [_avidoImageView setImage:[UIImage imageNamed:@"audio"] forState:UIControlStateHighlighted];
        [_avidoImageView addTarget:self action:@selector(audio) forControlEvents:UIControlEventTouchUpInside];
    }
    return _avidoImageView;
}

@end

