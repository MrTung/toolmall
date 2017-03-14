//
//  IndexViewController.m
//  eshop
//
//  Created by mc on 16/3/16.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import "IndexViewController.h"

#import "CatRootListViewController.h"
#import "TollMallRDViewController.h"
#import "RecommendView.h"
#import "CountdownView.h"
#import "HotActiveView1.h"
#import "HotActiveView2.h"
#import "HotActiveView3.h"
#import "TodayBrandView.h"
#import "AllClassifyView.h"
#import "UIFont+Fit.h"

#import "GDataXMLNode.h"
#import "TextModel.h"
#import "JSWebView.h"

#import "PYSearch.h"



@interface IndexViewController ()<UIAlertViewDelegate, NSXMLParserDelegate,PYSearchViewControllerDelegate>
{
    dispatch_source_t _timer;
    NSDateFormatter *dateFormatter;
    
    UILabel * lblShow;
    
    BOOL pageControlUsed;
    NSUInteger kNumberOfPages;
    AppProduct * product;
    ProductService *productService;
    FavoriteService *favoriteService;
    
    Boolean isBuyAtOnce;
    
    float totalHeight; //推荐的高度
    float tHeight;//整个页面的高度
    float offset;//偏移量
    
    __weak __typeof(PYSearchViewController*)weakVC;
}
@property (nonatomic, retain) UIViewController *lastVC;
@property (strong, nonatomic) CountdownView *cdView;
@property (nonatomic, strong) NSMutableArray * hotArray; //热门搜索词

@end

@implementation IndexViewController

@synthesize arrayBrand = _arrayBrand;
@synthesize arrayFour = _arrayFour;
@synthesize arrayHot = _arrayHot;
@synthesize arrayImage = _arrayImage;
@synthesize arrayRecommend = _arrayRecommend;
@synthesize arrayTop = _arrayTop;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.tabBarController.tabBar.hidden = YES;
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self configureCutLine];
    
    [self getLocalXmlStr];
    
    [self refreshData];
    
    self.backScrollView.frame = CGRectMake(0, 0, TMScreenW, TMScreenH-64-49);
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.backScrollView.contentSize = CGSizeMake(0, 2000);
    self.backScrollView.backgroundColor = groupTableViewBackgroundColorSelf;
    
    [self createNav];
    
    [self createUI];
    
    CartService *cartService = [[CartService alloc] initWithDelegate:self parentView:self.view];
    [cartService getCartList:NO];
    
    [self checkVersion];
    
    if (refreshHeaderView == nil) {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.backScrollView.bounds.size.height, self.backScrollView.frame.size.width, self.backScrollView.bounds.size.height)];
        view.delegate = self;
        [self.backScrollView addSubview:view];
        refreshHeaderView = view;
    }
}

/**
 检测版本更新
 */
-(void)checkVersion{
    VersionService *versionService = [[VersionService alloc] initWithDelegate:self parentView:self.view];
    [versionService getUpgradePolicy:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"] success:^(BaseModel *responseObj) {
        appUpdate = (AppUpdate*)responseObj;
        if (!appUpdate.isLatestVersion){
            // 立即更新
            NSString *index_force_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"index_force_title"];
            // 立即更新
            NSString *index_remind_cancelTitle = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"index_remind_cancelTitle"];
            // 以后再说
            NSString *index_remind_otherTitle = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"index_remind_otherTitle"];
            if (!index_remind_otherTitle.length || !index_remind_cancelTitle.length || !index_force_title.length) {
                index_remind_otherTitle = @"以后再说";
                index_remind_cancelTitle = @"立即更新";
                index_force_title = @"立即更新";
            }
            if ([appUpdate.upgradePolicy isEqualToString:@"force"]){
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:appUpdate.upgradeMsg delegate:self cancelButtonTitle:index_force_title otherButtonTitles:nil, nil];
                [alertView show];
            } else if ([appUpdate.upgradePolicy isEqualToString:@"remind"]){
                NSString *lastRemindDate = [[Config Instance] getUserInfo:@"AppLastRemindDate"];
                NSDateFormatter *format1=[[NSDateFormatter alloc]init];
                [format1 setDateFormat:@"yyyy/MM/dd"];
                NSString *today=[format1 stringFromDate:[NSDate date]];
                if (![today isEqualToString:lastRemindDate]){
                    [[Config Instance] saveUserInfo:@"AppLastRemindDate" withvalue:today];
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:appUpdate.upgradeMsg delegate:self cancelButtonTitle:index_remind_cancelTitle otherButtonTitles:index_remind_otherTitle, nil];
                    [alertView show];
                }
            }
        }
    }];
}

- (void)refreshData {
    
    IndexService * indexService = [[IndexService alloc] initWithDelegate:self parentView:self.view];
    indexResponse = [[IndexResponse alloc] init];
    _arrayHot = [[NSMutableArray alloc] init];
    _arrayRecommend = [[NSMutableArray alloc] init];
    _arrayTop = [[NSMutableArray alloc] init];
    _arrayImage = [[NSMutableArray alloc] init];
    _arrayFour = [[NSMutableArray alloc] init];
    _arrayBrand = [[NSMutableArray alloc] init];
    pagination = [[Pagination alloc] init];
    pagination.page = 1;
    
    [indexService getXMLString];
    
    [indexService getInfoWithBlock:^(BaseModel *responseObj) {
        indexResponse = (IndexResponse *)responseObj;
        
        if (indexResponse.appparasetting.count) {
            
            [[Config Instance] saveUserInfo:onlineUrl withvalue:indexResponse.appparasetting[@"url"]];
            [[Config Instance] saveUserInfo:phoneNum withvalue:indexResponse.appparasetting[@"phone"]];
        }
        
        if (indexResponse.topAdvs.count >0) {
            [_arrayImage removeAllObjects];
            for (int i=0; i<indexResponse.topAdvs.count; i++) {
                AppIndexUrl * adv = [[AppIndexUrl alloc] init];
                adv = indexResponse.topAdvs[i];
                [_arrayImage addObject:adv];
            }
            [self configureScrollView];
        }
        if (indexResponse.iOSShortcutLinks.count > 0) {
            [_arrayFour removeAllObjects];
            for (int i=0; i<indexResponse.iOSShortcutLinks.count; i++) {
                AppIndexUrl * top = [[AppIndexUrl alloc] init];
                top = indexResponse.iOSShortcutLinks[i];
                [_arrayFour addObject:top];
            }
            [self configInfoOfFourMenu];
        }
        
        if (indexResponse.recommands.count >0) {
            [_arrayRecommend removeAllObjects];
            for (int i=0; i<indexResponse.recommands.count; i++) {
                AppIndexUrl * top = [[AppIndexUrl alloc] init];
                top = indexResponse.recommands[i];
                [_arrayRecommend addObject:top];
            }
            [[TextDataBase shareTextDataBase] saveAppIndexUrlNSMutableArray:_arrayRecommend];
            
            [self configInfoOfrecommands];
        }
        if (indexResponse.hotActivities.count > 0) {
            [_arrayHot removeAllObjects];
            for (int i=0; i<indexResponse.hotActivities.count; i++) {
                AppIndexUrl * top = [[AppIndexUrl alloc] init];
                top = indexResponse.hotActivities[i];
                [_arrayHot addObject:top];
            }
            // 热门活动logo
            //            hotActivityLogo = indexResponse.hotActivityLogo;
            [self configInfoOfHot];
        }
        if (indexResponse.greatBrands.count > 0) {
            [_arrayBrand removeAllObjects];
            for (int i=0; i<indexResponse.greatBrands.count; i++) {
                AppIndexUrl * top = [[AppIndexUrl alloc] init];
                top = indexResponse.greatBrands[i];
                [_arrayBrand addObject:top];
            }
            [self configInfoOfTodayBrand];
        }
        if (indexResponse.productCategories.count>0) {
            [_arrayTop removeAllObjects];
            [_arrayTop addObjectsFromArray:indexResponse.productCategories];
            [self configInfoOfTopMenu];
        }
        //        NSLog(@"\n - %@ - \n", [[Config Instance] getUserInfo:phoneNum]);
        NSString *num = [[Config Instance] getUserInfo:phoneNum];
        [self.hottelephoneBtn setTitle:num forState:(UIControlStateNormal)];
        [self doneLoadingTableViewData];
        

    }];
    
    [self getSearchRequest];
    
    [self setTextValue];
}

