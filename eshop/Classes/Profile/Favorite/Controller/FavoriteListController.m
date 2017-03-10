//
//  FavoriteListController.m
//  eshop
//
//  Created by mc on 15-11-3.
//  Copyright (c) 2015年 hzlg. All rights reserved.
//

#import "FavoriteListController.h"

#import "ProductInfoViewController.h"

@interface FavoriteListController ()

@end

@implementation FavoriteListController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed=YES;
    }
    return self;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [super addNavBackButton];
    [super addThreedotButton];
    
    // @"我的收藏"
    NSString *favoriteListController_navItem_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"favoriteListController_navItem_title"];
    [super addNavTitle:favoriteListController_navItem_title];
    
    cartService = [[CartService alloc] initWithDelegate:self parentView:self.view];
    favoriteService = [[FavoriteService alloc] initWithDelegate:self parentView:self.view];
    productService = [[ProductService alloc] initWithDelegate:self parentView:self.view];
    pagination = [[Pagination alloc] init];
    
    favorites = [[NSMutableArray alloc]initWithCapacity:20];
    self.navigationItem.hidesBackButton = NO;
    self.navigationController.navigationBarHidden = NO;
    
    _right = [[UIBarButtonItem alloc] initWithTitle:@"  " style:UIBarButtonItemStylePlain target:self action:@selector(clickEdit:)];
    [_right setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = _right;
    
    self.btnContainerHeightCons.constant = TMScreenH *40/568;
}

- (void)backButtonClick:(UIButton *)button{
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[ShopLoginViewController class]]) {
            [temp removeFromParentViewController];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}


- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData:YES];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:TMPop2IndexNotificationName object:nil];
}

- (IBAction)clickEdit:(UIBarButtonItem*)sender{
    
    // @"完成"
    NSString *favoriteListController_right_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"favoriteListController_right_title"];
    // @"编辑"
    NSString *favoriteListController_right2_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"favoriteListController_right2_title"];
    if ([mode isEqualToString:@"view"]){
        mode = @"edit";
        [_right setTitle:favoriteListController_right_title];
        self.tableBtmCons.constant = TMScreenH *40/568;
        //        sender.tag = 2;
        self.btnContainer.hidden = NO;
    } else {
        mode = @"view";
        [_right setTitle:favoriteListController_right2_title];
        self.tableBtmCons.constant = 0;
        //        sender.tag = 1;
        self.btnContainer.hidden = YES;
    }
    
    [self.tableList reloadData];
}

- (void) loadData:(BOOL)refresh
{
    if (refresh){
        pagination.page = 1;
        [favorites removeAllObjects];
    }
    [favoriteService getFavoriteList:pagination];
}

