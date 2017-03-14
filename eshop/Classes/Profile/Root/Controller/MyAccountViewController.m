//
//  MyAccountViewController.m
//  toolmall
//
//  Created by mc on 15/10/12.
//
//

#import "MyAccountViewController.h"

@interface MyAccountViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *favoritesTopLayout10;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *favoritesCenterLayout10;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *favoritesBottemLayout5;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderTopLayout8;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderBottomLayout8;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderNumTopLayout3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderNumBottomLayout3;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgBtnTopLayout10;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgBtnBottomLayout10;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginTopLayout15;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginBottomLayout15;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *classifyTopLayout15;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *classifyBottomLayout15;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightLayout190;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewHeightLayout48;


@property (nonatomic, retain) UIViewController *lastVC;

@property (weak, nonatomic) IBOutlet UILabel *orderTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderMoreLabel;

@property (weak, nonatomic) IBOutlet UIButton *view2Btn1;
@property (weak, nonatomic) IBOutlet UIButton *view2Btn2;
@property (weak, nonatomic) IBOutlet UIButton *view2Btn3;
@property (weak, nonatomic) IBOutlet UIButton *view2Btn4;

@property (weak, nonatomic) IBOutlet UILabel *view3Label1;
@property (weak, nonatomic) IBOutlet UILabel *view3Label2;
@property (weak, nonatomic) IBOutlet UILabel *view3Label3;
@property (weak, nonatomic) IBOutlet UILabel *view3Label4;
@property (weak, nonatomic) IBOutlet UILabel *footerViewTitle;
@property (weak, nonatomic) IBOutlet UILabel *footerViewMore;

@end

@implementation MyAccountViewController
@synthesize btn_mobileno;
@synthesize btn_login;
@synthesize scrollview;
@synthesize btn_await_pay;
@synthesize btn_await_ship;
@synthesize btn_shipped;
@synthesize btn_await_review;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self configureCutLine];
    
    self.view.backgroundColor = groupTableViewBackgroundColorSelf;
    self.scrollview.backgroundColor = groupTableViewBackgroundColorSelf;
    self.bgView.backgroundColor = groupTableViewBackgroundColorSelf;
    
    // @"个人账户"
    NSString *myAccount_navItem_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"myAccount_navItem_title"];
    // @"设置"
    NSString *myAccount_navRightButton_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"myAccount_navRightButton_title"];
    self.navigationItem.title = myAccount_navItem_title;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBarHidden = NO;
    // Make BarButton Item
    UIBarButtonItem *navRightButton = [[UIBarButtonItem alloc] initWithTitle:myAccount_navRightButton_title style:UIBarButtonItemStylePlain target:self action:@selector(snapImage:)];
    [navRightButton setTintColor:TMBlackColor ];
    self.navigationItem.rightBarButtonItem = navRightButton;
    [super addThreedotButton];
    
    productService = [[ProductService alloc] initWithDelegate:self parentView:self.view];
    
    [self refreshUI:113 bgHeight:-48];
    
    self.scrollview.delegate = self;
    
    if (refreshHeaderView == nil) {
        
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.scrollview.bounds.size.height, kWidth, self.scrollview.bounds.size.height)];
        view.delegate = self;
        [self.scrollview addSubview:view];
        refreshHeaderView = view;
    }
    
    
    [self setTextValue];
}