//返回请求数据
- (void)loadResponse:(NSString *) url response:(BaseModel *)response{
    if ([url isEqual:api_cart_list]){
        CartResponse *respobj = (CartResponse*)response;
        if (respobj.status.succeed == 1){
            [AppStatic setCART_ITEM_QUANTITIES:[respobj.data getQuantities]];
            if ([AppStatic CART_ITEM_QUANTITIES]) {
                
                if([AppStatic CART_ITEM_QUANTITIES] < 1000){
                    [AppStatic CART_ITEM_BAR_ITEM].badgeValue = [[NSString alloc] initWithFormat:@"%d", [AppStatic CART_ITEM_QUANTITIES] ];
                }else{
                    [AppStatic CART_ITEM_BAR_ITEM].badgeValue = @"…";
                }
            } else {
                [AppStatic CART_ITEM_BAR_ITEM].badgeValue = nil;
            }
        }
    }
}

#pragma mark - 获取XML文本
- (void)loadResponse:(NSString *)url data:(NSData *)data {
    
    if ([url isEqualToString:api_xmlString]) {
        
        [self getXMLText:data];
        [self setTextValue];
    }
}

- (void)getLocalXmlStr {
    
    if (![[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"appDelegate_tabBarItem1_title"].length) {
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"path_textStr" ofType:@"xml"];
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        [self getXMLText:data];
        [self setTextValue];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appUpdate.downloadUrl]];
        if ([appUpdate.upgradePolicy isEqualToString:@"force"]){
            exit(0);
        }
    }
}
#pragma mark - 页面配置及赋值

