//
//  ProductInfoViewController.m
//  PagingDemo
//
//  Created by Liu jinyong on 15/8/6.
//  Copyright (c) 2015年 Baidu 91. All rights reserved.
//

#import "ProductInfoViewController.h"

#import "MJRefresh.h"
#import "UIScrollView+JYPaging.h"
#import "ProductDetailViewController.h"
#import "STPopupController.h"
#import "CouponDetailViewController.h"
#import "ProductPreheatView.h"
#import "ProductCountDownView.h"

#define kHeightOfScrollImageView TMScreenH*260/568
#define kHeightOfButtomButton TMScreenH*40/568
#define kWidthOfSpace TMScreenW*10/320
#define kHeightOfLabel TMScreenH*20/568
#define kHeightOfContent TMScreenH*370/568


@interface ProductInfoViewController ()<ProductPreheatViewDelegate, ProductCountDownViewDelegate>
{
    int state;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) ProductDetailViewController *detailVC;
@property (nonatomic, retain) ProductPreheatView *preheatView;      // 预热
@property (nonatomic, strong) ProductCountDownView *countdownView;  // 倒计时

@end

@implementation ProductInfoViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *) nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.hidesBottomBarWhenPushed=YES;
        
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self initView];
    
    [self initBottomView];
    
    [self initService];
    
    [self initNavgation];
    
    [self createUI];
}

-(void)initView{
    isBuyAtOnce = false;
    _isFirstDragging = YES;
    _scrollView.contentSize = CGSizeMake(0, kHeight);
    _scrollView.frame = CGRectMake(0, 0, kWidth, kHeight - TMScreenH *40/568 - 64);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.backgroundColor = groupTableViewBackgroundColorSelf;
    _scrollView.delegate = self;
}


-(void)initNavgation{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(clickCart:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:[UIImage imageNamed:@"topcart.png"] forState:UIControlStateNormal];
    UIBarButtonItem *navRightButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    button.size = button.currentBackgroundImage.size;
    self.navigationItem.rightBarButtonItem = navRightButton;
    
    [super addThreedotButton];
    
    [super addNavBackButton];
    
    self.navigationItem.rightBarButtonItems[1].badgeValue = [[NSString alloc] initWithFormat:@"%d", [AppStatic CART_ITEM_QUANTITIES] ];
    
    // @"分享"
    NSString *productInfoVC_shareMenu_menuItem = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"productInfoVC_shareMenu_menuItem"];
    YCXMenuItem *shareMenu = [YCXMenuItem menuItem:productInfoVC_shareMenu_menuItem image:[UIImage imageNamed:@"share_prod"]  target:self action:@selector(shareAppProduct:)];
    [super addThreedotMenu:shareMenu];
}

-(void)initService{
    
    productService = [[ProductService alloc] initWithDelegate:self parentView:self.view];
    cartService = [[CartService alloc] initWithDelegate:self parentView:self.view];
    orderService = [[OrderService alloc] initWithDelegate:self parentView:self.view];
    [productService getProductInfo:_productId];
}

-(void)initBottomView{
    
    _viewBottom.frame = CGRectMake(0, kHeight - TMScreenH *40/568 - 64, TMScreenW *320/320,  TMScreenH *40/568);
    
    CGFloat ss = TMScreenW*60/320;
    //    每个按钮的大小
    CGFloat space = (kWidth - 2*ss)/2.0;
    CGFloat itemW10 = TMScreenW*10/320;
    CGFloat itemW15 = TMScreenW*18/320;
    CGFloat itemW30 = TMScreenW*30/320;
    CGFloat itemH15 = TMScreenH*15/568;
    
    //    联系客服按钮
    _btnCall = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnCall.frame = CGRectMake(0, 0.5, ss - itemW10, kHeightOfButtomButton);
    _btnCall.backgroundColor = [UIColor whiteColor];
    [_btnCall addTarget:self action:@selector(callToServers:) forControlEvents:UIControlEventTouchUpInside];
    _callImageView = [[UIImageView alloc]initWithFrame:CGRectMake((CGRectGetWidth(_btnCall.frame) - itemW15)/2.0,  TMScreenH *3/568, itemW15, itemW15)];
    //    _callImageView.backgroundColor = [UIColor blueColor];
    _callImageView.image = [UIImage imageNamed:@"客服"];
    [_btnCall addSubview:_callImageView];
    
    // @"客服"
    NSString *productInfoVC_callLabel_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"productInfoVC_callLabel_title"];
    _callLabel = [[UILabel alloc]initWithFrame:CGRectMake((CGRectGetWidth(_btnCall.frame) - itemW30)/2.0, CGRectGetMaxY(_callImageView.frame), itemW30, itemH15)];
    //    _callLabel.backgroundColor = [UIColor redColor];
    _callLabel.textAlignment = NSTextAlignmentCenter;
    _callLabel.text = productInfoVC_callLabel_title;
    _callLabel.font = [UIFont systemFontWithSize:10];
    [_callLabel setTextColor:[UIColor colorWithRed:63/255.0 green:63/255.0 blue:63/255.0 alpha:1]];
    [_btnCall addSubview:_callLabel];
    
    //    收藏按钮
    _btnCollect = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnCollect.frame = CGRectMake(CGRectGetMaxX(_btnCall.frame)+0.5, 0.5, ss-0.5 - itemW10, kHeightOfButtomButton);
    _btnCollect.backgroundColor = [UIColor whiteColor];
    [_btnCollect addTarget:self action:@selector(addFavorite:) forControlEvents:UIControlEventTouchUpInside];
    _collectImageView = [[UIImageView alloc]initWithFrame:CGRectMake((CGRectGetWidth(_btnCollect.frame) - itemW15)/2.0,  TMScreenH *3/568, itemW15, itemW15)];
    //    _collectImageView.backgroundColor = [UIColor blueColor];
    _collectImageView.image = [UIImage imageNamed:@"收藏1"];
    [_btnCollect addSubview:_collectImageView];
    
    // @"收藏"
    NSString *productInfoVC_collectLabel_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"productInfoVC_collectLabel_title"];
    _collectLabel = [[UILabel alloc]initWithFrame:CGRectMake((CGRectGetWidth(_btnCollect.frame) - itemW30)/2.0, CGRectGetMaxY(_callImageView.frame), itemW30, itemH15)];
    //    _collectLabel.backgroundColor = [UIColor redColor];
    _collectLabel.textAlignment = NSTextAlignmentCenter;
    _collectLabel.text = productInfoVC_collectLabel_title;
    _collectLabel.font = [UIFont systemFontWithSize:10];
    [_collectLabel setTextColor:[UIColor colorWithRed:63/255.0 green:63/255.0 blue:63/255.0 alpha:1]];
    [_btnCollect addSubview:_collectLabel];
    
    // @"加入购物车"
    NSString *productInfoVC_btnAddCar_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"productInfoVC_btnAddCar_title"];
    // @"立即购买"
    NSString *productInfoVC_btnBuyNow_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"productInfoVC_btnBuyNow_title"];
    _btnAddCar = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnAddCar.frame = CGRectMake(CGRectGetMaxX(_btnCollect.frame), 0, space + itemW10, kHeightOfButtomButton);
    //    UIColor * acolor = [UIColor colorWithRed:9/255.0 green:49/255.0 blue:111/255.0 alpha:1];
    _btnAddCar.backgroundColor = blueColorSelf;
    [_btnAddCar setTitle:productInfoVC_btnAddCar_title forState:UIControlStateNormal];
    [_btnAddCar setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btnAddCar.titleLabel.font = [UIFont systemFontWithSize:14];
    [_btnAddCar addTarget:self action:@selector(addCartItem:) forControlEvents:UIControlEventTouchUpInside];
    //    [_btnAddCar addTarget:self action:@selector(addCartItem:quantity:) forControlEvents:UIControlEventTouchUpInside];
    
    //    立即购买按钮
    _btnBuyNow = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnBuyNow.frame = CGRectMake(CGRectGetMaxX(_btnAddCar.frame), 0, space + itemW10, kHeightOfButtomButton);
    _btnBuyNow.backgroundColor = redColorSelf;
    [_btnBuyNow setTitle:productInfoVC_btnBuyNow_title forState:UIControlStateNormal];
    [_btnBuyNow setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btnBuyNow.titleLabel.font = [UIFont systemFontWithSize:14];
    [_btnBuyNow addTarget:self action:@selector(buyAtonce:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.viewBottom addSubview:_btnCall];
    [self.viewBottom addSubview:_btnCollect];
    [self.viewBottom addSubview:_btnAddCar];
    [self.viewBottom addSubview:_btnBuyNow];
}

- (void)createUI{
    
    //    每个按钮的大小
    CGFloat itemW10 = TMScreenW*10/320;
    CGFloat itemW20 = TMScreenW*20/320;
    CGFloat itemH20 = TMScreenH*20/568;
    CGFloat itemH10 = TMScreenH*10/320;
    
    _imageScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeightOfScrollImageView)];
    _imageScrollView.backgroundColor = kBGColor;
    
    UITapGestureRecognizer *tapClickImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImageScrollView:)];
    [_imageScrollView addGestureRecognizer:tapClickImage];
    
    [_scrollView addSubview:_imageScrollView];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(0, 0, kWidth, itemH10);
    gradient.colors = [NSArray arrayWithObjects:
                       (id)[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.3].CGColor,
                       (id)[UIColor colorWithRed:223 / 255.0 green:223 / 255.0 blue:223 / 255.0 alpha:0.3].CGColor, nil];
    
    UIView *gradientView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_imageScrollView.frame) - itemW10, kWidth, itemH10)];
    gradientView.backgroundColor = [UIColor clearColor];
    [gradientView.layer insertSublayer:gradient atIndex:0];
    [_scrollView addSubview:gradientView];
    
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_imageScrollView.frame) - itemW20, kWidth, itemH20)];
    _pageControl.backgroundColor = [UIColor clearColor];
    _pageControl.pageIndicatorTintColor = [UIColor darkGrayColor];
    _pageControl.currentPageIndicatorTintColor = TMRedColor;
    [_scrollView addSubview:_pageControl];
    
