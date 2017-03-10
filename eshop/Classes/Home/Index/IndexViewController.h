//
//  IndexViewController.h
//  eshop
//
//  Created by mc on 16/3/16.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CartService.h"
#import "MsgList.h"
//#import "CodeScan.h"
#import "AppUpdate.h"
#import "VersionService.h"
#import "VersionService.h"
#import "ProdHotKeySearchViewController.h"
//#import "ToolMallRecommend.h"
#import "IndexResponse.h"
#import "IndexService.h"
#import "FavoriteListController.h"
#import "ShopLogin.h"
#import "RegisteViewController.h"
#import "IndexImage.h"
#import "AppIndexUrl.h"
#import "ProdList.h"
#import "MoreBrands.h"
#import "CatSecdListViewController.h"
#import "PromotionList.h"
#import "CouponCodeList.h"
#import "ActivityViewController.h"
#import "LBXScanViewController.h"
#import "SubLBXScanViewController.h"

@interface IndexViewController :UIBaseController<ServiceResponselDelegate,UIScrollViewDelegate,UIScrollViewAccessibilityDelegate,EGORefreshTableHeaderDelegate>{
    
    EGORefreshTableHeaderView *refreshHeaderView;
    
    //  Reloading var should really be your tableviews datasource
    //  Putting it here for demo purposes
    BOOL reloading;
    
    IndexResponse * indexResponse;
    IndexService * indexService;
     Pagination * pagination;
    
    CartService *cartService;
    VersionService *versionService;
    AppUpdate *appUpdate;
    
}

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

@property (nonatomic, strong) UIButton * searchBtn;
@property (strong, nonatomic) IBOutlet UIScrollView *backScrollView;  // 背景ScrollView

@property (strong, nonatomic) IBOutlet UIScrollView *imageScroll;   // 轮播图
@property (strong, nonatomic)  UIPageControl *pagecontroll;
@property(nonatomic) NSMutableArray* viewControllers;
@property (strong, nonatomic)  UIButton *btnClickImage;

@property (weak, nonatomic) IBOutlet UIView *faststockView; // 快速进货
@property (weak, nonatomic) IBOutlet UIButton *faststockBtn;

@property (strong, nonatomic) IBOutlet UIView *menu;  // 4button背景View
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (strong, nonatomic) IBOutlet UIButton *btnMenu1;
@property (weak, nonatomic) IBOutlet UILabel *labMenu1;
@property (weak, nonatomic) IBOutlet EGOImageView *imgMenu1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (strong, nonatomic) IBOutlet UIButton *btnMenu2;
@property (weak, nonatomic) IBOutlet UILabel *labMenu2;
@property (weak, nonatomic) IBOutlet EGOImageView *imgMenu2;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (strong, nonatomic) IBOutlet UIButton *btnMenu3;
@property (weak, nonatomic) IBOutlet UILabel *labMenu3;
@property (weak, nonatomic) IBOutlet EGOImageView *imgMenu3;
@property (weak, nonatomic) IBOutlet UIView *view4;
@property (strong, nonatomic) IBOutlet UIButton *btnMenu4;
@property (weak, nonatomic) IBOutlet UILabel *labMenu4;
@property (weak, nonatomic) IBOutlet EGOImageView *imgMenu4;

@property (strong, nonatomic) IBOutlet UIView *toolmallRecommendView; //土猫推荐
@property (weak, nonatomic) IBOutlet EGOImageView *tmRimg1;
@property (weak, nonatomic) IBOutlet UILabel *tmRtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *tmRmoreLabel;
@property (weak, nonatomic) IBOutlet EGOImageView *tmRimg2;
@property (weak, nonatomic) IBOutlet UIButton *toolmallRecommendBtn;
@property (strong, nonatomic) UIScrollView *scrollFoot; //土猫推荐内容背景
@property (strong, nonatomic) EGOImageView *advImage1;

@property (strong, nonatomic) IBOutlet UIView *hotActivityView; //热门活动项
@property (weak, nonatomic) IBOutlet EGOImageView *tmHimg1;
@property (weak, nonatomic) IBOutlet UILabel *tmHtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *tmHmoreLabel;
@property (weak, nonatomic) IBOutlet EGOImageView *tmHimg2;
@property (strong, nonatomic) UIView * imageListView;
@property (strong, nonatomic) EGOImageView *advImage2;

@property (weak, nonatomic) IBOutlet UIView *todaybrandView; // 今日大牌
@property (weak, nonatomic) IBOutlet EGOImageView *tmTimg1;
@property (weak, nonatomic) IBOutlet UILabel *tmTtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *tmTmoreLabel;
@property (weak, nonatomic) IBOutlet EGOImageView *tmTimg2;
@property (weak, nonatomic) IBOutlet UIButton *todaybrandBtn;
@property (strong, nonatomic) UIView *todayListView;

@property (weak, nonatomic) IBOutlet UIView *allclassifyView; // 全部分类
@property (weak, nonatomic) IBOutlet EGOImageView *tmAimg1;
@property (weak, nonatomic) IBOutlet UILabel *tmAtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *tmAmoreLabel;
@property (weak, nonatomic) IBOutlet EGOImageView *tmAimg2;
@property (weak, nonatomic) IBOutlet UIButton *allclassifyBtn;
@property (strong, nonatomic) UIView *allClassifyListView;


@property (weak, nonatomic) IBOutlet UIView *moreView;

@property (weak, nonatomic) IBOutlet UIView *onlineserviceView; // 在线客服
@property (weak, nonatomic) IBOutlet EGOImageView *tmLimg1;
@property (weak, nonatomic) IBOutlet UILabel *tmLtitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *onlineserviceBtn;

@property (weak, nonatomic) IBOutlet UIView *hottelephoneView; // 热线电话
@property (weak, nonatomic) IBOutlet EGOImageView *tmPimg1;
@property (weak, nonatomic) IBOutlet UILabel *tmPtitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *hottelephoneBtn;

//存储数据
@property (strong, nonatomic) NSMutableArray * arrayImage; //顶端广告条
@property (strong, nonatomic) NSMutableArray * arrayFour; //中间的四个按钮
@property (strong, nonatomic) NSMutableArray * arrayRecommend; //土猫推荐数组
@property (strong, nonatomic) NSMutableArray * arrayHot; //热门图片数组
@property (strong, nonatomic) NSMutableArray * arrayBrand; //今日大牌数组
@property (strong, nonatomic) NSMutableArray * arrayTop; //顶端菜单按钮


@property (nonatomic) int statues;

@property (nonatomic, copy) NSString *type;

@end
