//
//  ProdHotKeySearchViewController.m
//  eshop
//
//  Created by mc on 16/3/8.
//  Copyright © 2016年 hzlg. All rights reserved.
//

#import "ProdHotKeySearchViewController.h"

@interface ProdHotKeySearchViewController ()
{
    SearchService * searchService;
    UICollectionView * collectionviewHistory;
    Pagination * pagination;
    NSString * UUID;
    SESSION * session;
    UIView * hotkeyView;
}
@end

@implementation ProdHotKeySearchViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        [self hidesBottomBarWhenPushed];
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [super addNavBackButton];
    [self createNav];
    [self createUI];
    session = [SESSION getSession];
    UUID = [CommonUtils uuid];
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.alpha = 1;
    searchService = [[SearchService alloc] initWithDelegate:self parentView:self.view];
    _fetchSearchHistory = true;
    _historyArray = [[NSMutableArray alloc]init];
    _hotArray = [[NSMutableArray alloc]init];
    pagination = [[Pagination alloc] init];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (hotkeyView.subviews) {
        for (UIView * view in hotkeyView.subviews) {
            [view removeFromSuperview];
        }
    }

    [self getPostRequest];
}
//发起请求
- (void)getPostRequest{
    [searchService getProductWithFetchSearchHistory:_fetchSearchHistory andPagination:pagination success:^(BaseModel *responseObj) {
        
    }];
}

//热词换一批请求
- (void)changeHotKeyWithPage:(UIButton *)button{
    
    if (pagination.page == pagination.count) {
        pagination.page =1;
    }else{
        pagination.page = pagination.page +1;
    }
    [self getPostRequest];
}

//删除历史记录请求
- (void)deleteSearchHistories:(UIButton *)button{
//    NSLog(@"删除历史搜索");
    [searchService deleteHistoryKeyWordWithSuccess:^(BaseModel *responseObj) {
        
    }];
}

- (void)loadResponse:(NSString *) url response:(BaseModel *)response{
//    NSLog(@"%@",url);
    [_hotArray removeAllObjects];
    [_historyArray removeAllObjects];
    if ([url isEqualToString:api_hotsearchkeylist]) {
        HotSearchKeyListResponse * resobj = (HotSearchKeyListResponse *)response;
        [_hotArray addObjectsFromArray:resobj.data];
        [_historyArray addObjectsFromArray:resobj.searchHistories];
        float btnW = (kWidth-TMScreenW *40/320)/3.0;
        for (int i =0;i<_hotArray.count;i++) {
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(TMScreenW *10/320 + i%3*(btnW+TMScreenW *10/320), i/3*(TMScreenH *45/568)+TMScreenH *10/568, btnW, TMScreenH *35/568);
            btn.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1];
            [btn setTitle:_hotArray[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [btn.titleLabel sizeToFit];
            [btn.titleLabel setFont:[UIFont systemFontWithSize:12]];
            [btn addTarget:self action:@selector(searchButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            btn.layer.cornerRadius=3;
            btn.layer.masksToBounds=YES;
            btn.userInteractionEnabled = YES;
            btn.enabled = YES;
            [hotkeyView addSubview:btn];
        }
//        NSSet *set = [NSSet setWithArray:_historyMutableArray];
//        _historyArray = [set allObjects];
//        NSLog(@"%@",[set allObjects]);
        [collectionviewHistory reloadData];
        
    }
    if ([url isEqualToString:api_productsearchkey_clear_search_history]) {
        StatusResponse * resobj = (StatusResponse *)response;
//        NSLog(@"点击了删除按钮");
        if (resobj.status.succeed) {
            _historyArray = nil;
            [collectionviewHistory reloadData];
        }
    }
}

- (void)createNav{

    // @"输入关键词"
    NSString *prodHotKeySearchVC_searchText_plaTitle = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"prodHotKeySearchVC_searchText_plaTitle"];
    // @"搜索"
    NSString *prodHotKeySearchVC_lblSearch_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"prodHotKeySearchVC_lblSearch_title"];
    _searchText = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, TMScreenW *220/320,30)];
    _searchText.backgroundColor = [UIColor whiteColor];
    _searchText.textColor = [UIColor lightGrayColor];
    _searchText.font = [UIFont systemFontWithSize:12.0];
    [_searchText setTintColor:TMBlackColor];
    _searchText.placeholder = prodHotKeySearchVC_searchText_plaTitle;
    _searchText.layer.masksToBounds = YES;
    _searchText.layer.cornerRadius = 5;
    _searchText.layer.borderColor = [UIColor colorWithRed:209/255.0 green:209/255.0 blue:209/255.0 alpha:1].CGColor;
    _searchText.layer.borderWidth = 1;
    _searchText.delegate = self;
    self.navigationItem.titleView = _searchText;
    _searchText.returnKeyType = UIReturnKeySearch;