#pragma mark 商品信息模块
    
    _viewUp = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_pageControl.frame) , kWidth, TMScreenH*131/568)];
    _viewUp.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_viewUp];
    
    self.name = [[UILabel alloc]initWithFrame:CGRectMake(kWidthOfSpace, kWidthOfSpace, kWidth - kWidth*80/320, kHeight*35/568)];
    self.name.lineBreakMode = NSLineBreakByWordWrapping;
    self.name.numberOfLines = 0;
    self.name.textAlignment = NSTextAlignmentLeft;
    self.name.font = [UIFont systemFontWithSize:13];
    self.name.textColor = TMBlackColor;
    self.name.text = @"";
    [_viewUp addSubview:self.name];
    
    UIButton * btnShare = [UIButton buttonWithType:UIButtonTypeCustom];
    btnShare.frame = CGRectMake(_viewUp.frame.size.width - kWidth *40/320, kHeight *5/568, kWidth *40/320, kHeight * 30/568);
    [btnShare addTarget:self action:@selector(shareAppProduct:) forControlEvents:UIControlEventTouchUpInside];
    [_viewUp addSubview:btnShare];
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(1, 1, 0.5, kHeight *28/568)];
    view.backgroundColor = [UIColor lightGrayColor];
    [btnShare addSubview:view];
    
    UIImageView * image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"share"]];
    image.frame = CGRectMake(kWidth *10/320, kHeight *2/568, kWidth *15/320, kHeight *15/568);
    [btnShare addSubview:image];
    
    // @"分享"
    NSString *productInfoVC_btnShare_label = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"productInfoVC_btnShare_label"];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(kWidth * 8/320, kHeight *20/568, TMScreenW *25/320,  TMScreenH *10/568)];
    label.text = productInfoVC_btnShare_label;
    label.font = [UIFont systemFontWithSize:10];
    label.textColor = [UIColor lightGrayColor];
    [btnShare addSubview:label];
    
    self.brief = [[UILabel alloc] initWithFrame:(CGRectMake(kWidthOfSpace, CGRectGetMaxY(self.name.frame), kWidth-kWidthOfSpace*2, 1))];
    self.brief.numberOfLines = 0;
    self.brief.font = [UIFont systemFontWithSize:11];
    self.brief.textColor = [UIColor lightGrayColor];
    [_viewUp addSubview:self.brief];
    
    self.price = [[UILabel alloc] initWithFrame:CGRectMake(kWidthOfSpace, CGRectGetMaxY(self.brief.frame) + kWidthOfSpace, (kWidth-kWidthOfSpace*2)/3.0 + TMScreenW *20/320,  TMScreenH *35/568)];
    self.price.textColor = TMRedColor;
    self.price.font = [UIFont systemFontWithSize:11.0];
    [_viewUp addSubview:self.price ];
    
    // @"土猫价:"
    NSString *productInfoVC_lbMarketPriceWord_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"productInfoVC_lbMarketPriceWord_title"];
    _lbMarketPriceWord = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.price.frame) + TMScreenW *40/320, CGRectGetMaxY(self.brief.frame) +  TMScreenH *5/568 + kWidthOfSpace, (kWidth-kWidthOfSpace*2)/3.0 - TMScreenW *30/320, kHeightOfLabel)];
    _lbMarketPriceWord.text = productInfoVC_lbMarketPriceWord_title;
    self.lbMarketPriceWord.font = [UIFont systemFontWithSize:12];
    self.lbMarketPriceWord.textColor = [UIColor lightGrayColor];
    [_viewUp addSubview:self.lbMarketPriceWord ];
    
    
    self.marketPrice = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.price.frame) + TMScreenW *40/320, CGRectGetMaxY(self.brief.frame) +  TMScreenH *5/568 + kWidthOfSpace, (kWidth-kWidthOfSpace*2)/3.0 - TMScreenW *30/320, kHeightOfLabel)];
    self.marketPrice.text = @"";
    self.marketPrice.font = [UIFont systemFontWithSize:12];
    self.marketPrice.textColor = [UIColor lightGrayColor];
    [_viewUp addSubview:self.marketPrice ];
    
    
    
