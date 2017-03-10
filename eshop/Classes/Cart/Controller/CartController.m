//
//  Cart.m
//  toolmall
//
//  Created by mc on 15/10/26.
//
//

#import "CartController.h"

#import "UIFont+Fit.h"
//#import "ProdInfo.h"
#import "ProductInfoViewController.h"
#import "DeleteView.h"

@interface CartController ()
<UITableViewDelegate,UITableViewDataSource,MBProgressHUDDelegate,UIAlertViewDelegate,PullTableViewDelegate,UITextFieldDelegate,CartPromotionTitleViewDelegate,UIAlertViewDelegate,UIGestureRecognizerDelegate,ServiceResponselDelegate,CartItemHeadDelegate,CartItemCellDelegate>
{
    CartService *cartService;
    OrderService *orderService;
    NSMutableArray *cartItemGroup; //根据卖家来分组
    
    AppCart *cart;
    UILabel *lbTotalWord;
    NSIndexPath *deleteIndexPath;
    
    NSString * promotionType;
    CGFloat cellHeight; //用来存储cell的高度
    
    CGFloat heightOfPromotionTitleView;
    CGFloat heightOfOneGiftView;
    CGFloat heightOfDiscountView;
    CGFloat heightOfBlank;
    //    BOOL firstOrderFreeDispalyed; //用来是否展示首单免邮
    NSString * today;
    NSString * closeDay1; //首单免邮关闭日期字符串
    //    NSString * closeDay2; //500免邮关闭日期字符串
    NSMutableArray * deleteCartItemIds;
    UIButton *btnSelAllWord;
    UIButton *btnDelAllWord;
    UILabel *labelNotIncludeFreight;
    UIButton *btnSett;
    BOOL commonOfCartItems; // 是否是普通商品(cartItem.promotion.id > 0)
    
    int selectNum;
}
@property (nonatomic, retain) UIViewController *lastVC;

@end

@implementation CartController
@synthesize btnSelAll;
@synthesize lbTotalAmount;
@synthesize noResultView;
@synthesize btmView;

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [YCXMenu dismissMenu];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
    [self loadData:YES];
    [cartService getIsFreeInfoOfFirstOrder];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureCutLine];
    
    [self initView];
    
    [super addThreedotButton];
 
    [self initService];
    
    [self initFooterView];
    
    [self loadData:YES];
    
    [cartService getIsFreeInfoOfFirstOrder];
}

-(void)initService{
    
    cartService = [CartService alloc];
    cartService.delegate = self;
    cartService.parentView = self.view;
    
    orderService = [OrderService alloc];
    orderService.delegate = self;
    orderService.parentView = self.view;
}

-(void)initView{
    
    self.edgesForExtendedLayout = NO;
    [self.cartTable setHasLoadingMore:NO];
    self.view.backgroundColor = groupTableViewBackgroundColorSelf;
    self.cartTable.backgroundColor = groupTableViewBackgroundColorSelf;
    self.cartTable.rowHeight = UITableViewAutomaticDimension;
    self.cartTable.estimatedRowHeight = 130;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [btnSelAll setImage:[UIImage imageNamed:@"newcheckfalsedelete"] forState:UIControlStateNormal];
    [btnSelAll setImage:[UIImage imageNamed:@"newchecktrue"] forState:UIControlStateSelected];
    
    heightOfPromotionTitleView = 30;
    heightOfOneGiftView = 80;
    heightOfDiscountView = 60;
    cartItemGroup = [[NSMutableArray alloc] initWithCapacity:20];
    promotionType = [[NSString alloc] init];
    // 购物车
    NSString *cartVC_navItem_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"cartVC_navItem_title"];
    self.navigationItem.hidesBackButton = NO;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = cartVC_navItem_title;
    if (!self.hasBottomBar){
        [super addNavBackButton];
    }
    commonOfCartItems = YES;
    
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY/MM/dd"];
    today = [dateFormatter stringFromDate:currentDate];
    closeDay1 = @"CartFreeDeliveryClosedDate";
}

#pragma mark 刷新数据 edit by dxw 2017-03-07

