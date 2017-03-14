//
//  ProductInfoViewController.h
//  PagingDemo
//
//  Created by Liu jinyong on 15/8/6.
//  Copyright (c) 2015年 Baidu 91. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProdInfoImage.h"
//#import "ProdParamters.h"
//#import "ProdIntroduction.h"
#import "ProductService.h"
#import "UIBarButtonItem+Badge.h"
#import "CartResponse.h"
#import "CartService.h"
#import "CartController.h"
#import "FavoriteService.h"
//#import "ProdReviews.h"
#import "ProdImageScroll.h"
#import "MyWebView.h"
#import "ProdList.h"

#import "Item.h"
#import "PicAndTextActionSheet.h"
#import "ItemCell.h"
#import "ProdSpecificationViewController.h"
#import "ShareActionSheet.h"
#import "CodeActionSheet.h"
#import "QRCodeUtils.h"

@interface ProductInfoViewController : UIBaseController<UIScrollViewDelegate,ServiceResponselDelegate, MsgHandler, UIGestureRecognizerDelegate, CustomActionSheetDelegate>{
    BOOL pageControlUsed;
    NSUInteger kNumberOfPages;
    AppProduct * product;
    ProductService *productService;
    CartService *cartService;
    OrderService * orderService;
    Boolean isBuyAtOnce;
    ProdSpecificationViewController *specSelController;
    STPopupController *popupController;
    Boolean _isFirstDragging;
//    Boolean isDelete;
}
@property (strong, nonatomic) UIView * viewHeader;

@property (strong, nonatomic)  UIButton *btnCall; //联系客服
@property (nonatomic, strong) UIImageView * callImageView;
@property (nonatomic, strong) UILabel * callLabel;
@property (strong, nonatomic)  UIButton *btnCollect; //收藏
@property (nonatomic, strong) UIImageView * collectImageView;
@property (nonatomic, strong) UILabel * collectLabel;
@property (strong, nonatomic)  UIButton *btnAddCar; //加入购物车
@property (strong, nonatomic)  UIButton *btnBuyNow; //立即购买
@property (strong, nonatomic) IBOutlet UIView *viewBottom;

@property (nonatomic, strong) UIButton * btnImageScroll; //放在图片上的按钮

@property (nonatomic, strong) UIPageControl * pageControl;
@property (nonatomic, strong) UIScrollView * imageScrollView;
@property (strong, nonatomic)  UIView *viewUp;
@property (strong, nonatomic)  UIView *viewDown;
@property (strong, nonatomic)  UIView *viewContinue;

@property(nonatomic) NSMutableArray* viewControllers;

@property (strong, nonatomic)  UILabel *name; // 商品名字
@property (strong, nonatomic)  UILabel *brief; // 商品介绍

@property (strong, nonatomic)  UILabel *price; // 土猫价
@property (strong, nonatomic)  UILabel *marketPrice; //市场价
@property (strong, nonatomic)  UILabel *lbMarketPriceWord;

@property (strong, nonatomic)  UILabel *postage; //运费

@property (strong, nonatomic)  UILabel *lblBrand;
@property (strong, nonatomic)  UILabel *brand; //品牌

@property (strong, nonatomic)  UILabel *lblProId; //商品型号
@property (strong, nonatomic)  UILabel *makerModel;

@property (strong, nonatomic)  UILabel *sn; //商品编号

@property (strong, nonatomic)  UIButton *btnSelections;
@property (strong, nonatomic)  UIButton *btnServer;

@property (strong, nonatomic)  UILabel * lblSelections;
@property (nonatomic, strong) UILabel * merchant;
@property (nonatomic) int productId;


@end