#pragma mark - /** 秒杀配置修改-秒杀倒计时布局 **/
    
    // 预热展示
    self.preheatView = [[ProductPreheatView alloc] initWithFrame:(CGRectMake(kWidth - kWidth*60/320, CGRectGetMaxY(self.brief.frame) +  TMScreenH *5/568 + kWidthOfSpace, kWidth*60/320, TMScreenH *35/568))];
    self.preheatView.delegate = self;
    [_viewUp addSubview:self.preheatView];
    
    // 倒计时展示
    self.countdownView = [[[NSBundle mainBundle] loadNibNamed:@"ProductCountDownView" owner:self options:nil] firstObject];
    self.countdownView.frame = (CGRectMake(kWidth - kWidth*60/320, CGRectGetMaxY(self.brief.frame) +  TMScreenH *5/568 + kWidthOfSpace, kWidth*60/320, TMScreenH *35/568));
    self.countdownView.delegate = self;
    [_viewUp addSubview:self.countdownView];
    
    self.preheatView.hidden = YES;
    self.countdownView.hidden = YES;
    
    
    // @"品牌: "
    NSString *productInfoVC_lblBrand_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"productInfoVC_lblBrand_title"];
    _lblBrand = [[UILabel alloc]initWithFrame:CGRectMake(kWidthOfSpace, CGRectGetMaxY(self.price.frame) , kWidth-kWidthOfSpace, kHeightOfLabel)];
    _lblBrand.text = productInfoVC_lblBrand_title;
    _lblBrand.font = [UIFont systemFontWithSize:12];
    _lblBrand.textColor = [UIColor lightGrayColor];
    [_viewUp addSubview:_lblBrand];
    
    
    self.brand = [[UILabel alloc]initWithFrame:CGRectMake(kWidthOfSpace + TMScreenW *30/320, CGRectGetMaxY(self.price.frame) , kWidth-kWidthOfSpace - TMScreenW *30/320, kHeightOfLabel)];
    self.brand.text = @"";
    self.brand.font = [UIFont systemFontWithSize:12];
    self.brand.textColor = [UIColor lightGrayColor];
    [_viewUp addSubview:self.brand];
    
    _postage = [[UILabel alloc]initWithFrame:CGRectMake(kWidth- TMScreenW *90/320, CGRectGetMinY(self.brand.frame), TMScreenW *80/320, kHeightOfLabel)];
    _postage.textAlignment = NSTextAlignmentRight;
    _postage.text = @"";
    _postage.font = [UIFont systemFontWithSize:12];
    _postage.textColor = [UIColor lightGrayColor];
    [_viewUp addSubview:_postage];
    
    // @"型号: "
    NSString *productInfoVC_lblProId_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"productInfoVC_lblProId_title"];
    _lblProId = [[UILabel alloc]initWithFrame:CGRectMake( kWidthOfSpace , CGRectGetMaxY(_lblBrand.frame) , (kWidth-kWidthOfSpace*2)/2.0, kHeightOfLabel)];
    _lblProId.text = productInfoVC_lblProId_title;
    _lblProId.font = [UIFont systemFontWithSize:12];
    _lblProId.textColor = [UIColor lightGrayColor];
    [_viewUp addSubview:_lblProId];
    
    self.makerModel = [[UILabel alloc]initWithFrame:CGRectMake( kWidthOfSpace + TMScreenW *35/320 , CGRectGetMaxY(_lblBrand.frame) , (kWidth-kWidthOfSpace*2)/2.0 - TMScreenW *30/320, kHeightOfLabel)];
    self.makerModel.text = @"";
    self.makerModel.font = [UIFont systemFontWithSize:12];
    self.makerModel.textColor = [UIColor lightGrayColor];
    [_viewUp addSubview:self.makerModel];
    
    
    self.sn = [[UILabel alloc]initWithFrame:CGRectMake(kWidth - TMScreenW *110/320, CGRectGetMinY(self.makerModel.frame), TMScreenW *100/320, kHeightOfLabel)];
    self.sn.textAlignment = NSTextAlignmentRight;
    self.sn.font = [UIFont systemFontWithSize:12];
    self.sn.textColor = [UIColor lightGrayColor];
    [_viewUp addSubview:self.sn];
    
    
#pragma mark - 请选择规格模块
    
    _viewDown = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_viewUp.frame)+kWidthOfSpace, kWidth,  TMScreenH *120/568)];
    _viewDown.backgroundColor = kBGColor;
    [_scrollView addSubview:_viewDown];
    
    //    选择规格模块
    _btnSelections = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnSelections.frame = CGRectMake(0, 0, kWidth,  TMScreenH *40/568);
    _btnSelections.backgroundColor = [UIColor whiteColor];
    _btnSelections.titleLabel.font = [UIFont systemFontWithSize:13];
    [_btnSelections setTitleColor:TMBlackColor forState:UIControlStateNormal];
    [_viewDown addSubview:_btnSelections];
    
    // @"请选择规格、数量"
    NSString *productInfoVC_lblSelections_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"productInfoVC_lblSelections_title"];
    _lblSelections = [[UILabel alloc]initWithFrame:CGRectMake(TMScreenW *10/320, 0, kWidth- TMScreenW *45/320,  TMScreenH *40/568)];
    _lblSelections.text = productInfoVC_lblSelections_title;
    _lblSelections.textColor = TMBlackColor;
    [_lblSelections setFont:[UIFont systemFontWithSize:13]];
    [_btnSelections addSubview:_lblSelections];
    [_btnSelections addTarget:self action:@selector(selSpecQuantityAction) forControlEvents:UIControlEventTouchUpInside];

    CGFloat promHeight = TMScreenH *40/568;
    //    (kWidth - kWidth *30/320, (promHeight - kWidth *16/320) / 2, kWidth *10/320,  kWidth *16/320)
    UIImageView *imgOne  = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth - kWidth *30/320, (promHeight - kWidth *16/320) / 2, kWidth *10/320,  kWidth *16/320)];
    imgOne.image = [UIImage imageNamed:@"gray_right_arrow.png"];
    [_btnSelections addSubview:imgOne];
    
    
    //售后服务
    _btnServer = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnServer.frame = CGRectMake(0, CGRectGetMaxY(_btnSelections.frame)+1, kWidth,  TMScreenH *40/568);
    _btnServer.backgroundColor = [UIColor whiteColor];
    _btnServer.titleLabel.font = [UIFont systemFontWithSize:13];
    [_btnServer setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    [_btnServer addTarget:self action:@selector(serverDetailsAction) forControlEvents:UIControlEventTouchUpInside];
    
    [_viewDown addSubview:_btnServer];
    
    UIImageView *imgThree  = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth - kWidth *30/320, (promHeight - kWidth *16/320) / 2, kWidth *10/320,  kWidth *16/320)];
    imgThree.image = [UIImage imageNamed:@"gray_right_arrow.png"];
    [_btnServer addSubview:imgThree];
    
    _merchant = [[UILabel alloc]initWithFrame:CGRectMake(TMScreenW *10/320, 0, kWidth- TMScreenW *45/320,  TMScreenH *40/568)];
    _merchant.textColor = [UIColor lightGrayColor];
    _merchant.font = [UIFont systemFontWithSize:12];
    [_btnServer addSubview:_merchant];
    
#pragma mark - 继续拖动查看
    
    _viewContinue = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_viewDown.frame)+  TMScreenH *30/568, kWidth,  TMScreenH *10/568)];
    //    _viewContinue.backgroundColor = kBGColor;
    _viewContinue.backgroundColor = [UIColor clearColor];
    
    // @"继续拖动，查看图文详情"
    NSString *productInfoVC_lblContinue_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"productInfoVC_lblContinue_title"];
    UILabel * lblContinue = [[UILabel alloc]initWithFrame:CGRectMake((kWidth - TMScreenW *120/320)/2.0, (CGRectGetHeight(_viewContinue.frame) -  TMScreenH *50/568)/2.0, TMScreenW *120/320,  TMScreenH *20/568)];
    //    NSLog(@"(CGRectGetHeight(_viewContinue.frame) - 50) - %f", (CGRectGetHeight(_viewContinue.frame) - 50));
    lblContinue.backgroundColor = [UIColor clearColor];
    lblContinue.text = productInfoVC_lblContinue_title;
    lblContinue.textAlignment = NSTextAlignmentCenter;
    lblContinue.font = [UIFont systemFontWithSize:10];
    lblContinue.textColor = [UIColor colorWithRed:60/255.0 green:60/255.0 blue:60/255.0 alpha:1];
    [_viewContinue addSubview:lblContinue];
    
    
    UIView *lineLeft = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMidY(lblContinue.frame), (kWidth - CGRectGetWidth(lblContinue.frame)) /2.0, 0.5)];
    lineLeft.backgroundColor = [UIColor colorWithRed:203/255.0 green:203/255.0 blue:203/255.0 alpha:1];
    [_viewContinue addSubview:lineLeft];
    
    UIView * lineRight = [[UIView alloc]initWithFrame:CGRectMake(kWidth -(kWidth - CGRectGetWidth(lblContinue.frame)) /2.0, CGRectGetMidY(lineLeft.frame), CGRectGetWidth(lineLeft.frame), CGRectGetHeight(lineLeft.frame) )];
    lineRight.backgroundColor = lineLeft.backgroundColor;
    [_viewContinue addSubview:lineRight];
    
    [_scrollView addSubview:_viewContinue];
    
    //#pragma mark ISDelete 下架测试
    //
    //    [self disPlayIsDeleteView:isDelete];
    
    [self resizeLayout];
    //    NSLog(@"===%f",CGRectGetMaxY(_viewContinue.frame));
    
}