-(void)refleshData{
    
    [self loadData:YES];
    [cartService getIsFreeInfoOfFirstOrder];
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

#pragma mark 获取后台数据模块

- (void)loadData:(BOOL)refresh
{
    [cartItemGroup removeAllObjects];
    [cartService getCartList:YES] ;
}

- (void)loadResponse:(NSString *) url response:(BaseModel *)response{
    
    if([url isEqualToString:api_member_ismemberfirstorder]){
        SignalDataResponse * resobj = (SignalDataResponse *)response;
        
        if([AppStatic CART_ITEM_QUANTITIES] > 0){
            if (resobj.status.succeed) {
                if (![today isEqualToString:[[Config Instance] getUserInfo:closeDay1]]) {
                    
                    if(!self.firstOrderFreeHeader && resobj.data.price.length){
                        self.firstOrderFreeHeader = [[CartHeadView1 alloc] initWithFrame:CGRectMake(0, 0, self.cartTable.frame.size.width, 34)];
                        self.firstOrderFreeHeader.lblContent.text = resobj.data.price;
                        [self.view addSubview:self.firstOrderFreeHeader];
                        [self.firstOrderFreeHeader.btnClose addTarget:self action:@selector(closeTableHeader:) forControlEvents:UIControlEventTouchUpInside];
                        self.tableTop.constant = 34;
                    }
                    self.firstOrderFreeHeader.lblContent.text = resobj.data.price;
                }
             }
        }
    }
    
   else if ([url isEqualToString:api_order_build2]){
        OrderBuildResponse2 * orderBuildResponse = (OrderBuildResponse2 *)response;
       if (orderBuildResponse.status.succeed == 1){
        OrderController *orderController = [[OrderController alloc] initWithNibName:@"OrderController" bundle:nil];
       
        [orderController setOrderBuildResponse:orderBuildResponse];
        [self.navigationController pushViewController:orderController animated:YES];
       } else {
           [CommonUtils ToastNotification:orderBuildResponse.status.error_desc andView:self.view andLoading:NO andIsBottom:NO];
       }
    }
    else {
        CartResponse * respobj = (CartResponse *)response;
        
        cart = respobj.data;
        
        selectNum = 0;
        Boolean blnSelAll = YES;
        if ([url isEqual: api_cart_list] || [url isEqual: api_cart_updatemult] || [url isEqual: api_cart_item_delete] || [url isEqual:api_cart_update]){

            commonOfCartItems = YES;
            [cartItemGroup removeAllObjects];
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:20];
            
            for(AppCartItem* cartItem in cart.cartItems){
                
#pragma mark - 测试可分配库存
                NSMutableArray *merchantCartItems = [dict objectForKey:[NSString stringWithFormat:@"%d", cartItem.merchantId]];
                if (cartItem.promotion.id > 0) {
                    commonOfCartItems = NO;
                }
                if (merchantCartItems == nil){
                    merchantCartItems = [[NSMutableArray alloc] initWithCapacity:20];
                    
                    [dict setObject:merchantCartItems forKey:[NSString stringWithFormat:@"%d", cartItem.merchantId]];
                }
                [merchantCartItems addObject:cartItem];
                if (!cartItem.selected){
                    
                    blnSelAll = NO;
                }else {
                    selectNum += 1;
                }
            }
            // 升序排序
            NSMutableArray *stringArray = [NSMutableArray arrayWithArray:dict.allKeys];
            [stringArray sortUsingComparator: ^NSComparisonResult (NSString *str1, NSString *str2) {
                return [str1 compare:str2 options:NSNumericSearch];
            }];
            for (int i = 0; i < dict.count; i ++) {
                [cartItemGroup addObject:[dict objectForKey:stringArray[i]]];
            }
//          将同一个商家的最后一个商品打上标记
            for (int i=0 ;i <cartItemGroup.count; i++) {
                ((AppCartItem *)[cartItemGroup[i] lastObject]).isLast = YES;
            }
        }
        lbTotalAmount.text = [CommonUtils formatCurrency:cart.selectedTotal];
        
        self.cartTable.pullTableIsLoadingMore = NO;
        self.cartTable.pullTableIsRefreshing = NO;
        
        if (cartItemGroup.count == 0){
            self.tabBarController.tabBar.items[2].badgeValue = nil;
            [self displayNoResultViewLogin:YES];
            self.cartTable.hidden = YES;
            self.cartFooter.hidden = YES;
            self.firstOrderFreeHeader.hidden = YES;
//            self.fiveOrderFreeHeader.hidden = YES;
        } else {
            [self.cartTable reloadData];
            self.cartTable.hidden = NO;
            self.cartFooter.hidden = NO;
            self.noResultView.hidden = YES;
            self.firstOrderFreeHeader.hidden = NO;
//            self.fiveOrderFreeHeader.hidden = NO;
            
            [self setFooterValues];
        }
        
        btnSelAll.selected = blnSelAll;
        [self adjustTotalAmountPosition];
    }
}

//关闭头视图
- (void)closeTableHeader:(UIButton *)button{
    if (button == self.firstOrderFreeHeader.btnClose) {
        [self.firstOrderFreeHeader removeFromSuperview];
        self.firstOrderFreeHeader = nil;
        [[Config Instance] saveUserInfo:closeDay1 withvalue:today];
    }
    self.tableTop.constant = 0;
}