#pragma 顶部轮播图荐部分
- (void)configureScrollView {
    
    [_imageScroll.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    kNumberOfPages = _arrayImage.count;
    NSMutableArray* controllers = [[NSMutableArray alloc] init];
    
    for (int i = 0 ; i < kNumberOfPages; i++) {
        [controllers addObject:[NSNull null]];
    }
    self.viewControllers = controllers;
    self.imageScroll.pagingEnabled = YES;
    self.imageScroll.contentOffset = CGPointMake(self.pagecontroll.currentPage * TMScreenW, 0);
    self.imageScroll.contentSize = CGSizeMake(self.imageScroll.frame.size.width*kNumberOfPages,self.imageScroll.frame.size.height);
    self.imageScroll.showsHorizontalScrollIndicator = NO;
    self.imageScroll.showsVerticalScrollIndicator = NO;
    self.imageScroll.scrollsToTop = NO;
    self.imageScroll.delegate = self;
    
    self.pagecontroll.numberOfPages = kNumberOfPages;
    //    self.pagecontroll.currentPage = 0;
    [self.pagecontroll addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    
    [self loadScrollViewWithPage:self.pagecontroll.currentPage];
}

#pragma Fore菜单部分
- (void)configInfoOfFourMenu {
    
    if (_arrayFour.count == 4) {
        
        _labMenu1.text = [_arrayFour[0] valueForKey:@"title"];
        _labMenu2.text = [_arrayFour[1] valueForKey:@"title"];
        _labMenu3.text = [_arrayFour[2] valueForKey:@"title"];
        _labMenu4.text = [_arrayFour[3] valueForKey:@"title"];
        _imgMenu1.imageURL = [URLUtils createURL:[_arrayFour[0] valueForKey:@"newimage"]];
        _imgMenu2.imageURL = [URLUtils createURL:[_arrayFour[1] valueForKey:@"newimage"]];
        _imgMenu3.imageURL = [URLUtils createURL:[_arrayFour[2] valueForKey:@"newimage"]];
        _imgMenu4.imageURL = [URLUtils createURL:[_arrayFour[3] valueForKey:@"newimage"]];
    }
}

#pragma 配置猫工推荐部分
//创建每个item
- (void)configInfoOfrecommands {
    
    [_scrollFoot.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat itemWidth = TMScreenW *210/750;
    CGFloat itemHeight = TMScreenH *254/1334;
    for (int i =0; i<_arrayRecommend.count-1; i++) {
        
        RecommendView *item = [[[NSBundle mainBundle] loadNibNamed:@"RecommendView" owner:self options:nil] lastObject];
        item.frame = CGRectMake(i*itemWidth, 0, itemWidth, itemHeight);
        item.titleLabel.text = [_arrayRecommend[i] valueForKey:@"conesc"];
        item.contentLabel.text = [_arrayRecommend[i] valueForKey:@"coness"];
        //        NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[_arrayRecommend[i] valueForKey:@"newimage"]]];
        //        item.imageView.image = [UIImage imageWithData:imgData];
        item.imageView.placeholderImage = [UIImage imageNamed:@"recommendDefaultImg"];
        item.imageView.imageURL = [URLUtils createURL:[_arrayRecommend[i] valueForKey:@"newimage"]];
        
        [_scrollFoot addSubview:item];
        
        item.recommendBtn.tag = 1000+i;
        [item.recommendBtn addTarget:self action:@selector(clickToolMallRecommendView:) forControlEvents:UIControlEventTouchUpInside];
    }
    _scrollFoot.contentSize = CGSizeMake((_arrayRecommend.count-1)*itemWidth, 0);
}

#pragma 配置热门活动部分
- (void)configInfoOfHot{
    
    [_imageListView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self configOfHot1];
    [self configOfHot2];
    [self configOfHot3];
}

- (void)configOfHot1 {
    
    if (_arrayHot.count) {
        
        HotActiveView1 *hotac1 = [[[NSBundle mainBundle] loadNibNamed:@"HotActiveView1" owner:self options:nil] lastObject];
        hotac1.frame = CGRectMake(0, 0, (TMScreenW)/2.0 - 0.5, TMScreenW / 2.0 - 0.5);
        hotac1.backgroundColor = [UIColor whiteColor];
        
        hotac1.imageView.placeholderImage = [UIImage imageNamed:@"index_defImage"];
        hotac1.imageView.imageURL = [URLUtils createURL:[_arrayHot[0] valueForKey:@"newimage"]];
        
        hotac1.priceLabel.hidden = YES;
        hotac1.contentLabel.hidden = YES;
        
        hotac1.starImgView.hidden = YES;
        [hotac1.hotacBtn1 addTarget:self action:@selector(clickHotActivityAction:) forControlEvents:(UIControlEventTouchUpInside)];
        hotac1.hotacBtn1.tag = 2000;
        self.cdView = [[[NSBundle mainBundle] loadNibNamed:@"CountdownView" owner:self options:nil] lastObject];
        self.cdView.detailLabel.text = [_arrayHot[0] valueForKey:@"conesc"];
        self.cdView.detailLabel.textColor = redColorSelf;
        _cdView.frame = CGRectMake(10, 8, CGRectGetWidth(hotac1.frame)-20, 20);
        
        [hotac1 addSubview:_cdView];
        
        [_imageListView addSubview:hotac1];
    }
}
- (void)configOfHot2 {
    
    if (_arrayHot.count>2) {
        
        for (int i=1; i<3; i++) {
            
            HotActiveView2 *hotac2 = [[[NSBundle mainBundle] loadNibNamed:@"HotActiveView2" owner:self options:nil] lastObject];
            
            hotac2.titleLabel.text = [_arrayHot[i] valueForKey:@"conesc"];
            hotac2.contentLabel.text = [_arrayHot[i] valueForKey:@"coness"];
            hotac2.imageView.placeholderImage = [UIImage imageNamed:@"hotDefaultImg3"];
            hotac2.imageView.imageURL = [URLUtils createURL:[_arrayHot[i] valueForKey:@"newimage"]];
            
            hotac2.hotacBtn2.tag = 2000+i;
            [hotac2.hotacBtn2 addTarget:self action:@selector(clickHotActivityAction:) forControlEvents:(UIControlEventTouchUpInside)];
            
            if (i==1) {
                
                hotac2.frame =CGRectMake((TMScreenW)/2.0, 0, (TMScreenW)/2.0 - 0.5, TMScreenW/4.0 - 0.5);
                hotac2.titleLabel.textColor = redColorSelf;
            } else {
                hotac2.frame =CGRectMake((TMScreenW)/2.0, TMScreenW/4.0, (TMScreenW)/2.0 - 0.5, TMScreenW/4.0 - 0.5);
                //            hotac2.titleLabel.textColor = [UIColor blueColor];
                hotac2.titleLabel.textColor = [UIColor colorWithRed:95.0/255.0 green:138.0/255.0 blue:255.0/255.0 alpha:1.0];
                hotac2.goImage.hidden = YES;
            }
            hotac2.contentLabel.textColor = lightGrayColorSelf;
            [_imageListView addSubview:hotac2];
        }
    }
}
- (void)configOfHot3 {
    
    if (_arrayHot.count>5) {
        
        for (int i=3; i<6; i++) {
            
            HotActiveView3 *hotac3 = [[[NSBundle mainBundle] loadNibNamed:@"HotActiveView3" owner:self options:nil] lastObject];
            
            hotac3.titleLabel.text = [_arrayHot[i] valueForKey:@"conesc"];
            hotac3.contentLabel.text = [_arrayHot[i] valueForKey:@"coness"];
            hotac3.imageView.placeholderImage = [UIImage imageNamed:@"hotDefaultImg3"];
            hotac3.imageView.imageURL = [URLUtils createURL:[_arrayHot[i] valueForKey:@"newimage"]];
            hotac3.hotacBtn3.tag = 2000+i;
            [hotac3.hotacBtn3 addTarget:self action:@selector(clickHotActivityAction:) forControlEvents:(UIControlEventTouchUpInside)];
            
            if (i==3) {
                
                hotac3.frame =CGRectMake(0, (TMScreenW)/2.0, (TMScreenW)/3.0 - 0.5, (TMScreenW)/3.0*1.2 - 0.5);
                hotac3.titleLabel.textColor = [UIColor colorWithRed:54.0/255.0 green:189.0/255.0 blue:78.0/255.0 alpha:0.8];
            }
            else if (i==4) {
                
                //            hotac3.titleLabel.textColor = [UIColor orangeColor];
                hotac3.titleLabel.textColor = [UIColor colorWithRed:255.0/255.0 green:121.0/255.0 blue:59.0/255.0 alpha:0.8];
                hotac3.frame =CGRectMake((TMScreenW)/3.0, (TMScreenW)/2.0, (TMScreenW)/3.0 - 0.5, (TMScreenW)/3.0*1.2 - 0.5);
            }
            else {
                
                //            hotac3.titleLabel.textColor = [UIColor magentaColor];
                hotac3.titleLabel.textColor = [UIColor colorWithRed:183.0/255.0 green:120.0/255.0 blue:253.0/255.0 alpha:0.8];
                hotac3.frame =CGRectMake((TMScreenW)/3.0*2, (TMScreenW)/2.0, (TMScreenW)/3.0 - 0.5, (TMScreenW)/3.0*1.2 - 0.5);
            }
            hotac3.contentLabel.textColor = lightGrayColorSelf;
            [_imageListView addSubview:hotac3];
        }
    }
}

#pragma 配置今日大牌部分
- (void)configInfoOfTodayBrand{
    
    [_todayListView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    CGFloat itemW = TMScreenW/2.0;
    CGFloat itemHFloat = TMScreenW/4.0;
    int itemH = floor(itemHFloat);
    
    for (int i = 0; i < _arrayBrand.count; i ++) {
        
        TodayBrandView *tbView = [[[NSBundle mainBundle] loadNibNamed:@"TodayBrandView" owner:self options:nil] lastObject];
        tbView.todayBrandBtn.tag = 3000 + i;
        [tbView.todayBrandBtn addTarget:self action:@selector(clickTodayBrand:) forControlEvents:(UIControlEventTouchUpInside)];
        
        if (i<2) {
            
            tbView.frame = CGRectMake(i*itemW, 0, itemW, itemH);
        } else {
            tbView.frame = CGRectMake((i-2)*itemW, itemH, itemW, itemH);
        }
        NSArray *smallImgArr = @[@"推荐", @"活动"];
        
        //        NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[_arrayBrand[i] valueForKey:@"newimage"]]];
        //        tbView.bigImageView.image = [UIImage imageWithData:imgData];
        
        tbView.bigImageView.placeholderImage = [UIImage imageNamed:@"defaultImg_small"];
        tbView.bigImageView.imageURL = [URLUtils createURL:[_arrayBrand[i] valueForKey:@"newimage"]];
        
        AppIndexUrl * top = [[AppIndexUrl alloc] init];
        top = _arrayBrand[i];
        _statues = top.tips;
        if (_statues == 1) {
            
            tbView.smallImageView.image = [UIImage imageNamed:smallImgArr[1]];
        }
        else if (_statues == 0) {
            tbView.smallImageView.image = [UIImage imageNamed:smallImgArr[0]];
        }
        else {
            tbView.smallImageView.hidden = YES;
        }
        [self.todayListView addSubview:tbView];
    }
}

#pragma 重新配置全部分类信息
- (void)configInfoOfTopMenu{
    
    [_allClassifyListView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //    CGFloat itemW = TMScreenW/3.0;
    //    CGFloat itemH = TMScreenW/3.0*1.2;
    
    for (int i=0; i<_arrayTop.count; i++) {
        
        AllClassifyView *acView = [[[NSBundle mainBundle] loadNibNamed:@"AllClassifyView" owner:self options:nil] lastObject];
        
        if (i<3) {
            
            acView.frame = CGRectMake((TMScreenW)/3.0*i, 0, (TMScreenW)/3.0, (TMScreenW)/3.0*1.2);
        }else if (i>=3 && i<6){
            acView.frame = CGRectMake((TMScreenW)/3.0*(i-3), (TMScreenW)/3.0*1.2, (TMScreenW)/3.0, (TMScreenW)/3.0*1.2);
        }else if (i>=6 && i<9){
            acView.frame = CGRectMake((TMScreenW)/3.0*(i-6), (TMScreenW)/3.0*1.2*2, (TMScreenW)/3.0, (TMScreenW)/3.0*1.2);
        }
        else {
            acView.frame = CGRectMake((TMScreenW)/3.0*(i-9), (TMScreenW)/3.0*1.2*3, (TMScreenW)/3.0, (TMScreenW)/3.0*1.2);
        }
        
        acView.titleLabel.text = [_arrayTop[i] valueForKey:@"title"];
        //        NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[_arrayTop[i] valueForKey:@"newimage"]]];
        //        acView.imageView.image = [UIImage imageWithData:imgData];
        
        acView.imageView.placeholderImage = [UIImage imageNamed:@"index_defImage"];
        acView.imageView.imageURL = [URLUtils createURL:[_arrayTop[i] valueForKey:@"newimage"]];
        
        acView.allClassifyBtn.tag = 4000 + i;
        [_allClassifyListView addSubview:acView];
        //全部分类按钮事件
        [acView.allClassifyBtn addTarget:self action:@selector(clickTopMenu:) forControlEvents:UIControlEventTouchUpInside];
    }
    //    UIView *whiteView = [[UIView alloc] initWithFrame:(CGRectMake(itemW, itemH*3, itemW*2, itemH))];
    //    whiteView.backgroundColor = [UIColor whiteColor];
    //    [_allClassifyListView addSubview:whiteView];
    
}

#pragma mark - 点击事件

#pragma 点击轮播图图片跳转
- (void)clickImageToPage:(UIButton *)sender {
    
    //    NSLog(@"点击了广告图片");
    int i = self.pagecontroll.currentPage;
    //    NSString * urlType = [_arrayImage[i] valueForKey:@"urlType"];
    if (!(_arrayImage.count<i)) {
        
        [self pushToAPageWithURLType:_arrayImage[i]];
    }
}

#pragma 点击快速进货跳转
- (IBAction)clickFaststockBtnAction:(id)sender {
    
    //    NSLog(@"快速进货");
}

#pragma 四个菜单按钮的点击事件
- (IBAction)clickToProductListPage:(UIButton *)sender {
    
    int i = sender.tag-5000;
    if (_arrayFour.count) {
        
        [self pushToAPageWithURLType:_arrayFour[i]];
    }
}

#pragma 猫工推荐跳转事件

- (IBAction)clickToolMallRecommendDetailView:(id)sender {
    
    //    NSLog(@"猫工推荐更多");
    if (_arrayRecommend.count) {
        
        TollMallRDViewController *tollMallRDVC = [[TollMallRDViewController alloc] init];
        //        tollMallRDVC.dataArr = _arrayRecommend;
        tollMallRDVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:tollMallRDVC animated:YES];
    }
}

- (void)clickToolMallRecommendView:(UIButton *)sender{
    
    int i = sender.tag-1000;
    if (_arrayRecommend.count) {
        
        [self pushToAPageWithURLType:_arrayRecommend[i]];
    }
}

#pragma 广告栏——1跳转事件
- (void)clickadv1TapAction:(UITapGestureRecognizer *)tap {
    //    NSLog(@"广告栏——1");
    RegisteViewController * vc = [[RegisteViewController alloc]initWithNibName:@"RegisteViewController" bundle:nil];
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma 热门活动跳转事件
//- (void)clickHotActivityActionItem1:(UIButton *)sender {
//
//    [self pushToAPageWithURLType:_arrayHot[0]];
//}

- (void)clickHotActivityAction:(UIButton *)sender{
    
    int i = sender.tag-2000;
    
    if (_arrayHot.count > i) {
        
        [self pushToAPageWithURLType:_arrayHot[i]];
    }
}
#pragma 广告栏——2跳转事件
- (void)clickadv2TapAction:(UITapGestureRecognizer *)tap {
    
    //    NSLog(@"广告栏——2");
}

#pragma 今日大牌按钮跳转事件

- (IBAction)clickTBMoreBtnAction:(id)sender {
    //    NSLog(@"今日大牌-更多");
    MoreBrands * brands = [[MoreBrands alloc] initWithNibName:@"MoreBrands" bundle:nil];
    brands.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:brands animated:YES];
}

- (void)clickTodayBrand:(UIButton *)button{
    //    NSLog(@"今日大牌 - %ld", (long)button.tag);
    int i = button.tag-3000;
    //    NSString * urlType = [indexResponse.greatBrands[i] valueForKey:@"urlType"];
    [self pushToAPageWithURLType:indexResponse.greatBrands[i]];
}

#pragma 全部分类按钮跳转事件
- (IBAction)clickACDetailBtnAction:(id)sender {
    
    CatRootListViewController *catRootListController = [[CatRootListViewController alloc] initWithNibName:@"CatRootListViewController" bundle:nil];
    catRootListController.type = @"index";
    catRootListController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:catRootListController animated:YES];
    //    NSLog(@"全部分类-详情");
}

- (void)clickTopMenu:(UIButton *)button{
    //    NSLog(@"全部分类 - %ld", (long)button.tag);
    int i = button.tag-4000;
    //    NSString * urlType = [indexResponse.productCategories[i] valueForKey:@"urlType"];
    [self pushToAPageWithURLType:indexResponse.productCategories[i]];
    
}

#pragma mark - 在线客服点击事件
- (IBAction)onlineServiceBtnAction:(id)sender {
    
    MyWebView *myWebView = [[MyWebView alloc] init];
    
    // @"联系客服"
    NSString *index_webView_navTitle = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"index_webView_navTitle"];
    myWebView.navTitle = index_webView_navTitle;
    //    NSString *url = @"https://chat8.live800.com/live800/chatClient/chatbox.jsp?companyID=152592&configID=149993&jid=1091048728&ss=1";
    myWebView.loadUrl = [[Config Instance] getUserInfo:onlineUrl];
    myWebView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:myWebView animated:YES];
}

#pragma - 热线电话点击事件
- (IBAction)hotTelephoneBtnAction:(id)sender {
    
    NSString *phone = [[Config Instance] getUserInfo:phoneNum];
    NSString *phoneStr = [phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString *str = [NSString stringWithFormat:@"tel:%@", phoneStr];
    
    //    NSLog(@"%@", str);
    
    UIWebView *callWebView = [[UIWebView alloc] init];
    [callWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    
    [self.view addSubview:callWebView];
}

#pragma mark == 分界线 ==

#pragma 通过URLType跳转到下页
- (void)pushToAPageWithURLType:(AppIndexUrl *)appIndexUrl{
    
    if ([appIndexUrl.urlType isEqualToString:@"product"]) {
        //        跳转到商品详情页
        ProductInfoViewController * p = [[ProductInfoViewController alloc] initWithNibName:@"ProductInfoViewController" bundle:nil];
        p.productId = appIndexUrl.refId;
        p.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:p  animated:YES];
        
    }else if ([appIndexUrl.urlType isEqualToString:@"productCategory_prod_list"]){
        //        跳转到商品类目页
        ProdList * p = [[ProdList alloc] initWithNibName:@"ProdList" bundle:nil];
        p.productCategoryId =appIndexUrl.refId;
        p.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:p  animated:YES];
        
    }else if ([appIndexUrl.urlType isEqualToString:@"activity_prod_list"]){
        //        跳转到活动商品展示页
        ActivityViewController * p = [[ActivityViewController alloc] initWithNibName:@"ActivityViewController" bundle:nil];
        p.navTitle = appIndexUrl.title;
        p.activityId = appIndexUrl.refId;;
        p.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:p  animated:YES];
        
    }else if ([appIndexUrl.urlType isEqualToString:@"promotion_prod_list"]){
        //        跳转到促销商品展示页
        ProdList * p = [[ProdList alloc] initWithNibName:@"ProdList" bundle:nil];
        p.promotionId =appIndexUrl.refId;
        [self.navigationController pushViewController:p  animated:YES];
        
    }else if ([appIndexUrl.urlType isEqualToString:@"register"]){
        //       跳转到注册页面
        RegisteViewController * p = [[RegisteViewController alloc] initWithNibName:@"RegisteViewController" bundle:nil];
        p.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:p animated:YES];
        
    }else if ([appIndexUrl.urlType isEqualToString:@"myfavorite"]){
        //  跳转到收藏页面，如果没登录，跳转到登录页面
        if (![CommonUtils chkLogin:self gotoLoginScreen:YES]){
            return;
        }
        
        FavoriteListController *favoriteList = [[FavoriteListController alloc] initWithNibName:@"FavoriteListController" bundle:nil];
        [self.navigationController pushViewController:favoriteList animated:YES];
        
    }else if ([appIndexUrl.urlType isEqualToString:@"brandlist"]){
        //        跳转到品牌类别页
        MoreBrands * brands = [[MoreBrands alloc] initWithNibName:@"MoreBrands" bundle:nil];
        brands.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:brands animated:YES];
        
    }else if ([appIndexUrl.urlType isEqualToString:@"brand_prod_list"]) {
        //        跳转到品牌商品列表页
        ProdList *prodList = [[ProdList alloc] initWithNibName:@"ProdList" bundle:nil];
        prodList.brandId = appIndexUrl.refId;
        [self.navigationController pushViewController:prodList animated:YES];
    }
    else if ([appIndexUrl.urlType isEqualToString:@"webView"]) {
        
        MyWebView *myWebView = [[MyWebView alloc] init];
        myWebView.navTitle = appIndexUrl.title;
        myWebView.loadUrl = appIndexUrl.url;
        myWebView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:myWebView animated:YES];
    }
    else if ([appIndexUrl.urlType isEqualToString:@"JSWebView"]) {
        
        JSWebView *jsWebView = [[JSWebView alloc] init];
        jsWebView.navTitle = appIndexUrl.title;
        //        NSString *urlstr = @"https://www.toolmall.com/app/index/secondActivity.jhtm?actid1=2&actid2=21&client=iOSAPP&type=jsview";
        //        jsWebView.loadUrl = urlstr;
        jsWebView.loadUrl = appIndexUrl.url;
        jsWebView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:jsWebView animated:YES];
    }
}