#pragma mark - /** 秒杀配置 - 获取秒杀状态 **/

- (int)getProductStateWithPreheatDate:(NSString *)preheatDate activityBegin:(NSString *)activityBegin activityEnd:(NSString *)activityEnd {
    
    
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    
    NSString * timeStampString0 = preheatDate;
    NSTimeInterval _interval0=[timeStampString0 doubleValue] / 1000.0;
    NSDate *preDate = [NSDate dateWithTimeIntervalSince1970:_interval0];
    //    NSLog(@"秒杀预热: %@", [objDateformat stringFromDate: preDate]);
    
    NSString * timeStampString = activityBegin;
    NSTimeInterval _interval=[timeStampString doubleValue] / 1000.0;
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:_interval];
    //    NSLog(@"秒杀开始: %@", [objDateformat stringFromDate: startDate]);
    
    NSDate *nowDate = [NSDate date];
    //    NSLog(@"现在: %@", [objDateformat stringFromDate: nowDate]);
    
    NSString * timeStampString2 = activityEnd;
    NSTimeInterval _interval2=[timeStampString2 doubleValue] / 1000.0;
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:_interval2];
    //    NSLog(@"秒杀结束: %@", [objDateformat stringFromDate: endDate]);
    
    NSTimeInterval date0 = [nowDate timeIntervalSinceDate:preDate];
    NSTimeInterval date1 = [nowDate timeIntervalSinceDate:startDate];
    NSTimeInterval date2 = [endDate timeIntervalSinceDate:nowDate];
    //    NSLog(@"sn:%f == ne:%f", date1, date2);
    //    NSTimeInterval date3 = [startDate timeIntervalSinceDate:nowDate];
    
    if (date0 < 0) {
        
        NSLog(@"隐藏秒杀状态");
        return 0;
    }
    else if (date0 > 0 && date1 < 0) {
        
        NSLog(@"开始预热");
        return 1;
    }
    else if (date1 > 0 && date2 > 0) {
        
        NSLog(@"开始");
        return 2;
    }
    else if (date2 < 0) {
        
        NSLog(@"结束");
        return 3;
    }
    else {
        
        return 3;
    }
}

#pragma mark - 还有机会抢购提示
- (void)disPlayHaveChanceView {
    
    // @"有人未付款，您还有机会！"
    //    NSString *productInfoVC_deleteView_label = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"productInfoVC_deleteView_label"];
    UIView *deleteView = [[UIView alloc] initWithFrame:(CGRectMake(0, CGRectGetMinY(self.viewBottom.frame)-kHeightOfButtomButton, kWidth, TMScreenH *36/568))];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:(CGRectMake(0, 0, kWidth, kHeightOfButtomButton))];
    imgView.image = [UIImage imageNamed:@"deleteBacImgView"];
    UILabel *label = [[UILabel alloc] initWithFrame:(CGRectMake(0, 0, kWidth, kHeightOfButtomButton))];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"有人未付款，您还有机会！";
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontWithSize:12.0];
    
    [deleteView addSubview:imgView];
    [deleteView addSubview:label];
    [self.view addSubview:deleteView];
}

#pragma mark - 下架提示
- (void)disPlayIsDeleteView {
    
    // @"该商品已过期，不支持购买！"
    NSString *productInfoVC_deleteView_label = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"productInfoVC_deleteView_label"];
    UIView *deleteView = [[UIView alloc] initWithFrame:(CGRectMake(0, CGRectGetMinY(self.viewBottom.frame)-kHeightOfButtomButton, kWidth, TMScreenH *36/568))];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:(CGRectMake(0, 0, kWidth, kHeightOfButtomButton))];
    imgView.image = [UIImage imageNamed:@"deleteBacImgView"];
    UILabel *label = [[UILabel alloc] initWithFrame:(CGRectMake(0, 0, kWidth, kHeightOfButtomButton))];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = productInfoVC_deleteView_label;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontWithSize:12.0];
    
    [deleteView addSubview:imgView];
    [deleteView addSubview:label];
    [self.view addSubview:deleteView];
    
    
    //    _collectImageView.image = [UIImage imageNamed:@"deleteConImgView"];
    [_collectLabel setTextColor:[UIColor colorWithRed:184/255.0 green:184/255.0 blue:184/255.0 alpha:0.48]];
    [_btnAddCar setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.38] forState:UIControlStateNormal];
    [_btnBuyNow setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.38] forState:UIControlStateNormal];
    _btnCollect.userInteractionEnabled = NO;
    _btnAddCar.userInteractionEnabled = NO;
    _btnBuyNow.userInteractionEnabled = NO;
    
    [_viewDown removeFromSuperview];
    [_viewContinue removeFromSuperview];
    _scrollView.scrollEnabled = NO;
    
}

- (void)resizeLayout{
    if (product && product.validPromotions.count==0 && product.validCoupons.count == 0) {
        _btnServer.frame = CGRectMake(0, CGRectGetMaxY(_btnSelections.frame)+1, kWidth,  TMScreenH *40/568);
    }
    _viewUp.frame = CGRectMake(0, CGRectGetMaxY(_pageControl.frame) , kWidth, CGRectGetMaxY(self.lblProId.frame) + TMScreenH *8/568);
    _viewDown.frame = CGRectMake(0, CGRectGetMaxY(_viewUp.frame)+kWidthOfSpace, kWidth, CGRectGetMaxY(_btnServer.frame));
    _viewContinue.frame = CGRectMake(0, CGRectGetMaxY(_viewDown.frame)+ TMScreenW *30/320, kWidth,  TMScreenH *10/568);
    _scrollView.contentSize = CGSizeMake(0, _viewDown.frame.origin.y + _viewDown.frame.size.height +  TMScreenH *40/568);
    //    NSLog(@"ssss===%f",_scrollView.contentSize.height);
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //    NSLog(@"上一页的商品编号是：%d",_productId);
    
    // @"商品详情"
    NSString *productInfoVC_navItem_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"productInfoVC_navItem_title"];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = productInfoVC_navItem_title;
    cartService = [[CartService alloc] initWithDelegate:self parentView:self.view];
    [cartService getCartList:NO];
    
    if (product) {
        [self displayProdInfo];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    if (self.preheatView.timer) {
        dispatch_cancel(self.preheatView.timer);
        self.preheatView.timer = nil;
    }
    if (self.countdownView.timer) {
        dispatch_cancel(self.countdownView.timer);
        self.countdownView.timer = nil;
    }
}

