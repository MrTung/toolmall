//
//  ProdList.m
//  toolmall
//
//  Created by mc on 15/10/24.
//
//

#import "ProdList.h"

#import "PYSearch.h"

@interface ProdList ()<ProdHotKeySearchDelegate,PYSearchViewControllerDelegate>
{
    UISearchBar *searchBar;
    NSMutableArray * products;
    NSString *displayType;
    ProductService *productService;
    SearchService *searchService;
    CartService *cartService;
    Pagination * pagination;
    NSArray *attributes;
    UIScrollView *attrOptionsView;
    int curSelectedAttrIndex;
    UIView *masker;
    NSMutableArray *attrButtons;
    NSMutableDictionary *requestAttributes;
    Boolean attrOptionDisplayed;
    
    NSString * UUID;
    SESSION * session;
    Boolean isBuyAtOnce;
    __weak __typeof(PYSearchViewController*)weakVC;

}

@property UIButton * searchBtn;

@property (nonatomic, strong) NSMutableArray * hotArray;

@end

@implementation ProdList

@synthesize orderType;
@synthesize productCategoryId;
@synthesize tableProducts;
@synthesize topView;
@synthesize isSearch;
@synthesize searchKeyWord;
@synthesize oldSearchKeyWord;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [super addNavBackButton];
    [self addThreedotButtonself];
    self.view.backgroundColor = groupTableViewBackgroundColorSelf;
    curSelectedAttrIndex = -1;
    attrButtons = [[NSMutableArray alloc] initWithCapacity:10];
    requestAttributes = [[NSMutableDictionary alloc] initWithCapacity:10];
    displayType = @"list";
    [self setExtraCellLineHidden];
    
    _searchBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _searchBtn.frame = CGRectMake(0, 0, TMScreenW *220/320,30);
    //    _searchBtn.backgroundColor = [UIColor yellowColor];
    _searchBtn.titleLabel.textColor = [UIColor lightGrayColor];
    _searchBtn.layer.masksToBounds = YES;
    _searchBtn.layer.cornerRadius = 5;
    _searchBtn.layer.borderColor = [UIColor colorWithRed:209/255.0 green:209/255.0 blue:209/255.0 alpha:1].CGColor;
    _searchBtn.layer.borderWidth = 0.5;
    // @"请输入产品名称"
    NSString *prodList_searchBtn_plaTitle = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"prodList_searchBtn_plaTitle"];
    [_searchBtn setTitle:prodList_searchBtn_plaTitle forState:(UIControlStateNormal)];
    [_searchBtn setTitleColor:lightGrayColorSelf forState:(UIControlStateNormal)];
    _searchBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _searchBtn.contentEdgeInsets = UIEdgeInsetsMake(0, TMScreenW *30/320, 0, 0);
    //    [_searchBtn setFont:[UIFont systemFontOfSize:12]];
    _searchBtn.titleLabel.font = [UIFont systemFontWithSize:12.0];
    
    [_searchBtn addTarget:self action:@selector(pushToSearchPage:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.titleView = _searchBtn;
    
    
#pragma 需要更改图片的地方
    CGFloat textFH = CGRectGetHeight(_searchBtn.frame);
    UIButton * btnSearch = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSearch.frame = CGRectMake(0, 0, textFH, textFH);
    [btnSearch setImage:[UIImage imageNamed:@"搜索"] forState:UIControlStateNormal];
    [btnSearch addTarget:self action:@selector(pushToSearchPage:) forControlEvents:UIControlEventTouchUpInside];
    [_searchBtn addSubview:btnSearch];
    
    if (searchKeyWord) {
        [_searchBtn setTitle:searchKeyWord forState:(UIControlStateNormal)];
    }

    searchService = [[SearchService alloc] initWithDelegate:self parentView:self.view];
    cartService = [[CartService alloc] initWithDelegate:self parentView:self.view];
    productService = [[ProductService alloc] initWithDelegate:self parentView:self.view];

    pagination = [[Pagination alloc] init];
    pagination.count = 20;
    products = [[NSMutableArray alloc]initWithCapacity:20];
    self.orderType = @"topDesc";
    [self loadData:YES];
}

- (void)addThreedotButtonself{
 
     UIButton * right = [UIButton buttonWithType:UIButtonTypeCustom];
     right.frame = CGRectMake(0, 0, 40, 40);
//         right.backgroundColor = [UIColor  cyanColor];
     [right setImage:[UIImage imageNamed:@"threedot.png"] forState:UIControlStateNormal];
     [right setImage:[UIImage imageNamed:@"threedot.png"] forState:UIControlStateHighlighted];
     [right addTarget:self action:@selector(threedotButtonClick:) forControlEvents:UIControlEventTouchUpInside];
     UIBarButtonItem * threedotButtonItem =[[UIBarButtonItem alloc]initWithCustomView:right];
     NSArray<UIBarButtonItem *> *barButtonItems;
     if (self.navigationItem.rightBarButtonItem){
     barButtonItems = [[NSArray alloc] initWithObjects:threedotButtonItem, self.navigationItem.rightBarButtonItem  , nil];
     self.navigationItem.rightBarButtonItem = nil;
     } else {
     barButtonItems = [[NSArray alloc] initWithObjects:threedotButtonItem , nil];
     }
     self.navigationItem.rightBarButtonItems =barButtonItems;
}
 

/**
 前往搜索界面
 @param button
 */
- (void)searchButtonClicked:(UIButton *)button{
    ProdHotKeySearchViewController * hotkey = [[ProdHotKeySearchViewController alloc] initWithNibName:@"ProdHotKeySearchViewController" bundle:nil];
    hotkey.hidesBottomBarWhenPushed = YES;
    hotkey.hotKeyDelegate = self;
    [self.navigationController pushViewController:hotkey animated:YES];
}

- (void)changeTheTextOfTextFiled:(NSString *)string{
    searchKeyWord = string;
    isSearch = YES;
    [_searchBtn setTitle:string forState:(UIControlStateNormal)];
    [self loadData:YES];
}

-(void)setExtraCellLineHidden
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.tableProducts setTableFooterView:view];
}

