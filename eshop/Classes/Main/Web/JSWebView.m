//
//  JSWebView.m
//  eshop
//
//  Created by gs_sh on 17/1/12.
//  Copyright © 2017年 hzlg. All rights reserved.
//

#import "JSWebView.h"

#import "WebViewJavascriptBridge.h"
#import "LBXScanViewController.h"
#import "SubLBXScanViewController.h"

#import "ProductInfoViewController.h"
#import "ProdList.h"
#import "IndexViewController.h"
#import "TollMallRDViewController.h"
#import "CatRootListViewController.h"
#import "CatSecdListViewController.h"
#import "CartController.h"
#import "MyAccountViewController.h"
#import "ActivityViewController.h"
#import "FootPrintViewController.h"
#import "OrderList.h"
#import "OrderInfoController.h"
#import "OrderController.h"
#import "RegisteViewController.h"
#import "ShopLoginViewController.h"
#import "MoreBrands.h"
#import "FavoriteListController.h"
#import "ProdHotKeySearchViewController.h"
#import "ImproveInfoViewController.h"
#import "AddressList.h"
#import "AddressController.h"
#import "CouponCodeList.h"
#import "CouponInfoController.h"

@interface JSWebView ()<UIWebViewDelegate, ServiceResponselDelegate, SubLBXScanViewControllerDelegate>
{
    OrderService * orderService;
    CartService *cartService;
    CouponService *couponService;
    UIWebView *webView;
}

@property WebViewJavascriptBridge *bridge;

@end

@implementation JSWebView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addNavBackButton];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = self.navTitle;
    
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64)];
    webView.backgroundColor = groupTableViewBackgroundColorSelf;
    [self.view addSubview:webView];
    
    NSArray *httpArr = [self.loadUrl componentsSeparatedByString:@"//"];
    self.loadUrl = [NSString stringWithFormat:@"https://%@", httpArr.lastObject];
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.loadUrl]]];
    
    //开启日志
    [WebViewJavascriptBridge enableLogging];
    
    //给乃一个webView建立JS与OC的沟通的桥梁
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:webView];
    [self.bridge setWebViewDelegate:self];

    [self addRegisterHandler];
    
    orderService = [[OrderService alloc] initWithDelegate:self parentView:self.view];
    cartService = [[CartService alloc] initWithDelegate:self parentView:self.view];
    couponService = [[CouponService alloc] initWithDelegate:self parentView:self.view];
}

#pragma mark - 请求数据处理
- (void)loadResponse:(NSString *)url response:(BaseModel *)response {
  
    if ([url isEqualToString:api_order_build_buyatonce]){ // 立即购买
        
        OrderBuildResponse2 * orderBuildResponse = (OrderBuildResponse2 *)response;
        if (orderBuildResponse.status.succeed == 1){
            
            OrderController *orderController = [[OrderController alloc] initWithNibName:@"OrderController" bundle:nil];
            [orderController setOrderBuildResponse:orderBuildResponse];
            [self.navigationController pushViewController:orderController animated:YES];
        } else {
            [CommonUtils ToastNotification:orderBuildResponse.status.error_desc andView:self.view andLoading:NO andIsBottom:NO];
        }
    }
    if ([url  isEqual: api_cart_item_add]){
        CartResponse * cartResponse = (CartResponse *)response;
        if (cartResponse.status.succeed == 1){
            [SESSION getSession].cartId = cartResponse.data.cartId;
            [AppStatic setCART_ITEM_QUANTITIES:[cartResponse.data getQuantities]];
            
            if ([AppStatic CART_ITEM_QUANTITIES ] < 100) {
                [self.navigationItem.rightBarButtonItems objectAtIndex:1].badgeValue = [[NSString alloc] initWithFormat:@"%d", [AppStatic CART_ITEM_QUANTITIES ]];
            }else{
                [self.navigationItem.rightBarButtonItems objectAtIndex:1].badgeValue =  @"…";
            }
        }
        
        NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
        NSNumber *boolNumber = [NSNumber numberWithBool:YES];
        if (cartResponse.status.succeed != 1) {
            boolNumber = [NSNumber numberWithBool:NO];
        }
        [data setValue:boolNumber forKey:@"isOk"];
        [self onAddCart:data];
    }
    if ([url isEqual:api_coupon_getCoupon]){
        
        StatusResponse *respobj = (StatusResponse*)response;
        
        NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
        NSNumber *boolNumber = [NSNumber numberWithBool:YES];
        if (respobj.status.succeed == 0) {
            boolNumber = [NSNumber numberWithBool:NO];
            [data setValue:respobj.status.error_desc forKey:@"error_desc"];
        }
        [data setValue:boolNumber forKey:@"isOk"];
        [self onGetCoupon:data];
    }
}

