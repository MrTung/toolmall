//
//  OrderList.m
//  toolmall
//
//  Created by mc on 15/10/12.
//
//

#import "OrderList.h"

#import "UIFont+Fit.h"
#import "MyWebView.h"
#import "OrderInfoController.h"
#import "OpinionViewController.h"
@implementation OrderList
@synthesize tableOrderList;
@synthesize type;
@synthesize iniType;
@synthesize btnAll;
@synthesize btnAwaitPay;
@synthesize btnAwaitShip;
@synthesize btnShipped;
@synthesize btnAwaitReview;
@synthesize topView;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBarHidden = NO;
    self.view.backgroundColor = groupTableViewBackgroundColorSelf;
    self.tableOrderList.backgroundColor = groupTableViewBackgroundColorSelf;
    
    orderService = [[OrderService alloc] initWithDelegate:self parentView:self.view];
    pagination = [Pagination alloc];
    orders = [[NSMutableArray alloc] initWithCapacity:20];
    self.topView.hidden = NO;
    
    // @"订单搜索"
    NSString *orderList_navItem_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderList_navItem_title"];
    UILabel * nTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    nTitle.text = orderList_navItem_title;
    nTitle.textAlignment = NSTextAlignmentCenter;
    nTitle.textColor = [UIColor colorWithRed:37/255.0 green:38/255.0 blue:37/255.0 alpha:1];
    nTitle.font = [UIFont systemFontOfSize:20];
    self.navigationItem.titleView = nTitle;
    
    _btnR1 = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnR1.frame = CGRectMake(0, 12, 20, 20);
    [_btnR1 setImage:[UIImage imageNamed:@"order_list_search"] forState:UIControlStateNormal];
    [_btnR1 setImage:[UIImage imageNamed:@"order_list_search"] forState:UIControlStateHighlighted];
    [_btnR1 addTarget:self action:@selector(clickNavRightButtonOne:) forControlEvents:UIControlEventTouchUpInside];

      
    UIBarButtonItem * itemR1 = [[UIBarButtonItem alloc] initWithCustomView:_btnR1];
    
    self.navigationItem.rightBarButtonItem = itemR1;
    
    [self configureSliderFrame];
    
    [super addNavBackButton];
    
    [super addThreedotButton];
    
    [self createFootPrintView];
    
    _viewFootprint.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    [self configureSliderFrame];
    [self loadData:YES];
}

- (void)configureSliderFrame {
    
    // 全部
    NSString *orderList_btnAll_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderList_btnAll_title"];
    // 待付款
    NSString *orderList_btnAwaitPay_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderList_btnAwaitPay_title"];
    // 待发货
    NSString *orderList_btnAwaitShip_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderList_btnAwaitShip_title"];
    // 待收货
    NSString *orderList_btnShipped_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderList_btnShipped_title"];
    // 待评价
    NSString *orderList_btnAwaitReview_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderList_btnAwaitReview_title"];
    _viewSlider.hidden = NO;
    filterTypes = [NSArray arrayWithObjects:@"", @"await_pay", @"await_ship", @"shipped", @"await_review", nil];
    
    if (iniType != nil){
        type = iniType;
        iniType = nil;
    }
    if (type == nil || [type isEqual:@""]){
        [self.btnAll setTitleColor:redColorSelf forState:UIControlStateNormal];
        [self.btnAll setTitle:orderList_btnAll_title forState:(UIControlStateNormal)];
        _viewSlider.frame = CGRectMake(CGRectGetMinX(self.btnAll.frame) +5, 32, _viewSlider.frame.size.width, _viewSlider.frame.size.height);
    } else if ([type isEqual:[filterTypes objectAtIndex:1]]){
        [self.btnAwaitPay setTitleColor:redColorSelf forState:UIControlStateNormal];
        [self.btnAwaitPay setTitle:orderList_btnAwaitPay_title forState:(UIControlStateNormal)];
        _viewSlider.frame = CGRectMake(CGRectGetMinX(self.btnAwaitPay.frame) + 5, 32, _viewSlider.frame.size.width, _viewSlider.frame.size.height);
        
    } else if ([type isEqual:[filterTypes objectAtIndex:2]]){
        [self.btnAwaitShip setTitleColor:redColorSelf forState:UIControlStateNormal];
        [self.btnAwaitShip setTitle:orderList_btnAwaitShip_title forState:(UIControlStateNormal)];
        _viewSlider.frame = CGRectMake(CGRectGetMinX(self.btnAwaitShip.frame) + 5, 32, _viewSlider.frame.size.width, _viewSlider.frame.size.height);
        
    } else if ([type isEqual:[filterTypes objectAtIndex:3]]){
        [self.btnShipped setTitleColor:redColorSelf forState:UIControlStateNormal];
        [self.btnShipped setTitle:orderList_btnShipped_title forState:(UIControlStateNormal)];
        _viewSlider.frame = CGRectMake(CGRectGetMinX(self.btnShipped.frame) + 5, 32, _viewSlider.frame.size.width, _viewSlider.frame.size.height);
        
    } else if ([type isEqual:[filterTypes objectAtIndex:4]]){
        [self.btnAwaitReview setTitleColor:redColorSelf forState:UIControlStateNormal];
        [self.btnAwaitReview setTitle:orderList_btnAwaitReview_title forState:(UIControlStateNormal)];
        _viewSlider.frame = CGRectMake(CGRectGetMinX(self.btnAwaitReview.frame) + 5, 32, _viewSlider.frame.size.width, _viewSlider.frame.size.height);
    }
}