- (void)loadResponse:(NSString *) url response:(BaseModel *)response{
    self.right.enabled = YES;
    if ([url isEqualToString:api_cart_addmultiple]) {
        CartResponse * respobj = (CartResponse *)response;
        if (respobj.status.succeed == 1) {
            // @"成功加入购物车"
            NSString *favoriteListController_toastNotification_msg1 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"favoriteListController_toastNotification_msg1"];
            [CommonUtils ToastNotification:favoriteListController_toastNotification_msg1 andView:self.view andLoading:NO andIsBottom:YES];
            [self.tableList reloadData];
        }
    }
    
    if ([url isEqualToString:api_favorite_deleteFavorites]) {
        StatusResponse * respobj = (StatusResponse *)response;
        if (respobj.status.succeed == 1) {
            pagination.page = 1;
            [favorites removeAllObjects];
            [favoriteService getFavoriteList:pagination];
        }
    }
    if ([url isEqual:api_favorite_list]){
        //收藏列表
        FavoriteListResponse * respobj = (FavoriteListResponse *)response;
        [favorites addObjectsFromArray:respobj.data];
        //        NSLog(@"收藏列表信息：%@",favorites);
        if (favorites.count == 0){
            //创建热卖视图
            [self createFootPrintView];
            //当我的收藏数据没有值时，发起热卖推荐请求
            [productService getProductList:nil activityId:nil productCategoryId:nil promotionId:nil tagId:1 attributes:nil orderType:nil pagination:pagination couponId:nil];
            
            // @"您还没有收藏过商品"
            NSString *favoriteListController_noResultView_desc = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"favoriteListController_noResultView_desc"];
            CGRect rec = CGRectMake(0, CGRectGetMinY(self.tableList.frame) ,CGRectGetWidth(self.tableList.frame) , CGRectGetMinY(_viewFootprint.frame) - CGRectGetMinY(_tableList.frame));
            [CommonUtils displayCollectionNoResultView:self.view frame:rec desc:favoriteListController_noResultView_desc];
            NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
            [center addObserver:self selector:@selector(jumpToIndexPage) name:TMPop2IndexNotificationName object:nil];
            
            self.tableList.hidden = YES;
            self.btnContainer.hidden = YES;
            self.right.enabled = NO;
            self.right.title = @"  ";
            
        } else {
            
            // @"编辑"
            NSString *favoriteListController_right2_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"favoriteListController_right2_title"];
            [CommonUtils removeNoResultView:self.view];
            _viewFootprint.hidden = YES;
            self.tableList.hidden = NO;
            self.right.enabled = YES;
            self.right.title = favoriteListController_right2_title;
            self.tableBtmCons.constant = 0;
            self.btnContainer.hidden = YES;
            mode = @"view";
            [_tableList reloadData];
            if (respobj.paginated.more) {
                
                [self.tableList setHasLoadingMore:YES];
                [self.tableList setPullTableIsRefreshing:YES];
                //                self.tableList.pullTableIsLoadingMore = YES;
            }else{
                [self.tableList setHasLoadingMore:NO];
                [self.tableList setPullTableIsRefreshing:NO];
            }
        }
        
    } else if ([url isEqual:api_favorite_delete]){
        
        StatusResponse *respobj = (StatusResponse*)response;
        if (respobj.status.succeed == 1){
            [favorites removeObjectAtIndex:curDelRow];
            [self.tableList reloadData];
        }
        
    }else if([url isEqual:api_product_list]){
        
        ProductListResponse * respobj = (ProductListResponse *)response;
        _hotProducts = [[NSMutableArray alloc] initWithCapacity:0];
        [_hotProducts addObjectsFromArray:respobj.data];
        if (_hotProducts.count > 0) {
            
            [self createItemsOfProductViewHistory];
        }
    }
}

//跳转到首页
- (void)jumpToIndexPage{
    
    self.tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:NO];
}

#pragma mark - 创建足迹视图
- (void)createFootPrintView{
    
    _viewFootprint = [[UIView alloc] initWithFrame:CGRectMake(0, TMScreenH - TMScreenH *142/568-64, TMScreenW, TMScreenH *142/568)];
    _viewFootprint.backgroundColor = groupTableViewBackgroundColorSelf;
    [self.view addSubview:_viewFootprint];
    
    //足迹前面的图片
    UIView *topBacView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TMScreenW, TMScreenH *38/568)];
    topBacView.backgroundColor = [UIColor whiteColor];
    [_viewFootprint addSubview:topBacView];
    
    // @"热卖推荐"
    NSString *favoriteListController_viewFootprint_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"favoriteListController_viewFootprint_title"];
    // @"更多"
    NSString *favoriteListController_viewFootprint_more = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"favoriteListController_viewFootprint_more"];
    EGOImageView * image = [[EGOImageView alloc] initWithImage:[UIImage imageNamed:@"热卖推荐"]];
    image.frame = CGRectMake(TMScreenW *10/320, TMScreenH *8.5/568, TMScreenW *20/320, TMScreenW *20/320);
    [topBacView addSubview:image];
    UILabel * foot = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(image.frame)+TMScreenW *5/320, 0, TMScreenW *80/320, TMScreenH *37/568)];
    foot.text = favoriteListController_viewFootprint_title;
    foot.font = [UIFont systemFontWithSize:13];
    foot.textColor = [UIColor colorWithRed:46/255.0 green:46/255.0 blue:46/255.0 alpha:1];
    [topBacView addSubview:foot];
    UILabel * more = [[UILabel alloc] initWithFrame:CGRectMake(_viewFootprint.frame.size.width - TMScreenW *40/320, 0, TMScreenW *40/320, TMScreenH *37/568)];
    more.userInteractionEnabled = YES;
    more.text = favoriteListController_viewFootprint_more;
    more.font = [UIFont systemFontWithSize:12];
    more.textColor = [UIColor colorWithRed:84/255.0 green:84/255.0 blue:84/255.0 alpha:1];
    [topBacView addSubview:more];
    
    UIImageView * arr = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(more.frame)/2.0+TMScreenW *5/320, TMScreenH *11/568, TMScreenW *8/320, TMScreenH *15/568)];
    arr.image = [UIImage imageNamed:@"moreprod_right_arrow"];
    [more addSubview:arr];
    
    
    UIButton * btnMore = [UIButton buttonWithType:UIButtonTypeCustom];
    btnMore.frame = CGRectMake(0, 0, more.frame.size.width, more.frame.size.height);
    btnMore.backgroundColor = [UIColor clearColor];
    [btnMore addTarget:self action:@selector(clickOnMoreButton:) forControlEvents:UIControlEventTouchUpInside];
    [more addSubview:btnMore];
    
    _scrollFoot = [[UIScrollView alloc] initWithFrame:CGRectMake(0, TMScreenH *38/568, _viewFootprint.frame.size.width, TMScreenH *104/568)];
    _scrollFoot.showsHorizontalScrollIndicator = NO;
    _scrollFoot.showsVerticalScrollIndicator = NO;
    [_viewFootprint addSubview:_scrollFoot];
    
    UIView * viewLine1 = [[UIView alloc] initWithFrame:CGRectMake(0, TMScreenH *38/568 ,CGRectGetWidth(_viewFootprint.frame), 0.5)];
    viewLine1.backgroundColor = groupTableViewBackgroundColorSelf;
    [_viewFootprint addSubview:viewLine1];
}