//图片轮播换页
-(void)changePage:(id)sender{
    NSInteger page = self.pagecontroll.currentPage;
    
    [self loadScrollViewWithPage:page-1];
    [self loadScrollViewWithPage:page];
    
    CGRect frame = self.imageScroll.frame;
    frame.origin.x = frame.size.width*page;
    frame.origin.y = 0;
    [self.imageScroll scrollRectToVisible:frame animated:YES];
    
    pageControlUsed = YES;
}


-(void)loadScrollViewWithPage:(NSInteger)page{
    
    if (page < 0) {
        return;
    }else if(page >= kNumberOfPages) {
        //do some thing,like jump to other screen
        return;
    }
    
    IndexImage * controller = [self.viewControllers objectAtIndex:page];
    //    controller.view.frame = CGRectMake(controller.view.frame.origin.x, controller.view.frame.origin.y, _imageScroll.frame.size.width, _imageScroll.frame.size.height);
    if ((NSNull*)controller == [NSNull null]) {
        controller = [[IndexImage alloc] init];
        //        controller.msgHandler = self;
        [self.viewControllers replaceObjectAtIndex:page withObject:controller];
    }
    
    if (controller.view.superview == nil) {
        CGRect frame = self.imageScroll.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        [self.imageScroll addSubview:controller.view];
        //        controller.image.contentMode = UIViewContentModeScaleAspectFill;
        
        AppIndexUrl *url =(AppIndexUrl*)_arrayImage[page];
        
        controller.image.placeholderImage = [UIImage imageNamed:@"defaultImg_big"];
        controller.image.imageURL = [URLUtils createURL:url.newimage];
        
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == self.imageScroll) {
        if (pageControlUsed) {
            return;
        }
        CGFloat pageWidth = _imageScroll.frame.size.width;
        //page表示当前滚动哪一页的标识
        int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth)+1;
        
        self.pagecontroll.currentPage = page;
        [self loadScrollViewWithPage:page-1];
        [self loadScrollViewWithPage:page];
        [self loadScrollViewWithPage:page+1];
    }
    offset = self.backScrollView.contentOffset.y;
    
    CGRect bounds = scrollView.bounds;
    UIEdgeInsets inset = scrollView.contentInset;
    CGFloat offset1 = tHeight - bounds.size.height + inset.bottom;
    //    NSLog(@"offset - %f : offset1 - %f", offset, offset1);
    
    if (offset > offset1 + TMScreenH *60/568) {
        self.backScrollView.contentSize = CGSizeMake(0, tHeight+TMScreenH *110/568);
    }
    if (offset < offset1 - TMScreenH *20/568){
        self.backScrollView.contentSize = CGSizeMake(0, tHeight);
    }
    
    if (scrollView == self.backScrollView) {
        [refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (scrollView == self.backScrollView) {
        [refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}

-(void) scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.imageScroll) {
        pageControlUsed = NO;
    }
}

-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.imageScroll) {
        pageControlUsed = NO;
    }
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
    //    self.navigationItem.hidesBackButton = YES;
    self.backScrollView.frame = CGRectMake(0, 0, TMScreenW, TMScreenH-64-49);
    if ([self.type isEqualToString:@"webView"]) {
        
        self.tabBarController.tabBar.hidden = YES;
        [super addNavBackButton];
        self.backScrollView.frame = CGRectMake(0, 0, TMScreenW, TMScreenH-64);
    }
}