//分享
- (void)shareAppProduct:(UIButton *)button{
    
    // @"复制链接"
    NSString *productInfoVC_customActionSheetButton_title1 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"productInfoVC_customActionSheetButton_title1"];
    // @"二维码"
    NSString *productInfoVC_customActionSheetButton_title2 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"productInfoVC_customActionSheetButton_title2"];
    // @"微信好友"
    NSString *productInfoVC_customActionSheetButton_title3 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"productInfoVC_customActionSheetButton_title3"];
    // @"微信朋友圈"
    NSString *productInfoVC_customActionSheetButton_title4 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"productInfoVC_customActionSheetButton_title4"];
    // @"QQ"
    NSString *productInfoVC_customActionSheetButton_title5 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"productInfoVC_customActionSheetButton_title5"];
    ShareActionSheet* sheet = [[ShareActionSheet alloc] initWithButtons:[NSArray arrayWithObjects:
                                                                         [CustomActionSheetButton buttonWithImage:[UIImage imageNamed:@"复制链接.png"] title:productInfoVC_customActionSheetButton_title1],
                                                                         [CustomActionSheetButton buttonWithImage:[UIImage imageNamed:@"微信.png"] title:productInfoVC_customActionSheetButton_title3],
                                                                         [CustomActionSheetButton buttonWithImage:[UIImage imageNamed:@"朋友圈.png"] title:productInfoVC_customActionSheetButton_title4],
                                                                         [CustomActionSheetButton buttonWithImage:[UIImage imageNamed:@"QQ.png"] title:productInfoVC_customActionSheetButton_title5],
                                                                         [CustomActionSheetButton buttonWithImage:[UIImage imageNamed:@"二维码.png"] title:productInfoVC_customActionSheetButton_title2],
                                                                         nil]];
    sheet.delegate = self;
    [sheet showInView:self.view];
}

#pragma mark - 分享交互事件
//实现shareActionsheet代理协议
- (void)choseAtIndex:(int)index{
    
    switch (index) {
        case 0:
        {
            // @"复制成功"
            NSString *productInfoVC_toastNotification_msg1 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"productInfoVC_toastNotification_msg1"];
            //复制链接
            NSString *shareUrl = [CommonUtils changeImageUrlStr:product.shareUrl];
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            [pasteboard setString:shareUrl];
            [CommonUtils ToastNotification:productInfoVC_toastNotification_msg1 andView:self.view andLoading:YES andIsBottom:YES];
        }
            break;
            
        case 1:
        {
            //二维码
            NSString *shareUrl = [CommonUtils changeImageUrlStr:product.shareUrl];
            CodeActionSheet* codeSheet = [[CodeActionSheet alloc] initWithImageCode:[QRCodeUtils generateQRImage:shareUrl]];
            [codeSheet showInView:self.view];
            
        }
            break;
            
        case 2:
        {
            [self shareWebTo:UMSocialPlatformType_WechatSession];
        }
            break;
        case 3:
        {
            [self shareWebTo:UMSocialPlatformType_WechatTimeLine];
        }
            break;
        case 4:
        {
            [self shareWebTo:UMSocialPlatformType_QQ];
        }
            break;
            
        default:
            break;
    }
}

- (void)shareWebTo:(UMSocialPlatformType)UMSocialPlatformType {
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    NSString *imgUrl = [CommonUtils changeImageUrlStr:product.image];
    UMShareWebpageObject *webObject = [UMShareWebpageObject shareObjectWithTitle:product.name descr:sharecontent thumImage:imgUrl];
    webObject.webpageUrl = product.shareUrl;
    
    messageObject.shareObject = webObject;
    //设置文本
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            NSLog(@"response data is %@",data);
        }
    }];
}

//售后服务
- (void)serverDetailsAction{
    
    // @"支持货到付款"
    NSString *productInfoVC_item1_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"productInfoVC_item1_title"];
    // @"假一赔十"
    NSString *productInfoVC_item2_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"productInfoVC_item2_title"];
    // @"增值税发票"
    NSString *productInfoVC_item3_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"productInfoVC_item3_title"];
    // @"七天无理由退货"
    NSString *productInfoVC_item4_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"productInfoVC_item4_title"];
    // @"满500元免运费"
    NSString *productInfoVC_item5_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"productInfoVC_item5_title"];
    // @"服务说明"
    NSString *productInfoVC_sheet_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"productInfoVC_sheet_title"];
    Item *item1 = [[Item alloc] init];
    item1.title = productInfoVC_item1_title;
    Item *item2 = [[Item alloc] init];
    item2.title = productInfoVC_item2_title;
    Item *item3 = [[Item alloc] init];
    item3.title = productInfoVC_item3_title;
    Item *item4 = [[Item alloc] init];
    item4.title = productInfoVC_item4_title;
    Item *item5 = [[Item alloc] init];
    item5.title = productInfoVC_item5_title;
    
    NSArray *listData = [NSArray arrayWithObjects:item1,item2,item3,item4,item5, nil];
    PicAndTextActionSheet *sheet = [[PicAndTextActionSheet alloc] initWithList:listData title:productInfoVC_sheet_title];
    [sheet showInView:self];
}

//选择规格数量
- (void)selSpecQuantityAction{
    [self popupProdSpecPopupScreen];
    //sheet.view.frame = CGRectMake(0, 0, ScreenWidth, 400);
    //[self.view addSubview:sheet.view];
}

- (void)clickPromotionAction:(UIButton *)button{
    ProdList *prodList = [[ProdList alloc] initWithNibName:@"ProdList" bundle:nil];
    //    AppPromotion *promotion = [product.validPromotions objectAtIndex:0];
    prodList.promotionId = button.tag;
    [self.navigationController pushViewController:prodList animated:YES];
    
}

- (void)clickCouponAction:(UIButton *)button{
    CouponDetailViewController *couponDetail = [[CouponDetailViewController alloc] init];
    couponDetail.couponId = button.tag;
    [self.navigationController pushViewController:couponDetail animated:YES];
    
}

- (void)popupProdSpecPopupScreen{
    if (specSelController == NULL){
        specSelController = [[ProdSpecificationViewController alloc] myInitWithNibName:@"ProdSpecificationViewController" bundle:nil product:product];
        NSString *strProductId = [[NSString alloc] initWithFormat:@"%d", _productId];
        specSelController.startPage = [[api_host stringByAppendingString:@"product/specifications2.jhtm?os=IOS&productId="] stringByAppendingString:strProductId];
    }
    if (popupController == NULL){
        popupController = [[STPopupController alloc] initWithRootViewController:specSelController];
        [popupController.backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popupDismiss)]];
        [popupController setNavigationBarHidden:YES];
        popupController.style = STPopupStyleBottomSheet;
        [specSelController setProduct:product];
        specSelController.msgHandler = self;
    }
    [popupController presentInViewController:self];
}

//呼叫客服
- (void)callToServers:(id)sender{
    
    // @"联系客服"
    NSString *productInfoVC_webView_navTitle = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"productInfoVC_webView_navTitle"];
    MyWebView *myWebView = [[MyWebView alloc] init];
    myWebView.navTitle = productInfoVC_webView_navTitle;
    NSString *url = [[Config Instance] getUserInfo:onlineUrl];
    myWebView.loadUrl = url;
    myWebView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:myWebView animated:YES];
}

#pragma 点击图片的方法

- (void)clickImageScrollView:(UIButton *)button{
    
    //    NSLog(@"点击了图片");
    
    ProdImageScroll *prodImageScroll = [[ProdImageScroll alloc] initWithNibName:@"ProdImageScroll" bundle:nil];
    prodImageScroll.prodImages = product.appProductImages;
    [self.navigationController pushViewController:prodImageScroll animated:YES];
}


#pragma 点击导航的购物车
- (void)clickCart:(id)sender{
    CartController *cartController = [[CartController alloc] init];
    //    cartController.type = @"product";
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:cartController animated:YES];
}

#pragma 立即购买
- (void)buyAtonce:(id)sender{
    isBuyAtOnce = true;
    if (![CommonUtils chkLogin:self gotoLoginScreen:YES]) {
        return ;
    }
    [self popupProdSpecPopupScreen];
}

#pragma 加入购物车
- (void)addCartItem:(id)sender{
    isBuyAtOnce = false;
    [self popupProdSpecPopupScreen];
    //[cartService addCartItem:product.id quantity:1];
}

