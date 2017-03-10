//
//  FootPrintViewController.m
//  eshop
//
//  Created by mc on 16/5/13.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import "FootPrintViewController.h"

@interface FootPrintViewController ()

@end

@implementation FootPrintViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [super addNavBackButton];
    [super addThreedotButton];
    
    // @"足迹"
    NSString *footPrintVC_navItem_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"footPrintVC_navItem_title"];
    [super addNavTitle:footPrintVC_navItem_title];
//
    self.view.backgroundColor = groupTableViewBackgroundColorSelf;
    self.tableList.backgroundColor = groupTableViewBackgroundColorSelf;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    productService = [[ProductService alloc] init];
    productService.delegate = self;
    productService.parentView = self.view;
    cartService = [[CartService alloc] initWithDelegate:self parentView:self.view];
    
    pagination = [[Pagination alloc] init];
    self.tableList.tableFooterView = nil;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.tableList setHasLoadingMore:NO];
    [self loadData:YES];
    
}

- (void) loadData:(BOOL)refresh
{
    if (refresh){
        pagination.page = 1;
        [appProducts removeAllObjects];
    }
    
    // 分页
    [productService productViewHistoryWithPagination:pagination];
}

- (void)loadResponse:(NSString *) url response:(BaseModel *)response{
    if ([url isEqual:api_member_productviewhist_page]){
    
        appProducts = [[NSMutableArray alloc] initWithCapacity:0];
        ProductViewHistoryResponse * respobj = (ProductViewHistoryResponse *)response;
        
        if (respobj.paginated.more > 0){
            [self.tableList setHasLoadingMore:YES];
//            NSLog(@"sssssss");
        } else {
            [self.tableList setHasLoadingMore:NO];
//            NSLog(@"dddddd");
        }
        if (respobj.status.succeed == 1) {
            [appProducts addObjectsFromArray:respobj.data];
            
            if (appProducts.count == 0){
//                [CommonUtils displayNoResultView:self.view frame:self.tableList.frame];
                // @"没有结果"
                NSString *footPrintVC_noResultView_desc = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"footPrintVC_noResultView_desc"];
                [CommonUtils displayCollectionNoResultView:self.view frame:self.tableList.frame desc:footPrintVC_noResultView_desc];
                NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
                [center addObserver:self selector:@selector(jumpToIndexPage) name:TMPop2IndexNotificationName object:nil];
                self.tableList.hidden = YES;
            } else {
                [_tableList reloadData];
                [CommonUtils removeNoResultView:self.view];
                self.tableList.hidden = NO;
            }
        }
        self.tableList.pullTableIsRefreshing = NO;
        self.tableList.pullTableIsLoadingMore = NO;
    }
    /*
//    else if([url isEqualToString:api_member_productviewhistory]){
//        
//        appProducts = [[NSMutableArray alloc] initWithCapacity:0];
//        ProductViewHistoryResponse * respobj = (ProductViewHistoryResponse *)response;
//        if (respobj.status.succeed == 1) {
//            [appProducts addObjectsFromArray:respobj.data];
//            
//            if (appProducts.count == 0){
////                [CommonUtils displayNoResultView:self.view frame:self.tableList.frame];
//                [CommonUtils displayCollectionNoResultView:self.view frame:self.tableList.frame desc:@"没有结果"];
//                
//                NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
//                [center addObserver:self selector:@selector(jumpToIndexPage) name:TMPop2IndexNotificationName object:nil];
//                self.tableList.hidden = YES;
//            } else {
//                [_tableList reloadData];
//                [CommonUtils removeNoResultView:self.view];
//                self.tableList.hidden = NO;
//            }
//        }
//        
//    }
     */
    else if ([url  isEqual: api_cart_item_add]){
        CartResponse * cartResponse = (CartResponse *)response;
        if (cartResponse.status.succeed == 1){
            [SESSION getSession].cartId = cartResponse.data.cartId;
            // @"已加入购物车"
            NSString *footPrintVC_toastNotification_msg = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"footPrintVC_toastNotification_msg"];
            [CommonUtils ToastNotification:footPrintVC_toastNotification_msg andView:self.view andLoading:NO andIsBottom:YES];
            [AppStatic setCART_ITEM_QUANTITIES:[cartResponse.data getQuantities]];
//            [self.navigationItem.rightBarButtonItems objectAtIndex:1].badgeValue = [[NSString alloc] initWithFormat:@"%d", [AppStatic CART_ITEM_QUANTITIES ]];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return TMScreenH *100/568;
}