- (void)adjustTotalAmountPosition{
    float width = TMScreenW;
    CGSize size = [CommonUtils returnLabelSize:lbTotalAmount.text font:[UIFont systemFontOfSize:12]];

    self.lbTotalAmount.frame = CGRectMake(width - TMScreenW *86/320 - TMScreenW *(size.width)/320, 0, TMScreenW *(size.width)/320, 21);
    lbTotalWord.frame = CGRectMake(width - TMScreenW *86/320 -TMScreenW *(size.width)/320 - TMScreenW *30/320, 0, TMScreenW *30/320, 21);
}

- (void)initFooterView{
    float width = TMScreenW;
    
    int top = TMScreenH - 42;
    
    if (self.hasBottomBar){
        top = top - 44;
    }
    
    [self.cartFooter setBackgroundColor:[UIColor darkGrayColor]];
    if (!btnSelAll) {
        btnSelAll = [[UIButton alloc] initWithFrame:CGRectMake(5, 8, 25, 25)];
    }
    [btnSelAll setImage:[UIImage imageNamed:@"newcheckfalsedelete"] forState:UIControlStateNormal];
    [btnSelAll setImage:[UIImage imageNamed:@"newchecktrue"] forState:UIControlStateSelected];
    [btnSelAll addTarget:self action:@selector(clickSelectAll:) forControlEvents:UIControlEventTouchUpInside];
    [self.cartFooter addSubview:btnSelAll];
    
    if (!btnSelAllWord) {
        btnSelAllWord = [[UIButton alloc] initWithFrame:CGRectMake(35, 10, TMScreenW *35/320, 21)];
    }
    // 全选
    NSString *cartVC_btnSelAllWord_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"cartVC_btnSelAllWord_title"];
    [btnSelAllWord setTitle:cartVC_btnSelAllWord_title forState:UIControlStateNormal];
//    [btnSelAllWord setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [btnSelAllWord setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnSelAllWord.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [btnSelAllWord addTarget:self action:@selector(clickSelectAll:) forControlEvents:UIControlEventTouchUpInside];
    [self.cartFooter addSubview:btnSelAllWord];
    
    if (!btnDelAllWord) {
        btnDelAllWord = [[UIButton alloc] initWithFrame:CGRectMake(TMScreenW *35/320 + 40, 10, TMScreenW *40/320, 21)];
    }
    // 删除
    NSString *cartVC_btnDelAllWord_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"cartVC_btnDelAllWord_title"];
    [btnDelAllWord setTitle:cartVC_btnDelAllWord_title forState:UIControlStateNormal];
//    [btnDelAllWord setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [btnDelAllWord setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnDelAllWord.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [btnDelAllWord addTarget:self action:@selector(clickDeleteAll:) forControlEvents:UIControlEventTouchUpInside];
    [self.cartFooter addSubview:btnDelAllWord];
    
    if (!labelNotIncludeFreight) {
        labelNotIncludeFreight = [[UILabel alloc] initWithFrame:CGRectMake(width - TMScreenW *150/320, 18, TMScreenW *80/320, 21)];
    }
    [labelNotIncludeFreight setFont:[UIFont systemFontOfSize:12]];
    labelNotIncludeFreight.textColor = [UIColor whiteColor];
    // 不包含运费
    NSString *cartVC_labelNotIncludeFreight_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"cartVC_labelNotIncludeFreight_title"];
    [labelNotIncludeFreight setText:cartVC_labelNotIncludeFreight_title];
    [self.cartFooter addSubview:labelNotIncludeFreight];
    
    NSString *amount = @"";
    CGSize size = [amount sizeWithFont:[UIFont systemFontOfSize:12]];
    if (!self.lbTotalAmount) {
        self.lbTotalAmount = [[UILabel alloc] initWithFrame:CGRectMake(width - TMScreenW *86/320 - TMScreenW *(size.width)/320, 0, TMScreenW *(size.width)/320, 21)];
    }
    [self.lbTotalAmount setFont:[UIFont systemFontOfSize:12]];
