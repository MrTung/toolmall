//
//  MyDeposit.m
//  eshop
//
//  Created by mc on 15/11/1.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import "MyDeposit.h"
#import "IQKeyboardManager.h"
#import "IQKeyboardReturnKeyHandler.h"
#import "IQUIView+IQKeyboardToolbar.h"
@interface MyDeposit ()<ServiceResponselDelegate>

@end

@implementation MyDeposit
@synthesize lbBalance;
@synthesize txtChargeAmt;
@synthesize tableDeposits;
@synthesize btmView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [CommonUtils setExtraCellLineHidden:self.tableDeposits];
    // Do any additional setup after loading the view from its nib
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"我的预存款";

    depositService = [DepositService alloc];
    depositService.delegate = self;
    depositService.parentView = self.view;
    pagination = [[Pagination alloc] init];
    pagination.page = 1;
    
    deposits = [[NSMutableArray alloc] initWithCapacity:20];
    //[self setExtraCellLineHidden];
    
    
  
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self loadData:NO];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed=YES;
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tap
{
    [self.view endEditing:YES];
}

- (void) loadData:(BOOL)refresh
{
    if (refresh){
        pagination.page = 1;
        [deposits removeAllObjects];
    }
    [depositService getDepositList:pagination];
}



- (void)loadResponse:(NSString *) url response:(BaseModel *)response{
    DepositListResponse * respobj = (DepositListResponse *)response;
    
    [deposits addObjectsFromArray:respobj.data];
    
    
    [tableDeposits reloadData];
    
    self.tableDeposits.pullTableIsLoadingMore = NO;
    self.tableDeposits.pullTableIsRefreshing = NO;
    if (pagination.page == 1 && respobj.paginated.count > 0){
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"MyDepositHeader" owner:self options:nil];
        for (NSObject *o in objects) {
            if ([o isKindOfClass:[MyDepositHeader class]]) {
                myDepositHeader = (MyDepositHeader *)o;
                break;
            }
        }
        myDepositHeader.frame = CGRectMake(0, 0, self.view.frame.size.width, 30);
        self.tableDeposits.tableHeaderView = myDepositHeader;
        self.tableDeposits.tableHeaderView.frame = CGRectMake(0, 0, self.view.frame.size.width, 30);
    }
    if (deposits.count == 0){
//        [CommonUtils displayNoResultView:self.view frame:tableDeposits.frame];
        [CommonUtils displayCollectionNoResultView:self.view frame:self.tableDeposits.frame desc:@"没有结果"];
        
        NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(jumpToIndexPage) name:TMPop2IndexNotificationName object:nil];
        self.tableDeposits.hidden = YES;
    } else {
        [CommonUtils removeNoResultView:self.view];
        self.tableDeposits.hidden = NO;
    }
    if (respobj.paginated.more == 0){
        [self.tableDeposits setHasLoadingMore: NO];
    } else {
        [self.tableDeposits setHasLoadingMore: YES];
    }
    //self.btmView.frame = CGRectMake(0, self.view.frame.size.height - 56, self.view.frame.size.width, 56);
    //self.tableDeposits.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 56);
    self.lbBalance.text = [[NSString alloc] initWithFormat:@"余额:%@", [CommonUtils formatCurrency:respobj.balanceAmt]];
    
}

-(void)setExtraCellLineHidden
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableDeposits setTableFooterView:view];
}

- (IBAction)clickRecharge:(id)sender{
    if ([CommonUtils trim:self.txtChargeAmt.text].length == 0){
        [CommonUtils ToastNotification:@"请输入充值金额" andView:self.view andLoading:NO andIsBottom:NO];
        return;
    }
    if ([self.txtChargeAmt.text intValue] <= 0){
        [CommonUtils ToastNotification:@"充值金额格式不正确" andView:self.view andLoading:NO andIsBottom:NO];
        return;
    }
    PaymentPlugins *paymentPlugins = [[PaymentPlugins alloc] initWithNibName:@"PaymentPlugins" bundle:nil];
    PaymentInfo *paymentInfo = [[PaymentInfo alloc] init];
    paymentInfo.amount = [[NSNumber alloc] initWithInt:[self.txtChargeAmt.text intValue]];
    //paymentInfo.amount = [[NSNumber alloc] initWithFloat:0.01f];
    paymentInfo.type = @"recharge";
    [paymentPlugins setPaymentInfo:paymentInfo];
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [self.navigationController pushViewController:paymentPlugins animated:YES];
}

#pragma TableView的处理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return deposits.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MyDepositCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyDepositCell"];
    if (!cell) {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"MyDepositCell" owner:self options:nil];
        for (NSObject *o in objects) {
            if ([o isKindOfClass:[MyDepositCell class]]) {
                cell = (MyDepositCell *)o;
                break;
            }
        }
        AppDeposit *deposit =[deposits objectAtIndex:[indexPath row]];
        cell.lbDate.text = [CommonUtils formatDate:deposit.createDate];
        cell.lbType.text = deposit.typename;
        cell.lbDeposit.text = [NSString stringWithFormat:@"%@", deposit.debit];
        cell.lbCredit.text = [NSString stringWithFormat:@"%@", deposit.credit];
        

    }
return cell;
}


#pragma mark - Refresh and load more methods

- (void) refreshTable
{
    /*
     
     Code to actually refresh goes here.  刷新代码放在这
     */
    
    [self loadData:YES];
    self.tableDeposits.pullLastRefreshDate = [NSDate date];
    
}

- (void) loadMoreDataToTable
{
    pagination.page = pagination.page + 1;
    [self loadData:NO];
}

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    
    [self performSelector:@selector(refreshTable) withObject:nil afterDelay:0.2f];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    [self performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:0.2f];
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