- (void) loadData:(BOOL)refresh
{
    if (refresh){
        pagination.count = 20;
        pagination.page = 1;
        [products removeAllObjects];
    }
    [self getSearchRequest];
    if (isSearch){
        [searchService getProductSearchResult:searchKeyWord orderType:orderType pagination:pagination];
    } else {
        [productService getProductList:_brandId activityId:self.activityId productCategoryId:productCategoryId promotionId:_promotionId tagId:_tagId attributes:requestAttributes orderType:orderType pagination:pagination couponId:_couponId];
    }
}
- (void)loadResponse:(NSString *) url response:(BaseModel *)response{
    
    if ([url isEqual:api_product_list] || [url isEqualToString:api_product_search_list]){
        
        // 二次搜索滚动至顶部
        if (![oldSearchKeyWord isEqualToString:searchKeyWord] && isSearch) {
            
            //        NSLog(@"\n\n  oldSearchKeyWord:%@ - change - searchKeyWord:%@  \n\n", oldSearchKeyWord, searchKeyWord);
            [tableProducts setContentOffset:CGPointMake(0,0) animated:NO];
        }
        oldSearchKeyWord = searchKeyWord;
        
        ProductListResponse * respobj = (ProductListResponse *)response;
        [products addObjectsFromArray:respobj.data];
        if (respobj.paginated.more > 0){
//            [self.tableProducts setHasLoadingMore:YES];
            
//            [self loadMoreDataToTable];
            _hasMoreData = YES;
        } else {
            [self.tableProducts setHasLoadingMore:NO];
            _hasMoreData = NO;
        }
        if (!attrOptionDisplayed || isSearch){
            attributes = respobj.attributes;
            if (respobj.attributes.count > 0){
                self.attrFilterView.hidden = NO;
                self.tableTopConstraint.constant = 69;
                [self displayAttrFilters:respobj.attributes];
            } else {
                self.attrFilterView.hidden = YES;
                self.tableTopConstraint.constant = 34;
                [attrButtons removeAllObjects];
            }
            attrOptionDisplayed=true;
        }
        if (products.count == 0){
            self.tableProducts.hidden = YES;
            self.line2.hidden = YES;
            // @"没有搜索结果"
            NSString *prodList_noResultView_desc = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"prodList_noResultView_desc"];
            [CommonUtils displayCollectionNoResultView:self.view frame:self.tableProducts.frame desc:prodList_noResultView_desc];

            NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
            [center addObserver:self selector:@selector(jumpToIndexPage) name:TMPop2IndexNotificationName object:nil];
            
        } else {
            [CommonUtils removeNoResultView:self.view];
            
            self.tableProducts.hidden = NO;
            self.line2.hidden = NO;
            [tableProducts reloadData];
        }
        
        self.tableProducts.pullTableIsLoadingMore = NO;
        self.tableProducts.pullTableIsRefreshing = NO;
    
    } else if ([url isEqual:api_cart_item_add]){
        // @"已加入购物车"
        NSString *prodList_toastNotification_msg1 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"prodList_toastNotification_msg1"];
        [CommonUtils ToastNotification:prodList_toastNotification_msg1 andView:self.view andLoading:NO andIsBottom:YES];
    }
    else if ([url isEqualToString:api_hotsearchkeylist]) {
        
        _hotArray = [[NSMutableArray alloc] init];
        [_hotArray removeAllObjects];
        
        HotSearchKeyListResponse * resobj = (HotSearchKeyListResponse *)response;
        [_hotArray addObjectsFromArray:resobj.data];
        
        if (pagination.page > 1) {
            NSMutableArray<NSString *> *hotSeaches = [[NSMutableArray alloc] init];
            for (NSString *str in _hotArray) {
                [hotSeaches addObject:str];
            }
            weakVC.hotSearches = hotSeaches;
            [weakVC.tableView reloadData];
        }
        
    }
}