- (void)configureCutLine {
    
    
    self.navigationController.navigationBar.translucent = NO;
    // 隐藏导航栏底部的分割线
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bgLight"]
                                                 forBarPosition:UIBarPositionAny
                                                     barMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"05线"]];
    
    [self.tabBarController.tabBar setShadowImage:[[UIImage alloc]init]];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:(CGRectMake(0, 0, kWidth, 1))];
    imgView.image = [UIImage imageNamed:@"05线"];
    [self.tabBarController.tabBar addSubview:imgView];
    [self.tabBarController.tabBar setBackgroundImage:[[UIImage alloc]init]];
}

#pragma UI
- (void)createUI{
    //    滚动图片位置
    self.imageScroll.frame = CGRectMake(0, 0, TMScreenW, TMScreenH *150/667);
    self.imageScroll.userInteractionEnabled = YES;
    //    [self.view addGestureRecognizer: _imageScroll.panGestureRecognizer];
    
    UITapGestureRecognizer *tapClickImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImageToPage:)];
    [self.imageScroll addGestureRecognizer:tapClickImage];
    [self.backScrollView addSubview:self.imageScroll];
    
    self.pagecontroll = [[UIPageControl alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imageScroll.frame)/2-TMScreenW *50/320, CGRectGetMaxY(_imageScroll.frame)-TMScreenH *20/568, TMScreenW *100/320, TMScreenH *20/568)];
    self.pagecontroll.currentPageIndicatorTintColor = redColorSelf;
    self.pagecontroll.pageIndicatorTintColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.6];
    [self.backScrollView addSubview:self.pagecontroll];
    
    
    //    self.btnClickImage = [UIButton buttonWithType:UIButtonTypeCustom];
    //    self.btnClickImage.backgroundColor = [UIColor clearColor];
    //    self.btnClickImage.frame = CGRectMake(0, 0, _imageScroll.frame.size.width, _imageScroll.frame.size.height);
    //    [self.btnClickImage addTarget:self action:@selector(clickImageToPage:) forControlEvents:UIControlEventTouchUpInside];
    //    [self.backScrollView addSubview:self.btnClickImage];
    
    // 快速进货
    _faststockView.frame = CGRectMake(0, CGRectGetMaxY(_imageScroll.frame), TMScreenW, TMScreenH *90/1334);
    //    [self.backScrollView addSubview:_faststockView];
    
    //    四个按钮的位置(不会变化)
    CGFloat viewWidth = TMScreenW/4;
    CGFloat viewHeight = TMScreenH *160/1334;
    CGFloat imgPointX = TMScreenW/8 - TMScreenW *40/750;
    CGFloat imgWidth = TMScreenW *80/750;
    CGFloat imgHeight = TMScreenW *80/750;
    _menu.frame = CGRectMake(0, CGRectGetMaxY(_imageScroll.frame), TMScreenW, viewHeight);
    _view1.frame = CGRectMake(0, 0, viewWidth, viewHeight);
    _imgMenu1.frame = CGRectMake(imgPointX, TMScreenH *10/568, imgWidth, imgHeight);
    _view2.frame = CGRectMake(viewWidth, 0, viewWidth, viewHeight);
    _imgMenu2.frame = CGRectMake(imgPointX, TMScreenH *10/568, imgWidth, imgHeight);
    
    _view3.frame = CGRectMake(viewWidth*2, 0, viewWidth, viewHeight);
    _imgMenu3.frame = CGRectMake(imgPointX, TMScreenH *10/568, imgWidth, imgHeight);
    
    _view4.frame = CGRectMake(viewWidth*3, 0, viewWidth, viewHeight);
    _imgMenu4.frame = CGRectMake(imgPointX, TMScreenH *10/568, imgWidth, imgHeight);
    [self.backScrollView addSubview:_menu];
    
    CGFloat imgW = TMScreenH *46/1334;
    CGFloat imgH = TMScreenH *46/1334;
    CGFloat imgSize = TMScreenW *16/320;
    //    土猫推荐UI 计算
    self.toolmallRecommendView.frame = CGRectMake(0, CGRectGetMaxY(self.menu.frame)+TMScreenH *20/1334, TMScreenW, TMScreenH *90/1334);
    self.tmRimg1.frame = CGRectMake(TMScreenW *10/320, (TMScreenH *90/1334 - imgH)/2, imgW, imgH);
    
    self.tmRtitleLabel.frame = CGRectMake(CGRectGetMaxX(_tmRimg1.frame)+TMScreenW *5/320, 0, TMScreenW *150/320, TMScreenH *90/1334);
    self.tmRimg2.frame = CGRectMake(TMScreenW-imgSize-TMScreenW *10/320, (TMScreenH *90/1334 - imgSize)/2, imgSize, imgSize);
    self.tmRmoreLabel.frame = CGRectMake(CGRectGetMinX(_tmRimg2.frame)-TMScreenW *100/320, 0, TMScreenW *100/320, TMScreenH *90/1334);
    [self.backScrollView addSubview:_toolmallRecommendView];
    
    _scrollFoot = [[UIScrollView alloc] init];
    _scrollFoot.frame = CGRectMake(0, CGRectGetMaxY(_toolmallRecommendView.frame)+0.5, TMScreenW, TMScreenH * 254/1334);
    _scrollFoot.bounces = NO;
    _scrollFoot.showsHorizontalScrollIndicator = NO;
    _scrollFoot.showsVerticalScrollIndicator = NO;
    [self.backScrollView addSubview:_scrollFoot];
    
    self.advImage1 = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"banner1"]];
    _advImage1.frame = CGRectMake(0, CGRectGetMaxY(_scrollFoot.frame), TMScreenW, TMScreenH *120/1334);
    _advImage1.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickadv1TapAction:)];
    [_advImage1 addGestureRecognizer:tap];
    [self.backScrollView addSubview:_advImage1];
    
    // 重新给热门活动frame
    self.hotActivityView.frame = CGRectMake(0, CGRectGetMaxY(_advImage1.frame)+TMScreenH *20/1334, TMScreenW, TMScreenH *90/1334);
    self.tmHimg1.frame = CGRectMake(TMScreenW *10/320, (TMScreenH *90/1334 - imgH)/2, imgW, imgH);
    
    self.tmHtitleLabel.frame = CGRectMake(CGRectGetMaxX(_tmRimg1.frame)+TMScreenW *5/320, 0, TMScreenW *150/320, TMScreenH *90/1334);
    self.tmHimg2.frame = CGRectMake(TMScreenW-imgSize-TMScreenW *10/320, (TMScreenH *90/1334 - imgSize)/2, imgSize, imgSize);
    self.tmHmoreLabel.frame = CGRectMake(CGRectGetMinX(_tmRimg2.frame)-TMScreenW *100/320, 0, TMScreenW *100/320, TMScreenH *90/1334);
    [self.backScrollView addSubview:_hotActivityView];
    
    _imageListView = [[UIView alloc] init];
    _imageListView.frame =CGRectMake(0, CGRectGetMaxY(self.hotActivityView.frame)+0.5, TMScreenW, TMScreenH *675/1334);
    //    _imageListView.backgroundColor = [UIColor lightGrayColor];
    [self.backScrollView addSubview:_imageListView];
    
    
    self.advImage2 = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"banner2"]];
    _advImage2.frame = CGRectMake(0, CGRectGetMaxY(_imageListView.frame), TMScreenW, TMScreenH *120/1334);
    _advImage2.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickadv2TapAction:)];
    [_advImage2 addGestureRecognizer:tap2];
    //    [self.backScrollView addSubview:_advImage2];
    
    //    今日大牌UI 计算
    self.todaybrandView.frame = CGRectMake(0, CGRectGetMaxY(_imageListView.frame)+TMScreenH *20/1334, TMScreenW, TMScreenH *90/1334);
    self.tmTimg1.frame = CGRectMake(TMScreenW *10/320, (TMScreenH *90/1334 - imgH)/2, imgW, imgH);
    self.tmTtitleLabel.frame = CGRectMake(CGRectGetMaxX(_tmRimg1.frame)+TMScreenW *5/320, 0, TMScreenW *150/320, TMScreenH *90/1334);
    self.tmTimg2.frame = CGRectMake(TMScreenW-imgSize-TMScreenW *10/320, (TMScreenH *90/1334 - imgSize)/2, imgSize, imgSize);
    self.tmTmoreLabel.frame = CGRectMake(CGRectGetMinX(_tmRimg2.frame)-TMScreenW *100/320, 0, TMScreenW *100/320, TMScreenH *90/1334);
    [self.backScrollView addSubview:_todaybrandView];
    
    self.todayListView = [[UIView alloc] init];
    _todayListView.frame =CGRectMake(0, CGRectGetMaxY(self.todaybrandView.frame)+0.5, TMScreenW, TMScreenW/2);
    //    _todayListView.backgroundColor = [UIColor lightGrayColor];
    [self.backScrollView addSubview:_todayListView];
    
    //    全部分类UI 计算
    self.allclassifyView.frame = CGRectMake(0, CGRectGetMaxY(self.todayListView.frame)+TMScreenH *20/1334, TMScreenW, TMScreenH *90/1334);
    self.tmAimg1.frame = CGRectMake(TMScreenW *10/320, (TMScreenH *90/1334 - imgH)/2, imgW, imgH);
    self.tmAtitleLabel.frame = CGRectMake(CGRectGetMaxX(_tmRimg1.frame)+TMScreenW *5/320, 0, TMScreenW *150/320, TMScreenH *90/1334);
    self.tmAimg2.frame = CGRectMake(TMScreenW-imgSize-TMScreenW *10/320, (TMScreenH *90/1334 - imgSize)/2, imgSize, imgSize);
    self.tmAmoreLabel.frame = CGRectMake(CGRectGetMinX(_tmRimg2.frame)-TMScreenW *100/320, 0, TMScreenW *100/320, TMScreenH *90/1334);
    self.allClassifyListView = [[UIView alloc] init];
    
    _allClassifyListView.frame = CGRectMake(0, CGRectGetMaxY(self.allclassifyView.frame)+0.5, TMScreenW, TMScreenW/3*1.2*4-0.5);
    _allClassifyListView.backgroundColor = [UIColor whiteColor];
    [self.backScrollView addSubview:_allClassifyListView];
    
    //    整个页面高度的计算
    tHeight = CGRectGetMaxY(self.allClassifyListView.frame);
    //    NSLog(@"%f", tHeight);
    //  重写给scrollview滚动范围赋值
    self.backScrollView.contentSize = CGSizeMake(0, tHeight);
    
    // moreViewUI计算
    self.moreView.frame = CGRectMake(0, CGRectGetMaxY(self.allClassifyListView.frame)+TMScreenH *5/568, TMScreenW, TMScreenH *100/568);
    [self.backScrollView addSubview:_moreView];
    //    self.moreView.userInteractionEnabled = YES;
    
    //    self.tmLtitleLabel.font
    NSDictionary *dic = [NSDictionary dictionaryWithObject:self.tmLtitleLabel.font forKey:NSFontAttributeName];
    CGSize labSize = [@"点击联系:" sizeWithAttributes:dic];
    //    在线客服UI 计算
    self.onlineserviceView.frame = CGRectMake(0, TMScreenH *10/568, TMScreenW, TMScreenH *40/568);
    self.tmLimg1.frame = CGRectMake(TMScreenW *70/320, (TMScreenH *40/568 - TMScreenW *18/320)/2, TMScreenW *18/320, TMScreenW *18/320);
    self.tmLtitleLabel.frame = CGRectMake(CGRectGetMaxX(_tmLimg1.frame)+TMScreenW *5/320, 0, labSize.width, TMScreenH *40/568);
    self.onlineserviceBtn.frame = CGRectMake(CGRectGetMaxX(_tmLtitleLabel.frame)+TMScreenW *3/320, 0, TMScreenW *120/320, TMScreenH *40/568);
    
    //    热线电话UI 计算
    self.hottelephoneView.frame = CGRectMake(0, TMScreenH *50/568, TMScreenW, TMScreenH *40/568);
    self.tmPimg1.frame = CGRectMake(TMScreenW *70/320, (TMScreenH *40/568 - TMScreenW *18/320)/2, TMScreenW *18/320, TMScreenW *18/320);
    self.tmPtitleLabel.frame = CGRectMake(CGRectGetMaxX(_tmLimg1.frame)+TMScreenW *5/320, 0, labSize.width, TMScreenH *40/568);
    self.hottelephoneBtn.frame = CGRectMake(CGRectGetMaxX(_tmLtitleLabel.frame)+TMScreenW *3/320, 0, TMScreenW *120/320, TMScreenH *40/568);
    
}