- (void)refreshUI:(int)margin bgHeight:(int)bgHMarin {
    
    CGFloat height = TMScreenH - margin;
    
    self.favoritesTopLayout10.constant = height *13/445;
    self.favoritesCenterLayout10.constant = height *10/445;
    self.favoritesBottemLayout5.constant = height *5/445;
    self.orderTopLayout8.constant = height *13/445;
    self.orderBottomLayout8.constant = height *13/445;
    self.orderNumTopLayout3.constant = height *3/445;
    self.orderNumBottomLayout3.constant = height *3/445;
    self.imgBtnTopLayout10.constant = height *10/445;
    self.imgBtnBottomLayout10.constant = height *10/445;
    
    self.loginTopLayout15.constant = height *14/554;
    self.loginBottomLayout15.constant = height *14/554;
    self.classifyTopLayout15.constant = height *14/554;
    self.classifyBottomLayout15.constant = height *14/554;
    self.heightLayout190.constant = height*95.0/554;
    
    self.bgViewHeightLayout48.constant = bgHMarin;
    
    [self updateViewConstraints];
}

- (void)refreshData {
    
    self.imgPoint_YH.hidden = YES;
    self.footView.showsHorizontalScrollIndicator = NO;
    
    if (self.footView.subviews) {
        for(UIView *view in [self.footView subviews])
        {
            [view removeFromSuperview];
        }
    }
    [productService productViewHistory];
    SESSION *session = [SESSION getSession];
    //设置用户名
    Boolean regenUpdateMoreButton = false;
    if (![self.btn_login.titleLabel.text isEqualToString:session.uname]){
        
        // @"未登录"
        NSString *myAccount_view1_nameStr = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"myAccount_view1_nameStr"];
        // @"点击立即登录"
        NSString *myAccount_view1_phoneStr = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"myAccount_view1_phoneStr"];
        //        NSString *nameStr = myAccount_view1_nameStr;
        //        NSString *phoneStr = myAccount_view1_phoneStr;
        if (session.uid > 0){
            myAccount_view1_nameStr = session.uname;
            myAccount_view1_phoneStr = [SESSION getMobileNo];
        }
        [self.btn_login setTitle:myAccount_view1_nameStr forState:UIControlStateNormal];
        [self.btn_mobileno setTitle:myAccount_view1_phoneStr forState:UIControlStateNormal];
        regenUpdateMoreButton = true;
    }
    
    if (session.uid < 0)
    {
        self.imgPoint_YH.hidden = YES;
        self.img_profile.image = [UIImage imageNamed:@"头像"];
        //        self.btn_profile.imageView.image = nil;
        //        [self.btn_profile setImage:[UIImage imageNamed:@"头像"] forState:UIControlStateNormal];
        self.btn_await_pay.badgeValue = nil;
        self.btn_await_ship.badgeValue = nil;
        self.btn_shipped.badgeValue = nil;
        self.btn_await_review.badgeValue = nil;
        [self.btn_login removeTarget:self action:@selector(snapImage:) forControlEvents:UIControlEventTouchUpInside];
        [self.btn_mobileno removeTarget:self action:@selector(snapImage:) forControlEvents:UIControlEventTouchUpInside];
        [self.btn_profile removeTarget:self action:@selector(clickUpdateMore:) forControlEvents:UIControlEventTouchUpInside];
        [self.btn_profile addTarget:self action:@selector(clickLogin:) forControlEvents:UIControlEventTouchUpInside];
        [self.btn_login addTarget:self action:@selector(clickLogin:) forControlEvents:UIControlEventTouchUpInside];
        [self.btn_mobileno addTarget:self action:@selector(clickLogin:) forControlEvents:UIControlEventTouchUpInside];
        
    } else {
        
        self.img_profile.image = [UIImage imageNamed:@"头像2"];
        //        [self.btn_profile.imageView setHighlightedImage:[UIImage imageNamed:@"头像2"]];
        // @"请绑定手机"
        NSString *myAccount_view1_btn_mobileno = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"myAccount_view1_btn_mobileno"];
        if ([SESSION getMobileNo] == nil){
            [self.btn_mobileno setTitle:myAccount_view1_btn_mobileno forState:UIControlStateNormal];
            
        } else {
            [self.btn_mobileno setTitle:[SESSION getMobileNo] forState:UIControlStateNormal];
        }
        //        self.btn_mobileno.hidden = NO;
        //        self.img_mobile.hidden = NO;
        userInfoService = [UserInfoService alloc];
        userInfoService.delegate = self;
        userInfoService.parentView = self.view;
        [userInfoService getUserInfo];
        [self.btn_login removeTarget:self action:@selector(clickLogin:) forControlEvents:UIControlEventTouchUpInside];
        [self.btn_mobileno removeTarget:self action:@selector(clickLogin:) forControlEvents:UIControlEventTouchUpInside];
        [self.btn_profile removeTarget:self action:@selector(clickLogin:) forControlEvents:UIControlEventTouchUpInside];
        [self.btn_profile addTarget:self action:@selector(clickUpdateMore:) forControlEvents:UIControlEventTouchUpInside];
        [self.btn_login addTarget:self action:@selector(snapImage:) forControlEvents:UIControlEventTouchUpInside];
        [self.btn_mobileno addTarget:self action:@selector(snapImage:) forControlEvents:UIControlEventTouchUpInside];
        [self displayProfileImage];
    }
    
}
- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    self.img_profile.layer.cornerRadius = self.img_profile.frame.size.width/2.0;
    self.img_profile.layer.masksToBounds = YES;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [YCXMenu dismissMenu];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self refreshData];
    
    self.tabBarController.tabBar.hidden = NO;
    self.navigationItem.hidesBackButton = YES;
    [self refreshUI:113 bgHeight:-48];
    if ([self.type isEqualToString:@"webView"]) {
        
        self.tabBarController.tabBar.hidden = YES;
        [super addNavBackButton];
        [self refreshUI:64 bgHeight:1];
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
    
    //    self.tabBarController.tabBar.hidden = NO;
}