//    [self.lbTotalAmount setTextColor:TMRedColor];
    [self.lbTotalAmount setTextColor:[UIColor whiteColor]];

    self.lbTotalAmount.text = amount;
    [self.cartFooter addSubview:self.lbTotalAmount];
    
    if (!lbTotalWord) {
        lbTotalWord = [[UILabel alloc] initWithFrame:CGRectMake(width - TMScreenW *86/320 -TMScreenW *(size.width)/320 - TMScreenW *30/320, 0, TMScreenW *30/320, 21)];
    }
    // 合计:
    NSString *cartVC_lbTotalWord_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"cartVC_lbTotalWord_title"];
    lbTotalWord.text = cartVC_lbTotalWord_title;
    [lbTotalWord setFont:[UIFont systemFontOfSize:12]];
    [lbTotalWord setTextColor:[UIColor whiteColor]];
    [self.cartFooter addSubview:lbTotalWord];
    
    if (!btnSett) {
        btnSett = [[UIButton alloc] initWithFrame:CGRectMake(width - TMScreenW *80/320, 0, TMScreenW *80/320, 42)];
    }
    // 结算(0)
    NSString *cartVC_btnSett_titleZero = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"cartVC_btnSett_titleZero"];
    [btnSett setTitle: cartVC_btnSett_titleZero forState:UIControlStateNormal];
    [btnSett setBackgroundColor:redColorSelf];
    [btnSett setTintColor:[UIColor whiteColor]];
    btnSett.titleLabel.font = [UIFont systemFontOfSize:17];
    [btnSett addTarget:self action:@selector(clickSettle:) forControlEvents:UIControlEventTouchUpInside];
    [self.cartFooter addSubview:btnSett];
    
    self.cartFooter.hidden = YES;
}


- (void)setFooterValues{
    float width = TMScreenW;
    //float top = self.cartTable.frame.size.height;
    int top = TMScreenH - 42;
    if (self.hasBottomBar){
        top = top - 44;
    }
    NSString *amount = [CommonUtils formatCurrency:cart.selectedTotal];
    CGSize size = [amount sizeWithFont:[UIFont systemFontOfSize:12]];
    self.lbTotalAmount.frame = CGRectMake(width - TMScreenW *86/320 - TMScreenW *(size.width)/320, 0, TMScreenW *(size.width)/320, 21);
    self.lbTotalAmount.text = amount;
    lbTotalWord.frame = CGRectMake(width - TMScreenW *86/320 -TMScreenW *(size.width)/320 - TMScreenW *30/320, 0, TMScreenW *30/320, 21);
    
    // 合计:
    NSString *cartVC_lbTotalWord_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"cartVC_lbTotalWord_title"];
    // 结算(%d)
    NSString *cartVC_btnSett_titleData = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"cartVC_btnSett_titleData"];
    // 结算(...)
    NSString *cartVC_btnSett_titleMax = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"cartVC_btnSett_titleMax"];
    lbTotalWord.text = cartVC_lbTotalWord_title;
    if (selectNum < 100) {
        
        [btnSett setTitle: [NSString stringWithFormat:cartVC_btnSett_titleData, selectNum] forState:UIControlStateNormal];
    }else {
        [btnSett setTitle: cartVC_btnSett_titleMax forState:UIControlStateNormal];
    }
}

- (void)displayNoResultViewLogin:(BOOL)login{
    if (!noResultView){
        float imageX = TMScreenW / 2 - TMScreenW *55/375;
        float imageY = TMScreenH *105/667;
        float wordX = imageX - TMScreenW *45/375;
        float wordY = imageY + TMScreenW *110/375 + TMScreenH *30/667;
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, imageY, TMScreenW *110/375, TMScreenW *110/375)];
        image.image = [UIImage imageNamed:@"购物车空"];

        UILabel *word = [[UILabel alloc] initWithFrame:CGRectMake(wordX, wordY, TMScreenW *200/375, TMScreenH *40/667)];
        word.textAlignment = NSTextAlignmentCenter;
        word.font = [UIFont systemFontWithSize:15.0];
        word.textColor = [UIColor darkGrayColor];
        // @"购物车还没有商品"
        NSString *cartVC_noResultView_desc = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"cartVC_noResultView_desc"];
        [word setText:cartVC_noResultView_desc];
        
        self.noResultView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TMScreenW, TMScreenH)];
        self.noResultView.backgroundColor = groupTableViewBackgroundColorSelf;
        [self.noResultView addSubview:word];
        [self.noResultView addSubview:image];
        [self.view addSubview:self.noResultView];
    } else {
        noResultView.hidden = NO;
    }
}

- (void) selectMerchant:(NSInteger)section selected:(Boolean) selected{
    NSMutableArray *cartItems = [cartItemGroup objectAtIndex:section];
    NSMutableArray *cartItemIds = [[NSMutableArray alloc] init];
    for (AppCartItem *cartItem in cartItems){
        [cartItemIds addObject:[NSString stringWithFormat:@"%d", cartItem.id]];
    }
    [cartService updateMultiplyCartItem:cartItemIds selected:selected];
}