#pragma mark - 导航右边按钮事件
//搜索按钮
- (void)clickNavRightButtonOne:(UIButton *)button{
    OrderSearchViewController * orderSearchPage = [[OrderSearchViewController alloc] initWithNibName:@"OrderSearchViewController" bundle:nil];;
    orderSearchPage.returnKeyword = ^(NSString * string){
        _keyword = string;
    };
    [self.navigationController pushViewController:orderSearchPage animated:YES];
}
//更多按钮
- (void)clickNavRightButtonMore:(UIButton *) button{

}

#pragma mark - 创建足迹视图
- (void)createFootPrintView {
    
    _viewFootprint = [[UIView alloc] initWithFrame:CGRectMake(0, TMScreenH - TMScreenH *142/568-64, TMScreenW, TMScreenH *142/568)];
    _viewFootprint.backgroundColor = groupTableViewBackgroundColorSelf;
    [self.view addSubview:_viewFootprint];
    //足迹前面的图片
    UIView *topBacView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TMScreenW, TMScreenH *38/568)];
    topBacView.backgroundColor = [UIColor whiteColor];
    [_viewFootprint addSubview:topBacView];
    
    // 足迹
    NSString *orderList_viewFootprint_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderList_viewFootprint_title"];
    // 更多
    NSString *orderList_viewFootprint_more = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderList_viewFootprint_more"];
    EGOImageView * image = [[EGOImageView alloc] initWithImage:[UIImage imageNamed:@"足迹"]];
    image.frame = CGRectMake(TMScreenW *10/320, TMScreenH *8.5/568, TMScreenW *20/320, TMScreenW *20/320);
    [topBacView addSubview:image];
    UILabel * foot = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(image.frame)+TMScreenW *5/320, 0, TMScreenW *40/320, TMScreenH *37/568)];
    foot.text = orderList_viewFootprint_title;
    foot.font = [UIFont systemFontWithSize:13];
    foot.textColor = [UIColor colorWithRed:46/255.0 green:46/255.0 blue:46/255.0 alpha:1];
    [topBacView addSubview:foot];
    UILabel * more = [[UILabel alloc] initWithFrame:CGRectMake(_viewFootprint.frame.size.width - TMScreenW *40/320, 0, TMScreenW *40/320, TMScreenH *37/568)];
    more.userInteractionEnabled = YES;
    more.text = orderList_viewFootprint_more;
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
    
    FootPrintViewController * footPrint = [[FootPrintViewController alloc] initWithNibName:@"FootPrintViewController" bundle:nil];
    [self.navigationController pushViewController:footPrint animated:YES];
}