- (void)loadResponse:(NSString *) url response:(BaseModel *)response{
    
    if([url isEqual:api_member_productviewhistory]){
        ProductViewHistoryResponse * respobj = (ProductViewHistoryResponse *)response;
        _arrayFootprint = [[NSMutableArray alloc] initWithCapacity:0];
        [_arrayFootprint removeAllObjects];
        [_arrayFootprint addObjectsFromArray:respobj.data];
        if (_arrayFootprint.count > 0) {
            
            [self createItemsOfProductViewHistory];
            self.footView.backgroundColor = [UIColor whiteColor];
        }
        else {
            self.footView.backgroundColor = groupTableViewBackgroundColorSelf;
        }
        // 停止刷新<隐藏刷新header视图>
        [self doneLoadingTableViewData];
        
    } else if ([url isEqual:api_userinfo]){
        
        UserInfoResponse * respobj = (UserInfoResponse *)response;
        _user = respobj.data;
        //        NSLog(@"--%@",_user);
        [[Config Instance] saveUserInfo:@"email" withvalue:respobj.data.email];
        [[Config Instance] saveUserInfo:@"memberrank" withvalue:respobj.data.rank_name];
        
        OrderNum *orderNum = respobj.data.order_num;
        if (orderNum.await_pay > 0){
            self.lab_await_pay_num.text = [NSString stringWithFormat:@"%d", orderNum.await_pay];
            self.lab_await_pay_num.textColor = [UIColor redColor];
        } else {
            self.lab_await_pay_num.text = @"0";
            self.lab_await_pay_num.textColor = [UIColor lightGrayColor];
        }
        if (orderNum.await_ship > 0){
            self.lab_await_ship_num.text = [NSString stringWithFormat:@"%d", orderNum.await_ship];
            self.lab_await_ship_num.textColor = [UIColor redColor];
        } else {
            self.lab_await_ship_num.text = @"0";
            self.lab_await_ship_num.textColor = [UIColor lightGrayColor];
        }
        
        if (orderNum.shipped > 0){
            self.lab_await_shiped_num.text = [NSString stringWithFormat:@"%d", orderNum.shipped];
            self.lab_await_shiped_num.textColor = [UIColor redColor];
        } else {
            self.lab_await_shiped_num.text = @"0";
            self.lab_await_shiped_num.textColor = [UIColor lightGrayColor];
        }
        if (orderNum.await_review > 0){
            self.lab_await_review_num.text = [NSString stringWithFormat:@"%d", orderNum.await_review];
            self.lab_await_review_num.textColor = [UIColor redColor];
        } else {
            self.lab_await_review_num.text = @"0";
            self.lab_await_review_num.textColor = [UIColor lightGrayColor];
        }
        
#pragma mark = 优惠券标记显/隐
        NSString * couponCodeNum = [NSString stringWithFormat:@"%d", respobj.data.couponCodeNum];
        NSString * localNum = [[NSUserDefaults standardUserDefaults] valueForKey:localCouponCodeNum];
        if (localNum < couponCodeNum && respobj.data.couponCodeNum > 0) {
            
            self.imgPoint_YH.hidden = NO;
        } else {
            self.imgPoint_YH.hidden = YES;
        }
        
        [[NSUserDefaults standardUserDefaults] setValue:couponCodeNum forKeyPath:localCouponCodeNum];
    }
    
}

