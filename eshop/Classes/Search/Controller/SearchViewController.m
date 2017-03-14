//
//  SearchViewController.m
//  eshop
//
//  Created by 董徐维 on 2017/3/10.
//  Copyright © 2017年 hzlg. All rights reserved.
//

#import "SearchViewController.h"
#import "PYSearch.h"

#import "SearchService.h"
@interface SearchViewController ()<PYSearchViewControllerDelegate>
{
    SearchService * searchService;
    NSString * UUID;
    SESSION * session;
    Boolean isBuyAtOnce;
    Pagination * pagination;
}
@property (nonatomic, strong) NSMutableArray * hotArray; //热门搜索词

@end

@implementation SearchViewController



- (instancetype)init
{
    if (self = [super init]) {
        self.hotSearchStyle = PYHotSearchStyleDefault; // 热门搜索风格为默认
        self.searchHistoryStyle = PYSearchHistoryStyleBorderTag; // 搜索历史风格根据选择
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}

//发起请求
- (void)getSearchRequest{
    session = [SESSION getSession];
    UUID = [CommonUtils uuid];
    searchService = [[SearchService alloc] initWithDelegate:self parentView:self.view];
    [searchService getProductWithFetchSearchHistory:true andPagination:pagination success:^(BaseModel *responseObj) {
        
    }];
}

-(void)initView{
    
    NSString *prodHotKeySearchVC_searchText_plaTitle = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"prodHotKeySearchVC_searchText_plaTitle"];
    self.searchBar.placeholder = prodHotKeySearchVC_searchText_plaTitle;
    
    // 1.创建热门搜索
    NSArray *hotSeaches = @[@"Java1", @"Python", @"Objective-C", @"Swift", @"C", @"C++", @"PHP", @"C#", @"Perl", @"Go", @"JavaScript", @"R", @"Ruby", @"MATLAB"];
    // 2. 创建控制器
    
    self.hotSearches = hotSeaches;

    
//        NSMutableArray<NSString *> *hotSeaches = [[NSMutableArray alloc] init];
//        for (NSString *str in _hotArray) {
//            [hotSeaches addObject:str];
//        }
//    
//        PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:prodHotKeySearchVC_searchText_plaTitle didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
//    
//    //        ProdList *prodList = [[ProdList alloc] initWithNibName:@"ProdList" bundle:nil];
//    //        prodList.isSearch = true;
//    //        prodList.searchKeyWord = searchText;
//    //        [searchViewController.navigationController pushViewController:prodList animated:YES];
//    
//        }];
//    //    weakVC = searchViewController;
//        searchViewController.refleshClick = ^(void){
//    
//            pagination.page ++;
//            [self getSearchRequest];
//        };
//        searchViewController.hotSearchStyle = PYHotSearchStyleDefault; // 热门搜索风格为默认
//        searchViewController.searchHistoryStyle = PYSearchHistoryStyleBorderTag; // 搜索历史风格根据选择
//        searchViewController.delegate = self;
//        [self.view addSubview:searchViewController.view];
    
    __weak __typeof(self)weakSelf = self;

    self.refleshClick = ^(void){
        weakSelf.hotSearches = hotSeaches;
        [weakSelf.tableView reloadData];
    };
    
    [self.tableView reloadData];
}


@end
