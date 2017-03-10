//
//  MoreBrands.m
//  eshop
//
//  Created by gs_sh on 17/2/13.
//  Copyright © 2017年 hzlg. All rights reserved.
//

#import "MoreBrands.h"

#import "DetailBrandsVC.h"
#import "BrandService.h"
#import "MoreBrandsCatalistResponse.h"
#import "AppBrandCata.h"
#import "BrandIconCollectionViewCell.h"
#import "ProductInfoViewController.h"

#import "SCNavTabBar.h"
#import "CommonMacro.h"


@interface MoreBrands ()<SCNavTabBarDelegate, UIScrollViewDelegate, ServiceResponselDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
{
    NSArray * iconRoots;
    NSArray * cataRoots;
    BrandService *brandService;
    SCNavTabBar     *_navTabBar;
    
    UIButton *allBtn;  // 插入全部按钮
    UIView *line;      // 底部条
    BOOL _isAdd;       // 是否已插入
}

@property (strong, nonatomic) UICollectionView *collectionRootList;
@property (strong, nonatomic) UIView *contentView;

@end

@implementation MoreBrands


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [super addNavBackButton];
    
    [super addThreedotButton];
    
    [self initView];
    
    [self addCollectionView];
}

-(void)initView{
    // @"品牌推荐"
    NSString *moreBrands_navItem_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"moreBrands_navItem_title"];
    self.navigationItem.title = moreBrands_navItem_title;
    
    self.view.backgroundColor = groupTableViewBackgroundColorSelf;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    brandService = [[BrandService alloc] initWithDelegate:self parentView:self.view];
    [brandService getMoreBrandsCatalist];
    
    self.view.backgroundColor = groupTableViewBackgroundColorSelf;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
}

