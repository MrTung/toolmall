//
//  OrderController.m
//  eshop
//
//  Created by mc on 15/10/31.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import "OrderController.h"

#import "UIFont+Fit.h"

@interface OrderController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableordersBottomConstraint;

@end

@implementation OrderController
@synthesize tableOrders;

- (void)setOrderBuildResponse:(OrderBuildResponse2*)orderBuildResp{
    orderBuildResponseBegin = orderBuildResp;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    blnOrderBuilded = false;
    
    // @"确认订单"
    NSString *orderController_navItem_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderController_navItem_title"];
    self.navigationItem.title = orderController_navItem_title;
    [super addNavBackButton];
    orderService = [[OrderService alloc] initWithDelegate:self parentView:self.view];

    orderHeaderView = [[OrderHeadView alloc] initWithFrame:CGRectMake(0, 0, TMScreenW,TMScreenH *70/568) Name:nil phone:nil address:nil];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAddress)];
    [orderHeaderView addGestureRecognizer:tap];
    self.tableOrders.tableHeaderView = orderHeaderView;
    
    NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"OrderFooter" owner:self options:nil];
    for (NSObject *o in objects) {
        if ([o isKindOfClass:[OrderFooter class]]) {
            orderFooter = (OrderFooter *)o;
//            [orderFooter myinit];
            orderFooter.msgHandler = self;
            self.tableordersBottomConstraint.constant = TMScreenH *40/568;
            orderFooter.frame = CGRectMake(0, kHeight-TMScreenH *40/568-64, kWidth, TMScreenH *40/568);
            [self.view addSubview:orderFooter];
            break;
        }
    }

    [self displayOrderInfo:orderBuildResponseBegin];
    [self updateViewConstraints];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
//    orderFooter.itemHeightLayout.constant = TMScreenH *36/568;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed=YES;
    }
    return self;
}

//设置收件人信息
- (void)setReceiver:(Address*)address{
    receiver = address;
    
    orderHeaderView = [[OrderHeadView alloc] initWithFrame:CGRectMake(0, 0, TMScreenW, TMScreenH *70/568) Name:receiver.consignee phone:receiver.tel address:[receiver.areaName stringByAppendingString:receiver.address]];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAddress)];
    [orderHeaderView addGestureRecognizer:tap];

    [tableOrders setTableHeaderView:orderHeaderView];
    if (blnOrderBuilded){
        [self calculateOrders];
    }
}

//配送方式
- (void)setShippingMethod:(NSInteger)section shippingMethod:(AppShippingMethod*)shippingMethod{
    AppOrderInfo *order = [orders objectAtIndex:section];
    order.shippingMethod = shippingMethod;
    [self calculateOrders];
    //[self.tableOrders reloadData];
}
//付款方式
- (void)setPaymentMethod:(AppPaymentMethod*)pPaymentMethod{
    paymentMethod = pPaymentMethod;
    if (blnOrderBuilded){
        [self calculateOrders];
    }
}

//选择优惠券
- (void)setCouponCode:(NSInteger)section couponCode:(AppCouponCode*)pCouponCode
{
    AppOrderInfo *order = [orders objectAtIndex:section];
    order.couponCode = pCouponCode;
    [self calculateOrders];
}
//选择发票方式
- (void)setInvoice:(AppInvoice*)pInvoice{
    invoice = pInvoice;
    if (blnOrderBuilded){
        [self calculateOrders];
    }
}

////选择收货地址
- (void)clickAddress{
    
    AddressList *addressList = [[AddressList alloc] initWithNibName:@"AddressList" bundle:nil];
    addressList.isSelectAddress = true;
    addressList.selectAddressID = receiver.id;
    [self.navigationController pushViewController:addressList animated:YES];
}

////选择收货地址
//- (IBAction)clickAddress:(UIControl*)view{
//    AddressList *addressList = [[AddressList alloc] initWithNibName:@"AddressList" bundle:nil];
//    addressList.isSelectAddress = true;
//    [self.navigationController pushViewController:addressList animated:YES];
//}