- (void)clickOnMoreButton:(UIButton *)button{
    
    ProdList * prodList = [[ProdList alloc] initWithNibName:@"ProdList" bundle:nil];
    prodList.tagId = 1;
    [self.navigationController pushViewController:prodList animated:YES];
    
}

//创建每个item
- (void)createItemsOfProductViewHistory{
    
    for (int i =0; i<_hotProducts.count; i++) {
        
        FootViewItem * footItem = [[FootViewItem alloc] initWithFrame:CGRectMake(0 + i*(TMScreenW *85/320), TMScreenH *0/568, TMScreenW *85/320, TMScreenH *104/568) image:[_hotProducts[i] valueForKey:@"image"] title:[_hotProducts[i] valueForKey:@"name"] price:[_hotProducts[i] valueForKey:@"price"]];
        footItem.userInteractionEnabled = YES;
        _scrollFoot.userInteractionEnabled = YES;
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, footItem.frame.size.width, footItem.frame.size.height);
        button.tag = [[_hotProducts[i] valueForKey:@"id"] integerValue];
        [footItem addSubview:button];
        [button addTarget:self action:@selector(clickToDetailInfomation:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollFoot addSubview:footItem];
    }
    _scrollFoot.contentSize = CGSizeMake(_hotProducts.count*(TMScreenW *85/320), 0);
    
}


- (void)clickToDetailInfomation:(UIButton *)button{
    
    ProductInfoViewController * p = [[ProductInfoViewController alloc] initWithNibName:@"ProductInfoViewController" bundle:nil];
    p.productId = button.tag;
    p.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:p animated:YES];
}

- (void)sendMessage:(Message *)msg{
    if (msg.what == 1){
    }
}


//取消收藏
- (IBAction)delFavorite:(id)sender{
    
    //    NSLog(@"取消收藏");
    NSMutableArray *productIds = [self getSelectedProductIds];
    if (productIds.count > 0) {
        [favoriteService delFavorites:productIds];
    }
    else{
        // @"您当前还没有选择商品"
        NSString *favoriteListController_toastNotification_msg2 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"favoriteListController_toastNotification_msg2"];
        [CommonUtils ToastNotification:favoriteListController_toastNotification_msg2 andView:self.view andLoading:NO andIsBottom:YES];
    }
}

//加入购物车
- (IBAction)addCar:(id)sender{
    //    NSLog(@"加入购物车");
    NSMutableArray *productIds = [self getSelectedProductIds];
    if (productIds.count > 0) {
        [ cartService addCartItems:productIds quantities:nil];
    }
    else{
        // @"您当前还没有选择商品"
        NSString *favoriteListController_toastNotification_msg2 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"favoriteListController_toastNotification_msg2"];
        [CommonUtils ToastNotification:favoriteListController_toastNotification_msg2 andView:self.view andLoading:NO andIsBottom:YES];
    }
}

