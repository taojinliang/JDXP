//
//  XPFLViewController.m
//  JDXP
//
//  Created by MacBookPro on 16/1/21.
//  Copyright © 2016年 MacBookPro. All rights reserved.
//

#import "XPFLViewController.h"
#import "Masonry.h"
#import "MJRefresh.h"
#import "UtilsMacro.h"
#import "LIAppMacro.h"
#import "LISkinCss.h"
#import "LIAppUtils.h"

#import "XPNavigationBar.h"
#import "DataToolManager.h"
#import "LIHttpClient.h"
#import "FLImageModel.h"
#import "FXImageCollectionViewCell.h"
#import "FXMenuTableViewCell.h"

#define kSectionHeight 30
#define kCellHeight 40
#define kItemHeight  (SCREEN_WIDTH - 140)/3

@interface XPFLViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) XPNavigationBar *navBar;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
/**
 *  左边的菜单栏
 */
@property (nonatomic, strong) UITableView *tableView;
/**
 *  右边瀑布流
 */
@property (nonatomic, strong) UICollectionView *collectionView;
/**
 *  左边菜单栏数据
 */
@property (nonatomic, strong) NSMutableArray *titleNames;
/**
 *  右边瀑布流数据
 */
@property (nonatomic, strong) NSMutableDictionary *imagesDictionary;

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, assign) NSInteger tableRow;
@property (nonatomic, assign) NSInteger collectionRow;
@property (nonatomic, assign) NSInteger minRow;
@end

@implementation XPFLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化本界面数据
    [self initWithData];
    // 初始化UI
    [self initWithUI];
}

-(void)initWithData{
    self.titleNames = [NSMutableArray array];
    self.imagesDictionary = [NSMutableDictionary dictionary];
    self.selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    self.tableRow = 1;
    self.collectionRow = 1;
    
    [self requestData];
}

-(void)initWithUI{
    [self.view addSubview:self.navBar];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.contentView];
    [self.contentView addSubview:self.tableView];
    [self.contentView addSubview:self.collectionView];
    
    [self layoutPageSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 请求数据
-(void)requestData{
    [[LIHttpClient shareManager] sendRequest:[[DataToolManager shareManager] FL_IMAGES_TITLES_URL] completionHandler:^(NSInteger errorNo, NSDictionary *dict) {
        if (errorNo == 0) {
            NSArray *array = dict[@"data"][@"categories"];
            for (NSDictionary *dic in array) {
                [self.titleNames addObject:dic[@"name"]];
                
                NSArray *array2 = dic[@"subcategories"];
                NSMutableArray *array1 = [NSMutableArray array];
                for (NSDictionary *dic1 in array2) {
                    FLImageModel *model = [[FLImageModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic1];
                    [array1 addObject:model];
                }
                [self.imagesDictionary setValue:array1 forKey:dic[@"name"]];
            }
            
            //注册重用sectionHeader
            for (NSString *string in self.titleNames) {
                [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:string];
            }
            
            [self.tableView reloadData];
            [self.collectionView reloadData];
        }
    }];
}

//计算总高度
-(NSMutableArray *)calculateTotalHeight{
    NSInteger totalHeight = 0;
    NSMutableArray *everySectionHeights = [NSMutableArray array];
    for (NSInteger i = 0; i < [self.titleNames count]; i++) {
        NSInteger count = [[self.imagesDictionary objectForKey:self.titleNames[i]] count];
        NSInteger row = ceil(count/3);
        NSInteger height = kSectionHeight + row *(kItemHeight+10);//10是行间距和sectionInset
        totalHeight += height;
        [everySectionHeights addObject:[NSNumber numberWithInteger:totalHeight]];
    }
    return everySectionHeights;
}

//返回第几个section
-(NSInteger)autoCalculateHeight:(NSInteger)offsetY{
    NSMutableArray *EverySectionHeights = [self calculateTotalHeight];
    for (NSInteger row = 0; row < [EverySectionHeights count]; row ++) {
        if (offsetY > [EverySectionHeights[row] integerValue] && row > 0) {
            return  row + 1;
        }
    }
    return 0;
}

#pragma mark -UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleNames.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    FXMenuTableViewCell* cell = (FXMenuTableViewCell*)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FXMenuTableViewCell class])];
    if (cell==nil) {
        cell=[[FXMenuTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:NSStringFromClass([FXMenuTableViewCell class])];
    }
    
    [cell configureData:self.titleNames[indexPath.row] normalIndexPath:indexPath selectedIndexPath:self.selectedIndexPath];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;

}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedIndexPath = indexPath;
    [self.tableView reloadData];
    
    self.tableRow = indexPath.row;
    NSIndexPath* dex=[NSIndexPath indexPathForRow:0 inSection:indexPath.row];
    [self.collectionView scrollToItemAtIndexPath:dex atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
    
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

#pragma mark -UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [[self.imagesDictionary objectForKey:self.titleNames[section]] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FXImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FXImageCollectionViewCell class]) forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[FXImageCollectionViewCell alloc] initWithFrame:CGRectZero];
    }
    FLImageModel *model = [self.imagesDictionary objectForKey:self.titleNames[indexPath.section]][indexPath.item];
    [cell configureData:model];
    return cell;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.titleNames.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView*header=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:self.titleNames[indexPath.section] forIndexPath:indexPath];
    
    UILabel *label = [header viewWithTag:100];
    if (label == nil) {
        label = [[UILabel alloc] init];
        label.text = [NSString stringWithFormat:@"— %@ —",self.titleNames[indexPath.section]];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [LISkinCss fontSize11];
        label.textColor = [LISkinCss colorRGB3b3f4a];
        [header addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.mas_equalTo(header);
            make.top.mas_equalTo(header).offset(10);
        }];
    }
    return header;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(kItemHeight,kItemHeight);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(0,kSectionHeight);
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *array = [self.collectionView indexPathsForVisibleItems];
    if ([array count] > 0) {
//        if (_tableRow != _collectionRow) {
//            self.selectedIndexPath = [NSIndexPath indexPathForRow:_tableRow inSection:0];
//            FXMenuTableViewCell*cell=(FXMenuTableViewCell*)[self.tableView cellForRowAtIndexPath:self.selectedIndexPath];
//            [cell configureData:self.titleNames[self.selectedIndexPath.row] normalIndexPath:self.selectedIndexPath selectedIndexPath:self.selectedIndexPath];
//            
//            NSIndexPath* normalIndexPath1=[NSIndexPath indexPathForRow:_minRow inSection:0];
//            FXMenuTableViewCell*cell1=(FXMenuTableViewCell*)[self.tableView cellForRowAtIndexPath:normalIndexPath1];
//            [cell1 configureData:self.titleNames[normalIndexPath1.row] normalIndexPath:normalIndexPath1 selectedIndexPath:self.selectedIndexPath];
//            
//            NSIndexPath* normalIndexPath2=[NSIndexPath indexPathForRow:_collectionRow inSection:0];
//            FXMenuTableViewCell*cell2=(FXMenuTableViewCell*)[self.tableView cellForRowAtIndexPath:normalIndexPath2];
//            [cell2 configureData:self.titleNames[normalIndexPath2.row] normalIndexPath:normalIndexPath2 selectedIndexPath:self.selectedIndexPath];
//            
//            [self.tableView scrollToRowAtIndexPath:self.selectedIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
//            _minRow = _collectionRow;
//            
//        }else{
//            NSIndexPath *path = array[0];
//            self.selectedIndexPath = [NSIndexPath indexPathForRow:path.section inSection:0];
//            FXMenuTableViewCell*cell=(FXMenuTableViewCell*)[self.tableView cellForRowAtIndexPath:self.selectedIndexPath];
//            [cell configureData:self.titleNames[self.selectedIndexPath.row] normalIndexPath:self.selectedIndexPath selectedIndexPath:self.selectedIndexPath];
//            
//            NSIndexPath* normalIndexPath1=[NSIndexPath indexPathForRow:_minRow inSection:0];
//            FXMenuTableViewCell*cell1=(FXMenuTableViewCell*)[self.tableView cellForRowAtIndexPath:normalIndexPath1];
//            [cell1 configureData:self.titleNames[normalIndexPath1.row] normalIndexPath:normalIndexPath1 selectedIndexPath:self.selectedIndexPath];
//            
//            NSIndexPath* normalIndexPath2=[NSIndexPath indexPathForRow:_collectionRow inSection:0];
//            FXMenuTableViewCell*cell2=(FXMenuTableViewCell*)[self.tableView cellForRowAtIndexPath:normalIndexPath2];
//            [cell2 configureData:self.titleNames[normalIndexPath2.row] normalIndexPath:normalIndexPath2 selectedIndexPath:self.selectedIndexPath];
//            
//            [self.tableView scrollToRowAtIndexPath:self.selectedIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
//            _minRow = path.section;
//        }
        
//        NSIndexPath *path = array[0];
//        self.selectedIndexPath = [NSIndexPath indexPathForRow:path.section inSection:0];
//        [self.tableView reloadData];
//        [self.tableView scrollToRowAtIndexPath:self.selectedIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    
    
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    //在didEndDisplayingCell 执行完之后在执行;
    _collectionRow = _tableRow;
    
}