- (void) displayOrderInfo:(OrderBuildResponse2 *)orderBuildResponse{
    
    receiver = orderBuildResponse.defaultAddress;
    if (receiver != nil){
        [self setReceiver:receiver];
    }
    
    if (orderBuildResponse.paymentMethods.count > 0){
        valiablePaymentMethods = orderBuildResponse.paymentMethods;
        paymentMethod = [orderBuildResponse.paymentMethods objectAtIndex:0];
        footerView.lbPaymentMethod.text = paymentMethod.name;
    }
    orders = orderBuildResponse.orders;
    //        NSString *point = @"积分:";
    //        orderFooter.lbPoint.text = [point stringByAppendingString: [NSString stringWithFormat:@"%d",orderBuildResponse.totalPoint]];
    // @"合计:"
    NSString *orderController_orderFooter_lbAmount = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderController_orderFooter_lbAmount"];
    NSString *amount = orderController_orderFooter_lbAmount;
    NSString * ms = [CommonUtils formatCurrency:[orderBuildResponse getTotalAmount]];
    amount = [amount stringByAppendingString: ms];
    NSMutableAttributedString * linkString = [[ NSMutableAttributedString alloc] initWithString:amount];
    NSRange range = [[linkString string]rangeOfString:ms];
    [linkString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:190/255.0 green:21/255.0 blue:35/255.0 alpha:1] range:range];
    orderFooter.lbAmount.attributedText = linkString;
    
    [tableOrders reloadData];
    blnOrderBuilded = true;

}

- (void)loadResponse:(NSString *) url response:(BaseModel *)response{
    
    // @"合计:"
    NSString *orderController_orderFooter_lbAmount = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderController_orderFooter_lbAmount"];
    if ([url isEqual: api_order_build2]){
        OrderBuildResponse2 * orderBuildResponse = (OrderBuildResponse2 *)response;
        
        receiver = orderBuildResponse.defaultAddress;
        if (receiver != nil){
            [self setReceiver:receiver];
        }
        
        if (orderBuildResponse.paymentMethods.count > 0){
            valiablePaymentMethods = orderBuildResponse.paymentMethods;
            paymentMethod = [orderBuildResponse.paymentMethods objectAtIndex:0];
            footerView.lbPaymentMethod.text = paymentMethod.name;
        }
        orders = orderBuildResponse.orders;
//        NSString *point = @"积分:";
//        orderFooter.lbPoint.text = [point stringByAppendingString: [NSString stringWithFormat:@"%d",orderBuildResponse.totalPoint]];
        NSString *amount = orderController_orderFooter_lbAmount;
        orderFooter.lbAmount.text = [amount stringByAppendingString: [CommonUtils formatCurrency:[orderBuildResponse getTotalAmount]]];
        
        [tableOrders reloadData];
        blnOrderBuilded = true;
        
    } else if ([url isEqualToString:api_order_calculate]){
        OrderCalculateResponse2 * orderCalculateResponse = (OrderCalculateResponse2 *)response;
        
        orders = orderCalculateResponse.orders;
//        NSString *point = @"积分:";
//        orderFooter.lbPoint.text = [point stringByAppendingString: [NSString stringWithFormat:@"%d",orderCalculateResponse.totalPoint]];
        NSString *amount = orderController_orderFooter_lbAmount;
        orderFooter.lbAmount.text = [amount stringByAppendingString: [CommonUtils formatCurrency:[orderCalculateResponse getTotalAmount]]];
//        orderFooter.lbAmount.text = [amount stringByAppendingString: [CommonUtils formatCurrency:[orderCalculateResponse getTotalPayableAmount]]];
        [tableOrders reloadData];
    }
    else if([url isEqual:api_order_create2]){
        OrderCreateResponse2 *orderCreateResponse = (OrderCreateResponse2 *)response;
        Status *status = orderCreateResponse.status;
        
        if (status.succeed == 1){
            
            // @"订单创建成功"
            NSString *orderController_toastNotification_msg1 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderController_toastNotification_msg1"];
            // @"订单生成成功"
            NSString *orderController_toastNotification_msg2 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderController_toastNotification_msg2"];
            if ([paymentMethod.method isEqual:@"online"]){
                
                ////**** 展示失效时间 ****/////
                AppOrderInfo *order = [orderCreateResponse.data firstObject];
                ////********/////
                
                PaymentPlugins *plugins = [[PaymentPlugins alloc] init];
                PaymentInfo *paymentInfo = [[PaymentInfo alloc] init];
                float amount = 0;
                NSString *sn = @"";
                for (int i=0; i<orderCreateResponse.data.count; i++){
                    AppOrderInfo *orderInfo = [orderCreateResponse.data objectAtIndex:i];
                    amount = amount + orderInfo.amountPayable.floatValue;
                    sn = [[sn stringByAppendingString:orderInfo.sn] stringByAppendingString:@","];
                }
                if (amount == 0){
                    [CommonUtils ToastNotification:orderController_toastNotification_msg1 andView:self.view andLoading:NO andIsBottom:YES];
                    
                    [self performSelector:@selector(pop4SuccessCreateOrder) withObject:nil afterDelay:2.0f];
                    
                } else {
                    /*UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"购物车" style:UIBarButtonItemStyleDone target:nil action:nil];
                    self.navigationItem.backBarButtonItem = barButtonItem;
                    */
                    paymentInfo.amount = [[NSNumber alloc] initWithFloat:amount];
                    paymentInfo.sn = sn;
                    paymentInfo.type = @"payment";
                    [plugins setPaymentInfo:paymentInfo];
                    plugins.isFromOrderCreateScreen = true;
                    plugins.orderValidMsg = order.orderValidMsg;
                    [self.navigationController pushViewController:plugins animated:YES];
                }
            } else {
                [CommonUtils ToastNotification:orderController_toastNotification_msg2 andView:self.view andLoading:NO andIsBottom:YES];
                [self performSelector:@selector(pop4SuccessCreateOrder) withObject:nil afterDelay:2.0f];
            }
        }
    }
}