//创建足迹中的每个item
- (void)createItemsOfProductViewHistory{
    
    int itemN = 0;
    for (int i =0; i<_arrayFootprint.count; i++) {
        if (i == 10) {
            break;
        }
        itemN = i+1;
        FootViewItem * footItem = [[FootViewItem alloc] initWithFrame:CGRectMake(0 + i*(TMScreenW *85/320), TMScreenH *0/568, TMScreenW *85/320, TMScreenH *104/568) image:[_arrayFootprint[i] valueForKey:@"image"] title:[_arrayFootprint[i] valueForKey:@"name"] price:[_arrayFootprint[i] valueForKey:@"price"]];
        
        footItem.userInteractionEnabled = YES;
        _scrollFoot.userInteractionEnabled = YES;
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, footItem.frame.size.width, footItem.frame.size.height);
        button.tag = [[_arrayFootprint[i] valueForKey:@"id"] integerValue];
        [footItem addSubview:button];
        [button addTarget:self action:@selector(clickToDetailInfomation:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollFoot addSubview:footItem];
    }
    _scrollFoot.contentSize = CGSizeMake(itemN * (TMScreenW *85/320), 0);
}

- (void)clickToDetailInfomation:(UIButton *)button{
    
    ProductInfoViewController * p = [[ProductInfoViewController alloc] initWithNibName:@"ProductInfoViewController" bundle:nil];
    p.productId = button.tag;
    p.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:p animated:YES];
}

#pragma mark - 发起请求-足迹商品浏览历史
- (void)requestProductViewHistory{
    
    productService = [[ProductService alloc] initWithDelegate:self parentView:self.view];
    [productService productViewHistory];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    if (_keyword !=nil) {
        self.topView.hidden = YES;
        self.tableListTopCons.constant = 0;
        type = nil;
    }
    else{
        self.topView.hidden = NO;
        self.tableListTopCons.constant = 36;
    }
    _viewSlider.hidden = YES;
}

- (void) loadData:(BOOL)refresh
{
    if (refresh){
        pagination.page = 1;
        [orders removeAllObjects];
    }

    [orderService getOrderList:type pagination:pagination keyword:_keyword];
}