#pragma Nav
- (void)createNav{
    
    //    UIButton * btnWebLogo = [UIButton buttonWithType:UIButtonTypeCustom];
    //    btnWebLogo.frame = CGRectMake(0, 0, TMScreenW *50/320, TMScreenH *24/568);
    //    btnWebLogo.backgroundColor = [UIColor redColor];
    //    [btnWebLogo setImage:[UIImage imageNamed:@"toolmalllogo.png"]  forState:UIControlStateNormal];
    //    btnWebLogo.adjustsImageWhenHighlighted = NO;
    
    UIImageView *logoImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"toolmalllogo.png"]];
    logoImg.frame = CGRectMake(0, 0, TMScreenW *50/320, TMScreenH *25/568);
    UIBarButtonItem * left = [[UIBarButtonItem alloc]initWithCustomView:logoImg];
    self.navigationItem.leftBarButtonItem = left;
    
    _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    _searchBtn.userInteractionEnabled = NO;
    CGFloat marginWidth;
    if (TMScreenW == 414) {
        marginWidth = 52;
    } else {
        marginWidth = 44;
    }
    _searchBtn.frame = CGRectMake(0, 0, TMScreenW - TMScreenW *71/320 - marginWidth,TMScreenH *28/568);
    //    _searchBtn.backgroundColor = [UIColor yellowColor];
    _searchBtn.titleLabel.textColor = [UIColor lightGrayColor];
    _searchBtn.layer.masksToBounds = YES;
    _searchBtn.layer.cornerRadius = 5;
    _searchBtn.layer.borderColor = [UIColor colorWithRed:209/255.0 green:209/255.0 blue:209/255.0 alpha:1].CGColor;
    _searchBtn.layer.borderWidth = 0.5;
    
    // 请输入产品名称
    NSString *index_nav_btnTitle = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"index_nav_btnTitle"];
    [_searchBtn setTitle:index_nav_btnTitle forState:(UIControlStateNormal)];
    [_searchBtn setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
    _searchBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _searchBtn.contentEdgeInsets = UIEdgeInsetsMake(0, TMScreenW *30/320, 0, 0);
    //    [_searchBtn setFont:[UIFont systemFontOfSize:12]];
    _searchBtn.titleLabel.font = [UIFont systemFontWithSize:12.0];
    
    [_searchBtn addTarget:self action:@selector(pushToSearchPage:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.titleView = _searchBtn;
    
    
#pragma 需要更改图片的地方
    CGFloat textFW = CGRectGetWidth(_searchBtn.frame);
    CGFloat textFH = CGRectGetHeight(_searchBtn.frame);
    //        搜索框的放大镜图片
    UIButton * btnSearch = [UIButton buttonWithType:UIButtonTypeCustom];
    //    btnSearch.backgroundColor = [UIColor redColor];
    btnSearch.frame = CGRectMake(0, 0, textFH, textFH);
    [btnSearch setImage:[UIImage imageNamed:@"搜索"] forState:UIControlStateNormal];
    [btnSearch addTarget:self action:@selector(pushToSearchPage:) forControlEvents:UIControlEventTouchUpInside];
    //    _searchBtn.leftViewMode = UITextFieldViewModeAlways;
    //    _searchBtn.leftView = btnSearch;
    [_searchBtn addSubview:btnSearch];
    
    
    //        搜索框中的扫一扫图片
    UIButton * btnScanCode = [UIButton buttonWithType:UIButtonTypeCustom];
    //    btnScanCode.backgroundColor = [UIColor greenColor];
    btnScanCode.frame = CGRectMake(textFW-textFH, 0, textFH, textFH);
    [btnScanCode addTarget:self action:@selector(clickScan:) forControlEvents:UIControlEventTouchUpInside];
    [btnScanCode setImage:[UIImage imageNamed:@"扫一扫"] forState:UIControlStateNormal];
    [_searchBtn addSubview:btnScanCode];
    //    _searchBtn.rightViewMode = UITextFieldViewModeAlways;
    //    _searchBtn.rightView = btnScanCode;
    //    _searchBtn.keyboardType = UIReturnKeySearch;
    
    UIButton * btnMSG = [UIButton buttonWithType:UIButtonTypeCustom];
    //    btnMSG.backgroundColor = [UIColor cyanColor];
    btnMSG.frame = CGRectMake(0, 0, TMScreenW *21/320, TMScreenH *28/568);
    [btnMSG setImage:[UIImage imageNamed:@"indexmsg.png"]  forState:UIControlStateNormal];
    [btnMSG setImage:[UIImage imageNamed:@"indexmsg.png"]  forState:UIControlStateHighlighted];
    [btnMSG addTarget:self action:@selector(clickMsgCenter:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightButton = [[UIBarButtonItem alloc] initWithCustomView:btnMSG];
    rightButton.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightButton;
    
}

- (void)clickScan:(id)sender{
    
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
    [self.navigationController pushViewController:vc animated:NO];
}

- (IBAction)clickMsgCenter:(id)sender{
    MsgList *msgList = [[MsgList alloc] initWithNibName:@"MsgList" bundle:nil];
    [self.navigationController pushViewController:msgList animated:YES];
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods
//更新列表数据
- (void)reloadTableViewDataSource{
    [self refreshData];
    reloading = YES;
}

- (void)doneLoadingTableViewData{
    
    //model should call this when its done loading
    reloading = NO;
    [refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.backScrollView];
    
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    
    //    [self reloadTableViewDataSource];
    [self performSelector:@selector(reloadTableViewDataSource) withObject:nil afterDelay:0.2];
    
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    
    return reloading; // should return if data source model is reloading
    
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    
    return [NSDate date]; // should return date data source was last changed
    
}


- (void)getXMLText:(NSData *)data {
    
    NSDate *date1 = [NSDate date];
    
    NSError *error = nil;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:data options:0 error:&error];
    if (error) {
        NSLog(@"error : %@", error);
        return;
    }
    GDataXMLElement *rootElement = [doc rootElement];
    
    NSArray *strings = [rootElement elementsForName:@"string"];
    
    for (GDataXMLElement *string in strings) {
        
        TextModel *textModel = [[TextModel alloc] init];
        
        NSString *path = [[string attributeForName:@"name"] stringValue];
        NSString *value = [string stringValue];
        
        textModel.path = path;
        textModel.textStr = value;
        
        [[TextDataBase shareTextDataBase] saveTextModel:textModel];
    }
    NSDate *date2 = [NSDate date];
    NSTimeInterval a = [date2 timeIntervalSince1970] - [date1 timeIntervalSince1970];
    NSLog(@"用时%.3f秒",a);
}

#pragma mark - setTextValue文案配置
- (void)setTextValue {
    
    // 请输入产品名称
    NSString *index_nav_btnTitle = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"index_nav_btnTitle"];
    // 猫工推荐
    NSString *index_recommend_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"index_recommend_title"];
    // 更多
    NSString *index_recommend_more = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"index_recommend_more"];
    // 热门活动
    NSString *index_hotactive_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"index_hotactive_title"];
    // 今日大牌
    NSString *index_todayBrand_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"index_todayBrand_title"];
    // 更多
    NSString *index_todayBrand_more = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"index_todayBrand_more"];
    // 全部分类
    NSString *index_allclassify_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"index_allclassify_title"];
    // 详情
    NSString *index_allclassify_more = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"index_allclassify_more"];
    // 点击联系:
    NSString *index_onlineweb_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"index_onlineweb_title"];
    // 在线客服
    NSString *index_onlineweb_content = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"index_onlineweb_content"];
    // 热线电话:
    NSString *index_onlinePhone_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"index_onlinePhone_title"];
    
    [_searchBtn setTitle:index_nav_btnTitle forState:(UIControlStateNormal)];
    self.tmRtitleLabel.text = index_recommend_title;
    self.tmRmoreLabel.text = index_recommend_more;
    self.tmHtitleLabel.text = index_hotactive_title;
    //    if (index_hotactive_more.length) {
    //        self.tmHmoreLabel.text = index_hotactive_more;
    //    } else {
    self.tmHimg2.hidden = YES;
    //    }
    self.tmTtitleLabel.text = index_todayBrand_title;
    self.tmTmoreLabel.text = index_todayBrand_more;
    self.tmAtitleLabel.text = index_allclassify_title;
    self.tmAmoreLabel.text = index_allclassify_more;
    self.tmLtitleLabel.text = index_onlineweb_title;
    [self.onlineserviceBtn setTitle:index_onlineweb_content forState:(UIControlStateNormal)];
    self.tmPtitleLabel.text = index_onlinePhone_title;
}

