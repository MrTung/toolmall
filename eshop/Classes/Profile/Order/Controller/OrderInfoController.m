//
//  OrderInfoController.m
//  eshop
//
//  Created by mc on 15/11/30.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import "OrderInfoController.h"

#import "UIFont+Fit.h"
#import "OrderInfoResponse.h"
#import "OrderInfoCell.h"
#import "PaymentPlugins.h"
#import "MyWebView.h"
//#import "SubmitReview.h"
#import "OpinionViewController.h"
@interface OrderInfoController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnViewHeightConstraint;

@end

@implementation OrderInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // @"订单详情"
    NSString *orderInfoController_navItem_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderInfoController_navItem_title"];
    self.navigationItem.title = orderInfoController_navItem_title;
    [super addNavBackButton];
    self.tableOrder.showsVerticalScrollIndicator = NO;
    orderService = [[OrderService alloc] initWithDelegate:self parentView:self.view];
    [self displayButtons];
    [orderService getOrderInfo:self.orderSn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clickOnButtonToDetailInfoOfExpression:(UIButton *)button{
//    NSLog(@"1111111");
}

//请求返回的数据
- (void) loadResponse:(NSString *)url response:(BaseModel *)response{
    
    // @"已提醒卖家发货"
    NSString *orderInfoController_toastNotification_msg1 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderInfoController_toastNotification_msg1"];
    // @"操作成功"
    NSString *orderInfoController_toastNotification_msg2 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderInfoController_toastNotification_msg2"];
    // @"操作成功"
    NSString *orderInfoController_toastNotification_msg3 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderInfoController_toastNotification_msg3"];
    
    if ([url isEqualToString:api_order_view]){
        OrderInfoResponse *respObj = (OrderInfoResponse*)response;
        orderInfo = respObj.data;
        
        [self displayOrderHeader];
        [self displayOrderFooter];
        [self.tableOrder reloadData];
        [self displayButtons];
        [self.tableOrder setPullTableIsRefreshing:NO];
        [self.tableOrder setPullTableIsLoadingMore:NO];
        [self.tableOrder setHasLoadingMore:NO];
        
    } else if ([url isEqual:api_order_remindshipping]){
        StatusResponse *respobj = (StatusResponse*)response;
        if (respobj.status.succeed == 1){
            [CommonUtils ToastNotification:orderInfoController_toastNotification_msg1 andView:self.view andLoading:NO andIsBottom:NO];
        }
    } else if ([url isEqual:api_order_confirmreceived]){
        StatusResponse *respobj = (StatusResponse*)response;
        if (respobj.status.succeed == 1){
            [CommonUtils ToastNotification:orderInfoController_toastNotification_msg2 andView:self.view andLoading:NO andIsBottom:NO];
            [orderService getOrderInfo:self.orderSn];
        }
    } else if ([url isEqual:api_order_cancel]){
        StatusResponse *respobj = (StatusResponse*)response;
        if (respobj.status.succeed == 1){
            [CommonUtils ToastNotification:orderInfoController_toastNotification_msg3 andView:self.view andLoading:NO andIsBottom:NO];
            [orderService getOrderInfo:self.orderSn];
        }
    }
}
//显示订单头部
- (void)displayOrderHeader{
    if (orderInfoHeader == nil){
        orderInfoHeader = [[OrderInfoHeader alloc] init];
    }
    orderInfoHeader.navigationController = self.navigationController;
    [orderInfoHeader setOrderInfo:orderInfo];
    self.tableOrder.tableHeaderView = orderInfoHeader;
    [orderInfoHeader setFrame:CGRectMake(0, 0, self.view.frame.size.width, orderInfoHeader.frame.size.height)];

    [self.tableOrder.tableHeaderView setFrame:CGRectMake(0, 0, self.view.frame.size.width, orderInfoHeader.frame.size.height)];

}
//显示订单尾部
- (void)displayOrderFooter{
    
    if (orderInfoFooter == nil){
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"OrderInfoFooter" owner:self options:nil];
        for (NSObject *o in objects) {
            if ([o isKindOfClass:[OrderInfoFooter class]]) {
                orderInfoFooter = (OrderInfoFooter *)o;
                break;
            }
        }
    }
    [orderInfoFooter setOrderInfo:orderInfo];
    
    
    self.tableOrder.tableFooterView = orderInfoFooter;
    
    [self.tableOrder.tableFooterView setFrame:CGRectMake(0, 0, self.view.frame.size.width, orderInfoFooter.frame.size.height)];
    
}
//显示按钮
- (void)displayButtons{
    
    // @"立即付款"
    NSString *orderInfoController_btn1_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderInfoController_btn1_title"];
    // @"查看物流"
    NSString *orderInfoController_btn2_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderInfoController_btn2_title"];
    // @"确认收货"
    NSString *orderInfoController_btn3_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderInfoController_btn3_title"];
    // @"提醒发货"
    NSString *orderInfoController_btn4_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderInfoController_btn4_title"];
    // @"发表评论"
    NSString *orderInfoController_btn5_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderInfoController_btn5_title"];
    // @"取消订单"
    NSString *orderInfoController_btn6_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderInfoController_btn6_title"];
    NSMutableArray *dispButtons = [[NSMutableArray alloc] initWithCapacity:10];
    if (orderInfo.payEnable){
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:orderInfoController_btn1_title, @"title", @"gary", @"color", @"1", @"tag", nil];
        [dispButtons addObject:dic];
    }
    if (orderInfo.expressViewEnable){
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:orderInfoController_btn2_title, @"title", @"gary", @"color", @"2", @"tag", nil];
        [dispButtons addObject:dic];
    }
    if (orderInfo.confirmReceiveEnable){
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:orderInfoController_btn3_title, @"title", @"gary", @"color", @"3", @"tag", nil];
        [dispButtons addObject:dic];
    }
    if (orderInfo.remindShippingEnable){
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:orderInfoController_btn4_title, @"title", @"gary", @"color", @"4", @"tag", nil];
        [dispButtons addObject:dic];
    }
    if (orderInfo.reviewEnable){
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:orderInfoController_btn5_title, @"title", @"gary", @"color", @"5", @"tag", nil];
        [dispButtons addObject:dic];
    }
    if (orderInfo.cancelEnable){
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:orderInfoController_btn6_title, @"title", @"gary", @"color", @"6", @"tag", nil];
        [dispButtons addObject:dic];
    }
    for (UIView *view in [self.buttonsView subviews]){
        [view removeFromSuperview];
    }
