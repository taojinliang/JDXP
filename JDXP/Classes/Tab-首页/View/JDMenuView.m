//
//  JDMenuView.m
//  JDXP
//
//  Created by MacBookPro on 16/1/28.
//  Copyright © 2016年 MacBookPro. All rights reserved.
//

#import "JDMenuView.h"
#import "LIAppUtils.h"
#import "LIAttributeConfig.h"
#import "Masonry.h"
#import "NSStringAdditions.h"
#import "UtilsMacro.h"
#import "LIAppMacro.h"

#import "JDMenuCollectionViewCell.h"

#define kItemHight 60
#define kItemSpaceHeight 10

@interface JDMenuView()<UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) UICollectionView *contentView;
@property (strong, nonatomic) NSArray *resultIndexArray;
@end

@implementation JDMenuView

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


-(void)loadData:(NSArray *)array{
    _resultIndexArray = array;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.contentView reloadData];
    });
}

- (void)initViewUI {
    [self addSubview:self.contentView];
    // 添加约束条件
    [self layoutPageSubviews];
}


-(void)layoutPageSubviews{
    @WeakObj(self);
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(selfWeak);
    }];
}

#pragma mark -UICollectionViewDataSource, UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_resultIndexArray count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JDMenuCollectionViewCell *cell = (JDMenuCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JDMenuCollectionViewCell class]) forIndexPath:indexPath];
    if (!cell) {
        cell = [[JDMenuCollectionViewCell alloc] init];
    }
    NSDictionary *dict = [_resultIndexArray objectAtIndex:indexPath.item];
    [cell configureData:[[dict allValues] objectAtIndex:0] Title:[[dict allKeys] objectAtIndex:0]];
    return cell;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    return nil;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeZero;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeZero;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([_resultIndexArray count] > 0) {
        if ([self.delegate respondsToSelector:@selector(gotoJDMenuPage:)]) {
            [self.delegate gotoJDMenuPage:indexPath.item];
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(SCREEN_WIDTH/4, kItemHight);
}


-(UICollectionView *)contentView{
    if (_contentView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(10, 0, 10, 0);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _contentView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _contentView.delegate = self;
        _contentView.dataSource = self;
        _contentView.showsHorizontalScrollIndicator = NO;
        [_contentView registerClass:[JDMenuCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([JDMenuCollectionViewCell class])];
        _contentView.backgroundColor = [UIColor whiteColor];
        
    }
    return _contentView;
}
@end