#pragma 收藏
- (void)addFavorite:(UIButton*)sender{
    
    FavoriteService *favoriteService = [[FavoriteService alloc] initWithDelegate:self parentView:self.view];
    
    if ([CommonUtils chkLogin:self gotoLoginScreen:YES]){
        
        // @"已加入收藏"
        NSString *productInfoVC_toastNotification_msg3 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"productInfoVC_toastNotification_msg3"];
        // @"已取消收藏"
        NSString *productInfoVC_toastNotification_msg4 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"productInfoVC_toastNotification_msg4"];
 
        if (product.isFavorited){
            [favoriteService delFavorite:product.id success:^(BaseModel *responseObj) {
                StatusResponse *resp = (StatusResponse*)responseObj;
                if (resp.status.succeed == 1){
                    [CommonUtils ToastNotification:productInfoVC_toastNotification_msg4 andView:self.view andLoading:NO andIsBottom:NO];
                    _collectImageView.image = [UIImage imageNamed:@"收藏1"];
                    product.isFavorited = false;
                }
            }];
        }
        else [favoriteService addFavorite:product.id success:^(BaseModel *responseObj) {
                StatusResponse *resp = (StatusResponse*)responseObj;
                if (resp.status.succeed == 1){
                    [CommonUtils ToastNotification:productInfoVC_toastNotification_msg3 andView:self.view andLoading:NO andIsBottom:NO];
                    _collectImageView.image = [UIImage imageNamed:@"收藏2"];
                    product.isFavorited = true;
                }
        }];
    }
}


- (void)sendMessage:(Message *)msg{
    if (msg.what == 1) {
        //click Product Image
        ProdImageScroll *prodImageScroll = [[ProdImageScroll alloc] initWithNibName:@"ProdImageScroll" bundle:nil];
        prodImageScroll.prodImages = product.appProductImages;
        [self.navigationController pushViewController:prodImageScroll animated:YES];
    } else if (msg.what == 2){
        //select specification
        [_lblSelections setText:(NSString*)msg.obj];
    } else if (msg.what == 3){
        //add to cart or buy (click 'ok' button)
        if (popupController != NULL){
            [popupController dismiss];
        }
        if(isBuyAtOnce){
            
            [orderService buildOrderAtOnceWithProductId:(int)msg.int1 quantity:(int)msg.int2];
        }else{
            [cartService addCartItem:(int)msg.int1 quantity:(int)msg.int2];
        }
        
    } else if (msg.what == 4){
        //close specification popup
        
        [self popupDismiss];
    }
}

- (void)popupDismiss {
    
    if (popupController != NULL){
        [popupController dismiss];
    }
}
#pragma mark - //返回请求数据

- (void)loadResponse:(NSString *) url response:(BaseModel *)response{
    
    // @"已加入购物车"
    NSString *productInfoVC_toastNotification_msg2 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"productInfoVC_toastNotification_msg2"];
    
    if ([url  isEqual: api_product_info]){
        
        ProductDetailResponse * prodDetailResponse = (ProductDetailResponse *)response;
        product = prodDetailResponse.data;
        
        kNumberOfPages = product.appProductImages.count;
        NSMutableArray* controllers = [[NSMutableArray alloc] init];
        
        for (int i = 0 ; i < kNumberOfPages; i++) {
            [controllers addObject:[NSNull null]];
        }
        
        self.viewControllers = controllers;
        self.imageScrollView.pagingEnabled = YES;
        self.imageScrollView.contentSize = CGSizeMake(self.imageScrollView.frame.size.width*kNumberOfPages,
                                                      self.imageScrollView.frame.size.height);
        
        self.imageScrollView.showsHorizontalScrollIndicator = NO;
        self.imageScrollView.showsVerticalScrollIndicator = NO;
        self.imageScrollView.scrollsToTop = NO;
        self.imageScrollView.delegate = self;
        
        self.pageControl.numberOfPages = kNumberOfPages;
        self.pageControl.currentPage = 0;
        
        [self.pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
        
        [self loadScrollViewWithPage:0];
        [self loadScrollViewWithPage:1];
        [self displayProdInfo];
        
        
    } else if ([url isEqualToString:api_cart_list]){
        CartResponse *respobj = (CartResponse*)response;
        if ([respobj.data getQuantities] > 99) {
            [self.navigationItem.rightBarButtonItems objectAtIndex:1].badgeValue =  @"…";
        }else{
            [self.navigationItem.rightBarButtonItems objectAtIndex:1].badgeValue = [[NSString alloc] initWithFormat:@"%d", [respobj.data getQuantities]];
        }
    }else if ([url  isEqual: api_cart_item_add]){
        CartResponse * cartResponse = (CartResponse *)response;
        if (cartResponse.status.succeed == 1){
            [SESSION getSession].cartId = cartResponse.data.cartId;
            [CommonUtils ToastNotification:productInfoVC_toastNotification_msg2 andView:self.view andLoading:NO andIsBottom:YES];
            [AppStatic setCART_ITEM_QUANTITIES:[cartResponse.data getQuantities]];
            
            [self.navigationItem.rightBarButtonItems objectAtIndex:1].badgeValue = [[NSString alloc] initWithFormat:@"%d", [AppStatic CART_ITEM_QUANTITIES ]];
            
            if (isBuyAtOnce){
                CartController *cartController = [[CartController alloc] initWithNibName:@"CartController" bundle:nil];
                [self.navigationController pushViewController:cartController animated:YES];
                isBuyAtOnce = false;
            }
        }
    } else if ([url isEqualToString:api_order_build_buyatonce]){
        OrderBuildResponse2 * orderBuildResponse = (OrderBuildResponse2 *)response;
        if (orderBuildResponse.status.succeed == 1){
            
            OrderController *orderController = [[OrderController alloc] initWithNibName:@"OrderController" bundle:nil];
            [orderController setOrderBuildResponse:orderBuildResponse];
            [self.navigationController pushViewController:orderController animated:YES];
        } else {
            [CommonUtils ToastNotification:orderBuildResponse.status.error_desc andView:self.view andLoading:NO andIsBottom:NO];
        }
    }
}

#pragma 配置商品信息
- (void) displayProdInfo{
    
    self.name.text = product.name;
    self.brief.text = product.brief;
    if (product.makerModel){
        self.makerModel.text = product.makerModel;
    } else {
        // @"暂无"
        NSString *productInfoVC_makerModel_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"productInfoVC_makerModel_title"];
        self.makerModel.text = productInfoVC_makerModel_title;
    }
    
