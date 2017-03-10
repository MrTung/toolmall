//
//  ProductDetailViewController.h
//  PagingDemo
//
//  Created by Liu jinyong on 15/8/6.
//  Copyright (c) 2015年 Baidu 91. All rights reserved.
//

#import <UIKit/UIKit.h>


//#import "ProdIntroduction.h"
//#import "ProdParamters.h"
//#import "ProdReviews.h"
#import "CartService.h"
#import "FavoriteService.h"
#import "ProductService.h"


@interface ProductDetailViewController : UIViewController<UIScrollViewDelegate,ServiceResponselDelegate, MsgHandler, UIGestureRecognizerDelegate,UIWebViewDelegate,MBProgressHUDDelegate>{

    
    MBProgressHUD * hud;
}


@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) UIWebView * webView;
@property (nonatomic, strong) UIView * viewMenu;
@property (nonatomic, strong) UIButton * btnImageTextDetail;
@property (nonatomic, strong) UIButton * btnProductParams;
@property (nonatomic, strong) UIButton * btnUserJudge;
@property (nonatomic, strong) UIView * viewSlider;
@property (nonatomic) NSInteger productId;

@end
