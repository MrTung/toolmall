//
//  TwoViewController.m
//  图片处理
//
//  Created by mc on 16/3/30.
//  Copyright © 2016年 lxf. All rights reserved.
//

#import "OrderSearchViewController.h"
#import "OrderList.h"
#import "UIFont+Fit.h"

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

@interface OrderSearchViewController ()
{
    float totalItemHeight;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation OrderSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    orderService = [[OrderService alloc] initWithDelegate:self parentView:self.view];
    _sourceArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.navigationController.navigationBar.translucent = NO;

    [self createNav];
    [self createUI];
    // 最近搜索
    NSString *orderSearchVC_label_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderSearchVC_label_title"];
    self.label.text = orderSearchVC_label_title;
}


- (void)loadResponse:(NSString *)url response:(BaseModel *)response{
    

    if ([url isEqualToString:api_order_clear_history]) {
        StatusResponse * respobj = (StatusResponse *)response;
        //重新获取数据来刷新页面
        if (respobj.status.succeed == 1) {
            [_sourceArray removeAllObjects]; //数据源清空
            [_tableview reloadData];
            // @"删除成功"
            NSString *orderSearchVC_toastNotification_msg1 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderSearchVC_toastNotification_msg1"];
            [CommonUtils ToastNotification:orderSearchVC_toastNotification_msg1 andView:self.view andLoading:NO andIsBottom:YES];
        }
    }
    else if ([url isEqualToString:api_order_search_history]){
        ListResponse * respobj = (ListResponse *)response;
//        NSLog(@"返回的数据是：%@",respobj.data);
            [_sourceArray removeAllObjects]; //数据源清空
        if (respobj.data.count > 0) {
            [_sourceArray addObjectsFromArray:respobj.data];
            
            [_tableview reloadData];
        }
    }
}

- (void)clickButtonSearchHistory:(UIButton *)button {
//    NSLog(@"清空搜索历史");
    if (_sourceArray.count > 0) {
        [orderService clearOrderSearchHistory];
    }else{
        // @"当前没有历史记录"
        NSString *orderSearchVC_toastNotification_msg2 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderSearchVC_toastNotification_msg2"];
        [CommonUtils ToastNotification:orderSearchVC_toastNotification_msg2 andView:self.view andLoading:NO andIsBottom:YES];
    }
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_sourceArray removeAllObjects];
    [orderService orderSearchHistory];
}

- (void)createUI{

    self.headerViewHeightConstraint.constant = TMScreenH *30/568;
    
    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, TMScreenH *30/568, TMScreenW, TMScreenH - TMScreenH *110/568 - 64) style:UITableViewStylePlain];
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableview.dataSource = self;
    _tableview.delegate = self;
    [self.view addSubview:_tableview];
    
    // @"清空搜索历史"
    NSString *orderSearchVC_btnClearSearchHistory_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderSearchVC_btnClearSearchHistory_title"];
    _btnClearSearchHistory = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnClearSearchHistory.titleLabel.font = [UIFont systemFontWithSize:14];
    [_btnClearSearchHistory setTitle:orderSearchVC_btnClearSearchHistory_title forState:UIControlStateNormal];
    [_btnClearSearchHistory setTitleColor:redColorSelf forState:UIControlStateNormal];
    [_btnClearSearchHistory addTarget:self action:@selector(clickButtonSearchHistory:) forControlEvents:UIControlEventTouchUpInside];
    _btnClearSearchHistory.layer.cornerRadius = 5;
    _btnClearSearchHistory.layer.masksToBounds = YES;
    _btnClearSearchHistory.layer.borderColor = redColorSelf.CGColor;
    _btnClearSearchHistory.layer.borderWidth = 1;
    _btnClearSearchHistory.frame = CGRectMake((kWidth - TMScreenW *120/320)/2.0, TMScreenH *10/568, TMScreenW *120/320, TMScreenH *35/568);
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, kHeight - TMScreenH *80/568 - 64, kWidth, TMScreenH *80/568)];
    [view addSubview:_btnClearSearchHistory];
    [self.view addSubview:view];
    
    [self updateViewConstraints];
}

