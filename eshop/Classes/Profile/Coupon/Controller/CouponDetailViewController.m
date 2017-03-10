//
//  CouponDetailViewController.m
//  eshop
//
//  Created by mc on 16/3/17.
//  Copyright (c) 2016年 hzlg. All rights reserved.
//

#import "CouponDetailViewController.h"

@interface CouponDetailViewController ()

@property (weak, nonatomic) IBOutlet UIButton *btn1;

@end

@implementation CouponDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addNavBackButton];
    
    // @"优惠券兑换"
    NSString *couponDetailVC_navItem_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"couponDetailVC_navItem_title"];
    self.navigationItem.title = couponDetailVC_navItem_title;
    
    [self setTextValue];
    
    couponService = [[CouponService alloc] initWithDelegate:self parentView:self.view];
    if (self.couponId > 0){
        [couponService getCouponInfo:self.couponId];
    } else {
        [couponService getCouponInfoByCode:self.exchangeCode];
    }
}

- (IBAction)clickButtons:(UIButton*)sender{
    if (sender.tag == 1){
        
        if (![CommonUtils chkLogin:self gotoLoginScreen:YES]) {
            // @"请先登录，然后再领取优惠券"
            NSString *couponDetailVC_toastNotification_msg1 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"couponDetailVC_toastNotification_msg1"];
            [CommonUtils ToastNotification:couponDetailVC_toastNotification_msg1 andView:self.view andLoading:NO andIsBottom:NO];
            return;
        }
        [couponService exchange:coupon.id];
    }
}

- (void)loadResponse:(NSString *) url response:(BaseModel *)response{
    
    // @"满%@元可用"
    NSString *couponDetailVC_lbMinPrice_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"couponDetailVC_lbMinPrice_title"];
    // @"兑换成功"
    NSString *couponDetailVC_toastNotification_msg2 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"couponDetailVC_toastNotification_msg2"];
    if ([url isEqual:api_coupon_info]){
        CouponInfoResponse * respobj = (CouponInfoResponse *)response;
        coupon = respobj.data;
        self.lbDecreasePrice.text = [CommonUtils formatCurrency:coupon.decreasePrice];
        NSString *minPrice = [[NSString alloc] initWithFormat:couponDetailVC_lbMinPrice_title, coupon.minimumPrice];
        self.lbMinPrice.text = minPrice;
        self.lbName.text = coupon.name;
        self.lbSubTitle.text = coupon.subTitle;
        self.lbUseScopeName.text = coupon.useScopeName;
    }
    else if ([url isEqual:api_coupon_info_bycode]){
        CouponInfoResponse * respobj = (CouponInfoResponse *)response;
        coupon = respobj.data;
        self.lbDecreasePrice.text = [CommonUtils formatCurrency:coupon.decreasePrice];
        NSString *minPrice = [[NSString alloc] initWithFormat:couponDetailVC_lbMinPrice_title, coupon.minimumPrice];
        self.lbMinPrice.text = minPrice;
        self.lbName.text = coupon.name;
        self.lbSubTitle.text = coupon.subTitle;
        self.lbUseScopeName.text = coupon.useScopeName;
    } else if ([url isEqual:api_coupon_exchange]){
        MapResponse *respobj = (MapResponse*)response;
        if ([respobj getStatus].succeed == 1){
            [CommonUtils ToastNotification:couponDetailVC_toastNotification_msg2 andView:self.view andLoading:NO andIsBottom:NO];
            NSArray *controllers = [self.navigationController viewControllers];
            for (UIViewController *controller in controllers){
                if ([controller isKindOfClass:[CouponCodeList class]]){
                    [self.navigationController popToViewController:controller animated:YES];
                    return;
                }
            }
           } else {
            [CommonUtils ToastNotification:[respobj getStatus].error_desc andView:self.view andLoading:NO andIsBottom:NO];
        }
    }
}

#pragma mark - setTextValue文案配置
- (void)setTextValue {
    
    // 立即领取
    NSString *couponDetailVC_btn_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"couponDetailVC_btn_title"];
    [self.btn1 setTitle:couponDetailVC_btn_title forState:(UIControlStateNormal)];
}

@end