- (void)pop4SuccessCreateOrder{
//    NSArray *controllers = [self.navigationController viewControllers];
//    for (UIViewController *controller in controllers){
//        if ([controller isKindOfClass:[CartController class]]){
//            [self.navigationController popToViewController:controller animated:YES];
//            return;
//        }
//    }
//    [self.navigationController popToRootViewControllerAnimated:YES];

    OrderList * orderList = [[OrderList alloc] init];
    orderList.hidesBottomBarWhenPushed = YES;
    orderList.iniType = @"await_ship";
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.backBarButtonItem = barButtonItem;
    [self.navigationController pushViewController:orderList animated:YES];
//    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sendMessage:(Message *)msg{
    if (msg.what == 1){
        //选择配送方式
        AppOrderInfo *order = [orders objectAtIndex:msg.int1];
        ShippingMethods *shippingMethods = [[ShippingMethods alloc] initWithNibName:@"ShippingMethods" bundle:nil];
        shippingMethods.shippingMethods = order.shippingMethods;
        shippingMethods.section = msg.int1;
        [self.navigationController pushViewController:shippingMethods animated:YES];
    } else if (msg.what == 2){
        //select payment method//选择支付方式
        PaymentMethods *paymentMethodsController = [[PaymentMethods alloc] initWithNibName:@"PaymentMethods" bundle:nil];
        paymentMethodsController.paymentMethods = valiablePaymentMethods;
        [self.navigationController pushViewController:paymentMethodsController animated:YES];
    } else if (msg.what == 3){
        //submit order
        if (receiver == nil){
            
            // @"请选择收件地址"
            NSString *orderController_toastNotification_msg3 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderController_toastNotification_msg3"];
            [CommonUtils ToastNotification:orderController_toastNotification_msg3 andView:self.view andLoading:NO andIsBottom:NO];
            return;
        }
        OrderCreateRequest2 *request = [[OrderCreateRequest2 alloc] init];
        NSMutableArray * createOrders = [[NSMutableArray alloc] initWithCapacity:10];
        for (AppOrderInfo *orderInfo in orders){
            AppOrderInfo *newOrder = [[AppOrderInfo alloc] init];
            newOrder.appOrderItems = orderInfo.appOrderItems;
            newOrder.shippingMethod = orderInfo.shippingMethod;
            newOrder.couponCode = orderInfo.couponCode;
            newOrder.memo = orderInfo.memo;
            newOrder.merchantId = orderInfo.merchantId;
//            NSLog(@"lalal---%@",newOrder.memo);
            [createOrders addObject:newOrder];
        }
        request.orders = createOrders;
        request.paymentMethod = paymentMethod;
        request.receiver = receiver;
        request.invoice = invoice;
        request.session = [SESSION getSession];
        request.channel = @"iphone";
        request.isUseBalance = true;
        
        [orderService createOrder2:request];
        
    } else if (msg.what == 4){
        //select Invoice//选择发票信息
        OrderInvoice *orderInvoice = [[OrderInvoice alloc] initWithNibName:@"OrderInvoice" bundle:nil];
        [orderInvoice setInvoice:invoice];
        [self.navigationController pushViewController:orderInvoice animated:YES];
    } else if (msg.what == 5){
        //balance amount used or not
        [self calculateOrders];
    } else if (msg.what == 6){
        //select counpon//选择优惠券
        AppOrderInfo *order = [orders objectAtIndex:msg.int1];

        if (order.validCouponCodes.count < 1) {
            
            // @"抱歉，您没有优惠券"
            NSString *orderController_toastNotification_msg4 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderController_toastNotification_msg4"];
            [CommonUtils ToastNotification:orderController_toastNotification_msg4 andView:self.view andLoading:NO andIsBottom:NO];
        }else{
            CouponCodes *couponCodes = [[CouponCodes alloc] initWithNibName:@"CouponCodes" bundle:nil];
            couponCodes.couponCodes = order.validCouponCodes;
            couponCodes.section = msg.int1;
            [self.navigationController pushViewController:couponCodes animated:YES];
        }

    }else if (msg.what == 7){
        //memo // 留言
        AppOrderInfo * order = [orders objectAtIndex:msg.int1];
        UITextField * txt = (UITextField *)msg.obj;
        order.merchantId = order.merchantId;
        order.memo = txt.text;
        [self calculateOrders];
    }
}