//创建足迹中的每个item
- (void)createItemsOfProductViewHistory{
    int itemN = 0;
    CGFloat itemH = CGRectGetHeight(self.footView.frame);
    CGFloat itemW = itemH * 0.82;
    for (int i =0; i<_arrayFootprint.count; i++) {
        
        if (i == 10) {
            break;
        }
        itemN = i+1;
        
        FootViewItem * footItem = [[FootViewItem alloc] initWithFrame:CGRectMake(i*itemW, 0, itemW, itemH) image:[_arrayFootprint[i] valueForKey:@"image"] title:[_arrayFootprint[i] valueForKey:@"name"] price:[_arrayFootprint[i] valueForKey:@"price"]];
        footItem.userInteractionEnabled = YES;
        self.footView.userInteractionEnabled = YES;
        self.footView.backgroundColor = [UIColor whiteColor];
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, footItem.frame.size.width, footItem.frame.size.height);
        button.tag = [[_arrayFootprint[i] valueForKey:@"id"] integerValue];
        [footItem addSubview:button];
        [button addTarget:self action:@selector(clickToDetailInfomation:) forControlEvents:UIControlEventTouchUpInside];
        [self.footView addSubview:footItem];
        
    }
    self.footView.bounces = NO;
    self.footView.contentSize = CGSizeMake(itemN*itemW, 0);
    
}
//跳转到商品详情页
- (void)clickToDetailInfomation:(UIButton *)button{
    
    ProductInfoViewController * p = [[ProductInfoViewController alloc] initWithNibName:@"ProductInfoViewController" bundle:nil];
    p.productId = button.tag;
    p.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:p animated:YES];
}
//根据类型跳转到订单列表页
- (IBAction)clickFilterOrders:(UIButton *)sender{
    if (![CommonUtils chkLogin:self gotoLoginScreen:YES]){
        return;
    }
    NSArray *filterTypes = [NSArray arrayWithObjects:@"", @"await_pay", @"await_ship", @"shipped", @"await_review", nil];
    NSString *initType = [filterTypes objectAtIndex:sender.tag];
    OrderList * orderList = [[OrderList alloc] init];
    orderList.hidesBottomBarWhenPushed = YES;
    orderList.iniType = initType;
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.backBarButtonItem = barButtonItem;
    [self.navigationController pushViewController:orderList animated:YES];
}
//跳转到订单列表页
- (IBAction)clickAllOrder:(id)sender
{
    if (![CommonUtils chkLogin:self gotoLoginScreen:YES]){
        return;
    }
    OrderList * orderList = [[OrderList alloc] init];
    orderList.hidesBottomBarWhenPushed = YES;
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.backBarButtonItem = barButtonItem;
    [self.navigationController pushViewController:orderList animated:YES];
}
//跳转到完善个人信息页面
- (IBAction)clickUpdateMore:(id)sender
{
    ImproveInfoViewController * updateMore = [[ImproveInfoViewController alloc] init];
    updateMore.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:updateMore animated:YES];
}
//登录
- (IBAction)clickLogin:(id)sender
{
    ShopLoginViewController * loginVC = [[ShopLoginViewController alloc] init];
    loginVC.hidesBottomBarWhenPushed = YES;
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.backBarButtonItem = barButtonItem;
    [self.navigationController pushViewController:loginVC animated:YES];
}

