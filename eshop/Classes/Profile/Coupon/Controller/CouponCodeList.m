//
//  CouponCodeList.m
//  eshop
//
//  Created by mc on 15/11/2.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import "CouponCodeList.h"


@interface CouponCodeList ()
{
    CouponService *couponService;
    NSMutableArray *couponCodes;
    Pagination *pagination;
}

@end

@implementation CouponCodeList

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
    
    [self initView];
   
    [super addNavBackButton];
    
    [self addTableHead];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData:YES];
}


- (void)loadData:(BOOL)refresh
{
    if (refresh){
        pagination.page = 1;
        [couponCodes removeAllObjects];
    }
    [couponService getCouponCodeList:pagination];
}


-(void)initView
{
    self.view.backgroundColor = groupTableViewBackgroundColorSelf;
    
    // @"优惠券"
    NSString *couponCodeList_navItem_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"couponCodeList_navItem_title"];
    self.navigationItem.title = couponCodeList_navItem_title;
    
    couponService = [CouponService alloc];
    couponService.delegate = self;
    couponService.parentView = self.view;
    
    couponCodes = [[NSMutableArray alloc] initWithCapacity:20];
    
    pagination = [[Pagination alloc] init];
    pagination.page = 1;
}

- (void)backButtonClick:(UIButton *)button{
    
    NSArray *controllers = [self.navigationController viewControllers];
    Boolean comefromImprove = false;
    for (UIViewController *controller in controllers){
        if ([controller isKindOfClass:[ImproveInfoViewController class]]){
            comefromImprove = true;
        }
    }
    if (comefromImprove){
        for (UIViewController *controller in controllers){
            if ([controller isKindOfClass:[MyAccountViewController class]]){
                [self.navigationController popToViewController:controller animated:YES];
                break;
            }
        }
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)addTableHead{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, TMScreenH *50/568)];
    view.backgroundColor = self.view.backgroundColor;
    UIButton *btnExchange = [UIButton buttonWithType:UIButtonTypeCustom];
    btnExchange.frame = CGRectMake(TMScreenW *20/320 , TMScreenH *10/568 , kWidth - TMScreenW *40/320, TMScreenH *30/568);
    [btnExchange.titleLabel setFont:[UIFont systemFontWithSize:12]];
    [btnExchange setTitleColor:redColorSelf forState:UIControlStateNormal];
    // @"优惠券码兑换通道(点击进入)"
    NSString *couponCodeList_btnExchange_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"couponCodeList_btnExchange_title"];
    [btnExchange setTitle:couponCodeList_btnExchange_title forState:UIControlStateNormal];
    btnExchange.layer.borderWidth = 1.0f;
    btnExchange.layer.cornerRadius = 6;
    btnExchange.layer.borderColor = redColorSelf.CGColor;
    [btnExchange addTarget:self action:@selector(clickExchange) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btnExchange];
    self.tableCouponCodeList.tableHeaderView = view;
}

- (void)clickExchange{
    CouponExchangeByCodeViewController *couponExchangeByCode = [[CouponExchangeByCodeViewController alloc] init];
    [self.navigationController pushViewController:couponExchangeByCode animated:YES];
}


- (void)loadResponse:(NSString *) url response:(BaseModel *)response{
    if ([url isEqual:api_couponcode_list]){
        CouponCodeListResponse * respobj = (CouponCodeListResponse *)response;
        [couponCodes addObjectsFromArray:respobj.data];
        if (couponCodes.count == 0){
            
            // @"您还没有优惠券!"
            NSString *couponCodeList_noResultView_desc = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"couponCodeList_noResultView_desc"];
            [CommonUtils displayCollectionNoResultView:self.view frame:CGRectMake(0, TMScreenH *50/568, kWidth, kHeight - TMScreenH *50/568 -64) desc:couponCodeList_noResultView_desc];
            
            NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
            [center addObserver:self selector:@selector(jumpToIndexPage) name:TMPop2IndexNotificationName object:nil];
            
        } else {
            self.tableCouponCodeList.tableFooterView = nil;
            [self.tableCouponCodeList reloadData];
        }
        
        self.tableCouponCodeList.pullTableIsLoadingMore = NO;
        self.tableCouponCodeList.pullTableIsRefreshing = NO;
        if (respobj.paginated.more) {
            
            [self.tableCouponCodeList setHasLoadingMore:YES];
        }else{
            [self.tableCouponCodeList setHasLoadingMore:NO];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return couponCodes.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 86;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CouponCodeListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CouponCodeListCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CouponCodeListCell" owner:self options:nil] lastObject];
        AppCouponCode *couponCode =[couponCodes objectAtIndex:[indexPath row]];
        [cell setCouponCode:couponCode];
        cell.tag = couponCode.id;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    int couponId = (int)[tableView cellForRowAtIndexPath:indexPath].tag;
    CouponInfoController * vc = [[CouponInfoController alloc] initWithNibName:@"CouponInfoController" bundle:nil];
    vc.couponId = couponId;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Refresh and load more methods

- (void) refreshTable
{
    [self loadData:YES];
    self.tableCouponCodeList.pullLastRefreshDate = [NSDate date];
}

- (void) loadMoreDataToTable
{
    pagination.page = pagination.page + 1;
    [self loadData:NO];
}

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    
    [self performSelector:@selector(refreshTable) withObject:nil afterDelay:0.1f];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    [self performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:0.1f];
}

- (void)jumpToIndexPage{
    
    self.tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:NO];
}

@end