//#pragma TableView的处理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return appProducts.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    FootPrintCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FootPrintCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"FootPrintCell" owner:self options:nil]lastObject];

    }
    AppProduct * p = [appProducts objectAtIndex:indexPath.row];
    
    // @"品牌：%@"
    NSString *footPrintVC_cell_productBrand = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"footPrintVC_cell_productBrand"];
    // @"型号：%@"
    NSString *footPrintVC_cell_productModel1 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"footPrintVC_cell_productModel1"];
    // @"型号：暂无"
    NSString *footPrintVC_cell_productModel2 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"footPrintVC_cell_productModel2"];
    AppBrand * brand = p.appBrand;
//    cell.imageView.image = [UIImage imageNamed:@"index_defImage"];
    cell.imageview.imageURL = [URLUtils createURL: p.image];
    cell.productName.text = p.name;
    cell.productBrand.text = [NSString stringWithFormat:footPrintVC_cell_productBrand,brand.name];
    if (p.makerModel){
        cell.productModel.text = [NSString stringWithFormat:footPrintVC_cell_productModel1,p.makerModel];
    } else {
//        [NSString stringWithFormat:@"型号：%@",@"暂无"];
        cell.productModel.text = footPrintVC_cell_productModel2;
    }
    
    if (p.promotionPrice){
        cell.productPrice.text = [CommonUtils formatCurrency:p.promotionPrice];
        cell.productOldPrice.attributedText = [CommonUtils addDeleteLineOnLabel:[CommonUtils formatCurrency:p.price]];
    } else {
        
        cell.productPrice.text = [CommonUtils formatCurrency:p.price];
        cell.productOldPrice.text = @"";
    }
//    cell.productPrice.text = [CommonUtils formatCurrency:p.price];
//    if(p.marketPrice){
//        NSString * str = [NSString stringWithFormat:@"原价：%@元",[CommonUtils formatCurrency:p.marketPrice]];
//        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:str];
//        [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, [attri length])];
//        cell.productOldPrice.attributedText = attri;
//        
//    }
    cell.btnAddToCar.tag = p.id;
    [cell.btnAddToCar addTarget:self action:@selector(clickOnAddToCarButton:) forControlEvents:UIControlEventTouchUpInside];

    cell.btnHotSale.hidden = YES;
    if (p.isHotSale) {
        cell.btnHotSale.hidden = NO;
        cell.productName.text = [NSString stringWithFormat:@"         %@",p.name];
    }
//测试
//    if (indexPath.row >=2) {
//        cell.btnHotSale.hidden = NO;
//        cell.productName.text = [NSString stringWithFormat:@"         %@",p.name];
//    }
    return cell;
}

//加入购物车
- (void)clickOnAddToCarButton:(UIButton *)button{
    
    [cartService addCartItem:button.tag quantity:1];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    AppProduct * a = [appProducts objectAtIndex:indexPath.row];
    ProductInfoViewController * p = [[ProductInfoViewController alloc] initWithNibName:@"ProductInfoViewController" bundle:nil];
    p.productId = a.id;
    [self.navigationController pushViewController: p animated:YES];
}

#pragma mark - Refresh and load more methods




- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    [self performSelector:@selector(refreshTable) withObject:nil afterDelay:0.1f];
}
- (void) refreshTable
{
    [self loadData:YES];
    self.tableList.pullLastRefreshDate = [NSDate date];
    
}


- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    [self performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:0.1f];
}
- (void) loadMoreDataToTable
{
    pagination.page = pagination.page + 1;
    [self loadData:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)jumpToIndexPage{
    
    self.tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:NO];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