- (void)addCollectionView {
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    flowLayout.minimumLineSpacing = 0.5;
    flowLayout.minimumInteritemSpacing = 0.5;
    
    self.collectionRootList = [[UICollectionView alloc] initWithFrame:CGRectMake(0, NAV_TAB_BAR_HEIGHT, kWidth, kHeight -64 -NAV_TAB_BAR_HEIGHT) collectionViewLayout:flowLayout];
    self.collectionRootList.backgroundColor = groupTableViewBackgroundColorSelf;
    self.collectionRootList.showsVerticalScrollIndicator = NO;
    [self.collectionRootList registerNib:[UINib nibWithNibName:@"BrandIconCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"BrandIconCollectionViewCell"];
    self.collectionRootList.contentInset = UIEdgeInsetsMake(kHeight *8/568, 0, 0, 0);
    self.collectionRootList.delegate = self;
    self.collectionRootList.dataSource = self;
    [self.view addSubview:self.collectionRootList];
}

- (void) loadResponse:(NSString *)url response:(BaseModel *)response{
    
    
    if ([url isEqualToString:api_more_brandsCatalist]){
        
        MoreBrandsCatalistResponse *resobj = (MoreBrandsCatalistResponse *)response;
        
        // 插入全部分类
        AppBrandCata *model = [[AppBrandCata alloc] init];
        model.id = 0;
        model.name = @"全部";
        [resobj.data insertObject:model atIndex:0];
        
        cataRoots = resobj.data;
        NSMutableArray *titles = [NSMutableArray arrayWithCapacity:cataRoots.count];
        for (AppBrandCata *appBrandcata in resobj.data) {
            
            [titles addObject:appBrandcata.name];
        }
        
        if (!_navTabBar && titles.count) {
            
            _navTabBar = [[SCNavTabBar alloc] initWithFrame:CGRectMake(DOT_COORDINATE, DOT_COORDINATE, SCREEN_WIDTH, NAV_TAB_BAR_HEIGHT) canPopAllItemMenu:NO];
            _navTabBar.delegate = self;
            _navTabBar.backgroundColor = [UIColor whiteColor];
            _navTabBar.lineColor = redColorSelf;
            _navTabBar.itemTitles = titles;
            //        _navTabBar.arrowImage = [UIImage imageNamed:@"index_arrdown.png"];
            _navTabBar.titleFont = [UIFont systemFontWithSize:12.0];
            _navTabBar.currentItemIndex = 0;
            [_navTabBar.delegate itemDidSelectedWithIndex:0];
            [_navTabBar updateData];
            _navTabBar.navgationTabBar.delegate = self;
            _navTabBar.hasAllBtn = YES;
            [self.view addSubview:_navTabBar];
            
            allBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
            allBtn.frame = CGRectMake(0, 0, 52, NAV_TAB_BAR_HEIGHT);
            [allBtn setTitle:@"全部" forState:(UIControlStateNormal)];
            [allBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
            allBtn.titleLabel.font = [UIFont systemFontWithSize:12.0];
            allBtn.backgroundColor = [UIColor whiteColor];
            [allBtn addTarget:self action:@selector(clickAllBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
            allBtn.layer.shadowColor = [UIColor darkGrayColor].CGColor;//shadowColor阴影颜色
            allBtn.layer.shadowOffset = CGSizeMake(0, -3);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
            allBtn.layer.shadowOpacity = 0.8;//阴影透明度，默认0
            allBtn.layer.shadowRadius = 3;//阴影半径，默认3
            _isAdd = YES;
            
            line = [[UIView alloc] initWithFrame:CGRectMake(10.0f, NAV_TAB_BAR_HEIGHT - 3.0f, 52 - 20.0f, 3.0f)];
            line.backgroundColor = redColorSelf;
            [allBtn addSubview:line];
        }
    }
    if ([url isEqualToString:api_more_brandDetail]){
        
        MoreBrandsResponse * respobj = (MoreBrandsResponse *)response;
        iconRoots = respobj.data;
        
        [self.collectionRootList reloadData];
    }
}

#pragma collectionView的处理

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return  iconRoots.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BrandIconCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BrandIconCollectionViewCell" forIndexPath:indexPath];
    
    AppBrand *brand =[iconRoots objectAtIndex:[indexPath row]];
    cell.logoUrl = brand.logo;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    AppBrand *brand =[iconRoots objectAtIndex:[indexPath row]];
    NSLog(@"\nindexPath:%@ - %@ - %d\n", indexPath, brand.name, brand.id);
    DetailBrandsVC * detailBrandsVC = [[DetailBrandsVC alloc] init];
    detailBrandsVC.titleName = brand.name;
    detailBrandsVC.brandId = brand.id;
    
    detailBrandsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailBrandsVC animated:YES];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(kWidth/3-0.5, kHeight * 50/568);
}

- (void)clickAllBtnAction:(UIButton *)sender {
    
    [_navTabBar.delegate itemDidSelectedWithIndex:0];
}


#pragma mark - SCNavTabBarDelegate Methods

- (void)itemDidSelectedWithIndex:(NSInteger)index
{
    AppBrandCata *model = cataRoots[index];
    [brandService getBrandDetailById:model.id];
    _navTabBar.currentItemIndex = index;
    
    [self changeAllBtnStatue];
}

- (void)shouldPopNavgationItemMenu:(BOOL)pop height:(CGFloat)height
{
    if (pop)
    {
        [UIView animateWithDuration:0.5f animations:^{
            _navTabBar.frame = CGRectMake(_navTabBar.frame.origin.x, _navTabBar.frame.origin.y, _navTabBar.frame.size.width, kHeight - 64);
        }];
    }
    else
    {
        [UIView animateWithDuration:0.5f animations:^{
            _navTabBar.frame = CGRectMake(_navTabBar.frame.origin.x, _navTabBar.frame.origin.y, _navTabBar.frame.size.width, NAV_TAB_BAR_HEIGHT);
        }];
    }
    [_navTabBar refresh];
}

#pragma mark - UIScrollViewDelegate Methods
#pragma mark -

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _navTabBar.navgationTabBar) {
        
        CGFloat xset = 0;
        if (_navTabBar.itemsWidth.count) {
            
            xset = [_navTabBar.itemsWidth[0] floatValue];
        }
        if (scrollView.contentOffset.x > 0 && _isAdd) {
            _isAdd = NO;
            allBtn.frame = CGRectMake(0, 0, xset, NAV_TAB_BAR_HEIGHT);
            line.frame = CGRectMake(10.0f, NAV_TAB_BAR_HEIGHT - 3.0f, xset - 20.0f, 3.0f);
            [_navTabBar addSubview:allBtn];
        }
        if ((scrollView.contentOffset.x < 0.1 && !_isAdd)) {
            _isAdd = YES;
            [allBtn removeFromSuperview];
        }
        [self changeAllBtnStatue];
    }
}

- (void)changeAllBtnStatue {
    
    if (_navTabBar.currentItemIndex == 0) {
        
        [allBtn setTitleColor:redColorSelf forState:(UIControlStateNormal)];
        line.hidden = NO;
    } else {
        [allBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        line.hidden = YES;
    }
}


@end