//订单的菜单按钮
-(IBAction)clickFilter:(UIButton *)sender{
    
    //先取出滑块
    CGPoint center = _viewSlider.center;
    //用来去将原来选中的按钮取消掉
    for (UIView * view in self.topView.subviews) {
        if (view.tag != 2000) {
            ((UIButton *)view).selected = NO;
        }
    }
    //将点击的按钮进行选中
    sender.selected = YES;
    //改变滑块的位置
    center.x = sender.center.x;
    //使用动画来进行移动改变滑块的位置
    [UIView animateWithDuration:0.3 animations:^{
        //赋给滑块的中心点
        _viewSlider.center = center;
    }];
    
    self.type = [filterTypes objectAtIndex:sender.tag];
    [self.btnAll setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btnAwaitShip setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btnAwaitPay setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btnShipped setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btnAwaitReview setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    [sender setTitleColor:[UIColor colorWithRed:197/255.0 green:0 blue:5/255.0 alpha:1]  forState:UIControlStateNormal];
    
    if (type == nil || [type isEqual:@""]){
    } else if ([type isEqual:[filterTypes objectAtIndex:1]]){
    } else if ([type isEqual:[filterTypes objectAtIndex:2]]){
    } else if ([type isEqual:[filterTypes objectAtIndex:3]]){
    } else if ([type isEqual:[filterTypes objectAtIndex:4]]){
    }

    [self loadData:YES];
}

//请求返回
- (void)loadResponse:(NSString *) url response:(BaseModel *)response{
    
    // @"已提醒卖家发货"
    NSString *orderList_toastNotification_msg1 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderList_toastNotification_msg1"];
    // @"操作成功"
    NSString *orderList_toastNotification_msg2 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderList_toastNotification_msg2"];
    // @"操作成功"
    NSString *orderList_toastNotification_msg3 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderList_toastNotification_msg3"];
    
    if([url isEqual:api_member_productviewhistory]){
        ProductViewHistoryResponse * respobj = (ProductViewHistoryResponse *)response;
        _arrayFootprint = [[NSMutableArray alloc] initWithCapacity:0];
        [_arrayFootprint addObjectsFromArray:respobj.data];
//        NSLog(@"足迹：%@",_arrayFootprint);
        if (_arrayFootprint.count > 0) {
            
            _viewFootprint.hidden = NO;
            [self createItemsOfProductViewHistory];
            self.scrollFoot.backgroundColor = [UIColor whiteColor];
        }
        else {
            _viewFootprint.hidden = YES;
            self.scrollFoot.backgroundColor = groupTableViewBackgroundColorSelf;
        }
    }
    
    else if ([url isEqual:api_order_list]){
            OrderListResponse * respobj = (OrderListResponse *)response;
            [orders addObjectsFromArray:respobj.data];
        if (_keyword != nil) {
            if (orders.count > 0) {
                [CommonUtils removeNoResultView:self.view];
                [tableOrderList reloadData];
                _viewFootprint.hidden = YES;
                [_viewFootprint removeFromSuperview];
                self.tableOrderList.hidden = NO;
            }
            else {
                CGRect rec = CGRectMake(0, CGRectGetMinY(self.tableOrderList.frame) ,CGRectGetWidth(self.tableOrderList.frame) , CGRectGetMinY(_viewFootprint.frame) - CGRectGetMinY(tableOrderList.frame));
                [CommonUtils displayOrderNoResultView:self.view frame:rec];
               
                self.tableOrderList.hidden = YES;
//                显示足迹
                [self requestProductViewHistory];
//                _viewFootprint.hidden = NO;
            }
        }
        else{
        
            if (orders.count > 0){
                [CommonUtils removeNoResultView:self.view];
                [tableOrderList reloadData];
                self.tableOrderList.hidden = NO;
                _viewFootprint.hidden = YES;
                _footIsExist = NO;
            } else {
#pragma mark - 订单没有数据-界面处理
                CGRect rec = CGRectMake(0, CGRectGetMinY(self.tableOrderList.frame) ,CGRectGetWidth(self.tableOrderList.frame) , CGRectGetMinY(_viewFootprint.frame) - CGRectGetMinY(tableOrderList.frame));
                [CommonUtils displayOrderNoResultView:self.view frame:rec];
                if (_footIsExist == NO) {
//                    _viewFootprint.hidden = NO;
                    _footIsExist = YES;
                    [self requestProductViewHistory];
                }
                self.tableOrderList.hidden = YES;
                NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
                [center addObserver:self selector:@selector(jumpToIndexPage) name:TMPop2IndexNotificationName object:nil];
            }
            
            self.tableOrderList.pullTableIsRefreshing = NO;
            self.tableOrderList.pullTableIsLoadingMore = NO;
            if (respobj.paginated.more == 0){
                [self.tableOrderList setHasLoadingMore:NO];
            } else {
                [self.tableOrderList setHasLoadingMore:YES];
            }
        }
    
        
    }
    else if ([url isEqual:api_order_remindshipping]){
        StatusResponse *respobj = (StatusResponse*)response;
        if (respobj.status.succeed == 1){
            [CommonUtils ToastNotification:orderList_toastNotification_msg1 andView:self.view andLoading:NO andIsBottom:NO];
        }
        
    }
    else if ([url isEqual:api_order_confirmreceived]){
        StatusResponse *respobj = (StatusResponse*)response;
        if (respobj.status.succeed == 1){
            [CommonUtils ToastNotification:orderList_toastNotification_msg2 andView:self.view andLoading:NO andIsBottom:NO];
            [self loadData:YES];
        }
        
    }
    else if ([url isEqual:api_order_cancel]){
        StatusResponse *respobj = (StatusResponse*)response;
        if (respobj.status.succeed == 1){
            [CommonUtils ToastNotification:orderList_toastNotification_msg3 andView:self.view andLoading:NO andIsBottom:NO];
            [self loadData:YES];
        }
    }
}

//跳转到首页
- (void)jumpToIndexPage{
    
    self.tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:NO];
}


#pragma mark OrderListItemFooterDelegate