//    int buttonWidth = TMScreenW *70/320;
    int posX = [UIScreen mainScreen].bounds.size.width - TMScreenW *80/320;
    for (NSDictionary *btndict in dispButtons){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        CGRect frame = CGRectMake(posX, 9, TMScreenW *70/320, 32);
        button.frame = frame;
        [button setTitle:[btndict objectForKey:@"title"] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor clearColor];
        if ([[btndict objectForKey:@"color"] isEqualToString:@"red"]){
            [button setTitleColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:1.0f] forState:UIControlStateNormal];
            [CommonUtils decrateRedButton:button];
        } else {
            [button setTitleColor:[UIColor colorWithRed:1/196 green:1/196 blue:1/196 alpha:1.0f] forState:UIControlStateNormal];
            [CommonUtils decrateGaryButton:button];
        }
        button.font = [UIFont systemFontOfSize:12];
//        [button setBackgroundColor:[UIColor lightGrayColor]];
//        [button setTintColor:[UIColor darkGrayColor]];
        button.tag = [[btndict objectForKey:@"tag"] intValue];
        [button addTarget:self action:@selector(clickButtons:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonsView addSubview:button];
        posX = posX - TMScreenH *76/568;
    }
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:(CGRectMake(0, 0, kWidth, 1))];
    imgView.image = [UIImage imageNamed:@"05线"];
    [self.buttonsView addSubview:imgView];
    if (dispButtons.count) {
        self.btnViewHeightConstraint.constant = 49;
    } else {
        self.btnViewHeightConstraint.constant = 0;
    }
}