- (void)viewDidUnload {
    refreshHeaderView=nil;
}

- (void)dealloc {
    
    refreshHeaderView = nil;
}

#pragma search模块

//发起请求
- (void)getSearchRequest{
    SearchService * searchService = [[SearchService alloc] initWithDelegate:self parentView:self.view];
    [searchService getProductWithFetchSearchHistory:true andPagination:pagination success:^(BaseModel *responseObj) {
        _hotArray = [[NSMutableArray alloc] init];
        [_hotArray removeAllObjects];
        
        HotSearchKeyListResponse * resobj = (HotSearchKeyListResponse *)responseObj;
        [_hotArray addObjectsFromArray:resobj.data];
        
        if (pagination.page > 1) {
            NSMutableArray<NSString *> *hotSeaches = [[NSMutableArray alloc] init];
            for (NSString *str in _hotArray) {
                [hotSeaches addObject:str];
            }
            weakVC.hotSearches = hotSeaches;
            [weakVC.tableView reloadData];
        }
        
    }];
    
}

- (void)pushToSearchPage:(UIButton *)button{
    
    NSString *prodHotKeySearchVC_searchText_plaTitle = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"prodHotKeySearchVC_searchText_plaTitle"];
    
    NSMutableArray<NSString *> *hotSeaches = [[NSMutableArray alloc] init];
    for (NSString *str in _hotArray) {
        [hotSeaches addObject:str];
    }
    
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:prodHotKeySearchVC_searchText_plaTitle didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        
        ProdList *prodList = [[ProdList alloc] initWithNibName:@"ProdList" bundle:nil];
        prodList.isSearch = true;
        prodList.searchKeyWord = searchText;
        [self.navigationController pushViewController:prodList animated:YES];
        [searchViewController dismissViewControllerAnimated:NO completion:nil];
        
    }];
    weakVC = searchViewController;
    searchViewController.refleshClick = ^(void){
        
        pagination.page ++;
        [self getSearchRequest];
    };
    searchViewController.hotSearchStyle = PYHotSearchStyleDefault; // 热门搜索风格为默认
    searchViewController.searchHistoryStyle = PYSearchHistoryStyleBorderTag; // 搜索历史风格根据选择
    searchViewController.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    [self presentViewController:nav  animated:NO completion:nil];
}

@end
