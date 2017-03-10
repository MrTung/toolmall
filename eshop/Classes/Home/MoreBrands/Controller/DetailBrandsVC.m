//
//  DetailBrandsVC.m
//  eshop
//
//  Created by gs_sh on 17/2/13.
//  Copyright © 2017年 hzlg. All rights reserved.
//

#import "DetailBrandsVC.h"

#import "ProductInfoViewController.h"
#import "BrandService.h"
#import "DetailBrandsHeaderView.h"
#import "BrandGoodsCollectionViewCell.h"
#import "AppBrandCata.h"

#import "HWPopTool.h"
#import "SHCollectionViewFlowLayout.h"

#import "SCNavTabBar.h"
#import "CommonMacro.h"

@interface DetailBrandsVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate, MsgHandler, SCNavTabBarDelegate, ServiceResponselDelegate>
{
    BrandService *brandService;
    CartService *cartService;
    NSArray * roots;
    AppBrand *appBrand;
    NSMutableArray * productsArr;
    Pagination * pagination;
    
    DetailBrandsHeaderView *headerView;
    UIScrollView *backScrollView;
    SCNavTabBar     *_navTabBar;
    UIView *collectionBacView;
    AppBrandCata *appBrandcata;
}
@property (strong, nonatomic) UICollectionView *collectionRootList;
@property (strong, nonatomic) UIView *contentView;

@end

@implementation DetailBrandsVC


- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationItem.title = self.titleName;
    [super addNavBackButton];
    [super addThreedotButton];
    
    self.view.backgroundColor = groupTableViewBackgroundColorSelf;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    productsArr = [NSMutableArray array];
    [self viewConfig];
    
    cartService = [[CartService alloc] initWithDelegate:self parentView:self.view];
    brandService = [[BrandService alloc] initWithDelegate:self parentView:self.view];
    [brandService getBrandDetailCatalistById:self.brandId];
    
    pagination = [[Pagination alloc] init];
    pagination.count = 20;
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth *250/320, kHeight *350/568)];
    _contentView.backgroundColor = [UIColor whiteColor];
    _contentView.layer.masksToBounds = YES;
    _contentView.layer.cornerRadius = kWidth *5/320;
    
    if (refreshHeaderView == nil) {
        
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 09.0f - self.collectionRootList.bounds.size.height, kWidth, self.collectionRootList.bounds.size.height)];
        view.delegate = self;
        [self.collectionRootList addSubview:view];
        refreshHeaderView = view;
    }
}

- (void)viewConfig {
    
    backScrollView = [[UIScrollView alloc] initWithFrame:(CGRectMake(0, 0, kWidth, kHeight-64))];
    backScrollView.bounces = NO;
    backScrollView.contentSize = CGSizeMake(kWidth, kHeight + kHeight *125/667 - 64);
    backScrollView.delegate = self;
    backScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:backScrollView];
    
    headerView = [[[NSBundle mainBundle] loadNibNamed:@"DetailBrandsHeaderView" owner:self options:nil] lastObject];
    headerView.frame = CGRectMake(0, 0, kWidth, kHeight *125/667);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickHeaderView:)];
    [headerView addGestureRecognizer:tap];
    [backScrollView addSubview:headerView];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    flowLayout.minimumLineSpacing = 0.5;
    flowLayout.minimumInteritemSpacing = 0.5;