//计算订单
- (void)calculateOrders{
    OrderCalculateRequest2 *request = [[OrderCalculateRequest2 alloc] init];
    NSMutableArray * calculateOrders = [[NSMutableArray alloc] initWithCapacity:10];
    for (AppOrderInfo *orderInfo in orders){
        
//        NSLog(@"++%@",orderInfo.memo);
        AppOrderInfo *newOrder = [[AppOrderInfo alloc] init];
        newOrder.appOrderItems = orderInfo.appOrderItems;
        newOrder.shippingMethod = orderInfo.shippingMethod;
        newOrder.couponCode = orderInfo.couponCode;
        newOrder.memo = orderInfo.memo;
        newOrder.merchantId = orderInfo.merchantId;
        [calculateOrders addObject:newOrder];
    }
    request.orders = calculateOrders;
//    request.orders = orders;
    request.paymentMethod = paymentMethod;
    request.invoice = invoice;
    request.receiver = receiver;
    request.isUseBalance = false;
    request.session = [SESSION getSession];
    [orderService calculateOrders:request];
}
#pragma TableView的处理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return orders.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    AppOrderInfo *order = [orders objectAtIndex:section];
    return order.appOrderItems.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TMScreenH *85/568;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return TMScreenH *25/568;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (orders.count - 1 == section) {
        
        return TMScreenH *235/568+10;
    } else {
        return TMScreenH *161/568;
    }
    
}

- ( UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    AppOrderInfo *orderInfo = [orders objectAtIndex:section];
    OrderItemHeader *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"OrderItemHeader"];
    
    if (headerView == nil)
    {
        //headerView = [[CartItemHeader alloc] initWithReuseIdentifier:@"CartItemHeader"];
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"OrderItemHeader" owner:self options:nil];
        for (NSObject *o in objects) {
            if ([o isKindOfClass:[OrderItemHeader class]]) {
                headerView = (OrderItemHeader *)o;
                break;
            }
        }
    }
//    headerView.merchantName.text = [@"      " stringByAppendingString:orderInfo.shopName];
    headerView.merchantName.text = orderInfo.shopName;
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    AppOrderInfo *orderInfo = [orders objectAtIndex:section];
    footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"OrderItemFooter"];
    
    if (footerView == nil)
    {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"OrderItemFooter" owner:self options:nil];
        for (NSObject *o in objects) {
            if ([o isKindOfClass:[OrderItemFooter class]]) {
                footerView = (OrderItemFooter *)o;
                footerView.msgHandler = self;
                break;
            }
        }
    }
    if (orderInfo.couponCode != nil){
        [footerView.btnCouponName addTarget:self action:@selector(nibBundle) forControlEvents:UIControlEventTouchUpInside];
//        [[[orderInfo.couponCode.coupon.name stringByAppendingString:@"(优惠:"] stringByAppendingString:[CommonUtils formatCurrency:orderInfo.couponDiscount]] stringByAppendingString:@")"];
        // @"%@(优惠:%@)"
        NSString *orderController_footerView_lbCouponName = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderController_footerView_lbCouponName"];
        footerView.lbCouponName.text = [NSString stringWithFormat:orderController_footerView_lbCouponName, orderInfo.couponCode.coupon.name, [CommonUtils formatCurrency:orderInfo.couponDiscount]];
    }
    NSString* shippingMethodName =orderInfo.shippingMethod.name;