- (void)sendMessage:(NSInteger)tagId section:(NSInteger)section{
    AppOrderInfo *orderInfo = [orders objectAtIndex:section];
    if (tagId == 1){
        //立即付款
        PaymentPlugins *paymentPulgins = [[PaymentPlugins alloc] initWithNibName:@"PaymentPlugins" bundle:nil];
        PaymentInfo *paymentInfo = [[PaymentInfo alloc] init];
        paymentInfo.sn = orderInfo.sn;
        paymentInfo.type = @"payment";
        paymentInfo.amount = orderInfo.amountPayable;
        [paymentPulgins setPaymentInfo:paymentInfo];
        [self.navigationController pushViewController:paymentPulgins animated:YES];
    } else if (tagId == 2){
        
        // @"物流信息"
        NSString *orderList_webView_navTitle = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderList_webView_navTitle"];
        //查看物流
        MyWebView *myWebView = [[MyWebView alloc] init];
        myWebView.navTitle = orderList_webView_navTitle;
        SESSION *session = [SESSION getSession];
        NSString *url = [[NSString alloc] initWithFormat:@"%@?sn=%@&key=%@&sessionId=%@&userId=%d", url_delivery_query, orderInfo.sn, session.key, session.sid, session.uid ];
        myWebView.loadUrl = url;
        [self.navigationController pushViewController:myWebView animated:YES];
    } else if (tagId == 3){
        
        // @"提示"
        NSString *orderList_alert_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderList_alert_title"];
        // @"请收到货后，再确认收货！是否继续?"
        NSString *orderList_alert_msg = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderList_alert_msg"];
        //确认收货
        curOperaterOrder = orderInfo;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:orderList_alert_title
                                                        message:orderList_alert_msg
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:@"取消", nil];
        [alert show];
    } else if (tagId == 4){
        //提醒发货
        [orderService remindShipping:orderInfo.sn];
    } else if (tagId == 5){
        //发表评论
//        SubmitReview *submitReview = [[SubmitReview alloc] initWithNibName:@"SubmitReview" bundle:nil];
        OpinionViewController *submitReview = [[OpinionViewController alloc] initWithNibName:@"OpinionViewController" bundle:nil];
        submitReview.appOrderInfo = orderInfo;
        [self.navigationController pushViewController:submitReview animated:YES];
    } else if (tagId == 6){
        //取消订单
        curOperaterOrder = orderInfo;
        CancelOrder *cancelOrder = [[CancelOrder alloc] initWithNibName:@"CancelOrder" bundle:nil];
        cancelOrder.cancelOrderDelegate = self;
        popupController = [[STPopupController alloc] initWithRootViewController:cancelOrder];
        popupController.style = STPopupStyleBottomSheet;
        [popupController presentInViewController:self];
    } else if (tagId == 7){
        //我的评论
        MyOpinionViewController * myOpinion = [[MyOpinionViewController alloc] initWithNibName:@"MyOpinionViewController" bundle:nil];
        myOpinion.appOrderInfo = orderInfo;
        [self.navigationController pushViewController:myOpinion animated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){
        [orderService confirmReceived:curOperaterOrder.sn];
    }
}

- (void)complete:(int)cancelReason{
    [popupController popViewControllerAnimated:YES];
    [orderService orderCancle:curOperaterOrder.sn cancelReason:cancelReason];
}

