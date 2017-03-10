//
//  PaymentPlugins.m
//  eshop
//
//  Created by mc on 15/11/1.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import "PaymentPlugins.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "WXApiObject.h"
#import "WXApiManager.h"

#import "UINavigationController+FDFullscreenPopGesture.h"

@interface PaymentPlugins ()

@end

@implementation PaymentPlugins
@synthesize tablePlugins;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // @"在线支付"
    NSString *paymentPlugins_navItem_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"paymentPlugins_navItem_title"];
    self.navigationItem.title = paymentPlugins_navItem_title;
    //self.navigationItem.hidesBackButton = YES;
    [super addNavBackButton];
    // Do any additional setup after loading the view from its nib.
    pluginList= [[NSMutableArray alloc] initWithCapacity:10];
    paymentService = [[PaymentService alloc] initWithDelegate:self parentView:self.view];
    pluginService = [[PluginService alloc] initWithDelegate:self parentView:self.view];
    [pluginService getPaymentPlugins];
    
    self.fd_interactivePopDisabled = YES;
    
    //通知向后传值
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(abc:) name:@"push" object:nil];
}


- (void)backButtonClick:(UIButton *)button{
    
    // @"确定要放弃付款?"
    NSString *paymentPlugins_alert_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"paymentPlugins_alert_title"];
    // @"该订单23小时59分钟后将被取消，请尽快完成付款"
    NSString *paymentPlugins_alert_message = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"paymentPlugins_alert_message"];
    // @"继续支付"
    NSString *paymentPlugins_alert_cancelTitle = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"paymentPlugins_alert_cancelTitle"];
    // @"放弃付款"
    NSString *paymentPlugins_alert_otherTitle = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"paymentPlugins_alert_otherTitle"];
//    self.orderValidMsg
    if (_isFromOrderCreateScreen){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:paymentPlugins_alert_title
                                                        message:self.orderValidMsg
                                                       delegate:self
                                              cancelButtonTitle:paymentPlugins_alert_cancelTitle
                                              otherButtonTitles:paymentPlugins_alert_otherTitle, nil];
        [alert show];
    } else {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1){
        NSArray *controllers = self.navigationController.viewControllers;
//        [controllers]
//
//        for (UIViewController *controller in controllers){
//            if ([controller isKindOfClass:[CartController class]]){
                OrderList * orderList = [[OrderList alloc] init];
                orderList.hidesBottomBarWhenPushed = YES;
                orderList.iniType = @"await_pay";
//                UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:nil action:nil];
//                self.navigationItem.backBarButtonItem = barButtonItem;
                [self.navigationController pushViewController:orderList animated:YES];
//                [self.navigationController popToViewController:controller animated:YES];
        
//                return;
//            }
//        }
//
//        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)setPaymentInfo:(PaymentInfo*)ppaymentInfo{
    paymentInfo = ppaymentInfo;
}


- (void)loadResponse:(NSString *) url response:(BaseModel *)response{
    
    if ([url isEqual: api_payment_plugins]){
        PaymentPluginListResponse * pluginListResponse = (PaymentPluginListResponse *)response;
        [pluginList addObjectsFromArray:pluginListResponse.data];
        [tablePlugins reloadData];
        
    } else if ([url isEqualToString:api_online_pay]){
        OnlinePayResponse *respobj = (OnlinePayResponse*)response;
        NSString *scheme = @"eshoptoolmall";
        if (respobj.status.succeed == 1){
            
            if ([response.paymentPluginId isEqualToString:@"alipayDirectPlugin"]) {
                
                NSString *orderStr = [respobj.data objectForKey:@"param"];
                [[AlipaySDK defaultService] payOrder:orderStr fromScheme:scheme callback:^(NSDictionary *resultDic) {
//                    NSLog(@"reslut = %@",resultDic);
//                    NSLog(@"reslut = %@",resultDic[@"memo"]);
                    NSString *resultStatus = [resultDic objectForKey:@"resultStatus"];
                    
                    if ([resultStatus isEqualToString:@"9000"]){
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"push" object:@"1"];
                    }
                    else {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"push" object:@"0"];
                    }
                    
                    
                }];
            }
            if ([response.paymentPluginId isEqualToString:@"cmbpayPlugin"]) {
                
//                NSString *orderStr = [respobj.data objectForKey:@"param"];
//                NSString *orderStr1 = [respobj.data objectForKey:@"param1"];
            }
            if ([response.paymentPluginId isEqualToString:@"weixinpayPlugin"]) {
                
                [WXApiManager sharedManager];
                
                PayReq* req = [[PayReq alloc] init];
                req.partnerId = [respobj.data objectForKey:@"partner_id"];
                req.prepayId = [respobj.data objectForKey:@"prepay_id"];
                req.nonceStr = [respobj.data objectForKey:@"nonce_str"];
                req.timeStamp = [[respobj.data objectForKey:@"timeStamp"] intValue];
                req.package = [respobj.data objectForKey:@"packageValue"];
                req.sign = [respobj.data objectForKey:@"sign"];
                
                [WXApi sendReq:req];
                //日志输出
//                NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",[respobj.data objectForKey:@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
            }
        }
    }
}

// WX/ali - 支付成功后回调方法
-(void)abc:(NSNotification *)noti
{
    if ([noti.object intValue]==1)
    {
        if ([paymentInfo.type isEqualToString:@"recharge"]){
            
            [self.navigationController popViewControllerAnimated:YES];
            [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        }
        if ([paymentInfo.type isEqualToString:@"payment"]){
            OrderList * orderList = [[OrderList alloc] init];
            orderList.hidesBottomBarWhenPushed = YES;
            orderList.iniType = @"await_ship";
            [self.navigationController pushViewController:orderList animated:YES];
        }
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return pluginList.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppPaymentPlugin *plugin = [pluginList objectAtIndex:indexPath.row];
    PaymentPluginCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PaymentPluginCell"];
    if (!cell) {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"PaymentPluginCell" owner:self options:nil];
        for (NSObject *o in objects) {
            if ([o isKindOfClass:[PaymentPluginCell class]]) {
                cell = (PaymentPluginCell *)o;
                break;
            }
        }
    }
    
    [cell setPlugin:plugin];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            {
                AppPaymentPlugin *plugin = [pluginList objectAtIndex:indexPath.row];
                [paymentService onlinePay:paymentInfo.type paymentPluginId:plugin.pluginId sn:paymentInfo.sn amount:paymentInfo.amount];
            }
            break;
        case 1:
            {
                AppPaymentPlugin *plugin = [pluginList objectAtIndex:indexPath.row];
//                NSLog(@"pluginId:%@", plugin.pluginId);
//                NSLog(@"%@ - %@ - %@ - %@", paymentInfo.type, paymentInfo.sn, paymentInfo.amount ,plugin.pluginId );
                [paymentService onlinePay:paymentInfo.type paymentPluginId:plugin.pluginId sn:paymentInfo.sn amount:paymentInfo.amount];
            }
            break;
        case 2:
        {
            AppPaymentPlugin *plugin = [pluginList objectAtIndex:indexPath.row];
            //                NSLog(@"pluginId:%@", plugin.pluginId);
//            NSLog(@"%@ - %@ - %@ - %@", paymentInfo.type, paymentInfo.sn, paymentInfo.amount ,plugin.pluginId );
            [paymentService onlinePay:paymentInfo.type paymentPluginId:plugin.pluginId sn:paymentInfo.sn amount:paymentInfo.amount];
        }
            break;
        default:
            break;
    }
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