- (void) selectCartItem:(NSIndexPath *) indexPath quantity:(int) quantity selected:(Boolean)selected{
    NSMutableArray *cartItems = [cartItemGroup objectAtIndex:indexPath.section];
    AppCartItem *cartItem = [cartItems objectAtIndex:indexPath.row];
    cartItem.quantity = quantity;
    cartItem.selected = selected;
    [cartService updateCartItem:cartItem.id quantity:quantity selected:selected];
}

- (IBAction)clickSelectAll:(UIButton *)sender {
    btnSelAll.selected = !btnSelAll.selected;
    NSMutableArray *cartItemIds = [[NSMutableArray alloc] init];
    for (NSMutableArray *cartItems in cartItemGroup){
        for (AppCartItem *cartItem in cartItems){
            [cartItemIds addObject:[NSString stringWithFormat:@"%d", cartItem.id]];
        }
    }
    [cartService updateMultiplyCartItem:cartItemIds selected:btnSelAll.selected];
}

-(void)clickDeleteAll:(UIButton *)sender{
//    btnSelAll.selected = !btnSelAll.selected;
    deleteCartItemIds = [[NSMutableArray alloc] init];
    [deleteCartItemIds removeAllObjects];
    for (NSMutableArray *cartItems in cartItemGroup){
        for (AppCartItem *cartItem in cartItems){
            if (cartItem.selected == YES) {
                [deleteCartItemIds addObject:[NSString stringWithFormat:@"%d", cartItem.id]];
            }
        }
    }
    // @"确定删除选中商品？"
    NSString *cartVC_deleteAlert_chooseMsg = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"cartVC_deleteAlert_chooseMsg"];
    // @"请选择要删除的商品"
    NSString *cartVC_toastNotification_msg1 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"cartVC_toastNotification_msg1"];
    if (deleteCartItemIds.count > 0) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:cartVC_deleteAlert_chooseMsg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }else{
        [CommonUtils ToastNotification:cartVC_toastNotification_msg1 andView:self.view andLoading:NO andIsBottom:NO];
    }

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [cartService deleteCartItem:deleteCartItemIds];
    }
}

