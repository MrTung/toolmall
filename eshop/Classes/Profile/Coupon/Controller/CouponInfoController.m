//
//  CouponDetailViewController.m
//  eshop
//
//  Created by mc on 16/3/17.
//  Copyright (c) 2016年 hzlg. All rights reserved.
//

#import "CouponInfoController.h"

#import "ProductInfoViewController.h"
#import "UIFont+Fit.h"

@interface CouponInfoController ()
{
    CouponService *couponService;
    AppCouponCode *couponCode;
    NSMutableArray * arrayProducts;
    ProductService * productService;
}

@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;

@end

@implementation CouponInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavBackButton];
    
    [self setTextValue];
    
    // @"优惠券详情"
    NSString *couponInfoController_navItem_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"couponInfoController_navItem_title"];
    self.navigationItem.title = couponInfoController_navItem_title;
    
    // 发起请求获取数据
    couponService = [[CouponService alloc] initWithDelegate:self parentView:self.view];
    productService = [[ProductService alloc] initWithDelegate:self parentView:self.view];
    arrayProducts = [[NSMutableArray alloc] initWithCapacity:4];
    Pagination * pagination = [[Pagination alloc] init];
    [couponService getCouponCodeInfo:self.couponId];
    [productService getProductList:nil activityId:nil productCategoryId:nil promotionId:nil tagId:nil attributes:nil orderType:nil pagination:pagination couponId:self.couponId];
}

- (void)loadResponse:(NSString *) url response:(BaseModel *)response{
    if ([url isEqual:api_couponcode_view]){
        CouponCodeInfoResponse * respobj = (CouponCodeInfoResponse *)response;
        couponCode = respobj.data;
        // @"满%@元可用"
        NSString *couponInfoController_lbMinPrice_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"couponInfoController_lbMinPrice_title"];
        // @"共%@份"
        NSString *couponInfoController_lblCouponCount_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"couponInfoController_lblCouponCount_title"];
        // @"共%@份 (%@)"
        NSString *couponInfoController_lblCouponCount2_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"couponInfoController_lblCouponCount2_title"];
        
        // @"使用期限: %@-%@"
        NSString *couponInfoController_lblUsingLimitedDate_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"couponInfoController_lblUsingLimitedDate_title"];
        // @"使用范围: %@"
        NSString *couponInfoController_lblUsingRange_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"couponInfoController_lblUsingRange_title"];
        // @"使用平台: %@"
        NSString *couponInfoController_lblUsinPlatform_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"couponInfoController_lblUsinPlatform_title"];
        // @"1、%@，仅能在土猫网使用"
        NSString *couponInfoController_lblUsingDescLimitOne_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"couponInfoController_lblUsingDescLimitOne_title"];     self.lbName.text = [CommonUtils formatCurrency:couponCode.coupon.decreasePrice];
        self.lbMinPrice.text = [NSString stringWithFormat:couponInfoController_lbMinPrice_title,couponCode.coupon.minimumPrice];
        
        self.lblCouponCount.text = [NSString stringWithFormat:couponInfoController_lblCouponCount_title,couponCode.ownNumber];
        
        if (couponCode.coupon.useScopeName) {
            self.lblCouponCount.text = [NSString stringWithFormat:couponInfoController_lblCouponCount2_title,couponCode.ownNumber, couponCode.coupon.useScopeName];
        }
        
        self.lblUsingLimitedDate.text = [NSString stringWithFormat:couponInfoController_lblUsingLimitedDate_title,[CommonUtils changeDateFormatLineWithDot:couponCode.beginUseDate],[CommonUtils changeDateFormatLineWithDot: couponCode.endUseDate]];
        
        self.lblCouponName.text = couponCode.coupon.subTitleBrief;
        self.lblUsingRange.text = [NSString stringWithFormat:couponInfoController_lblUsingRange_title,couponCode.coupon.useScopeName];
        self.lblUsinPlatform.text = [NSString stringWithFormat:couponInfoController_lblUsinPlatform_title,couponCode.coupon.usePlatformName];
        
        self.lblUsingDescLimitOne.text = [NSString stringWithFormat:couponInfoController_lblUsingDescLimitOne_title,couponCode.coupon.subTitleBrief];
        
    }
    else if ([url isEqual:api_product_list]){
        ProductListResponse * respobj = (ProductListResponse *)response;
        [arrayProducts removeAllObjects];
        [arrayProducts addObjectsFromArray:respobj.data];
        if (arrayProducts.count > 0) {
            [self configProductCanUseCoupon];
            self.viewPro.hidden = NO;
        }else{
            self.viewPro.hidden = YES;
            self.conViewDescTop.constant = 0;
        }
    }
}

//配置可以使用优惠券的商品图片
- (void)configProductCanUseCoupon{
    
    for (UIView * e in self.viewPro.subviews) {
        if ([e isKindOfClass:[EGOImageView class]]) {
            [e removeFromSuperview];
        }
    }
    CGFloat imgeW = (kWidth - 10*4 -5*3)/4.0;
    for (int i = 0; i<arrayProducts.count; i++) {
        if ( i == 4) {
            break;
        }
        
        AppProduct * p = [arrayProducts objectAtIndex:i];
        EGOImageView * image = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"index_defImage"]];
        image.frame = CGRectMake(10 + i%4*(imgeW+5), 30, imgeW, imgeW);
        image.imageURL = [URLUtils createURL:p.image];
        [CommonUtils decrateImageGaryBorder:image];
        image.userInteractionEnabled = YES;
        
        UIButton *btn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        btn.frame = CGRectMake(0, 0, image.frame.size.width, image.frame.size.height);
        btn.tag = p.id;
        [btn addTarget:self action:@selector(pushProductInfoViewController:) forControlEvents:(UIControlEventTouchUpInside)];
        [image addSubview:btn];
        
        [self.viewPro addSubview:image];
    }
}

- (void)pushProductInfoViewController:(UIButton *)btn {
    
    ProductInfoViewController * prodInfo = [[ProductInfoViewController alloc]init];
    prodInfo.productId = btn.tag;
    [self.navigationController pushViewController:prodInfo animated:YES];
}

//点击查看更多适用优惠券的商品
- (IBAction)clickOnMore:(id)sender {
    
    ProdList * vc = [[ProdList alloc] initWithNibName:@"ProdList" bundle:nil];
    vc.couponId = self.couponId;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - setTextValue文案配置
- (void)setTextValue {
    
    // 适用商品
    NSString *couponInfoController_lblFitProduct_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"couponInfoController_lblFitProduct_title"];
    // 使用说明
    NSString *couponInfoController_lblUsingDesc_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"couponInfoController_lblUsingDesc_title"];
    // 面额详情
    NSString *couponInfoController_label1_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"couponInfoController_label1_title"];
    // 2、用户在享受立减优惠后，如订单产生退款，优惠券不退回。
    NSString *couponInfoController_label2_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"couponInfoController_label2_title"];
    // 3、在获取和使用优惠券的过程中，如果出现违规行为（如作弊领取，恶意套现等虚假交易），土猫网将收回优惠券（包括已使用的券及未使用的券），必要时追究法律责任。
    NSString *couponInfoController_label3_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"couponInfoController_label3_title"];
    
    self.label1.text = couponInfoController_label1_title;
    self.label2.text = couponInfoController_label2_title;
    self.label3.text = couponInfoController_label3_title;
    self.lblFitProduct.text = couponInfoController_lblFitProduct_title;
    self.lblUsingDesc.text = couponInfoController_lblUsingDesc_title;
}

@end
