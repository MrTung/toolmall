//
//  ScanResultViewController.m
//  LBXScanDemo
//
//  Created by lbxia on 15/11/17.
//  Copyright © 2015年 lbxia. All rights reserved.
//

#import "ScanResultViewController.h"

#import "CouponDetailViewController.h"

@interface ScanResultViewController ()

//@property (weak, nonatomic) IBOutlet UIImageView *scanImg;
@property (weak, nonatomic) IBOutlet UILabel *labelScanText;
//@property (weak, nonatomic) IBOutlet UILabel *labelScanCodeType;
@end

@implementation ScanResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.navigationItem.title = @"扫描结果";
    UILabel * nTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    nTitle.text = @"扫描结果";
    nTitle.textAlignment = NSTextAlignmentCenter;
    nTitle.textColor = [UIColor colorWithRed:37/255.0 green:38/255.0 blue:37/255.0 alpha:1];
    nTitle.font = [UIFont systemFontOfSize:20];
    self.navigationItem.titleView = nTitle;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    /*
//    if ([_strScan hasPrefix:website_url]){
//        
//        NSString *produrl = [website_url stringByAppendingString:@"product/content/"];
//        if ([_strScan hasPrefix:produrl]){
//            NSArray *array = [_strScan componentsSeparatedByString:@"/"];
//            NSString *productStr = [array objectAtIndex:array.count - 1];
//            productStr = [productStr stringByReplacingOccurrencesOfString:@".html" withString:@""];
//            int prodId = [productStr intValue];
//            //            ProdInfo *prodInfo = [[ProdInfo alloc] init];
//            
//            ProductInfoViewController * prodInfo = [[ProductInfoViewController alloc]init];
//            prodInfo.productId = prodId;
//            [self.navigationController pushViewController:prodInfo animated:YES];
//            
//        } else {
//            //            ScanResult *scanResult = [[ScanResult alloc] init];
//            //            scanResult.result = url;
//            //            [self.navigationController pushViewController:scanResult animated:YES];
//            
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_strScan]];
//            
//        }
//    } else if ([_strScan hasPrefix:@"couponExchangeByCode"]){
//        NSArray *array = [_strScan componentsSeparatedByString:@":"];
//        NSString *exchangeCode = [array objectAtIndex:array.count - 1];
//        CouponDetailViewController *couponDetail = [[CouponDetailViewController alloc] init];
//        couponDetail.exchangeCode = exchangeCode;
//        [self.navigationController pushViewController:couponDetail animated:YES];
//    }
//    
//    //    其他二维码
//    else
    */
    
    self.labelScanText.text = _strScan;
    if ([_strScan hasPrefix:@"http"]){
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"可能存在风险，是否继续打开网址:%@", _strScan] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"打开", nil];
        
        [alert show];
        
    }
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        [self.navigationController popViewControllerAnimated:NO];
        return;
    }else if (buttonIndex == 1){

        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_strScan]];
    }
}

@end