#pragma mark - UIScrollViewDelegate
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    if ([scrollView isKindOfClass:[UICollectionView class]]) {
//
//    }
//}





#pragma mark -layoutPageSubviews
- (void)layoutPageSubviews {
    @WeakObj(self);
    
    [self.navBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(selfWeak.view);
        make.height.mas_equalTo(64);
    }];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(selfWeak.navBar.mas_bottom);
        make.left.bottom.and.right.equalTo(selfWeak.view);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(selfWeak.scrollView);
        make.width.equalTo(selfWeak.scrollView);
    }];
    
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(selfWeak.contentView);
        make.height.mas_equalTo(SCREEN_HEIGHT-64-44);
        make.width.mas_equalTo(100);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(selfWeak.contentView);
        make.height.mas_equalTo(selfWeak.tableView.mas_height);
        make.left.mas_equalTo(selfWeak.tableView.mas_right);
    }];
    
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(selfWeak.collectionView.mas_bottom);
    }];
}

#pragma mark - setter and getter

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.scrollEnabled = NO;
    }
    
    return _scrollView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor clearColor];
    }
    
    return _contentView;
}

-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView  = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[FXMenuTableViewCell class] forCellReuseIdentifier:NSStringFromClass([FXMenuTableViewCell class])];
        _tableView.showsVerticalScrollIndicator = NO;
        
    }
    return _tableView;
}

-(UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 10;
        layout.minimumLineSpacing = 10;
        layout.sectionInset =UIEdgeInsetsMake(0, 10, 10, 10);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[FXImageCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([FXImageCollectionViewCell class])];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsVerticalScrollIndicator = NO;
    }
    return _collectionView;
}

-(XPNavigationBar *)navBar{
    if (_navBar == nil) {
        _navBar = [[XPNavigationBar alloc] initWithTarget:self];
        _navBar.title = @"分类";
    }
    return _navBar;
}

@end