-(IBAction)clickSettle:(id)sender{
    NSArray *cartItems = cart.cartItems;
    Boolean hascartItemSel= false;
    for (AppCartItem *cartItem in cartItems){
        if (cartItem.selected){
            hascartItemSel = true;
            break;
        }
    }
    if (!hascartItemSel){
        // @"请选择商品"
        NSString *cartVC_toastNotification_msg2 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"cartVC_toastNotification_msg2"];
        [CommonUtils ToastNotification:cartVC_toastNotification_msg2 andView:self.view andLoading:NO andIsBottom:NO];
        return;
    }
    if (![CommonUtils chkLogin:self gotoLoginScreen:YES]){
        return;
    }
    [orderService buildOrder2:false];
}
#pragma TableView的处理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return cartItemGroup.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *array = [cartItemGroup objectAtIndex:section];
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    CartItemHeader *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"CartItemHeader"];
    
    if (cartItemGroup.count > section) {
        
        NSMutableArray *merchantGroup = [cartItemGroup objectAtIndex:section];
        if (headerView == nil)
        {
            NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"CartItemHeader" owner:self options:nil];
            for (NSObject *o in objects) {
                if ([o isKindOfClass:[CartItemHeader class]]) {
                    headerView = (CartItemHeader *)o;
                    [headerView myinit];
                    headerView.headDelegate = self;
                    break;
                }
            }
        }
        [headerView.merchantName setTitle: ((AppCartItem*)[merchantGroup objectAtIndex:0]).product.shopName forState:UIControlStateNormal];
        Boolean allSelected = YES;
        for (AppCartItem *cartItem in merchantGroup){
            if (!cartItem.selected){
                allSelected = NO;
                break;
            }
        }
        headerView.section = section;
        headerView.merchantChk.selected = allSelected;
        
    }
    
    return headerView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CartCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CartCell"];
    if (!cell) {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"CartCell" owner:self options:nil];
        for (NSObject *o in objects) {
            if ([o isKindOfClass:[CartCell class]]) {
                cell = (CartCell *)o;
                [cell myinit];
                cell.cartDelegate = self;
                cell.userInteractionEnabled = YES;
                cell.contentView.userInteractionEnabled = YES;
                break;
            }
        }
    }
    /*cell获取当前视图View*/
    [cell initParentView:self.cartTable];
    
    if (cartItemGroup.count>indexPath.section) {
        
        NSMutableArray *cartItems = [cartItemGroup objectAtIndex:indexPath.section];
        
        AppCartItem * item = [cartItems lastObject];
        item.isLast = YES;
        AppCartItem * firstItem = [cartItems firstObject];
        firstItem.isFirst = YES;
        promotionType = firstItem.promotion.title;
        //
        for (int i=1; i<cartItems.count; i++) {
            AppCartItem * item = [cartItems objectAtIndex:(i-1)];
            AppCartItem * nextItem = [cartItems objectAtIndex:i];
            
            if (![nextItem.promotion.title isEqualToString:promotionType]) {
                item.isLast = YES;
                nextItem.isFirst = YES;
                promotionType = nextItem.promotion.title;
            }
        }
        
        
        AppCartItem *cartItem =[cartItems objectAtIndex:[indexPath row]];
        
        //如果是第一个就加上标题，相同活动的不加标题
        if (cartItem.isFirst == YES) {
            //如果是普通商品就隐藏红色的满减
            if (cartItem.promotion.id < 0 && commonOfCartItems == NO) {
                CartPromotionTitleView * promotionTitleView = [[CartPromotionTitleView alloc] initWithFrame:CGRectMake(0, 0, kWidth, heightOfPromotionTitleView) hasPromotion:NO title:cartItem.promotion.title type:cartItem.promotion.promotionModeName];
                promotionTitleView.image.hidden = YES;
                [cell.contentView addSubview:promotionTitleView];
            }
            
            if (cartItem.promotion.id > 0) {
                // @",点击查看"
                NSString *cartVC_promotionTitleView_clickpromotionMsg = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"cartVC_promotionTitleView_clickpromotionMsg"];
                //        如果不是普通商品，就显示红色的满减,并且可以点击到促销详情页
                CartPromotionTitleView * promotionTitleView = [[CartPromotionTitleView alloc] initWithFrame:CGRectMake(0, 0, kWidth, heightOfPromotionTitleView) hasPromotion:YES title:[cartItem.promotion.titleOnCart stringByAppendingString:cartVC_promotionTitleView_clickpromotionMsg]  type:cartItem.promotion.promotionModeName];
                //增加点击事件
                promotionTitleView.btnClickToPromotion.tag = cartItem.promotion.id;
                [promotionTitleView.btnClickToPromotion addTarget:self action:@selector(clickOnCartPromotionTitleView:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:promotionTitleView];
                
            }
            //      如果都是普通商品不显示 “普通商品”
            if (commonOfCartItems == NO) {
                
                cell.commonContentTopLayout.constant = heightOfPromotionTitleView;
            }
        }
        //    不是第一个cell
        else{
            
            cell.commonContentTopLayout.constant = 2;
        }
        
        //    如果有赠送礼品，就将礼品视图加上去cartItem.giftItems.count
        if (cartItem.giftItems.count > 0)
        {
            int count = (int)cartItem.giftItems.count;
            for (int i=0; i<count; i++)
            {
                AppGiftItem * giftItem = cartItem.giftItems[i];
                
                CGRect frame;
                if (!cartItem.isFirst) {
                    
                    frame = CGRectMake(0, TMScreenH *77/568 +12 + i*heightOfOneGiftView, kWidth, heightOfOneGiftView);
                } else {
                    frame = CGRectMake(0, TMScreenH *77/568 +10 + heightOfPromotionTitleView + i*heightOfOneGiftView, kWidth, heightOfOneGiftView);
                }
                
                GiftView * giftView = [[GiftView alloc] initWithFrame:frame giftImage:giftItem.gift.image giftName:giftItem.gift.name giftSpec:giftItem.gift.specificationName giftPrice:giftItem.gift.price giftAmount:giftItem.quantity meetDemands:cartItem.cartItemAccessory.accessoryHtml];
                
                [cell.contentView addSubview:giftView];
            }
            //      重新给cell的高度赋值
            cell.commonContentBottomLayout.constant = count*heightOfOneGiftView;
        }
        
        //   如果有折扣商品，就将折扣视图加上去cartItem.cartItemAccessory
        //    if(cartItem.cartItemAccessory){
        //
        //        CGRect frame;
        //        if (!cartItem.isFirst) {
        //
        //            frame = CGRectMake(0, TMScreenH *77/568 +12 + cell.commonContentBottomLayout.constant, kWidth, heightOfDiscountView);
        //        } else {
        //            frame = CGRectMake(0, TMScreenH *77/568 +10 + heightOfPromotionTitleView + cell.commonContentBottomLayout.constant, kWidth, heightOfDiscountView);
        //        }
        //
        //        CartPromotionDiscountView * discountView = [[CartPromotionDiscountView alloc] initWithFrame:frame promotionDesc:cartItem.cartItemAccessory.accessoryHtml discountMoney:cartItem.cartItemAccessory.discAmount];
        //
        //        [cell.contentView addSubview:discountView];
        //        //          重新给cell的高度赋值
        //        cell.commonContentBottomLayout.constant += heightOfDiscountView;
        //    }
        
        
        if (cartItem.isLast && ([cartItem.promotion.cartDiscountAmount doubleValue] > 0
                                || [cartItem.cartDiscountAmount doubleValue] > 0)) {
            UIView *lblIdscountView = [[UIView alloc] init];
            
            lblIdscountView.backgroundColor = [UIColor colorWithRed:253/255.0 green:240/255.0  blue:213/255.0  alpha:1];
            
            UILabel * lblDiscount = [[UILabel alloc] init];
            
            // @"已满足优惠条件, 优惠%@元"
            NSString *cartVC_lblDiscount_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"cartVC_lblDiscount_title"];
            if ([cartItem.cartDiscountAmount doubleValue] > 0){
                lblDiscount.text = [NSString stringWithFormat:cartVC_lblDiscount_title,[CommonUtils formatCurrency:cartItem.cartDiscountAmount]];
            } else {
                lblDiscount.text = [NSString stringWithFormat:cartVC_lblDiscount_title,[CommonUtils formatCurrency:cartItem.promotion.cartDiscountAmount]];
            }
            lblDiscount.textColor = TMRedColor;
            lblDiscount.font = [UIFont systemFontOfSize:13];
            //        lblDiscount.backgroundColor = [UIColor colorWithRed:253/255.0 green:240/255.0  blue:213/255.0  alpha:1];
            if (!cartItem.isFirst) {
                
                lblIdscountView.frame = CGRectMake(0, TMScreenH *77/568 +12 + cell.commonContentBottomLayout.constant, kWidth, heightOfPromotionTitleView);
            } else {
                lblIdscountView.frame = CGRectMake(0, TMScreenH *77/568 +10 + heightOfPromotionTitleView + cell.commonContentBottomLayout.constant, kWidth, heightOfPromotionTitleView);
            }
            lblDiscount.frame = CGRectMake(35, 0, lblIdscountView.frame.size.width, lblIdscountView.frame.size.height);
            [lblIdscountView addSubview:lblDiscount];
            [cell.contentView addSubview:lblIdscountView];
            //          重新给cell的高度赋值
            cell.commonContentBottomLayout.constant += heightOfPromotionTitleView;
        }
        
        
        cell.prodname.text = cartItem.product.name;
        //    如果有
        //    cartItem.delPrice = [NSNumber numberWithInt:100]; //测试
        if (cartItem.delPrice) {
            cell.prodSpec.text = [CommonUtils formatCurrency:cartItem.displayPrice];
            
            cell.price.textColor = [UIColor colorWithRed:175/255.0 green:175/255.0 blue:175/255.0 alpha:1];
            cell.price.font = [UIFont systemFontOfSize:10];
            cell.price.attributedText = [CommonUtils addDeleteLineOnLabel:[CommonUtils formatCurrency:cartItem.delPrice]];
            
        }else{
            cell.price.text = [CommonUtils formatCurrency:cartItem.displayPrice];
            
        }
        cell.image.placeholderImage = [UIImage imageNamed:@"index_defImage"];
        cell.image.imageURL = [URLUtils createURL:cartItem.product.image];
        
        if (cartItem.product.specificationName) {
            cell.lblProdSpecName.text = [NSString stringWithFormat:@"%@",cartItem.product.specificationName];
        }
        
        cell.btnChk.selected = cartItem.selected;
        cell.quantity.text = [NSString stringWithFormat:@"%d", cartItem.quantity];
        cell.indexPath = indexPath;