//    flowLayout.naviHeight = 0;
    //    flowLayout.headerReferenceSize = CGSizeMake(WScreenWidth, 50);
    
    
    self.collectionRootList = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kHeight *125/667 + 44, kWidth, kHeight - 44 - 64) collectionViewLayout:flowLayout];
    //    self.collectionRootList = [[UICollectionView alloc] init];
    self.collectionRootList.backgroundColor = groupTableViewBackgroundColorSelf;
    self.collectionRootList.showsVerticalScrollIndicator = NO;
    [self.collectionRootList registerNib:[UINib nibWithNibName:@"BrandGoodsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"BrandGoodsCollectionViewCell"];
    [self.collectionRootList registerNib:[UINib nibWithNibName:@"DetailBrandsHeaderCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"DetailBrandsHeaderCollectionViewCell"];
    
    self.collectionRootList.contentInset = UIEdgeInsetsMake(0, 0, kWidth * 15/750, 0);
    self.collectionRootList.delegate = self;
    self.collectionRootList.dataSource = self;
    self.collectionRootList.scrollEnabled = NO;
    self.collectionRootList.alwaysBounceVertical = YES;
//    [self configureCollectionViewHeaderView];
    [backScrollView addSubview:self.collectionRootList];
}


- (void)loadResponse:(NSString *)url response:(BaseModel *)response{
    
    
    if ([url isEqualToString:api_more_brandsecondCatatList]){
        
        BrandsDetailCatalistResponse * respobj = (BrandsDetailCatalistResponse *)response;
        roots = respobj.appProductCategories;
        appBrand = respobj.appBrand;
        
        headerView.appBrand = appBrand;
        
        NSMutableArray *titles = [NSMutableArray arrayWithCapacity:roots.count];
        for (AppBrandCata *brandcata in roots) {
            
            [titles addObject:brandcata.name];
        }
        if (!_navTabBar && titles.count) {
            
            _navTabBar = [[SCNavTabBar alloc] initWithFrame:CGRectMake(DOT_COORDINATE, kHeight *125/667, SCREEN_WIDTH, NAV_TAB_BAR_HEIGHT) canPopAllItemMenu:YES];
            _navTabBar.delegate = self;
            _navTabBar.backgroundColor = [UIColor whiteColor];
            _navTabBar.lineColor = redColorSelf;
            _navTabBar.itemTitles = titles;
            _navTabBar.arrowImage = [UIImage imageNamed:@"arrowDown.png"];
            _navTabBar.titleFont = [UIFont systemFontWithSize:12.0];
            //        _navTabBar.currentItemIndex = 0;
            [_navTabBar.delegate itemDidSelectedWithIndex:0];
            [_navTabBar updateData];
            [backScrollView addSubview:_navTabBar];
            
        }

//        [self.collectionRootList reloadData];
    }
    if ([url isEqualToString:api_more_brandsecondCatatProductList]) {
        
        BrandsDetailProductsResponse *respobj = (BrandsDetailProductsResponse *)response;
        [productsArr addObjectsFromArray:respobj.data];
        if (respobj.paginated.more > 0){
            _hasMoreData = YES;
        } else {
            _hasMoreData = NO;
        }
       
        [self.collectionRootList reloadData];
        
        // 停止刷新<隐藏刷新header视图>
        [self doneLoadingTableViewData];
    }
    if ([url isEqual:api_cart_item_add]){
        // @"已加入购物车"
        NSString *prodList_toastNotification_msg1 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"prodList_toastNotification_msg1"];
        [CommonUtils ToastNotification:prodList_toastNotification_msg1 andView:self.view andLoading:NO andIsBottom:YES];
    }
}

#pragma collectionView的处理

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return  productsArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BrandGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BrandGoodsCollectionViewCell" forIndexPath:indexPath];
    
    if (productsArr.count) {
        
        AppProduct *product = productsArr[indexPath.row];
        cell.product = product;
        cell.msgHandler = self;
        cell.productId = product.id;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == (productsArr.count -1)) {
        if (_hasMoreData) {
            [self loadData:NO];
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    AppProduct *product = productsArr[indexPath.row];
    NSLog(@"\n %@ - %d \n", product.name, product.id);
    
    //点击商品
    ProductInfoViewController * prodInfo = [[ProductInfoViewController alloc]init];
    prodInfo.productId = product.id;
    
    [self.navigationController pushViewController:prodInfo animated:YES];
}

- (void)clickHeaderView:(UITapGestureRecognizer *)tap {
    [self popViewShowBrand:appBrand];
}

- (void)popViewShowBrand:(AppBrand *)brand {
    
    [_contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];;
    
    CGFloat popViewMargin = kHeight *15/568;
    
    EGOImageView *imageV = [[EGOImageView alloc]initWithFrame:CGRectMake(popViewMargin, popViewMargin, kWidth *85/320, kHeight *50/568)];
    imageV.placeholderImage = [UIImage imageNamed:@"defaultImg_small.png"];
    imageV.imageURL = [URLUtils createURL:brand.logo];
    [_contentView addSubview:imageV];
    [CommonUtils decrateImageGaryBorder:imageV];
    
    UILabel *nameLab = [[UILabel alloc] initWithFrame:(CGRectMake(CGRectGetMaxX(imageV.frame) + popViewMargin, popViewMargin, popViewMargin *2, popViewMargin))];
    nameLab.textAlignment = NSTextAlignmentLeft;
    nameLab.font = [UIFont systemFontWithSize:14.0];
    nameLab.text = brand.name;
    [nameLab sizeToFit];
    [_contentView addSubview:nameLab];
    
    UIButton *closeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    closeBtn.frame = CGRectMake(_contentView.frame.size.width-popViewMargin*2.2, popViewMargin*0.5, popViewMargin*1.7, popViewMargin*1.7);
    [closeBtn setImage:[UIImage imageNamed:@"share_close.png"] forState:(UIControlStateNormal)];
    [closeBtn addTarget:self action:@selector(closeBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [_contentView addSubview:closeBtn];
    
    UILabel *lineLab = [[UILabel alloc] initWithFrame:(CGRectMake(0, CGRectGetMaxY(imageV.frame) + popViewMargin, _contentView.frame.size.width, 0.5))];
    lineLab.backgroundColor = groupTableViewBackgroundColorSelf;
    [_contentView addSubview:lineLab];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:(CGRectMake(popViewMargin, CGRectGetMaxY(lineLab.frame) + popViewMargin, _contentView.frame.size.width - popViewMargin*2, _contentView.frame.size.height - CGRectGetMaxY(lineLab.frame)-popViewMargin *2))];
//    scrollView.alwaysBounceHorizontal = NO;
    
    UILabel *textView = [[UILabel alloc] initWithFrame:(CGRectMake(0, 0, scrollView.frame.size.width, scrollView.frame.size.height))];
//    textView.text = brand.brief;
    textView.numberOfLines = 0;
    textView.font = [UIFont systemFontWithSize:12.0];
    textView.attributedText = [CommonUtils getAttributedString:brand.brief font:textView.font lineSpacing:(kHeight *3/568)];

    [textView sizeToFit];
    textView.textColor = [UIColor darkGrayColor];
    
    CGSize size = textView.frame.size;
    size.width = textView.frame.size.width - 1;
    scrollView.contentSize = size;
    [scrollView addSubview:textView];
    
    [_contentView addSubview:scrollView];
    
    [HWPopTool sharedInstance].shadeBackgroundType = ShadeBackgroundTypeGradient;
    [HWPopTool sharedInstance].closeButtonType = ButtonPositionTypeNone;
    [[HWPopTool sharedInstance] showWithPresentView:_contentView animated:YES];
}

- (void)closeBtnAction:(UIButton *)sender {

    [[HWPopTool sharedInstance] closeWithBlcok:nil];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake((kWidth - kWidth * 15/750)/2, kHeight * 260/667);
}

- (void)sendMessageBtnTag:(NSInteger)tag {
    
    if (roots.count > tag) {
        
        [productsArr removeAllObjects];
        
        appBrandcata = roots[tag];
        
        pagination.count = 20;
        pagination.page = 1;
//        NSLog(@"\n appBrandcata: %@ - %d \n", appBrandcata.name, appBrandcata.id);
        [brandService getBrandDetailCatalistById:self.brandId cataId:appBrandcata.id pagination:pagination];
    }
}

- (void)loadData:(BOOL)refresh {
    
    if (refresh) {
        
        pagination.count = 20;
        pagination.page = 1;
        [productsArr removeAllObjects];
    }
    else {

        pagination.page = pagination.page + 1;
    }
    
    NSLog(@"\n appBrandcata: %@ - %d \n", appBrandcata.name, appBrandcata.id);
    [brandService getBrandDetailCatalistById:self.brandId cataId:appBrandcata.id pagination:pagination];
}

- (void)sendMessage:(Message *)msg{
    if (msg.what == 1){
        //add product to cart
        [cartService addCartItem:msg.int1 quantity:1];
    }
}


#pragma mark - SCNavTabBarDelegate Methods
#pragma mark -
- (void)itemDidSelectedWithIndex:(NSInteger)index
{
    
    [self.collectionRootList setContentOffset:CGPointMake(0, 0) animated:NO];
    [self sendMessageBtnTag:index];
    _navTabBar.currentItemIndex = index;
}

- (void)shouldPopNavgationItemMenu:(BOOL)pop height:(CGFloat)height
{
    if (pop)
    {
//        [UIView animateWithDuration:0.5f animations:^{
            _navTabBar.frame = CGRectMake(_navTabBar.frame.origin.x, _navTabBar.frame.origin.y, _navTabBar.frame.size.width, kHeight - 64);
//            _navTabBar.frame = CGRectMake(_navTabBar.frame.origin.x, _navTabBar.frame.origin.y, _navTabBar.frame.size.width, height);
//        }];
    }
    else
    {
//        [UIView animateWithDuration:0.5f animations:^{
            _navTabBar.frame = CGRectMake(_navTabBar.frame.origin.x, _navTabBar.frame.origin.y, _navTabBar.frame.size.width, NAV_TAB_BAR_HEIGHT);
//        }];
    }
    [_navTabBar refresh];
}


#pragma mark - UIScrollViewDelegate Methods
#pragma mark -

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//
    if (scrollView == backScrollView && scrollView.contentOffset.y) {
        
//        NSLog(@"\n contentOffset: %f -> %f \n" , scrollView.contentOffset.y, kHeight *125/667);
        if (scrollView.contentOffset.y > kHeight *125/667-0.5) {
            
            self.collectionRootList.scrollEnabled = YES;
//            backScrollView.scrollEnabled = NO;
        }
        else {
            
            self.collectionRootList.scrollEnabled = NO;
            
            if (productsArr.count < 5) {
                
                self.collectionRootList.alwaysBounceVertical = YES;
                self.collectionRootList.bounces = YES;
            }
//            backScrollView.scrollEnabled = YES;
        }
    }
    
    [refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}


#pragma mark -
#pragma mark Data Source Loading / Reloading Methods
//更新列表数据
- (void)reloadTableViewDataSource{
    
    [self loadData:YES];
    reloading = YES;
}

- (void)loadMoreTableViewDataSource {

    [self loadData:NO];
    reloading = YES;
}

- (void)doneLoadingTableViewData{
    
    //model should call this when its done loading
    reloading = NO;
    [refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.collectionRootList];
}

#pragma mark -
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
#pragma mark - LoadMoreTableViewDelegate


- (void)loadMoreTableFooterDidTriggerLoadMore:(LoadMoreTableFooterView *)view
{
    [self performSelector:@selector(loadMoreTableViewDataSource) withObject:nil afterDelay:0.2];
}

@end