//收货地址管理
- (IBAction)clickAddressManage:(id)sender{
    if (![CommonUtils chkLogin:self gotoLoginScreen:YES]){
        return;
    }
    AddressList *addressList = [[AddressList alloc] init];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.backBarButtonItem = barButtonItem;
    [self.navigationController pushViewController:addressList animated:YES];
}

//优惠券列表
- (IBAction)clickMyCouponCodes:(id)sender{
    if (![CommonUtils chkLogin:self gotoLoginScreen:YES]){
        return;
    }
    CouponCodeList *couponCodeList = [[CouponCodeList alloc] initWithNibName:@"CouponCodeList" bundle:nil];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.backBarButtonItem = barButtonItem;
    
    [self.navigationController pushViewController:couponCodeList animated:YES];
}
//我的收藏
- (IBAction)clickMyFavorites:(id)sender{
    if (![CommonUtils chkLogin:self gotoLoginScreen:YES]){
        return;
    }
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.backBarButtonItem = barButtonItem;
    
    FavoriteListController *favoriteList = [[FavoriteListController alloc] initWithNibName:@"FavoriteListController" bundle:nil];
    [self.navigationController pushViewController:favoriteList animated:YES];
}

//联系客服
- (IBAction)clickCallPhone:(id)sender{
    
    // @"联系客服"
    NSString *myAccount_webView_navTitle = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"myAccount_webView_navTitle"];
    MyWebView *myWebView = [[MyWebView alloc] init];
    myWebView.navTitle = myAccount_webView_navTitle;
    NSString *url = [[Config Instance] getUserInfo:onlineUrl];
    myWebView.loadUrl = url;
    myWebView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:myWebView animated:YES];
}

//跳转到足迹列表页
- (IBAction)clickFootPrint:(id)sender {
    
    FootPrintViewController * p = [[FootPrintViewController alloc] initWithNibName:@"FootPrintViewController" bundle:nil];
    p.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:p animated:YES];
}

#pragma mark - 跳转至设置页面<我的资料>
/*跳转至设置页面<我的资料>*/
- (void) snapImage: (id) sender
{
    MyInfoViewController * myInfo = [[MyInfoViewController alloc] initWithNibName:@"MyInfoViewController" bundle:nil];
    myInfo.hidesBottomBarWhenPushed = YES;
    myInfo.user = _user;
    
    [self.navigationController pushViewController:myInfo animated:YES];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
{
    // @"保存图片成功"
    NSString *myAccount_toastNotification_msg1 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"myAccount_toastNotification_msg1"];
    // @"保存图片失败"
    NSString *myAccount_toastNotification_msg2 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"myAccount_toastNotification_msg2"];
    if (!error)
        [CommonUtils ToastNotification:myAccount_toastNotification_msg1 andView:self.view andLoading:NO andIsBottom:NO];
    else
        [CommonUtils ToastNotification:myAccount_toastNotification_msg2 andView:self.view andLoading:NO andIsBottom:NO];
}

-(NSString *)getImageSavePath{
    //获取存放的照片
    //获取Documents文件夹目录
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [path objectAtIndex:0];
    //指定新建文件夹路径
    NSString *imageDocPath = [documentPath stringByAppendingPathComponent:@"/profilephoto.jpg"];
    return imageDocPath;
}

