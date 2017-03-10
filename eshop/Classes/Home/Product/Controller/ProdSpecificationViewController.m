//
//  ProdSpecificationViewController.m
//  eshop
//
//  Created by mc on 16/3/9.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import "ProdSpecificationViewController.h"


@interface ProdSpecificationViewController ()

@property (nonatomic, assign) int productIdOC;

@end

@implementation ProdSpecificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib
    [CommonUtils decrateImageGaryBorder:self.prodImage];
   
}
- (instancetype)myInitWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil product:(AppProduct *)product{
    myproduct = product;
    //    self.contentSizeInPopup = CGSizeMake([UIScreen mainScreen].applicationFrame.size.width, 400);

#pragma mark - 弹出框整体高度frame
    if (myproduct.appGoods.appSpecifications.count > 0){
        self.contentSizeInPopup = CGSizeMake([UIScreen mainScreen].applicationFrame.size.width,  TMScreenH *400/568);
    } else {
        self.contentSizeInPopup = CGSizeMake([UIScreen mainScreen].applicationFrame.size.width,  TMScreenH *260/568);
    }
    
    //    self.landscapeContentSizeInPopup = CGSizeMake(320, 200);
    self.landscapeContentSizeInPopup = CGSizeMake(TMScreenW *320/320, 0);
    return [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIWebView*)newCordovaViewWithFrame:(CGRect)bounds
{
    //    return [[UIWebView alloc] initWithFrame:CGRectMake(0, 120, [UIScreen mainScreen].applicationFrame.size.width, 280)];
    
#pragma mark - 弹出框webView高度frame

    if (myproduct.appGoods.appSpecifications.count > 0){
        return [[UIWebView alloc] initWithFrame:CGRectMake(0,  TMScreenH *120/568, [UIScreen mainScreen].applicationFrame.size.width,  TMScreenH *280/568)];
    } else {
        return [[UIWebView alloc] initWithFrame:CGRectMake(0,  TMScreenH *120/568, [UIScreen mainScreen].applicationFrame.size.width,  TMScreenH *140/568)];

    }
}

- (void)setProduct:(AppProduct*)product
{
    [self.lbPrice setTextColor:TMRedColor];
    // 设置webView交互代理
    [SelProdSpecPlugin setMSG_HANDLER:self];
    self.prodImage.imageURL = [NSURL URLWithString:product.image];
//    if ([product.appGoods.minPrice isEqualToNumber:product.appGoods.maxPrice]){
//        [self.lbPrice setText:[CommonUtils formatCurrency:product.price ]];
//    } else {
//        NSString *priceRange = [[NSString alloc] initWithFormat:@"%@ - %@", [CommonUtils formatCurrency:product.appGoods.minPrice ], product.appGoods.maxPrice ];
//        [self.lbPrice setText:priceRange];
//    }
    if (product.secondProductInfo.secondPrice) {
        [self.lbPrice setText:[CommonUtils formatCurrency:product.secondProductInfo.secondPrice]];
    }
    else if (product.promotionPrice){
        [self.lbPrice setText:[CommonUtils formatCurrency:product.promotionPrice]];
    }
    else {
        [self.lbPrice setText:[CommonUtils formatCurrency:product.price]];
    }
    
//    [self.lbPrice setText:[CommonUtils formatCurrency:product.price]];
    
    if (product.specificationName) {
        
        // @"已选 "
        NSString *prodSpecificationVC_lbSpecs_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"prodSpecificationVC_lbSpecs_title"];
        NSString *strSpecValues = prodSpecificationVC_lbSpecs_title;
        NSArray *specificationNameArray = [product.specificationName componentsSeparatedByString:@":"];
        //去掉字符串左右两边的空格
        NSString *specification = [specificationNameArray.lastObject stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        strSpecValues = [NSString stringWithFormat:@"%@\"%@\"", strSpecValues, specification];
        [self.lbSpecs setText:strSpecValues];
        [self.webView.scrollView setScrollEnabled:false];
    }
    // 获取当前商品默认ID
    self.productIdOC = product.id;
}

- (void)sendMessage:(Message *)msg{
    NSArray *args = (NSArray*)msg.obj;
    if (msg.what == 1){
        //选择规格
        NSString *strProductId = [args objectAtIndex:0];
        int productId = [strProductId intValue];
        Message *msg = [[Message alloc] init];
        msg.what = 2;
        msg.int1 = productId;
        
        // @"选择 "
        NSString *prodSpecificationVC_errmsg_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"prodSpecificationVC_errmsg_title"];
        // @"已选 "
        NSString *prodSpecificationVC_lbSpecs_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"prodSpecificationVC_lbSpecs_title"];
        if (productId <= 0){
            NSString *errmsg = prodSpecificationVC_errmsg_title;
            errmsg = [errmsg stringByAppendingString:[args objectAtIndex:5]];
            msg.obj = errmsg;
            
            //MyToastView.toast(ProductSpecificationPopup.this.context, errMsg);
        } else {
            NSString *strPrice = @"￥";
            NSString *arg1 = [(NSNumber*)[args objectAtIndex:1] stringValue];
            strPrice = [strPrice stringByAppendingString:arg1];
            msg.int2 = [[args objectAtIndex:3] intValue];
            [self.lbPrice setText:[CommonUtils formatCurrency:(NSNumber*)[args objectAtIndex:1]]];
            NSString *strSpecValues = prodSpecificationVC_lbSpecs_title;
            strSpecValues = [strSpecValues stringByAppendingString:[args objectAtIndex:4]];
            [self.lbSpecs setText:strSpecValues];
            msg.obj = strSpecValues;
        }
        [self.msgHandler sendMessage:msg];
    } else if (msg.what == 2){
        //add to cart or buy
        NSString *strProductId = [args objectAtIndex:0];
        int productId = [strProductId intValue];
        
        if (productId <= 0){
//            NSString *errmsg = [args objectAtIndex:2];
//            [CommonUtils ToastNotification:errmsg andView:self.view andLoading:NO andIsBottom:NO];
            Message *msg = [[Message alloc] init];
            msg.what = 3;
            msg.int1 = self.productIdOC;
            msg.int2 = [(NSNumber*)[args objectAtIndex:1] intValue];
            [self.msgHandler sendMessage:msg];
            
        } else {
            Message *msg = [[Message alloc] init];
            msg.what = 3;
            msg.int1 = productId;
            msg.int2 = [(NSNumber*)[args objectAtIndex:1] intValue];
            [self.msgHandler sendMessage:msg];
        }
    }
}

- (IBAction)clickClosePopup:(UIButton *)sender{
    Message *msg = [[Message alloc] init];
    msg.what = 4;
    [self.msgHandler sendMessage:msg];
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
