//
//  FXMenuTableViewCell.m
//  JDXP
//
//  Created by MacBookPro on 16/2/1.
//  Copyright © 2016年 MacBookPro. All rights reserved.
//

#import "FXMenuTableViewCell.h"
#import "LIAppUtils.h"
#import "Masonry.h"
#import "LISkinCss.h"
#import "LIAppMacro.h"
#import "UtilsMacro.h"

#import "UIImageView+WebCache.h"


@interface FXMenuTableViewCell()
@property (strong, nonatomic) UIView *vline;
@property (strong, nonatomic) UILabel *titleLabel;
@end


@implementation FXMenuTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initViewUI];
    }
    return self;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)initViewUI {
    [self.contentView addSubview:self.vline];
    [self.contentView addSubview:self.titleLabel];

    
    // 添加约束条件
    [self layoutPageSubviews];
}


-(void)configureData:(NSString *)title normalIndexPath:(NSIndexPath *)normalIndexPath selectedIndexPath:(NSIndexPath *)selectedIndexPath{
    self.titleLabel.text = title;
    if (normalIndexPath.section == selectedIndexPath.section && normalIndexPath.row == selectedIndexPath.row) {
        self.titleLabel.textColor = [LISkinCss colorRGBf75300];
        self.vline.hidden = NO;
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    }else{
        self.titleLabel.textColor = [LISkinCss colorRGB686f7e];
        self.vline.hidden = YES;
        self.backgroundColor = [LISkinCss colorRGBeeeeee];
    }
}


#pragma mark - private method


- (void)layoutPageSubviews {
    
    @WeakObj(self);
    
    [self.vline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(selfWeak.contentView);
        make.width.mas_equalTo(2);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_equalTo(selfWeak.contentView);
        make.left.mas_equalTo(selfWeak.vline.mas_right);
    }];
    
}

#pragma mark - setter and getter

- (UIView *)vline {
    if (_vline == nil) {
        _vline = [[UIView alloc] init];
        _vline.backgroundColor = [LISkinCss colorRGBf75300];
    }
    
    return _vline;
}

-(UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [LISkinCss fontSize13];
    }
    return _titleLabel;
}
@end