//        cell.tap = indexPath;
        cell.quantity.delegate = self;
        
        cell.cartItem = cartItem;
        
#pragma mark - 自定义删除按钮
        // 删除
//        NSString *cartVC_deleteView_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"cartVC_deleteView_title"];
//        //    NSLog(@"cell.frame.size.height  %f",cell.frame.size.height);
//        DeleteView *deleteView = [[[NSBundle mainBundle] loadNibNamed:@"DeleteView" owner:self options:nil] lastObject];
//        
//        if (cell.frame.size.height < 120) {
//            deleteView.frame = CGRectMake(TMScreenW, 0, TMScreenW, cell.frame.size.height);
//        }
//        else if (120 < cell.frame.size.height && cell.frame.size.height < 120+heightOfPromotionTitleView){
//            deleteView.frame = CGRectMake(TMScreenW, 0, TMScreenW, cell.frame.size.height-heightOfPromotionTitleView);
//        }
//        else {
//            deleteView.frame = CGRectMake(TMScreenW, 0, TMScreenW, cell.frame.size.height-2*heightOfPromotionTitleView);
//        }
//        //    NSLog(@"deleteView.frame.size.height  %f", deleteView.frame.size.height);
//        deleteView.contentLabel.text = cartVC_deleteView_title;
//        [cell.contentView addSubview:deleteView];
        
        [self.view setNeedsUpdateConstraints];
        
    }
    
    return cell;
}

