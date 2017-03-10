//
//  AddressList.m
//  eshop
//
//  Created by mc on 15/11/2.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import "AddressList.h"

#import "OrderController.h"
#import "AddressListHeaderView.h"
@interface AddressList ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addAddressHeightLayoutConstraint;

@end

@implementation AddressList
@synthesize tableAddressList;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        self.navigationController.hidesBottomBarWhenPushed = YES;
        self.hidesBottomBarWhenPushed = YES;
    }
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [CommonUtils setExtraCellLineHidden:self.tableAddressList];
    self.navigationItem.hidesBackButton = NO;
    self.navigationController.navigationBarHidden = NO;

    // @"地址管理"
    NSString *addressList_navItem_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"addressList_navItem_title"];
    
    self.navigationItem.title = addressList_navItem_title;
    
    [super addNavBackButton];

    self.view.backgroundColor = groupTableViewBackgroundColorSelf;
    self.tableAddressList.backgroundColor = groupTableViewBackgroundColorSelf;
    self.tableAddressList.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableAddressList.showsVerticalScrollIndicator = NO;
    
    addressService = [AddressService alloc];
    addressService.delegate = self;
    addressService.parentView = self.view;
    addressList = [[NSMutableArray alloc] initWithCapacity:20];
    
    [self configureAddressListHeaderView];
    [super addThreedotButton];
    
}

- (void)configureAddressListHeaderView {

//    self.tableAddressList.
    UIView *view = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, kWidth, kHeight*40/568 + TMScreenH *0/568))];
    AddressListHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"AddressListHeaderView" owner:self options:nil] lastObject];
    headerView.frame = CGRectMake(0, TMScreenH *0/568, kWidth, kHeight*40/568);
    [headerView.addAddressBtn addTarget:self action:@selector(clickAddButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [view addSubview:headerView];
    view.backgroundColor = groupTableViewBackgroundColorSelf;
//    self.tableAddressList.contentInset = UIEdgeInsetsMake(kHeight*36/568, 0, 0, 0);
    self.tableAddressList.tableHeaderView = view;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.hidesBottomBarWhenPushed = YES;
    [self loadData];
}

- (void) loadData
{
    [addressService getAddressList];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)loadResponse:(NSString *) url response:(BaseModel *)response{
    if ([url isEqual:api_address_list]){
        AddressListResponse * respobj = (AddressListResponse *)response;
        addressList = respobj.data;
        
        if (addressList.count) {
            
            NSUInteger index = 0;
            for (Address *address in addressList) {
                
                if (address.isDefault) {
                    index = [addressList indexOfObject:address];
                }
            }
            [addressList exchangeObjectAtIndex:0 withObjectAtIndex:index];
        }
        [tableAddressList reloadData];
    } else if ([url isEqual:api_address_delete]){
        StatusResponse *respobj = (StatusResponse*)response;
        if (respobj.status.succeed == 1){
            [addressList removeObject:curOperaterAddress];
            [self.tableAddressList reloadData];
        }   
    } else if ([url isEqual:api_address_setdefault]){
        Status *status = (Status*)response;
        if (status.succeed == 1){
            for (Address *address in addressList){
                address.isDefault = false;
            }
            curOperaterAddress.isDefault = true;
            [self.tableAddressList reloadData];
        } else {
            [CommonUtils ToastNotification:status.error_desc andView:self.view andLoading:NO andIsBottom:NO];
        }
    } 
}

- (void) sendMessage:(NSIndexPath*)indexPath tag:(NSInteger)tag{
    curOperaterAddress = [addressList objectAtIndex:indexPath.section];
    NSString *address_id = [[NSString alloc] initWithFormat:@"%d", curOperaterAddress.id];
    if (tag == 1){
        //设为默认
        [addressService addressDefault:address_id];
    } else if (tag == 2){
        //编辑
        AddressController *addressController = [[AddressController alloc] init];
        addressController.mode = @"edit";
        addressController.editAddress = curOperaterAddress;
        [self.navigationController pushViewController:addressController animated:YES];
    } else if (tag == 3){
        
        // @"提示"
        NSString *addressList_alert_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"addressList_alert_title"];
        // @"确定删除?"
        NSString *addressList_alert_msg = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"addressList_alert_msg"];
        //删除
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:addressList_alert_title
                                                        message:addressList_alert_msg
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:@"取消", nil];
        [alert show];
    } else if (tag == 4){
        //选择地址
        NSArray *controllers = [self.navigationController viewControllers];
        OrderController *orderController = (OrderController*)[controllers objectAtIndex:controllers.count - 2];
        [orderController setReceiver:curOperaterAddress];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){
        NSString *address_id = [[NSString alloc] initWithFormat:@"%d", curOperaterAddress.id];
        [addressService addressDelete:address_id];
    }
}


- (IBAction)clickAddButtonAction:(id)sender {
    
    AddressController *addressController = [[AddressController alloc] init];
    addressController.mode = @"new";
    [self.navigationController pushViewController:addressController animated:YES];
    
}


#pragma TableView的处理


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return addressList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddressListCell"];
    if (!cell) {
        cell = [[AddressListCell alloc] initWithReuseIdentifier:@"AddressListCell"];
    }
    Address *address =[addressList objectAtIndex:[indexPath section]];
    
//    CGFloat height = [cell returnCellHeight:address];
    CGFloat height = [cell returnCellHeight:address isSelectAddress:self.isSelectAddress selectAddressId:self.selectAddressID];
    
//    CGFloat height = kHeight * 85/568;
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    AddressListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddressListCell"];
    if (!cell) {
        cell = [[AddressListCell alloc] initWithReuseIdentifier:@"AddressListCell"];
    }
    
    cell.msgDelegate = self;
    cell.indexPath = indexPath;
    Address *address =[addressList objectAtIndex:[indexPath section]];
    
    
//    [cell setAddress:address isSelectAddress:self.isSelectAddress];
    [cell setAddress:address isSelectAddress:self.isSelectAddress selectAddressId:self.selectAddressID];

    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isSelectAddress) {
        
        [self sendMessage:indexPath tag:4];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleNormal) title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        curOperaterAddress = [addressList objectAtIndex:indexPath.section];
        // @"提示"
        NSString *addressList_alert_title = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"addressList_alert_title"];
        // @"确定删除?"
        NSString *addressList_alert_msg = [[TextDataBase shareTextDataBase] searchTextStrByModelPath:@"addressList_alert_msg"];
        //删除
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:addressList_alert_title
                                                        message:addressList_alert_msg
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:@"取消", nil];
        [alert show];
        
    }];
    deleteAction.backgroundColor = redColorSelf;
    return @[deleteAction];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView * lightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TMScreenW *320/320, TMScreenH *8/568)];
    lightView.backgroundColor = groupTableViewBackgroundColorSelf;
    
    return lightView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return TMScreenH *8/568;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    return 0.1;
}

@end