#pragma mark - //** 秒杀配置修改-秒杀价格展示 **//
    
    if (product.secondProductInfo.secondPrice){
        self.price.attributedText = [CommonUtils getProductPriceAttributedStringFromString:[CommonUtils formatCurrency:product.secondProductInfo.secondPrice]];
        self.lbMarketPriceWord.hidden = NO;
        self.marketPrice.attributedText = [CommonUtils addDeleteLineOnLabel:[CommonUtils formatCurrency:product.price]];
    }
    else if (product.promotionPrice){
        self.price.attributedText = [CommonUtils getProductPriceAttributedStringFromString:[CommonUtils formatCurrency:product.promotionPrice]];
        self.lbMarketPriceWord.hidden = NO;
        self.marketPrice.attributedText = [CommonUtils addDeleteLineOnLabel:[CommonUtils formatCurrency:product.price]];
    }
    else {
        self.price.attributedText = [CommonUtils getProductPriceAttributedStringFromString:[CommonUtils formatCurrency:product.price]];
        self.lbMarketPriceWord.hidden = YES;
        [self.marketPrice removeFromSuperview];
    }
    
    self.preheatView.beginTime = product.secondProductInfo.activityBegin;
    self.countdownView.endTime = product.secondProductInfo.activityEnd;
    
    // @"商品编号:"
    NSString *productInfoVC_sn_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"productInfoVC_sn_title"];
    self.sn.text = [productInfoVC_sn_title stringByAppendingString: product.sn];
    self.brand.text = product.appBrand.name;
    
    CGSize briefSize = [CommonUtils returnLabelSize:self.brief.text font:self.brief.font];
    // 去除 . 描述
    if ([self.brief.text isEqualToString:@"."] || self.brief.text.length < 3) {
        briefSize = CGSizeMake(0, 0);
    }
    CGSize lbMarketPriceWordSize = [CommonUtils returnLabelSize:self.lbMarketPriceWord.text font:self.lbMarketPriceWord.font];
    CGSize priceSize = [CommonUtils returnLabelSize:self.price.text font:[UIFont systemFontWithSize:16.0]];
    CGSize marketPriceSize = [CommonUtils returnLabelSize:self.marketPrice.text font:self.marketPrice.font];
    
    self.brief.frame = (CGRectMake(kWidthOfSpace, CGRectGetMaxY(self.name.frame), kWidth-kWidthOfSpace*2, briefSize.height));
    self.price.frame = CGRectMake(kWidthOfSpace, CGRectGetMaxY(self.brief.frame), priceSize.width,  TMScreenH *35/568);
    
    // 隐藏土猫价
    self.lbMarketPriceWord.frame = CGRectMake(priceSize.width + TMScreenW *10/320, CGRectGetMaxY(self.brief.frame) + TMScreenW *8/320, 0, kHeightOfLabel);
    
    self.marketPrice.frame = CGRectMake(CGRectGetMaxX(self.lbMarketPriceWord.frame) + kWidth*2/320, CGRectGetMaxY(self.brief.frame) +  TMScreenH *8/568, marketPriceSize.width, kHeightOfLabel);
    
    //    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.marketPrice.frame)/2.0, marketPriceSize.width, 1)];
    //    view.backgroundColor = [UIColor lightGrayColor];
    //    [self.marketPrice addSubview:view];
    
    
    self.lblBrand.frame = CGRectMake(kWidthOfSpace, CGRectGetMaxY(self.price.frame) , kWidth-kWidthOfSpace, kHeightOfLabel);
    self.brand.frame = CGRectMake(kWidthOfSpace + TMScreenW *30/320, CGRectGetMaxY(self.price.frame) , kWidth-kWidthOfSpace - TMScreenW *30/320, kHeightOfLabel);
    self.postage.frame = CGRectMake(kWidth- TMScreenW *90/320, CGRectGetMinY(self.brand.frame), TMScreenW *80/320, kHeightOfLabel);
    self.lblProId.frame = CGRectMake( kWidthOfSpace , CGRectGetMaxY(_lblBrand.frame) , (kWidth-kWidthOfSpace*2)/2.0, kHeightOfLabel);
    self.makerModel.frame = CGRectMake( kWidthOfSpace + TMScreenW *35/320 , CGRectGetMaxY(_lblBrand.frame) , (kWidth-kWidthOfSpace*2)/2.0 - TMScreenW *30/320, kHeightOfLabel);
    self.sn.frame = CGRectMake(kWidth - TMScreenW *110/320, CGRectGetMinY(self.makerModel.frame), TMScreenW *100/320, kHeightOfLabel);
    
    
    
    _postage.frame = CGRectMake(kWidth- TMScreenW *90/320, CGRectGetMinY(self.brand.frame), TMScreenW *80/320, kHeightOfLabel);
    
    // @"由%@发货并提供售后服务"
    NSString *productInfoVC_merchant_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"productInfoVC_merchant_title"];
    // @"运费:"
    NSString *productInfoVC_postage_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"productInfoVC_postage_title"];
    self.merchant.text = [[NSString alloc] initWithFormat:productInfoVC_merchant_title, product.shopName];
    if (product.isFavorited){
        self.btnCollect.imageView.image = [UIImage imageNamed:@"收藏2"];
    }
    if ([NSString stringWithFormat:@"%@",product.freight].length > 0 && product.freight > 0) {
        self.postage.text = [productInfoVC_postage_title stringByAppendingString: [CommonUtils formatCurrency:product.freight]];
    }
    if (product.validPromotions.count==0 && product.validCoupons.count == 0) {
        
        _btnServer.frame = CGRectMake(0, CGRectGetMaxY(_btnSelections.frame)+1, kWidth,  TMScreenH *40/568);
        //        CGRectMake(0, CGRectGetMaxY(_btnSelections.frame)+2, kWidth, 30);
    } else {
        
        //AppPromotion *promotion = [product.validPromotions objectAtIndex:0];
        //[_lblSaleDown setText:promotion.name];
        CGFloat promHeight =  TMScreenH *40/568;
        float height = (promHeight +1) * (product.validCoupons.count + product.validPromotions.count);
        _btnSelections.frame = CGRectMake(0, height, kWidth,  TMScreenH *40/568);
        _btnServer.frame = CGRectMake(0, CGRectGetMaxY(_btnSelections.frame) +1, kWidth,  TMScreenH *40/568);
        
        AppPromotion *promotion = nil;
        //        float compY =CGRectGetMaxY(_btnSelections.frame)+1;
        float compY = 0;
        for (int i=0; i<product.validPromotions.count; i++){
            promotion = product.validPromotions[i];
            
            UIView *promotionView = [[UIView alloc] initWithFrame:(CGRectMake(0, compY, kWidth, promHeight))];
            promotionView.backgroundColor = [UIColor whiteColor];
            [_viewDown addSubview:promotionView];
            
            EGOImageView *imgView = [[EGOImageView alloc] initWithFrame:CGRectMake(kWidth *10/320, 0, promHeight, promHeight)];
            imgView.placeholderImage = [UIImage imageNamed:@"promotionImg.png"];
            imgView.imageURL = [URLUtils createURL:promotion.image];
            //            [imgView setImage:[UIImage imageNamed:@"couponImg.png"]];
            [promotionView addSubview:imgView];
            
            UILabel *lblSaleDown = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imgView.frame)+ kWidth *5/320, 0, kWidth- kWidth *(60+30)/320, promHeight)];
            lblSaleDown.text = promotion.title;
            lblSaleDown.font = [UIFont systemFontWithSize:12];
            lblSaleDown.textColor = TMBlackColor;
            [promotionView addSubview:lblSaleDown];
            
            UIImageView *imgTwo  = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth - kWidth *30/320, (promHeight - kWidth *16/320) / 2, kWidth *10/320,  kWidth *16/320)];
            imgTwo.image = [UIImage imageNamed:@"gray_right_arrow.png"];
            [promotionView addSubview:imgTwo];
            
            //   促销活动
            UIButton *btnSaleDown = [UIButton buttonWithType:UIButtonTypeCustom];
            btnSaleDown.frame = CGRectMake(0, 0, kWidth, promHeight);
            [btnSaleDown setTag:promotion.id];
            [btnSaleDown addTarget:self action:@selector(clickPromotionAction:) forControlEvents:UIControlEventTouchUpInside];
            [promotionView addSubview:btnSaleDown];
            
            compY = compY + promHeight + 1;
        }
        
        AppCoupon *coupon = nil;
        for (int i=0; i<product.validCoupons.count; i++){
            coupon = product.validCoupons[i];
            
            UIView *couponView = [[UIView alloc] initWithFrame:(CGRectMake(0, compY, kWidth, promHeight))];
            couponView.backgroundColor = [UIColor whiteColor];
            [_viewDown addSubview:couponView];
            
            EGOImageView *imgView = [[EGOImageView alloc] initWithFrame:CGRectMake(kWidth *10/320, 0, promHeight, promHeight)];
            imgView.placeholderImage = [UIImage imageNamed:@"couponImg.png"];
            imgView.imageURL = [URLUtils createURL:coupon.image];
            [couponView addSubview:imgView];
            
            UILabel *lblSaleDown = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imgView.frame)+ kWidth *5/320, 0, kWidth- kWidth *(60+30)/320, promHeight)];
            lblSaleDown.text = coupon.name;
            lblSaleDown.font = [UIFont systemFontWithSize:12];
            lblSaleDown.textColor = TMBlackColor;
            [couponView addSubview:lblSaleDown];
            
            UIImageView *imgTwo  = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth - kWidth *30/320, (promHeight - kWidth *16/320) / 2, kWidth *10/320,  kWidth *16/320)];
            imgTwo.image = [UIImage imageNamed:@"gray_right_arrow.png"];
            [couponView addSubview:imgTwo];
            
            // 折扣券
            UIButton *btnSaleDown = [UIButton buttonWithType:UIButtonTypeCustom];
            btnSaleDown.frame = CGRectMake(0, 0, kWidth, promHeight);
            [btnSaleDown setTag:coupon.id];
            [btnSaleDown addTarget:self action:@selector(clickCouponAction:) forControlEvents:UIControlEventTouchUpInside];
            [couponView addSubview:btnSaleDown];
            
            compY = compY + promHeight + 1;
        }
        
    }
