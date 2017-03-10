//
//  MsgList.m
//  eshop
//
//  Created by mc on 15-11-4.
//  Copyright (c) 2015年 hzlg. All rights reserved.
//

#import "MsgList.h"
#import "MsgDialogController.h"
#import "NewMsg.h"
@interface MsgList ()<ServiceResponselDelegate>

@end

@implementation MsgList
@synthesize tableList;
@synthesize msgList;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [CommonUtils setExtraCellLineHidden:self.tableList];
    self.navigationItem.hidesBackButton = NO;
    self.navigationController.navigationBarHidden = NO;
    self.view.backgroundColor = groupTableViewBackgroundColorSelf;
    
    // @"消息中心"
    NSString *msgList_navItem_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"msgList_navItem_title"];
    self.navigationItem.title = msgList_navItem_title;
    [self addNavBackButton];
    UIBarButtonItem* rightButton = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"newmsg.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickAddMsg:)];
    rightButton.title = @"ADD";
    rightButton.tintColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = rightButton;

    
    msgService = [MsgService alloc];
    msgService.delegate = self;
    msgService.parentView = self.view;
    
    msgList = [[NSMutableArray alloc] initWithCapacity:20];
//    pagination = [[Pagination alloc] init];
//    pagination.page = 1;
//    [self loadData:YES];
    [self testdata];
}

- (void)testdata {
    
    msgList = [[TextDataBase shareTextDataBase] getAllAppMessageDataArr];
    if (msgList.count == 0){
        // @"消息功能正在紧急上线中"
        NSString *msgList_noResultView_desc = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"msgList_noResultView_desc"];
        [CommonUtils displayCollectionNoResultView:self.view frame:self.view.frame desc:msgList_noResultView_desc];
        self.tableList.hidden = YES;
        NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(jumpToIndexPage) name:TMPop2IndexNotificationName object:nil];
    } else {
        [tableList reloadData];
    }
//    self.tableList.pullTableIsLoadingMore = NO;
//    self.tableList.pullTableIsRefreshing = NO;
}

- (void)backButtonClick:(UIButton *)button{
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[ShopLoginViewController class]]) {
            [temp removeFromParentViewController];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed=YES;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    pagination.page = 1;
//    [self loadData:YES];
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:TMPop2IndexNotificationName object:self];
}

-(IBAction)clickAddMsg:(id)sender{
    NewMsg *newMsg = [[NewMsg alloc] initWithNibName:@"NewMsg" bundle:nil];
    [self.navigationController pushViewController:newMsg animated:YES];
}

- (void) loadData:(BOOL)refresh
{
    if (refresh){
        pagination.page = 1;
        [msgList removeAllObjects];
    }
    [msgService getMsgList:pagination];
}


- (void)loadResponse:(NSString *) url response:(BaseModel *)response{
    if ([url isEqual:api_msg_list]){
        MsgListResponse * respobj = (MsgListResponse *)response;
        [msgList addObjectsFromArray:respobj.data];
        if (msgList.count == 0){
            // @"消息功能正在紧急上线中"
            NSString *msgList_noResultView_desc = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"msgList_noResultView_desc"];
            [CommonUtils displayCollectionNoResultView:self.view frame:self.view.frame desc:msgList_noResultView_desc];
            self.tableList.hidden = YES;
            NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
            [center addObserver:self selector:@selector(jumpToIndexPage) name:TMPop2IndexNotificationName object:nil];
        } else {
            [tableList reloadData];
        }
//        self.tableList.pullTableIsLoadingMore = NO;
//        self.tableList.pullTableIsRefreshing = NO;
    }
}

- (void)jumpToIndexPage{
    
    self.tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return msgList.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MsgListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MsgListCell"];
    if (!cell) {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"MsgListCell" owner:self options:nil];
        for (NSObject *o in objects) {
            if ([o isKindOfClass:[MsgListCell class]]) {
                cell = (MsgListCell *)o;
                break;
            }
        }
        AppMessage *message = [msgList objectAtIndex:indexPath.row];
        cell.title.text = message.title;
//        cell.date.text = [CommonUtils formatDate:message.createDate];
        cell.date.text = message.content;
    }
    return cell;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppMessage *msg = [msgList objectAtIndex:indexPath.row];
    MsgDialogController *msgDialog = [[MsgDialogController alloc] initWithNibName:@"MsgDialogController" bundle:nil];
    msgDialog.appMessage = msg;
    [self.navigationController pushViewController:msgDialog animated:YES];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleNormal) title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        AppMessage *appMsg =[self.msgList objectAtIndex:[indexPath row]];
        
        [[TextDataBase shareTextDataBase] deleteOneAppMessageDataBy:appMsg.title];
        
        [self testdata];
        
    }];
//    deleteAction.backgroundColor = [UIColor clearColor];
    return @[deleteAction];
}


//- (void) refreshTable
//{
//
//    [self loadData:YES];
//    self.tableList.pullLastRefreshDate = [NSDate date];
//    
//}
//
//- (void) loadMoreDataToTable
//{
//    pagination.page = pagination.page + 1;
//    [self loadData:NO];
//}
//
//- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
//{
//    
//    [self performSelector:@selector(refreshTable) withObject:nil afterDelay:0.1f];
//}
//
//- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
//{
//    [self performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:0.1f];
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