- (void) imagePickerController:(UIImagePickerController *)picker
 didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *image = [self fixOrientation:[info objectForKey:@"UIImagePickerControllerOriginalImage"]];
    
    //保存
    
    NSString *imagePath = [self getImageSavePath];
    
    //以下是保存文件到Document路径下
    //把图片转成NSData类型的数据来保存文件
    NSData *data = nil;
    //判断图片是不是png格式的文件
    if (UIImagePNGRepresentation(image)) {
        //返回为png图像。
        data = UIImagePNGRepresentation(image);
    }else {
        //返回为JPEG图像。
        data = UIImageJPEGRepresentation(image, 1.0);
    }
    //保存
    [[NSFileManager defaultManager] createFileAtPath:imagePath contents:data attributes:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self displayProfileImage];
}

- (void)displayProfileImage{
    NSString *imagePath = [self getImageSavePath];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:imagePath];
    if (image != nil){
        self.img_profile.image = image;
    }
}

- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}


#pragma mark -
#pragma mark Data Source Loading / Reloading Methods
//更新列表数据
- (void)reloadTableViewDataSource{
    
    [self refreshData];
    reloading = YES;
}

- (void)doneLoadingTableViewData{
    
    reloading = NO;
    [refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.scrollview];
    
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    
    [self performSelector:@selector(reloadTableViewDataSource) withObject:nil afterDelay:0.2];
    
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    
    return reloading;
    
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    
    return [NSDate date];
    
}

- (void)viewDidUnload {
    refreshHeaderView = nil;
}

- (void)dealloc {
    
    refreshHeaderView = nil;
}

#pragma mark - setTextValue文案配置

- (void)setTextValue {
    
    // 我的订单
    NSString *myAccount_view2_orderTitle = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"myAccount_view2_orderTitle"];
    // 查看全部订单
    NSString *myAccount_view2_orderMore = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"myAccount_view2_orderMore"];
    // 待付款
    NSString *myAccount_view2_btn1 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"myAccount_view2_btn1"];
    // 待发货
    NSString *myAccount_view2_btn2 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"myAccount_view2_btn2"];
    // 待收货
    NSString *myAccount_view2_btn3 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"myAccount_view2_btn3"];
    // 待评价
    NSString *myAccount_view2_btn4 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"myAccount_view2_btn4"];
    // 收藏夹
    NSString *myAccount_view3_label1 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"myAccount_view3_label1"];
    // 优惠券
    NSString *myAccount_view3_label2 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"myAccount_view3_label2"];
    // 收货地址
    NSString *myAccount_view3_label3 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"myAccount_view3_label3"];
    // 在线咨询
    NSString *myAccount_view3_label4 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"myAccount_view3_label4"];
    // 足迹
    NSString *myAccount_view4_footerTitle = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"myAccount_view4_footerTitle"];
    // 更多
    NSString *myAccount_view4_footerMore = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"myAccount_view4_footerMore"];
    
    self.orderTitleLabel.text = myAccount_view2_orderTitle;
    self.orderMoreLabel.text = myAccount_view2_orderMore;
    [self.view2Btn1 setTitle:myAccount_view2_btn1 forState:(UIControlStateNormal)];
    [self.view2Btn2 setTitle:myAccount_view2_btn2 forState:(UIControlStateNormal)];
    [self.view2Btn3 setTitle:myAccount_view2_btn3 forState:(UIControlStateNormal)];
    [self.view2Btn4 setTitle:myAccount_view2_btn4 forState:(UIControlStateNormal)];
    self.view3Label1.text = myAccount_view3_label1;
    self.view3Label2.text = myAccount_view3_label2;
    self.view3Label3.text = myAccount_view3_label3;
    self.view3Label4.text = myAccount_view3_label4;
    self.footerViewTitle.text = myAccount_view4_footerTitle;
    self.footerViewMore.text = myAccount_view4_footerMore;
}

@end