#pragma mark - //** 秒杀配置修改-是否加入购物车 **//
    
    CGFloat ss = TMScreenW*60/320;
    CGFloat space = (kWidth - 2*ss)/2.0;
    CGFloat itemW10 = TMScreenW*10/320;
    if (product.isOffsale || (!product.secondProductInfo.addCartEnable && product.secondProductInfo)
        ){
        _btnAddCar.hidden = YES;
        _btnBuyNow.frame = CGRectMake(CGRectGetMinX(_btnAddCar.frame), _btnBuyNow.frame.origin.y, kWidth - CGRectGetMinX(_btnAddCar.frame), _btnBuyNow.frame.size.height);
    }
    else {
        _btnAddCar.hidden = NO;
        _btnBuyNow.frame = CGRectMake(CGRectGetMaxX(_btnAddCar.frame), 0, space + itemW10, kHeightOfButtomButton);
    }
    
    
    if (product.isFavorited){
        _collectImageView.image = [UIImage imageNamed:@"收藏2"];
    }
    if (product.isDeleted) {
        
        [self disPlayIsDeleteView];
    }
    
    [self configSecKillView];
    
    [self resizeLayout];
}

#pragma mark - 秒杀状态配置
- (void)configSecKillView {
    
    int productState = [self getProductStateWithPreheatDate:product.secondProductInfo.preheatDate activityBegin:product.secondProductInfo.activityBegin activityEnd:product.secondProductInfo.activityEnd];
    
    switch (productState) {
        case 0:
        {
            self.preheatView.hidden = YES;
            self.countdownView.hidden = YES;
        }
            break;
        case 1:
        {
            self.preheatView.hidden = NO;
            self.countdownView.hidden = YES;
            self.preheatView.frame = CGRectMake(kWidth - kWidth*135/320, CGRectGetMaxY(self.brief.frame) +kHeight *5/568, kWidth *135/320, kHeight *25/568);
            
            [_btnBuyNow setTitle:@"即将开始..." forState:(UIControlStateNormal)];
            [_btnBuyNow setBackgroundColor:[UIColor lightGrayColor]];
            _btnBuyNow.userInteractionEnabled = NO;
        }
            break;
        case 2:
        {
            self.preheatView.hidden = YES;
            self.countdownView.hidden = NO;
            self.countdownView.frame = CGRectMake(kWidth - kWidth*135/320, CGRectGetMaxY(self.brief.frame) +kHeight *5/568, kWidth *135/320, kHeight *25/568);
            [self.view updateConstraints];
            
            [_btnBuyNow setTitle:@"立即购买" forState:(UIControlStateNormal)];
            [_btnBuyNow setBackgroundColor:redColorSelf];
            _btnBuyNow.userInteractionEnabled = YES;
        }
            break;
        case 3:
        {
            self.preheatView.hidden = YES;
            self.countdownView.hidden = YES;
        }
            break;
        default:
            break;
    }
    
    if (product.secondProductInfo.isSaleOut) {
        
        [_btnBuyNow setTitle:@"抢光了" forState:(UIControlStateNormal)];
        [_btnBuyNow setBackgroundColor:[UIColor lightGrayColor]];
        _btnBuyNow.userInteractionEnabled = NO;
    }
    //    product.secondProductInfo.hasChance = 1;
    if (product.secondProductInfo.isSaleOut && product.secondProductInfo.hasChance) {
        
        [self disPlayHaveChanceView];
    }
    
}

//图片轮播换页
-(void) changePage:(id)sender{
    NSInteger page = self.pageControl.currentPage;
    
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    
    
    CGRect frame = self.imageScrollView.frame;
    frame.origin.x = frame.size.width*page;
    frame.origin.y = 0;
    [self.imageScrollView scrollRectToVisible:frame animated:YES];
    
    pageControlUsed = YES;
}


-(void) loadScrollViewWithPage:(NSInteger)page{
    if (page < 0) {
        return;
    }else if(page >= kNumberOfPages) {
        
        return;
    }
    
    ProdInfoImage * controller = [self.viewControllers objectAtIndex:page];
    if ((NSNull*)controller == [NSNull null]) {
        controller = [[ProdInfoImage alloc] init];
        controller.frame = self.imageScrollView.frame;
        //controller.msgHandler = self;
        [self.viewControllers replaceObjectAtIndex:page withObject:controller];
    }
    
    if (controller.view.superview == nil) {
        CGRect frame = self.imageScrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        [self.imageScrollView addSubview:controller.view];
        
        AppProductImage *productImage =[product.appProductImages objectAtIndex:page];
        NSString* url = productImage.medium;
        controller.image.imageURL = [NSURL URLWithString:url];
        
    }
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == self.imageScrollView) {
        if (pageControlUsed) {
            return;
        }
        CGFloat pageWidth = _imageScrollView.frame.size.width;
        //page表示当前滚动哪一页的标识
        int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth)+1;
        
        self.pageControl.currentPage = page;
        [self loadScrollViewWithPage:page-1];
        [self loadScrollViewWithPage:page];
        [self loadScrollViewWithPage:page+1];
    }
}


-(void) scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.imageScrollView) {
        pageControlUsed = NO;
    }
}

//最后执行
-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.imageScrollView) {
        pageControlUsed = NO;
    }
    else if (scrollView == self.scrollView){
    }
}

//拖拽释放 2
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
}

//拖拽释放 1
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    if (scrollView == self.scrollView) {
        _isFirstDragging = NO;
        _detailVC.scrollView.hidden = NO;
        NSString * strurl = [[[api_host stringByAppendingString:api_product_desc] stringByAppendingString:@"?productId="] stringByAppendingString:[NSString stringWithFormat:@"%d", _productId]];
        NSURL *url = [[NSURL alloc] initWithString:strurl];
        [_detailVC.webView loadRequest:[NSURLRequest requestWithURL:url]];
    }
}

//将要拖拽
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (scrollView == self.scrollView) {
    
        if (!_detailVC) {
            
            _detailVC = [[ProductDetailViewController alloc] init];
        }
        _detailVC.productId = _productId;
        [self addChildViewController:_detailVC];
        //         just for force load view
        if (_detailVC.view != nil) {
            
            _scrollView.secondScrollView = _detailVC.scrollView;
        }
        
        if (_isFirstDragging == YES) {
            _detailVC.scrollView.hidden = YES;
        }
        else if (_isFirstDragging == NO){
            _detailVC.scrollView.hidden = NO;
        }
    }
}


#pragma mark - /** 倒计时状态 结束 回调处理 **/
- (void)senMessageActivityisBegin {
    [self performSelector:@selector(displayProdInfo) withObject:nil afterDelay:2.0];
}

- (void)senMessageActivityisEnd {
    product.secondProductInfo = nil;
    [self performSelector:@selector(displayProdInfo) withObject:nil afterDelay:1.0];
}
@end