- (void)addRegisterHandler {
    
    // 跳转至商品详情
    [self toAppProductInfoVC];
    
    // 跳转至商品列表页
    [self toAppProductList];
    
    // 跳转至订单列表页
    [self toAppOrderList];
    
    // 跳转至订单详情页
    [self toAppOrderInfoVC];
    
    // 跳转至提交订单页
    [self toAppOrderController];
    
    // 跳转至主页
    [self toAppIndexVC];
    
    // 跳转至我的页面
    [self toAppMyAccountViewController];
    
    // 跳转至猫工推荐
    [self toAppToolMallRDVC];
    
    // 跳转至一级分类
    [self toAppFirstClassify];
    
    // 跳转至二级分类
    [self toAppSecondClassify];
    
    // 跳转至购物车页面
    [self toAppCartController];
    
    // 跳转至活动列表页
    [self toAppActiveVC];
    
    // 跳转至足迹列表页
    [self toAppFootPrintVC];
    
    // 跳转至品牌列表页
    [self toAppMoreBrands];
    
    // 跳转至收藏列表页
    [self toAppFavoriteListController];
    
    // 跳转至商品搜索页
    [self toAppProdHotKeySearchVC];
    
    // 跳转至注册页
    [self toAppRegisterVC];
    
    // 跳转至登录页
    [self toAppShopLoginViewControllerVC];
    
    // 跳转至完善个人信息
    [self toAppImproveInfoVC];
    
    // 跳转至地址列表页面
    [self toAppAddressList];
    
    // 跳转至新建地址
    [self toAppAddressController];
    
    // 跳转至优惠券列表
    [self toAppCouponCodeList];
    
    // 跳转至优惠券详情
    [self toAppCouponInfoController];
    
    // 加入购物车
    [self addCartItem];
    
    // 扫描二维码
    [self saomaGetPrd];
    
    // 获取用户信息
    [self sendUserMsg];
    
    // 获取优惠券
    [self getCoupon];
}

#pragma mark - 跳转到商品详情页
- (void)toAppProductInfoVC {

    [self.bridge registerHandler:@"toAppProductInfoVC" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSLog(@"JS 调用了 toAppProductInfoVC 这个方法，从js回来的数据是: %@",data);
        if ([data[@"id"] intValue]) {
            //        跳转到商品详情页
            ProductInfoViewController * p = [[ProductInfoViewController alloc] initWithNibName:@"ProductInfoViewController" bundle:nil];
            p.productId = [data[@"id"] intValue];
            p.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:p  animated:YES];
            
        }
        if (responseCallback) {
            //反馈给JS
            responseCallback(data);
        }
    }];
}

#pragma mark - 跳转到产品列表页
- (void)toAppProductList {

    [self.bridge registerHandler:@"toAppProductList" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSLog(@"JS 调用了 toAppProductList 这个方法，从js回来的数据是: %@",data);
        
        if ([data[@"id"] intValue]) {
            
//            @property int productCategoryId; // 分类ID<二级分类页面>
//            @property int brandId; // 品牌商品列表<更多品牌>
//            @property int promotionId; // 促销ID<购物车促销Bar>
//            @property int activityId;
//            @property int tagId; // 热卖推荐列表<我的收藏>
//            @property int couponId; // 优惠券适用商品ID<优惠券详情>
            ProdList * p = [[ProdList alloc] initWithNibName:@"ProdList" bundle:nil];
            NSArray *idArr = [NSArray arrayWithObjects:@"productCategoryId", @"brandId", @"promotionId", @"activityId", @"tagId", @"couponId", nil];
            NSUInteger index = [idArr indexOfObject:data[@"type"]];
            //        跳转到商品类目页
            switch (index) {
                case 0:
                    p.productCategoryId = [data[@"id"] intValue];
                    break;
                case 1:
                    p.brandId = [data[@"id"] intValue];
                    break;
                case 2:
                    p.promotionId = [data[@"id"] intValue];
                    break;
                case 3:
                    p.activityId = [data[@"id"] intValue];
                    break;
                case 4:
                    p.tagId = [data[@"id"] intValue];
                    break;
                case 5:
                    p.couponId = [data[@"id"] intValue];
                    break;
                    
                default:
                    p.promotionId = [data[@"id"] intValue];
                    break;
            }
            p.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:p  animated:YES];
        }
        if (responseCallback) {
            //反馈给JS
            responseCallback(data);
        }
    }];
}