- (void)clickOrderSearchHistoryItemAction:(UIButton *)button{
//    NSLog(@"点击了：clickOrderSearchHistoryItem:--%ld",(long)button.tag);
    [orderService clearOrderSearchHistory];
}


-(void)createNav{

    [super addNavBackButton];
    
    // @"订单编号/商品编号/商品标题"
    NSString *orderSearchVC_navItem_txtSearch = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderSearchVC_navItem_txtSearch"];
    // @"搜索"
    NSString *orderSearchVC_navItem_btnR2 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderSearchVC_navItem_btnR2"];
    
    _btnR2 = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnR2.frame = CGRectMake(0, 0, 45, 30);
//    [_btnR2 setImage:[UIImage imageNamed:@"search_foot.png"] forState:UIControlStateNormal];
//    [_btnR2 setImage:[UIImage imageNamed:@"search_foot.png"] forState:UIControlStateHighlighted];
    [_btnR2 setTitle:orderSearchVC_navItem_btnR2 forState:UIControlStateNormal];
    _btnR2.titleLabel.font = [UIFont systemFontOfSize:13];
    [_btnR2 setBackgroundColor:redColorSelf];
    [_btnR2 addTarget:self action:@selector(clickSearchAction:) forControlEvents:UIControlEventTouchUpInside];
    [CommonUtils decrateRedButton:_btnR2];
    UIBarButtonItem * itemR2 = [[UIBarButtonItem alloc] initWithCustomView:_btnR2];
    
    self.navigationItem.rightBarButtonItem = itemR2;
//    self.navigationItem.rightBarButtonItems = @[itemR2];
    
    _txtSearch = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, TMScreenW *220/320,30)];
    
    _txtSearch.backgroundColor = [UIColor whiteColor];
    _txtSearch.textColor = [UIColor lightGrayColor];
    _txtSearch.font = [UIFont systemFontOfSize:14];
    [_txtSearch setTintColor:TMBlackColor];
    _txtSearch.placeholder = orderSearchVC_navItem_txtSearch;
    _txtSearch.layer.masksToBounds = YES;
    _txtSearch.layer.cornerRadius = 5;
    _txtSearch.layer.borderColor = [UIColor colorWithRed:209/255.0 green:209/255.0 blue:209/255.0 alpha:1].CGColor;
    _txtSearch.layer.borderWidth = 1;
    _txtSearch.delegate = self;
    self.navigationItem.titleView = _txtSearch;
    
    UIButton * btnSearch = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSearch.frame = CGRectMake(0, 0, CGRectGetHeight(_txtSearch.frame)-8, CGRectGetHeight(_txtSearch.frame)-8);
    [btnSearch setImage:[UIImage imageNamed:@"indexsearch.png"] forState:UIControlStateNormal];
    [btnSearch addTarget:self action:@selector(clickSearchAction:) forControlEvents:UIControlEventTouchUpInside];
    _txtSearch.leftViewMode = UITextFieldViewModeAlways;
    _txtSearch.leftView = btnSearch;
    
}

- (void)clickSearchAction:(UIButton *)button{
    if (_txtSearch.text.length > 0) {
        self.returnKeyword(_txtSearch.text);
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        // @"请输入关键字"
        NSString *orderSearchVC_toastNotification_msg3 = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"orderSearchVC_toastNotification_msg3"];
        [CommonUtils ToastNotification:orderSearchVC_toastNotification_msg3 andView:self.view andLoading:NO andIsBottom:YES];
    }
}

- (void)clickNavLeftButton:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - todo
- (void)clickNavRightButtonMore:(UIButton *) button{
//    NSLog(@"2");
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _sourceArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    OrderSearchHistoryItem * item = [[OrderSearchHistoryItem alloc] initWithFrame:CGRectMake(20, 0, SCREENWIDTH-20, 44) andTitle:_sourceArray[indexPath.row]];
    item.userInteractionEnabled = NO;
    [cell.contentView addSubview:item];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    self.returnKeyword(_sourceArray[indexPath.row]);
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