//促销标题点击的方法
- (void)clickOnCartPromotionTitleView:(UIButton *)button{
    ProdList * vc = [[ProdList alloc] initWithNibName:@"ProdList" bundle:nil];
    vc.promotionId = (int)button.tag;
    [self.navigationController pushViewController:vc animated:YES];
}

// became first responder
- (void)textFieldDidBeginEditing:(UITextField *)textField {

    [self keyboardShow];
}

//return按钮
- (BOOL)textFieldShouldReturn:(UITextField *)textField{

//  向服务器传送商品个数
    [self textFieldDidEndEditing:textField];
    return YES;
}

//结束编辑 - 点击右上完成按钮响应的是此事件
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    [textField resignFirstResponder];
    [self keyboardHide];
//    向服务器传送商品个数
    //获取改变了的textfield对应的NSIndexPath
    //获取到对应的NSIndexPath就可以设置对应的数据源了
    CGPoint point = [textField.superview convertPoint:textField.frame.origin toView:self.cartTable];
    NSIndexPath *indexPath = [self.cartTable indexPathForRowAtPoint:point];
    NSMutableArray *cartItems = [cartItemGroup objectAtIndex:indexPath.section];
    AppCartItem *cartItem =[cartItems objectAtIndex:[indexPath row]];

    NSLog(@"availableStock - %@", cartItem.product.availableStock);
    
    [self selectCartItem:indexPath quantity:[textField.text intValue] selected:cartItem.selected];
    if ([textField.text intValue] > [cartItem.product.availableStock intValue] && cartItem.product.availableStock) {
        
        textField.text = [NSString stringWithFormat:@"%@", cartItem.product.availableStock];
        [self selectCartItem:indexPath quantity:[textField.text intValue] selected:cartItem.selected];
    }
    else if ([textField.text intValue] < 1) {
    
        [self selectCartItem:indexPath quantity:1 selected:cartItem.selected];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *cartItems = [cartItemGroup objectAtIndex:indexPath.section];
    AppCartItem *cartItem = [cartItems objectAtIndex:indexPath.row];
    ProductInfoViewController *prodInfo = [[ProductInfoViewController alloc] init];
    prodInfo.productId = cartItem.product.id;
    [self.navigationController pushViewController:prodInfo animated:YES];

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        deleteIndexPath = indexPath;
//        
//        NSMutableArray *cartItems = [cartItemGroup objectAtIndex:indexPath.section];
//        AppCartItem *cartItem =[cartItems objectAtIndex:[indexPath row]];
//        
//        NSMutableArray *itemIds = [[NSMutableArray alloc] initWithObjects:[NSString stringWithFormat:@"%d", cartItem.id], nil];
//        [cartService deleteCartItem:itemIds];
//        
//    }
//    else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
//    }
//}

//- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return @"删除";
//}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleNormal) title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        deleteIndexPath = indexPath;
        
        NSMutableArray *cartItems = [cartItemGroup objectAtIndex:indexPath.section];
        AppCartItem *cartItem =[cartItems objectAtIndex:[indexPath row]];
        
        NSMutableArray *itemIds = [[NSMutableArray alloc] initWithObjects:[NSString stringWithFormat:@"%d", cartItem.id], nil];
        [cartService deleteCartItem:itemIds];
        
    }];
    deleteAction.backgroundColor = [UIColor redColor];
    return @[deleteAction];
}



- (void)keyboardShow {
    
//    在弹出键盘的通知方法里面我们添加一个背景我淡黑的透明view，然后在view上面加上一个手势
    
    self.keyView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    self.keyView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
    
    [self.view addSubview:self.keyView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(action_sendTap)];
    
    tap.delegate = self;
    
    [self.keyView addGestureRecognizer:tap];
}

- (void)keyboardHide {
    
    //    移除这个view
    [self.keyView removeFromSuperview];
}

//实现手势方法

- (void)action_sendTap{
    
    for (UIView *view in self.view.subviews) {
        
        [view endEditing:YES];
    }
}


#pragma mark - Refresh and load more methods

- (void) refreshTable
{
    [self loadData:YES];
    [cartService getIsFreeInfoOfFirstOrder];
    self.cartTable.pullLastRefreshDate = [NSDate date];
    
}

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    [self performSelector:@selector(refreshTable) withObject:nil afterDelay:0.2f];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    
}



@end
        