//    [_searchText becomeFirstResponder];
    
    UIButton * btnSearch = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSearch.frame = CGRectMake(0, 0, CGRectGetHeight(_searchText.frame)-8, CGRectGetHeight(_searchText.frame)-8);
    [btnSearch setImage:[UIImage imageNamed:@"indexsearch.png"] forState:UIControlStateNormal];
    [btnSearch addTarget:self action:@selector(searchBarSearchButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _searchText.leftViewMode = UITextFieldViewModeAlways;
    _searchText.leftView = btnSearch;
    
    
    UIButton * lblSearch = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 45, 30)];
    [lblSearch setTitle:prodHotKeySearchVC_lblSearch_title forState:UIControlStateNormal];
    lblSearch.backgroundColor = redColorSelf;
    [lblSearch setFont:[UIFont systemFontOfSize:12]];
    [lblSearch addTarget:self action:@selector(searchBarSearchButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [CommonUtils decrateRedButton: lblSearch];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:lblSearch];

    
}

//热搜按钮搜索
- (void)searchButtonClicked:(UIButton *)button{
    
    if (button.titleLabel.text.length>0 && ([[button.titleLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] != 0)) {
        [self search:button.titleLabel.text];
    }
    else {
        [self prodHotKeySearchVC_toastNotification_msg1];
    }
}

//导航又边的搜索
- (void)searchBarSearchButtonClicked:(UIButton *)button{
    if (_searchText.text.length > 0 && ([[_searchText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] != 0)) {
        [self search:_searchText.text];
    }
    else {
        [self prodHotKeySearchVC_toastNotification_msg1];
    }
}

//进行搜索
- (void)search:(NSString *)string {
        
    NSArray * arrayVCs = [self.navigationController viewControllers];
    
//    NSLog(@"%@",self.navigationController.viewControllers);
    UIViewController * lastVC = arrayVCs[arrayVCs.count -2];
    if ([lastVC isKindOfClass:[ProdList class]]) {
//        //            block反向传值，将搜索的关键词反向传回到ProdList页面
//        self.keywordSearch(string);
        if ([self.hotKeyDelegate respondsToSelector:@selector(changeTheTextOfTextFiled:)]) {
            [self.hotKeyDelegate changeTheTextOfTextFiled:string];
        }
        [self.navigationController popViewControllerAnimated:NO];
        
    }else{
        
        ProdList *prodList = [[ProdList alloc] initWithNibName:@"ProdList" bundle:nil];
        prodList.isSearch = true;
        prodList.searchKeyWord = string;
        [self.navigationController pushViewController:prodList animated:NO];
    }
}

- (void)createUI{
    
    UIColor * ItemBGColor = [UIColor whiteColor];
    
//    热门搜索
    UIView * viewHot = [[UIView alloc] initWithFrame:CGRectMake(0, TMScreenH *10/568, kWidth, TMScreenH *30/568)];
    viewHot.userInteractionEnabled = YES;
    viewHot.backgroundColor = ItemBGColor;

    UIImageView * hotImg = [[UIImageView alloc] init];
    hotImg.frame = CGRectMake(TMScreenW *10/320, TMScreenH *8/568, TMScreenW *14/320, TMScreenH *14/568);
    hotImg.image = [UIImage imageNamed:@"热门搜索"];
    [viewHot addSubview:hotImg];
    UILabel * lblHot = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(hotImg.frame)+TMScreenW *8/320, 0, TMScreenW *60/320, TMScreenH *30/568)];
    // @"热门搜索"
    NSString *prodHotKeySearchVC_lblHot_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"prodHotKeySearchVC_lblHot_title"];
    lblHot.text = prodHotKeySearchVC_lblHot_title;
    [lblHot setFont:[UIFont systemFontWithSize:14]];
    [viewHot addSubview:lblHot];

    
    UIView *viewChange = [[UIView alloc] initWithFrame:(CGRectMake(kWidth-TMScreenW *72/320, 0, TMScreenW *62/320, TMScreenH *30/568))];
    
    UIImageView * changeImg = [[UIImageView alloc] init];
    changeImg.frame = CGRectMake(TMScreenW *0/320, TMScreenH *8/568, TMScreenW *14/320, TMScreenH *14/568);
    changeImg.image = [UIImage imageNamed:@"换一批"];
    [viewChange addSubview:changeImg];
    
    UILabel * lblChange = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(changeImg.frame)+TMScreenW *8/320, 0, TMScreenW *40/320, TMScreenH *30/568)];
    // @"换一批"
    NSString *prodHotKeySearchVC_lblChange_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"prodHotKeySearchVC_lblChange_title"];
    lblChange.text = prodHotKeySearchVC_lblChange_title;
    lblChange.textColor = [UIColor grayColor];
