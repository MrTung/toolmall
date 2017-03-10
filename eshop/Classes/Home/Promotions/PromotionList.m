//
//  PromotionList.m
//  eshop
//
//  Created by mc on 15/11/7.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import "PromotionList.h"

@interface PromotionList ()

@end

@implementation PromotionList

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // @"土猫促销"
    NSString *promotionList_navItem_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"promotionList_navItem_title"];
    self.navigationItem.title = promotionList_navItem_title;
    // Do any additional setup after loading the view from its nib.
    promotionService = [[PromotionService alloc] initWithDelegate:self parentView:self.view];
    pagination = [Pagination alloc];
    [self.tableList setHasLoadingMore:NO];
    promotions = [[NSMutableArray alloc] initWithCapacity:20];
    [self loadData:NO];

}


- (void) loadData:(BOOL)refresh
{
    if (refresh){
        pagination.page = 1;
        [promotions removeAllObjects];
    }
    [promotionService getPromotionList:@"normal" pagination:pagination];
}



- (void)loadResponse:(NSString *) url response:(BaseModel *)response{
    
    if ([url isEqual:api_promotion_list]){
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(8, 8, self.view.frame.size.width, 40)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
        label.font = [UIFont systemFontOfSize:13];
        
        // @"全部活动"
        NSString *promotionList_label_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"promotionList_label_title"];
        label.text = promotionList_label_title;
        [header addSubview:label];
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 34, 320, 1)];
        line.backgroundColor = [UIColor lightGrayColor];
        [header addSubview:line];
        self.tableList.tableHeaderView = header;
        [self.tableList.tableHeaderView setFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];

        PromotionListResponse * respobj = (PromotionListResponse *)response;
        [promotions addObjectsFromArray:respobj.data];
        if (promotions.count == 0){
//            [CommonUtils displayNoResultView:self.view frame:self.tableList.frame];
            [CommonUtils displayCollectionNoResultView:self.view frame:self.tableList.frame desc:@"没有结果"];
            NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
            [center addObserver:self selector:@selector(jumpToIndexPage) name:TMPop2IndexNotificationName object:nil];
            self.tableList.hidden = YES;
        } else {
            [_tableList reloadData];
            [CommonUtils removeNoResultView:self.view];
            self.tableList.hidden = NO;
        }
        self.tableList.pullTableIsRefreshing = NO;
        self.tableList.pullTableIsLoadingMore = NO;
    }
}

#pragma TableView的处理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return promotions.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:self.tableList cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PromotionListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PromotionListCell"];
    if (!cell) {
        cell = [[PromotionListCell alloc] initWithReuseIdentifier:@"PromotionListCell"];
        
        //UIFont *font = [UIFont fontWithName:@"Arial" size:12];
        //设置一个行高上限
        //CGSize size = CGSizeMake(320,2000);
        //计算实际frame大小，并将label的frame变成实际大小
        //CGSize labelsize = [desc sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
        //[cell.prmoDesc setFrame:CGRectMake(0,0, labelsize.width, labelsize.height)];
        //NSLog([[NSString alloc]initWithFormat:@"SDSD%f" ,labelsize.height ]);
        //cell.prmoDesc.text = desc;
        //[cell layoutSubviews];
    }
    AppPromotion *promotion = [promotions objectAtIndex:indexPath.row];
    NSString *desc = @"";
    if (promotion.introduction != nil){
        // @"活动说明:"
        NSString *promotionList_cell_desc = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"promotionList_cell_desc"];
        desc = [promotionList_cell_desc stringByAppendingString:promotion.introduction];
    }
    
    [cell setBrief:desc];
    [cell setImageUrl:promotion.image];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppPromotion *promotion = [promotions objectAtIndex:indexPath.row];
    ProdList *prodList = [[ProdList alloc] initWithNibName:@"ProdList" bundle:nil];
    prodList.promotionId = promotion.id;
    [self.navigationController pushViewController:prodList animated:YES];
}

#pragma mark - Refresh and load more methods

- (void) refreshTable
{
    /*
     
     Code to actually refresh goes here.  刷新代码放在这
     */
    
    [self loadData:YES];
    self.tableList.pullLastRefreshDate = [NSDate date];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)jumpToIndexPage{
    
    self.tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:NO];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