- (void) clickButtons:(UIButton*)button{
    int tagId = button.tag;
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
        NSString *orderInfoController_webView_navTitle = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderInfoController_webView_navTitle"];
        //查看物流
        MyWebView *myWebView = [[MyWebView alloc] init];
        myWebView.navTitle = orderInfoController_webView_navTitle;
        SESSION *session = [SESSION getSession];
        NSString *url = [[NSString alloc] initWithFormat:@"%@?sn=%@&key=%@&sessionId=%@&userId=%d", url_delivery_query, orderInfo.sn, session.key, session.sid, session.uid ];
        myWebView.loadUrl = url;
        [self.navigationController pushViewController:myWebView animated:YES];
    } else if (tagId == 3){
        
        // @"提示"
        NSString *orderInfoController_alert_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderInfoController_alert_title"];
        // @"请收到货后，再确认收货！是否继续?"
        NSString *orderInfoController_alert_msg = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderInfoController_alert_msg"];
        //确认收货
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:orderInfoController_alert_title
                                                        message:orderInfoController_alert_msg
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
        CancelOrder *cancelOrder = [[CancelOrder alloc] initWithNibName:@"CancelOrder" bundle:nil];
        cancelOrder.cancelOrderDelegate = self;
        STPopupController* popupController = [[STPopupController alloc] initWithRootViewController:cancelOrder];
        popupController.style = STPopupStyleBottomSheet;
        [popupController presentInViewController:self];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){
        [orderService confirmReceived:orderInfo.sn];
    }
}

#pragma TableView的处理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return orderInfo.appOrderItems.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //return 86;
    return [self tableView:self.tableOrder cellForRowAtIndexPath:indexPath].frame.size.height;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return TMScreenH *30/568;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 0;
//}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"OrderInfoItemHeader"];
    
    if (headerView == nil)
    {
        headerView = [[UITableViewHeaderFooterView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, TMScreenH *30/568)];
        
        UILabel *lbShopName = [[UILabel alloc] initWithFrame:CGRectMake(TMScreenW *8/320, TMScreenH *5/568, [UIScreen mainScreen].bounds.size.width, TMScreenH *20/568)];
        [lbShopName setTextColor:[UIColor blackColor]];
        [lbShopName setFont:[UIFont systemFontWithSize:12]];
        [lbShopName setText:orderInfo.shopName];
//        [headerView setBackgroundColor:[UIColor whiteColor]];
        [headerView.contentView setBackgroundColor:[UIColor whiteColor]];
        [headerView addSubview:lbShopName];
    }
    return headerView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    OrderInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderInfoCell"];
    if (!cell) {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"OrderInfoCell" owner:self options:nil];
        for (NSObject *o in objects) {
            if ([o isKindOfClass:[OrderInfoCell class]]) {
                cell = (OrderInfoCell *)o;
                break;
            }
        }
    }
    AppOrderItem *orderItem = [orderInfo.appOrderItems objectAtIndex:indexPath.row];
    [cell setOrderItem:orderItem];
    cell.tag = orderItem.appProduct.id;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int pId = (int)[tableView cellForRowAtIndexPath:indexPath].tag;
    ProductInfoViewController * vc = [[ProductInfoViewController alloc] initWithNibName:@"ProductInfoViewController" bundle:nil];
    vc.productId = pId;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Refresh and load more methods

- (void) refreshTable
{
    /*
     Code to actually refresh goes here.  刷新代码放在这
     */
    
    [orderService getOrderInfo:self.orderSn];
    self.tableOrder.pullLastRefreshDate = [NSDate date];
    
}

- (void) loadMoreDataToTable
{
    /*
     
     Code to actually load more data goes here.  加载更多实现代码放在在这
     
     */
}

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    
    [self performSelector:@selector(refreshTable) withObject:nil afterDelay:0.1f];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    [self performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:0.1f];
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