- (void)jumpToIndexPage{
    
    self.tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)displayAttrFilters:(NSArray *)attributes{
    for (UIView *view in [self.attrFilterView subviews]){
        [view removeFromSuperview];
    }
    float width = TMScreenW / 4 - 16;
    for (int i=0; i<attributes.count; i++){
        AppAttribute *attribute = [attributes objectAtIndex:i];
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((width + 8) * i + 8, 4, width, 26)];
        [button setBackgroundColor:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0f]];
        button.tag = i;
        button.layer.cornerRadius = 6;
        [button setTitle:attribute.name forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontWithSize:12]];
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickAttrFilter:) forControlEvents:UIControlEventTouchUpInside];
        [self.attrFilterView addSubview:button];
        [attrButtons addObject:button];
    }
}

- (IBAction)clickAttrFilter:(UIButton*)sender{
    AppAttribute *attribute = [attributes objectAtIndex:sender.tag];
    if (masker == nil){
        masker = [[UIView alloc] initWithFrame:CGRectMake(0, 70, self.view.frame.size.width, self.view.frame.size.height)];
        [masker setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6f]];
        [self.view addSubview:masker];
        masker.layer.zPosition = 4;
        self.topView.layer.zPosition = 5;
    }
    NSString *attributeId = [[NSString alloc] initWithFormat:@"%d" , attribute.id];
    NSString *key = [@"attribute_" stringByAppendingString:attributeId];
    if (curSelectedAttrIndex == sender.tag){
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3f];
        attrOptionsView.frame = CGRectMake(0, 70, self.view.frame.size.width, 1);
        [UIView commitAnimations];
        masker.hidden = YES;
        UIButton *button = [attrButtons objectAtIndex:sender.tag];
        [button setTitle:attribute.name forState:UIControlStateNormal];
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [attrOptionsView removeFromSuperview];
        curSelectedAttrIndex = -1;
    }
    else if ([requestAttributes objectForKey:key] != nil){
        masker.hidden = YES;
        [requestAttributes removeObjectForKey:key];
        UIButton *button = [attrButtons objectAtIndex:sender.tag];
        [button setTitle:attribute.name forState:UIControlStateNormal];
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self loadData:YES];
    } else {
        masker.hidden = NO;
        curSelectedAttrIndex = sender.tag;
        [self displayAttrOptions:attribute];
    }
}