#pragma mark - 跳转至订单列表页
- (void)toAppOrderList {
    
    [self.bridge registerHandler:@"toAppOrderList" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSLog(@"JS 调用了 toAppOrderList 这个方法，从js回来的数据是: %@",data);
        
        if ([data[@"id"] intValue]) {
            
            NSArray *filterTypes = [NSArray arrayWithObjects:@"", @"await_pay", @"await_ship", @"shipped", @"await_review", nil];
            NSString *initType = [filterTypes objectAtIndex:([data[@"id"] intValue] - 1)];
            OrderList * orderList = [[OrderList alloc] init];
            orderList.hidesBottomBarWhenPushed = YES;
            orderList.iniType = initType;
            UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:nil action:nil];
            self.navigationItem.backBarButtonItem = barButtonItem;
            [self.navigationController pushViewController:orderList animated:YES];
        }
        if (responseCallback) {
            
            // responseCallback(params);
            
        }
    }];
}

#pragma mark - 跳转至订单详情页
- (void)toAppOrderInfoVC {
    
    [self.bridge registerHandler:@"toAppOrderInfoVC" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSLog(@"JS 调用了 toAppOrderInfoVC 这个方法，从js回来的数据是: %@",data);
        
        if (data[@"ordersn"]) {
            
            OrderInfoController *orderInfoController = [[OrderInfoController alloc] initWithNibName:@"OrderInfoController" bundle:nil];
            orderInfoController.orderSn = data[@"ordersn"];
            orderInfoController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:orderInfoController animated:YES];
        }
        if (responseCallback) {
            
            // responseCallback(params);
            
        }
    }];
}

#pragma mark - 跳转至提交订单
- (void)toAppOrderController {
    
    [self.bridge registerHandler:@"toAppOrderController" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSLog(@"JS 调用了 toAppOrderController 这个方法，从js回来的数据是: %@",data);
        
        if ([data[@"id"] intValue]) {
            
            [orderService buildOrderAtOnceWithProductId:[data[@"id"] intValue] quantity:[data[@"num"] intValue]];
        }
        if (responseCallback) {
            
            // responseCallback(params);
            
        }
    }];
}


#pragma mark - 加入购物车
- (void)addCartItem {
    
    [self.bridge registerHandler:@"addCartItem" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSLog(@"JS 调用了 addCartItem 这个方法，从js回来的数据是: %@",data);
        
        if (![CommonUtils chkLogin:self gotoLoginScreen:YES]){
            return;
        }
        
        if ([data[@"id"] intValue]) {
            
            [cartService addCartItem:[data[@"id"] intValue] quantity:[data[@"num"] intValue]];
        }
        
        if (responseCallback) {
            
//            responseCallback(params);
            
        }
    }];
}

- (void)onAddCart:(NSDictionary *)data {
    
    [self.bridge callHandler:@"onAddCart" data:data responseCallback:^(id responseData) {
        
        NSLog(@"%@", responseData);
        
    }];
    
}


#pragma mark - 跳转至主页
- (void)toAppIndexVC {
    
    [self.bridge registerHandler:@"toAppIndexVC" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSLog(@"JS 调用了 toAppIndexVC 这个方法，从js回来的数据是: %@",data);
        IndexViewController *indexVC = [[IndexViewController alloc] initWithNibName:@"IndexViewController" bundle:nil];
        indexVC.hidesBottomBarWhenPushed = YES;
        indexVC.type = @"webView";
        [self.navigationController pushViewController:indexVC animated:YES];
        
        if (responseCallback) {
            
            // responseCallback(params);
        }
    }];
}