//    lblChange.textAlignment = NSTextAlignmentCenter;
    [lblChange setFont:[UIFont systemFontWithSize:13]];
    [viewChange addSubview:lblChange];
    
    UIButton * btnHuan = [UIButton buttonWithType:UIButtonTypeCustom];
    btnHuan.frame = CGRectMake(0, 0, TMScreenW *62/320, TMScreenH *30/568);
    [btnHuan addTarget:self action:@selector(changeHotKeyWithPage:) forControlEvents:UIControlEventTouchUpInside];
    [viewChange addSubview:btnHuan];
    
    [viewHot addSubview:viewChange];
    
    [self.view addSubview:viewHot];
    
    
    hotkeyView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(viewHot.frame), kWidth, TMScreenH *100/568)];
    hotkeyView.backgroundColor = [UIColor whiteColor];
    hotkeyView.userInteractionEnabled = YES;
    [self.view addSubview:hotkeyView];
    
//  最近搜索
    UIView * viewHistory = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(hotkeyView.frame), kWidth, TMScreenH *30/568)];
    viewHistory.backgroundColor = ItemBGColor;
    
    UIImageView * hisImg = [[UIImageView alloc] init];
    hisImg.frame = CGRectMake(TMScreenW *10/320, TMScreenH *8/568, TMScreenW *14/320, TMScreenH *14/568);
    hisImg.image = [UIImage imageNamed:@"最近搜索"];
    [viewHistory addSubview:hisImg];
    
    UILabel * lblHistory = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(hisImg.frame)+TMScreenW *8/320, 0, TMScreenW *80/320, TMScreenH *30/568)];
    // @"最近搜索"
    NSString *prodHotKeySearchVC_lblHistory_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"prodHotKeySearchVC_lblHistory_title"];
    lblHistory.text = prodHotKeySearchVC_lblHistory_title;
    [lblHistory setFont:[UIFont systemFontWithSize:14]];
    [viewHistory addSubview:lblHistory];
    
    [self.view addSubview:viewHistory];
    