- (void)displayAttrOptions:(AppAttribute*)attribute{
    for (int i=0; i < attrButtons.count; i++){
        UIButton *button = [attrButtons objectAtIndex:i];
        AppAttribute *attr = [attributes objectAtIndex:i];
        NSString *attributeId = [[NSString alloc] initWithFormat:@"%d" , attr.id];
        NSString *key = [@"attribute_" stringByAppendingString:attributeId];
        if (i == curSelectedAttrIndex || [requestAttributes objectForKey:key] != nil){
            [button setTitleColor:TMRedColor forState:UIControlStateNormal];
        } else {
            [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        }
    }
    [attrOptionsView removeFromSuperview];
    attrOptionsView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 70, self.view.frame.size.width, 0)];
    [attrOptionsView setBackgroundColor:[UIColor whiteColor]];
    for (int i=0; i<attribute.options.count; i++){
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((i%2)*(self.view.frame.size.width/2)+5, 40 * (i / 2), self.view.frame.size.width / 2 - 10, 40)];
        [button setTitle:[attribute.options objectAtIndex:i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [button setFont: [UIFont systemFontWithSize:12]];
        [button addTarget:self action:@selector(clickAttrOption:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        [attrOptionsView addSubview:button];
    }
    [self.view addSubview:attrOptionsView];
    attrOptionsView.layer.zPosition = 5;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3f];
    attrOptionsView.frame = CGRectMake(0, 70, self.view.frame.size.width, self.view.frame.size.height - 200);
    [UIView commitAnimations];
}

- (IBAction)clickAttrOption:(UIButton *)sender{
    AppAttribute *attribute = [attributes objectAtIndex:curSelectedAttrIndex];
    NSString *option = [attribute.options objectAtIndex:sender.tag];
    NSString *attributeId = [[NSString alloc] initWithFormat:@"%d" , attribute.id];
    NSString *key = [@"attribute_" stringByAppendingString:attributeId];
    [requestAttributes setObject:option forKey:key];
    UIButton *button = [attrButtons objectAtIndex:curSelectedAttrIndex];
    [button setTitle:option forState:UIControlStateNormal];
    [attrOptionsView removeFromSuperview];
    masker.hidden = YES;
    curSelectedAttrIndex = -1;
    [self loadData:YES];
}

- (IBAction)clickBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickSort:(UIButton*)sender{
    if (sender.tag == 1){
        self.orderType = @"topDesc";
        [self.btnTopSort setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self.btnSaleSort setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.btnPriceSort setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.imgPriceAsc.image = [UIImage imageNamed:@"arrow_up_gray.png"];
        self.imgPriceDesc.image = [UIImage imageNamed:@"arrow_down_gray.png"];
    } else if (sender.tag == 2){
        self.orderType = @"salesDesc";
        [self.btnSaleSort setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self.btnTopSort setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.btnPriceSort setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.imgPriceAsc.image = [UIImage imageNamed:@"arrow_up_gray.png"];
        self.imgPriceDesc.image = [UIImage imageNamed:@"arrow_down_gray.png"];
    } else if (sender.tag == 3){
        self.orderType = @"priceAsc";
        sender.tag = 4;
        [self.btnSaleSort setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.btnTopSort setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.btnPriceSort setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        self.imgPriceAsc.image = [UIImage imageNamed:@"arrow_up_gray.png"];
        self.imgPriceDesc.image = [UIImage imageNamed:@"arrow_down_red.png"];
    } else if (sender.tag == 4){
        self.orderType = @"priceDesc";
        sender.tag = 3;
        [self.btnSaleSort setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.btnTopSort setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.btnPriceSort setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        self.imgPriceAsc.image = [UIImage imageNamed:@"arrow_up_red.png"];
        self.imgPriceDesc.image = [UIImage imageNamed:@"arrow_down_gray.png"];
    }
    [self loadData:YES];
}

- (void)sendMessage:(Message *)msg{
    if (msg.what == 1){
        //add product to cart
        [cartService addCartItem:msg.int1 quantity:1];
    } else if (msg.what == 2){
        //点击商品
        ProductInfoViewController * prodInfo = [[ProductInfoViewController alloc]init];
        prodInfo.productId = msg.int1;
        
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:nil];
        [self.navigationItem setBackBarButtonItem:backButton];
        
        [self.navigationController pushViewController:prodInfo animated:YES];
    }
}

-(IBAction)clickListType:(UIButton *)sender{
    
    if (sender.tag == 1){
        displayType = @"table";
        sender.tag = 2;
        [sender setBackgroundImage:[UIImage imageNamed:@"sort_list.png"] forState:UIControlStateNormal];
        [self.tableProducts setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    } else if (sender.tag == 2){
        displayType = @"list";
        sender.tag = 1;
        [sender setBackgroundImage:[UIImage imageNamed:@"sort_table.png"] forState:UIControlStateNormal];
        [self.tableProducts setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    }
    [self.tableProducts reloadData];
}

#pragma mark - searchBar的代理
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
    ProdHotKeySearchViewController * hotkey = [[ProdHotKeySearchViewController alloc] initWithNibName:@"ProdHotKeySearchViewController" bundle:nil];
    hotkey.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:hotkey animated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [[[UIApplication sharedApplication] keyWindow] endEditing: YES];
    self.isSearch = true;
    self.searchKeyWord = searchBar.text;
    [self loadData:YES];
}

#pragma TableView的处理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([displayType isEqualToString:@"list"]){
        return products.count;
    } else {
        return products.count / 2 + products.count % 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([displayType isEqualToString:@"list"]){
        return 120;
    } else {
        return 252;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([displayType isEqualToString:@"list"]){
        ProdTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProdTableCell"];
        if (!cell) {
            NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"ProdTableCell" owner:self options:nil];
            for (NSObject *o in objects) {
                if ([o isKindOfClass:[ProdTableCell class]]) {
                    cell = (ProdTableCell *)o;
                    [cell myinit];
                    break;
                }
            }
            if (products.count > indexPath.row) {
                
                AppProduct *product =[products objectAtIndex:[indexPath row]];
               
                // @"券"
                NSString *prodList_range_string = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"prodList_range_string"];
                // @"折"
                NSString *prodList_promrange_string = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"prodList_promrange_string"];
                NSRange range = [product.appMarking rangeOfString:prodList_range_string];
                NSRange promrange = [product.appMarking rangeOfString:prodList_promrange_string];
                if (range.location && range.location != NSNotFound){
                    UIImageView *tempView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 5.0, 20.0, 15.0)];
                    tempView.image = [UIImage imageNamed:@"coup1.png"];
                    [cell.name addSubview:tempView];
                    NSString *prodname =@"      ";
                    cell.name.text = [prodname stringByAppendingString:product.name];
                } else if (range.location && promrange.location != NSNotFound) {
                    UIImageView *tempView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 5.0, 20.0, 15.0)];
                    tempView.image = [UIImage imageNamed:@"promdisc.png"];
                    [cell.name addSubview:tempView];
                    NSString *prodname =@"      ";
                    cell.name.text = [prodname stringByAppendingString:product.name];
                }else {
                    cell.name.text = product.name;
                }
                
                [cell.name alignTop];
                
                // @"品牌:%@"
                NSString *prodList_cellOne_brand = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"prodList_cellOne_brand"];
                // @"型号:%@"
                NSString *prodList_cellOne_makerModel = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"prodList_cellOne_makerModel"];
                // @"型号:暂无"
                NSString *prodList_cellOne_makerModel2 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"prodList_cellOne_makerModel2"];
                // @"商品编号:%@"
                NSString *prodList_cellOne_sn = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"prodList_cellOne_sn"];
                cell.brand.text = [NSString stringWithFormat:prodList_cellOne_brand, product.appBrand.name];
                if (product.makerModel){
                    cell.makerModel.text = [NSString stringWithFormat:prodList_cellOne_makerModel, product.makerModel];
                } else {
//                    [NSString stringWithFormat:@"型号:%@", @"暂无"];
                    cell.makerModel.text = prodList_cellOne_makerModel2;
                }
                cell.sn.text = [NSString stringWithFormat:prodList_cellOne_sn, product.sn];
                if (product.promotionPrice){
                    cell.price.text = [CommonUtils formatCurrency:product.promotionPrice];
                    cell.delPrice.attributedText = [CommonUtils addDeleteLineOnLabel:[CommonUtils formatCurrency:product.price]];
                } else {
                    
                    cell.price.text = [CommonUtils formatCurrency:product.price];
                    cell.delPrice.text = @"";
                }
                
                [cell.price sizeToFit];
                [cell.delPrice setFrame:CGRectMake(CGRectGetMaxX(cell.price.frame) + 10, CGRectGetMinY(cell.price.frame),1.0,1.0)];
                
                [cell.delPrice sizeToFit];
                
                cell.image.imageURL = [NSURL URLWithString:product.image];
                if (product.isHotSale){
                    cell.hotImage.hidden = NO;
                } else {
                    cell.hotImage.hidden = YES;
                }
                cell.productId = product.id;
                cell.msgHandler = self;
            }
        }
        
        return cell;
        
    } else {
        ProdTableCellTable *cell = [tableView dequeueReusableCellWithIdentifier:@"ProdTableCellTable"];
        
        int row = indexPath.row * 2;

        if (!cell && products.count>row) {
            NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"ProdTableCellTable" owner:self options:nil];
            for (NSObject *o in objects) {
                if ([o isKindOfClass:[ProdTableCellTable class]]) {
                    cell = (ProdTableCellTable *)o;
                    [cell myinit];
                    cell.msgHandler = self;
                    break;
                }
            }
            
            // @"券"
            NSString *prodList_range_string = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"prodList_range_string"];
            // @"折"
            NSString *prodList_promrange_string = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"prodList_promrange_string"];
            // @"品牌:%@"
            NSString *prodList_cellTwo_brand = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"prodList_cellTwo_brand"];
            // @"型号:%@"
            NSString *prodList_cellTwo_makerModel = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"prodList_cellTwo_makerModel"];
            // @"型号:暂无"
            NSString *prodList_cellTwo_makerModel2 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"prodList_cellTwo_makerModel2"];
            // @"商品编号:%@"
            NSString *prodList_cellTwo_sn = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"prodList_cellTwo_sn"];
            AppProduct *product =[products objectAtIndex:row];
            NSRange range = [product.appMarking rangeOfString:prodList_range_string];
            NSRange promrange = [product.appMarking rangeOfString:prodList_promrange_string];
            if (range.location != NSNotFound){
                UIImageView *tempView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 5.0, 20.0, 15.0)];
                tempView.image = [UIImage imageNamed:@"coup1.png"];
                [cell.name1 addSubview:tempView];
                NSString *prodname =@"      ";
                cell.name1.text = [prodname stringByAppendingString:product.name];
            } else if (promrange.location != NSNotFound) {
                UIImageView *tempView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 5.0, 20.0, 15.0)];
                tempView.image = [UIImage imageNamed:@"promdisc.png"];
                [cell.name1 addSubview:tempView];
                NSString *prodname =@"      ";
                cell.name1.text = [prodname stringByAppendingString:product.name];
            }else {
                cell.name1.text = product.name;
            }
            [cell.name1 alignTop];
            
            cell.brand1.text = [NSString stringWithFormat:prodList_cellTwo_brand, product.appBrand.name];
            if (product.makerModel){
                cell.makerModel1.text = [NSString stringWithFormat:prodList_cellTwo_makerModel, product.makerModel];
            } else {
//                [NSString stringWithFormat:@"型号:%@", @"暂无"];
                cell.makerModel1.text = prodList_cellTwo_makerModel2;
            }
            
            cell.sn1.text = [NSString stringWithFormat:prodList_cellTwo_sn, product.sn];
            if (product.promotionPrice){
                cell.price1.text =[CommonUtils formatCurrency:product.promotionPrice];
                cell.delPrice1.attributedText = [CommonUtils addDeleteLineOnLabel:[CommonUtils formatCurrency:product.price]];
            } else {
                cell.price1.text =[CommonUtils formatCurrency:product.price];
                cell.delPrice1.text = @"";
            }
            [cell.price1 sizeToFit];
            [cell.delPrice1 setFrame:CGRectMake(CGRectGetMaxX(cell.price1.frame) + 10, CGRectGetMinY(cell.price1.frame),1.0,1.0)];
            
            [cell.delPrice1 sizeToFit];
            
            cell.image1.imageURL = [NSURL URLWithString:product.image];
            if (product.isHotSale){
                cell.hotImage1.hidden = NO;
            } else {
                cell.hotImage1.hidden = YES;
            }
            cell.productId1 = product.id;
            cell.bgView1.tag = product.id;
            
            if (products.count > row + 1){
                product =[products objectAtIndex:row + 1];
                
                NSRange range = [product.appMarking rangeOfString:prodList_range_string];
                NSRange promrange = [product.appMarking rangeOfString:prodList_promrange_string];
                if (range.location != NSNotFound){
                    UIImageView *tempView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 5.0, 20.0, 15.0)];
                    tempView.image = [UIImage imageNamed:@"coup1.png"];
                    [cell.name2 addSubview:tempView];
                    NSString *prodname =@"      ";
                    cell.name2.text = [prodname stringByAppendingString:product.name];
                } else if (promrange.location != NSNotFound) {
                    UIImageView *tempView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 5.0, 20.0, 15.0)];
                    tempView.image = [UIImage imageNamed:@"promdisc.png"];
                    [cell.name2 addSubview:tempView];
                    NSString *prodname =@"      ";
                    cell.name2.text = [prodname stringByAppendingString:product.name];
                }else {
                    cell.name2.text = product.name;
                }
                [cell.name2 alignTop];
                
                cell.brand2.text = [NSString stringWithFormat:prodList_cellTwo_brand, product.appBrand.name];
                if (product.makerModel){
                    cell.makerModel2.text = [NSString stringWithFormat:prodList_cellTwo_makerModel, product.makerModel];
                } else {
//                    [NSString stringWithFormat:@"型号:%@", @"暂无"];
                    cell.makerModel2.text = prodList_cellTwo_makerModel2;
                }
                cell.sn2.text = [NSString stringWithFormat:prodList_cellTwo_sn, product.sn];
                if (product.promotionPrice){
                    cell.price2.text = [CommonUtils formatCurrency:product.promotionPrice];
                    cell.delPrice2.attributedText = [CommonUtils addDeleteLineOnLabel:[CommonUtils formatCurrency:product.price]];
                } else {
                cell.price2.text = [CommonUtils formatCurrency:product.price];
                    cell.delPrice2.text = @"";
                }
                [cell.price2 sizeToFit];
                [cell.delPrice2 setFrame:CGRectMake(CGRectGetMaxX(cell.price2.frame) + 10, CGRectGetMinY(cell.price2.frame),1.0,1.0)];
                
                [cell.delPrice2 sizeToFit];
                cell.image2.imageURL = [NSURL URLWithString:product.image];
                cell.productId2 = product.id;
                cell.bgView2.tag = product.id;
                if (product.isHotSale){
                    cell.hotImage2.hidden = NO;
                } else {
                    cell.hotImage2.hidden = YES;
                }
            } else {
                cell.bgView2.hidden = YES;
            }
            cell.bgView1.frame = CGRectMake(0, 0, self.view.frame.size.width / 2 - 2, 250);
            cell.bgView2.frame = CGRectMake(self.view.frame.size.width / 2 + 4, 0, self.view.frame.size.width / 2 -2, 250);
        }
        return cell;
    }
    
}

