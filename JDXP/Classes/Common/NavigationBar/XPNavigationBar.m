//
//  XPNavigationBar.m
//  JDXP
//
//  Created by MacBookPro on 16/1/28.
//  Copyright © 2016年 MacBookPro. All rights reserved.
//

#import "XPNavigationBar.h"
#import "LISkinCss.h"
#import <Masonry.h>

@interface XPNavigationBar ()
@property (nonatomic, weak) UIViewController *targetVC;
@property (nonatomic, strong) NSMutableArray *leftButtons;
@property (nonatomic, strong) NSMutableArray *rightButtons;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation XPNavigationBar

- (id)initWithTarget:(UIViewController *)targetVC {
    self = [super initWithFrame:CGRectZero];
    if(self) {
        self.targetVC = targetVC;
        [self initDatas];
        [self initViews];
        [self initLayouts];
    }
    return self;
}

- (void)initDatas {
    self.leftButtons = @[].mutableCopy;
    self.rightButtons = @[].mutableCopy;
}

- (void)initViews {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.titleLabel];
}

- (void)initLayouts {
    __weak typeof(self) weakSelf = self;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.centerY.equalTo(weakSelf).offset(10);
        make.size.mas_equalTo(CGSizeMake(160, 44));
    }];
}

- (void)updateLayouts {
    __weak typeof(self) weakSelf = self;
    __block UIButton *lastBtn = nil;
    [self.leftButtons enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL *stop) {
        [btn sizeToFit];
        CGFloat width = MAX(btn.frame.size.width, 44);
        CGFloat height = MAX(btn.frame.size.height, 44);
        [btn mas_updateConstraints:^(MASConstraintMaker *make) {
            if(lastBtn == nil) {
                make.left.equalTo(weakSelf);
            } else {
                make.left.equalTo(lastBtn.mas_right);
            }
            make.bottom.equalTo(weakSelf);
            make.size.mas_equalTo(CGSizeMake(width, height));
        }];
        lastBtn = btn;
    }];
    lastBtn = nil;
    [self.rightButtons enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL *stop) {
        [btn sizeToFit];
        CGFloat width = MAX(btn.frame.size.width, 44);
        CGFloat height = MAX(btn.frame.size.height, 44);
        [btn mas_updateConstraints:^(MASConstraintMaker *make) {
            if(lastBtn == nil) {
                make.right.equalTo(weakSelf);
            } else {
                make.right.equalTo(lastBtn.mas_left);
            }
            make.bottom.equalTo(weakSelf);
            make.size.mas_equalTo(CGSizeMake(width, height));
        }];
        lastBtn = btn;
    }];
}

#pragma mark - Public

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (void)addDefaultBackButton {
    UIButton *btn = [self buttonWithImage:[UIImage imageNamed:@"common_back"] target:self action:@selector(actionBack) imageInsets:UIEdgeInsetsMake(0, -12, 0, 0)];
    [self.leftButtons addObject:btn];
    [self addSubview:btn];
    [self updateLayouts];
}

- (void)addLeftButtonWithImage:(UIImage *)image action:(SEL)action {
    UIButton *btn = [self buttonWithImage:image target:self.targetVC action:action imageInsets:UIEdgeInsetsZero];
    [self.leftButtons addObject:btn];
    [self addSubview:btn];
    [self updateLayouts];
}

- (void)addRightButtonWithImage:(UIImage *)image action:(SEL)action {
    UIButton *btn = [self buttonWithImage:image target:self.targetVC action:action imageInsets:UIEdgeInsetsZero];
    [self.rightButtons addObject:btn];
    [self addSubview:btn];
    [self updateLayouts];
}

- (void)fadeTitleWithAlpha:(CGFloat)alpha {
    self.titleLabel.alpha = alpha;
}

- (UIButton *)buttonWithImage:(UIImage *)image target:(id)target action:(SEL)action imageInsets:(UIEdgeInsets)insets {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:image forState:UIControlStateNormal];
    btn.imageEdgeInsets = insets; ;
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

#pragma mark - Action

- (void)actionBack {
    [self.targetVC.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Object

- (UILabel *)titleLabel {
    if(!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:17];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

@end


