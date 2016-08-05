//
//  FXImageTableViewCell.m
//  JDXP
//
//  Created by MacBookPro on 16/1/28.
//  Copyright © 2016年 MacBookPro. All rights reserved.
//

#import "FXImageTableViewCell.h"
#import "LIAppUtils.h"
#import "Masonry.h"
#import "LISkinCss.h"
#import "LIAppMacro.h"
#import "UtilsMacro.h"

#import "UIImageView+WebCache.h"
#import "FXImageModel.h"

@interface FXImageTableViewCell()
@property (strong, nonatomic) UIImageView *fxImageView;
@property (strong, nonatomic) UIView *whiteView;
@property (strong, nonatomic) UILabel *shortLabel;
@property (strong, nonatomic) UIView *horizontalLine;
@property (strong, nonatomic) UILabel *longLabel;
@end


@implementation FXImageTableViewCell
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
    [self.contentView addSubview:self.fxImageView];
    [self.fxImageView addSubview:self.whiteView];
    [self.whiteView addSubview:self.shortLabel];
    [self.whiteView addSubview:self.horizontalLine];
    [self.whiteView addSubview:self.longLabel];
    
    // 添加约束条件
    [self layoutPageSubviews];
}


-(void)loadData:(FXImageModel *)model{
    [self.fxImageView sd_setImageWithURL:[NSURL URLWithString:model.cover_image_url] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.shortLabel.text = model.short_title;
    self.longLabel.text = model.title;
}


#pragma mark - private method


- (void)layoutPageSubviews {
    
    @WeakObj(self);
    
    [self.fxImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(selfWeak.contentView);
    }];
    
    [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(selfWeak.fxImageView);
        make.bottom.mas_equalTo(selfWeak.contentView);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-200, 80));
    }];
    
    [self.shortLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(selfWeak.whiteView);
        make.centerX.mas_equalTo(selfWeak.whiteView);
        make.left.right.mas_equalTo(selfWeak.whiteView);
        make.height.mas_equalTo(35);
    }];
    
    [self.horizontalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(selfWeak.whiteView.mas_left).offset(50);
        make.right.mas_equalTo(selfWeak.whiteView.mas_right).offset(-50);
        make.top.mas_equalTo(selfWeak.shortLabel.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    
    [self.longLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(selfWeak.horizontalLine.mas_bottom);
        make.centerX.mas_equalTo(selfWeak.whiteView);
        make.left.right.mas_equalTo(selfWeak.whiteView);
        make.height.mas_equalTo(35);
    }];
    
}

#pragma mark - setter and getter

-(UIImageView *)fxImageView{
    if (_fxImageView == nil) {
        _fxImageView = [[UIImageView alloc] init];
    }
    return _fxImageView;
}

-(UIView *)whiteView{
    if (_whiteView == nil) {
        _whiteView = [[UIView alloc] init];
        _whiteView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    }
    return _whiteView;
}

-(UILabel *)shortLabel{
    if (_shortLabel == nil) {
        _shortLabel = [[UILabel alloc] init];
        _shortLabel.textAlignment = NSTextAlignmentCenter;
        _shortLabel.textColor = [UIColor blackColor];
        _shortLabel.font = [LISkinCss fontSize13];
    }
    return _shortLabel;
}

- (UIView *)horizontalLine {
    if (_horizontalLine == nil) {
        _horizontalLine = [[UILabel alloc] init];
        _horizontalLine.backgroundColor = [LISkinCss colorRGBeeeeee];
    }
    
    return _horizontalLine;
}

-(UILabel *)longLabel{
    if (_longLabel == nil) {
        _longLabel = [[UILabel alloc] init];
        _longLabel.textAlignment = NSTextAlignmentCenter;
        _longLabel.textColor = [UIColor blackColor];
        _longLabel.font = [LISkinCss fontSize13];
    }
    return _longLabel;
}
@end