#pragma mark - 跳转至我的页面
- (void)toAppMyAccountViewController {
    
    [self.bridge registerHandler:@"toAppMyAccount" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSLog(@"JS 调用了 toAppMyAccount 这个方法，从js回来的数据是: %@",data);
        
        MyAccountViewController *myAccountVC = [[MyAccountViewController alloc] initWithNibName:@"MyAccountViewController" bundle:nil];
        myAccountVC.hidesBottomBarWhenPushed = YES;
        myAccountVC.type = @"webView";
        [self.navigationController pushViewController:myAccountVC animated:YES];
        
        if (responseCallback) {
            
            // responseCallback(params);
            
        }
    }];
}

#pragma mark - 跳转至猫工推荐
- (void)toAppToolMallRDVC {
    
    [self.bridge registerHandler:@"toAppToolMallRDVC" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSLog(@"JS 调用了 toAppToolMallRDVC 这个方法，从js回来的数据是: %@",data);
        
        TollMallRDViewController *tollMallRDVC = [[TollMallRDViewController alloc] init];
        tollMallRDVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:tollMallRDVC animated:YES];
        
        if (responseCallback) {
            
            // responseCallback(params);
        }
    }];
}

#pragma mark - 一级分类
- (void)toAppFirstClassify {
    
    [self.bridge registerHandler:@"toAppFirstClassify" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSLog(@"JS 调用了 toAppFirstClassify 这个方法，从js回来的数据是: %@",data);
        
        CatRootListViewController *catRootListController = [[CatRootListViewController alloc] initWithNibName:@"CatRootListViewController" bundle:nil];
        catRootListController.type = @"index";
        catRootListController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:catRootListController animated:YES];
        
        if (responseCallback) {
            
            // responseCallback(params);
            
        }
    }];
}

#pragma mark - 二级分类
- (void)toAppSecondClassify {
    
    [self.bridge registerHandler:@"toAppSecondClassify" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSLog(@"JS 调用了 toAppSecondClassify 这个方法，从js回来的数据是: %@",data);
        
        if ([data[@"id"] intValue]) {
            
            CatSecdListViewController * secdListController = [[CatSecdListViewController alloc] initWithNibName:@"CatSecdListViewController" bundle:nil];
            
            secdListController.prodCategoryId = [data[@"id"] intValue];
            secdListController.prodCategoryName = data[@"name"];
            secdListController.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:secdListController animated:YES];
        }
        if (responseCallback) {
            
            // responseCallback(params);
            
        }
    }];
}

#pragma mark - 跳转至购物车
- (void)toAppCartController {
    
    [self.bridge registerHandler:@"toAppCartController" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSLog(@"JS 调用了 toAppCartController 这个方法，从js回来的数据是: %@",data);
        
        CartController *cartController = [[CartController alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:cartController animated:YES];
        
        if (responseCallback) {
            
            // responseCallback(params);
            
        }
    }];
}

#pragma mark - 跳转至活动列表页
- (void)toAppActiveVC {
    
    [self.bridge registerHandler:@"toAppActiveVC" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSLog(@"JS 调用了 toAppActiveVC 这个方法，从js回来的数据是: %@",data);
        if ([data[@"id"] intValue]) {
            
            //        跳转到活动商品展示页
            ActivityViewController * p = [[ActivityViewController alloc] initWithNibName:@"ActivityViewController" bundle:nil];
            p.activityId = [data[@"id"] intValue];
            p.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:p  animated:YES];
        }
        if (responseCallback) {
            
            // responseCallback(params);
            
        }
    }];
}

#pragma mark - 跳转至足迹列表页
- (void)toAppFootPrintVC {
    
    [self.bridge registerHandler:@"toAppFootPrintVC" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSLog(@"JS 调用了 toAppFootPrintVC 这个方法，从js回来的数据是: %@",data);
        
        FootPrintViewController * p = [[FootPrintViewController alloc] initWithNibName:@"FootPrintViewController" bundle:nil];
        p.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:p animated:YES];
        if (responseCallback) {
            
            // responseCallback(params);
            
        }
    }];
}

#pragma mark - 跳转至品牌列表页
- (void)toAppMoreBrands {
    
    [self.bridge registerHandler:@"toAppMoreBrands" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSLog(@"JS 调用了 toAppMoreBrands 这个方法，从js回来的数据是: %@",data);
        
        //        跳转到品牌类别页
        MoreBrands * brands = [[MoreBrands alloc] initWithNibName:@"MoreBrands" bundle:nil];
        brands.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:brands animated:YES];
        
        if (responseCallback) {
            
            // responseCallback(params);
            
        }
    }];
}