#pragma TableView的处理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return orders.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    AppOrderInfo *orderInfo = (AppOrderInfo*)[orders objectAtIndex:section];
    return orderInfo.appOrderItems.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TMScreenH *82/568;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return TMScreenH *33/568;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    AppOrderInfo *orderInfo = [orders objectAtIndex:section];
    OrderListItemFooter *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"OrderListItemFooter"];
    CGFloat height;
    if (footerView == nil)
    {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"OrderListItemFooter" owner:self options:nil];
        for (NSObject *o in objects) {
            if ([o isKindOfClass:[OrderListItemFooter class]]) {
                footerView = (OrderListItemFooter *)o;
                footerView.footerDelegate = self;
                footerView.section = section;
                break;
            }
        }
        
       height = [footerView displayButtons:orderInfo];
    }
    return height;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    OrderListItemHeader *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"OrderListItemHeader"];
    if ((orders.count <= section)) {
        return headerView;
    }
    AppOrderInfo *orderInfo = [orders objectAtIndex:section];
    if (headerView == nil)
    {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"OrderListItemHeader" owner:self options:nil];
        for (NSObject *o in objects) {
            if ([o isKindOfClass:[OrderListItemHeader class]]) {
                headerView = (OrderListItemHeader *)o;
                break;
            }
        }
        headerView.orderSn.text = orderInfo.sn;
        headerView.orderStatus.text = orderInfo.orderStatusName;
    }
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    OrderListItemFooter *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"OrderListItemFooter"];
    if (!(orders.count > section)) {
        return footerView;
    }
    AppOrderInfo *orderInfo = [orders objectAtIndex:section];
    
    if (footerView == nil)
    {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"OrderListItemFooter" owner:self options:nil];
        for (NSObject *o in objects) {
            if ([o isKindOfClass:[OrderListItemFooter class]]) {
                footerView = (OrderListItemFooter *)o;
                footerView.footerDelegate = self;
                footerView.section = section;
                break;
            }
        }
        // @"共%lu件商品,合计:%@(运费:%@)"
        NSString *orderList_footerView_lnFooterDesc = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderList_footerView_lnFooterDesc"];
        NSString *footerDesc = [[NSString alloc] initWithFormat:orderList_footerView_lnFooterDesc,(unsigned long)orderInfo.quantity, [CommonUtils formatCurrency:orderInfo.amount] , [CommonUtils formatCurrency:orderInfo.freight]];
        
        NSMutableAttributedString * s = [[NSMutableAttributedString alloc] initWithString:footerDesc];
        NSRange range = [[s string]rangeOfString:[CommonUtils formatCurrency:orderInfo.amountPayable]];
        [s addAttribute:NSForegroundColorAttributeName value:redColorSelf range:range];
        [s addAttribute:NSFontAttributeName value:[UIFont systemFontWithSize:15] range:range];
        footerView.lnFooterDesc.attributedText = s;
        
        [footerView displayButtons:orderInfo];
    }
    return footerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:OrderListCellIdentifier];
    if (!cell) {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"OrderListCell" owner:self options:nil];
        for (NSObject *o in objects) {
            if ([o isKindOfClass:[OrderListCell class]]) {
                cell = (OrderListCell *)o;
                break;
            }
        }
        
        if (orders.count > indexPath.section) {
            
            AppOrderInfo *order =[orders objectAtIndex:[indexPath section]];
            
            if (order.appOrderItems.count > indexPath.row) {
                
                AppOrderItem *orderItem = [order.appOrderItems objectAtIndex:indexPath.row];
                cell.image.imageURL = [NSURL URLWithString:orderItem.thumbnail];
                cell.prodName.text = orderItem.appProduct.name;
                cell.prodSn.text = orderItem.appProduct.sn;
                cell.prodBrand.text = orderItem.appProduct.appBrand.name;
                // @"暂无"
                NSString *orderList_cell_prodMakerModel = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderList_cell_prodMakerModel"];
                if (orderItem.appProduct.makerModel){
                    cell.prodMakerModel.text = orderItem.appProduct.makerModel;
                } else {
                    cell.prodMakerModel.text = orderList_cell_prodMakerModel;
                }
                cell.price.text = [CommonUtils formatCurrency:orderItem.finalPrice];
                cell.quantity.text = [[NSString alloc] initWithFormat:@"X%d", orderItem.quantity];
            }
        }
    }
    return cell;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppOrderInfo *order = [orders objectAtIndex:[indexPath section]];
    OrderInfoController *orderInfoController = [[OrderInfoController alloc] initWithNibName:@"OrderInfoController" bundle:nil];
    orderInfoController.orderSn = order.sn;
    orderInfoController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:orderInfoController animated:YES];
}

#pragma mark - Refresh and load more methods

- (void) refreshTable
{
    /*Code to actually refresh goes here.  刷新代码放在这 */
    [self loadData:YES];
    self.tableOrderList.pullLastRefreshDate = [NSDate date];
}

- (void) loadMoreDataToTable
{
    /*Code to actually load more data goes here.  加载更多实现代码放在在这*/
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

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:TMPop2IndexNotificationName object:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)backButtonClick:(UIButton *)button{
    NSArray *controllers = self.navigationController.viewControllers;

    for (UIViewController *controller in controllers){
        if ([controller isKindOfClass:[ProductInfoViewController class]]){
            [self.navigationController popToViewController:controller animated:YES];
            
            return;
        }
        else if ([controller isKindOfClass:[CartController class]]){
            [self.navigationController popToViewController:controller animated:YES];
            
            return;
        }
    }
    [super backButtonClick:button];
}
@end
