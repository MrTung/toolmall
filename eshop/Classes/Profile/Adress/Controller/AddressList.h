//
//  AddressList.h
//  eshop
//
//  Created by mc on 15/11/2.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressListResponse.h"
#import "AddressService.h"
#import "AddressListCell.h"
#import "Address.h"
#import "AddressController.h"

@interface AddressList : UIBaseController<UITableViewDelegate,UITableViewDataSource,MBProgressHUDDelegate, UITabBarControllerDelegate,UIAlertViewDelegate,AddressListCellDelegate, ServiceResponselDelegate>{
    NSMutableArray * addressList;
    AddressService * addressService;
    Address *curOperaterAddress;
}

@property (strong, nonatomic) IBOutlet UITableView *tableAddressList;
@property Boolean isSelectAddress;
@property (nonatomic, assign) int selectAddressID;

@end
