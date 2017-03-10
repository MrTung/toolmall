//
//  CouponExchangeByCodeViewController.m
//  eshop
//
//  Created by mc on 16/3/17.
//  Copyright (c) 2016年 hzlg. All rights reserved.
//

#import "CouponExchangeByCodeViewController.h"

@interface CouponExchangeByCodeViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnHeightConstraint;

@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UIButton *btn1;

@end

@implementation CouponExchangeByCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addNavBackButton];
    
    // @"优惠券兑换"
    NSString *couponExchangeByCodeVC_navItem_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"couponExchangeByCodeVC_navItem_title"];
    self.navigationItem.title = couponExchangeByCodeVC_navItem_title;
    couponService = [[CouponService alloc] initWithDelegate:self parentView:self.view];
    
    self.btnHeightConstraint.constant = TMScreenH *30/568;
    
    [self setTextValue];
    
    [self updateViewConstraints];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickButtons:(UIButton*)sender{
    if (sender.tag == 1){
        if (self.tf_exchangeCode.text.length == 0){
            // @"请输入兑换码"
            NSString *couponExchangeByCodeVC_toastNotification_msg1 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"couponExchangeByCodeVC_toastNotification_msg1"];
            [CommonUtils ToastNotification:couponExchangeByCodeVC_toastNotification_msg1 andView:self.view andLoading:NO andIsBottom:NO];
            return;
        }
        [couponService exchangebycode:self.tf_exchangeCode.text];
    } else if (sender.tag == 2){
//        CodeScan *camerScan = [[CodeScan alloc] init];
//        camerScan.navigationItem.backBarButtonItem.tintColor = [UIColor blackColor];
//        [self.navigationController pushViewController:camerScan animated:YES];
        [self clickScanByCoupon];
    }
}

- (void)clickScanByCoupon {
    
    //    CodeScan *camerScan = [[CodeScan alloc] init];
    //    camerScan.navigationItem.backBarButtonItem.tintColor = [UIColor blackColor];
    //    [self.navigationController pushViewController:camerScan animated:YES];
    //
    
    //设置扫码区域参数
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    style.centerUpOffset = 60;
    style.xScanRetangleOffset = 30;
    
    if ([UIScreen mainScreen].bounds.size.height <= 480 )
    {
        //3.5inch 显示的扫码缩小
        style.centerUpOffset = 40;
        style.xScanRetangleOffset = 20;
    }
    
    
    style.alpa_notRecoginitonArea = 0.6;
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Inner;
    style.photoframeLineW = 2.0;
    style.photoframeAngleW = 16;
    style.photoframeAngleH = 16;
    
    style.isNeedShowRetangle = NO;
    
    style.anmiationStyle = LBXScanViewAnimationStyle_NetGrid;
    
    //使用的支付宝里面网格图片
    UIImage *imgFullNet = [UIImage imageNamed:@"qrcode_scan_full_net"];
    style.animationImage = imgFullNet;
    
    [self openScanVCWithStyle:style];
}

- (void)openScanVCWithStyle:(LBXScanViewStyle*)style
{
    SubLBXScanViewController *vc = [SubLBXScanViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    vc.style = style;
    //    vc.isQQSimulator = YES;
    //vc.isOpenInterestRect = YES;
    [self.navigationController pushViewController:vc animated:NO];
}



- (void)loadResponse:(NSString *) url response:(BaseModel *)response{
    if ([url isEqual:api_coupon_exchangebycode]){
        MapResponse *respobj = (MapResponse*)response;
        if ([respobj getStatus].succeed == 1){
            // @"兑换成功"
            NSString *couponExchangeByCodeVC_toastNotification_msg2 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"couponExchangeByCodeVC_toastNotification_msg2"];
            [CommonUtils ToastNotification:couponExchangeByCodeVC_toastNotification_msg2 andView:self.view andLoading:NO andIsBottom:NO];
        } else {
            [CommonUtils ToastNotification:[respobj getStatus].error_desc andView:self.view andLoading:NO andIsBottom:NO];
        }
    }
}


#pragma mark - setTextValue文案配置
- (void)setTextValue {
    
    // 领券购物更实惠
    NSString *couponExchangeByCodeVC_label_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"couponExchangeByCodeVC_label_title"];
    // 立即兑换
    NSString *couponExchangeByCodeVC_btn_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"couponExchangeByCodeVC_btn_title"];
    
    self.label1.text = couponExchangeByCodeVC_label_title;
    [self.btn1 setTitle:couponExchangeByCodeVC_btn_title forState:(UIControlStateNormal)];
    
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
