//
//  CatRootListViewController.m
//  eshop
//
//  Created by mc on 16/3/12.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import "CatRootListViewController.h"

@interface CatRootListViewController ()

@property (nonatomic, retain) UIViewController *lastVC;

@end

@implementation CatRootListViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    [self configureCutLine];
    
    [super addThreedotButton];
    
    [self addCollectionView];
    
    [prodCatService getRoots_v2];
}

-(void)initView{
    // 全部分类
    NSString *catRoot_navItem_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"catRoot_navItem_title"];
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = catRoot_navItem_title;
    
    self.view.backgroundColor = groupTableViewBackgroundColorSelf;
    self.collectionRootList.backgroundColor = groupTableViewBackgroundColorSelf;
    self.collectionRootList.showsVerticalScrollIndicator = NO;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    prodCatService = [[ProductCategoryService alloc] initWithDelegate:self parentView:self.view];
    
    if (refreshHeaderView == nil) {
        
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.collectionRootList.bounds.size.height, self.collectionRootList.frame.size.width, self.collectionRootList.bounds.size.height)];
        view.delegate = self;
        //        [view setBackgroundColor:nil textColor:nil arrowImage:[UIImage new] logoImage:LOGO_IMAGE];
        [self.collectionRootList addSubview:view];
        refreshHeaderView = view;
    }
}

#pragma mark 刷新数据 edit by dxw 2017-03-07

-(void)refleshData{
    
    [prodCatService getRoots_v2];
}

- (void)addCollectionView {
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    flowLayout.minimumLineSpacing = 0.5;
    flowLayout.minimumInteritemSpacing = 0.5;
    //    flowLayout.headerReferenceSize = CGSizeMake(WScreenWidth, 50);
    
    self.collectionRootList = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, TMScreenW, TMScreenH-64-49) collectionViewLayout:flowLayout];
    //    self.collectionRootList = [[UICollectionView alloc] init];
    self.collectionRootList.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.collectionRootList registerNib:[UINib nibWithNibName:@"CatRootCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CatRootCollectionViewCell"];
    self.collectionRootList.delegate = self;
    self.collectionRootList.dataSource = self;
    
    [self.view addSubview:self.collectionRootList];
}

- (void)loadResponse:(NSString *) url response:(BaseModel *)response{
    if ([url isEqual:api_productcat_roots_v2]){
        ProductCategoryListResponse * respobj = (ProductCategoryListResponse *)response;
        roots = respobj.data;
        // 停止刷新<隐藏刷新header视图>
        [self doneLoadingTableViewData];
        
        [self.collectionRootList reloadData];
    }
}

#pragma collectionView的处理

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return roots.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CatRootCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CatRootCollectionViewCell" forIndexPath:indexPath];
    
    AppProductCategory *prodCategory =[roots objectAtIndex:[indexPath row]];
    [cell setProdCategory:prodCategory];
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    AppProductCategory *prodCategory = [roots objectAtIndex:indexPath.row];
    CatSecdListViewController * secdListController = [[CatSecdListViewController alloc] initWithNibName:@"CatSecdListViewController" bundle:nil];
    secdListController.prodCategoryId = prodCategory.id;
    secdListController.prodCategoryName = prodCategory.name;
    secdListController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:secdListController animated:YES];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(TMScreenW/2-0.25, TMScreenW/2);
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [YCXMenu dismissMenu];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if ([self.type isEqualToString:@"index"]) {
        self.tabBarController.tabBar.hidden = YES;
        [super addNavBackButton];
        self.collectionRootList.frame = CGRectMake(0, 0, TMScreenW, TMScreenH-64);
    }else {
        self.navigationItem.hidesBackButton = YES;
        self.tabBarController.tabBar.hidden = NO;
        self.collectionRootList.frame = CGRectMake(0, 0, TMScreenW, TMScreenH-64-49);
    }
}

- (void)configureCutLine {
    
    self.navigationController.navigationBar.translucent = NO;
    // 隐藏导航栏底部的分割线
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bgLight"]
                                                 forBarPosition:UIBarPositionAny
                                                     barMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"05线"]];
    
    [self.tabBarController.tabBar setShadowImage:[[UIImage alloc]init]];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:(CGRectMake(0, 0, kWidth, 1))];
    imgView.image = [UIImage imageNamed:@"05线"];
    [self.tabBarController.tabBar addSubview:imgView];
    [self.tabBarController.tabBar setBackgroundImage:[[UIImage alloc]init]];
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark Data Source Loading / Reloading Methods
//更新列表数据
- (void)reloadTableViewDataSource{
    
    [prodCatService getRoots_v2];
    reloading = YES;
}

- (void)doneLoadingTableViewData{
    
    reloading = NO;
    [refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.collectionRootList];
}

#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    
    [self performSelector:@selector(reloadTableViewDataSource) withObject:nil afterDelay:0.2];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    
    return reloading; // should return if data source model is reloading
    
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    
    return [NSDate date]; // should return date data source was last changed
    
}

- (void)viewDidUnload {
    refreshHeaderView=nil;
}

- (void)dealloc {
    
    refreshHeaderView = nil;
}

@end
