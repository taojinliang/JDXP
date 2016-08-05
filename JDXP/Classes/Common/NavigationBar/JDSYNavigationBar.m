//
//  JDSYNavigationBar.m
//  JDXP
//
//  Created by MacBookPro on 16/1/25.
//  Copyright © 2016年 MacBookPro. All rights reserved.
//

#import "JDSYNavigationBar.h"
#import "LIAppUtils.h"
#import "Masonry.h"
#import "LISkinCss.h"
#import "UtilsMacro.h"
#import "NotificationMacro.h"

#import "ActionButton.h"
#import "JDSYSearchBar.h"

#define kTag1 500001
#define kTag2 500002

@interface JDSYNavigationBar()<onActionButtonDelegate,JDSearchBarDelegate>
@property(nonatomic, strong) UIView *contentView;
@property(nonatomic, strong) ActionButton *scanButton;
@property(nonatomic, strong) JDSYSearchBar *searchBar;
@property(nonatomic, strong) ActionButton *messageButton;
@end

@implementation JDSYNavigationBar

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
    [self.contentView addSubview:self.scanButton];
    [self.contentView addSubview:self.searchBar];
    [self.contentView addSubview:self.messageButton];
    
    // 添加约束条件
    [self layoutPageSubviews];
}


-(void)changeAlpha:(CGFloat)tmp{
    _searchBar.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:(0.5+tmp)];
}

#pragma mark -onActionButtonDelegate
-(void)onTapAction:(NSInteger )tag{
    if (tag == kTag1) {
        if ([self.barDelegate respondsToSelector:@selector(gotoNavBarScanPage)]) {
            [self.barDelegate gotoNavBarScanPage];
        }
    }else{
        if ([self.barDelegate respondsToSelector:@selector(gotoNavBarMessagePage)]) {
            [self.barDelegate gotoNavBarMessagePage];
        }
    }
}

#pragma mark -JDSearchBarDelegate
-(void)gotoSearchPage{
    if ([self.barDelegate respondsToSelector:@selector(gotoNavBarSearchPage)]) {
        [self.barDelegate gotoNavBarSearchPage];
    }
}

-(void)gotoVoicePage{
    if ([self.barDelegate respondsToSelector:@selector(gotoNavBarVoicePage)]) {
        [self.barDelegate gotoNavBarVoicePage];
    }
}

#pragma mark -layoutPageSubviews
-(void)layoutPageSubviews{
    @WeakObj(self);
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(selfWeak);
    }];
    
    [self.scanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(selfWeak.contentView).offset(20);
        make.left.mas_equalTo(selfWeak.contentView);
        make.size.mas_equalTo(CGSizeMake(40, 44));
    }];
    
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(selfWeak.contentView).offset(20);
        make.left.mas_equalTo(selfWeak.scanButton.mas_right).offset(10);
        make.right.mas_equalTo(selfWeak.messageButton.mas_left).offset(-10);
        make.bottom.mas_equalTo(selfWeak.contentView).offset(-5);
    }];
    
    
    [self.messageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(selfWeak.contentView).offset(20);
        make.right.mas_equalTo(selfWeak.contentView);
        make.size.mas_equalTo(CGSizeMake(40, 44));
    }];

    
}

-(UIView *)contentView{
    if (_contentView == nil) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor clearColor];
    }
    return _contentView;
}

-(ActionButton *)scanButton{
    if (_scanButton == nil) {
        _scanButton = [[ActionButton alloc] init];
        _scanButton.tag = kTag1;
        [_scanButton configureData:@"scan" Title:@"扫一扫"];
        _scanButton.delegate = self;
    }
    return _scanButton;
}

-(JDSYSearchBar *)searchBar{
    if (_searchBar == nil) {
        _searchBar = [[JDSYSearchBar alloc] init];
        _searchBar.layer.cornerRadius = 4.0f;
        _searchBar.layer.masksToBounds = YES;
        _searchBar.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        _searchBar.delegate = self;
    }
    return _searchBar;
}

-(ActionButton *)messageButton{
    if (_messageButton == nil) {
        _messageButton = [[ActionButton alloc] init];
        _messageButton.tag = kTag2;
        [_messageButton configureData:@"message" Title:@"消息"];
        _messageButton.delegate = self;
    }
    return _messageButton;
}

@end
