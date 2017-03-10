//
//  MyDeposit.h
//  eshop
//
//  Created by mc on 15/11/1.
//  Copyright © 2015年 hzlg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DepositService.h"
#import "DepositListResponse.h"
#import "AppDeposit.h"
#import "MyDepositCell.h"
#import "MyDepositHeader.h"
#import "PullTableView.h"
#import "PaymentPlugins.h"
#import "PaymentInfo.h"


@interface MyDeposit : UIViewController<UITableViewDelegate,UITableViewDataSource,PullTableViewDelegate,MBProgressHUDDelegate,UIAlertViewDelegate>{
    MyDepositHeader * myDepositHeader;
    NSMutableArray * deposits;
    DepositService * depositService;
    Pagination * pagination;

}
@property (strong, nonatomic) IBOutlet PullTableView *tableDeposits;
@property (nonatomic) IBOutlet UILabel *lbBalance;
@property (nonatomic) IBOutlet UITextField *txtChargeAmt;
@property (nonatomic) IBOutlet UIView *btmView;

@end