//    collectionviewHistory = [[UICollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(viewHistory.frame), kWidth, TMScreenH *150/568) style:UITableViewStylePlain];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    flowLayout.minimumLineSpacing = TMScreenH *10/568;
    flowLayout.minimumInteritemSpacing = 1;
    collectionviewHistory = [[UICollectionView alloc] initWithFrame:(CGRectMake(0, CGRectGetMaxY(viewHistory.frame), kWidth, TMScreenH *190/568)) collectionViewLayout:flowLayout];
    collectionviewHistory.backgroundColor = [UIColor whiteColor];
    collectionviewHistory.dataSource = self;
    collectionviewHistory.delegate = self;
    collectionviewHistory.bounces = NO;
    
    collectionviewHistory.showsVerticalScrollIndicator = NO;
    
    [collectionviewHistory registerNib:[UINib nibWithNibName:@"HistoryCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"historyCollectionViewCell"];
    
    [self.view addSubview:collectionviewHistory];
//    tableviewHistory.tableFooterView = [[UIView alloc] init];
    
    
    UIButton * btnDelete = [UIButton buttonWithType:UIButtonTypeSystem];
    btnDelete.frame = CGRectMake((kWidth - TMScreenW *120/320)/2.0, CGRectGetMaxY(collectionviewHistory.frame) + TMScreenH *50/568, TMScreenW *120/320, TMScreenH *35/568);
    // @"清空搜索历史"
    NSString *prodHotKeySearchVC_btnDelete_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"prodHotKeySearchVC_btnDelete_title"];
    [btnDelete setTitle:prodHotKeySearchVC_btnDelete_title forState:UIControlStateNormal];
    [btnDelete setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btnDelete setBackgroundColor:[UIColor whiteColor]];
    [btnDelete addTarget:self action:@selector(deleteSearchHistories:) forControlEvents:UIControlEventTouchUpInside];
    btnDelete.titleLabel.font = [UIFont systemFontWithSize:14];
//    btnDelete setfo\\\
    
    btnDelete.layer.masksToBounds = YES;
    btnDelete.layer.cornerRadius = 5;
    btnDelete.layer.borderColor = [UIColor redColor].CGColor;
    btnDelete.layer.borderWidth = 1.0f;
    
    [self.view addSubview:btnDelete];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (_historyArray == nil){
        return 0;
    }
    return _historyArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    
    HistoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"historyCollectionViewCell" forIndexPath:indexPath];

    if ([[_historyArray objectAtIndex:indexPath.row] isEqual:[NSNull alloc]]) {
        cell.textLabel.text = @"";
    }else{
        cell.textLabel.text = [_historyArray objectAtIndex:indexPath.row];
    }
    [cell setTintColor:[UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1]];
    [[cell textLabel] setFont:[UIFont systemFontWithSize:12]];
    
    return cell;
}


#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //当手指离开某行时，就让某行的选中状态消失
//    [collectionView deselectRowAtIndexPath:indexPath animated:YES];
    if (_historyArray.count > indexPath.row) {
        
        NSString *keyword = (NSString*)[_historyArray objectAtIndex:indexPath.row];
        if (![keyword isKindOfClass:[NSNull class]]) {
            
            [self search:keyword];
        }
        else {
            [self prodHotKeySearchVC_toastNotification_msg1];
        }
    }
}
#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake((kWidth-TMScreenW *40/320)/3.0, TMScreenH *35/568);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(TMScreenH *10/568, TMScreenW *10/320, TMScreenH *10/568, TMScreenW *10/320);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    if (_searchText.text.length > 0 && ([[_searchText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] != 0)) {
        [self search:_searchText.text];
    }
    else {
        [self prodHotKeySearchVC_toastNotification_msg1];
    }
    return YES;
}

- (void)prodHotKeySearchVC_toastNotification_msg1 {

    // @"禁止搜索空字符串"
    NSString *prodHotKeySearchVC_toastNotification_msg1 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"prodHotKeySearchVC_toastNotification_msg1"];
    [CommonUtils ToastNotification:prodHotKeySearchVC_toastNotification_msg1 andView:self.view andLoading:NO andIsBottom:YES];
}

@end