#pragma mark - 跳转至收藏列表页
- (void)toAppFavoriteListController {
    
    [self.bridge registerHandler:@"toAppFavoriteListController" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSLog(@"JS 调用了 toAppFavoriteListController 这个方法，从js回来的数据是: %@",data);
        
        FavoriteListController *favoriteList = [[FavoriteListController alloc] initWithNibName:@"FavoriteListController" bundle:nil];
        [self.navigationController pushViewController:favoriteList animated:YES];
        if (responseCallback) {
            
            // responseCallback(params);
            
        }
    }];
}

#pragma mark - 跳转至商品搜索页
- (void)toAppProdHotKeySearchVC {
    
    [self.bridge registerHandler:@"toAppProdHotKeySearchVC" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSLog(@"JS 调用了 toAppProdHotKeySearchVC 这个方法，从js回来的数据是: %@",data);
        
        ProdHotKeySearchViewController * hotkey = [[ProdHotKeySearchViewController alloc] initWithNibName:@"ProdHotKeySearchViewController" bundle:nil];
        hotkey.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:hotkey animated:YES];
        if (responseCallback) {
            
            // responseCallback(params);
            
        }
    }];
}


#pragma mark - 跳转至注册页
- (void)toAppRegisterVC {
    
    [self.bridge registerHandler:@"toAppRegisterVC" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSLog(@"JS 调用了 toAppRegisterVC 这个方法，从js回来的数据是: %@",data);
        
        //       跳转到注册页面
        RegisteViewController * p = [[RegisteViewController alloc] initWithNibName:@"RegisteViewController" bundle:nil];
        p.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:p animated:YES];
        if (responseCallback) {
            
            // responseCallback(params);
            
        }
    }];
}

#pragma mark - 跳转至登陆页面
- (void)toAppShopLoginViewControllerVC {
    
    [self.bridge registerHandler:@"toAppShopLoginViewControllerVC" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSLog(@"JS 调用了 toAppShopLoginViewControllerVC 这个方法，从js回来的数据是: %@",data);
        
        //       跳转到登陆页面
        ShopLoginViewController * p = [[ShopLoginViewController alloc] initWithNibName:@"ShopLoginViewController" bundle:nil];
        p.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:p animated:YES];
        if (responseCallback) {
            
            // responseCallback(params);
            
        }
    }];
}

#pragma mark - 跳转至完善个人信息
- (void)toAppImproveInfoVC {
    
    [self.bridge registerHandler:@"toAppImproveInfoVC" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSLog(@"JS 调用了 toAppImproveInfoVC 这个方法，从js回来的数据是: %@",data);
        
        ImproveInfoViewController * updateMore = [[ImproveInfoViewController alloc] init];
        updateMore.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:updateMore animated:YES];
        
        if (responseCallback) {
            
            // responseCallback(params);
            
        }
    }];
}

#pragma mark - 跳转至地址列表页
- (void)toAppAddressList {
    
    [self.bridge registerHandler:@"toAppAddressList" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSLog(@"JS 调用了 toAppAddressList 这个方法，从js回来的数据是: %@",data);
        
        if (![CommonUtils chkLogin:self gotoLoginScreen:YES]){
            return;
        }
        AddressList *addressList = [[AddressList alloc] init];
//        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:nil action:nil];
//        self.navigationItem.backBarButtonItem = barButtonItem;
        [self.navigationController pushViewController:addressList animated:YES];
        if (responseCallback) {
            
            // responseCallback(params);
            
        }
    }];
}

#pragma mark - 跳转至新建/修改地址
- (void)toAppAddressController {
    
    [self.bridge registerHandler:@"toAppAddressController" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSLog(@"JS 调用了 toAppAddressController 这个方法，从js回来的数据是: %@",data);
        
//        //编辑
//        AddressController *addressController = [[AddressController alloc] init];
//        addressController.mode = @"edit";
//        addressController.editAddress = curOperaterAddress;
//        [self.navigationController pushViewController:addressController animated:YES];
        
        AddressController *addressController = [[AddressController alloc] init];
        addressController.mode = @"new";
        [self.navigationController pushViewController:addressController animated:YES];
        
        if (responseCallback) {
            
            // responseCallback(params);
            
        }
    }];
}