//    if (shippingMethodName != nil){
//        shippingMethodName = [[[shippingMethodName stringByAppendingString:@"("] stringByAppendingString:[CommonUtils formatCurrency:orderInfo.freight]] stringByAppendingString:@")"];
//    }
    // @"%@(包邮)"
    NSString *orderController_footerView_lbFreight = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderController_footerView_lbFreight"];
    if ([orderInfo.freight intValue] > 0) {
        footerView.lbFreight.text = [NSString stringWithFormat:@"%@(%@)",shippingMethodName,[CommonUtils formatCurrency:orderInfo.freight]];
    }else {
        footerView.lbFreight.text = [NSString stringWithFormat:orderController_footerView_lbFreight,shippingMethodName];
    }
    
    // @"合计 %@"
    NSString *orderController_footerView_lblItemTotal1 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderController_footerView_lblItemTotal1"];
    // @"已优惠%@  合计 %@"
    NSString *orderController_footerView_lblItemTotal2 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderController_footerView_lblItemTotal2"];
    NSString * mStr = [CommonUtils formatCurrency:orderInfo.amount];
    NSString * bigFont = [NSString stringWithFormat:orderController_footerView_lblItemTotal1,mStr];

    NSMutableAttributedString * linkString;
    
    if ([orderInfo.promotionDiscount intValue] > 0) {
        linkString = [[ NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:orderController_footerView_lblItemTotal2,[CommonUtils formatCurrency:orderInfo.promotionDiscount],mStr]];
    }else{
        linkString = [[ NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:orderController_footerView_lblItemTotal1,mStr]];
    }

    NSRange range = [[linkString string]rangeOfString:mStr];
    NSRange bigRange = [[linkString string] rangeOfString:bigFont];
    [linkString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:190/255.0 green:21/255.0 blue:35/255.0 alpha:1] range:range];
    [linkString addAttribute:NSFontAttributeName value:[UIFont systemFontWithSize:15] range:bigRange];
    footerView.lblItemTotal.attributedText = linkString;
    
    if (orderInfo.memo) {
        footerView.txtBuyerMessage.text = orderInfo.memo;
    }
//    NSLog(@"留言：%@",orderInfo.memo);
    
    if (orders.count - 1 == section) {
        
        footerView.lbPaymentMethod.text = paymentMethod.name;
        
        // @"普通发票"
        NSString *orderController_footerView_lbInvoice1 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderController_footerView_lbInvoice1"];
        // @"增值税发票"
        NSString *orderController_footerView_lbInvoice2 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderController_footerView_lbInvoice2"];
        // @"不需要发票"
        NSString *orderController_footerView_lbInvoice3 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderController_footerView_lbInvoice3"];
        if ([invoice.invoiceType isEqualToString:@"REG"]){
            footerView.lbInvoice.text = orderController_footerView_lbInvoice1;
        } else if ([invoice.invoiceType isEqualToString:@"VAT"]){
            footerView.lbInvoice.text = orderController_footerView_lbInvoice2;
        }else{
            footerView.lbInvoice.text = orderController_footerView_lbInvoice3;
        }
        
    } else {
        
        [footerView removeConstraint:footerView.paymentViewTopMarginConstraint];
        [footerView.payMentView removeFromSuperview];
        [footerView.invoiceView removeFromSuperview];
    }
    
    footerView.section = section;
    
    return footerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppOrderInfo *order = [orders objectAtIndex:indexPath.section];
    OrderItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderItemCell"];
    if (!cell) {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"OrderItemCell" owner:self options:nil];
        for (NSObject *o in objects) {
            if ([o isKindOfClass:[OrderItemCell class]]) {
                cell = (OrderItemCell *)o;
                [cell myinit];
                break;
            }
        }
        AppOrderItem *orderItem =[order.appOrderItems objectAtIndex:[indexPath row]];
        cell.lbQuantity.text = [@"X" stringByAppendingString:[NSString stringWithFormat:@"%d", orderItem.quantity]];
        cell.lbProdName.text = orderItem.appProduct.fullName;
        cell.lbProdSize.text = orderItem.appProduct.specificationName;
        NSString * str = [CommonUtils formatCurrency:orderItem.appProduct.price];
        
        cell.lbOldPrice.attributedText = [CommonUtils addDeleteLineOnLabel:str];
        cell.lbPrice.text = [CommonUtils formatCurrency:orderItem.finalPrice];
        if ([str isEqualToString:cell.lbPrice.text]){
            cell.lbOldPrice.text = @"";
        }
        cell.image.imageURL = [NSURL URLWithString:orderItem.appProduct.image];
        
        cell.tag = orderItem.appProduct.id;
    }
    
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
