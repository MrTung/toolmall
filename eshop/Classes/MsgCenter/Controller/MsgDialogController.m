//
//  MsgDialogController.m
//  eshop
//
//  Created by mc on 15/11/15.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import "MsgDialogController.h"
#import "MsgDialogCell.h"
@interface MsgDialogController ()

@end

@implementation MsgDialogController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [CommonUtils setExtraCellLineHidden:self.tableList];
    self.navigationItem.hidesBackButton = NO;
    self.navigationController.navigationBarHidden = NO;
    
    self.navigationItem.title = _appMessage.title;
    
    msgService = [MsgService alloc];
    msgService.delegate = self;
    msgService.parentView = self.view;
    
    msgList = [[NSMutableArray alloc] initWithCapacity:20];
    
    [self loadData:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed=YES;
    }
    return self;
}

- (void) loadData:(BOOL*)refresh
{
    [msgList removeAllObjects];
    [msgService viewMsg:_appMessage.id];
}


- (void)loadResponse:(NSString *) url response:(BaseModel *)response{
    if ([url isEqual:api_msg_view]){
        MsgListResponse * respobj = (MsgListResponse *)response;
        [msgList addObjectsFromArray:respobj.data];
        if (msgList.count == 0){
//            [CommonUtils displayNoResultView:self.view];
            [CommonUtils displayCollectionNoResultView:self.view frame:self.tableList.frame desc:@"没有结果"];
            
            NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
            [center addObserver:self selector:@selector(jumpToIndexPage) name:TMPop2IndexNotificationName object:nil];
            self.tableList.hidden = YES;
        } else {
            [CommonUtils removeNoResultView:self.view];
            [self.tableList reloadData];
        }
        self.tableList.pullTableIsLoadingMore = NO;
        self.tableList.pullTableIsRefreshing = NO;
        [self.tableList setHasLoadingMore: NO];
    } else if ([url isEqual:api_msg_reply]){
        MsgListResponse * respobj = (MsgListResponse *)response;
        if (respobj.status.succeed == 1){
            self.sendMsgContent.text = @"";
            [msgList addObjectsFromArray:respobj.data];
            if (msgList.count == 0){
//                [CommonUtils displayNoResultView:self.view];
                [CommonUtils displayCollectionNoResultView:self.view frame:self.tableList.frame desc:@"没有结果"];
                
                NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
                [center addObserver:self selector:@selector(jumpToIndexPage) name:TMPop2IndexNotificationName object:nil];
                self.tableList.hidden = YES;
            } else {
                [CommonUtils removeNoResultView:self.view];
                [self.tableList reloadData];
            }
        }
    }
}

- (IBAction)clickSend:(id)sender{
    if ([CommonUtils trim:self.sendMsgContent.text].length == 0){
        [CommonUtils ToastNotification:@"请输入消息内容" andView:self.view andLoading:NO andIsBottom:NO];
        return;
    }
    [[[UIApplication sharedApplication] keyWindow]endEditing:YES];
    [msgService reply:_appMessage.id content:[CommonUtils trim:self.sendMsgContent.text]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return msgList.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:self.tableList cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MsgDialogCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MsgDialogCell"];
    if (!cell) {
        cell = [[MsgDialogCell alloc] initWithReuseIdentifier:@"MsgDialogCell"];
        
    }
    
    [cell setMessage:[msgList objectAtIndex:indexPath.row]];
    return cell;
    
}


- (void) refreshTable
{
    
    [self loadData:YES];
    self.tableList.pullLastRefreshDate = [NSDate date];
    
}

- (void) loadMoreDataToTable
{
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


- (void)jumpToIndexPage{
    
    self.tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:NO];
}

@end