#pragma mark - 跳转至优惠券列表
- (void)toAppCouponCodeList {
    
    [self.bridge registerHandler:@"toAppCouponCodeList" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSLog(@"JS 调用了 toAppCouponCodeList 这个方法，从js回来的数据是: %@",data);
        
        if (![CommonUtils chkLogin:self gotoLoginScreen:YES]){
            return;
        }
        CouponCodeList *couponCodeList = [[CouponCodeList alloc] initWithNibName:@"CouponCodeList" bundle:nil];
//        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:nil action:nil];
//        self.navigationItem.backBarButtonItem = barButtonItem;
        
        [self.navigationController pushViewController:couponCodeList animated:YES];
        
        if (responseCallback) {
            
            // responseCallback(params);
            
        }
    }];
}

#pragma mark - 跳转至优惠券详情
- (void)toAppCouponInfoController {
    
    [self.bridge registerHandler:@"toAppCouponInfoController" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSLog(@"JS 调用了 toAppCouponInfoController 这个方法，从js回来的数据是: %@",data);
        
        if ([data[@"id"] intValue]) {
            
            CouponInfoController * vc = [[CouponInfoController alloc] initWithNibName:@"CouponInfoController" bundle:nil];
            vc.couponId = [data[@"id"] intValue];
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (responseCallback) {
            
            // responseCallback(params);
            
        }
    }];
}



#pragma mark - 扫描二维码
- (void)saomaGetPrd {

    [self.bridge registerHandler:@"saomaGetPrd" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSLog(@"JS 调用了 saomaGetPrd 这个方法，从js回来的数据是: %@",data);
        
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
        SubLBXScanViewController * vc = [[SubLBXScanViewController alloc] init];
        //        vc.hidesBottomBarWhenPushed = YES;
        vc.style = style;
//        vc.isQQSimulator = YES;
        vc.type = @"webView";
        vc.delegate = self;
        vc.returnScanBarCodeValue = ^(NSString * barCodeString){
            
            NSLog(@"扫描结果的字符串======%@",barCodeString);
            if (responseCallback) {
                
//                NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
//                NSNumber *boolNumber = [NSNumber numberWithBool:YES];
//                [data setValue:boolNumber forKey:@"isOk"];
//                [data setValue:barCodeString forKey:@"id"];
//                
//                NSLog(@"data - %@", data);
//                
//                responseCallback(data);
            }
        };
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }];


}

- (void)sendValue:(NSDictionary *)data {
    
    [self.bridge callHandler:@"onSaoMa" data:data responseCallback:^(id responseData) {
        
        NSLog(@"%@", responseData);
        
    }];
    
}

#pragma mark - 获取用户信息
- (void)sendUserMsg {

    [self.bridge registerHandler:@"sendUserMsg" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSLog(@"JS 调用了 sendUserMsg 这个方法，从js回来的数据是: %@",data);
        
        if (![CommonUtils chkLogin:self gotoLoginScreen:YES]){
            return;
        }
        SESSION *session = [SESSION getSession];
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [CommonUtils fillStrToDictionary:params key:@"user" value:session.toJsonString];

        if (responseCallback) {
            
//             responseCallback(params);
        }
    }];

}

#pragma mark - 获取优惠券

- (void)getCoupon {
    
    [self.bridge registerHandler:@"getCoupon" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSLog(@"JS 调用了 getCoupon 这个方法，从js回来的数据是: %@",data);
        SESSION *session = [SESSION getSession];
        if (session.uid < 0){
            ShopLoginViewController *loginVC = [[ShopLoginViewController alloc] initWithNibName:@"ShopLoginViewController" bundle:nil];
            loginVC.popView = YES;
            [self.navigationController pushViewController:loginVC animated:YES];
            
            return;
        }
        
        if ([data[@"id"] intValue]) {
            
//            [couponService getExchange:[data[@"id"] intValue]];
            [couponService getJSViewExchange:[data[@"id"] intValue]];
        }
        if (responseCallback) {
            
//             responseCallback(params);
        }
    }];
    
}

- (void)onGetCoupon:(NSDictionary *)data {
    
    [self.bridge callHandler:@"onGetCoupon" data:data responseCallback:^(id responseData) {
        
        NSLog(@"%@", responseData);
    }];
    
}


- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    [webView reload];
}

//- (void)sendData:(id)data responseCallback:(WVJBResponseCallback)responseCallback handlerName:(NSString*)handlerName {
//
//    
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