- (NSMutableArray*)getSelectedProductIds{
    NSMutableArray * array = [[NSMutableArray alloc] init];
    for (FavoriteList * f in favorites) {
        if (f.selected){
            [array addObject:[NSNumber numberWithInt:f.productId]];
        }
    }
    return array;
}


#pragma TableView的处理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(favorites.count == 0){
        self.right.title = @"  ";
        self.right.enabled = NO;
    }
    
    return favorites.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 115;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FavoriteListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FavoriteListCell"];
    if (!cell) {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"FavoriteListCell" owner:self options:nil];
        for (NSObject *o in objects) {
            if ([o isKindOfClass:[FavoriteListCell class]]) {
                cell = (FavoriteListCell *)o;
                [cell myinit];
                cell.msgHandler = self;
                break;
            }
        }
    }
    
    FavoriteList *favorite =[favorites objectAtIndex:indexPath.row];
    
    if ([mode isEqual:@"edit"]){
        //在编辑模式下
        cell.btn1.hidden = NO;
        cell.btn1.tag = indexPath.row;
        if (favorite.selected){
            [cell.btn1 setImage:[UIImage imageNamed:@"newchecktrue.png"] forState:UIControlStateNormal];
        } else {
            [cell.btn1 setImage:[UIImage imageNamed:@"newcheckfalse.png"] forState:UIControlStateNormal];
        }
        [cell.btn1 addTarget:self action:@selector(isSelected:) forControlEvents:UIControlEventTouchUpInside];
        cell.cons.constant = 25;
        
        
    } else {
        
        cell.btn1.hidden = YES;
        cell.control1.hidden = NO;
        cell.cons.constant = 0;
        cell.control1.tag = favorite.productId;
        [cell.btn1 removeTarget:self action:@selector(isSelected:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    cell.name1.text = favorite.name;
    cell.image1.imageURL = [URLUtils createURL:favorite.image];
    cell.lbPrice1.text = [CommonUtils formatCurrency:favorite.price];
    
    return cell;
}


- (void)isSelected:(UIButton *)button{
    
    FavoriteListCell *cell = (FavoriteListCell *)button.superview.superview;
    NSIndexPath *indexPath = [_tableList indexPathForCell:cell];
    
    FavoriteList * favorite = [favorites objectAtIndex:indexPath.row];
    
    //    favorite.productId = button.tag;
    
    if ([mode isEqualToString:@"edit"]){
        if (favorite.selected) {
            [button setImage:[UIImage imageNamed:@"newcheckfalse.png"] forState:UIControlStateNormal];
            favorite.selected = false;
        }else{
            [button setImage:[UIImage imageNamed:@"newchecktrue.png"] forState:UIControlStateNormal];
            favorite.selected = true;
        }
    }
}

#pragma mark - Refresh and load more methods

- (void)refreshTable
{
    /* Code to actually refresh goes here.  刷新代码放在这*/
    
    [self loadData:YES];
    self.tableList.pullLastRefreshDate = [NSDate date];
    
}

- (void) loadMoreDataToTable
{
    /* Code to actually load more data goes here.  加载更多实现代码放在在这 */
    pagination.page = pagination.page + 1;
    [self loadData:NO];
}

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    [self performSelector:@selector(refreshTable) withObject:nil afterDelay:3.0f];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    [self performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:3.0f];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FavoriteListCell *cell = (FavoriteListCell *)[tableView cellForRowAtIndexPath:indexPath];
    FavoriteList *favorite = [favorites objectAtIndex:indexPath.row];
    if ([mode isEqualToString:@"edit"]){
        if (favorite.selected) {
            [cell.btn1 setImage:[UIImage imageNamed:@"newcheckfalse.png"] forState:UIControlStateNormal];
            favorite.selected = false;
        }else{
            [cell.btn1 setImage:[UIImage imageNamed:@"newchecktrue.png"] forState:UIControlStateNormal];
            favorite.selected = true;
        }
    } else {
        ProductInfoViewController * prodInfo = [[ProductInfoViewController alloc]init];
        prodInfo.productId = favorite.productId;
        
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:nil];
        [self.navigationItem setBackBarButtonItem:backButton];
        
        [self.navigationController pushViewController:prodInfo animated:YES];
    }
}

@end