//////判断当最后一行的时候，就加载下一行
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == (products.count -1)) {
        if (_hasMoreData) {
            [self loadMoreDataToTable];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([displayType isEqualToString:@"list"]){
        
        AppProduct *product = [products objectAtIndex:indexPath.row];
//        ProdInfo *prodInfo = [[ProdInfo alloc] init];
        ProductInfoViewController * prodInfo = [[ProductInfoViewController alloc]init];
        prodInfo.productId = product.id;
        
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:nil];
        [self.navigationItem setBackBarButtonItem:backButton];
        
        [self.navigationController pushViewController:prodInfo animated:YES];
    }
}

#pragma mark - Refresh and load more methods

- (void) refreshTable
{
    /*
     Code to actually refresh goes here.  刷新代码放在这
     */
    
    [self loadData:YES];
    self.tableProducts.pullLastRefreshDate = [NSDate date];
    
}

- (void) loadMoreDataToTable
{
    /*
     Code to actually load more data goes here.  加载更多实现代码放在在这
     */
    pagination.page = pagination.page + 1;
    [self loadData:NO];
}


- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    [self performSelector:@selector(refreshTable) withObject:nil afterDelay:0.1f];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    [self performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:0.1f];
}

#pragma search模块

//发起请求
- (void)getSearchRequest{
    session = [SESSION getSession];
    UUID = [CommonUtils uuid];
    searchService = [[SearchService alloc] initWithDelegate:self parentView:self.view];
    [searchService getProductWithFetchSearchHistory:true andSearchCookieUUID:UUID andSession:session andPagination:pagination];
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
